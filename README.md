plack-phpmyadmin
================

PlackでphpMyAdminを動かすスクリプトです。

## PHPをインストール

PHPをインストールして下さい。

http://jp1.php.net/downloads.php


## phpMyAdminを設置

phpMyAdminを設置して下さい。

http://www.phpmyadmin.net/home_page/index.php


## Cartonをインストール

Cartonをインストールして下さい。

```
$ cpanm Carton
```

## clone

git cloneします。

```
$ git clone git@github.com:memememomo/plack-phpmyadmin.git
```

## 依存モジュールをインストール

依存モジュールをインストールします。

```
$ cd plack-phpmyadmin
$ carton install
```


## phpMyAdminへのPATHを設定

app.psgiをテキストエディタで開いて、
*$PHPMYADMIN* に、phpMyAdminへのPathを設定してください。

例えば以下のように。

```
$PHPMYADMIN = '/home/uchiko/phpmyadmin';
```


## 実行

実行は以下の様なコマンドになります。

```
$ carton exec -- plackup
```

ブラウザで「http://localhost:5000/」にアクセスすると、
phpMyAdminの画面が表示されます。

