.DEFAULT_GOAL := explain
.PHONY: explain
explain:
	### Dialogflow Terraform
	#
	#
	#  DDDDDDDDDDDDD          iiii                    lllllll                                         ffffffffffffffff  lllllll
	#   D::::::::::::DDD      i::::i                   l:::::l                                        f::::::::::::::::f l:::::l
	#   D:::::::::::::::DD     iiii                    l:::::l                                       f::::::::::::::::::fl:::::l
	#   DDD:::::DDDDD:::::D                            l:::::l                                       f::::::fffffff:::::fl:::::l
	#     D:::::D    D:::::D iiiiiii   aaaaaaaaaaaaa    l::::l    ooooooooooo      ggggggggg   ggggg f:::::f       ffffff l::::l    ooooooooooo wwwwwww           wwwww           wwwwwww
	#     D:::::D     D:::::Di:::::i   a::::::::::::a   l::::l  oo:::::::::::oo   g:::::::::ggg::::g f:::::f              l::::l  oo:::::::::::oow:::::w         w:::::w         w:::::w
	#     D:::::D     D:::::D i::::i   aaaaaaaaa:::::a  l::::l o:::::::::::::::o g:::::::::::::::::gf:::::::ffffff        l::::l o:::::::::::::::ow:::::w       w:::::::w       w:::::w
	#     D:::::D     D:::::D i::::i            a::::a  l::::l o:::::ooooo:::::og::::::ggggg::::::ggf::::::::::::f        l::::l o:::::ooooo:::::o w:::::w     w:::::::::w     w:::::w
	#     D:::::D     D:::::D i::::i     aaaaaaa:::::a  l::::l o::::o     o::::og:::::g     g:::::g f::::::::::::f        l::::l o::::o     o::::o  w:::::w   w:::::w:::::w   w:::::w
	#     D:::::D     D:::::D i::::i   aa::::::::::::a  l::::l o::::o     o::::og:::::g     g:::::g f:::::::ffffff        l::::l o::::o     o::::o   w:::::w w:::::w w:::::w w:::::w
	#     D:::::D     D:::::D i::::i  a::::aaaa::::::a  l::::l o::::o     o::::og:::::g     g:::::g  f:::::f              l::::l o::::o     o::::o    w:::::w:::::w   w:::::w:::::w
	#     D:::::D    D:::::D  i::::i a::::a    a:::::a  l::::l o::::o     o::::og::::::g    g:::::g  f:::::f              l::::l o::::o     o::::o     w:::::::::w     w:::::::::w
	#   DDD:::::DDDDD:::::D  i::::::ia::::a    a:::::a l::::::lo:::::ooooo:::::og:::::::ggggg:::::g f:::::::f            l::::::lo:::::ooooo:::::o      w:::::::w       w:::::::w
	#   D:::::::::::::::DD   i::::::ia:::::aaaa::::::a l::::::lo:::::::::::::::o g::::::::::::::::g f:::::::f            l::::::lo:::::::::::::::o       w:::::w         w:::::w
	#   D::::::::::::DDD     i::::::i a::::::::::aa:::al::::::l oo:::::::::::oo   gg::::::::::::::g f:::::::f            l::::::l oo:::::::::::oo         w:::w           w:::w
	#   DDDDDDDDDDDDD        iiiiiiii  aaaaaaaaaa  aaaallllllll   ooooooooooo       gggggggg::::::g fffffffff            llllllll   ooooooooooo            www             www
	#                                                                                    g:::::g
	#                                                                        gggggg      g:::::g
	#                                                                        g:::::gg   gg:::::g
	#                                                                         g::::::ggg:::::::g
	#                                                                          gg:::::::::::::g
	#                                                                            ggg::::::ggg
	#                                                                               gggggg
	### Installation
	#
	# $$ make install
	#
	### Targets
	#
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Clean the local filesystem for all the automated items
	rm -fr application/node_modules
	git clean -fX || true

.PHONY: install
install: ## Install all the dependencies we need
	@echo "Getting NPM packages"
	cd application && npm install && cd ..
	cd infrastructure && terraform init && cd ..

.PHONY: deploy
deploy: ## Deploy everything
	@echo "Zipping the Platform files"
	cd ./platform/chatbot && \
		zip -r main.zip ./
	@echo "Building the application"
	cd ./application && \
	npm run build
	@echo "Calling Terraform Apply"
	cd ./infrastructure && \
	terraform apply
	@echo "Uploading application build files"
	cd ./application/build && \
	gsutil cp -r ./ gs://dialogflow-website/

