Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6081F2EE87C
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbhAGWZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728378AbhAGWZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:22 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15883C0612FB
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:25:07 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id r4so6804372wmh.5
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZbrS3lwYRxTRTFDPc0/zNPF7RtQTn+hbYyf7KgsVbYc=;
        b=lIkcglkgVN21uCEiEunLDhrdJAPFUj+xEtRIzT62MEGmRZHsmaCrQxDp1vg7xM09wn
         CpTf3suuwqPqpdM6NboTUEgrH8e8+a6zikA+3Jl9tDWzHl2+qE5U63z8mEJYRHQA2YLt
         j2r0h8OZHsOnOMt5ZPyZ2fiW5d5aAE2KI1M1YMr70tv+pnh7OFTN162aCZbqnnICp2tU
         RuEL+3V4TfAPJKecrTS/fHFFbpMMcmk1ZwYiTK9kC+PVLq+wPmW/G6fXWDlS86IHAqGO
         Vzm1cPM0FZ3xWpNNKCka5C+6RYjjJne3GjyNffGdZNQEgBpLYbILz4buTquH47RQ3MTx
         hJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ZbrS3lwYRxTRTFDPc0/zNPF7RtQTn+hbYyf7KgsVbYc=;
        b=dk05FvI96viDD57djZgh2OtKAYS17Q1x25MLCya0oXkw4Gbzv7Jpa7IofVRDkNk9Vx
         kBYE790rclAJ6KxAFJ5IcbIHmuLQJsz1BrHQPtoQok2R9zcVyDM2VmHHubdN2aHnjtnw
         PXL2LwqnGcQ1lJNiXXetQZoV/eO/H43tq6cUFifufaaY7GwWJqMqd/6MjfSMjkI//d0l
         jNrh7Gkgjj+ybo5P2xHzP0kodCZEncTn3R3ES+mhDUApJV27iy/v0XVk/5ZLQbx/V34N
         ezqvBsOpmgqRc033jWKEMVgncKjpP3823yV35rVZwz6sp7bV4bJE9W8OvD1/oQUcZhZM
         T32A==
X-Gm-Message-State: AOAM532EP2ACOkcQ/P1TUZx+2ERbV99fNHLsfsPRK/xZCJqXiMuQc/Ok
        ljaC19QYLHGOEqTCliqcrpE=
X-Google-Smtp-Source: ABdhPJzbX3i0+o+WsTnVEJ4EExrsavAWV4+8h19zG+o5Hahro23lxmuhWyBBgQorIBRxeCpsbjMgAQ==
X-Received: by 2002:a7b:c406:: with SMTP id k6mr520768wmi.90.1610058305846;
        Thu, 07 Jan 2021 14:25:05 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id m2sm9131291wml.34.2021.01.07.14.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:25:05 -0800 (PST)
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
Subject: [PULL 25/66] target/mips: Fix code style for checkpatch.pl
Date:   Thu,  7 Jan 2021 23:22:12 +0100
Message-Id: <20210107222253.20382-26-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
index 044052fb77c..21ee22c05dc 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -936,19 +936,19 @@ void mips_cpu_list(void)
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
@@ -960,25 +960,25 @@ static void r4k_mmu_init (CPUMIPSState *env, const mips_def_t *def)
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

