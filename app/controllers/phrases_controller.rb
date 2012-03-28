class PhrasesController < ApplicationController

    def deshift
      input_text = params[:input_text]
      output_text = Phrase.deshift(input_text)

      render :json => {:success => true, :deshifted => output_text}
    end

	def waldorize
		begin
		input_text = params[:input_text]

		output_text = Phrase.waldorize2(input_text)

		render :json => {:success => true, :waldorized => output_text}

		rescue
			render :json => {:success => false, :error => "#{$!}"}
			return
		end
	end
end

