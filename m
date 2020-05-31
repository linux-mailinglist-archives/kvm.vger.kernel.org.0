Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BFA1E98F0
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbgEaQjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60672 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728294AbgEaQjx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T0yaQrYBR9fbxjrwWSMaG0y1Z8dADDvU+WXrcZtsKyw=;
        b=jU3vi5C1dmhd7aSiZLOpJ+XAGEQWOAqWFjctWXT+LFaieywiHqzMP7NuhvCuOEXMuYWM7O
        jh/KKsL89gmcQJlHVAVvkiorO34StzxrPoGi5n9agB/At9qC0bLF7SaXKFPkPHUt+dbc9g
        NoTBeTtrcO6iQ6FzyGERcJtEipy8KJY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-y8MhXQzYOcKvnaCnv3oNvQ-1; Sun, 31 May 2020 12:39:47 -0400
X-MC-Unique: y8MhXQzYOcKvnaCnv3oNvQ-1
Received: by mail-wm1-f70.google.com with SMTP id h25so174437wmb.0
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T0yaQrYBR9fbxjrwWSMaG0y1Z8dADDvU+WXrcZtsKyw=;
        b=GPoHQnel1dLUCZnOsqFx3Tj4r/mNRU/xvRRJ/hhx7FllSDAE9hn7jWntRISPQELNdZ
         J25pEdZAb92+3F2e7+FAOIssBsT3b4ZzSIzryr62+3SMrWc5yFuA0GYTgN8mdkOPybye
         mlTvzF1UONC5FRQJd+EIkibWljJ4UIX93BQgbfNI1ioG3brHftfpam0Lp/c6iWAvqj51
         1kyR6qsjazbzDfaqovA7FKgm0DFqLI4Utj73DSCy1bPaRUL/OmkZglWr8xx1ITqUUxL3
         v31Py4UWRCsNGBh7hA4jZ/2s8gMo60MjEpE1evYaU8qmmTXs1NeoXqpU49wI/sNLFtdB
         SZvQ==
X-Gm-Message-State: AOAM533N0RvOvp037WQlnnll1MH1yVhsZsVMEjTU+/XViWck9e+BqYX4
        nMoq+PvmCxtOrJNMlJ9IJV4QVeZYhJFl+dtatVgCNy7xzf52vrZAhkWBoCqupiijDhVqJvSBrec
        0AXUWQZR1OnPe
X-Received: by 2002:adf:e692:: with SMTP id r18mr17215581wrm.192.1590943186010;
        Sun, 31 May 2020 09:39:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyzme/eJkzFKriVfDnwFDZTFh5KmHq5g1d6NkwyrSeOmFMs12wVIIfxqx+l/LdP8rud9JxpA==
X-Received: by 2002:adf:e692:: with SMTP id r18mr17215570wrm.192.1590943185775;
        Sun, 31 May 2020 09:39:45 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id h15sm17067658wrt.73.2020.05.31.09.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:45 -0700 (PDT)
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
Subject: [PULL 11/25] python/qemu: delint; add flake8 config
Date:   Sun, 31 May 2020 18:38:32 +0200
Message-Id: <20200531163846.25363-12-philmd@redhat.com>
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

Mostly, ignore the "no bare except" rule, because flake8 is not
contextual and cannot determine if we re-raise. Pylint can, though, so
always prefer pylint for that.

Signed-off-by: John Snow <jsnow@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200528222129.23826-5-jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 python/qemu/.flake8    |  2 ++
 python/qemu/accel.py   |  9 ++++++---
 python/qemu/machine.py | 13 +++++++++----
 python/qemu/qmp.py     |  4 ++--
 4 files changed, 19 insertions(+), 9 deletions(-)
 create mode 100644 python/qemu/.flake8

