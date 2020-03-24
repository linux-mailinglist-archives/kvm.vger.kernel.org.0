Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B83E190B16
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 11:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgCXKeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 06:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbgCXKeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 06:34:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B492C208CA;
        Tue, 24 Mar 2020 10:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585046043;
        bh=30h7UlIYcv15SFWwUhObNqqXntK57/pTlMzsWIWSfyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSWhQKpVui7ZWyhh/N3zZsItDEd88ugjJn1JXEGjFX4o3My7oxlsJC33Z+tH4bu7e
         Sf44xgyAyVYBxE3GWwryZ3ccmdMLGH9tTGdXr6n80GYbc8kezOSwzGrW6vPYfvYd4S
         S1d/JJMogzJif0YN/bsd4PNFxi4PKzkN5bwxbTro=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jGgsj-00FE8V-W4; Tue, 24 Mar 2020 10:34:02 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will@kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stefan Agner <stefan@agner.ch>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Takashi Yoshi <takashi@yoshi.email>,
        Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH v2 3/7] arm: Remove 32bit KVM host support
Date:   Tue, 24 Mar 2020 10:33:46 +0000
Message-Id: <20200324103350.138077-4-maz@kernel.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200324103350.138077-1-maz@kernel.org>
References: <20200324103350.138077-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, olof@lixom.net, arnd@arndb.de, will@kernel.org, vladimir.murzin@arm.com, catalin.marinas@arm.com, linus.walleij@linaro.org, christoffer.dall@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, pbonzini@redhat.com, qperret@google.com, linux@arm.linux.org.uk, stefan@agner.ch, jan.kiszka@siemens.com, krzk@kernel.org, b.zolnierkie@samsung.com, m.szyprowski@samsung.com, takashi@yoshi.email, daniel@makrotopia.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

That's it. Remove all references to KVM itself, and document
that although it is no more, the ABI between SVC and HYP still
exists.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Olof Johansson <olof@lixom.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
---
 Documentation/virt/kvm/arm/hyp-abi.rst |    5 +
 arch/arm/include/asm/kvm_arm.h         |  239 ----
 arch/arm/include/asm/kvm_asm.h         |   77 --
 arch/arm/include/asm/kvm_coproc.h      |   36 -
 arch/arm/include/asm/kvm_emulate.h     |  372 ------
 arch/arm/include/asm/kvm_host.h        |  457 --------
 arch/arm/include/asm/kvm_hyp.h         |  127 ---
 arch/arm/include/asm/kvm_mmu.h         |  435 -------
 arch/arm/include/asm/kvm_ras.h         |   14 -
 arch/arm/include/asm/stage2_pgtable.h  |   75 --
 arch/arm/include/asm/virt.h            |    5 -
 arch/arm/include/uapi/asm/kvm.h        |  314 -----
 arch/arm/kernel/asm-offsets.c          |   11 -
 arch/arm/kvm/Kconfig                   |   59 -
 arch/arm/kvm/Makefile                  |   43 -
 arch/arm/kvm/coproc.c                  | 1455 ------------------------
 arch/arm/kvm/coproc.h                  |  130 ---
 arch/arm/kvm/coproc_a15.c              |   39 -
 arch/arm/kvm/coproc_a7.c               |   42 -
 arch/arm/kvm/emulate.c                 |  166 ---
 arch/arm/kvm/guest.c                   |  387 -------
 arch/arm/kvm/handle_exit.c             |  175 ---
 arch/arm/kvm/hyp/Makefile              |   34 -
 arch/arm/kvm/hyp/banked-sr.c           |   70 --
 arch/arm/kvm/hyp/cp15-sr.c             |   72 --
 arch/arm/kvm/hyp/entry.S               |  121 --
 arch/arm/kvm/hyp/hyp-entry.S           |  295 -----
 arch/arm/kvm/hyp/s2-setup.c            |   22 -
 arch/arm/kvm/hyp/switch.c              |  242 ----
 arch/arm/kvm/hyp/tlb.c                 |   68 --
 arch/arm/kvm/hyp/vfp.S                 |   57 -
 arch/arm/kvm/init.S                    |  157 ---
 arch/arm/kvm/interrupts.S              |   36 -
 arch/arm/kvm/irq.h                     |   16 -
 arch/arm/kvm/reset.c                   |   86 --
 arch/arm/kvm/trace.h                   |   86 --
 arch/arm/kvm/vgic-v3-coproc.c          |   27 -
 37 files changed, 5 insertions(+), 6047 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_arm.h
 delete mode 100644 arch/arm/include/asm/kvm_asm.h
 delete mode 100644 arch/arm/include/asm/kvm_coproc.h
 delete mode 100644 arch/arm/include/asm/kvm_emulate.h
 delete mode 100644 arch/arm/include/asm/kvm_host.h
 delete mode 100644 arch/arm/include/asm/kvm_hyp.h
 delete mode 100644 arch/arm/include/asm/kvm_mmu.h
 delete mode 100644 arch/arm/include/asm/kvm_ras.h
 delete mode 100644 arch/arm/include/asm/stage2_pgtable.h
 delete mode 100644 arch/arm/include/uapi/asm/kvm.h
 delete mode 100644 arch/arm/kvm/Kconfig
 delete mode 100644 arch/arm/kvm/Makefile
 delete mode 100644 arch/arm/kvm/coproc.c
 delete mode 100644 arch/arm/kvm/coproc.h
 delete mode 100644 arch/arm/kvm/coproc_a15.c
 delete mode 100644 arch/arm/kvm/coproc_a7.c
 delete mode 100644 arch/arm/kvm/emulate.c
 delete mode 100644 arch/arm/kvm/guest.c
 delete mode 100644 arch/arm/kvm/handle_exit.c
 delete mode 100644 arch/arm/kvm/hyp/Makefile
 delete mode 100644 arch/arm/kvm/hyp/banked-sr.c
 delete mode 100644 arch/arm/kvm/hyp/cp15-sr.c
 delete mode 100644 arch/arm/kvm/hyp/entry.S
 delete mode 100644 arch/arm/kvm/hyp/hyp-entry.S
 delete mode 100644 arch/arm/kvm/hyp/s2-setup.c
 delete mode 100644 arch/arm/kvm/hyp/switch.c
 delete mode 100644 arch/arm/kvm/hyp/tlb.c
 delete mode 100644 arch/arm/kvm/hyp/vfp.S
 delete mode 100644 arch/arm/kvm/init.S
 delete mode 100644 arch/arm/kvm/interrupts.S
 delete mode 100644 arch/arm/kvm/irq.h
 delete mode 100644 arch/arm/kvm/reset.c
 delete mode 100644 arch/arm/kvm/trace.h
 delete mode 100644 arch/arm/kvm/vgic-v3-coproc.c

