Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3B61E98EF
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgEaQjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43845 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728294AbgEaQjp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3OcgS+8uizQs2BB2jjqHl6ry4DnKvgwh0XUrC24oYQg=;
        b=M57Rtvdmf6nKV7BMsqTaicLK5Vx7zDeQ8vg2Pp95QsNgRnJoYT5IbBlexHFJv7pCvZ4rmI
        4IUsbLwm/xQT3b6AyaMNyvmnWIzpngFIn3WuLC/x/gJDSregzz9FXRS08dUy+tRnYh4p1e
        IcbV+oPRuBeXZqxBG8Y6L+MNpUa4SfY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-vBOM8gfZNzuPFI-5oFMnhQ-1; Sun, 31 May 2020 12:39:42 -0400
X-MC-Unique: vBOM8gfZNzuPFI-5oFMnhQ-1
Received: by mail-wr1-f71.google.com with SMTP id a4so3615049wrp.5
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OcgS+8uizQs2BB2jjqHl6ry4DnKvgwh0XUrC24oYQg=;
        b=SE4XNxKq78aI79jWpxaVRC+c7b03wnXOsA2X5o5HrC3RNPbfPhLWWtE+wT9Iniz0x9
         qCsBzGK9prPceBviJtRdNkt6qU4ZIZ5LW/Z0zT0WMW0ma1fQNJqJc4jiowA7+mR2bEM9
         dZRx3Oc7AbgBqPEGLfi4nFdh+XEpjy1+p8Ip12oXPFlB1acvIqUg0wb95Qp05mbIYFFW
         5M0cByTb2Mk6wdryKOkHsiZoBF/GS0CuUwFzno13W+8e3JzZR6UL5uk8sdV33ZpofrQo
         1k67lTnMi6D7KktBLKA0FdsN8JLvFGfzeGlXvvKzxy0aMUDW39aoIODgyJn1R82tjmib
         Ei/w==
X-Gm-Message-State: AOAM531zFirw5EmuXKzR9pJA9EcWMY13Y+YRPME9Ja3AzO01o+S0p4Xz
        GrI2SpkGVEIfPGRJLVE0bB/SrDJCus3InYJoWyE7faB/jiAORiRLtZb8xzUntI+j2Be50pr3CAM
        DD+CPiVzxqrz1
X-Received: by 2002:a1c:230a:: with SMTP id j10mr17544791wmj.124.1590943180766;
        Sun, 31 May 2020 09:39:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwjt9ib7xJBDUlj2i2d+LbU8yd4lrgg9+eyZSY61K4oGbjGUzzZ/w68ViV2DfDZ4MNSeL8Yw==
X-Received: by 2002:a1c:230a:: with SMTP id j10mr17544774wmj.124.1590943180526;
        Sun, 31 May 2020 09:39:40 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id 23sm8942553wmo.18.2020.05.31.09.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:40 -0700 (PDT)
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
        John Snow <jsnow@redhat.com>
Subject: [PULL 10/25] python/qemu: delint and add pylintrc
Date:   Sun, 31 May 2020 18:38:31 +0200
Message-Id: <20200531163846.25363-11-philmd@redhat.com>
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

From: John Snow <jsnow@redhat.com>

Bring our these files up to speed with pylint 2.5.0.
Add a pylintrc file to formalize which pylint subset
we are targeting.

The similarity ignore is there to suppress similarity
reports across imports, which for typing constants,
are going to trigger this report erroneously.

Signed-off-by: John Snow <jsnow@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200528222129.23826-4-jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 python/qemu/machine.py |  6 ++---
 python/qemu/pylintrc   | 58 ++++++++++++++++++++++++++++++++++++++++++
 python/qemu/qtest.py   | 42 +++++++++++++++++++-----------
 3 files changed, 88 insertions(+), 18 deletions(-)
 create mode 100644 python/qemu/pylintrc

diff --git a/python/qemu/machine.py b/python/qemu/machine.py
index 41554de533..8e4ecd1837 100644
--- a/python/qemu/machine.py
+++ b/python/qemu/machine.py
@@ -58,7 +58,7 @@ def __init__(self, reply):
         self.reply = reply
 
 
