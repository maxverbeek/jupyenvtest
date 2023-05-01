{ pkgs, ... }: {
  kernel.python = {
    minimal = { enable = true; };

    gfenv = {
      enable = true;
      # projectDir = ./graftfailure;
      extraPackages = ps:
        with ps; [
          jupyter
          ipython
          pandas
          matplotlib
          seaborn
          numpy
          scikitlearn
          xgboost
          joblib
          pyreadstat
        ];
    };
  };
}
