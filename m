Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87326CAB04
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjC0QvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjC0QvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:51:08 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CEB449A
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id cm5so286837pfb.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935852;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l1UGGwgJvUlKd8p+NgWkwJl19iT6mzgCxedlFkmP7mY=;
        b=Kv+FO1Vza29QieeIXBjYRHkxUSsus9sduVkceAl1viYb/zAZtVS7e6RPQTAFsla3Re
         c4Qks5cTRW2wqjlYbb3ibFb0PYu1rDlYblHlu63zNPSyBdcBmzPkXSqmSDg024z4Jl1L
         Y8C6J8eCTW6cgwK9AEHHciHii8ts8oY1FcPBtu7cyVM2ekqEd2LDqmH+zQhU+/1By1EG
         Fu4AHd2YJgAigadXZh/DLH0HoGQT3ch4IJrO6O0WSTF6Mg8J0F9flCGpw6wgHbhXGR14
         RISYJVBWRQeBqqgsCiWc5VO0cHXwUInzerL1e1UluKvMnhDkD9ZMoVvT1/Iu3hWfxqCR
         SDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935852;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1UGGwgJvUlKd8p+NgWkwJl19iT6mzgCxedlFkmP7mY=;
        b=XueHKSBjOGeOLut9E+gQR5LOp1/o6ZbVs12WUtgkyjiqM8IttA4Nt0KpHI4j6Y3ro1
         oOstEeN5UPgW5JWEao9eWNeDS/zwyFl9cdvjdUzakF7JKjCt12We7pUGycPi96/YNXVy
         ykdJ1rtoBeCEikypbXlhm8bIV6UvgfUoSJr7nXLl+3eolAV4Ffde9gzuMkjJXlDfsnCu
         /A3wokDxCnIOqOyPpu1CXbO+gzlH8zOn+hcQawryhpFiyVX+3D4kxBji4JSZ4lQOwEr+
         NB7lTTQyAqdhYWaD2N6C96Qtt4i6TKjFqzxH2M1pqQL3hYPtB171r5Bj375iu3xAJg42
         ORFg==
X-Gm-Message-State: AAQBX9eDPmim1BO6SZ0kNv4FCs+Uxxi3y3cTG8zcnZUEmDIfCpn/b4Or
        uklqYTEjuI70aGYKRnPyDtEIqQ==
X-Google-Smtp-Source: AKy350bJAPt2QeT1DfDHJ0VktjlShozoUGqi/m/CR5NAgfO2F0FtaDB0zsBMXw+CC46cZhSicbbmBA==
X-Received: by 2002:a05:6a00:4e:b0:628:a3d:8aa7 with SMTP id i14-20020a056a00004e00b006280a3d8aa7mr12794234pfk.31.1679935851801;
        Mon, 27 Mar 2023 09:50:51 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:50:51 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Liao Chang <liaochang1@huawei.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Mattias Nissler <mnissler@rivosinc.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH -next v17 10/20] riscv: Allocate user's vector context in the first-use trap
Date:   Mon, 27 Mar 2023 16:49:30 +0000
Message-Id: <20230327164941.20491-11-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vector unit is disabled by default for all user processes. Thus, a
process will take a trap (illegal instruction) into kernel at the first
time when it uses Vector. Only after then, the kernel allocates V
context and starts take care of the context for that user process.

Suggested-by: Richard Henderson <richard.henderson@linaro.org>
Link: https://lore.kernel.org/r/3923eeee-e4dc-0911-40bf-84c34aee962d@linaro.org
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/include/asm/insn.h   | 29 +++++++++++
 arch/riscv/include/asm/vector.h |  2 +
 arch/riscv/kernel/traps.c       | 26 +++++++++-
 arch/riscv/kernel/vector.c      | 90 +++++++++++++++++++++++++++++++++
 4 files changed, 145 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index 8d5c84f2d5ef..4e1505cef8aa 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -137,6 +137,26 @@
 #define RVG_OPCODE_JALR		0x67
 #define RVG_OPCODE_JAL		0x6f
 #define RVG_OPCODE_SYSTEM	0x73
