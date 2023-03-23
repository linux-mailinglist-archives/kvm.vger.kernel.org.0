Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A676C6BC8
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 16:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjCWPBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 11:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCWPA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 11:00:58 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C7C28E58
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:00:45 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o2so15149957plg.4
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583645;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iCcObYH91oMWZ6bdmVu48SZE269reFVecBrOrqoWxGA=;
        b=EedgoYClEcxGQrd7CKPRbbltCB2tJHu+Fmlpu8Pyj2bwl7Gnf6pMQCHledQLM5pNGt
         eu/R4VHE3TUdT1hoMGOil5MG8hLG3yOvHuzb2/80pADS2gD8Ca8mYIRB6lydKe+RGB+4
         5SkucqXXrvupapqLr7hGhptUAscK0M1iAg4gVQE8+Tfqv0cSu3I4WuzavtEIr06oClKn
         J4skEaVk7mxy/P1vj1hNohtrzMGtmUYqauqo7vdv7WGBtHAYtXgc1kY4wckCqbG3vL5J
         qVDEIQSdKBAtprO/vamwbfCszmuYY5ClsdJXXYAsnEdVQ0gut1Wkp7qirKDz3y0PckcO
         ePjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583645;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iCcObYH91oMWZ6bdmVu48SZE269reFVecBrOrqoWxGA=;
        b=Hr7dfbtDzbkF6IpX4/mF6phawm9KHwL2tU9aL+5uaCtw8Km3iETwCSE+XjYwzXs4DM
         mjF4fuTb4M4vmTi37ANobXE4+bJaZekBya/OsJDIndOT1Dp46OQW3FFdTJhIQzXuecPi
         yQwZeSCCo75r7doMNlY6+AYUjzga55OysqnjKrDNGUv8OQyiLfG5bhZOhUWFYVs/zdhx
         n07Ss5Lp5fttaMD6JW1ZyfFhkieXADOahAna3DUGkqGxdas7TCEkwdIDaJCY/NR2eAm2
         T0CYNNf1GaSY/7vPsAzUoPvown/mQkuUmmzmNibl9tbUAPwN/d54ZohiBMEFjP8qpsmI
         IWAw==
X-Gm-Message-State: AO0yUKXwwsivrZTq3Mn9kR+QvwuwXdHm3hrpApHiR7lX3RgAyNnipQs3
        2bocSheqKOeKy+H1EK4rL0tQKBb4Bi/SKjoo8fQ=
X-Google-Smtp-Source: AK7set+KLpJHA+/Z+2zEQnRhf/oukFKUa4LDaaL+p8lySAkLSMylITH3L3Yp2iGzhZB2T4tJ79F5NQ==
X-Received: by 2002:a17:903:41c1:b0:1a1:b7fc:eeba with SMTP id u1-20020a17090341c100b001a1b7fceebamr9008680ple.19.1679583644813;
        Thu, 23 Mar 2023 08:00:44 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.08.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 08:00:44 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Qing Zhang <zhangqing@loongson.cn>,
        Rolf Eike Beer <eb@emlix.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH -next v16 11/20] riscv: Add ptrace vector support
Date:   Thu, 23 Mar 2023 14:59:15 +0000
Message-Id: <20230323145924.4194-12-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230323145924.4194-1-andy.chiu@sifive.com>
References: <20230323145924.4194-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

This patch adds ptrace support for riscv vector. The vector registers will
be saved in datap pointer of __riscv_v_ext_state. This pointer will be set
right after the __riscv_v_ext_state data structure then it will be put in
ubuf for ptrace system call to get or set. It will check if the datap got
from ubuf is set to the correct address or not when the ptrace system call
is trying to set the vector registers.

Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/uapi/asm/ptrace.h |  7 +++
 arch/riscv/kernel/ptrace.c           | 70 ++++++++++++++++++++++++++++
 include/uapi/linux/elf.h             |  1 +
 3 files changed, 78 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index 586786d023c4..e8d127ec5cf7 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -94,6 +94,13 @@ struct __riscv_v_ext_state {
 	 */
 };
 
