#encoding: utf-8
class Phrase < ActiveRecord::Base

	#현호야 너한테 맡김

	validates :input, :presence => true
	validates :output, :presence => true

	def self.deshift(str)
		res = ""
		str.chars.each do |c|
			print c
			c.bytes.each do |b|
				print b.to_s(16)
				if c.count == 1 then
					return str
				end
			end
		end
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
			return char
		when "모름" then
			return char
		when "특수문자" then
			return char
		when "숫자" then
			return char
		when "소문자" then
			return char.upcase
		when "대문자"then
			return char
		end
	end


	# 이 위는 쉬프트키 빼고 넣는거고 이 아래는 왈도체 여기는 내가

	def self.waldorize(str)

		str = swapTargetEnd(str)

		print str
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

		target = ""
		strend = ""
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

		strend[0] = powerfulEnd(strend[0])

		strenum[target.last] = strend[0]
		strenum[strend.last] = target[0]

		return strenum.join(" ")

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
		if str[0] then
			case str[0]
			when "하였다" then
				return "함!"
			when "주웠다" then
				return "주움!"
			when "싸웠다" then
			end
		else 
			if str[1] then
				case str[1]
				when "했다", "한다", "하다"
					return "함!"
				when "웠다" then
					return "움!"
				when "이다" then
					return "임!"
				when "오다", "온다", "왔다" then
					return "옴!"
				when "간다", "가다", "갔다" then
					return "감!"
				when "가라" then 				#명령어는 '라'로 끝나는 경우가 많다. 이때는 라를 삭제하고 느낌표를 넣으면 될까?
					return "가!"
				end
			else 
				if str[2] then
					case str[2]
					when "다" then
						return "음!"
					end
				end
			end
		end
	end
end
