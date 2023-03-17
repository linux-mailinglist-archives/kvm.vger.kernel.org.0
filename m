Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0076BE85F
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjCQLht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCQLh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:37:26 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142C3A225F
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:37:01 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cn6so4789615pjb.2
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679053019;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mt/3vG/fBmUabGwDvQKWLcM8kN7QfVyattaldKY5dpc=;
        b=LxWejpj9SOMiWpIpYiWYNdEHOxUm6m9Czolyet+zZdYF7k4CdPKCq41vR70jhGMYwD
         fx8/3OPNP972jFqgbZebu7y6c8/VmharUze6TxUnWQVpRWVmzZWAkwV0PXil2RivCK2z
         lQg+F5ikZ7Sdy/28uwUneL/zqq/6qj00qEqfs0gSJ4IV8t8iYPGW259i0rlSqMHoXi1L
         RixvP5ZKGsV1hstT/CAKQkJffeYaL2HAMlqWdslffpz8LSPrVZYwjZxxyA2sOPzExxIc
         vV+YCNAoU9GJLla+uetINmOSZrnCmOVpM9d32mbrzUxADGPP9K89vmv66YrHxIBr6u1N
         j2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053019;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mt/3vG/fBmUabGwDvQKWLcM8kN7QfVyattaldKY5dpc=;
        b=D27b33iL6tWJ2MdkHtLP7hrBEjBz8k3Sm+CMUeTJlfjXYvsfr7xGhTroorF9uItIhR
         aXfvbVLShgT3ZOloQw71XidytDgK6o38YaQtPiqdaEsMROubgW1fPnQqzzMZR6Q5k8BL
         ocKec9zLAz8RWXzBTMLjnLcK95RiqdvzBLioIdMCMwH5pCLUbYHUaNeJicfd18ryuyxD
         dMz43LXyXjr35Q2JmpbV5DgGxiSW2uoBtbKUbg/VishIq7ViyEmFIcry9PElWIo0pq8L
         AqFO5trSmQ0KJNbBZqt3WfrtN8lTHxy6wGyJMPXcmZX3lrpcVXEbgQBwYhL/0JEtsdmJ
         uoFQ==
X-Gm-Message-State: AO0yUKVdDwvpi/QBgs5VOIV+GlJx37c9tI4k8elFMgbXybcHPBd9OD98
        RP3N9kGcu2tqzMspnERWM0vwuA==
X-Google-Smtp-Source: AK7set+rjC4MizyOUPvdKGEDY5pi3DD/eYGiUejRaVsNSQNB//zgC7i1MAy7okqg20XcCdrfoZauww==
X-Received: by 2002:a17:90b:1c02:b0:23b:4f2a:8016 with SMTP id oc2-20020a17090b1c0200b0023b4f2a8016mr8075509pjb.3.1679053019564;
        Fri, 17 Mar 2023 04:36:59 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:36:59 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Liao Chang <liaochang1@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH -next v15 07/19] riscv: Introduce riscv_v_vsize to record size of Vector context
Date:   Fri, 17 Mar 2023 11:35:26 +0000
Message-Id: <20230317113538.10878-8-andy.chiu@sifive.com>
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

From: Greentime Hu <greentime.hu@sifive.com>

This patch is used to detect the size of CPU vector registers and use
riscv_v_vsize to save the size of all the vector registers. It assumes all
harts has the same capabilities in a SMP system.

Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/asm/vector.h |  5 +++++
 arch/riscv/kernel/Makefile      |  1 +
 arch/riscv/kernel/cpufeature.c  |  2 ++
 arch/riscv/kernel/vector.c      | 21 +++++++++++++++++++++
 4 files changed, 29 insertions(+)
 create mode 100644 arch/riscv/kernel/vector.c

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index dfe5a321b2b4..18448e24d77b 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -13,6 +13,9 @@
 #include <asm/hwcap.h>
 #include <asm/csr.h>
 
+extern unsigned long riscv_v_vsize;
+void riscv_v_setup_vsize(void);
+
 static __always_inline bool has_vector(void)
 {
 	return riscv_has_extension_likely(RISCV_ISA_EXT_v);
@@ -31,6 +34,8 @@ static __always_inline void riscv_v_disable(void)
 #else /* ! CONFIG_RISCV_ISA_V  */
 
 static __always_inline bool has_vector(void) { return false; }
+#define riscv_v_vsize (0)
+#define riscv_v_setup_vsize()	 		do {} while (0)
 
 #endif /* CONFIG_RISCV_ISA_V */
 
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 4cf303a779ab..48d345a5f326 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_MMU) += vdso.o vdso/
 
 obj-$(CONFIG_RISCV_M_MODE)	+= traps_misaligned.o
 obj-$(CONFIG_FPU)		+= fpu.o
+obj-$(CONFIG_RISCV_ISA_V)	+= vector.o
 obj-$(CONFIG_SMP)		+= smpboot.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_SMP)		+= cpu_ops.o
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index bb1d14e08a0a..265070f0158f 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -22,6 +22,7 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/switch_to.h>
+#include <asm/vector.h>
 
 #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
 
@@ -258,6 +259,7 @@ void __init riscv_fill_hwcap(void)
 	}
 
 	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
+		riscv_v_setup_vsize();
 		/*
 		 * ISA string in device tree might have 'v' flag, but
 		 * CONFIG_RISCV_ISA_V is disabled in kernel.
diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
new file mode 100644
index 000000000000..082baf2a061f
--- /dev/null
+++ b/arch/riscv/kernel/vector.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 SiFive
+ * Author: Andy Chiu <andy.chiu@sifive.com>
+ */
+#include <linux/export.h>
+
+#include <asm/vector.h>
+#include <asm/csr.h>
+
+unsigned long riscv_v_vsize __read_mostly;
+EXPORT_SYMBOL_GPL(riscv_v_vsize);
+
+void riscv_v_setup_vsize(void)
+{
+	/* There are 32 vector registers with vlenb length. */
+	riscv_v_enable();
+	riscv_v_vsize = csr_read(CSR_VLENB) * 32;
+	riscv_v_disable();
+}
+
-- 
2.17.1