+/*
+ * According to spec: The number of bits in a single vector register,
+ * VLEN >= ELEN, which must be a power of 2, and must be no greater than
+ * 2^16 = 65536bits = 8192bytes
+ */
+#define RISCV_MAX_VLENB (8192)
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI_ASM_RISCV_PTRACE_H */
diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 2ae8280ae475..84df5be90742 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -7,6 +7,7 @@
  * Copied from arch/tile/kernel/ptrace.c
  */
 
+#include <asm/vector.h>
 #include <asm/ptrace.h>
 #include <asm/syscall.h>
 #include <asm/thread_info.h>
@@ -27,6 +28,9 @@ enum riscv_regset {
 #ifdef CONFIG_FPU
 	REGSET_F,
 #endif
+#ifdef CONFIG_RISCV_ISA_V
+	REGSET_V,
+#endif
 };
 
 static int riscv_gpr_get(struct task_struct *target,
@@ -83,6 +87,61 @@ static int riscv_fpr_set(struct task_struct *target,
 }
 #endif
 
+#ifdef CONFIG_RISCV_ISA_V
+static int riscv_vr_get(struct task_struct *target,
+			const struct user_regset *regset,
+			struct membuf to)
+{
+	struct __riscv_v_ext_state *vstate = &target->thread.vstate;
+
+	if (!riscv_v_vstate_query(task_pt_regs(target)))
+		return -EINVAL;
+
+	/*
+	 * Ensure the vector registers have been saved to the memory before
+	 * copying them to membuf.
+	 */
+	if (target == current)
+		riscv_v_vstate_save(current, task_pt_regs(current));
+
+	/* Copy vector header from vstate. */
+	membuf_write(&to, vstate, offsetof(struct __riscv_v_ext_state, datap));
+	membuf_zero(&to, sizeof(void *));
+
+	/* Copy all the vector registers from vstate. */
+	return membuf_write(&to, vstate->datap, riscv_v_vsize);
+}
+
+static int riscv_vr_set(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			const void *kbuf, const void __user *ubuf)
+{
+	int ret, size;
+	struct __riscv_v_ext_state *vstate = &target->thread.vstate;
+
+	if (!riscv_v_vstate_query(task_pt_regs(target)))
+		return -EINVAL;
+
+	/* Copy rest of the vstate except datap */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, vstate, 0,
+				 offsetof(struct __riscv_v_ext_state, datap));
+	if (unlikely(ret))
+		return ret;
+
+	/* Skip copy datap. */
+	size = sizeof(vstate->datap);
+	count -= size;
+	ubuf += size;
+
+	/* Copy all the vector registers. */
+	pos = 0;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, vstate->datap,
+				 0, riscv_v_vsize);
+	return ret;
+}
+#endif
+
 static const struct user_regset riscv_user_regset[] = {
 	[REGSET_X] = {
 		.core_note_type = NT_PRSTATUS,
@@ -102,6 +161,17 @@ static const struct user_regset riscv_user_regset[] = {
 		.set = riscv_fpr_set,
 	},
 #endif
+#ifdef CONFIG_RISCV_ISA_V
+	[REGSET_V] = {
+		.core_note_type = NT_RISCV_VECTOR,
+		.align = 16,
+		.n = ((32 * RISCV_MAX_VLENB) +
+		      sizeof(struct __riscv_v_ext_state)) / sizeof(__u32),
+		.size = sizeof(__u32),
+		.regset_get = riscv_vr_get,
+		.set = riscv_vr_set,
+	},
+#endif
 };
 
 static const struct user_regset_view riscv_user_native_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ac3da855fb19..7d8d9ae36615 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -440,6 +440,7 @@ typedef struct elf64_shdr {
 #define NT_MIPS_DSP	0x800		/* MIPS DSP ASE registers */
 #define NT_MIPS_FP_MODE	0x801		/* MIPS floating-point mode */
 #define NT_MIPS_MSA	0x802		/* MIPS SIMD registers */
+#define NT_RISCV_VECTOR	0x900		/* RISC-V vector registers */
 #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
 #define NT_LOONGARCH_CSR	0xa01	/* LoongArch control and status registers */
 #define NT_LOONGARCH_LSX	0xa02	/* LoongArch Loongson SIMD Extension registers */
-- 
2.17.1

