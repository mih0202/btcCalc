﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Content.aspx.cs" Inherits="BitcoinCalc.Items.Content" %>
<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContainer" runat="server">
    <style>
      #output video {
        width: 100%;
      }
      #progressBar {
          height: 5px;
          width: 0%;
          background-color: #35b44f;
          transition: width .4s ease-in-out;
      }
      body.is-seed .show-seed {
          display: inline;
      }
      body.is-seed .show-leech {
          display: none;
      }
      .show-seed {
          display: none;
      }
      #status code {
          font-size: 90%;
          font-weight: 700;
          margin-left: 3px;
          margin-right: 3px;
          border-bottom: 1px dashed rgba(255,255,255,0.3);
      }

      .is-seed #hero {
          background-color: #154820;
          transition: .5s .5s background-color ease-in-out;
      }
      #hero {
          background-color: #2a3749;
      }
      #status {
          color: #fff;
          font-size: 17px;
          padding: 5px;
      }
      a:link, a:visited {
          color: #30a247;
          text-decoration: none;
      }
    </style>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div id="hero">
      <div id="output">
        <div id="progressBar"></div>
        <!-- The video player will be added here -->
      </div>
      <!-- Statistics -->
      <div id="status">
        <div>
          <span class="show-leech">Downloading </span>
          <span class="show-seed">Seeding </span>
          <code>
            <!-- Informative link to the torrent file -->
            <a id="torrentLink" href="https://webtorrent.io/torrents/sintel.torrent">sintel.torrent</a>
          </code>
          <span class="show-leech"> from </span>
          <span class="show-seed"> to </span>
          <code id="numPeers">0 peers</code>.
        </div>
        <div>
          <code id="downloaded"></code>
          of <code id="total"></code>
          — <span id="remaining"></span><br/>
          &#x2198;<code id="downloadSpeed">0 b/s</code>
          / &#x2197;<code id="uploadSpeed">0 b/s</code>
        </div>
      </div>
    </div>
    <script>
      var torrentId = 'https://webtorrent.io/torrents/sintel.torrent'
        //var torrentId = 'https://metaphoric-odds.000webhostapp.com/123.torrent';
        var client = new WebTorrent()

      // HTML elements
      var $body = document.body
      var $progressBar = document.querySelector('#progressBar')
      var $numPeers = document.querySelector('#numPeers')
      var $downloaded = document.querySelector('#downloaded')
      var $total = document.querySelector('#total')
      var $remaining = document.querySelector('#remaining')
      var $uploadSpeed = document.querySelector('#uploadSpeed')
      var $downloadSpeed = document.querySelector('#downloadSpeed')

      // Download the torrent
      client.add(torrentId, function (torrent) {

        // Torrents can contain many files. Let's use the .mp4 file
        //var file = torrent.files.find(function (file) {
        //  return file.name.endsWith('.mp4')
          //})
          console.log(torrent.files);
        var file = torrent.files[5];
        // Stream the file in the browser
        file.appendTo('#output')

        // Trigger statistics refresh
        torrent.on('done', onDone)
        setInterval(onProgress, 500)
        onProgress()

        // Statistics
        function onProgress () {
          // Peers
          $numPeers.innerHTML = torrent.numPeers + (torrent.numPeers === 1 ? ' peer' : ' peers')

          // Progress
          var percent = Math.round(torrent.progress * 100 * 100) / 100
          $progressBar.style.width = percent + '%'
          $downloaded.innerHTML = prettyBytes(torrent.downloaded)
          $total.innerHTML = prettyBytes(torrent.length)

          // Remaining time
          var remaining
          if (torrent.done) {
            remaining = 'Done.'
          } else {
            remaining = moment.duration(torrent.timeRemaining / 1000, 'seconds').humanize()
            remaining = remaining[0].toUpperCase() + remaining.substring(1) + ' remaining.'
          }
          $remaining.innerHTML = remaining

          // Speed rates
          $downloadSpeed.innerHTML = prettyBytes(torrent.downloadSpeed) + '/s'
          $uploadSpeed.innerHTML = prettyBytes(torrent.uploadSpeed) + '/s'
        }
        function onDone () {
          $body.className += ' is-seed'
          onProgress()
        }
      })

      // Human readable bytes util
      function prettyBytes(num) {
        var exponent, unit, neg = num < 0, units = ['B', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
        if (neg) num = -num
        if (num < 1) return (neg ? '-' : '') + num + ' B'
        exponent = Math.min(Math.floor(Math.log(num) / Math.log(1000)), units.length - 1)
        num = Number((num / Math.pow(1000, exponent)).toFixed(2))
        unit = units[exponent]
        return (neg ? '-' : '') + num + ' ' + unit
      }
    </script>
</asp:Content>