diff --git a/Documentation/virt/kvm/arm/hyp-abi.rst b/Documentation/virt/kvm/arm/hyp-abi.rst
index d1fc27d848e9..d9eba93aa364 100644
--- a/Documentation/virt/kvm/arm/hyp-abi.rst
+++ b/Documentation/virt/kvm/arm/hyp-abi.rst
@@ -11,6 +11,11 @@ hypervisor when running as a guest (under Xen, KVM or any other
 hypervisor), or any hypervisor-specific interaction when the kernel is
 used as a host.
 
+Note: KVM/arm has been removed from the kernel. The API described
+here is still valid though, as it allows the kernel to kexec when
+booted at HYP. It can also be used by a hypervisor other than KVM
+if necessary.
+
 On arm and arm64 (without VHE), the kernel doesn't run in hypervisor
 mode, but still needs to interact with it, allowing a built-in
 hypervisor to be either installed or torn down.
diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
deleted file mode 100644
index 9c04bd810d07..000000000000
diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
deleted file mode 100644
index f615830f9f57..000000000000
diff --git a/arch/arm/include/asm/kvm_coproc.h b/arch/arm/include/asm/kvm_coproc.h
deleted file mode 100644
index a23826117dd6..000000000000
diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
deleted file mode 100644
index 3944305e81df..000000000000
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
deleted file mode 100644
index 3da57e863df6..000000000000
diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
deleted file mode 100644
index 3c1b55ecc578..000000000000
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
deleted file mode 100644
index 0d84d50bf9ba..000000000000
diff --git a/arch/arm/include/asm/kvm_ras.h b/arch/arm/include/asm/kvm_ras.h
deleted file mode 100644
index e9577292dfe4..000000000000
diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
deleted file mode 100644
index aaceec7855ec..000000000000
diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index 17c26ccd126d..6cd4e33418e9 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -67,11 +67,6 @@ static inline bool is_kernel_in_hyp_mode(void)
 	return false;
 }
 
