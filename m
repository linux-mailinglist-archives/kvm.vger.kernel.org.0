Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC921E98E9
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgEaQj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 May 2020 12:39:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23694 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728243AbgEaQj1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 May 2020 12:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590943165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zavZXRcfF4vEsC1fffibsH2BOyGQjn9n39JGbmxfN4M=;
        b=EdaBuI7CX6GrM2CE69LNIi4+q2H0HHKQAvQPz5NkGz/x9rcnRqDQ5m5v4pc7LMFkMmGDNa
        X2k1sDyQO95WMxKZcYxeEdQniK59rJtJeM08VMFt+KzEVqyy/DwAhO6AnThb1BXvMHBeZw
        2IOT/uaYWaPo8rlH+IqD6CqkKYKmg3U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-_SPEDn40MmiWnZ5mfUpv1g-1; Sun, 31 May 2020 12:39:21 -0400
X-MC-Unique: _SPEDn40MmiWnZ5mfUpv1g-1
Received: by mail-wr1-f71.google.com with SMTP id o1so3589628wrm.17
        for <kvm@vger.kernel.org>; Sun, 31 May 2020 09:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zavZXRcfF4vEsC1fffibsH2BOyGQjn9n39JGbmxfN4M=;
        b=R/whxiFApiclzj3JlcRi71gtOjFYoQHNStFJXxjcVEdBN4Zrr46Aamju98X3sPHS0Z
         A9lD7DPo0Tkn6BfnYwRxnXHxtQ19CG2tAOnL5USV06gUJHjbeH0Erm8MjBqG+vW+0enO
         6jLX+L1Dfe0ZrgFvNsMzQfllSVzb9T8YCnNrnFnVu9Vx2GnZ57EGqi30msFIICelD/d+
         kJ2deGIytyIq4v0/wN+B1iZ2/3y4X8ZwgZxUjlVuj/8+PIbKeunYXCt7jw8qCE6G0CPl
         ckaKXf0M7AjNnWxBfPHScQIgPjNeHfFHmZVWOxTkVZAfw/ofVU4E7EAOUur9EPbDHz+I
         ymDg==
X-Gm-Message-State: AOAM531GOWDM/at7rbIPm27WowLQBmNuj+bPkgodM5m6AVZDoiLJEijy
        n20K8yQOvf87LfHJz4DXIWv/OXRMkn5wqEiSI/MZnXtoKwHDRxVnpsINuG69vOPjIDZ2HvcYJXV
        g+g+YX8+i8+mZ
X-Received: by 2002:a05:600c:4410:: with SMTP id u16mr17583871wmn.88.1590943160626;
        Sun, 31 May 2020 09:39:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxly3Ew6xb8Z2VBdFKMDEhwnRILeq2GKU98Tl7lrJZyURsFrFEvr8EmgNXNr/Rk3c8TXuUC7w==
X-Received: by 2002:a05:600c:4410:: with SMTP id u16mr17583850wmn.88.1590943160429;
        Sun, 31 May 2020 09:39:20 -0700 (PDT)
Received: from localhost.localdomain (43.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.43])
        by smtp.gmail.com with ESMTPSA id w10sm18093502wrp.16.2020.05.31.09.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 09:39:19 -0700 (PDT)
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
Subject: [PULL 06/25] scripts/qmp: Fix shebang and imports
Date:   Sun, 31 May 2020 18:38:27 +0200
Message-Id: <20200531163846.25363-7-philmd@redhat.com>
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

There's more wrong with these scripts; They are in various stages of
disrepair. That's beyond the scope of this current patchset.

This just mechanically corrects the imports and the shebangs, as part of
ensuring that the python/qemu/lib refactoring didn't break anything
needlessly.

Signed-off-by: John Snow <jsnow@redhat.com>
Message-Id: <20200528222129.23826-2-jsnow@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/qmp/qmp      | 4 +++-
 scripts/qmp/qom-fuse | 4 +++-
 scripts/qmp/qom-get  | 4 +++-
 scripts/qmp/qom-list | 4 +++-
 scripts/qmp/qom-set  | 4 +++-
 scripts/qmp/qom-tree | 4 +++-
 6 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/scripts/qmp/qmp b/scripts/qmp/qmp
index 0625fc2aba..8e52e4a54d 100755
--- a/scripts/qmp/qmp
+++ b/scripts/qmp/qmp
@@ -11,7 +11,9 @@
 # See the COPYING file in the top-level directory.
 
 import sys, os
-from qmp import QEMUMonitorProtocol
+
+sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
+from qemu.qmp import QEMUMonitorProtocol
 
 def print_response(rsp, prefix=[]):
     if type(rsp) == list:
diff --git a/scripts/qmp/qom-fuse b/scripts/qmp/qom-fuse
index 6bada2c33d..5fa6b3bf64 100755
--- a/scripts/qmp/qom-fuse
+++ b/scripts/qmp/qom-fuse
@@ -15,7 +15,9 @@ import fuse, stat
 from fuse import Fuse
 import os, posix
 from errno import *
-from qmp import QEMUMonitorProtocol
+
+sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
+from qemu.qmp import QEMUMonitorProtocol
 
 fuse.fuse_python_api = (0, 2)
 
diff --git a/scripts/qmp/qom-get b/scripts/qmp/qom-get
index 7c5ede91bb..666df71832 100755
--- a/scripts/qmp/qom-get
+++ b/scripts/qmp/qom-get
@@ -13,7 +13,9 @@
 
 import sys
 import os
-from qmp import QEMUMonitorProtocol
+
+sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
+from qemu.qmp import QEMUMonitorProtocol
 
 cmd, args = sys.argv[0], sys.argv[1:]
 socket_path = None
diff --git a/scripts/qmp/qom-list b/scripts/qmp/qom-list
index bb68fd65d4..5074fd939f 100755
--- a/scripts/qmp/qom-list
+++ b/scripts/qmp/qom-list
@@ -13,7 +13,9 @@
 
 import sys
 import os
-from qmp import QEMUMonitorProtocol
+
+sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
+from qemu.qmp import QEMUMonitorProtocol
 
 cmd, args = sys.argv[0], sys.argv[1:]
 socket_path = None
diff --git a/scripts/qmp/qom-set b/scripts/qmp/qom-set
index 19881d85e9..240a78187f 100755
--- a/scripts/qmp/qom-set
+++ b/scripts/qmp/qom-set
@@ -13,7 +13,9 @@
 
 import sys
 import os
-from qmp import QEMUMonitorProtocol
+
+sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
+from qemu.qmp import QEMUMonitorProtocol
 
 cmd, args = sys.argv[0], sys.argv[1:]
 socket_path = None
diff --git a/scripts/qmp/qom-tree b/scripts/qmp/qom-tree
index fa91147a03..25b0781323 100755
--- a/scripts/qmp/qom-tree
+++ b/scripts/qmp/qom-tree
@@ -15,7 +15,9 @@
 
 import sys
 import os
-from qmp import QEMUMonitorProtocol
+
+sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))
+from qemu.qmp import QEMUMonitorProtocol
 
 cmd, args = sys.argv[0], sys.argv[1:]
 socket_path = None
-- 
2.21.3