+#define RVG_SYSTEM_CSR_OFF	20
+#define RVG_SYSTEM_CSR_MASK	GENMASK(12, 0)
+
+/* parts of opcode for RVF, RVD and RVQ */
+#define RVFDQ_FL_FS_WIDTH_OFF	12
+#define RVFDQ_FL_FS_WIDTH_MASK	GENMASK(3, 0)
+#define RVFDQ_FL_FS_WIDTH_W	2
+#define RVFDQ_FL_FS_WIDTH_D	3
+#define RVFDQ_LS_FS_WIDTH_Q	4
+#define RVFDQ_OPCODE_FL		0x07
+#define RVFDQ_OPCODE_FS		0x27
+
+/* parts of opcode for RVV */
+#define RVV_OPCODE_VECTOR	0x57
+#define RVV_VL_VS_WIDTH_8	0
+#define RVV_VL_VS_WIDTH_16	5
+#define RVV_VL_VS_WIDTH_32	6
+#define RVV_VL_VS_WIDTH_64	7
+#define RVV_OPCODE_VL		RVFDQ_OPCODE_FL
+#define RVV_OPCODE_VS		RVFDQ_OPCODE_FS
 
 /* parts of opcode for RVC*/
 #define RVC_OPCODE_C0		0x0
@@ -304,6 +324,15 @@ static __always_inline bool riscv_insn_is_branch(u32 code)
 	(RVC_X(x_, RVC_B_IMM_7_6_OPOFF, RVC_B_IMM_7_6_MASK) << RVC_B_IMM_7_6_OFF) | \
 	(RVC_IMM_SIGN(x_) << RVC_B_IMM_SIGN_OFF); })
 
+#define RVG_EXTRACT_SYSTEM_CSR(x) \
+	({typeof(x) x_ = (x); RV_X(x_, RVG_SYSTEM_CSR_OFF, RVG_SYSTEM_CSR_MASK); })
+
+#define RVFDQ_EXTRACT_FL_FS_WIDTH(x) \
+	({typeof(x) x_ = (x); RV_X(x_, RVFDQ_FL_FS_WIDTH_OFF, \
+				   RVFDQ_FL_FS_WIDTH_MASK); })
+
+#define RVV_EXRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
+
 /*
  * Get the immediate from a J-type instruction.
  *
diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 4161352d6ea8..70a5e696c1de 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -20,6 +20,7 @@
 
 extern unsigned long riscv_v_vsize;
 void riscv_v_setup_vsize(void);
+bool riscv_v_first_use_handler(struct pt_regs *regs);
 
 static __always_inline bool has_vector(void)
 {
@@ -163,6 +164,7 @@ static inline void __switch_to_vector(struct task_struct *prev,
 struct pt_regs;
 
 static __always_inline bool has_vector(void) { return false; }
+static inline bool riscv_v_first_use_handler(struct pt_regs *regs) { return false; }
 static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return false; }
 #define riscv_v_vsize (0)
 #define riscv_v_setup_vsize()			do {} while (0)
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 1f4e37be7eb3..f543e5ebfd29 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -26,6 +26,7 @@
 #include <asm/ptrace.h>
 #include <asm/syscall.h>
 #include <asm/thread_info.h>
+#include <asm/vector.h>
 
 int show_unhandled_signals = 1;
 
@@ -145,8 +146,29 @@ DO_ERROR_INFO(do_trap_insn_misaligned,
 	SIGBUS, BUS_ADRALN, "instruction address misaligned");
 DO_ERROR_INFO(do_trap_insn_fault,
 	SIGSEGV, SEGV_ACCERR, "instruction access fault");
-DO_ERROR_INFO(do_trap_insn_illegal,
-	SIGILL, ILL_ILLOPC, "illegal instruction");
+
+asmlinkage __visible __trap_section void do_trap_insn_illegal(struct pt_regs *regs)
+{
+	if (user_mode(regs)) {
+		irqentry_enter_from_user_mode(regs);
+
+		local_irq_enable();
+
+		if (!has_vector() || !riscv_v_first_use_handler(regs))
+			do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->epc,
+				      "Oops - illegal instruction");
+
+		irqentry_exit_to_user_mode(regs);
+	} else {
+		irqentry_state_t state = irqentry_nmi_enter(regs);
+
+		do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->epc,
+			      "Oops - illegal instruction");
+
+		irqentry_nmi_exit(regs, state);
+	}
+}
+
 DO_ERROR_INFO(do_trap_load_fault,
 	SIGSEGV, SEGV_ACCERR, "load access fault");
 #ifndef CONFIG_RISCV_M_MODE
diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 03582e2ade83..ea59f32adf46 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -4,9 +4,19 @@
  * Author: Andy Chiu <andy.chiu@sifive.com>
  */
 #include <linux/export.h>
