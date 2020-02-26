Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77268170347
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 16:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbgBZP4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 10:56:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25395 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728073AbgBZP4F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 10:56:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582732564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/g3Gs6VDiPT1QYPbL+OndFSLPCBMmybI6k/WRvA9aKw=;
        b=M0zCA2Z8dZWdjzUmCVf2MF7yiznfiRUlRv7B1gpxi3oaL+2EaWBHbYlw7ODw5qoLMR19Yu
        7YeZqGQF4XlXF1Z46sw4TtvgQPXwvsdPiulEOVeNBbMA/KiwQXYk1q8w65Za4xVlGlORVc
        ZC3k7T2leOtKG5FuXLqRh8K1D6a8tGo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-jP10h2vuOf64TZSv9bmu8w-1; Wed, 26 Feb 2020 10:56:01 -0500
X-MC-Unique: jP10h2vuOf64TZSv9bmu8w-1
Received: by mail-qt1-f199.google.com with SMTP id k20so4926580qtm.11
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 07:56:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/g3Gs6VDiPT1QYPbL+OndFSLPCBMmybI6k/WRvA9aKw=;
        b=kYre5zOGuRtKI1ZjNoxJp8rTiBb0uZQmRTzZKzSCPXy3EKnvIBiwe4Vu8ykzv0+hK9
         LqDWeqJq24JCU5CIIvYmUBCePHL7CHcZT0May9SIf6toIuxlWqHvmTkul6MtOiyRXZtB
         ExzhN3q+QEh20a5SYnNewokni0Sx4BdZdp6NEtvForjZTvktHr5aXoPsyV5XQ89xvrs1
         HkBFzS+eQgqdr8i4jj03f0FGrIgeBK5rOWGDmNWC0Q0QiD3NloNNcijQsHeJn2lU9wMt
         oG6wOwOXlMDXMpJ22dsEpPrX+x9pQxDMbrSBUjDQVT1UsV6d7KYn38fjhs3Fd5AWX+Ka
         RZrA==
X-Gm-Message-State: APjAAAXSlTeHL9Y/q7nRW0X+WasWbh2UUBHneKC/YmPZJoccb5lF+Fqc
        KrtzlvusrmEuunWJUi9pAmH/RSvQeQM1pTjZF+ZxvFFRwzkfigjDBVfgiamaTnTjZYBcBS4e0Vw
        HbBeIpW4fNZ58
X-Received: by 2002:a05:620a:42:: with SMTP id t2mr6812728qkt.45.1582732560690;
        Wed, 26 Feb 2020 07:56:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqxUtK+kn5dwXfcN05C4cimB/Hkd5ivHt4kkovs/4KfLs5Cjvj2XGzCzXVVOvLta6kthdvWhHA==
X-Received: by 2002:a05:620a:42:: with SMTP id t2mr6812699qkt.45.1582732560379;
        Wed, 26 Feb 2020 07:56:00 -0800 (PST)
