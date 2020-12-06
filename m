Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803A32D0822
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgLFXll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbgLFXlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:40 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF87C0613D3
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:41:00 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id i2so11043126wrs.4
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T3FlFk78pLMkupK1YI/tjtH+Hq+IGEC+koiKdnLg6D4=;
        b=Nd40X/OAaFHU7qiOSgMuQvCbYgV4L46HRjBTenvdE6K7BjJktwpHXWNVaawkhTZbhQ
         f1XDpTbKYfXjgWpc7PVXdXJcmdYjn1hMiVuHUtsfsFC65VKnFs6+HEpRYrSn9o65epuS
         5lgBLiZgQz8UrVk5IAkyx1imzjlUXcmBxmReRL8UIury8SpVuEoBWJF+SZTJmZ9U7HVI
         AlZq61DO68FzIZgkldq06THajtSF5NmsGFoDIjYw/0xsm87uVB5OezgFTXZrItwUvXYZ
         2WshCAmKuvvR9dfxG092CZwgXaPEVskHC3S/ioc07+Hob0/TSzoAcpYt7ZLuiEX7P6F9
         vFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=T3FlFk78pLMkupK1YI/tjtH+Hq+IGEC+koiKdnLg6D4=;
        b=r/C0cDgUGiOWiGnhjdjjLG7U7QsHx443TonaSvuhu6zm9E9GQWIE/ypbTm8gItATsj
         BF1bQc6L0K4PBVXqWRdc8KqxIipVGSHk4uMw04Lai0aeuTP6kYgvx0KH/VHn5d7lVlWW
         Oc5mXTRqdyTtu2+yeP8lMMgT5D334uu99JmzXOBFzhou9OGv0Jr/Q8NANZHfaUmmRFZF
         Ytrky86fd+ZrMcSlqzDJJrlm3/93NqvKIla4eGKrJAmBsAdPsTQmz4mHmPC7GQH3QYe8
         l3DfXB1QUjpSOLJpIfqv/w9PSEzMEDwhOT8PoSZZ2MdLR3clBU2Fwf1yytYdmiY95Nz8
         7euQ==
X-Gm-Message-State: AOAM531LseZffLEzG5rq+Wll5zGkHQ51VOd2u3vWYVJ9ZNYdGtoOxcPb
        5X5BKaRRR0J7GGY64O85fGs=
X-Google-Smtp-Source: ABdhPJw8IuYkegnv9iK+VaKUkUOm0Qb6xkjQ5rtQTFv+GuhbUTLtX2B/74LwkiAvEJAHYh99X9An8g==
X-Received: by 2002:a05:6000:187:: with SMTP id p7mr16728218wrx.240.1607298058923;
        Sun, 06 Dec 2020 15:40:58 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id v64sm12121580wme.25.2020.12.06.15.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:58 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 13/19] target/mips: Fix code style for checkpatch.pl
Date:   Mon,  7 Dec 2020 00:39:43 +0100
Message-Id: <20201206233949.3783184-14-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are going to move this code, fix its style first.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate_init.c.inc | 36 ++++++++++++++++----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index ea85d5c6a79..535b52b5444 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -932,19 +932,19 @@ void mips_cpu_list(void)
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
@@ -956,25 +956,25 @@ static void r4k_mmu_init (CPUMIPSState *env, const mips_def_t *def)
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