diff --git a/python/qemu/.flake8 b/python/qemu/.flake8
new file mode 100644
index 0000000000..45d8146f3f
--- /dev/null
+++ b/python/qemu/.flake8
@@ -0,0 +1,2 @@
+[flake8]
+extend-ignore = E722  # Pylint handles this, but smarter.
\ No newline at end of file
diff --git a/python/qemu/accel.py b/python/qemu/accel.py
index 36ae85791e..7fabe62920 100644
--- a/python/qemu/accel.py
+++ b/python/qemu/accel.py
@@ -23,11 +23,12 @@
 # Mapping host architecture to any additional architectures it can
 # support which often includes its 32 bit cousin.
 ADDITIONAL_ARCHES = {
-    "x86_64" : "i386",
-    "aarch64" : "armhf",
-    "ppc64le" : "ppc64",
+    "x86_64": "i386",
+    "aarch64": "armhf",
+    "ppc64le": "ppc64",
 }
 
+
 def list_accel(qemu_bin):
     """
     List accelerators enabled in the QEMU binary.
@@ -47,6 +48,7 @@ def list_accel(qemu_bin):
     # Skip the first line which is the header.
     return [acc.strip() for acc in out.splitlines()[1:]]
 
+
 def kvm_available(target_arch=None, qemu_bin=None):
     """
     Check if KVM is available using the following heuristic:
@@ -69,6 +71,7 @@ def kvm_available(target_arch=None, qemu_bin=None):
         return False
     return True
 
+
 def tcg_available(qemu_bin):
     """
     Check if TCG is available.
diff --git a/python/qemu/machine.py b/python/qemu/machine.py
index 8e4ecd1837..187790ce9e 100644
--- a/python/qemu/machine.py
+++ b/python/qemu/machine.py
@@ -29,6 +29,7 @@
 
 LOG = logging.getLogger(__name__)
 
+
 class QEMUMachineError(Exception):
     """
     Exception called when an error in QEMUMachine happens.
@@ -62,7 +63,8 @@ class QEMUMachine:
     """
     A QEMU VM
 
-    Use this object as a context manager to ensure the QEMU process terminates::
+    Use this object as a context manager to ensure
+    the QEMU process terminates::
 
         with VM(binary) as vm:
             ...
@@ -185,8 +187,10 @@ def send_fd_scm(self, fd=None, file_path=None):
             fd_param.append(str(fd))
 
         devnull = open(os.path.devnull, 'rb')
-        proc = subprocess.Popen(fd_param, stdin=devnull, stdout=subprocess.PIPE,
-                                stderr=subprocess.STDOUT, close_fds=False)
+        proc = subprocess.Popen(
+            fd_param, stdin=devnull, stdout=subprocess.PIPE,
+            stderr=subprocess.STDOUT, close_fds=False
+        )
         output = proc.communicate()[0]
         if output:
             LOG.debug(output)
@@ -485,7 +489,8 @@ def event_wait(self, name, timeout=60.0, match=None):
 
     def events_wait(self, events, timeout=60.0):
         """
-        events_wait waits for and returns a named event from QMP with a timeout.
+        events_wait waits for and returns a named event
+        from QMP with a timeout.
 
         events: a sequence of (name, match_criteria) tuples.
                 The match criteria are optional and may be None.
diff --git a/python/qemu/qmp.py b/python/qemu/qmp.py
index d6c9b2f4b1..6ae7693965 100644
--- a/python/qemu/qmp.py
+++ b/python/qemu/qmp.py
@@ -168,8 +168,8 @@ def accept(self, timeout=15.0):
 
         @param timeout: timeout in seconds (nonnegative float number, or
                         None). The value passed will set the behavior of the
-                        underneath QMP socket as described in [1]. Default value
-                        is set to 15.0.
+                        underneath QMP socket as described in [1].
+                        Default value is set to 15.0.
         @return QMP greeting dict
         @raise OSError on socket connection errors
         @raise QMPConnectError if the greeting is not received
-- 
2.21.3