Received: from xz-x1.redhat.com (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id w134sm1307026qka.127.2020.02.26.07.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 07:55:59 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, jianjay.zhou@huawei.com,
        peterx@redhat.com
Subject: [PATCH] KVM: Remove unecessary asm/kvm_host.h includes
Date:   Wed, 26 Feb 2020 10:55:58 -0500
Message-Id: <20200226155558.175021-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linux/kvm_host.h and asm/kvm_host.h have a dependency in that the asm
header should be included first, then we can define arch-specific
macros in asm/ header and use "#ifndef" in linux/ header to define the
generic value of the macro.  One example is KVM_MAX_VCPU_ID.

Now in many C files we've got both the headers included, and
linux/kvm_host.h is included even earlier.  It's working only because
in linux/kvm_host.h we also included asm/kvm_host.h anyway so the
explicit inclusion of asm/kvm_host.h in the C files are meaningless.

To avoid the confusion, remove the asm/ header if the linux/ header is
included.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/arm/kvm/coproc.c                | 1 -
 arch/arm64/kvm/fpsimd.c              | 1 -
 arch/arm64/kvm/guest.c               | 1 -
 arch/arm64/kvm/hyp/switch.c          | 1 -
 arch/arm64/kvm/sys_regs.c            | 1 -
 arch/arm64/kvm/sys_regs_generic_v8.c | 1 -
 arch/powerpc/kvm/book3s_64_vio.c     | 1 -
 arch/powerpc/kvm/book3s_64_vio_hv.c  | 1 -
 arch/powerpc/kvm/book3s_hv.c         | 1 -
 arch/powerpc/kvm/mpic.c              | 1 -
 arch/powerpc/kvm/powerpc.c           | 1 -
 arch/powerpc/kvm/timing.h            | 1 -
 arch/s390/kvm/intercept.c            | 1 -
 arch/x86/kvm/mmu/page_track.c        | 1 -
 virt/kvm/arm/psci.c                  | 1 -
 15 files changed, 15 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 07745ee022a1..f0c09049ee99 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -10,7 +10,6 @@
 #include <linux/kvm_host.h>
 #include <linux/uaccess.h>
 #include <asm/kvm_arm.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_mmu.h>
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 525010504f9d..e329a36b2bee 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -11,7 +11,6 @@
 #include <linux/kvm_host.h>
 #include <asm/fpsimd.h>
 #include <asm/kvm_asm.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2bd92301d32f..23ebe51410f0 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -25,7 +25,6 @@
 #include <asm/kvm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
-#include <asm/kvm_host.h>
 #include <asm/sigcontext.h>
 
 #include "trace.h"
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index dfe8dd172512..f3e0ab961565 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -17,7 +17,6 @@
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3e909b117f0c..b95f7b7743c8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -22,7 +22,6 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/perf_event.h>
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 2b4a3e2d1b89..9cb6b4c8355a 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -12,7 +12,6 @@
 #include <asm/cputype.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/sysreg.h>
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index ee6c103bb7d5..50555ad1db93 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -27,7 +27,6 @@
 #include <asm/hvcall.h>
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
-#include <asm/kvm_host.h>
 #include <asm/udbg.h>
 #include <asm/iommu.h>
 #include <asm/tce.h>
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index ab6eeb8e753e..6fcaf1fa8e02 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -24,7 +24,6 @@
 #include <asm/hvcall.h>
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
-#include <asm/kvm_host.h>
 #include <asm/udbg.h>
 #include <asm/iommu.h>
 #include <asm/tce.h>
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2cefd071b848..f065d6956342 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -72,7 +72,6 @@
 #include <asm/xics.h>
 #include <asm/xive.h>
 #include <asm/hw_breakpoint.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_book3s_uvmem.h>
 #include <asm/ultravisor.h>
 
diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
index fe312c160d97..23e9c2bd9f27 100644
--- a/arch/powerpc/kvm/mpic.c
+++ b/arch/powerpc/kvm/mpic.c
@@ -32,7 +32,6 @@
 #include <linux/uaccess.h>
 #include <asm/mpic.h>
 #include <asm/kvm_para.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_ppc.h>
 #include <kvm/iodev.h>
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 1af96fb5dc6f..c1f23cb4206c 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -32,7 +32,6 @@
 #include <asm/plpar_wrappers.h>
 #endif
 #include <asm/ultravisor.h>
-#include <asm/kvm_host.h>
 
 #include "timing.h"
 #include "irq.h"
diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
index ace65f9fed30..feef7885ba82 100644
--- a/arch/powerpc/kvm/timing.h
+++ b/arch/powerpc/kvm/timing.h
@@ -10,7 +10,6 @@
 #define __POWERPC_KVM_EXITTIMING_H__
 
 #include <linux/kvm_host.h>
-#include <asm/kvm_host.h>
 
 #ifdef CONFIG_KVM_EXIT_TIMING
 void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index a389fa85cca2..3655196f1c03 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -12,7 +12,6 @@
 #include <linux/errno.h>
 #include <linux/pagemap.h>
 
-#include <asm/kvm_host.h>
 #include <asm/asm-offsets.h>
 #include <asm/irq.h>
 #include <asm/sysinfo.h>
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 3521e2d176f2..0713778b8e12 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -14,7 +14,6 @@
 #include <linux/kvm_host.h>
 #include <linux/rculist.h>
 
-#include <asm/kvm_host.h>
 #include <asm/kvm_page_track.h>
 
 #include "mmu.h"
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 17e2bdd4b76f..14a162e295a9 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -12,7 +12,6 @@
 
 #include <asm/cputype.h>
 #include <asm/kvm_emulate.h>
-#include <asm/kvm_host.h>
 
 #include <kvm/arm_psci.h>
 #include <kvm/arm_hypercalls.h>
-- 
2.24.1

