import QtQuick 2.12
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import Morph.Web 0.1
import "UCSComponents"
import QtWebEngine 1.10
import Qt.labs.settings 1.0
//import QtSystemInfo 5.12
import "config.js" as Conf

MainView {
  id:window
  //
  // ScreenSaver {
  //   id: screenSaver
  //   screenSaverEnabled: !(Qt.application.active)
  // }

  objectName: "mainView"
  //theme.name: "Ubuntu.Components.Themes.SuruDark"
  backgroundColor: Conf.AppBackgroundColor
  applicationName: "webtoonsapp.ste-kal"
  property string title: Conf.AppTitle

  property string myTabletUrl: Conf.TabletUrl
  property string myMobileUrl: Conf.MobileUrl
  property string myTabletUA: Conf.TabletUA
  property string myMobileUA: Conf.MobileUA
  property string myTabletZoom: Conf.TabletZoom
  property string myMobileZoom: Conf.MobileZoom

  property string myUrl: (Screen.devicePixelRatio == 1.625) ? myTabletUrl : myMobileUrl
  property string myUA: (Screen.devicePixelRatio == 1.625) ? myTabletUA : myMobileUA
  property string myZoom: (Screen.devicePixelRatio == 1.625) ? myTabletZoom : myMobileZoom

  WebEngineView {
    id: webview
    anchors {
      fill: parent
    }
    //settings.localStorageEnabled: true
    //settings.allowFileAccessFromFileUrls: true
    //settings.allowUniversalAccessFromFileUrls: true
    //settings.appCacheEnabled: true
    settings.javascriptCanAccessClipboard: true
    settings.fullScreenSupportEnabled: true
    settings.showScrollBars: false
    property var currentWebview: webview
    settings.pluginsEnabled: true

/*     onFullScreenRequested: function(request) {
      mainview.fullScreenRequested(request.toggleOn);
      nav.visible = !nav.visible
      request.accept();
    } */
    property string test: writeToLog("DEBUG","my URL:", myUrl);
    property string test2: writeToLog("DEBUG","PixelRatio:", Screen.devicePixelRatio);
    property string test6: writeToLog("DEBUG","F: my Zoom:", myZoom);

    function writeToLog(mylevel,mytext, mymessage){
      console.log("["+mylevel+"]  "+mytext+" "+mymessage)
      return(true);
    }

    profile:  WebEngineProfile {
      id: webContext
      persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
      property alias dataPath: webContext.persistentStoragePath
      dataPath: dataLocation
      httpUserAgent: myUA
      httpCacheType: WebEngineProfile.NoCache
      offTheRecord: false
    }

    anchors {
      fill:parent
      centerIn: parent.verticalCenter
    }
    // Workaround for not correctly working zoom
    onLoadingChanged: {
      zoomFactor = myZoom
    }
    url: myUrl
    /*userScripts: [
      WebEngineScript {
        injectionPoint: WebEngineScript.DocumentCreation
        worldId: WebEngineScript.MainWorld
        name: "QWebChannel"
        sourceUrl: "ubuntutheme.js"
      }
    ]*/
  }

  RadialBottomEdge {
    id: nav
    visible: true
    actions: [
      RadialAction {
        id: home
        iconName: "home"
        onTriggered: {
          webview.url = myUrl+"en"
        }
        text: qsTr("Home")
      },
      RadialAction {
        id: reload
        iconName: "reload"
        onTriggered: {
          webview.reload()
        }
        text: qsTr("Reload")
      },
      RadialAction {
        id: login
        iconName: "contact"
        onTriggered: {
          webview.url = myUrl+"member/login?returnUrl=https%3A%2F%2Fm.webtoons.com%2Fen%2Fmore"
        }
        text: qsTr("login")
      },
      RadialAction {
        id: favorite
        iconName: "favorite-selected"
        onTriggered: {
          webview.url = myUrl+"favorite"
        }
        text: qsTr("My Favorites")
      },
      RadialAction {
        id: recent
        iconName: "browser-timeline"
        onTriggered: {
          webview.url = myUrl+"en/recent"
        }
        text: qsTr("Recent views")
      },
      RadialAction {
        id: genre
        iconName: "keypad"
        onTriggered: {
          webview.url = myUrl+"en/genre"
        }
        text: qsTr("Genre")
      },
      RadialAction {
        id: news
        iconName: "flash-on"
        onTriggered: {
          webview.url = myUrl+"en/new"
        }
        text: qsTr("New to Webtoon")
      },
      RadialAction {
        id: search
        iconName: "find"
        onTriggered: {
          webview.url = myUrl+"en/search"
        }
        text: qsTr("Search")
      },
      RadialAction {
        id: back
        enabled: webview.canGoBack
        iconName: "go-previous"
        onTriggered: {
          webview.goBack()
        }
        text: qsTr("Back")
      }
    ]
  }

  Connections {
    target: Qt.inputMethod
    onVisibleChanged: nav.visible = !nav.visible
  }
  Connections {
    target: webview

    onIsFullScreenChanged: {
      window.setFullscreen()
      if (currentWebview.isFullScreen) {
        nav.state = "hidden"
      }
      else {
        nav.state = "shown"
      }
    }

  }
  Connections {
    target: window.webview
    onIsFullScreenChanged: window.setFullscreen(window.webview.isFullScreen)
  }

  function setFullscreen(fullscreen) {
    if (!window.forceFullscreen) {
      if (fullscreen) {
        if (window.visibility != Window.FullScreen) {
          internal.currentWindowState = window.visibility
          window.visibility = 5
        }
      } else {
        window.visibility = internal.currentWindowState
      }
    }
  }
}
