Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8129439BEB8
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhFDR32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:29:28 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:55197 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFDR31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:29:27 -0400
Received: by mail-pf1-f202.google.com with SMTP id d17-20020aa781510000b02902e921bdea05so5722364pfn.21
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1dLh43sRzXKlMYZMKws7XnkKCPB3IC+/0BCvd5bfEb4=;
        b=wEB+aiv3QlRV5Bl2C3a2vo2Oq9fjvPOCJq1Cu3SUTlEn4tBSwkruAqOSFGHAq8IU2u
         hOunnmbirTIF0GzNy4Tf4X0sn8R38nMBXRByn/EwoeMLQLSl4yhZ0CzyyAe1N8+RGqwT
         XLtHPGon+A6Zorct87mCOl0O5TXYnAAGNuND/kWpIap4cdwS8M793N/mldRUeKyxML9E
         IMPW7BbfqrFPv/tVmbURE/TdEGgmldulnZrOt0fcKujSRm45CAzSO0cFz3XLfKZIFRt+
         9+/FaqEtPiU2jCgjtQ3v+QDlmfuKARS/OxgAM9eotPOGthK/ycvMVSZWwSqBvhmS6eD3
         /Ndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1dLh43sRzXKlMYZMKws7XnkKCPB3IC+/0BCvd5bfEb4=;
        b=BXblUrrTPt7NybnRYWEnfs+gWy7QSxqeLM7Hzr+egmBTZcAYOJa+hX4Xn+9jpDHS/g
         TIOB+hpO32lveCivzhoTFBipGV4WzSuI6hPoK8wa5wieZF8r+P9keuvbpU64+Z5lGi8q
         aNeaHGbz2BDEP2Jh3sbOqQCSFuJ0WbyvgjI76Ye1h7Ls2hk7yXkxac0X2aMr8UZg33sb
         rkVwQ3P3uc1jY/JVuW/y5IbU3/QeGVMqEIy/kkODbzyEqqGqOwHFinMz0frrdgdU1qIT
         NjaeoxEjNPJFJTlg5p7JdAEHBqDXJydagrcyNhvOfDsSO3P/MahYBBcn//vu6nw2xNtk
         A5yQ==
X-Gm-Message-State: AOAM533R000/kEjIQ7dR+rLBl/DW2JX6eFY61WNVbHGd+zm6DTxaO4du
        evcedTG67ZzaUNVl9p+Bt8z8x8jg3Eu1IDN2KW00Qi+G0JkYFD/ABgm35AeGqDjuOPJH3ZIWjSa
        pdF+Upmh+yETP74AaBGZVpW8wn6YJJl9qwVh9/oh32zZwDQgb2Emx7scj/e85/8g=
X-Google-Smtp-Source: ABdhPJzOac3kB7ozYzik4KIRn8hYkBcZDDtzdZGrKylyWXy2cJohiKrCx7Ss4hhPLieuzIDtzhlDNPdJQVGpSA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:a1d:b029:2e9:3aec:89c2 with SMTP
 id p29-20020a056a000a1db02902e93aec89c2mr5466087pfh.68.1622827600904; Fri, 04
 Jun 2021 10:26:40 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:07 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-9-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 08/12] KVM: selftests: Move APIC definitions into a
 separate file
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Processor.h is a hodgepodge of definitions. Though the local APIC is
technically built into the CPU these days, move the APIC definitions
into a new header file: apic.h.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/x86_64/apic.h       | 58 +++++++++++++++++++
 .../selftests/kvm/include/x86_64/processor.h  | 47 ---------------
 .../selftests/kvm/include/x86_64/vmx.h        |  1 +
 3 files changed, 59 insertions(+), 47 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/apic.h

diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
new file mode 100644
index 000000000000..0d0e35c8866b
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * tools/testing/selftests/kvm/include/x86_64/apic.h
+ *
+ * Copyright (C) 2021, Google LLC.
+ */
+
+#ifndef SELFTEST_KVM_APIC_H
+#define SELFTEST_KVM_APIC_H
+
+#define APIC_DEFAULT_GPA		0xfee00000ULL
+
+/* APIC base address MSR and fields */
+#define MSR_IA32_APICBASE		0x0000001b
+#define MSR_IA32_APICBASE_BSP		(1<<8)
+#define MSR_IA32_APICBASE_EXTD		(1<<10)
+#define MSR_IA32_APICBASE_ENABLE	(1<<11)
+#define MSR_IA32_APICBASE_BASE		(0xfffff<<12)
+#define		GET_APIC_BASE(x)	(((x) >> 12) << 12)
+
+#define APIC_BASE_MSR	0x800
+#define X2APIC_ENABLE	(1UL << 10)
+#define	APIC_ID		0x20
+#define	APIC_LVR	0x30
+#define		GET_APIC_ID_FIELD(x)	(((x) >> 24) & 0xFF)
+#define	APIC_TASKPRI	0x80
+#define	APIC_PROCPRI	0xA0
+#define	APIC_EOI	0xB0
+#define	APIC_SPIV	0xF0
+#define		APIC_SPIV_FOCUS_DISABLED	(1 << 9)
+#define		APIC_SPIV_APIC_ENABLED		(1 << 8)
+#define	APIC_ICR	0x300
+#define		APIC_DEST_SELF		0x40000
+#define		APIC_DEST_ALLINC	0x80000
+#define		APIC_DEST_ALLBUT	0xC0000
+#define		APIC_ICR_RR_MASK	0x30000
+#define		APIC_ICR_RR_INVALID	0x00000
+#define		APIC_ICR_RR_INPROG	0x10000
+#define		APIC_ICR_RR_VALID	0x20000
+#define		APIC_INT_LEVELTRIG	0x08000
+#define		APIC_INT_ASSERT		0x04000
+#define		APIC_ICR_BUSY		0x01000
+#define		APIC_DEST_LOGICAL	0x00800
+#define		APIC_DEST_PHYSICAL	0x00000
+#define		APIC_DM_FIXED		0x00000
+#define		APIC_DM_FIXED_MASK	0x00700
+#define		APIC_DM_LOWEST		0x00100
+#define		APIC_DM_SMI		0x00200
+#define		APIC_DM_REMRD		0x00300
+#define		APIC_DM_NMI		0x00400
+#define		APIC_DM_INIT		0x00500
+#define		APIC_DM_STARTUP		0x00600
+#define		APIC_DM_EXTINT		0x00700
+#define		APIC_VECTOR_MASK	0x000FF
+#define	APIC_ICR2	0x310
+#define		SET_APIC_DEST_FIELD(x)	((x) << 24)
+
+#endif /* SELFTEST_KVM_APIC_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b30b4e15c38..a4729d9032ce 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -425,53 +425,6 @@ struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpui
 #define X86_CR0_CD          (1UL<<30) /* Cache Disable */
 #define X86_CR0_PG          (1UL<<31) /* Paging */
 
-#define APIC_DEFAULT_GPA		0xfee00000ULL
-
-/* APIC base address MSR and fields */
-#define MSR_IA32_APICBASE		0x0000001b
-#define MSR_IA32_APICBASE_BSP		(1<<8)
-#define MSR_IA32_APICBASE_EXTD		(1<<10)
-#define MSR_IA32_APICBASE_ENABLE	(1<<11)
-#define MSR_IA32_APICBASE_BASE		(0xfffff<<12)
-#define		GET_APIC_BASE(x)	(((x) >> 12) << 12)
-
-#define APIC_BASE_MSR	0x800
-#define X2APIC_ENABLE	(1UL << 10)
-#define	APIC_ID		0x20
-#define	APIC_LVR	0x30
-#define		GET_APIC_ID_FIELD(x)	(((x) >> 24) & 0xFF)
-#define	APIC_TASKPRI	0x80
-#define	APIC_PROCPRI	0xA0
-#define	APIC_EOI	0xB0
-#define	APIC_SPIV	0xF0
-#define		APIC_SPIV_FOCUS_DISABLED	(1 << 9)
-#define		APIC_SPIV_APIC_ENABLED		(1 << 8)
-#define	APIC_ICR	0x300
-#define		APIC_DEST_SELF		0x40000
-#define		APIC_DEST_ALLINC	0x80000
-#define		APIC_DEST_ALLBUT	0xC0000
-#define		APIC_ICR_RR_MASK	0x30000
-#define		APIC_ICR_RR_INVALID	0x00000
-#define		APIC_ICR_RR_INPROG	0x10000
-#define		APIC_ICR_RR_VALID	0x20000
-#define		APIC_INT_LEVELTRIG	0x08000
-#define		APIC_INT_ASSERT		0x04000
-#define		APIC_ICR_BUSY		0x01000
-#define		APIC_DEST_LOGICAL	0x00800
-#define		APIC_DEST_PHYSICAL	0x00000
-#define		APIC_DM_FIXED		0x00000
-#define		APIC_DM_FIXED_MASK	0x00700
-#define		APIC_DM_LOWEST		0x00100
-#define		APIC_DM_SMI		0x00200
-#define		APIC_DM_REMRD		0x00300
-#define		APIC_DM_NMI		0x00400
-#define		APIC_DM_INIT		0x00500
-#define		APIC_DM_STARTUP		0x00600
-#define		APIC_DM_EXTINT		0x00700
-#define		APIC_VECTOR_MASK	0x000FF
-#define	APIC_ICR2	0x310
-#define		SET_APIC_DEST_FIELD(x)	((x) << 24)
-
 /* VMX_EPT_VPID_CAP bits */
 #define VMX_EPT_VPID_CAP_AD_BITS       (1ULL << 21)
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 65eb1079a161..516c81d86353 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -10,6 +10,7 @@
 
 #include <stdint.h>
 #include "processor.h"
+#include "apic.h"
 
 /*
  * Definitions of Primary Processor-Based VM-Execution Controls.
-- 
2.32.0.rc1.229.g3e70b5a671-goog

