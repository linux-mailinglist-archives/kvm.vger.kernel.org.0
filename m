Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B6554C65C
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 12:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350483AbiFOKk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 06:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbiFOKky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 06:40:54 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695DB50B02
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 03:40:52 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id z14so6868382pgh.0
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 03:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dji2CV55v/GE9ijLdL3IMDzlu/25n1Y2pBLlWhseCNU=;
        b=EPAvh3cE+eflsCwJwXK/YPbJzenVnkHaLENUmrdXJYSJYBH8WAGSCppDYudDhnmsx4
         AJE+qO00FD9AINlQPFJTs7M+2H6cZ+eSrv4K+WVvJb+6SEZGkpQ/tQ0oXpGUZGgwxrZf
         wVXZuB84H3XlIkoWMt28o7sdzrLQdu9lNXeaK3l/FiTxP3nNBQgduzxl122+qTMHCivj
         JVtyay+tiOb7zGULhC37/Ip0eDozDZZMOi4SvDNc8tcWaGLswsYLJ+9tk7AcTjIoM0pq
         BVJ96B9tnEs6tvbZKbDSnRxFJc9y9zJ9DkVf8tBCKEvVhim0/t9kQ+UTWyYu93mFyL/r
         Chpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dji2CV55v/GE9ijLdL3IMDzlu/25n1Y2pBLlWhseCNU=;
        b=V1asShAeCxzS02MPv8kU5m34g3eu508w6krx6d5vTlgAHTtFf0CYYx8xvReEgjBJW2
         l8BZor5WxLZVfvyVDEXXipCJpXZ+ic2iqrYs1CY02aMFbzkXKqts1aeXzw8ZcPrUFw8R
         HwRhbF6nxvtdr4Dd6kZu37sRksvazVuLZgNFXVOjGA3gnTu+McFX26i/tbK+rEpV1pB5
         9UdxdaMwic58IjdzC0ivWAU43HGE7f3hriqK1OSjX8UYprjYrEc5cOQrZx0bw9feGZ4c
         cA+nIsuUhYRhb9JjvaaQST/O7zh8fCYev7iyfUcK/xy7i0qlfIpFo0L7m//Eyy0GJBoY
         48uw==
X-Gm-Message-State: AOAM533zOhlgGppk/Pi56T2CXC2eb6kewVcn32meJR5s1CjQuj/ZbKqJ
        lYiqlcdhKCC4jECrcyNgaf0+kw==
X-Google-Smtp-Source: ABdhPJwBdYuabNIjZOO9RDoKg0NPtl2WPiLOLC61kEyaJ2cj8GYfMIFpgbT0EhGKrIZuocuIxNUnkA==
X-Received: by 2002:a63:86c7:0:b0:3fd:9822:d1ae with SMTP id x190-20020a6386c7000000b003fd9822d1aemr8182347pgd.609.1655289651527;
        Wed, 15 Jun 2022 03:40:51 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.104.191])
        by smtp.gmail.com with ESMTPSA id i19-20020a056a00225300b00522c365225csm1427273pfu.3.2022.06.15.03.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:40:50 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 1/3] RISC-V: KVM: Factor-out instruction emulation into separate sources
Date:   Wed, 15 Jun 2022 16:10:23 +0530
Message-Id: <20220615104025.941382-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220615104025.941382-1-apatel@ventanamicro.com>
References: <20220615104025.941382-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The instruction and CSR emulation for VCPU is going to grow over time
due to upcoming AIA, PMU, Nested and other virtualization features.

Let us factor-out VCPU instruction emulation from vcpu_exit.c to a
separate source dedicated for this purpose.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h           |  11 +-
 arch/riscv/include/asm/kvm_vcpu_insn.h      |  33 ++
 arch/riscv/kvm/Makefile                     |   1 +
 arch/riscv/kvm/vcpu_exit.c                  | 490 +-------------------
 arch/riscv/kvm/{vcpu_exit.c => vcpu_insn.c} | 309 +++---------
 5 files changed, 101 insertions(+), 743 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_insn.h
 copy arch/riscv/kvm/{vcpu_exit.c => vcpu_insn.c} (67%)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 319c8aeb42af..03103b86dd86 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <asm/csr.h>
 #include <asm/kvm_vcpu_fp.h>
+#include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_timer.h>
 
 #define KVM_MAX_VCPUS			1024
@@ -90,14 +91,6 @@ struct kvm_arch {
 	struct kvm_guest_timer timer;
 };
 
-struct kvm_mmio_decode {
-	unsigned long insn;
-	int insn_len;
-	int len;
-	int shift;
-	int return_handled;
-};
-
 struct kvm_sbi_context {
 	int return_handled;
 };
@@ -303,14 +296,12 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
 
 void __kvm_riscv_unpriv_trap(void);
 
