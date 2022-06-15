Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457AD54C661
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 12:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351994AbiFOKlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 06:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351137AbiFOKlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 06:41:06 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC41650E3D
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 03:41:01 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id g186so11030552pgc.1
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 03:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IiW6/Wj6aEziSQchLkFJstelw1x7VOvv11UX6Ci45GA=;
        b=hDC2YeXjiicf8IegqWbV7bw2wfUR0GwCM9pUHyUetUeDakGcQcS4hP4mDGZfuG57rn
         0z6aUBG5/nEHXP1AgZF17BVhvrYb68G+RSTk1M1kMP839m8fnwQQTIe2PTia8K5zn9r0
         +LYPUqZi5cwR2fyqS+2hkc6b7Up0s13OcssCT2zLOgOTb2vkQ/LGrYUI/ToC7d+HP1L/
         9xa+L4MF33pMudcOXxij6xRNAd0Dj8Ciw5Ix00Q0BAdYUdyQTetwxLnQw7rdzy5Gr4XC
         GU6WwN32JGNKhCzIFE7ra96OQanNptW+Ttnn9g365Wzfgv6YV+rEwN3cMCK2y4qXx3B7
         gRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IiW6/Wj6aEziSQchLkFJstelw1x7VOvv11UX6Ci45GA=;
        b=IEgnnAWMNIjlmNBzff6GxW/OEr6V3QfG0VzU5z9s0cbGIXZzDzFTXrYfEAmpOSzdGi
         vhn7Wu7RPX+0MjjbSyXO/6SDlwh/5HqZZZF3zrlrxYq6FkfnuwIIpaiRdDKbXTyAs0Zv
         TCdbc6bW1/8WCXV3BfQ5HAb+F0pudNBvpoWLf9nDAzFTFHP16JWe7GjDuOZvtQwfeL1C
         8CiBQXIfBcNV58V9OtG3z+dR6XUOMA2uvvXeT/ipz6CWCSaeRBv2mIzURORrG8bST4Oi
         tB6ZE0jHhbXb/iSx8fFhTvdkAUCra+lGFiWl+hRHgeOXeW4cHGsGtMT8N5t4lMbdS+YS
         rzUg==
X-Gm-Message-State: AOAM5321zGqW5qpHPlP3oRnoJl7YFQhliqhLAthtNqiwb16de++LYwzO
        rO0fooVi7AaRCQyjbly1QHC9Fg==
X-Google-Smtp-Source: ABdhPJwk/Om9g1Wzkc8oeqAMAvhlE2K0q4tary69vhdWHKGTojvtxWMYIP6Wyka2EzKjkliyjEUjbw==
X-Received: by 2002:a63:8142:0:b0:3fc:c051:167f with SMTP id t63-20020a638142000000b003fcc051167fmr8428942pgd.384.1655289660932;
        Wed, 15 Jun 2022 03:41:00 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.104.191])
        by smtp.gmail.com with ESMTPSA id i19-20020a056a00225300b00522c365225csm1427273pfu.3.2022.06.15.03.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:41:00 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 3/3] RISC-V: KVM: Add extensible CSR emulation framework
Date:   Wed, 15 Jun 2022 16:10:25 +0530
Message-Id: <20220615104025.941382-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220615104025.941382-1-apatel@ventanamicro.com>
References: <20220615104025.941382-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add an extensible CSR emulation framework which is based upon the
existing system instruction emulation. This will be useful to upcoming
AIA, PMU, Nested and other virtualization features.

The CSR emulation framework also has provision to emulate CSR in user
space but this will be used only in very specific cases such as AIA
IMSIC CSR emulation in user space or vendor specific CSR emulation
in user space.

By default, all CSRs not handled by KVM RISC-V will be redirected back
to Guest VCPU as illegal instruction trap.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h      |   5 +
 arch/riscv/include/asm/kvm_vcpu_insn.h |   6 +
 arch/riscv/kvm/vcpu.c                  |  34 +++--
 arch/riscv/kvm/vcpu_insn.c             | 172 ++++++++++++++++++++++++-
 include/uapi/linux/kvm.h               |   8 ++
 5 files changed, 209 insertions(+), 16 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 03103b86dd86..a54744d7e1ba 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -64,6 +64,8 @@ struct kvm_vcpu_stat {
 	u64 wfi_exit_stat;
 	u64 mmio_exit_user;
 	u64 mmio_exit_kernel;
+	u64 csr_exit_user;
+	u64 csr_exit_kernel;
 	u64 exits;
 };
 
@@ -209,6 +211,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
+	/* CSR instruction details */
+	struct kvm_csr_decode csr_decode;
+
 	/* SBI context */
 	struct kvm_sbi_context sbi_context;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_insn.h b/arch/riscv/include/asm/kvm_vcpu_insn.h
index 3351eb61a251..350011c83581 100644
--- a/arch/riscv/include/asm/kvm_vcpu_insn.h
+++ b/arch/riscv/include/asm/kvm_vcpu_insn.h
@@ -18,6 +18,11 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
 
