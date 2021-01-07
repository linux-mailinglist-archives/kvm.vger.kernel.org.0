Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242532EE85B
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbhAGWXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAGWXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:23:48 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BC5C0612F6
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:07 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id n16so5680328wmc.0
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+5gxhXnPVS+EmwiIP+LC6CRqrj3N73XVIMAHkwrkkuk=;
        b=UsfXlI+TbWdQdaUfwWdRfbxO8P+8XB5wKI0zUFGsVeVhjL++Yj7b0MzEJLWhzoeNJ2
         QK2QcK/yZXaZ7X1Gwr+tYJYkTMXHBz7azKGrWATr0hW0vKIBS3zH62+RIojLiThUrT49
         MSq8Pzs+MVTHHIqabNpoOxAybytLjI7a6lVJqPb435sccUTDp9ygBDZ/AIDg3Kj31sgL
         91bLkujoqPC6bl6D8iMbBOXw2Zr1fjHvjRa9ECdEMArYesGyqrNQrCtcJ5q/C7DFEo+c
         TNzcRXoDdgeeaWFtQ7EB7nXLY04gcAem/lR8SZE2smXgHIjbie0cAZcCDgkwKTn3Yun9
         j8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=+5gxhXnPVS+EmwiIP+LC6CRqrj3N73XVIMAHkwrkkuk=;
        b=iq1aZlOfNpu6h226oxL14ZUfvzqPIXIsmWGdh6ugxXZN5M/PJTH0/ZoMQGAeTuh2yH
         wiW5+oDILJ+0nIqs7ZZrtVnjvl/GXRhhaNBJ0v6foiPX0xeltlD/XrQ9Om2BJusee3FN
         bv2b5sm4lKOePxWdGXt//cIGhrnlCN4d6xqYO1Fic38iFfI6SkXgTbcQpBSpCXbokXlJ
         ABky7aaLc6Z80ORgUEB1mwgvu/ykxEGbqhMXovi2/p8C7Vj0wg34++76ZyIvgOb71028
         XrwM8zXmgATzFujbBRTpMhUtIsUh48Nk0rlae4Gw7H2ecY9FIPUmyjU3UjqZHMHVGPE/
         +2wA==
X-Gm-Message-State: AOAM531m9ve3FBy0QNfCuSuMptwzTTuwSxn+v3NA5YcPOjNEfSGQyV8t
        Xo0KFcpkD0UBOuMGt1QvlaA=
X-Google-Smtp-Source: ABdhPJx8vDUwzrJghUt0/rCE93jpLdwKg32Sc+17jrccybyhDqY0AAjbyR2/52kuueElTbq+kesoFQ==
X-Received: by 2002:a1c:4d12:: with SMTP id o18mr526276wmh.114.1610058186556;
        Thu, 07 Jan 2021 14:23:06 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id y130sm10116378wmc.22.2021.01.07.14.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:05 -0800 (PST)
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
Subject: [PULL 02/66] target/mips: Replace CP0_Config0 magic values by proper definitions
Date:   Thu,  7 Jan 2021 23:21:49 +0100
Message-Id: <20210107222253.20382-3-f4bug@amsat.org>
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
Message-Id: <20201201132817.2863301-3-f4bug@amsat.org>
---
 target/mips/translate_init.c.inc | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index f72fee3b40a..cac3d241831 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -495,7 +495,8 @@ const mips_def_t mips_defs[] =
         .name = "R4000",
         .CP0_PRid = 0x00000400,
         /* No L2 cache, icache size 8k, dcache size 8k, uncached coherency. */
-        .CP0_Config0 = (1 << 17) | (0x1 << 9) | (0x1 << 6) | (0x2 << CP0C0_K0),
+        .CP0_Config0 = (2 << CP0C0_Impl) | (1 << CP0C0_IC) | (1 << CP0C0_DC) |
+                       (2 << CP0C0_K0),
         /* Note: Config1 is only used internally, the R4000 has only Config0. */
         .CP0_Config1 = (1 << CP0C1_FP) | (47 << CP0C1_MMU),
         .CP0_LLAddr_rw_bitmask = 0xFFFFFFFF,
@@ -516,7 +517,8 @@ const mips_def_t mips_defs[] =
         .name = "VR5432",
         .CP0_PRid = 0x00005400,
         /* No L2 cache, icache size 8k, dcache size 8k, uncached coherency. */
-        .CP0_Config0 = (1 << 17) | (0x1 << 9) | (0x1 << 6) | (0x2 << CP0C0_K0),
+        .CP0_Config0 = (2 << CP0C0_Impl) | (1 << CP0C0_IC) | (1 << CP0C0_DC) |
+                       (2 << CP0C0_K0),
         .CP0_Config1 = (1 << CP0C1_FP) | (47 << CP0C1_MMU),
         .CP0_LLAddr_rw_bitmask = 0xFFFFFFFFL,
         .CP0_LLAddr_shift = 4,
@@ -766,8 +768,8 @@ const mips_def_t mips_defs[] =
         .name = "Loongson-2E",
         .CP0_PRid = 0x6302,
         /* 64KB I-cache and d-cache. 4 way with 32 bit cache line size.  */
-        .CP0_Config0 = (0x1<<17) | (0x1<<16) | (0x1<<11) | (0x1<<8) |
-                       (0x1<<5) | (0x1<<4) | (0x1<<1),
+        .CP0_Config0 = (3 << CP0C0_Impl) | (4 << CP0C0_IC) | (4 << CP0C0_DC) |
+                       (1 << CP0C0_IB) | (1 << CP0C0_DB) | (0x2 << CP0C0_K0),
         /* Note: Config1 is only used internally,
            Loongson-2E has only Config0.  */
         .CP0_Config1 = (1 << CP0C1_FP) | (47 << CP0C1_MMU),
@@ -786,8 +788,8 @@ const mips_def_t mips_defs[] =
         .name = "Loongson-2F",
         .CP0_PRid = 0x6303,
         /* 64KB I-cache and d-cache. 4 way with 32 bit cache line size.  */
-        .CP0_Config0 = (0x1<<17) | (0x1<<16) | (0x1<<11) | (0x1<<8) |
-                       (0x1<<5) | (0x1<<4) | (0x1<<1),
+        .CP0_Config0 = (3 << CP0C0_Impl) | (4 << CP0C0_IC) | (4 << CP0C0_DC) |
+                       (1 << CP0C0_IB) | (1 << CP0C0_DB) | (0x2 << CP0C0_K0),
         /* Note: Config1 is only used internally,
            Loongson-2F has only Config0.  */
         .CP0_Config1 = (1 << CP0C1_FP) | (47 << CP0C1_MMU),
-- 
2.26.2

