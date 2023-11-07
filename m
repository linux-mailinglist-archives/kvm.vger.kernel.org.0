Return-Path: <kvm+bounces-1071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE547E49AD
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25FDB281419
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A993715C;
	Tue,  7 Nov 2023 20:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PosLP695"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0291B36B13
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:21 +0000 (UTC)
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6376F10CC
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:21 -0800 (PST)
Received: by mail-ot1-x349.google.com with SMTP id 46e09a7af769-6ce26d7fd45so7930424a34.3
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388420; x=1699993220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yHtSZXfxM41A5xelmirKq8UJ34KMEqQJ6uQM49e88n4=;
        b=PosLP695pD3EvW9V3sE+ynXunoprW2/1tAzhImNB1RSMEGZSIdgQn41cEO9ffluZET
         lh+fiajt4dPLNK5EJWAaSh23YOUv5JBPUF9/GED2yHF53pQZY2a40jXtTAP8EENtT7Ql
         HqO38p5Kz8JHGTbC+xfJwxYDt7+B5wQTEu5NmUtSDtHUVujVjWllZzXztmHcRLrC38Fu
         AVozGNLv1g6hOv1GiQ4+LUP3jznj4A31GEUs+ZmwnGrW+1y21ZL5Nlib1p6HWFwYDqE7
         LqyYg4Wbe6Jt2iq94qnmS/dVoEqHVaqWRMOzSuXoTbfAJ0Yu3LCI9umyzTdG16i45xA5
         tfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388420; x=1699993220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yHtSZXfxM41A5xelmirKq8UJ34KMEqQJ6uQM49e88n4=;
        b=f0X1my8dH8rAuFWue/LANtqCOYwVWAw+G7JLA6EBJMmbuNQwE8FuUAgS4pl/MOLZxm
         pDoHzzaGXN0Fnt7/yWZ6Fj2NwlBfHEKHKdgtvCpe7I0x5Uqr7jkBDj8U8T00wnqTXioH
         JSF7BkWR3R2yBQD52YJJLdD1fydwk9+mXmUnCoCHkkL/Vdfu9X2pFA+QZZi1wdz4ufkT
         rVPSxliQB88f+gaCq+1kvOgarCanZ5S61ev4XPMTXUmwkuD8/DHm55C/WPHB/O5D/7I7
         hvDSB0CdXdNwQB9ic9igLeqXWaOkku3sUi7PqBvQqAzZAyQx1YTvg0Epp+TGKzrDYHx3
         KSLA==
X-Gm-Message-State: AOJu0YwYG2dDLcMkZ3V7gH/ACON0gF9dAZdgL7/JVm+7KaX7SBXO4RO1
	P9XJMvHh8i4pHNI/N7Bt+LYQ1xpUAcC6Ys74elRYUN52DI945tfGTPrsxjL9a8uAG8EtQPWIkre
	sv79atBj2Uj02WZpTCF3EhERudCGFXIcnbBU6UzhTZEt4c/XkeaAT0t0j19e4t9U=
X-Google-Smtp-Source: AGHT+IH+sJeS0ROAOq43lwtwQUvZBoMusw05VPI8LA5O035oWce3ho1ohN0fd1vRG/n1OuGrAfAPNCHaW1P53w==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a05:6830:26da:b0:6c4:7e6c:cb4e with SMTP
 id m26-20020a05683026da00b006c47e6ccb4emr9658721otu.5.1699388420723; Tue, 07
 Nov 2023 12:20:20 -0800 (PST)
Date: Tue,  7 Nov 2023 20:19:52 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-5-aghulati@google.com>
Subject: [RFC PATCH 04/14] KVM: x86: Create stubs for a new VAC module
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

Create emtpy stub files for what will eventually be a new module named
Virtualization Acceleration Code: Unupgradable Units Module (backronym:
VACUUM, or VAC for short). VAC will function as a base module for
multiple KVM modules and will contain the code needed to manage
system-wide virtualization resources, like enabling/disabling
virtualization hardware.

Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/kvm/Makefile  | 2 ++
 arch/x86/kvm/svm/vac.c | 2 ++
 arch/x86/kvm/vac.c     | 3 +++
 arch/x86/kvm/vac.h     | 6 ++++++
 arch/x86/kvm/vmx/vac.c | 2 ++
 virt/kvm/Makefile.kvm  | 1 +
 virt/kvm/vac.c         | 3 +++
 virt/kvm/vac.h         | 6 ++++++
 8 files changed, 25 insertions(+)
 create mode 100644 arch/x86/kvm/svm/vac.c
 create mode 100644 arch/x86/kvm/vac.c
 create mode 100644 arch/x86/kvm/vac.h
 create mode 100644 arch/x86/kvm/vmx/vac.c
 create mode 100644 virt/kvm/vac.c
 create mode 100644 virt/kvm/vac.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 3e965c90e065..b3de4bd7988f 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -13,6 +13,8 @@ kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
 			   mmu/spte.o
 
+kvm-y                   += vac.o vmx/vac.o svm/vac.o
+
 ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
 endif
diff --git a/arch/x86/kvm/svm/vac.c b/arch/x86/kvm/svm/vac.c
new file mode 100644
index 000000000000..4aabf16d2fc0
--- /dev/null
+++ b/arch/x86/kvm/svm/vac.c
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
diff --git a/arch/x86/kvm/vac.c b/arch/x86/kvm/vac.c
new file mode 100644
index 000000000000..18d2ae7d3e47
--- /dev/null
+++ b/arch/x86/kvm/vac.c
@@ -0,0 +1,3 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "vac.h"
diff --git a/arch/x86/kvm/vac.h b/arch/x86/kvm/vac.h
new file mode 100644
index 000000000000..4d5dc4700f4e
--- /dev/null
+++ b/arch/x86/kvm/vac.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef ARCH_X86_KVM_VAC_H
+#define ARCH_X86_KVM_VAC_H
+
+#endif // ARCH_X86_KVM_VAC_H
diff --git a/arch/x86/kvm/vmx/vac.c b/arch/x86/kvm/vmx/vac.c
new file mode 100644
index 000000000000..4aabf16d2fc0
--- /dev/null
+++ b/arch/x86/kvm/vmx/vac.c
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 4de10d447ef3..7876021ea4d7 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -11,6 +11,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
 ifdef CONFIG_VFIO
 kvm-y += $(KVM)/vfio.o
 endif
+kvm-y += $(KVM)/vac.o
 kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
 kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
 kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
diff --git a/virt/kvm/vac.c b/virt/kvm/vac.c
new file mode 100644
index 000000000000..18d2ae7d3e47
--- /dev/null
+++ b/virt/kvm/vac.c
@@ -0,0 +1,3 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "vac.h"
diff --git a/virt/kvm/vac.h b/virt/kvm/vac.h
new file mode 100644
index 000000000000..8f7123a916c5
--- /dev/null
+++ b/virt/kvm/vac.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __KVM_VAC_H__
+#define __KVM_VAC_H__
+
+#endif
-- 
2.42.0.869.gea05f2083d-goog