-class QEMUMachine(object):
+class QEMUMachine:
     """
     A QEMU VM
 
@@ -239,7 +239,7 @@ def _base_args(self):
                          'chardev=mon,mode=control'])
         if self._machine is not None:
             args.extend(['-machine', self._machine])
-        for i in range(self._console_index):
+        for _ in range(self._console_index):
             args.extend(['-serial', 'null'])
         if self._console_set:
             self._console_address = os.path.join(self._sock_dir,
@@ -374,7 +374,7 @@ def shutdown(self, has_quit=False, hard=False):
                 command = ' '.join(self._qemu_full_args)
             else:
                 command = ''
-            LOG.warning(msg, -exitcode, command)
+            LOG.warning(msg, -int(exitcode), command)
 
         self._launched = False
 
diff --git a/python/qemu/pylintrc b/python/qemu/pylintrc
new file mode 100644
index 0000000000..5d6ae7367d
--- /dev/null
+++ b/python/qemu/pylintrc
@@ -0,0 +1,58 @@
+[MASTER]
+
+[MESSAGES CONTROL]
+
+# Disable the message, report, category or checker with the given id(s). You
+# can either give multiple identifiers separated by comma (,) or put this
+# option multiple times (only on the command line, not in the configuration
+# file where it should appear only once). You can also use "--disable=all" to
+# disable everything first and then reenable specific checks. For example, if
+# you want to run only the similarities checker, you can use "--disable=all
+# --enable=similarities". If you want to run only the classes checker, but have
+# no Warning level messages displayed, use "--disable=all --enable=classes
+# --disable=W".
+disable=too-many-arguments,
+        too-many-instance-attributes,
+        too-many-public-methods,
+
+[REPORTS]
+
+[REFACTORING]
+
+[MISCELLANEOUS]
+
+[LOGGING]
+
+[BASIC]
+
+# Good variable names which should always be accepted, separated by a comma.
+good-names=i,
+           j,
+           k,
+           ex,
+           Run,
+           _,
+           fd,
+
+[VARIABLES]
+
+[STRING]
+
+[SPELLING]
+
+[FORMAT]
+
+[SIMILARITIES]
+
+# Ignore imports when computing similarities.
+ignore-imports=yes
+
+[TYPECHECK]
+
+[CLASSES]
+
+[IMPORTS]
+
+[DESIGN]
+
+[EXCEPTIONS]
diff --git a/python/qemu/qtest.py b/python/qemu/qtest.py
index d24ad04256..53d814c064 100644
--- a/python/qemu/qtest.py
+++ b/python/qemu/qtest.py
@@ -1,5 +1,11 @@
-# QEMU qtest library
-#
+"""
+QEMU qtest library
+
+qtest offers the QEMUQtestProtocol and QEMUQTestMachine classes, which
+offer a connection to QEMU's qtest protocol socket, and a qtest-enabled
+subclass of QEMUMachine, respectively.
+"""
+
 # Copyright (C) 2015 Red Hat Inc.
 #
 # Authors:
@@ -17,19 +23,21 @@
 from .machine import QEMUMachine
 
 
-class QEMUQtestProtocol(object):
-    def __init__(self, address, server=False):
-        """
-        Create a QEMUQtestProtocol object.
+class QEMUQtestProtocol:
+    """
+    QEMUQtestProtocol implements a connection to a qtest socket.
 
-        @param address: QEMU address, can be either a unix socket path (string)
-                        or a tuple in the form ( address, port ) for a TCP
-                        connection
-        @param server: server mode, listens on the socket (bool)
-        @raise socket.error on socket connection errors
-        @note No connection is established, this is done by the connect() or
-              accept() methods
-        """
+    :param address: QEMU address, can be either a unix socket path (string)
+                    or a tuple in the form ( address, port ) for a TCP
+                    connection
+    :param server: server mode, listens on the socket (bool)
+    :raise socket.error: on socket connection errors
+
+    .. note::
+       No conection is estabalished by __init__(), this is done
+       by the connect() or accept() methods.
+    """
+    def __init__(self, address, server=False):
         self._address = address
         self._sock = self._get_sock()
         self._sockfile = None
@@ -73,15 +81,19 @@ def cmd(self, qtest_cmd):
         return resp
 
     def close(self):
+        """Close this socket."""
         self._sock.close()
         self._sockfile.close()
 
     def settimeout(self, timeout):
+        """Set a timeout, in seconds."""
         self._sock.settimeout(timeout)
 
 
 class QEMUQtestMachine(QEMUMachine):
-    '''A QEMU VM'''
+    """
+    A QEMU VM, with a qtest socket available.
+    """
 
     def __init__(self, binary, args=None, name=None, test_dir="/var/tmp",
                  socket_scm_helper=None, sock_dir=None):
-- 
2.21.3

