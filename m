Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0241CF283
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgELKdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:33:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29413 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729365AbgELKdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 06:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589279589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ds4l+7fZ3gMORFydzgGtrLwAaPpZWtJvEPP6Ecz3QgY=;
        b=FrxQAN8f4Cm814+g7613LhdhBHZTNGuyM/EKPEyI0l8lmWWzVywpmDTLzQZpjYN77E6Dwp
        +Me0G8QXRLUwhR8ttHM/pO4zTUl20nf9qhKp/uW4y1SDPxjjiCnIhgh3GCe5e/vGR9D/ru
        mAZFRk6qyxRkdNhyz1R8OcptC32kL5Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-zgC5UCrsM9-wuqEdoliQjw-1; Tue, 12 May 2020 06:33:05 -0400
X-MC-Unique: zgC5UCrsM9-wuqEdoliQjw-1
Received: by mail-wm1-f69.google.com with SMTP id q5so9752369wmc.9
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 03:33:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ds4l+7fZ3gMORFydzgGtrLwAaPpZWtJvEPP6Ecz3QgY=;
        b=FneAUTiiHFUNkdzHBq3q9P9D6Wo11GrzAJemRpP6pctXeyjOMorPs0TaTzGSCEL3Xe
         Z5pgjL7MXFPAqzOJY00ptuqkMc4CyMQ47Nyaq0c/QWYOG40ebxxrKVQO8IwmaynKwoLD
         YbcmC2lxlOFOph6AB+EyyRi9LJoq2xpDgKYbER8nNaKkDUaqBCDLs0vDADvq1a7X3WO/
         DyIPfdmMPqMPu1AsSoFDKmMLXuCzl7v9A/YJz9ro1k3LbfKuvOpKh9btT6odA4XpWcx3
         paUvr30il2PZm6deK77jC7pE5Lq2xoQVErxHUk8VTDM4mUhhzfOConnzJim0B5VTFYYe
         C33A==
X-Gm-Message-State: AGi0PuYLae1jg9+MyG4WhP1gjJOtSNqIFYuBaw7xsMF6S6CisXX5C95w
        OvcVnXONy+pnw0Evy1g0oD8GpZiXzFMI4i/7XJU+r5PckPVk3NuUI2I3NefWgLgYCU7hVumsP7v
        4j2RTyo+bp6ok
X-Received: by 2002:a1c:e4c1:: with SMTP id b184mr20242340wmh.4.1589279584721;
        Tue, 12 May 2020 03:33:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypI/laT2LsXrPFPVBKvEk7pWPnx7ibaLAWboB7OwBuZFbrY2ibbD5F30XX0MAqw3dY3xhmeCtA==
X-Received: by 2002:a1c:e4c1:: with SMTP id b184mr20242317wmh.4.1589279584461;
        Tue, 12 May 2020 03:33:04 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id w15sm21193073wrl.73.2020.05.12.03.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 03:33:03 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        qemu-trivial@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Cleber Rosa <crosa@redhat.com>, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>
Subject: [PATCH v4 5/6] scripts/modules/module_block: Use Python 3 interpreter & add pseudo-main
Date:   Tue, 12 May 2020 12:32:37 +0200
Message-Id: <20200512103238.7078-6-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200512103238.7078-1-philmd@redhat.com>
References: <20200512103238.7078-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/modules/module_block.py | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/scripts/modules/module_block.py b/scripts/modules/module_block.py
index f23191fac1..2e7021b952 100644
--- a/scripts/modules/module_block.py
+++ b/scripts/modules/module_block.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python3
 #
 # Module information generator
 #
@@ -10,7 +10,6 @@
 # This work is licensed under the terms of the GNU GPL, version 2.
 # See the COPYING file in the top-level directory.
 
-import sys
 import os
 
 def get_string_struct(line):
@@ -80,19 +79,21 @@ def print_bottom(fheader):
 #endif
 ''')
 
-# First argument: output file
-# All other arguments: modules source files (.c)
-output_file = sys.argv[1]
-with open(output_file, 'w') as fheader:
-    print_top(fheader)
+if __name__ == '__main__':
+    import sys
+    # First argument: output file
+    # All other arguments: modules source files (.c)
+    output_file = sys.argv[1]
+    with open(output_file, 'w') as fheader:
+        print_top(fheader)
 
-    for filename in sys.argv[2:]:
-        if os.path.isfile(filename):
-            process_file(fheader, filename)
-        else:
-            print("File " + filename + " does not exist.", file=sys.stderr)
-            sys.exit(1)
+        for filename in sys.argv[2:]:
+            if os.path.isfile(filename):
+                process_file(fheader, filename)
+            else:
+                print("File " + filename + " does not exist.", file=sys.stderr)
+                sys.exit(1)
 
-    print_bottom(fheader)
+        print_bottom(fheader)
 
-sys.exit(0)
+    sys.exit(0)
-- 
2.21.3

