Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464E62EE87E
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbhAGWZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbhAGWZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:27 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAD2C0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:25:12 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id g185so6831629wmf.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6XvVGZx0cqMA0IbQkfNJyPnGsDJniknsO06wunE5/50=;
        b=ezh6a3ocDKcM3HI5iUhq5PBvcWgBK6BAd72QFsj39sGkwnDwvhQdaV5iJJgPxAbjgX
         HnDcp6QHSFr30gEXPigbeRotkjQuy+0x8yOxLQ+vSo7KwCR7kcawa3OOwDFLNLFiQ44X
         BNy8P/+0lKH8gGfuIlLWIBfbOsJFq2sJ3VOpq7huvycAOEukEStVh/ubgtZGZ5jNbFfP
         Kyk5mLSLM7owCBRrzDqeG2CgEsfggdFBXljf7DHJcCLc7d1jGPgej3V3ytbunLn2HZOT
         sWiQ7n6nPysUeqkZwkoDKbfj/3BgMba1pTJuxNLCZKjm9XBbrgi3ckpUkz33L1/W8Jsx
         xF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=6XvVGZx0cqMA0IbQkfNJyPnGsDJniknsO06wunE5/50=;
        b=dpE3zMd4reLtb3REpMeJXNXeX1CHuw84q4teJW4TXwkab4rXaTxvG0IIa/ynggLbuW
         QEj1+6AZRWw7+KVqiaKXgr5iWYtqaleucfJgVsv8/qlj6JDTzsmFEZgj29fZRq+ij6jj
         PvyRlD1Ez2xtvxSb31PMjqANIaYnv2OkW/I6P34JvgWNXzUy93DrQv9poCtFFYeHFPHr
         u7nzwWxoBq+Fev78Ww4J9x0kCnyMc7bBr+YMU142rbHBLQ23peGUQh31bY8LMM/iD6R2
         0AbGWqBKhRSIfrOI1k/2slwO0a9mAvC5QR605TlgJC22xDRVhTJL7N0ZOb7P1p2KS/A8
         A8EQ==
X-Gm-Message-State: AOAM530fLp04PzP+W/qNi/RdO5r/ZnHxFrvoxa5eo+eQKGa7UzvPdusY
        6j4qn1032D7d9XkHWyQl9CE=
X-Google-Smtp-Source: ABdhPJx6x49t860Ji4WBqZXY+0iRVBS0DuxcRHaO7i+LjJx6y6RwOhS5Mayfg4WzxVVZyQstZYej7w==
X-Received: by 2002:a7b:ce02:: with SMTP id m2mr482037wmc.111.1610058311180;
        Thu, 07 Jan 2021 14:25:11 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id w18sm10304215wrn.2.2021.01.07.14.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:25:10 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 26/66] target/mips: Move mmu_init() functions to tlb_helper.c
Date:   Thu,  7 Jan 2021 23:22:13 +0100
Message-Id: <20210107222253.20382-27-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-15-f4bug@amsat.org>
---
 target/mips/internal.h           |  1 +
 target/mips/tlb_helper.c         | 46 ++++++++++++++++++++++++++++++
 target/mips/translate_init.c.inc | 48 --------------------------------
 3 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index ae1181d2029..9a7698019e2 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -207,6 +207,7 @@ void cpu_mips_start_count(CPUMIPSState *env);
 void cpu_mips_stop_count(CPUMIPSState *env);
 
 /* helper.c */
+void mmu_init(CPUMIPSState *env, const mips_def_t *def);
 bool mips_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
                        bool probe, uintptr_t retaddr);
diff --git a/target/mips/tlb_helper.c b/target/mips/tlb_helper.c
index b02c0479e79..082c17928d3 100644
--- a/target/mips/tlb_helper.c
+++ b/target/mips/tlb_helper.c
@@ -120,6 +120,52 @@ int r4k_map_address(CPUMIPSState *env, hwaddr *physical, int *prot,
     return TLBRET_NOMATCH;
 }
 