+#include <linux/sched/signal.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
 
+#include <asm/thread_info.h>
+#include <asm/processor.h>
+#include <asm/insn.h>
 #include <asm/vector.h>
 #include <asm/csr.h>
+#include <asm/ptrace.h>
+#include <asm/bug.h>
 
 unsigned long riscv_v_vsize __read_mostly;
 EXPORT_SYMBOL_GPL(riscv_v_vsize);
@@ -18,3 +28,83 @@ void riscv_v_setup_vsize(void)
 	riscv_v_vsize = csr_read(CSR_VLENB) * 32;
 	riscv_v_disable();
 }
+
+static bool insn_is_vector(u32 insn_buf)
+{
+	u32 opcode = insn_buf & __INSN_OPCODE_MASK;
+	bool is_vector = false;
+	u32 width, csr;
+
+	/*
+	 * All V-related instructions, including CSR operations are 4-Byte. So,
+	 * do not handle if the instruction length is not 4-Byte.
+	 */
+	if (unlikely(GET_INSN_LENGTH(insn_buf) != 4))
+		return false;
+
+	switch (opcode) {
+	case RVV_OPCODE_VECTOR:
+		is_vector = true;
+		break;
+	case RVV_OPCODE_VL:
+	case RVV_OPCODE_VS:
+		width = RVV_EXRACT_VL_VS_WIDTH(insn_buf);
+		if (width == RVV_VL_VS_WIDTH_8 || width == RVV_VL_VS_WIDTH_16 ||
+		    width == RVV_VL_VS_WIDTH_32 || width == RVV_VL_VS_WIDTH_64)
+			is_vector = true;
+		break;
+	case RVG_OPCODE_SYSTEM:
+		csr = RVG_EXTRACT_SYSTEM_CSR(insn_buf);
+		if ((csr >= CSR_VSTART && csr <= CSR_VCSR) ||
+		    (csr >= CSR_VL && csr <= CSR_VLENB))
+			is_vector = true;
+		break;
+	}
+	return is_vector;
+}
+
+static int riscv_v_thread_zalloc(void)
+{
+	void *datap;
+
+	datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
+	if (!datap)
+		return -ENOMEM;
+	current->thread.vstate.datap = datap;
+	memset(&current->thread.vstate, 0, offsetof(struct __riscv_v_ext_state,
+						    datap));
+	return 0;
+}
+
+bool riscv_v_first_use_handler(struct pt_regs *regs)
+{
+	u32 __user *epc = (u32 __user *)regs->epc;
+	u32 insn = (u32)regs->badaddr;
+
+	/* If V has been enabled then it is not the first-use trap */
+	if (riscv_v_vstate_query(regs))
+		return false;
+
+	/* Get the instruction */
+	if (!insn) {
+		if (__get_user(insn, epc))
+			return false;
+	}
+	/* Filter out non-V instructions */
+	if (!insn_is_vector(insn))
+		return false;
+
+	/* Sanity check. datap should be null by the time of the first-use trap */
+	WARN_ON(current->thread.vstate.datap);
+	/*
+	 * Now we sure that this is a V instruction. And it executes in the
+	 * context where VS has been off. So, try to allocate the user's V
+	 * context and resume execution.
+	 */
+	if (riscv_v_thread_zalloc()) {
+		force_sig(SIGKILL);
+		return true;
+	}
+	riscv_v_vstate_on(regs);
+	return true;
+}
-- 
2.17.1

