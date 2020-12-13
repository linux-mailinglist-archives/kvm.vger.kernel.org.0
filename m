Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8132E2D9063
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393046AbgLMUVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390355AbgLMUVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:21 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1407CC0613CF
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:35 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id v14so11953120wml.1
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SiRxwMOsvHMX7da84kOf25+ipqu85MeG7Znceh6cVl0=;
        b=KsQv3qbOe+LI/cP5EbRVc/SVzgzrUF2ZAG/DrKk9RxDzkO0u6E03MnxQWFY+mGEd9D
         /hvwr8carDz8ZIbGZ+BIEDf5/jGNRzqNUIkp0H8jOyVxRKJh068pHSaZlm6rLALMF4fo
         pq6k7mFzjPpMPDe5j73MXeYWB8PQ/ceA/TP8EctzpGirpk+N0nD9ZDZ08IsLJ/gendvX
         7VczUnp/wZk8oQU9W5qWER5e//1av8L5t+znrnIBpuCNRkR+PFBpPERulsbIWmY6ZvTj
         Ld0VBislp5Cwde6JQiZ0cub52eYHa7l27ShjMOwudC2wbeHIraeP6bg2JoTS568jpp2x
         TvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=SiRxwMOsvHMX7da84kOf25+ipqu85MeG7Znceh6cVl0=;
        b=iyLWr8zkodQ+VEwEPwAuQ9fdlB8waitqU98T5Y1rqszYN2oDGxGylfdjUWjczpo9hm
         Uzex1tnwH7FurvheaOrYh9vFwAn0SDvBsOLzK1oqjoYMrKol1gUxHanMnaMnnzIWMCXG
         tfkeos6ibToW6sSf+ntK9h4Dhs6pTkgQicSmYVMiXBu/fi6US1MgqctIRksUeNeSEKpG
         sCQGGVE/RwScoSU1Dqo3NEt5qdj6utHF5Fnr3XECttMi4HgpVGVCulVgD+u6d9dWqktr
         Uai74HbCqR6WAKCNI9upWgdrNAr+rDKq8pO7MgKI24M9z49OG8OYlK/zy7756tkRy5fC
         RhKw==
X-Gm-Message-State: AOAM531yzBlihXT3ZnilD3AlOyTUWOafxkGXTnaniKpJc+TbSmIey9T5
        7Bx2EKaBJtsdAqg17bjRvD3R9qfIHgY=
X-Google-Smtp-Source: ABdhPJxDuA+DFk/Zc3/I9RhXui88zg7XTIi8CvF9r8p0+haLdCa3xW3ioiFyX+skKOBc1htwpOepaw==
X-Received: by 2002:a1c:b657:: with SMTP id g84mr24544929wmf.181.1607890833832;
        Sun, 13 Dec 2020 12:20:33 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id w3sm27387242wma.3.2020.12.13.12.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:33 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PULL 09/26] target/mips: Allow executing MSA instructions on Loongson-3A4000
Date:   Sun, 13 Dec 2020 21:19:29 +0100
Message-Id: <20201213201946.236123-10-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Loongson-3A4000 is a GS464V-based processor with MIPS MSA ASE:
https://www.mail-archive.com/qemu-devel@nongnu.org/msg763059.html

Commit af868995e1b correctly set the 'MSA present' bit of Config3
register, but forgot to allow the MSA instructions decoding in
insn_flags, so executing them triggers a 'Reserved Instruction'.

Fix by adding the ASE_MSA mask to insn_flags.

Fixes: af868995e1b ("target/mips: Add Loongson-3 CPU definition")
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Huacai Chen <chenhc@lemote.com>
Message-Id: <20201130102228.2395100-1-f4bug@amsat.org>
---
 target/mips/translate_init.c.inc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index ea85d5c6a79..79f75ed863c 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -832,7 +832,7 @@ const mips_def_t mips_defs[] =
         .mmu_type = MMU_TYPE_R4000,
     },
     {
-        .name = "Loongson-3A4000",
+        .name = "Loongson-3A4000", /* GS464V-based */
         .CP0_PRid = 0x14C000,
         /* 64KB I-cache and d-cache. 4 way with 32 bit cache line size.  */
         .CP0_Config0 = MIPS_CONFIG0 | (0x1 << CP0C0_AR) | (0x2 << CP0C0_AT) |
@@ -885,7 +885,7 @@ const mips_def_t mips_defs[] =
         .CP1_fcr31_rw_bitmask = 0xFF83FFFF,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_LOONGSON3A,
+        .insn_flags = CPU_LOONGSON3A | ASE_MSA,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
-- 
2.26.2

