Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6494F67B42E
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbjAYOVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbjAYOVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:21:46 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0A74858C
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:38 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p24so17974236plw.11
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pdk9Hg21UiGJKBpwTJEtp2zNNJGaWTJ6E/wOuwrGazE=;
        b=T7eGSydzCb9tsVg9VvD9J6S/VbtlVUfNp4BWLGQII0x3jm0LMpbz0LXxJO06gfWh/z
         6iPQIlBjKGFuLPoSrPEJDxdxBYILm+G3nkILHYBTL9jKZ5Nhi2v45NPRtOZBWa+s3yDQ
         hvySxHZschtGpLoON+nEFOp7qENlE1HwJn7vpMZfHYctwLrwojbkwTCmIp3LqkWlQTG1
         D64cs0edjNrfp7PlcWJYe27cDzjSZatBhkdesulr/rz/rJzHac+k9yqZmiH0Yla6braN
         r42ULyG1g1OIdpOdJ9VEYeZMd8BmZLZ4QRBLPYO319N2mbrwK3tnbdDxc4RxibPsPxqN
         8GRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pdk9Hg21UiGJKBpwTJEtp2zNNJGaWTJ6E/wOuwrGazE=;
        b=sdurWNl6XS9HDVy5eoSHnRCE/ohfWwMrKQyrOrNH59xDDFHeCoDcypGsmvwpC/M4Gg
         66SzE/42DLsNMR2p3w04YLI8Jx/kwtB/Hj6Fx1ViqjjkE9yBm2raGETUBDGs88uIP4Pl
         3G0G9Wwq2JhNNrLMwq9WHMCH8RWd5l51YNWo5rJ4dqsuzxcNd3fOKqFUOla3Id/sWocx
         uYVyntKMWo4BJHwc3wmWbrx6358NbV0j+B22ddjHeSCY9EyTNuZGp0ZpAJlhRTEV/t3U
         Heci3v7nydu4p18FyzFo0Dd/J9KBOMVLVNCNgEPpI3rTJw78wuGgi/qp8CcIHJ1KoGoi
         SycQ==
X-Gm-Message-State: AFqh2krzHO8SzyYcJWN+euoJ71bfNsLuYTd6ajfdqRmiCt8eS+2Aq3Jp
        CgBmwtEA/BJMr+ICgjdfN5IQVPWk5t0Vdk11
X-Google-Smtp-Source: AMrXdXtK5TgYd7QRGlqkQx3V6zKwI+owEPLnQGHOFH0yT2oZD/AVKYYxogM5JfQLtu4ECIURORpMLA==
X-Received: by 2002:a05:6a20:8c24:b0:9d:efbe:a0f1 with SMTP id j36-20020a056a208c2400b0009defbea0f1mr29905022pzh.1.1674656498014;
        Wed, 25 Jan 2023 06:21:38 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id bu11-20020a63294b000000b004a3510effa5sm3203520pgb.65.2023.01.25.06.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:21:37 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: [PATCH -next v13 07/19] riscv: Introduce riscv_vsize to record size of Vector context
Date:   Wed, 25 Jan 2023 14:20:44 +0000
Message-Id: <20230125142056.18356-8-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230125142056.18356-1-andy.chiu@sifive.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

This patch is used to detect the size of CPU vector registers and use
riscv_vsize to save the size of all the vector registers. It assumes all
harts has the same capabilities in a SMP system.

[guoren@linux.alibaba.com: add has_vector checking]
Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/include/asm/vector.h |  3 +++
 arch/riscv/kernel/cpufeature.c  | 12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 0fda0faf5277..16cb4a1c1230 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -13,6 +13,8 @@
 #include <asm/hwcap.h>
 #include <asm/csr.h>
 
+extern unsigned long riscv_vsize;
+
 static __always_inline bool has_vector(void)
 {
 	return static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_VECTOR]);
@@ -31,6 +33,7 @@ static __always_inline void rvv_disable(void)
 #else /* ! CONFIG_RISCV_ISA_V  */
 
 static __always_inline bool has_vector(void) { return false; }
+#define riscv_vsize (0)
 
 #endif /* CONFIG_RISCV_ISA_V */
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index c433899542ff..3aaae4e0b963 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -21,6 +21,7 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/switch_to.h>
+#include <asm/vector.h>
 
 #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
 
@@ -31,6 +32,10 @@ static DECLARE_BITMAP(riscv_isa, RISCV_ISA_EXT_MAX) __read_mostly;
 
 DEFINE_STATIC_KEY_ARRAY_FALSE(riscv_isa_ext_keys, RISCV_ISA_EXT_KEY_MAX);
 EXPORT_SYMBOL(riscv_isa_ext_keys);
+#ifdef CONFIG_RISCV_ISA_V
+unsigned long riscv_vsize __read_mostly;
+EXPORT_SYMBOL_GPL(riscv_vsize);
+#endif
 
 /**
  * riscv_isa_extension_base() - Get base extension word
@@ -258,7 +263,12 @@ void __init riscv_fill_hwcap(void)
 	}
 
 	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
-#ifndef CONFIG_RISCV_ISA_V
+#ifdef CONFIG_RISCV_ISA_V
+		/* There are 32 vector registers with vlenb length. */
+		rvv_enable();
+		riscv_vsize = csr_read(CSR_VLENB) * 32;
+		rvv_disable();
+#else
 		/*
 		 * ISA string in device tree might have 'v' flag, but
 		 * CONFIG_RISCV_ISA_V is disabled in kernel.
-- 
2.17.1