+static void no_mmu_init(CPUMIPSState *env, const mips_def_t *def)
+{
+    env->tlb->nb_tlb = 1;
+    env->tlb->map_address = &no_mmu_map_address;
+}
+
+static void fixed_mmu_init(CPUMIPSState *env, const mips_def_t *def)
+{
+    env->tlb->nb_tlb = 1;
+    env->tlb->map_address = &fixed_mmu_map_address;
+}
+
+static void r4k_mmu_init(CPUMIPSState *env, const mips_def_t *def)
+{
+    env->tlb->nb_tlb = 1 + ((def->CP0_Config1 >> CP0C1_MMU) & 63);
+    env->tlb->map_address = &r4k_map_address;
+    env->tlb->helper_tlbwi = r4k_helper_tlbwi;
+    env->tlb->helper_tlbwr = r4k_helper_tlbwr;
+    env->tlb->helper_tlbp = r4k_helper_tlbp;
+    env->tlb->helper_tlbr = r4k_helper_tlbr;
+    env->tlb->helper_tlbinv = r4k_helper_tlbinv;
+    env->tlb->helper_tlbinvf = r4k_helper_tlbinvf;
+}
+
+void mmu_init(CPUMIPSState *env, const mips_def_t *def)
+{
+    env->tlb = g_malloc0(sizeof(CPUMIPSTLBContext));
+
+    switch (def->mmu_type) {
+    case MMU_TYPE_NONE:
+        no_mmu_init(env, def);
+        break;
+    case MMU_TYPE_R4000:
+        r4k_mmu_init(env, def);
+        break;
+    case MMU_TYPE_FMT:
+        fixed_mmu_init(env, def);
+        break;
+    case MMU_TYPE_R3000:
+    case MMU_TYPE_R6000:
+    case MMU_TYPE_R8000:
+    default:
+        cpu_abort(env_cpu(env), "MMU type not supported\n");
+    }
+}
+
 static int is_seg_am_mapped(unsigned int am, bool eu, int mmu_idx)
 {
     /*
diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index 21ee22c05dc..535d4c0c702 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -935,54 +935,6 @@ void mips_cpu_list(void)
     }
 }
 
-#ifndef CONFIG_USER_ONLY
-static void no_mmu_init(CPUMIPSState *env, const mips_def_t *def)
-{
-    env->tlb->nb_tlb = 1;
-    env->tlb->map_address = &no_mmu_map_address;
-}
-
-static void fixed_mmu_init(CPUMIPSState *env, const mips_def_t *def)
-{
-    env->tlb->nb_tlb = 1;
-    env->tlb->map_address = &fixed_mmu_map_address;
-}
-
-static void r4k_mmu_init(CPUMIPSState *env, const mips_def_t *def)
-{
-    env->tlb->nb_tlb = 1 + ((def->CP0_Config1 >> CP0C1_MMU) & 63);
-    env->tlb->map_address = &r4k_map_address;
-    env->tlb->helper_tlbwi = r4k_helper_tlbwi;
-    env->tlb->helper_tlbwr = r4k_helper_tlbwr;
-    env->tlb->helper_tlbp = r4k_helper_tlbp;
-    env->tlb->helper_tlbr = r4k_helper_tlbr;
-    env->tlb->helper_tlbinv = r4k_helper_tlbinv;
-    env->tlb->helper_tlbinvf = r4k_helper_tlbinvf;
-}
-
-static void mmu_init(CPUMIPSState *env, const mips_def_t *def)
-{
-    env->tlb = g_malloc0(sizeof(CPUMIPSTLBContext));
-
-    switch (def->mmu_type) {
-    case MMU_TYPE_NONE:
-        no_mmu_init(env, def);
-        break;
-    case MMU_TYPE_R4000:
-        r4k_mmu_init(env, def);
-        break;
-    case MMU_TYPE_FMT:
-        fixed_mmu_init(env, def);
-        break;
-    case MMU_TYPE_R3000:
-    case MMU_TYPE_R6000:
-    case MMU_TYPE_R8000:
-    default:
-        cpu_abort(env_cpu(env), "MMU type not supported\n");
-    }
-}
-#endif /* CONFIG_USER_ONLY */
-
 static void fpu_init (CPUMIPSState *env, const mips_def_t *def)
 {
     int i;
-- 
2.26.2

