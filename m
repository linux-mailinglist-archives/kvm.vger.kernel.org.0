Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12552EE89B
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbhAGW1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbhAGW1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:36 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6646C0612F8
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:27:20 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id r4so6807534wmh.5
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rBzgLDqqE9tlixFb1w2Ems4Ej+21PfOS0dtp5Xnk1qE=;
        b=XbMQJGvj/ERQdAoqFOepJIDBJBm4DPyk7iHUwRpA3fFh+5xFh/FO+wULHMhIpPtpVU
         H1Ylr0RRBgLph1HF5h/zyUPw5cfKvJqceiULQvPmTTiey43fJhlF+sNyMcEUZ46prG92
         QN+7j0zYlZTGJQO7doASweklnwwodL8ol0ZvtJNl6NxddseLXLPtrisuM/epcYJPLxrZ
         oewa1iIHa+nYlvFTn8ciNS2ZrXFMHkVnyidP2Zk+sYiFtpbJhrX5PfRQ9wHPF0xwV7Uv
         T2Rkjd7GhvS6ELbcbPEI/+4VwMqO5BPVJMyCbz6WWXRLJ40zDb1ERjkeg9hYrlL1hGeC
         TTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=rBzgLDqqE9tlixFb1w2Ems4Ej+21PfOS0dtp5Xnk1qE=;
        b=ZmmDH3Z6JZushXH0oUZCRAP4myLu21mUNDKF/vtYXvGFlKTSmNJSYYP431CGBzX2fL
         h4A/l4F1ca8p8peE2DUjeLzZDcDVcE3kdUeVRUHoALCyhPMUSlJSHu6uQococL0mJ/yK
         C0LlhMImSrD065Qp9ybMFF/br4FlSS8x1qS8+KydFuej0m4k+4yBimSL7f8YuifxqdMB
         5dqM270kVSQmGd+tsZ+cG22qkLt+HAfqaSJzHiFszV0JH0eEEcXmQP5nQfRU8ku+gAYg
         M1INhjnWhrzZfdEpU11h3x6KuNX1f1YkzBVdzI/fTIKIvwwFX+FFBpjQKzLuD0eZE/yr
         Ulkg==
X-Gm-Message-State: AOAM533SYq+ZZqQjTvHS3IOmEsu7v/Pf77mCDrUcCod35TMhCBqwtvg4
        6jHsNDE6TpaNJ2WTCvTmwWs=
X-Google-Smtp-Source: ABdhPJz3cwRLw1uViG9szTaeR7d2mfQE7xcFc/rcQiEksAumr9lADebyUs4v2fikkm9QTzErOR897w==
X-Received: by 2002:a1c:4645:: with SMTP id t66mr510210wma.152.1610058439578;
        Thu, 07 Jan 2021 14:27:19 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id f77sm9367016wmf.42.2021.01.07.14.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:27:18 -0800 (PST)
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
Subject: [PULL 51/66] target/mips: Pass TCGCond argument to MSA gen_check_zero_element()
Date:   Thu,  7 Jan 2021 23:22:38 +0100
Message-Id: <20210107222253.20382-52-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify gen_check_zero_element() by passing the TCGCond
argument along.

Suggested-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201215225757.764263-25-f4bug@amsat.org>
---
 target/mips/msa_translate.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/target/mips/msa_translate.c b/target/mips/msa_translate.c
index a4f9a6c1285..52bd428759a 100644
--- a/target/mips/msa_translate.c
+++ b/target/mips/msa_translate.c
@@ -304,7 +304,8 @@ static inline int check_msa_access(DisasContext *ctx)
     return 1;
 }
 
-static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt)
+static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt,
+                                   TCGCond cond)
 {
     /* generates tcg ops to check if any element is 0 */
     /* Note this function only works with MSA_WRLEN = 128 */
@@ -339,7 +340,7 @@ static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt)
     tcg_gen_or_i64(t0, t0, t1);
     /* if all bits are zero then all elements are not zero */
     /* if some bit is non-zero then some element is zero */
-    tcg_gen_setcondi_i64(TCG_COND_NE, t0, t0, 0);
+    tcg_gen_setcondi_i64(cond, t0, t0, 0);
     tcg_gen_trunc_i64_tl(tresult, t0);
     tcg_temp_free_i64(t0);
     tcg_temp_free_i64(t1);
@@ -378,10 +379,7 @@ static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
         return true;
     }
 
-    gen_check_zero_element(bcond, df, wt);
-    if (if_not) {
-        tcg_gen_setcondi_tl(TCG_COND_EQ, bcond, bcond, 0);
-    }
+    gen_check_zero_element(bcond, df, wt, if_not ? TCG_COND_EQ : TCG_COND_NE);
 
     ctx->btarget = ctx->base.pc_next + (s16 << 2) + 4;
     ctx->hflags |= MIPS_HFLAG_BC;
-- 
2.26.2