+struct kvm_csr_decode {
+	unsigned long insn;
+	int return_handled;
+};
+
 /* Return values used by function emulating a particular instruction */
 enum kvm_insn_return {
 	KVM_INSN_EXIT_TO_USER_SPACE = 0,
@@ -28,6 +33,7 @@ enum kvm_insn_return {
 };
 
 void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_csr_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 				struct kvm_cpu_trap *trap);
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7f4ad5e4373a..21bbb9e83982 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -26,6 +26,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_user),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
+	STATS_DESC_COUNTER(VCPU, csr_exit_user),
+	STATS_DESC_COUNTER(VCPU, csr_exit_kernel),
 	STATS_DESC_COUNTER(VCPU, exits)
 };
 
@@ -851,22 +853,26 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_vcpu_srcu_read_lock(vcpu);
 
-	/* Process MMIO value returned from user-space */
-	if (run->exit_reason == KVM_EXIT_MMIO) {
+	switch (run->exit_reason) {
+	case KVM_EXIT_MMIO:
+		/* Process MMIO value returned from user-space */
 		ret = kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
-		if (ret) {
-			kvm_vcpu_srcu_read_unlock(vcpu);
-			return ret;
-		}
-	}
-
-	/* Process SBI value returned from user-space */
-	if (run->exit_reason == KVM_EXIT_RISCV_SBI) {
+		break;
+	case KVM_EXIT_RISCV_SBI:
+		/* Process SBI value returned from user-space */
 		ret = kvm_riscv_vcpu_sbi_return(vcpu, vcpu->run);
-		if (ret) {
-			kvm_vcpu_srcu_read_unlock(vcpu);
-			return ret;
-		}
+		break;
+	case KVM_EXIT_RISCV_CSR:
+		/* Process CSR value returned from user-space */
+		ret = kvm_riscv_vcpu_csr_return(vcpu, vcpu->run);
+		break;
+	default:
+		ret = 0;
+		break;
+	}
+	if (ret) {
+		kvm_vcpu_srcu_read_unlock(vcpu);
+		return ret;
 	}
 
 	if (run->immediate_exit) {
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 75ca62a7fba5..7eb90a47b571 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -14,6 +14,19 @@
 #define INSN_MASK_WFI		0xffffffff
 #define INSN_MATCH_WFI		0x10500073
 
+#define INSN_MATCH_CSRRW	0x1073
+#define INSN_MASK_CSRRW		0x707f
+#define INSN_MATCH_CSRRS	0x2073
+#define INSN_MASK_CSRRS		0x707f
+#define INSN_MATCH_CSRRC	0x3073
+#define INSN_MASK_CSRRC		0x707f
+#define INSN_MATCH_CSRRWI	0x5073
+#define INSN_MASK_CSRRWI	0x707f
+#define INSN_MATCH_CSRRSI	0x6073
+#define INSN_MASK_CSRRSI	0x707f
+#define INSN_MATCH_CSRRCI	0x7073
+#define INSN_MASK_CSRRCI	0x707f
+
 #define INSN_MATCH_LB		0x3
 #define INSN_MASK_LB		0x707f
 #define INSN_MATCH_LH		0x1003
@@ -71,6 +84,7 @@
 #define SH_RS1			15
 #define SH_RS2			20
 #define SH_RS2C			2
+#define MASK_RX			0x1f
 
 #define RV_X(x, s, n)		(((x) >> (s)) & ((1 << (n)) - 1))
 #define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
@@ -104,7 +118,7 @@
 #define REG_PTR(insn, pos, regs)	\
 	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
 
-#define GET_RM(insn)		(((insn) >> 12) & 7)
+#define GET_FUNCT3(insn)	(((insn) >> 12) & 7)
 
 #define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
 #define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
@@ -116,7 +130,6 @@
 #define IMM_I(insn)		((s32)(insn) >> 20)
 #define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
 				 (s32)(((insn) >> 7) & 0x1f))
-#define MASK_FUNCT3		0x7000
 
 struct insn_func {
 	unsigned long mask;
@@ -189,7 +202,162 @@ static int wfi_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
 	return KVM_INSN_CONTINUE_NEXT_SEPC;
 }
 
+struct csr_func {
+	unsigned int base;
+	unsigned int count;
+	/*
+	 * Possible return values are as same as "func" callback in
+	 * "struct insn_func".
+	 */
+	int (*func)(struct kvm_vcpu *vcpu, unsigned int csr_num,
+		    unsigned long *val, unsigned long new_val,
+		    unsigned long wr_mask);
+};
+
+static const struct csr_func csr_funcs[] = { };
+
+/**
+ * kvm_riscv_vcpu_csr_return -- Handle CSR read/write after user space
+ *				emulation or in-kernel emulation
+ *
+ * @vcpu: The VCPU pointer
+ * @run:  The VCPU run struct containing the CSR data
+ *
+ * Returns > 0 upon failure and 0 upon success
+ */
+int kvm_riscv_vcpu_csr_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	ulong insn;
+
+	if (vcpu->arch.csr_decode.return_handled)
+		return 0;
+	vcpu->arch.csr_decode.return_handled = 1;
+
+	/* Update destination register for CSR reads */
+	insn = vcpu->arch.csr_decode.insn;
+	if ((insn >> SH_RD) & MASK_RX)
+		SET_RD(insn, &vcpu->arch.guest_context,
+		       run->riscv_csr.ret_value);
+
+	/* Move to next instruction */
+	vcpu->arch.guest_context.sepc += INSN_LEN(insn);
+
+	return 0;
+}
+
+static int csr_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
+{
+	int i, rc = KVM_INSN_ILLEGAL_TRAP;
+	unsigned int csr_num = insn >> SH_RS2;
+	unsigned int rs1_num = (insn >> SH_RS1) & MASK_RX;
+	ulong rs1_val = GET_RS1(insn, &vcpu->arch.guest_context);
+	const struct csr_func *tcfn, *cfn = NULL;
+	ulong val = 0, wr_mask = 0, new_val = 0;
+
+	/* Decode the CSR instruction */
+	switch (GET_FUNCT3(insn)) {
+	case GET_FUNCT3(INSN_MATCH_CSRRW):
+		wr_mask = -1UL;
+		new_val = rs1_val;
+		break;
+	case GET_FUNCT3(INSN_MATCH_CSRRS):
+		wr_mask = rs1_val;
+		new_val = -1UL;
+		break;
+	case GET_FUNCT3(INSN_MATCH_CSRRC):
+		wr_mask = rs1_val;
+		new_val = 0;
+		break;
+	case GET_FUNCT3(INSN_MATCH_CSRRWI):
+		wr_mask = -1UL;
+		new_val = rs1_num;
+		break;
+	case GET_FUNCT3(INSN_MATCH_CSRRSI):
+		wr_mask = rs1_num;
+		new_val = -1UL;
+		break;
+	case GET_FUNCT3(INSN_MATCH_CSRRCI):
+		wr_mask = rs1_num;
+		new_val = 0;
+		break;
+	default:
+		return rc;
+	}
+
+	/* Save instruction decode info */
+	vcpu->arch.csr_decode.insn = insn;
+	vcpu->arch.csr_decode.return_handled = 0;
+
+	/* Update CSR details in kvm_run struct */
+	run->riscv_csr.csr_num = csr_num;
+	run->riscv_csr.new_value = new_val;
+	run->riscv_csr.write_mask = wr_mask;
+	run->riscv_csr.ret_value = 0;
+
+	/* Find in-kernel CSR function */
+	for (i = 0; i < ARRAY_SIZE(csr_funcs); i++) {
+		tcfn = &csr_funcs[i];
+		if ((tcfn->base <= csr_num) &&
+		    (csr_num < (tcfn->base + tcfn->count))) {
+			cfn = tcfn;
+			break;
+		}
+	}
+
+	/* First try in-kernel CSR emulation */
+	if (cfn && cfn->func) {
+		rc = cfn->func(vcpu, csr_num, &val, new_val, wr_mask);
+		if (rc > KVM_INSN_EXIT_TO_USER_SPACE) {
+			if (rc == KVM_INSN_CONTINUE_NEXT_SEPC) {
+				run->riscv_csr.ret_value = val;
+				vcpu->stat.csr_exit_kernel++;
+				kvm_riscv_vcpu_csr_return(vcpu, run);
+				rc = KVM_INSN_CONTINUE_SAME_SEPC;
+			}
+			return rc;
+		}
+	}
+
+	/* Exit to user-space for CSR emulation */
+	if (rc <= KVM_INSN_EXIT_TO_USER_SPACE) {
+		vcpu->stat.csr_exit_user++;
+		run->exit_reason = KVM_EXIT_RISCV_CSR;
+	}
+
+	return rc;
+}
+
 static const struct insn_func system_opcode_funcs[] = {
+	{
+		.mask  = INSN_MASK_CSRRW,
+		.match = INSN_MATCH_CSRRW,
+		.func  = csr_insn,
+	},
+	{
+		.mask  = INSN_MASK_CSRRS,
+		.match = INSN_MATCH_CSRRS,
+		.func  = csr_insn,
+	},
+	{
+		.mask  = INSN_MASK_CSRRC,
+		.match = INSN_MATCH_CSRRC,
+		.func  = csr_insn,
+	},
+	{
+		.mask  = INSN_MASK_CSRRWI,
+		.match = INSN_MATCH_CSRRWI,
+		.func  = csr_insn,
+	},
+	{
+		.mask  = INSN_MASK_CSRRSI,
+		.match = INSN_MATCH_CSRRSI,
+		.func  = csr_insn,
+	},
+	{
+		.mask  = INSN_MASK_CSRRCI,
+		.match = INSN_MATCH_CSRRCI,
+		.func  = csr_insn,
+	},
 	{
 		.mask  = INSN_MASK_WFI,
 		.match = INSN_MATCH_WFI,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5088bd9f1922..c48fd3d1c45b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -270,6 +270,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_RISCV_CSR        36
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -496,6 +497,13 @@ struct kvm_run {
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+		/* KVM_EXIT_RISCV_CSR */
+		struct {
+			unsigned long csr_num;
+			unsigned long new_value;
+			unsigned long write_mask;
+			unsigned long ret_value;
+		} riscv_csr;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.34.1

