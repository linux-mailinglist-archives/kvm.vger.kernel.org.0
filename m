Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470032EE8AF
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbhAGW3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728405AbhAGW3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:29:23 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D59C0612FB
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:28:21 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id m5so7114856wrx.9
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ADeLjBIuNm8Db2lkSUMCJRDAVngCOHiUxA4Y6spWn0I=;
        b=DsPiUBFgZubvxf2GePgfLlQAvIsVAdsSz4Pr9D3xFLnGnAV6kscnE/yLi/H5oybGLJ
         lf6RlFYc8SoacNkGAukiY77zsn/ei6qXWVMzAh0raYVJ+BZGXSc3gX+fw1NAah1cI+zw
         8PgNNKqAdzIlWOklbEDv9+ZAVUtEE4XqP6XZUxNg7IYik2MvFnSkGbKXZH2iCmoneHUa
         wUTrY0iosyh0IdFd1OolVkHkDYyuWJHnSG47p28Wsmkh7VI+05X3pkbvPLTWqeme9Ypg
         IddKtUBE2yWH2SK57efV4dnc4mdZxos5u/NcrMP1Z8oJkPnAuAvXAt7NCZK8CIzc4U2w
         CjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ADeLjBIuNm8Db2lkSUMCJRDAVngCOHiUxA4Y6spWn0I=;
        b=YU0iSXVtvsMEX2RcvRCqunw50cK/sekFpXqZE7e4TPgkchivrP6dbL9WKobE+20h6v
         GohcjML0Rx14B+IBfyOwESSky8Z13mIXvFATXtIsW5jf9PD9pbYwnlp+fpAa1elbvht8
         IZtxcYtBnMFt+CH5BdblKQRBOiLrHAgb4VMZ/j7l/vjik9ymO/nY2dDPzjM1/GjVGil8
         73XOCFDYcUoNBQ+P+0NSkbaFJcz3qJYGleDv7o3W5bFcV8f2jcFYk2oqpgnrJDTp7l3F
         Y+Q+5wPtkgcqNnwjHXCxGEShQjCVALJrkJg/h8VCZDPSvoLHZnhJ3mdyle32KOQuh+aT
         LLng==
X-Gm-Message-State: AOAM531XHgpXiEEgZMVCt5Ee+LdwTe3ua5WBB/9NaViMb868cdcT4tlh
        SSIJNsAFAiQ1zmuBLPaMd54=
X-Google-Smtp-Source: ABdhPJwmwG+IOuURAtgZfJZeyY0mGhHbK6Zox4gOBAU8vjb6V2st3D0j0ccmQnWMvuf9SjqNPgJ4VQ==
X-Received: by 2002:a5d:684b:: with SMTP id o11mr667739wrw.157.1610058500527;
        Thu, 07 Jan 2021 14:28:20 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id m17sm11788101wrn.0.2021.01.07.14.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:28:19 -0800 (PST)
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
Subject: [PULL 63/66] target/mips: Convert Rel6 LDL/LDR/SDL/SDR opcodes to decodetree
Date:   Thu,  7 Jan 2021 23:22:50 +0100
Message-Id: <20210107222253.20382-64-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LDL/LDR/SDL/SDR opcodes have been removed from the Release 6.

Add a single decodetree entry for the opcodes, triggering
Reserved Instruction if ever used.

Remove unreachable check_insn_opc_removed() calls.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201208203704.243704-12-f4bug@amsat.org>
---
 target/mips/mips64r6.decode | 6 ++++++
 target/mips/translate.c     | 5 +----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/target/mips/mips64r6.decode b/target/mips/mips64r6.decode
index e812224341e..8c3fc5dae9c 100644
--- a/target/mips/mips64r6.decode
+++ b/target/mips/mips64r6.decode
@@ -10,8 +10,14 @@
 #       (Document Number: MD00087-2B-MIPS64BIS-AFP-6.06)
 #
 
+&REMOVED            !extern
 &lsa                rd rt rs sa !extern
 
 @lsa                ...... rs:5 rt:5 rd:5 ... sa:2 ......   &lsa
 
 DLSA                000000 ..... ..... ..... 000 .. 010101  @lsa
+
+REMOVED             011010 ----- ----- ----------------     # LDL
+REMOVED             011011 ----- ----- ----------------     # LDR
+REMOVED             101100 ----- ----- ----------------     # SDL
+REMOVED             101101 ----- ----- ----------------     # SDR
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 73efbd24585..f46d7c5f80b 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28871,11 +28871,10 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
         if (ctx->insn_flags & INSN_R5900) {
             check_insn_opc_user_only(ctx, INSN_R5900);
         }
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         /* fall through */
     case OPC_LDL:
     case OPC_LDR:
-        check_insn_opc_removed(ctx, ISA_MIPS_R6);
-        /* fall through */
     case OPC_LWU:
     case OPC_LD:
         check_insn(ctx, ISA_MIPS3);
@@ -28884,8 +28883,6 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
         break;
     case OPC_SDL:
     case OPC_SDR:
-        check_insn_opc_removed(ctx, ISA_MIPS_R6);
-        /* fall through */
     case OPC_SD:
         check_insn(ctx, ISA_MIPS3);
         check_mips_64(ctx);
-- 
2.26.2