-void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu);
 unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
 					 bool read_insn,
 					 unsigned long guest_addr,
 					 struct kvm_cpu_trap *trap);
 void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
 				  struct kvm_cpu_trap *trap);
-int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap);
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_insn.h b/arch/riscv/include/asm/kvm_vcpu_insn.h
new file mode 100644
index 000000000000..4e3ba4e84d0f
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_insn.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022 Ventana Micro Systems Inc.
+ */
+
+#ifndef __KVM_VCPU_RISCV_INSN_H
+#define __KVM_VCPU_RISCV_INSN_H
+
+struct kvm_vcpu;
+struct kvm_run;
+struct kvm_cpu_trap;
+
+struct kvm_mmio_decode {
+	unsigned long insn;
+	int insn_len;
+	int len;
+	int shift;
+	int return_handled;
+};
+
+void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				struct kvm_cpu_trap *trap);
+
+int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			     unsigned long fault_addr,
+			     unsigned long htinst);
+int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			      unsigned long fault_addr,
+			      unsigned long htinst);
+int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+
+#endif
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index e5c56182f48f..019df9208bdd 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -17,6 +17,7 @@ kvm-y += mmu.o
 kvm-y += vcpu.o
 kvm-y += vcpu_exit.o
 kvm-y += vcpu_fp.o
+kvm-y += vcpu_insn.o
 kvm-y += vcpu_switch.o
 kvm-y += vcpu_sbi.o
 kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index dbb09afd7546..c364128787be 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -6,412 +6,9 @@
  *     Anup Patel <anup.patel@wdc.com>
  */
 
-#include <linux/bitops.h>
-#include <linux/errno.h>
-#include <linux/err.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
 
