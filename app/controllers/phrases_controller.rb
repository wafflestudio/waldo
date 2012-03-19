class PhrasesController < ApplicationController

	def waldorize
		begin
		input_text = params[:input_text]

		output_text = Phrase.waldorize(input_text)

		render :json => {:success => true, :waldorized => output_text}

		rescue
			render :json => {:success => false, :error => "#{$!}"}
			return
		end
	end
end

