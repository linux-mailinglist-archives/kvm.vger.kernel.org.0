Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7952B2D9F5E
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408597AbgLNSjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408907AbgLNSjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:39:05 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E21BC0617B0
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:19 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id v14so14685282wml.1
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1YHqfW9C9zJMYC4AZlw/rgEaF/1fbEs/5bZEvXJxOms=;
        b=NFZKb47HS15qKB3UYMr+dzqvtDKW4LVGYn53nUuezRuuuZx0/i+K9MpNxIaDZQkfD7
         o9XG0NfiKVZAZCviwFql8IBz5V4qlv3xKF/AnfImdPOU6cg0sw22R45IkKZIvOk9e2+x
         PsTMXsFYEasWyTX7FJOX2/8Ef0nf99oADa8+d9c8v4C+jhIYCVUIRnZLAlcCuFTrMpSr
         LKGQWD57apC7qhn+WBRbcQmORjXvXY24jm/Ism+alV6z5uRJ5mPICo+nle0BD2vlJy+c
         bW+0hx1pyfIY/rHS3Iib1Q4H47kvRSp5Pe+4fW/qHfF04v++9DU4Mw4eH64by8e+PUXF
         X1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=1YHqfW9C9zJMYC4AZlw/rgEaF/1fbEs/5bZEvXJxOms=;
        b=T+oNawNisy4uDrC11aq7WjNkEKrVKmZKB2WydHufUoQwf4n6KcD3M67S1iuL6C78SF
         1V5rfFQwAFEBSF+0OA00XtQC9VxG7vLejFV2mggBJ5h/e6zk+Ic7MnKlddWf1GxGhlbO
         Uxmwl1z/6GsehM4HwjrgEAhDK4f10q6iWmdPWo8u2VkRp4T8NWLfP0VZqxvda+jVch0j
         7t8XAaakvvgQyVsxt57k/AtZc9cDHdKfLlAfqLH5wPVhUL7xU1v+vPF6kt1IyzQE/SYa
         cHy2BVSmbK0aP/eFuXytOxV4htU8kwR5tIkPErnUU8c9NmsJUOFDZZ5RSpXGhUE04WBF
         Z1cQ==
X-Gm-Message-State: AOAM531+PVDmbxN5OjexczgZGdd2ILmz7W46b/8ccuzcLhLncAFa7ZQk
        XYyoF/CHzPwIQ4tGnmBvdzo=
X-Google-Smtp-Source: ABdhPJxwtUczlKopDRSmG1EyYSoU0DtPkmTvGdqnbZDV9LhACCcRBx2qy8ZipUeryy41Sg/B180lGQ==
X-Received: by 2002:a1c:790f:: with SMTP id l15mr29516909wme.188.1607971097824;
        Mon, 14 Dec 2020 10:38:17 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id j10sm15660953wmj.7.2020.12.14.10.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:17 -0800 (PST)
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
Subject: [PATCH v2 07/16] target/mips: Fix code style for checkpatch.pl
Date:   Mon, 14 Dec 2020 19:37:30 +0100
Message-Id: <20201214183739.500368-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are going to move this code, fix its style first.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-14-f4bug@amsat.org>
---
 target/mips/translate_init.c.inc | 36 ++++++++++++++++----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index 915277dd1f6..ff14502529b 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -934,19 +934,19 @@ void mips_cpu_list(void)
 }
 
 #ifndef CONFIG_USER_ONLY
-static void no_mmu_init (CPUMIPSState *env, const mips_def_t *def)
+static void no_mmu_init(CPUMIPSState *env, const mips_def_t *def)
 {
     env->tlb->nb_tlb = 1;
     env->tlb->map_address = &no_mmu_map_address;
 }
 
-static void fixed_mmu_init (CPUMIPSState *env, const mips_def_t *def)
+static void fixed_mmu_init(CPUMIPSState *env, const mips_def_t *def)
 {
     env->tlb->nb_tlb = 1;
     env->tlb->map_address = &fixed_mmu_map_address;
 }
 
-static void r4k_mmu_init (CPUMIPSState *env, const mips_def_t *def)
+static void r4k_mmu_init(CPUMIPSState *env, const mips_def_t *def)
 {
     env->tlb->nb_tlb = 1 + ((def->CP0_Config1 >> CP0C1_MMU) & 63);
     env->tlb->map_address = &r4k_map_address;
@@ -958,25 +958,25 @@ static void r4k_mmu_init (CPUMIPSState *env, const mips_def_t *def)
     env->tlb->helper_tlbinvf = r4k_helper_tlbinvf;
 }
 
-static void mmu_init (CPUMIPSState *env, const mips_def_t *def)
+static void mmu_init(CPUMIPSState *env, const mips_def_t *def)
 {
     env->tlb = g_malloc0(sizeof(CPUMIPSTLBContext));
 
     switch (def->mmu_type) {
-        case MMU_TYPE_NONE:
-            no_mmu_init(env, def);
-            break;
-        case MMU_TYPE_R4000:
-            r4k_mmu_init(env, def);
-            break;
-        case MMU_TYPE_FMT:
-            fixed_mmu_init(env, def);
-            break;
-        case MMU_TYPE_R3000:
-        case MMU_TYPE_R6000:
-        case MMU_TYPE_R8000:
-        default:
-            cpu_abort(env_cpu(env), "MMU type not supported\n");
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
     }
 }
 #endif /* CONFIG_USER_ONLY */
-- 
2.26.2

