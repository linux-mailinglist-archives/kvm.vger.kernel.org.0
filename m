Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10EF8B87EC
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 01:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404482AbfISXCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 19:02:33 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:33060 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390172AbfISXCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 19:02:33 -0400
Received: by mail-pf1-f202.google.com with SMTP id z4so3307706pfn.0
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 16:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3dI2aAeHuXV9dcgvDwt653/mfpUM3BDLO9nXnPwcIA8=;
        b=FF9l9HQK+45Pl3gCa+8h7zVqzKPzH0YcpY1nuWQq1BaA9OdnOXDmJU7GzJNxRyXTUX
         hEll1q4qLpIcKI7D8xa1+erFRevw+Hh7Xxtt+5H/7lLW5HrQyvDTK11de/2dJKyM0cMI
         HZtCdsmqgjcKdIdQT5AkvzflQMza0CyD9TNaXuuxZlOiThy1lWzDrXbQuq9U9K8XW/cw
         6+yOwKFijnJJfOLNI8o6S2d/kKT79g5juCC6WJGyK08Fyrgs/NwjZfFTbIybM9THVAav
         n6Cw3YODmOW9Vss9Jr+AUTfG2SuWNp1epyHFfUyvCNkEjqoYyxLgdncXU6QSyrUWrqoV
         3asw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3dI2aAeHuXV9dcgvDwt653/mfpUM3BDLO9nXnPwcIA8=;
        b=ZleBHjh9ggvlCY17lC9p3HmS+Zm98t619jW5ZMD8PryLhHDrj2/Sn2lPZ4McpfdKyT
         dvAcmIC8GQEgowjsJXlx1uodU2LSdqTcn3SER74PB8Z7iFuvEKqDc0YaQDgQPKMRCa4o
         8XVKLFyQTQdbwSoTCGO6s9Ctx0eXY91bxLiEWKjxeOnPGPB2YhMKeh/KAgXJj8Sd1XpM
         68JEOkq4OWRV5PkRWLbVKQNdXKRvwHeYYB9sYiZsx8AojQxHYQGKk4c233OU/xo8NbS6
         GYjbAOIvNGCso2oVgISmW4bfSP+G0k50q3PHUVQiVYByvsGVhIsz1/hjnBxLTbczBBG+
         bcTQ==
X-Gm-Message-State: APjAAAU55Xv3049zS5NGlIoH96UkX6blyOY2AZ3N7TWWTzlJYI1PUPhP
        cJTBqtze9QyBGdkErxdskhHaBrAkmrSeLFxZ6EkJk2HhkWgVaRzK7PNgaELTsFkiSh6n73mJuel
        PNMY+pBMknL9MV1l+6xp3+qS8Q45BfmhdcqYepEPgyFmIg7lzio5PtA0WMk4w4dA=
X-Google-Smtp-Source: APXvYqxgHc7uq5o4T8efx7CKrNZfcHJJsNVHyS3s28ovcwCBU3TzR6qCjHV3cBIJpTmZWeugwrvl/mU3iZgbOA==
X-Received: by 2002:a63:1045:: with SMTP id 5mr11444857pgq.165.1568934151159;
 Thu, 19 Sep 2019 16:02:31 -0700 (PDT)
Date:   Thu, 19 Sep 2019 16:02:25 -0700
Message-Id: <20190919230225.37796-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [kvm-unit-tests PATCH] kvm-unit-test: x86: Add RDPRU test
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure that support for RDPRU is not enumerated in the guest's CPUID
and that the RDPRU instruction raises #UD.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 lib/x86/processor.h |  1 +
 x86/Makefile.x86_64 |  1 +
 x86/rdpru.c         | 23 +++++++++++++++++++++++
 x86/unittests.cfg   |  5 +++++
 4 files changed, 30 insertions(+)
 create mode 100644 x86/rdpru.c

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b1c579b..121f19c 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -150,6 +150,7 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
+#define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
 
 /*
  * AMD CPUID features
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 51f9b80..010102b 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -19,6 +19,7 @@ tests += $(TEST_DIR)/vmx.flat
 tests += $(TEST_DIR)/tscdeadline_latency.flat
 tests += $(TEST_DIR)/intel-iommu.flat
 tests += $(TEST_DIR)/vmware_backdoors.flat
+tests += $(TEST_DIR)/rdpru.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/x86/rdpru.c b/x86/rdpru.c
new file mode 100644
index 0000000..a298960
--- /dev/null
+++ b/x86/rdpru.c
@@ -0,0 +1,23 @@
+/* RDPRU test */
+
+#include "libcflat.h"
+#include "processor.h"
+#include "desc.h"
+
+static int rdpru_checking(void)
+{
+	asm volatile (ASM_TRY("1f")
+		      ".byte 0x0f,0x01,0xfd \n\t" /* rdpru */
+		      "1:" : : "c" (0) : "eax", "edx");
+	return exception_vector();
+}
+
+int main(int ac, char **av)
+{
+	setup_idt();
+
+	report("RDPRU not supported", !this_cpu_has(X86_FEATURE_RDPRU));
+	report("RDPRU raises #UD", rdpru_checking() == UD_VECTOR);
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 694ee3d..9764e18 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -221,6 +221,11 @@ file = pcid.flat
 extra_params = -cpu qemu64,+pcid
 arch = x86_64
 
+[rdpru]
+file = rdpru.flat
+extra_params = -cpu host
+arch = x86_64
+
 [umip]
 file = umip.flat
 extra_params = -cpu qemu64,+umip
-- 
2.23.0.351.gc4317032e6-goog

