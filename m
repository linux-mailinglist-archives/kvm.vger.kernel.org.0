Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40DC6C6BBB
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 16:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjCWPA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 11:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbjCWPAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 11:00:21 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E9210277
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:00:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a16so17366512pjs.4
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 08:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679583615;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vEs6CRaMiSaSyMADyPFyhJnxav5yWBpTn1OIiNt7Cro=;
        b=PD5b2CTWH2BDVtVrIbqAxDC1ItVk913jsFn09/fpt0+ikj+GTbnSy6M5cuYmdLcN+o
         8+7ZNgE8RsIFOCfO1yLx6ABE3pNe8XysSVymyblKGXHDoJTUeK6pC/F2cd+DspnWNY1Y
         xi/jWUVAVv7zDkRnjQ5KfhW3ANQMFL3dA3BlOUWeJ3Xkde165ttM+mXb23sGuM60bofX
         JK3xz1bbszOU0/18X0yjPMqrkm6C8OUXNsD6VpaPHOKIS+TYZLD0QmePaqg466MSgNyx
         linu7uAbKyFmA3JPyI7i2co975WIZzRspmvK7xW+d2ud9CyD7D+aJcfpK2s+Zn4SOVrk
         mbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679583615;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vEs6CRaMiSaSyMADyPFyhJnxav5yWBpTn1OIiNt7Cro=;
        b=NasQCENcGdfT7NpCGlFYFETuOl6lHSbvUz3vWB3/wUPVvW04tiY59RrZXm/cpArO7+
         VslzETqUTa/0lGvfxxROS4JlaUljml1IKoDV9i91RgdUVUGc3kV1TNipnd30XeUaKSjY
         ADZOVlnIfU49Jlio16RWZz0NOzJ84N0MtEDcEg5hcQk4yNM5UBZD86JLFgQLAPVZHqzd
         Im2fVtXZW0URRAcv4ZFp1IuHTNc6v0gz97VrHQkapXR/VeZymzPcLVee09TSYhcXVpdV
         k98lgTQd5SeBerLtCmzSD46IYsssNWdj7KEhAJSWdfu8xXVq5M4UukZkj+ulYnfGGDM2
         TW2g==
X-Gm-Message-State: AO0yUKV1+3STG3i34g4snN1zSr00xZhZyFXzsMBvjKjXV9xvZOUL5Tmj
        HT139FPB5kS1GLXuFZXDN8nQEQ==
X-Google-Smtp-Source: AK7set+PtVegPK51VFFk78fLlqp5HSdE85hJsVjyxbQGFMw0HWCd68xqflXn7JKfh7vFpjwOj7Qeng==
X-Received: by 2002:a17:903:64e:b0:1a1:c0e6:d8d6 with SMTP id kh14-20020a170903064e00b001a1c0e6d8d6mr5931238plb.54.1679583615268;
        Thu, 23 Mar 2023 08:00:15 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019f53e0f136sm12503965plo.232.2023.03.23.08.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 08:00:14 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH -next v16 07/20] riscv: Introduce riscv_v_vsize to record size of Vector context
Date:   Thu, 23 Mar 2023 14:59:11 +0000
Message-Id: <20230323145924.4194-8-andy.chiu@sifive.com>
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
 arch/riscv/kernel/vector.c      | 20 ++++++++++++++++++++
 4 files changed, 28 insertions(+)
 create mode 100644 arch/riscv/kernel/vector.c

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index dfe5a321b2b4..e433ba3cd4da 100644
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
+#define riscv_v_setup_vsize()			do {} while (0)
 
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
index 923ca75f2192..267070f3cc9e 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -17,6 +17,7 @@
 #include <asm/hwcap.h>
 #include <asm/patch.h>
 #include <asm/processor.h>
+#include <asm/vector.h>
 
 #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
 
@@ -263,6 +264,7 @@ void __init riscv_fill_hwcap(void)
 	}
 
 	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
+		riscv_v_setup_vsize();
 		/*
 		 * ISA string in device tree might have 'v' flag, but
 		 * CONFIG_RISCV_ISA_V is disabled in kernel.
diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
new file mode 100644
index 000000000000..03582e2ade83
--- /dev/null
+++ b/arch/riscv/kernel/vector.c
@@ -0,0 +1,20 @@
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
-- 
2.17.1

