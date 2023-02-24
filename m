Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF626A203E
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjBXRDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjBXRDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:03:41 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35F35454C
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:03:29 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s5so199760plg.0
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sQCYkWxghjLS7BAQiZptP45payXWmeGjuFJjmEJEuNw=;
        b=iG7u46voWoCSXsiGC6Ysj4m1pbjjUvB2vqFL7cTXHrPGbkWtDLDalWuivRKZXBTTfe
         kD1u/0FERjeGskarnybYskbOvXn6AYKDq09mEejyQ2Ve9fGuHqHgEiHSBck53ZOXpI4g
         6v1qPCxZ3IWdn3xjhhkeiqlW+L8Vnnd0dkkqylyO0ZYXjZmheTHjZtbxC4gmXx3ZzUHL
         fOw6b0msdExdSij/iTwNJBulPwJTbau1hxc3xCPlJ7FPzno08MfUSbODByVjxMbAVZz+
         KG3+8ra9cffVbtio4BTEJqA0sfeqN7gdTX0yz4a3naXCwKWMFUOkO4Ax9+EvwVC9ON3C
         LErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sQCYkWxghjLS7BAQiZptP45payXWmeGjuFJjmEJEuNw=;
        b=ig5++42UyPOudATu1SXpNIi44JUMpIFC2+pm7bhqfgnUj9VB8RYK9zNDzO6HV/ma64
         F1fmJgxbXe+sdPts3HTiadXWrNWy1m8m6rb6jTPi8HZmdPMWfBfG1OxQjxD+X4oXuNbN
         l6Ir3ZFy4A1xaJxJROhTdJV2he7UBQQjHTF60gyATOuF+dsOwx4W5O47RkYCga1Yd+Hw
         QhNdaw5pCF49fdKWAoubbCCFKeiZLJ3eT7mrzJgcZehvxNpQ8W+kcP18qMYkXMHZ0Sx9
         5+wzEryCBCg5G6Sk2tCaa/sBN8LlHop/bToW80KU4y9TzToiUcm3R1FFFWMyEey+5n2b
         cFqQ==
X-Gm-Message-State: AO0yUKWcGoT5RQdSkwqhwFJZnnX2gMMk7XDEwOYAsLNDUKg2T7fCSfa4
        17Yfvjmn34BGdEntEBgzAJVbqQ==
X-Google-Smtp-Source: AK7set9Ndd7cIxsBi8HJx0vn2lfPItJRZuCTbx6BWLEvEmJFMQ8OEZOrWu57xNwWs55af4DUU19VCw==
X-Received: by 2002:a17:902:b286:b0:19c:a9b8:4349 with SMTP id u6-20020a170902b28600b0019ca9b84349mr9480458plr.32.1677258209313;
        Fri, 24 Feb 2023 09:03:29 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:03:28 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH -next v14 19/19] riscv: Enable Vector code to be built
Date:   Fri, 24 Feb 2023 17:01:18 +0000
Message-Id: <20230224170118.16766-20-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230224170118.16766-1-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

This patch adds a config which enables vector feature from the kernel
space.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
Suggested-by: Atish Patra <atishp@atishpatra.org>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/Kconfig  | 18 ++++++++++++++++++
 arch/riscv/Makefile |  3 ++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 81eb031887d2..19deeb3bb36b 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -418,6 +418,24 @@ config RISCV_ISA_SVPBMT
 
 	   If you don't know what to do here, say Y.
 
+config TOOLCHAIN_HAS_V
+	bool
+	default y
+	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64iv)
+	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32iv)
+	depends on LLD_VERSION >= 140000 || LD_VERSION >= 23800
+
+config RISCV_ISA_V
+	bool "VECTOR extension support"
+	depends on TOOLCHAIN_HAS_V
+	select DYNAMIC_SIGFRAME
+	default y
+	help
+	  Say N here if you want to disable all vector related procedure
+	  in the kernel.
+
+	  If you don't know what to do here, say Y.
+
 config TOOLCHAIN_HAS_ZBB
 	bool
 	default y
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 76989561566b..375a048b11cb 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -56,6 +56,7 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
 riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
+riscv-march-$(CONFIG_RISCV_ISA_V)	:= $(riscv-march-y)v
 
 # Newer binutils versions default to ISA spec version 20191213 which moves some
 # instructions from the I extension to the Zicsr and Zifencei extensions.
@@ -65,7 +66,7 @@ riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
 # Check if the toolchain supports Zihintpause extension
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) := $(riscv-march-y)_zihintpause
 
-KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
+KBUILD_CFLAGS += -march=$(subst fdv,,$(riscv-march-y))
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
 KBUILD_CFLAGS += -mno-save-restore
-- 
2.17.1

