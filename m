Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823BD2EE8A8
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbhAGW2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbhAGW2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:28:42 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890B0C0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:28:01 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 190so6381143wmz.0
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85d5cVtyUsTX7S7LbQY+InlQNjjtHltMndZsoNBoSL4=;
        b=nraN2mOVUcgRgNgyVYJJSc9AtepJctiYv3inK3boLA2ZJ5R3teD2lWbDuOhqftYs4K
         aljUHeg2H14Qv7vammJ9Idv6h05/oXhGAm9OtTOebDKiVNp+B+A8FEb5pABUCP7izrju
         g62dDfEKVKuTYpF0OhcN8edwK9PN3DtdyB3deImtoW60QwcUhY3+EiSnGamg8NL7rBhW
         Z/YmYr8RylFv1/efu4dPwZB07/1+dwV/0nrqEhqgSBMPpzKtxAdEZSXBSsOYeWXBjPrS
         WEh7NaVbWnHCmc3TwNp0JOMoM45wcZ9HK4/r1MqlKEvMueeHNT7Ln9Ln6y89nhQdsMmg
         766Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=85d5cVtyUsTX7S7LbQY+InlQNjjtHltMndZsoNBoSL4=;
        b=SnJrXc+5qB0W+dB2fgTwrVbIAJ0hM4iRDm50c8qYUvBCdl3ceHvIexPadgpugAXP3c
         EZjAZ6D8mqTFjvSG7VKDnkC4FiqA7cqYI3dHYw1SfM8E+VP/eKBkO98XTkTkl/AIkCqs
         FqwJ890gXL0isCcj8koDwEC/YZo5bw7qZAwvP/G5fFmp5Zof1TWjriDvpVKeJsaLTTOn
         Z/psqgn4oAQnWQoH+v8xUiu8EQ3E0n/nNsOLuKWMGPAYyQF+lw1202v4Y7zyFRn8AKpK
         6+ac1H5DxJpiifa782h7MnNZTcDJGK7W+291qlTY5lj+O83VsG+QA8oftg7tX8zGkhLm
         CcQQ==
X-Gm-Message-State: AOAM530ozsfqEdfo2eRlm9xPNoUlgjIar9FG8NZa0qOZ4T3pIc7Thwpt
        /t4Gy3yA5F48YqXhm1D6pHE=
X-Google-Smtp-Source: ABdhPJy7r2Dm8szonCZjGKKtJ+ouK1+WaygeHI3YzUMw65d3dheae2KjeyNpEeIr7uKkwkIWUfRTXA==
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr533619wmf.134.1610058480374;
        Thu, 07 Jan 2021 14:28:00 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id z6sm9175402wmi.15.2021.01.07.14.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:27:59 -0800 (PST)
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
Subject: [PULL 59/66] target/mips: Convert Rel6 COP1X opcode to decodetree
Date:   Thu,  7 Jan 2021 23:22:46 +0100
Message-Id: <20210107222253.20382-60-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

COP1x opcode has been removed from the Release 6.

Add a single decodetree entry for it, triggering
Reserved Instruction if ever used.

Remove unreachable check_insn_opc_removed() call.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201208203704.243704-8-f4bug@amsat.org>
---
 target/mips/mips32r6.decode | 2 ++
 target/mips/translate.c     | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/mips/mips32r6.decode b/target/mips/mips32r6.decode
index 259bac612ab..7b12a1bff25 100644
--- a/target/mips/mips32r6.decode
+++ b/target/mips/mips32r6.decode
@@ -16,4 +16,6 @@
 
 LSA                 000000 ..... ..... ..... 000 .. 000101  @lsa
 
+REMOVED             010011 ----- ----- ----- ----- ------   # COP1X (COP3)
+
 REMOVED             011100 ----- ----- ----- ----- ------   # SPECIAL2
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 01c1ee546e2..52397bce84b 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28827,7 +28827,6 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
         break;
 
     case OPC_CP3:
-        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         if (ctx->CP0_Config1 & (1 << CP0C1_FP)) {
             check_cp1_enabled(ctx);
             op1 = MASK_CP3(ctx->opcode);
-- 
2.26.2

