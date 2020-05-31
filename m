Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B840A1E98F1
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgEaQj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49634 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728341AbgEaQj4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:39:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7aysy7LnzzU/PowJNv/vyjVqjvAz/h8eLbGuZ+OSeO4=;
        b=JcPpYnCKTC9+VWDxGaupqHCriVeKb5/Oa0DNOWze9O2JLOiW59sUidonVSdYemEWVHwvLi
        Hv2fE8I/Raexc9m5TNx/2M5H/TfizMXI6yTDwwhibfy+vNsw28ZnfJVP83rqc0aImsoFI5
        CCXFIu+HYwhTkRdksmHUkaHhXdwCm/k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-3Qkw9K5uNJy3iDlkNjR_Ig-1; Sun, 31 May 2020 12:39:52 -0400
X-MC-Unique: 3Qkw9K5uNJy3iDlkNjR_Ig-1
Received: by mail-wr1-f71.google.com with SMTP id j16so3578968wre.22
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7aysy7LnzzU/PowJNv/vyjVqjvAz/h8eLbGuZ+OSeO4=;
        b=C2RO31AmsdbTMPrLIFSamHwLtgII5pcbRYwemwkg/awyokYDYe7/KFAvfLylGouDtU
         6Z/joCLm4sR3C2c0ZRTddblpDNknDAUMUsfYBNCMWAqUISjGH1u36azcT9/csDuUu+Wm
         qVC5zH7kkcUTkIcQDmiZBN95Q9LFLgVjP3c9PKiPw8BtoVFK86v22bAuyVgt1XER+uWi
         3gxySuuWku2iiqgpjnrshkne09ronGHCv+HMWJZExa455dBXU921VXN2SrZmY+jOaYtb
         Se3r4LenAEp1M/YXEjbbwSI5yCfv6W3zo3DPUmKknI1kML/bKg05RqmhEw5bTG7cQjgB
         kaVQ==
X-Gm-Message-State: AOAM533wSiizmPdEaw+2C/bbjJEQz3JMAyQpzpPt5PJAVrI91Kd9YqFd
        7UFILQ6G3L4WWZZrkD1XSzkdVn2aXFEgovMENU8l3aFcO9C7w8ArPhCOsKCWxSVQkF6N0uObYOM
        ALY8tEt9JjuU8
X-Received: by 2002:a7b:cae2:: with SMTP id t2mr18047629wml.150.1590943190882;
        Sun, 31 May 2020 09:39:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyk81obw3iwl5cmks4QKQu+FzG80vqvlMOpxZsa5rTowYPRYxGfXszL5E/IQCa/DUJwBl8aug==
X-Received: by 2002:a7b:cae2:: with SMTP id t2mr18047608wml.150.1590943190702;
        Sun, 31 May 2020 09:39:50 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id q1sm5415572wmc.15.2020.05.31.09.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:50 -0700 (PDT)
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
Subject: [PULL 12/25] python/qemu: remove Python2 style super() calls
Date:   Sun, 31 May 2020 18:38:33 +0200
Message-Id: <20200531163846.25363-13-philmd@redhat.com>
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

Use the Python3 style instead.

Signed-off-by: John Snow <jsnow@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200514055403.18902-12-jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 python/qemu/machine.py |  2 +-
 python/qemu/qtest.py   | 15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/python/qemu/machine.py b/python/qemu/machine.py
index 187790ce9e..95a20a17f9 100644
--- a/python/qemu/machine.py
+++ b/python/qemu/machine.py
@@ -55,7 +55,7 @@ def __init__(self, reply):
             desc = reply["error"]["desc"]
         except KeyError:
             desc = reply
-        super(MonitorResponseError, self).__init__(desc)
+        super().__init__(desc)
         self.reply = reply
 
 
diff --git a/python/qemu/qtest.py b/python/qemu/qtest.py
index 53d814c064..7943487c2b 100644
--- a/python/qemu/qtest.py
+++ b/python/qemu/qtest.py
@@ -101,29 +101,28 @@ def __init__(self, binary, args=None, name=None, test_dir="/var/tmp",
             name = "qemu-%d" % os.getpid()
         if sock_dir is None:
             sock_dir = test_dir
-        super(QEMUQtestMachine,
-              self).__init__(binary, args, name=name, test_dir=test_dir,
-                             socket_scm_helper=socket_scm_helper,
-                             sock_dir=sock_dir)
+        super().__init__(binary, args, name=name, test_dir=test_dir,
+                         socket_scm_helper=socket_scm_helper,
+                         sock_dir=sock_dir)
         self._qtest = None
         self._qtest_path = os.path.join(sock_dir, name + "-qtest.sock")
 
     def _base_args(self):
-        args = super(QEMUQtestMachine, self)._base_args()
+        args = super()._base_args()
         args.extend(['-qtest', 'unix:path=' + self._qtest_path,
                      '-accel', 'qtest'])
         return args
 
     def _pre_launch(self):
-        super(QEMUQtestMachine, self)._pre_launch()
+        super()._pre_launch()
         self._qtest = QEMUQtestProtocol(self._qtest_path, server=True)
 
     def _post_launch(self):
-        super(QEMUQtestMachine, self)._post_launch()
+        super()._post_launch()
         self._qtest.accept()
 
     def _post_shutdown(self):
-        super(QEMUQtestMachine, self)._post_shutdown()
+        super()._post_shutdown()
         self._remove_if_exists(self._qtest_path)
 
     def qtest(self, cmd):
-- 
2.21.3

