Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694292D9F56
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408697AbgLNSje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408911AbgLNSjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:39:10 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A55C06138C
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:24 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id t16so17456868wra.3
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pxw5yz+fseWQ/dQcwxqgNwkSctI6l6EW+pu9mjED4a0=;
        b=eG+rZt31DsZsT8XFwZ5zWXKppwa4lzEcEGnNBXebed7vDj4MxqtXSGUsR4eixHW6pm
         F3ExTzKgY2hVmLcA3Y/+M+pFCCt38W0keXX9wK3Cv3DL94W5Dl+wZkmAM6Q5BYHeC/uq
         Fw6kUyCzIjcIHR/cjpLO/lBUgMhkO1nTIP/lLf6fINpRKhD1j8odvqEWMT7oO2HPQhWz
         Y58qS5FvhifFEjWdVGKBIKj8m+/ZChqwnfdRFnXrmdxB+oOvoIuc3J56FVZjwifkdqXQ
         F2ysxu2Xu+2pRtQQC+DEtw5Mvrl4Tr7Km/4Aal9bAH4Hky2pwOiCzdCS84N6KiU5q0BD
         NKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Pxw5yz+fseWQ/dQcwxqgNwkSctI6l6EW+pu9mjED4a0=;
        b=RAfV43yhhzkDETxJW55pGJwnYYty2L9NUG396wu23FOwYRt8NKeE94mNkCoi3sIWrR
         7n1ONZQQKVSX0blPHHaEEVRTtexmZ8BLhPJavQ6zTd+mHizER60GbZICfHDGdu7fQbqv
         GW+THa+Vba8+DTJOj4eh64tbBbpeRc3XJ1fIWM1ZGVWmlDbb+tpsheW+Uo2CdAuI8fhr
         t/NSq/mis+UjQew+KfSAErkEP1UvfueZNg5YmNZJLwGHhKMAub/iEqYj3tNVqZYUyzWg
         7ijgYQ/mjTWG+Z+ak+5T8WMv0LT1bGa//rHjXIbpqtWxGbAF7xjAk6FMBYU4JiPFHXnU
         Vppg==
X-Gm-Message-State: AOAM530xbUAzfPXoAEtRTXQ7rGU4h6NcKRHqqGdxtNeeMugztKwy6BoB
        qzLF2+RTsPGkCwjpJxKDuvc=
X-Google-Smtp-Source: ABdhPJziMYXAnUWCqbPBIaNucXK2KRgqogVbVQ+OduRyvXOkAxSuRmEn6ZfGwHWYFMs9FiPSOATzPg==
X-Received: by 2002:a5d:43c3:: with SMTP id v3mr6016210wrr.184.1607971102985;
        Mon, 14 Dec 2020 10:38:22 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id e16sm36965915wra.94.2020.12.14.10.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:22 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v2 08/16] target/mips: Move mmu_init() functions to tlb_helper.c
Date:   Mon, 14 Dec 2020 19:37:31 +0100
Message-Id: <20201214183739.500368-9-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
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
index c1401492c46..968a3a8db8f 100644
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
index 2e52539a511..94a482e3dbe 100644
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
index ff14502529b..a788f5a6b6d 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -933,54 +933,6 @@ void mips_cpu_list(void)
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