-#define INSN_OPCODE_MASK	0x007c
-#define INSN_OPCODE_SHIFT	2
-#define INSN_OPCODE_SYSTEM	28
-
-#define INSN_MASK_WFI		0xffffffff
-#define INSN_MATCH_WFI		0x10500073
-
-#define INSN_MATCH_LB		0x3
-#define INSN_MASK_LB		0x707f
-#define INSN_MATCH_LH		0x1003
-#define INSN_MASK_LH		0x707f
-#define INSN_MATCH_LW		0x2003
-#define INSN_MASK_LW		0x707f
-#define INSN_MATCH_LD		0x3003
-#define INSN_MASK_LD		0x707f
-#define INSN_MATCH_LBU		0x4003
-#define INSN_MASK_LBU		0x707f
-#define INSN_MATCH_LHU		0x5003
-#define INSN_MASK_LHU		0x707f
-#define INSN_MATCH_LWU		0x6003
-#define INSN_MASK_LWU		0x707f
-#define INSN_MATCH_SB		0x23
-#define INSN_MASK_SB		0x707f
-#define INSN_MATCH_SH		0x1023
-#define INSN_MASK_SH		0x707f
-#define INSN_MATCH_SW		0x2023
-#define INSN_MASK_SW		0x707f
-#define INSN_MATCH_SD		0x3023
-#define INSN_MASK_SD		0x707f
-
-#define INSN_MATCH_C_LD		0x6000
-#define INSN_MASK_C_LD		0xe003
-#define INSN_MATCH_C_SD		0xe000
-#define INSN_MASK_C_SD		0xe003
-#define INSN_MATCH_C_LW		0x4000
-#define INSN_MASK_C_LW		0xe003
-#define INSN_MATCH_C_SW		0xc000
-#define INSN_MASK_C_SW		0xe003
-#define INSN_MATCH_C_LDSP	0x6002
-#define INSN_MASK_C_LDSP	0xe003
-#define INSN_MATCH_C_SDSP	0xe002
-#define INSN_MASK_C_SDSP	0xe003
-#define INSN_MATCH_C_LWSP	0x4002
-#define INSN_MASK_C_LWSP	0xe003
-#define INSN_MATCH_C_SWSP	0xc002
-#define INSN_MASK_C_SWSP	0xe003
-
-#define INSN_16BIT_MASK		0x3
-
-#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
-
-#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)
-
-#ifdef CONFIG_64BIT
-#define LOG_REGBYTES		3
-#else
-#define LOG_REGBYTES		2
-#endif
-#define REGBYTES		(1 << LOG_REGBYTES)
-
-#define SH_RD			7
-#define SH_RS1			15
-#define SH_RS2			20
-#define SH_RS2C			2
-
-#define RV_X(x, s, n)		(((x) >> (s)) & ((1 << (n)) - 1))
-#define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
-				 (RV_X(x, 10, 3) << 3) | \
-				 (RV_X(x, 5, 1) << 6))
-#define RVC_LD_IMM(x)		((RV_X(x, 10, 3) << 3) | \
-				 (RV_X(x, 5, 2) << 6))
-#define RVC_LWSP_IMM(x)		((RV_X(x, 4, 3) << 2) | \
-				 (RV_X(x, 12, 1) << 5) | \
-				 (RV_X(x, 2, 2) << 6))
-#define RVC_LDSP_IMM(x)		((RV_X(x, 5, 2) << 3) | \
-				 (RV_X(x, 12, 1) << 5) | \
-				 (RV_X(x, 2, 3) << 6))
-#define RVC_SWSP_IMM(x)		((RV_X(x, 9, 4) << 2) | \
-				 (RV_X(x, 7, 2) << 6))
-#define RVC_SDSP_IMM(x)		((RV_X(x, 10, 3) << 3) | \
-				 (RV_X(x, 7, 3) << 6))
-#define RVC_RS1S(insn)		(8 + RV_X(insn, SH_RD, 3))
-#define RVC_RS2S(insn)		(8 + RV_X(insn, SH_RS2C, 3))
-#define RVC_RS2(insn)		RV_X(insn, SH_RS2C, 5)
-
-#define SHIFT_RIGHT(x, y)		\
-	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
-
-#define REG_MASK			\
-	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
-
-#define REG_OFFSET(insn, pos)		\
-	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
-
-#define REG_PTR(insn, pos, regs)	\
-	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
-
-#define GET_RM(insn)		(((insn) >> 12) & 7)
-
-#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
-#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
-#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
-#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
-#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
-#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
-#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) = (val))
-#define IMM_I(insn)		((s32)(insn) >> 20)
-#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
-				 (s32)(((insn) >> 7) & 0x1f))
-#define MASK_FUNCT3		0x7000
-
-static int truly_illegal_insn(struct kvm_vcpu *vcpu,
-			      struct kvm_run *run,
-			      ulong insn)
-{
-	struct kvm_cpu_trap utrap = { 0 };
-
-	/* Redirect trap to Guest VCPU */
-	utrap.sepc = vcpu->arch.guest_context.sepc;
-	utrap.scause = EXC_INST_ILLEGAL;
-	utrap.stval = insn;
-	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-
-	return 1;
-}
-
-static int system_opcode_insn(struct kvm_vcpu *vcpu,
-			      struct kvm_run *run,
-			      ulong insn)
-{
-	if ((insn & INSN_MASK_WFI) == INSN_MATCH_WFI) {
-		vcpu->stat.wfi_exit_stat++;
-		kvm_riscv_vcpu_wfi(vcpu);
-		vcpu->arch.guest_context.sepc += INSN_LEN(insn);
-		return 1;
-	}
-
-	return truly_illegal_insn(vcpu, run, insn);
-}
-
-static int virtual_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			      struct kvm_cpu_trap *trap)
-{
-	unsigned long insn = trap->stval;
-	struct kvm_cpu_trap utrap = { 0 };
-	struct kvm_cpu_context *ct;
-
-	if (unlikely(INSN_IS_16BIT(insn))) {
-		if (insn == 0) {
-			ct = &vcpu->arch.guest_context;
-			insn = kvm_riscv_vcpu_unpriv_read(vcpu, true,
-							  ct->sepc,
-							  &utrap);
-			if (utrap.scause) {
-				utrap.sepc = ct->sepc;
-				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-				return 1;
-			}
-		}
-		if (INSN_IS_16BIT(insn))
-			return truly_illegal_insn(vcpu, run, insn);
-	}
-
-	switch ((insn & INSN_OPCODE_MASK) >> INSN_OPCODE_SHIFT) {
-	case INSN_OPCODE_SYSTEM:
-		return system_opcode_insn(vcpu, run, insn);
-	default:
-		return truly_illegal_insn(vcpu, run, insn);
-	}
-}
-
-static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			unsigned long fault_addr, unsigned long htinst)
-{
-	u8 data_buf[8];
-	unsigned long insn;
-	int shift = 0, len = 0, insn_len = 0;
-	struct kvm_cpu_trap utrap = { 0 };
-	struct kvm_cpu_context *ct = &vcpu->arch.guest_context;
-
-	/* Determine trapped instruction */
-	if (htinst & 0x1) {
-		/*
-		 * Bit[0] == 1 implies trapped instruction value is
-		 * transformed instruction or custom instruction.
-		 */
-		insn = htinst | INSN_16BIT_MASK;
-		insn_len = (htinst & BIT(1)) ? INSN_LEN(insn) : 2;
-	} else {
-		/*
-		 * Bit[0] == 0 implies trapped instruction value is
-		 * zero or special value.
-		 */
-		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
-						  &utrap);
-		if (utrap.scause) {
-			/* Redirect trap if we failed to read instruction */
-			utrap.sepc = ct->sepc;
-			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-			return 1;
-		}
-		insn_len = INSN_LEN(insn);
-	}
-
-	/* Decode length of MMIO and shift */
-	if ((insn & INSN_MASK_LW) == INSN_MATCH_LW) {
-		len = 4;
-		shift = 8 * (sizeof(ulong) - len);
-	} else if ((insn & INSN_MASK_LB) == INSN_MATCH_LB) {
-		len = 1;
-		shift = 8 * (sizeof(ulong) - len);
-	} else if ((insn & INSN_MASK_LBU) == INSN_MATCH_LBU) {
-		len = 1;
-		shift = 8 * (sizeof(ulong) - len);
-#ifdef CONFIG_64BIT
-	} else if ((insn & INSN_MASK_LD) == INSN_MATCH_LD) {
-		len = 8;
-		shift = 8 * (sizeof(ulong) - len);
-	} else if ((insn & INSN_MASK_LWU) == INSN_MATCH_LWU) {
-		len = 4;
-#endif
-	} else if ((insn & INSN_MASK_LH) == INSN_MATCH_LH) {
-		len = 2;
-		shift = 8 * (sizeof(ulong) - len);
-	} else if ((insn & INSN_MASK_LHU) == INSN_MATCH_LHU) {
-		len = 2;
-#ifdef CONFIG_64BIT
-	} else if ((insn & INSN_MASK_C_LD) == INSN_MATCH_C_LD) {
-		len = 8;
-		shift = 8 * (sizeof(ulong) - len);
-		insn = RVC_RS2S(insn) << SH_RD;
-	} else if ((insn & INSN_MASK_C_LDSP) == INSN_MATCH_C_LDSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
-		len = 8;
-		shift = 8 * (sizeof(ulong) - len);
-#endif
-	} else if ((insn & INSN_MASK_C_LW) == INSN_MATCH_C_LW) {
-		len = 4;
-		shift = 8 * (sizeof(ulong) - len);
-		insn = RVC_RS2S(insn) << SH_RD;
-	} else if ((insn & INSN_MASK_C_LWSP) == INSN_MATCH_C_LWSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
-		len = 4;
-		shift = 8 * (sizeof(ulong) - len);
-	} else {
-		return -EOPNOTSUPP;
-	}
-
-	/* Fault address should be aligned to length of MMIO */
-	if (fault_addr & (len - 1))
-		return -EIO;
-
-	/* Save instruction decode info */
-	vcpu->arch.mmio_decode.insn = insn;
-	vcpu->arch.mmio_decode.insn_len = insn_len;
-	vcpu->arch.mmio_decode.shift = shift;
-	vcpu->arch.mmio_decode.len = len;
-	vcpu->arch.mmio_decode.return_handled = 0;
-
-	/* Update MMIO details in kvm_run struct */
-	run->mmio.is_write = false;
-	run->mmio.phys_addr = fault_addr;
-	run->mmio.len = len;
-
-	/* Try to handle MMIO access in the kernel */
-	if (!kvm_io_bus_read(vcpu, KVM_MMIO_BUS, fault_addr, len, data_buf)) {
-		/* Successfully handled MMIO access in the kernel so resume */
-		memcpy(run->mmio.data, data_buf, len);
-		vcpu->stat.mmio_exit_kernel++;
-		kvm_riscv_vcpu_mmio_return(vcpu, run);
-		return 1;
-	}
-
-	/* Exit to userspace for MMIO emulation */
-	vcpu->stat.mmio_exit_user++;
-	run->exit_reason = KVM_EXIT_MMIO;
-
-	return 0;
-}
-
-static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			 unsigned long fault_addr, unsigned long htinst)
-{
-	u8 data8;
-	u16 data16;
-	u32 data32;
-	u64 data64;
-	ulong data;
-	unsigned long insn;
-	int len = 0, insn_len = 0;
-	struct kvm_cpu_trap utrap = { 0 };
-	struct kvm_cpu_context *ct = &vcpu->arch.guest_context;
-
-	/* Determine trapped instruction */
-	if (htinst & 0x1) {
-		/*
-		 * Bit[0] == 1 implies trapped instruction value is
-		 * transformed instruction or custom instruction.
-		 */
-		insn = htinst | INSN_16BIT_MASK;
-		insn_len = (htinst & BIT(1)) ? INSN_LEN(insn) : 2;
-	} else {
-		/*
-		 * Bit[0] == 0 implies trapped instruction value is
-		 * zero or special value.
-		 */
-		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
-						  &utrap);
-		if (utrap.scause) {
-			/* Redirect trap if we failed to read instruction */
-			utrap.sepc = ct->sepc;
-			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-			return 1;
-		}
-		insn_len = INSN_LEN(insn);
-	}
-
-	data = GET_RS2(insn, &vcpu->arch.guest_context);
-	data8 = data16 = data32 = data64 = data;
-
-	if ((insn & INSN_MASK_SW) == INSN_MATCH_SW) {
-		len = 4;
-	} else if ((insn & INSN_MASK_SB) == INSN_MATCH_SB) {
-		len = 1;
-#ifdef CONFIG_64BIT
-	} else if ((insn & INSN_MASK_SD) == INSN_MATCH_SD) {
-		len = 8;
-#endif
-	} else if ((insn & INSN_MASK_SH) == INSN_MATCH_SH) {
-		len = 2;
-#ifdef CONFIG_64BIT
-	} else if ((insn & INSN_MASK_C_SD) == INSN_MATCH_C_SD) {
-		len = 8;
-		data64 = GET_RS2S(insn, &vcpu->arch.guest_context);
-	} else if ((insn & INSN_MASK_C_SDSP) == INSN_MATCH_C_SDSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
-		len = 8;
-		data64 = GET_RS2C(insn, &vcpu->arch.guest_context);
-#endif
-	} else if ((insn & INSN_MASK_C_SW) == INSN_MATCH_C_SW) {
-		len = 4;
-		data32 = GET_RS2S(insn, &vcpu->arch.guest_context);
-	} else if ((insn & INSN_MASK_C_SWSP) == INSN_MATCH_C_SWSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
-		len = 4;
-		data32 = GET_RS2C(insn, &vcpu->arch.guest_context);
-	} else {
-		return -EOPNOTSUPP;
-	}
-
-	/* Fault address should be aligned to length of MMIO */
-	if (fault_addr & (len - 1))
-		return -EIO;
-
-	/* Save instruction decode info */
-	vcpu->arch.mmio_decode.insn = insn;
-	vcpu->arch.mmio_decode.insn_len = insn_len;
-	vcpu->arch.mmio_decode.shift = 0;
-	vcpu->arch.mmio_decode.len = len;
-	vcpu->arch.mmio_decode.return_handled = 0;
-
-	/* Copy data to kvm_run instance */
-	switch (len) {
-	case 1:
-		*((u8 *)run->mmio.data) = data8;
-		break;
-	case 2:
-		*((u16 *)run->mmio.data) = data16;
-		break;
-	case 4:
-		*((u32 *)run->mmio.data) = data32;
-		break;
-	case 8:
-		*((u64 *)run->mmio.data) = data64;
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	/* Update MMIO details in kvm_run struct */
-	run->mmio.is_write = true;
-	run->mmio.phys_addr = fault_addr;
-	run->mmio.len = len;
-
-	/* Try to handle MMIO access in the kernel */
-	if (!kvm_io_bus_write(vcpu, KVM_MMIO_BUS,
-			      fault_addr, len, run->mmio.data)) {
-		/* Successfully handled MMIO access in the kernel so resume */
-		vcpu->stat.mmio_exit_kernel++;
-		kvm_riscv_vcpu_mmio_return(vcpu, run);
-		return 1;
-	}
-
-	/* Exit to userspace for MMIO emulation */
-	vcpu->stat.mmio_exit_user++;
-	run->exit_reason = KVM_EXIT_MMIO;
-
-	return 0;
-}
-
 static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			     struct kvm_cpu_trap *trap)
 {
@@ -430,11 +27,13 @@ static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	    (trap->scause == EXC_STORE_GUEST_PAGE_FAULT && !writeable)) {
 		switch (trap->scause) {
 		case EXC_LOAD_GUEST_PAGE_FAULT:
-			return emulate_load(vcpu, run, fault_addr,
-					    trap->htinst);
+			return kvm_riscv_vcpu_mmio_load(vcpu, run,
+							fault_addr,
+							trap->htinst);
 		case EXC_STORE_GUEST_PAGE_FAULT:
-			return emulate_store(vcpu, run, fault_addr,
-					     trap->htinst);
+			return kvm_riscv_vcpu_mmio_store(vcpu, run,
+							 fault_addr,
+							 trap->htinst);
 		default:
 			return -EOPNOTSUPP;
 		};
@@ -448,21 +47,6 @@ static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	return 1;
 }
 
