Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8521F23CEF7
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgHETKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729174AbgHESaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:30:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9B1122EBD;
        Wed,  5 Aug 2020 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596652027;
        bh=ObyvKEKZYF0tiHEd8xlZlpuDoXoetFaGeELOokvwPnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZIQ9A6Z5GWe+s0AI3MT3ZNTVqe86F0LbwSnMiKqsd4adDMP6HDzaBaxghdqw4Ixl
         NSafYkv0M3WBbatU2i/pJeEGUxmGQtuOnlJyemqUsZCTJN0s7VO1pKVzTOa704QKQ2
         ywrcV8JJC5RoA1vRVAxFMD/bhdypDaVCUtB985Gc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nfc-0004w9-2X; Wed, 05 Aug 2020 18:57:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 25/56] KVM: arm64: Compile remaining hyp/ files for both VHE/nVHE
Date:   Wed,  5 Aug 2020 18:56:29 +0100
Message-Id: <20200805175700.62775-26-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Brazdil <dbrazdil@google.com>

The following files in hyp/ contain only code shared by VHE/nVHE:
  vgic-v3-sr.c, aarch32.c, vgic-v2-cpuif-proxy.c, entry.S, fpsimd.S
Compile them under both configurations. Deletions in image-vars.h reflect
eliminated dependencies of nVHE code on the rest of the kernel.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200625131420.71444-14-dbrazdil@google.com
---
 arch/arm64/kernel/image-vars.h   | 29 -----------------------------
 arch/arm64/kvm/hyp/Makefile      | 13 +------------
 arch/arm64/kvm/hyp/nvhe/Makefile |  5 +++--
 arch/arm64/kvm/hyp/vhe/Makefile  |  4 +++-
 4 files changed, 7 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 2757d3512704..9e897c500237 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -63,35 +63,6 @@ __efistub__ctype		= _ctype;
 
 #define KVM_NVHE_ALIAS(sym) __kvm_nvhe_##sym = sym;
 
-/* Symbols defined in aarch32.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(kvm_skip_instr32);
-
-/* Symbols defined in entry.S (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__guest_enter);
-KVM_NVHE_ALIAS(__guest_exit);
-KVM_NVHE_ALIAS(abort_guest_exit_end);
-KVM_NVHE_ALIAS(abort_guest_exit_start);
-
-/* Symbols defined in fpsimd.S (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__fpsimd_restore_state);
-KVM_NVHE_ALIAS(__fpsimd_save_state);
-
-/* Symbols defined in vgic-v2-cpuif-proxy.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__vgic_v2_perform_cpuif_access);
-
-/* Symbols defined in vgic-v3-sr.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__vgic_v3_activate_traps);
-KVM_NVHE_ALIAS(__vgic_v3_deactivate_traps);
-KVM_NVHE_ALIAS(__vgic_v3_get_ich_vtr_el2);
-KVM_NVHE_ALIAS(__vgic_v3_init_lrs);
-KVM_NVHE_ALIAS(__vgic_v3_perform_cpuif_access);
-KVM_NVHE_ALIAS(__vgic_v3_read_vmcr);
-KVM_NVHE_ALIAS(__vgic_v3_restore_aprs);
-KVM_NVHE_ALIAS(__vgic_v3_restore_state);
-KVM_NVHE_ALIAS(__vgic_v3_save_aprs);
-KVM_NVHE_ALIAS(__vgic_v3_save_state);
-KVM_NVHE_ALIAS(__vgic_v3_write_vmcr);
-
 /* Alternative callbacks for init-time patching of nVHE hyp code. */
 KVM_NVHE_ALIAS(arm64_enable_wa2_handling);
 KVM_NVHE_ALIAS(kvm_patch_vector_branch);
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ef1aa7fe8f5a..f54f0e89a71c 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -10,16 +10,5 @@ subdir-ccflags-y := -I$(incdir)				\
 		    -DDISABLE_BRANCH_PROFILING		\
 		    $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
+obj-$(CONFIG_KVM) += vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
-
-hyp-y := vgic-v3-sr.o aarch32.o vgic-v2-cpuif-proxy.o entry.o \
-	 fpsimd.o
-
-# KVM code is run at a different exception code with a different map, so
-# compiler instrumentation that inserts callbacks or checks into the code may
-# cause crashes. Just disable it.
-GCOV_PROFILE	:= n
-KASAN_SANITIZE	:= n
-UBSAN_SANITIZE	:= n
-KCOV_INSTRUMENT	:= n
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 0f4c544f07db..ad8729f5e814 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,8 +6,9 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o \
-	 ../hyp-entry.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
+obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
+	 ../fpsimd.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index a1dbbc5409bd..090fd1e14be2 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,9 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o ../hyp-entry.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
+obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
+	 ../fpsimd.o ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.27.0

