Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F228C1E82C8
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgE2QBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 12:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbgE2QBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 12:01:46 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53661208B8;
        Fri, 29 May 2020 16:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590768105;
        bh=LZ30L6JfHr68OqgXl/j/De7pkTJdoqp2orMzu9RwlW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpP1nSMqOUm1aBOcQsQHfU9QtUiBarRbXGHm1YHZYo93oGxjlPIcV+0NSTUcl/unn
         3bD0sRibgWrrVVHSqk74YROKgQGnQcM4zQ7DgJrG8Trjc12/Q1hhSR0+25vdkfHron
         u00q6GqnNJK04vXQ7vLiMAR4kB91GUqkiG7bTE6Y=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jehS3-00GJKc-PJ; Fri, 29 May 2020 17:01:43 +0100
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
Subject: [PATCH 05/24] KVM: arm64: Clean up kvm makefiles
Date:   Fri, 29 May 2020 17:01:02 +0100
Message-Id: <20200529160121.899083-6-maz@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Consolidate references to the CONFIG_KVM configuration item to encompass
entire folders rather than per line.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200505154520.194120-5-tabba@google.com
---
 arch/arm64/kvm/Makefile     | 38 +++++++++++++------------------------
 arch/arm64/kvm/hyp/Makefile | 15 ++++-----------
 2 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 419696e615b3..8d3d9513cbfe 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -10,30 +10,18 @@ KVM=../../../virt/kvm
 obj-$(CONFIG_KVM) += kvm.o
 obj-$(CONFIG_KVM) += hyp/
 
-kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
-kvm-$(CONFIG_KVM) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
-kvm-$(CONFIG_KVM) += arm.o mmu.o mmio.o
-kvm-$(CONFIG_KVM) += psci.o perf.o
-kvm-$(CONFIG_KVM) += hypercalls.o
-kvm-$(CONFIG_KVM) += pvtime.o
+kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
+	 $(KVM)/vfio.o $(KVM)/irqchip.o \
+	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
+	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o \
+	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
+	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
+	 aarch32.o arch_timer.o \
+	 vgic/vgic.o vgic/vgic-init.o \
+	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
+	 vgic/vgic-v3.o vgic/vgic-v4.o \
+	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
+	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
+	 vgic/vgic-its.o vgic/vgic-debug.o
 
-kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
-kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
-kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
-kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
-kvm-$(CONFIG_KVM) += aarch32.o
-kvm-$(CONFIG_KVM) += arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
-
-kvm-$(CONFIG_KVM) += vgic/vgic.o
-kvm-$(CONFIG_KVM) += vgic/vgic-init.o
-kvm-$(CONFIG_KVM) += vgic/vgic-irqfd.o
-kvm-$(CONFIG_KVM) += vgic/vgic-v2.o
-kvm-$(CONFIG_KVM) += vgic/vgic-v3.o
-kvm-$(CONFIG_KVM) += vgic/vgic-v4.o
-kvm-$(CONFIG_KVM) += vgic/vgic-mmio.o
-kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v2.o
-kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v3.o
-kvm-$(CONFIG_KVM) += vgic/vgic-kvm-device.o
-kvm-$(CONFIG_KVM) += vgic/vgic-its.o
-kvm-$(CONFIG_KVM) += vgic/vgic-debug.o
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 8229e47ba870..8c9880783839 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -6,17 +6,10 @@
 ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 		$(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM) += vgic-v3-sr.o
-obj-$(CONFIG_KVM) += timer-sr.o
-obj-$(CONFIG_KVM) += aarch32.o
-obj-$(CONFIG_KVM) += vgic-v2-cpuif-proxy.o
-obj-$(CONFIG_KVM) += sysreg-sr.o
-obj-$(CONFIG_KVM) += debug-sr.o
-obj-$(CONFIG_KVM) += entry.o
-obj-$(CONFIG_KVM) += switch.o
-obj-$(CONFIG_KVM) += fpsimd.o
-obj-$(CONFIG_KVM) += tlb.o
-obj-$(CONFIG_KVM) += hyp-entry.o
+obj-$(CONFIG_KVM) += hyp.o
+
+hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
+	 debug-sr.o entry.o switch.o fpsimd.o tlb.o hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.26.2

