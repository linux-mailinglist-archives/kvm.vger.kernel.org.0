Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AC21E82C0
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 18:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgE2QBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 12:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgE2QBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 12:01:43 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A1B320814;
        Fri, 29 May 2020 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590768102;
        bh=E/PuPpWmiPrQz16kOxC09voxVIFgWpR67AwcFCKj6rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UylOJdpa2G1BF+AHK7NO2WL2jQiwDyDLUoEmpUqst5UC3OjK9JRO6kL5hSC1pyEns
         SS2IMjCSwOpsHzkf79GE/Nrn36yTdzm2/AE+hI6AslyO+1FcFbIdRBI4O/OWYCKkq1
         rtw26Zo64Px2CpAq+xE6hYEvF94pVpxF8My9c2Tc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jehS0-00GJKc-WB; Fri, 29 May 2020 17:01:41 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Jiang Yi <giangyi@amazon.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 02/24] KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
Date:   Fri, 29 May 2020 17:00:59 +0100
Message-Id: <20200529160121.899083-3-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com, dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com, zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Will Deacon <will@kernel.org>

CONFIG_KVM_ARM_HOST is just a proxy for CONFIG_KVM, so remove it in favour
of the latter.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200505154520.194120-2-tabba@google.com
---
 arch/arm64/kernel/asm-offsets.c |  2 +-
 arch/arm64/kernel/cpu_errata.c  |  2 +-
 arch/arm64/kernel/smp.c         |  2 +-
 arch/arm64/kvm/Kconfig          |  6 ----
 arch/arm64/kvm/Makefile         | 52 ++++++++++++++++-----------------
 arch/arm64/kvm/hyp/Makefile     | 22 +++++++-------
 6 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 9981a0a5a87f..a27e0cd731e9 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -96,7 +96,7 @@ int main(void)
   DEFINE(CPU_BOOT_PTRAUTH_KEY,	offsetof(struct secondary_data, ptrauth_key));
 #endif
   BLANK();
-#ifdef CONFIG_KVM_ARM_HOST
+#ifdef CONFIG_KVM
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index df56d2295d16..a102321fc8a2 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -234,7 +234,7 @@ static int detect_harden_bp_fw(void)
 		smccc_end = NULL;
 		break;
 
-#if IS_ENABLED(CONFIG_KVM_ARM_HOST)
+#if IS_ENABLED(CONFIG_KVM)
 	case SMCCC_CONDUIT_SMC:
 		cb = call_smc_arch_workaround_1;
 		smccc_start = __smccc_workaround_1_smc;
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 061f60fe452f..0a3045d9f33f 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -430,7 +430,7 @@ static void __init hyp_mode_check(void)
 			   "CPU: CPUs started in inconsistent modes");
 	else
 		pr_info("CPU: All CPU(s) started at EL1\n");
-	if (IS_ENABLED(CONFIG_KVM_ARM_HOST))
+	if (IS_ENABLED(CONFIG_KVM))
 		kvm_compute_layout();
 }
 
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449386d76441..ce724e526689 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -28,7 +28,6 @@ config KVM
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
-	select KVM_ARM_HOST
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select SRCU
 	select KVM_VFIO
@@ -50,11 +49,6 @@ config KVM
 
 	  If unsure, say N.
 
-config KVM_ARM_HOST
-	bool
-	---help---
-	  Provides host support for ARM processors.
-
 config KVM_ARM_PMU
 	bool
 	---help---
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 7a3768538343..419696e615b3 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -7,33 +7,33 @@ ccflags-y += -I $(srctree)/$(src)
 
 KVM=../../../virt/kvm
 
-obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
-obj-$(CONFIG_KVM_ARM_HOST) += hyp/
+obj-$(CONFIG_KVM) += kvm.o
+obj-$(CONFIG_KVM) += hyp/
 
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
-kvm-$(CONFIG_KVM_ARM_HOST) += arm.o mmu.o mmio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += psci.o perf.o
-kvm-$(CONFIG_KVM_ARM_HOST) += hypercalls.o
-kvm-$(CONFIG_KVM_ARM_HOST) += pvtime.o
+kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
+kvm-$(CONFIG_KVM) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
+kvm-$(CONFIG_KVM) += arm.o mmu.o mmio.o
+kvm-$(CONFIG_KVM) += psci.o perf.o
+kvm-$(CONFIG_KVM) += hypercalls.o
+kvm-$(CONFIG_KVM) += pvtime.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
-kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
-kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o pmu.o
-kvm-$(CONFIG_KVM_ARM_HOST) += aarch32.o
-kvm-$(CONFIG_KVM_ARM_HOST) += arch_timer.o
+kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
+kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
+kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
+kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
+kvm-$(CONFIG_KVM) += aarch32.o
+kvm-$(CONFIG_KVM) += arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-init.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-irqfd.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v2.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v3.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v4.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio-v2.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio-v3.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-kvm-device.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-its.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-debug.o
+kvm-$(CONFIG_KVM) += vgic/vgic.o
+kvm-$(CONFIG_KVM) += vgic/vgic-init.o
+kvm-$(CONFIG_KVM) += vgic/vgic-irqfd.o
+kvm-$(CONFIG_KVM) += vgic/vgic-v2.o
+kvm-$(CONFIG_KVM) += vgic/vgic-v3.o
+kvm-$(CONFIG_KVM) += vgic/vgic-v4.o
+kvm-$(CONFIG_KVM) += vgic/vgic-mmio.o
+kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v2.o
+kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v3.o
+kvm-$(CONFIG_KVM) += vgic/vgic-kvm-device.o
+kvm-$(CONFIG_KVM) += vgic/vgic-its.o
+kvm-$(CONFIG_KVM) += vgic/vgic-debug.o
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index dc18274a6826..8229e47ba870 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -6,17 +6,17 @@
 ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 		$(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += aarch32.o
-obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-cpuif-proxy.o
-obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += entry.o
-obj-$(CONFIG_KVM_ARM_HOST) += switch.o
-obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
-obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
-obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
+obj-$(CONFIG_KVM) += vgic-v3-sr.o
+obj-$(CONFIG_KVM) += timer-sr.o
+obj-$(CONFIG_KVM) += aarch32.o
+obj-$(CONFIG_KVM) += vgic-v2-cpuif-proxy.o
+obj-$(CONFIG_KVM) += sysreg-sr.o
+obj-$(CONFIG_KVM) += debug-sr.o
+obj-$(CONFIG_KVM) += entry.o
+obj-$(CONFIG_KVM) += switch.o
+obj-$(CONFIG_KVM) += fpsimd.o
+obj-$(CONFIG_KVM) += tlb.o
+obj-$(CONFIG_KVM) += hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.26.2

