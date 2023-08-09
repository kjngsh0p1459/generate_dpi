sync:
	@melos bootstrap
	@melos run l10n
	@melos run force_build_all