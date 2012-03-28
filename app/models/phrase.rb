#encoding: utf-8


require 'google_spreadsheet'


class Phrase < ActiveRecord::Base

	SRC_ROW = 2
	SRC_COL = 1

	DEST_ROW = 5

	@@session = GoogleSpreadsheet.login("id", "password")

	# First worksheet of http://spreadsheets.google.com/ccc?key=pz7XtlQC-PYx-jrVMJErTcg&hl=en
	@@ws = @@session.spreadsheet_by_key("0AhHNBodQU76_dDQzMmJMX3JaZnM2T0hDV2VaeU9zdVE").worksheets[0]

	#현호야 너한테 맡김

	validates :input, :presence => true
	validates :output, :presence => true

	def self.deshift(str)
		res = ""
		str.chars.each do |c|
#			print c
#			c.bytes.each do |b|
#				print b.to_s(16)
#				if c.count == 1 then
#					return str
#				end
#			end
        c = shiftchar(c)
		end
		return str
	end


	def self.kind(char)
		char.bytes.each do |b|
			case char.bytes.count
			when 3 then
				return "한글"
			when 2 then
				return "모름"
			when 1 then
				if (b >= 0x21 && b <= 0x2f) || (b >= 0x3a && b <= 0x40) || (b >= 0x5b && b <= 0x60 ) || (b >= 0x7b && b<= 0x7e) then
					if b == 0x22 then
						return "큰따옴표"
					end
					if b >= 0x21 && b <= 0x2f then
						return "일반특수문자"
					end
					if b then
						return "특수문자"
					else 
						if (b > 0x2f && b < 0x3a) then 
							return "숫자"
						else 
							if (b > 0x60 && b < 0x7b) then
								return "소문자"
							else 
								if (b > 0x40 && b < 0x5a) then
									return "대문자"
								end
							end
						end
					end
				end
			end
		end
	end


	def self.shiftchar(char)
		case kind(char)
		when "한글" then
		    char.bytes.each do |b|
		      if (b == 0x1101 || b == 0x1104 || b == 0x1108 || b ==0x110A || b == 0x110D) then
		          b = b - 0x1
		      end
		      if (b == 0x1164 || b == 0x1168) then
		          b = b - 0x2
		      end
		    end
			return char
		when "모름" then
			return char
		when "일반특수문자" then
            if char == 0x26 then
              char == 0x37
              return char
            end
		    if char == 0x2B then
		      char = 0x3D
		      return char
		    end
            if char == 0x2A then
              char == 0x38
              return char
            end
            if (char >= 0x21 && char <= 0x25) then
              char == char + 0x10
              return char
            end
            if (char == 0x28) then
              char == 0x30
              return char
            end
            if char == 0x29 then
              char == 0x39
              return char
            end
		when "특수문자" then
            if char == 0x40 then
              char == 0x32
              return char
            end
            if char == 0x5E then
              char == 0x36
              return char
            end
		    if char == 0x3C then
		      char = 0x2C
		      return char
		    end
		    if char == 0x3E then
		      char = 0x2E
		      return char
		    end
		    if char == 0x3F then
		      char = 0x2F
		      return char
		    end
		    if char == 0x3A then
		      char = char + 0x1
		      return char
		    end
		    if (char >= 0x7B && char <= 0x7D) then
		      char = char - 0x20
		      return char
		    end
		    if char == 0x5F then
		      char = 0x2D
		      return char
		    end
			return char
		when "큰따옴표" then
		    return 0x27
		when "숫자" then
			return char
		when "소문자" then
			return char.upcase
		when "대문자" then
			return char + 0x20
		end
	end


	# 이 위는 쉬프트키 빼고 넣는거고 이 아래는 왈도체 여기는 내가

	def self.waldorize(str)

		str = containSpecial(str)

		str = swapTargetEnd(str)

		return str
	end


	def self.inspectword(str)
		str = str.chomp

		strtype = case str.chars.to_a.last
				  when ".", "다", "함", "음", "거" then
					  return "평서문 어미"
				  when "?", "까", "래", "거" then
					  return "의문문 어미"
				  when "한", "쁜", "운", "린", "은" then
					  return "형용사"
				  when "의" then
					  return "소유격 조사"
				  when "은", "는", "이", "가" then
					  return "주격 조사"
				  when "을", "를" then
					  return "목적격 조사"
				  when "에", "로" then
					  return "목적격 조사2"
				  when "게", "리", "히" then
					  return "부사"
				  end

		return strtype
	end

	def self.swapTargetEnd(str)
		strenum = str.split(" ")

		target = nil
		strend = nil
		index = 0
		strenum.each do |s|
			if inspectword(s) == "목적격 조사" || inspectword(s) == "목적격 조사2" then
				target = [s, index]
			end

			if inspectword(s) == "평서문 어미" || inspectword(s) == "의문문 어미" then
				strend = [s, index]

			end
			index += 1
		end

		if target && strend then

			strend[0] = powerfulEnd(strend[0])

			strenum[target.last] = strend[0]
			strenum[strend.last] = target[0]


			return strenum.join(" ")
		else
			return str
		end

	end

	def self.analyzeEnd(str)
		chars = str.chars.to_a

		length = chars.count

		case chars.last
		when "?", ".", "!", "~" then
			length -= 1
		end

		lastOne, lastTwo, lastThree = nil

		if length > 2 then
			lastThree = chars[length - 3] + chars[length - 2] + chars[length - 1]
			lastTwo = chars[length - 2] + chars[length - 1]
			lastOne = chars[length - 1]		
		else 
			if length > 1 then
				lastTwo = chars[length - 2] + chars[length - 1]
				lastOne = chars[length - 1]
			else
				lastOne = chars[length - 1]
			end
		end

		return [lastThree, lastTwo, lastOne]
	end

	def self.powerfulEnd(str)

		last123 = analyzeEnd(str)
		if last123[0] then
			case last123[0]
			when "하였다" then
				return "했다."
			end
		else 
=begin
	if last123[1] then
				case last123[1]

				end
			else 
				if last123 then
					case last123[2]
					end
				end
			end 
=end
		end

		return str
	end

	def self.containSpecial(str)
		str = str.sub("으아아아", "호옹이")
		str = str.sub("안준형", "짱 천재")
		str = str.sub("준형", "천재")
		str = str.sub("제작자", "준형님")
		str = str.sub("정원영", "http://rkdrnf.snucse.org/jwyeong")
		str = str.sub("박준상", "http://rkdrnf.snucse.org/junsangs")
		str = str.sub("정현호", "그냥 똑똑")
		str = str.sub("학교가자", "휴학하자")
	end

	def self.waldorize2(input_str)
		
		# call my script from spreadsheet
		@@ws[SRC_ROW,SRC_COL] = '=GoogleTranslate("' + input_str + '", "ko", "en")'
		@@ws.save()

		@@ws.reload()
		transAgain(@@ws, SRC_ROW, SRC_COL)
	end
	

	def self.transAgain(ws, row, col)
		
		str_src = ws[row, col]

		str_arr = str_src.split(' ')

		cell_len = str_arr.length

		str_arr.each_with_index do |s, i|
			ws[DEST_ROW, i + 1] = '=GoogleTranslate(' + '"' + s + '"' + ', "en", "ko")'
		end

		ws.save()
		ws.reload()

		str_mer_arr = []

		for i in 1..cell_len do 
			str_mer_arr << ws[DEST_ROW,i]
		end

		return str_mer_arr.join(' ');
	end
end
