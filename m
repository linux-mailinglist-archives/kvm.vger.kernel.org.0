Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91AA6BE847
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCQLhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCQLhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:37:11 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD0DC4EB2
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:35 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o11so5005208ple.1
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679052991;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=J7d/Gx92osy3qRALLSXR7ZlrWNvK4PrWEMcChV451s8=;
        b=m+xBO4XgfVJXwmrXKy2b1Ca527z7eYqi1jc45Ld0cKLnb3E+5xXWFZEahHIZTODdei
         /u5L9MQXCdrWm41pqboozLj68Xx4JnVezThCOYjcZhTKEzrgaKsSUbc2+G2eimdeCwy6
         uXFrnxb0njo+XYWvNE/qPaxbe1yXPH39o78Wq2qUsX1sB2Iiy/N+8LbLzHSAKVXUoXAf
         1FPGraCC2dgW50EjqubzGjRRyhmjLi61LMndpaNsL+zltni+uuxulQ2YJalPf1bOkUq+
         6E/BcZeuqnfrwGDFeNn0waQ3Nuak3gxQYQmQwuhtWexSQlTePWw4A2kD+4y6mAdoc+R0
         w2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679052991;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J7d/Gx92osy3qRALLSXR7ZlrWNvK4PrWEMcChV451s8=;
        b=rL07LViuTEqOeWtN4ZzdPxbFXs1d/POYjFKLxSyrVzHvgbg1qRPaSoRHB0/VD98i6s
         0BMvJAvPyNJwpBOm945Jysg3iUVDD+/3L6gBn5Iz45B+nYDvPTVq0bb+wvtNsjEYtGXl
         3Oa1gE5zkU06hNnpmobBJG16aKEA8x9q6T38arcJPbgJ3sdnhgykskNTa+X4Z6vEW9+9
         K5Rm3VRqyG23faxJkdxAlJTfxWokBNY4tWBdVK9/9+8RB+ucBmSt2wREC2wAtDSKavlf
         q1kidZMu7+fT4FbiWoi4/QdYRgVIjMeGpdjYyzfmwbg28Bu0YYgOusf14insVqbH8ey+
         yw7Q==
X-Gm-Message-State: AO0yUKWU+7Pg1w7h/QXEsD0okqt9ncvLixHgnRlLyRQAF//uIN66lqYU
        XWqur7t1GH2HGG1173zxWUC38g==
X-Google-Smtp-Source: AK7set9kIO/UYXlsxR9CUEAEGLj6sYySBuBnQixIDz6QQ/ABmEapr1cXxbDXZYVKANoDA2/CCzdH8w==
X-Received: by 2002:a17:90b:314e:b0:23a:177b:5bfa with SMTP id ip14-20020a17090b314e00b0023a177b5bfamr7746057pjb.22.1679052991334;
        Fri, 17 Mar 2023 04:36:31 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:36:30 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>, Atish Patra <atishp@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Tsukasa OI <research_trasio@irq.a4lg.com>
Subject: [PATCH -next v15 02/19] riscv: Extending cpufeature.c to detect V-extension
Date:   Fri, 17 Mar 2023 11:35:21 +0000
Message-Id: <20230317113538.10878-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <ren_guo@c-sky.com>

Add V-extension into riscv_isa_ext_keys array and detect it with isa
string parsing.

Signed-off-by: Guo Ren <ren_guo@c-sky.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
Co-developed-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/asm/hwcap.h      |  1 +
 arch/riscv/include/asm/vector.h     | 26 ++++++++++++++++++++++++++
 arch/riscv/include/uapi/asm/hwcap.h |  1 +
 arch/riscv/kernel/cpufeature.c      | 11 +++++++++++
 4 files changed, 39 insertions(+)
 create mode 100644 arch/riscv/include/asm/vector.h

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 0ed15c2a2816..154f1c45c8c7 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -22,6 +22,7 @@
 #define RISCV_ISA_EXT_m		('m' - 'a')
 #define RISCV_ISA_EXT_s		('s' - 'a')
 #define RISCV_ISA_EXT_u		('u' - 'a')
+#define RISCV_ISA_EXT_v		('v' - 'a')
 
 /*
  * These macros represent the logical IDs of each multi-letter RISC-V ISA
diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
new file mode 100644
index 000000000000..427a3b51df72
--- /dev/null
+++ b/arch/riscv/include/asm/vector.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2020 SiFive
+ */
+
+#ifndef __ASM_RISCV_VECTOR_H
+#define __ASM_RISCV_VECTOR_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_RISCV_ISA_V
+
+#include <asm/hwcap.h>
+
+static __always_inline bool has_vector(void)
+{
+	return riscv_has_extension_likely(RISCV_ISA_EXT_v);
+}
+
+#else /* ! CONFIG_RISCV_ISA_V  */
+
+static __always_inline bool has_vector(void) { return false; }
+
+#endif /* CONFIG_RISCV_ISA_V */
+
+#endif /* ! __ASM_RISCV_VECTOR_H */
diff --git a/arch/riscv/include/uapi/asm/hwcap.h b/arch/riscv/include/uapi/asm/hwcap.h
index 46dc3f5ee99f..c52bb7bbbabe 100644
--- a/arch/riscv/include/uapi/asm/hwcap.h
+++ b/arch/riscv/include/uapi/asm/hwcap.h
@@ -21,5 +21,6 @@
 #define COMPAT_HWCAP_ISA_F	(1 << ('F' - 'A'))
 #define COMPAT_HWCAP_ISA_D	(1 << ('D' - 'A'))
 #define COMPAT_HWCAP_ISA_C	(1 << ('C' - 'A'))
+#define COMPAT_HWCAP_ISA_V	(1 << ('V' - 'A'))
 
 #endif /* _UAPI_ASM_RISCV_HWCAP_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index a4728bf60b84..bb1d14e08a0a 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -99,6 +99,7 @@ void __init riscv_fill_hwcap(void)
 	isa2hwcap['f' - 'a'] = COMPAT_HWCAP_ISA_F;
 	isa2hwcap['d' - 'a'] = COMPAT_HWCAP_ISA_D;
 	isa2hwcap['c' - 'a'] = COMPAT_HWCAP_ISA_C;
+	isa2hwcap['v' - 'a'] = COMPAT_HWCAP_ISA_V;
 
 	elf_hwcap = 0;
 
@@ -256,6 +257,16 @@ void __init riscv_fill_hwcap(void)
 		elf_hwcap &= ~COMPAT_HWCAP_ISA_F;
 	}
 
+	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
+		/*
+		 * ISA string in device tree might have 'v' flag, but
+		 * CONFIG_RISCV_ISA_V is disabled in kernel.
+		 * Clear V flag in elf_hwcap if CONFIG_RISCV_ISA_V is disabled.
+		 */
+		if (!IS_ENABLED(CONFIG_RISCV_ISA_V))
+			elf_hwcap &= ~COMPAT_HWCAP_ISA_V;
+	}
+
 	memset(print_str, 0, sizeof(print_str));
 	for (i = 0, j = 0; i < NUM_ALPHA_EXTS; i++)
 		if (riscv_isa[0] & BIT_MASK(i))
-- 
2.17.1

