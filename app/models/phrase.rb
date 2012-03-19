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
					if 
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


	end
end
