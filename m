Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CDD2EE8A1
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbhAGW2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbhAGW2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:28:11 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF9AC0612FC
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:27:56 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id y23so6842148wmi.1
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2KMW1AHx+CcjcF6oy+EHrDBlKoWTeIJxR2dMpOZQe7U=;
        b=eu/pL2XsD3VR3uKPHuTsM8iVriGrGrjPRln4TPJRfQZh9Wms+y1U2X+v2CLH7nW5uf
         s7UNpD79IzDqtqMDOI+rpEe5hMgNatDvgxevjKH69XI+BZw49OQb1xzQ9pSccDWLoe9x
         UQD8i6iXuWPjvWDV14d5xSEjIgYQ2WP4GF3aQal/85RncyXxdGPnU2uQ+eeoNOOxmpTY
         iePB7so0OQAEj9HHVscAzXTKVj8ONFLG1iH6KPpZV9r++IQUiGniQTmQ3u8uRVUve708
         YE3ZPFb7AKetOsEqIzrRp3ReKkKqbnCy18Gq2Y9QfBgWcWDMTJcgRDJcWhO0bnmmPD0G
         uSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=2KMW1AHx+CcjcF6oy+EHrDBlKoWTeIJxR2dMpOZQe7U=;
        b=SkfIIGONX0VFBrudo3TpfVeJ2uV1ZCJqhB1FaRIDmvvSH0dYLEUj8Ez/Ap2xSV6zei
         WdWzphXQJZGivgOB0jI2t+RnNUoBZ6SH+26jEjNphoBeR18TPS3bQAVul/IYJUr4AVVu
         6mBt4MPerkOfXT4dBAEpA2dLtyhbiPa6p4HK6IivhyToni7gXKT5MZIgkwHFE9r1He6w
         Qf+lbkjXXFodPO8eWshxUkJ+Muw2KAxUWXuy0OKwp2MKvSDbI2I1romPHcb8o6kSTwCP
         VBgwGOMRaEGIyCNeW8otZnDT3blezP7l/j3pECs2g/W7TAH/t2uZbFFJnY5BgBp/a8nu
         R5ww==
X-Gm-Message-State: AOAM532vDoklCc231KzPfb9eFm6peegNRNq7UYi/c4R7Q6yK+y0i29T6
        v6jt+Lkfnxc5ERXSjiNhpKg=
X-Google-Smtp-Source: ABdhPJwhlHkwhPGlw9CABxGJvzuyyJEPRsNT1YsTzkdqiwuDfohqGuCHk/Hb4esUZif9cgPQE9hFFQ==
X-Received: by 2002:a1c:2b46:: with SMTP id r67mr521041wmr.162.1610058475322;
        Thu, 07 Jan 2021 14:27:55 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id b83sm9675771wmd.48.2021.01.07.14.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:27:54 -0800 (PST)
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
Subject: [PULL 58/66] target/mips: Convert Rel6 Special2 opcode to decodetree
Date:   Thu,  7 Jan 2021 23:22:45 +0100
Message-Id: <20210107222253.20382-59-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Special2 opcode have been removed from the Release 6.

Add a single decodetree entry for all the opcode class,
triggering Reserved Instruction if ever used.

Remove unreachable check_insn_opc_removed() call.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201208203704.243704-7-f4bug@amsat.org>
---
 target/mips/mips32r6.decode  | 2 ++
 target/mips/rel6_translate.c | 7 +++++++
 target/mips/translate.c      | 2 --
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/target/mips/mips32r6.decode b/target/mips/mips32r6.decode
index 027585ee042..259bac612ab 100644
--- a/target/mips/mips32r6.decode
+++ b/target/mips/mips32r6.decode
@@ -15,3 +15,5 @@
 @lsa                ...... rs:5 rt:5 rd:5 ... sa:2 ......   &lsa
 
 LSA                 000000 ..... ..... ..... 000 .. 000101  @lsa
+
+REMOVED             011100 ----- ----- ----- ----- ------   # SPECIAL2
diff --git a/target/mips/rel6_translate.c b/target/mips/rel6_translate.c
index 631d0b87748..51264f0ce92 100644
--- a/target/mips/rel6_translate.c
+++ b/target/mips/rel6_translate.c
@@ -18,6 +18,13 @@
 #include "decode-mips32r6.c.inc"
 #include "decode-mips64r6.c.inc"
 
+bool trans_REMOVED(DisasContext *ctx, arg_REMOVED *a)
+{
+    gen_reserved_instruction(ctx);
+
+    return true;
+}
+
 static bool trans_LSA(DisasContext *ctx, arg_LSA *a)
 {
     return gen_LSA(ctx, a->rd, a->rt, a->rs, a->sa);
diff --git a/target/mips/translate.c b/target/mips/translate.c
index f4481afb8de..01c1ee546e2 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -27137,8 +27137,6 @@ static void decode_opc_special2_legacy(CPUMIPSState *env, DisasContext *ctx)
     int rs, rt, rd;
     uint32_t op1;
 
-    check_insn_opc_removed(ctx, ISA_MIPS_R6);
-
     rs = (ctx->opcode >> 21) & 0x1f;
     rt = (ctx->opcode >> 16) & 0x1f;
     rd = (ctx->opcode >> 11) & 0x1f;
-- 
2.26.2

