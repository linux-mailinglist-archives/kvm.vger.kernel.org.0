Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCCC186FBD
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbgCPQOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:14:02 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:23073 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732032AbgCPQOC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CXjQwOZg5TRrzV2gPeofWVxsNWA85AadaVJBm5vW278=;
        b=BST8vHPGK0rwOOKaY66MD+ljH/at94PEpF0NMbGvlyG9vbz1brRlY9JNn+rFzBd4xMIn8q
        yycNcJl6ox6q76QmsWovrqibFYUpdmYWlERBhLEwSw/+zSyY1nK/zzIwNvgPCszWklzYBm
        0/RtES3cZtFtswcQ14DGB0EB53shD+Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-OfhBUFD1ON2azkFX7JHgcw-1; Mon, 16 Mar 2020 12:07:22 -0400
X-MC-Unique: OfhBUFD1ON2azkFX7JHgcw-1
Received: by mail-wr1-f71.google.com with SMTP id p5so9175350wrj.17
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CXjQwOZg5TRrzV2gPeofWVxsNWA85AadaVJBm5vW278=;
        b=N7S5iT16IAJWToa0fazWtuZfqqsq712eNC6jVdWHJpO2Sc7+TfAQUfEljGSLN7judd
         9YKmOG9i45NpaVmfnV6X1g44fbC7F5wlwJXb+bCPVN4x6BWyelJK4t/IzZzntlYL0/6w
         zZv0wEmHer11rgZSK3Kwbl2m1/37WYya94xS1nptowl6ZRGC3LddY+hMy279iQXASiZn
         6RBWzQCqD6i/dSBx7LZ+LLlxzmb6OkHHRqI5jw9wRV5wu2MynNoewAPbI3kYQO8O09zs
         S79soTqj9mzy62F/ua2mSJo3j3TYVXFJcHBzkrgdY0aAa69japjVchGT38d5Duq+xkS/
         5Z6g==
X-Gm-Message-State: ANhLgQ07frHsKLrxu09e2RVu6/E2nQI1UeBFGKHiu+q2UhBnL+VYTF5K
        rSvAlWhQCKF8EzLBXwKWwji8D1XwpgcjEBSYEy3o+EDQQa4YFyAKZ8H5dxfAlRDauTufcSXUyE+
        imfhcZk2rewR2
X-Received: by 2002:adf:dd8f:: with SMTP id x15mr63155wrl.201.1584374841785;
        Mon, 16 Mar 2020 09:07:21 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsxe/KqUgpqRGockZFKDs2m6WInFJ38H8FHOWfbUrTbCQq4cCk2UoU+Cb7vY3P51wmSj99eAw==
X-Received: by 2002:adf:dd8f:: with SMTP id x15mr63130wrl.201.1584374841621;
        Mon, 16 Mar 2020 09:07:21 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id u204sm185104wmg.40.2020.03.16.09.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:07:21 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 08/19] target/arm: Add semihosting stub to allow building without TCG
Date:   Mon, 16 Mar 2020 17:06:23 +0100
Message-Id: <20200316160634.3386-9-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Semihosting requires TCG. When configured with --disable-tcg, the
build fails because the 'do_arm_semihosting' is missing. Instead
of adding more few more #ifdeffery to the helper code, add a stub.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/arm-semi-stub.c | 13 +++++++++++++
 target/arm/Makefile.objs   |  3 ++-
 2 files changed, 15 insertions(+), 1 deletion(-)
 create mode 100644 target/arm/arm-semi-stub.c

diff --git a/target/arm/arm-semi-stub.c b/target/arm/arm-semi-stub.c
new file mode 100644
index 0000000000..47d042f942
--- /dev/null
+++ b/target/arm/arm-semi-stub.c
@@ -0,0 +1,13 @@
+/*
+ * Arm "Angel" semihosting syscalls stubs
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "hw/semihosting/semihost.h"
+
+target_ulong do_arm_semihosting(CPUARMState *env)
+{
+    abort();
+}
diff --git a/target/arm/Makefile.objs b/target/arm/Makefile.objs
index 0c6f8c248d..fa278bb4c1 100644
--- a/target/arm/Makefile.objs
+++ b/target/arm/Makefile.objs
@@ -57,7 +57,8 @@ target/arm/translate.o: target/arm/decode-t16.inc.c
 
 ifeq ($(CONFIG_TCG),y)
 
-obj-y += arm-semi.o
+obj-$(CONFIG_SEMIHOSTING) += arm-semi.o
+obj-$(call lnot,$(CONFIG_SEMIHOSTING)) += arm-semi-stub.o
 
 endif # CONFIG_TCG
 
-- 
2.21.1