-/**
- * kvm_riscv_vcpu_wfi -- Emulate wait for interrupt (WFI) behaviour
- *
- * @vcpu: The VCPU pointer
- */
-void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
-{
-	if (!kvm_arch_vcpu_runnable(vcpu)) {
-		kvm_vcpu_srcu_read_unlock(vcpu);
-		kvm_vcpu_halt(vcpu);
-		kvm_vcpu_srcu_read_lock(vcpu);
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
-	}
-}
-
 /**
  * kvm_riscv_vcpu_unpriv_read -- Read machine word from Guest memory
  *
@@ -601,66 +185,6 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
 	vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
 }
 
-/**
- * kvm_riscv_vcpu_mmio_return -- Handle MMIO loads after user space emulation
- *			     or in-kernel IO emulation
- *
- * @vcpu: The VCPU pointer
- * @run:  The VCPU run struct containing the mmio data
- */
-int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	u8 data8;
-	u16 data16;
-	u32 data32;
-	u64 data64;
-	ulong insn;
-	int len, shift;
-
-	if (vcpu->arch.mmio_decode.return_handled)
-		return 0;
-
-	vcpu->arch.mmio_decode.return_handled = 1;
-	insn = vcpu->arch.mmio_decode.insn;
-
-	if (run->mmio.is_write)
-		goto done;
-
-	len = vcpu->arch.mmio_decode.len;
-	shift = vcpu->arch.mmio_decode.shift;
-
-	switch (len) {
-	case 1:
-		data8 = *((u8 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data8 << shift >> shift);
-		break;
-	case 2:
-		data16 = *((u16 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data16 << shift >> shift);
-		break;
-	case 4:
-		data32 = *((u32 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data32 << shift >> shift);
-		break;
-	case 8:
-		data64 = *((u64 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data64 << shift >> shift);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-done:
-	/* Move to next instruction */
-	vcpu->arch.guest_context.sepc += vcpu->arch.mmio_decode.insn_len;
-
-	return 0;
-}
-
 /*
  * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
  * proper exit to userspace.
@@ -680,7 +204,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	switch (trap->scause) {
 	case EXC_VIRTUAL_INST_FAULT:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
-			ret = virtual_inst_fault(vcpu, run, trap);
+			ret = kvm_riscv_vcpu_virtual_insn(vcpu, run, trap);
 		break;
 	case EXC_INST_GUEST_PAGE_FAULT:
 	case EXC_LOAD_GUEST_PAGE_FAULT:
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_insn.c
similarity index 67%
copy from arch/riscv/kvm/vcpu_exit.c
copy to arch/riscv/kvm/vcpu_insn.c
index dbb09afd7546..be756879c2ee 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -1,16 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2019 Western Digital Corporation or its affiliates.
- *
- * Authors:
- *     Anup Patel <anup.patel@wdc.com>
+ * Copyright (c) 2022 Ventana Micro Systems Inc.
  */
 
 #include <linux/bitops.h>
-#include <linux/errno.h>
-#include <linux/err.h>
 #include <linux/kvm_host.h>
-#include <asm/csr.h>
 
 #define INSN_OPCODE_MASK	0x007c
 #define INSN_OPCODE_SHIFT	2
@@ -138,6 +133,21 @@ static int truly_illegal_insn(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+/**
+ * kvm_riscv_vcpu_wfi -- Emulate wait for interrupt (WFI) behaviour
+ *
+ * @vcpu: The VCPU pointer
+ */
+void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_arch_vcpu_runnable(vcpu)) {
+		kvm_vcpu_srcu_read_unlock(vcpu);
+		kvm_vcpu_halt(vcpu);
+		kvm_vcpu_srcu_read_lock(vcpu);
+		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+	}
+}
+
 static int system_opcode_insn(struct kvm_vcpu *vcpu,
 			      struct kvm_run *run,
 			      ulong insn)
@@ -152,8 +162,19 @@ static int system_opcode_insn(struct kvm_vcpu *vcpu,
 	return truly_illegal_insn(vcpu, run, insn);
 }
 
-static int virtual_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			      struct kvm_cpu_trap *trap)
+/**
+ * kvm_riscv_vcpu_virtual_insn -- Handle virtual instruction trap
+ *
+ * @vcpu: The VCPU pointer
+ * @run:  The VCPU run struct containing the mmio data
+ * @trap: Trap details
+ *
+ * Returns > 0 to continue run-loop
+ * Returns   0 to exit run-loop and handle in user-space.
+ * Returns < 0 to report failure and exit run-loop
+ */
+int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				struct kvm_cpu_trap *trap)
 {
 	unsigned long insn = trap->stval;
 	struct kvm_cpu_trap utrap = { 0 };
@@ -183,8 +204,21 @@ static int virtual_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	}
 }
 
