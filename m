Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65891E98F3
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgEaQkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:40:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53414 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728341AbgEaQkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 May 2020 12:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ssulewpBrPPL8AloNMkgJXTsJOTpzeqWq+VA42pqYDs=;
        b=V/rmodckbutJp7Dlo3/4nSqSrnyN70VqcFMZEiRbOfxFTRVzNkuossR3JMkXLVU1hUXM7E
        si+64jqil2Zo93KBJ55SS+3s2y4sm51Odm7xwQPswW3DXjPoxJd9aUn+YrJfyMRSmiElcB
        kER+sB7KKM8GwOJu4B8n0hj2arJ/svw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-B0kiJPXUM0O3p9rN1_Q_Dw-1; Sun, 31 May 2020 12:40:02 -0400
X-MC-Unique: B0kiJPXUM0O3p9rN1_Q_Dw-1
Received: by mail-wr1-f70.google.com with SMTP id e1so3634817wrm.3
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:40:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ssulewpBrPPL8AloNMkgJXTsJOTpzeqWq+VA42pqYDs=;
        b=jv5GyCN0jNo+vr2XiFcz6kj+fCDn6U5004DSbwB323AKa8FwJ3KOKyDnvovaHAXHZJ
         h/eTFby7uAgTJLHAu2lkrTYlm145DYCskEhMfXo6eeWjLhpUH4YOzLTDNT7ECVfsu62I
         gpVHL6bkzGoxztT6eFx8oe7Pqt08ESOXSpG6slxRujtnprTa9Q4IZSxd/pccD6hTv3g+
         fzmvI7fcCBM6FeBH2Bh6zrXqoxuvBZmgFiObCB5QH0koxOFNmddd81AGOqSX5NLAER+3
         UJzUoj9FJbf/pbE+22jjwWdhovF8vNwffxAPnGEQTkhteZEL2+I15N23JlCMxrlIP+qr
         CLrw==
X-Gm-Message-State: AOAM531VZ6fCPVgwQwFIZnENSslyP4mjq4QOV9GsYgyl4k/SQmsSVVZk
        KEZzIdLZap4+NVmEyAB5Rs2g973lS9cTEEaprm2kwig/bRTjFnga1zAfbqjFdi9AqCZDDJha41u
        9gXpcBqG3oO39
X-Received: by 2002:a7b:c046:: with SMTP id u6mr17054024wmc.57.1590943201017;
        Sun, 31 May 2020 09:40:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIdvNLMI//OZsjdo+C0sjBhIjuTUkjfNnTxiKuC1ShLlJgATsXVMG+s/5lIguCBK7zduo/Bw==
X-Received: by 2002:a7b:c046:: with SMTP id u6mr17054012wmc.57.1590943200820;
        Sun, 31 May 2020 09:40:00 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id o9sm8676600wmh.37.2020.05.31.09.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:40:00 -0700 (PDT)
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
Subject: [PULL 14/25] python/qemu: Adjust traceback typing
Date:   Sun, 31 May 2020 18:38:35 +0200
Message-Id: <20200531163846.25363-15-philmd@redhat.com>
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

mypy considers it incorrect to use `bool` to statically return false,
because it will assume that it could conceivably return True, and gives
different analysis in that case. Use a None return to achieve the same
effect, but make mypy happy.

Note: Pylint considers function signatures as code that might trip the
duplicate-code checker. I'd rather not disable this as it does not
trigger often in practice, so I'm disabling it as a one-off and filed a
change request; see https://github.com/PyCQA/pylint/issues/3619

Signed-off-by: John Snow <jsnow@redhat.com>
Acked-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200514055403.18902-14-jsnow@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 python/qemu/machine.py |  8 ++++++--
 python/qemu/qmp.py     | 10 ++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/python/qemu/machine.py b/python/qemu/machine.py
index 95a20a17f9..041c615052 100644
--- a/python/qemu/machine.py
+++ b/python/qemu/machine.py
@@ -24,6 +24,8 @@
 import shutil
 import socket
 import tempfile
+from typing import Optional, Type
+from types import TracebackType
 
 from . import qmp
 
@@ -124,9 +126,11 @@ def __init__(self, binary, args=None, wrapper=None, name=None,
     def __enter__(self):
         return self
 
-    def __exit__(self, exc_type, exc_val, exc_tb):
+    def __exit__(self,
+                 exc_type: Optional[Type[BaseException]],
+                 exc_val: Optional[BaseException],
+                 exc_tb: Optional[TracebackType]) -> None:
         self.shutdown()
-        return False
 
     def add_monitor_null(self):
         """
diff --git a/python/qemu/qmp.py b/python/qemu/qmp.py
index 73d49050ed..b91c9d5c1c 100644
--- a/python/qemu/qmp.py
+++ b/python/qemu/qmp.py
@@ -14,7 +14,9 @@
 from typing import (
     Optional,
     TextIO,
+    Type,
 )
+from types import TracebackType
 
 
 class QMPError(Exception):
@@ -146,10 +148,14 @@ def __enter__(self):
         # Implement context manager enter function.
         return self
 
-    def __exit__(self, exc_type, exc_value, exc_traceback):
+    def __exit__(self,
+                 # pylint: disable=duplicate-code
+                 # see https://github.com/PyCQA/pylint/issues/3619
+                 exc_type: Optional[Type[BaseException]],
+                 exc_val: Optional[BaseException],
+                 exc_tb: Optional[TracebackType]) -> None:
         # Implement context manager exit function.
         self.close()
-        return False
 
     def connect(self, negotiate=True):
         """
-- 
2.21.3

