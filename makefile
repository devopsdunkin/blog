deploy:
	printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"
	hugo -t paper
	cd public
	git add .
	msg="rebuilding site $(date)"
	git commit -m "$msg"
	git push origin master