-static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			unsigned long fault_addr, unsigned long htinst)
+/**
+ * kvm_riscv_vcpu_mmio_load -- Emulate MMIO load instruction
+ *
+ * @vcpu: The VCPU pointer
+ * @run:  The VCPU run struct containing the mmio data
+ * @fault_addr: Guest physical address to load
+ * @htinst: Transformed encoding of the load instruction
+ *
+ * Returns > 0 to continue run-loop
+ * Returns   0 to exit run-loop and handle in user-space.
+ * Returns < 0 to report failure and exit run-loop
+ */
+int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			     unsigned long fault_addr,
+			     unsigned long htinst)
 {
 	u8 data_buf[8];
 	unsigned long insn;
@@ -292,8 +326,21 @@ static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	return 0;
 }
 
-static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			 unsigned long fault_addr, unsigned long htinst)
+/**
+ * kvm_riscv_vcpu_mmio_store -- Emulate MMIO store instruction
+ *
+ * @vcpu: The VCPU pointer
+ * @run:  The VCPU run struct containing the mmio data
+ * @fault_addr: Guest physical address to store
+ * @htinst: Transformed encoding of the store instruction
+ *
+ * Returns > 0 to continue run-loop
+ * Returns   0 to exit run-loop and handle in user-space.
+ * Returns < 0 to report failure and exit run-loop
+ */
+int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			      unsigned long fault_addr,
+			      unsigned long htinst)
 {
 	u8 data8;
 	u16 data16;
@@ -412,195 +459,6 @@ static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	return 0;
 }
 