-static inline bool has_vhe(void)
-{
-	return false;
-}
-
 /* The section containing the hypervisor idmap text */
 extern char __hyp_idmap_text_start[];
 extern char __hyp_idmap_text_end[];
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
deleted file mode 100644
index 03cd7c19a683..000000000000
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index c773b829ee8e..c036a4a2f8e2 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -11,9 +11,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
-#ifdef CONFIG_KVM_ARM_HOST
-#include <linux/kvm_host.h>
-#endif
 #include <asm/cacheflush.h>
 #include <asm/glue-df.h>
 #include <asm/glue-pf.h>
@@ -167,14 +164,6 @@ int main(void)
   DEFINE(CACHE_WRITEBACK_ORDER, __CACHE_WRITEBACK_ORDER);
   DEFINE(CACHE_WRITEBACK_GRANULE, __CACHE_WRITEBACK_GRANULE);
   BLANK();
-#ifdef CONFIG_KVM_ARM_HOST
-  DEFINE(VCPU_GUEST_CTXT,	offsetof(struct kvm_vcpu, arch.ctxt));
-  DEFINE(VCPU_HOST_CTXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
-  DEFINE(CPU_CTXT_VFP,		offsetof(struct kvm_cpu_context, vfp));
-  DEFINE(CPU_CTXT_GP_REGS,	offsetof(struct kvm_cpu_context, gp_regs));
-  DEFINE(GP_REGS_USR,		offsetof(struct kvm_regs, usr_regs));
-#endif
-  BLANK();
 #ifdef CONFIG_VDSO
   DEFINE(VDSO_DATA_SIZE,	sizeof(union vdso_data_store));
 #endif
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
deleted file mode 100644
index f591026347a5..000000000000
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
deleted file mode 100644
index e442d82821df..000000000000
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
deleted file mode 100644
index 07745ee022a1..000000000000
diff --git a/arch/arm/kvm/coproc.h b/arch/arm/kvm/coproc.h
deleted file mode 100644
index 637065b13012..000000000000
diff --git a/arch/arm/kvm/coproc_a15.c b/arch/arm/kvm/coproc_a15.c
deleted file mode 100644
index 36bf15421ae8..000000000000
diff --git a/arch/arm/kvm/coproc_a7.c b/arch/arm/kvm/coproc_a7.c
deleted file mode 100644
index 40f643e1e05c..000000000000
diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
deleted file mode 100644
index 29bb852140c5..000000000000
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
deleted file mode 100644
index 9f7ae0d8690f..000000000000
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
deleted file mode 100644
index e58a89d2f13f..000000000000
diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
deleted file mode 100644
index ba88b1eca93c..000000000000
diff --git a/arch/arm/kvm/hyp/banked-sr.c b/arch/arm/kvm/hyp/banked-sr.c
deleted file mode 100644
index c4632ed9e819..000000000000
diff --git a/arch/arm/kvm/hyp/cp15-sr.c b/arch/arm/kvm/hyp/cp15-sr.c
deleted file mode 100644
index e6923306f698..000000000000
diff --git a/arch/arm/kvm/hyp/entry.S b/arch/arm/kvm/hyp/entry.S
deleted file mode 100644
index 4bd1f6a74180..000000000000
diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
deleted file mode 100644
index fe3d7811a908..000000000000
diff --git a/arch/arm/kvm/hyp/s2-setup.c b/arch/arm/kvm/hyp/s2-setup.c
deleted file mode 100644
index 5dfbea5adf65..000000000000
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
deleted file mode 100644
index 1efeef3fd0ee..000000000000
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
deleted file mode 100644
index 848f27bbad9d..000000000000
diff --git a/arch/arm/kvm/hyp/vfp.S b/arch/arm/kvm/hyp/vfp.S
deleted file mode 100644
index 675a52348d8d..000000000000
diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
deleted file mode 100644
index 33e34b6d24b2..000000000000
diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
deleted file mode 100644
index 064f4f118ca7..000000000000
diff --git a/arch/arm/kvm/irq.h b/arch/arm/kvm/irq.h
deleted file mode 100644
index 0d257de42c10..000000000000
diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
deleted file mode 100644
index eb4174f6ebbd..000000000000
diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
deleted file mode 100644
index 69a9d62a0ac6..000000000000
diff --git a/arch/arm/kvm/vgic-v3-coproc.c b/arch/arm/kvm/vgic-v3-coproc.c
deleted file mode 100644
index ed3b2e4759ce..000000000000
-- 
2.25.0

