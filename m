Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BA41E98EB
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgEaQjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41091 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728206AbgEaQjf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rjbH7teVMtjBh+T5ufCfzeY9CyBEBHGmfbosO+YUVTM=;
        b=WQtlWz83FaR6CsbyUIwFSH/qgqVmmwvJQTTx2w64rD3xoTy8PKGninJGCFE/3o+erS47dj
        JhdJbhOJ7h4xohxPB7C37ludFkvyQCATEXurK+QvrfB2tiTiqbhMRy0CdtDmmyaJoZuZA+
        YVEWBA9Corv5k0qM3DYRrz/C4oZ4beU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-j1wgaqkoMzKki47TsePASg-1; Sun, 31 May 2020 12:39:32 -0400
X-MC-Unique: j1wgaqkoMzKki47TsePASg-1
Received: by mail-wm1-f72.google.com with SMTP id x6so1913227wmj.9
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rjbH7teVMtjBh+T5ufCfzeY9CyBEBHGmfbosO+YUVTM=;
        b=i8KEJeBQTIIZwh87QwrODbuJmDE+zMcVaMBXVnNLYJU7+tuW2sStC/1wNwNe/ar9rI
         8YvS+pTucvMpjf42rH9LQV7YYRFSFfUswjeKo5vraEhLu4wywSNsozjdizf9dx0cfp1C
         xWS9ogG/9Z8zzqx+8BJ4ciS+4ZNnVLnGvivGsADN3b0B605TKQuVMYg+5wHTv4pdJqZE
         /5ftXGLdZP5aQY0mU8sBFR5rmRXmKJRACwrzODkoxCGw74cJL4grBJOdDcxpzAshw6Oc
         sb1GGsCnmp0Z3tsE/SqW0zT7v2W8eL5eVpDgoI9K3aMmX4kARSq0n4XTQ+x1aK045w3F
         GsKA==
X-Gm-Message-State: AOAM530hoFu20ZfMzS64McvFOdDdCxDCHwgmTOHIFtB9goOVDDN3W31j
        Tz0gKxqnRmm55/ZierfIhiPzgD+RpMZAGfre5OgtBFhdzE7MziU6n5orwcIMqcfoHBEhunwTY+Y
        p5S0A4/Af9BtL
X-Received: by 2002:a5d:5112:: with SMTP id s18mr17632624wrt.160.1590943170817;
        Sun, 31 May 2020 09:39:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxviLkgXrjUX2NcNJC5mie2lsvP1IrSShLdDDtm64dQg0NFzJSb44/ioBt+ym943Nm0qZ2SIA==
X-Received: by 2002:a5d:5112:: with SMTP id s18mr17632616wrt.160.1590943170658;
        Sun, 31 May 2020 09:39:30 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id k26sm9409518wmi.27.2020.05.31.09.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:30 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cleber Rosa <crosa@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
Subject: [PULL 08/25] python/qemu/machine: add kill() method
Date:   Sun, 31 May 2020 18:38:29 +0200
Message-Id: <20200531163846.25363-9-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200531163846.25363-1-philmd@redhat.com>
References: <20200531163846.25363-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>

Add method to hard-kill vm, without any quit commands.

Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Reviewed-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
Message-Id: <20200217150246.29180-19-vsementsov@virtuozzo.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 python/qemu/machine.py | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/python/qemu/machine.py b/python/qemu/machine.py
index b9a98e2c86..d2f531f1b4 100644
--- a/python/qemu/machine.py
+++ b/python/qemu/machine.py
@@ -342,7 +342,7 @@ def wait(self):
         self._load_io_log()
         self._post_shutdown()
 
-    def shutdown(self, has_quit=False):
+    def shutdown(self, has_quit=False, hard=False):
         """
         Terminate the VM and clean up
         """
@@ -354,7 +354,9 @@ def shutdown(self, has_quit=False):
             self._console_socket = None
 
         if self.is_running():
-            if self._qmp:
+            if hard:
+                self._popen.kill()
+            elif self._qmp:
                 try:
                     if not has_quit:
                         self._qmp.cmd('quit')
@@ -368,7 +370,8 @@ def shutdown(self, has_quit=False):
         self._post_shutdown()
 
         exitcode = self.exitcode()
-        if exitcode is not None and exitcode < 0:
+        if exitcode is not None and exitcode < 0 and \
+                not (exitcode == -9 and hard):
             msg = 'qemu received signal %i: %s'
             if self._qemu_full_args:
                 command = ' '.join(self._qemu_full_args)
@@ -378,6 +381,9 @@ def shutdown(self, has_quit=False):
 
         self._launched = False
 
+    def kill(self):
+        self.shutdown(hard=True)
+
     def set_qmp_monitor(self, enabled=True):
         """
         Set the QMP monitor.
-- 
2.21.3

