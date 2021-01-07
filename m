Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22382EE8B0
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbhAGW3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbhAGW3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:29:23 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82F4C0612FC
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:28:26 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id e25so6859531wme.0
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fdYSuYQvqNKVpq92aM/7Wd5ow52H+eR0/gXxomb4sjQ=;
        b=p1pIzZixnJJdVf3tNQtie+BS/J9X6mCCyj5oom4aY6rxUcdFR87nVvnNZxj3/d6AO5
         +sNJy7DbIn38NuGPBAawa3G83YzTRF8eR4XWGg3sdoEkaGhKStegzMKZf27WgeVyAA/w
         X+Esuf7b+chUIP8OTLp6wNCNuQhZIFgggjlH5mSgYwQpAG8r8DGTnoiulIDD2EsNYkcy
         WMD2VK/d4+AfT417dztTwV9dZIFxX1guExgmLZrKXKQBbzAhmuVA1UPH35tM1rPdyno1
         +zSDdxO8II4oA8Jswe7FjtDcjPzY1uNyYVTnYsSEFF7Zqecnu1rPlgF1lQFwjb6VaapS
         zNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=fdYSuYQvqNKVpq92aM/7Wd5ow52H+eR0/gXxomb4sjQ=;
        b=XPHrbS4rRoASc8z9WIZB/+z3lL+M3Slzntyp/eVgEfHpp15QrW0aA+4fbCONfHuMeg
         vi2O48riu/LUccDU5GsXDW+HRbIesTRjPTI+sNbTsPawD3ZS4HmmcxPsk+kzKHtgNRJi
         BbQNqYnaj4WIeHMUvTlzCXJN/CXYsAN+vI1MkLtZf9d1/jyZc8VT2JiDkzgdfXM+tnTQ
         cbGunnbg8wVJIz08/Fey0S7qCRNzgW9pGVFAhEFJJ6cn8ly1PUlSgUL6SCGF+2X1nUL6
         6GudaPqXU/0emGQ4zmbK5uAqoSz+EzqGHw0fqztnZliCUYaQB0cSm6FjBK+Y9kC0cwJ9
         H+kQ==
X-Gm-Message-State: AOAM530s6NkqOlh7S/StVQdS8puLJY5b7TdoEpW/NlX4Si/ds1tEHF8X
        DbNR/iIbWfp6zAw7X5UiGrc=
X-Google-Smtp-Source: ABdhPJws5xak3FcT1HkGs0Ly6rut//3AP/lYHP4MA74T0CtSIKncybZuO1pBYPc0CUfac9oScLTv7A==
X-Received: by 2002:a1c:e90b:: with SMTP id q11mr537869wmc.102.1610058505516;
        Thu, 07 Jan 2021 14:28:25 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id v20sm11076739wra.19.2021.01.07.14.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:28:24 -0800 (PST)
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
Subject: [PULL 64/66] target/mips: Convert Rel6 LLD/SCD opcodes to decodetree
Date:   Thu,  7 Jan 2021 23:22:51 +0100
Message-Id: <20210107222253.20382-65-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LLD/SCD opcodes have been removed from the Release 6.

Add a single decodetree entry for the opcodes, triggering
Reserved Instruction if ever used.

Remove unreachable check_insn_opc_removed() calls.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201208203704.243704-13-f4bug@amsat.org>
---
 target/mips/mips64r6.decode | 3 +++
 target/mips/translate.c     | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/mips/mips64r6.decode b/target/mips/mips64r6.decode
index 8c3fc5dae9c..609b8958d25 100644
--- a/target/mips/mips64r6.decode
+++ b/target/mips/mips64r6.decode
@@ -21,3 +21,6 @@ REMOVED             011010 ----- ----- ----------------     # LDL
 REMOVED             011011 ----- ----- ----------------     # LDR
 REMOVED             101100 ----- ----- ----------------     # SDL
 REMOVED             101101 ----- ----- ----------------     # SDR
+
+REMOVED             110100 ----- ----- ----------------     # LLD
+REMOVED             111100 ----- ----- ----------------     # SCD
diff --git a/target/mips/translate.c b/target/mips/translate.c
index f46d7c5f80b..9f717aab287 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28871,7 +28871,6 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
         if (ctx->insn_flags & INSN_R5900) {
             check_insn_opc_user_only(ctx, INSN_R5900);
         }
-        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         /* fall through */
     case OPC_LDL:
     case OPC_LDR:
@@ -28889,7 +28888,6 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
         gen_st(ctx, op, rt, rs, imm);
         break;
     case OPC_SCD:
-        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         check_insn(ctx, ISA_MIPS3);
         if (ctx->insn_flags & INSN_R5900) {
             check_insn_opc_user_only(ctx, INSN_R5900);
-- 
2.26.2

