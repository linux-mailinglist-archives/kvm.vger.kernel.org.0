Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB62338B9FB
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhETXFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbhETXF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:27 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A472CC061763
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:05 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o1-20020a17090a4201b029015c8f11f550so7156364pjg.5
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Otf7aQinzlQ1psbjlGm9ZcByrmOGOiHC8uYjTOHlsVc=;
        b=IWC3ixlLB40rzU+VF31dGORzbQi8yvBuQGQic5bWk4xLyUOT97ctM/h5utK2ed+OiU
         TReHl2I1BxIBXRhaIBKcbBZ2Cuc/z1d/+xSBbaR5gL/o9Tamhu2EMa05Qkvx1EgPeJbt
         vGh7/iKDBVR8DShy4sqrCzOY/1kG81ciSRVyv3QLJ1frxgurxvkJD42XsyavyAY1TGxF
         ivEmN+EPEY4TpGiNhcZlCcE9meEhAGDE9dKVO9U4ruvX8BQc0R9XFebZxojJJ2tmAX+2
         sv/SUkqBMWjDTOJwAAPWPL1nnXlziZ7AKBvCw59VMbCtTpQXWM2xMM2yhL/zHvczzT4R
         21TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Otf7aQinzlQ1psbjlGm9ZcByrmOGOiHC8uYjTOHlsVc=;
        b=TN02NX6VjEWkiTUgSHcptYbeqIC5A+ulX6ouDdnws4mwRLZt7R6Sq5rOEUfheeOsx6
         RXcmusGKqFb25yC2TOtObFmVJPh/eqAAcywwgHbRBhFPL9ZEMQlbj+imB5EL0wpci1K0
         eed2Ijt4cn7d2eddcAmDeuh93KETx5fvaXy8J/Ih3JGMHE8Uen48MzaqDiwv7xCm0N53
         S7q13W1w/w5yECJU/VRv0fCM4I85GMWNIfoRQHAeueKawZ/zm491/Niy8vME/tI61C2k
         UxgqmxU5WfDJGSmTuzAKBwg9PQ7jWU/Ou5ijW8s8lJ5v1shklJGBHcJgYdw6PnG7NI6z
         /8qw==
X-Gm-Message-State: AOAM5303Jl5XwrerwEsNi7BjYO/FG8pcyVZEZAZNfc13mNGt//3O5K5w
        bcsbIwBSB3QvttFZ9UZv3rt3hHE2GZbfv5Zxr6Ixm2dYEtu9awmGqPf7/UKMFzWiidpOkd3kS3E
        Srfa9FViyH9GkEO1cN02YTmKafNevPTk2piLX8onActMu99boJEWj2A8UXSDuXMY=
X-Google-Smtp-Source: ABdhPJwCOx/wRQDYIVM+YntufPO255uR6vA9FYlkM4681EnJomSNoid21UmbuXdZT2x4gb1alxjBdYPy2lnyUg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90b:ed5:: with SMTP id
 gz21mr7420817pjb.102.1621551845073; Thu, 20 May 2021 16:04:05 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:35 -0700
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Message-Id: <20210520230339.267445-9-jmattson@google.com>
Mime-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 08/12] KVM: selftests: Move APIC definitions into a separate file
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
2.31.1.818.g46aad6cb9e-goog