-static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			     struct kvm_cpu_trap *trap)
-{
-	struct kvm_memory_slot *memslot;
-	unsigned long hva, fault_addr;
-	bool writeable;
-	gfn_t gfn;
-	int ret;
-
-	fault_addr = (trap->htval << 2) | (trap->stval & 0x3);
-	gfn = fault_addr >> PAGE_SHIFT;
-	memslot = gfn_to_memslot(vcpu->kvm, gfn);
-	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writeable);
-
-	if (kvm_is_error_hva(hva) ||
-	    (trap->scause == EXC_STORE_GUEST_PAGE_FAULT && !writeable)) {
-		switch (trap->scause) {
-		case EXC_LOAD_GUEST_PAGE_FAULT:
-			return emulate_load(vcpu, run, fault_addr,
-					    trap->htinst);
-		case EXC_STORE_GUEST_PAGE_FAULT:
-			return emulate_store(vcpu, run, fault_addr,
-					     trap->htinst);
-		default:
-			return -EOPNOTSUPP;
-		};
-	}
-
-	ret = kvm_riscv_gstage_map(vcpu, memslot, fault_addr, hva,
-		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
-	if (ret < 0)
-		return ret;
-
-	return 1;
-}
-
-/**
- * kvm_riscv_vcpu_wfi -- Emulate wait for interrupt (WFI) behaviour
- *
- * @vcpu: The VCPU pointer
- */
-void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
-{
-	if (!kvm_arch_vcpu_runnable(vcpu)) {
-		kvm_vcpu_srcu_read_unlock(vcpu);
-		kvm_vcpu_halt(vcpu);
-		kvm_vcpu_srcu_read_lock(vcpu);
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
-	}
-}
-
-/**
- * kvm_riscv_vcpu_unpriv_read -- Read machine word from Guest memory
- *
- * @vcpu: The VCPU pointer
- * @read_insn: Flag representing whether we are reading instruction
- * @guest_addr: Guest address to read
- * @trap: Output pointer to trap details
- */
-unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
-					 bool read_insn,
-					 unsigned long guest_addr,
-					 struct kvm_cpu_trap *trap)
-{
-	register unsigned long taddr asm("a0") = (unsigned long)trap;
-	register unsigned long ttmp asm("a1");
-	register unsigned long val asm("t0");
-	register unsigned long tmp asm("t1");
-	register unsigned long addr asm("t2") = guest_addr;
-	unsigned long flags;
-	unsigned long old_stvec, old_hstatus;
-
-	local_irq_save(flags);
-
-	old_hstatus = csr_swap(CSR_HSTATUS, vcpu->arch.guest_context.hstatus);
-	old_stvec = csr_swap(CSR_STVEC, (ulong)&__kvm_riscv_unpriv_trap);
-
-	if (read_insn) {
-		/*
-		 * HLVX.HU instruction
-		 * 0110010 00011 rs1 100 rd 1110011
-		 */
-		asm volatile ("\n"
-			".option push\n"
-			".option norvc\n"
-			"add %[ttmp], %[taddr], 0\n"
-			/*
-			 * HLVX.HU %[val], (%[addr])
-			 * HLVX.HU t0, (t2)
-			 * 0110010 00011 00111 100 00101 1110011
-			 */
-			".word 0x6433c2f3\n"
-			"andi %[tmp], %[val], 3\n"
-			"addi %[tmp], %[tmp], -3\n"
-			"bne %[tmp], zero, 2f\n"
-			"addi %[addr], %[addr], 2\n"
-			/*
-			 * HLVX.HU %[tmp], (%[addr])
-			 * HLVX.HU t1, (t2)
-			 * 0110010 00011 00111 100 00110 1110011
-			 */
-			".word 0x6433c373\n"
-			"sll %[tmp], %[tmp], 16\n"
-			"add %[val], %[val], %[tmp]\n"
-			"2:\n"
-			".option pop"
-		: [val] "=&r" (val), [tmp] "=&r" (tmp),
-		  [taddr] "+&r" (taddr), [ttmp] "+&r" (ttmp),
-		  [addr] "+&r" (addr) : : "memory");
-
-		if (trap->scause == EXC_LOAD_PAGE_FAULT)
-			trap->scause = EXC_INST_PAGE_FAULT;
-	} else {
-		/*
-		 * HLV.D instruction
-		 * 0110110 00000 rs1 100 rd 1110011
-		 *
-		 * HLV.W instruction
-		 * 0110100 00000 rs1 100 rd 1110011
-		 */
-		asm volatile ("\n"
-			".option push\n"
-			".option norvc\n"
-			"add %[ttmp], %[taddr], 0\n"
-#ifdef CONFIG_64BIT
-			/*
-			 * HLV.D %[val], (%[addr])
-			 * HLV.D t0, (t2)
-			 * 0110110 00000 00111 100 00101 1110011
-			 */
-			".word 0x6c03c2f3\n"
-#else
-			/*
-			 * HLV.W %[val], (%[addr])
-			 * HLV.W t0, (t2)
-			 * 0110100 00000 00111 100 00101 1110011
-			 */
-			".word 0x6803c2f3\n"
-#endif
-			".option pop"
-		: [val] "=&r" (val),
-		  [taddr] "+&r" (taddr), [ttmp] "+&r" (ttmp)
-		: [addr] "r" (addr) : "memory");
-	}
-
-	csr_write(CSR_STVEC, old_stvec);
-	csr_write(CSR_HSTATUS, old_hstatus);
-
-	local_irq_restore(flags);
-
-	return val;
-}
-
-/**
- * kvm_riscv_vcpu_trap_redirect -- Redirect trap to Guest
- *
- * @vcpu: The VCPU pointer
- * @trap: Trap details
- */
-void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
-				  struct kvm_cpu_trap *trap)
-{
-	unsigned long vsstatus = csr_read(CSR_VSSTATUS);
-
-	/* Change Guest SSTATUS.SPP bit */
-	vsstatus &= ~SR_SPP;
-	if (vcpu->arch.guest_context.sstatus & SR_SPP)
-		vsstatus |= SR_SPP;
-
-	/* Change Guest SSTATUS.SPIE bit */
-	vsstatus &= ~SR_SPIE;
-	if (vsstatus & SR_SIE)
-		vsstatus |= SR_SPIE;
-
-	/* Clear Guest SSTATUS.SIE bit */
-	vsstatus &= ~SR_SIE;
-
-	/* Update Guest SSTATUS */
-	csr_write(CSR_VSSTATUS, vsstatus);
-
-	/* Update Guest SCAUSE, STVAL, and SEPC */
-	csr_write(CSR_VSCAUSE, trap->scause);
-	csr_write(CSR_VSTVAL, trap->stval);
-	csr_write(CSR_VSEPC, trap->sepc);
-
-	/* Set Guest PC to Guest exception vector */
-	vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
-}
-
 /**
  * kvm_riscv_vcpu_mmio_return -- Handle MMIO loads after user space emulation
  *			     or in-kernel IO emulation
@@ -660,52 +518,3 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	return 0;
 }
-
-/*
- * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
- * proper exit to userspace.
- */
-int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			struct kvm_cpu_trap *trap)
-{
-	int ret;
-
-	/* If we got host interrupt then do nothing */
-	if (trap->scause & CAUSE_IRQ_FLAG)
-		return 1;
-
-	/* Handle guest traps */
-	ret = -EFAULT;
-	run->exit_reason = KVM_EXIT_UNKNOWN;
-	switch (trap->scause) {
-	case EXC_VIRTUAL_INST_FAULT:
-		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
-			ret = virtual_inst_fault(vcpu, run, trap);
-		break;
-	case EXC_INST_GUEST_PAGE_FAULT:
-	case EXC_LOAD_GUEST_PAGE_FAULT:
-	case EXC_STORE_GUEST_PAGE_FAULT:
-		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
-			ret = gstage_page_fault(vcpu, run, trap);
-		break;
-	case EXC_SUPERVISOR_SYSCALL:
-		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
-			ret = kvm_riscv_vcpu_sbi_ecall(vcpu, run);
-		break;
-	default:
-		break;
-	}
-
-	/* Print details in-case of error */
-	if (ret < 0) {
-		kvm_err("VCPU exit error %d\n", ret);
-		kvm_err("SEPC=0x%lx SSTATUS=0x%lx HSTATUS=0x%lx\n",
-			vcpu->arch.guest_context.sepc,
-			vcpu->arch.guest_context.sstatus,
-			vcpu->arch.guest_context.hstatus);
-		kvm_err("SCAUSE=0x%lx STVAL=0x%lx HTVAL=0x%lx HTINST=0x%lx\n",
-			trap->scause, trap->stval, trap->htval, trap->htinst);
-	}
-
-	return ret;
-}
-- 
2.34.1

