Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DFB2D1F1F
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgLHAjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgLHAjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:39:00 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13105C061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:38:20 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id g20so22223534ejb.1
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VlrFjWtMkM6uUa/WdAt5ZGBwVseuDv9UZLscN2Lc6YE=;
        b=BTbC8sfgwcLErcE9Hgftpej+TdCf0CU7Xd+fKx9k+aNXF/+eqfoMap7579RGKkP+6P
         Vi3Ejna5DpRoseSrKcFya/SmRPRfHKMUuG5U01E+MYE8usNGlpOLXv8sQ/bhgsEnaB1I
         MW+j7dnMN8/03LrWNA1vUK0PIMc4qgBi9W3coF1Hw1kzDd3/eD/KzhyUOGeXnvCMMGSa
         OvIZWgd74s9I3/ckLr3Yzxh15nG6ES77Jqj+iJ/60piaGA3Hps8MoMTJqoCGjV43qju/
         8dHbcHyah3i5XdY6NTUbqRIqdOzMNt+dUs1HNowb1TV8/God8Fe3npTyqBbmh6ZkJwkN
         66kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=VlrFjWtMkM6uUa/WdAt5ZGBwVseuDv9UZLscN2Lc6YE=;
        b=Ot5dkj6Ztzuck4gxpQOxtMletA/08A/grdJ5QOzcwE2zcWbD06cWLqo3rRSK6vFAgw
         UIRD+QuzjnfWlRCSwlRwkGdkK9TDGJLAtatodmWwAIlNjyL0oUZ8ABLSOEeLDTV1hy9T
         GUBYuH+rpkMFq3niPzngMTWOzjoDq3ngG4b2YQYg0AawEsv7l8bulOBiFYCjJPzZNmHk
         lFnLcJQb34z5zk5TgoDE+cRe0zxRWtjuHUJD6k3E5KfnXk69aapOJOsc47siLSGQwsgw
         VSWXyyvQsks1nrnAFZY59EsWNwBt89A/pwrdLH83JbSkzdMVf3tJolQYwIJmifr19aFF
         KUBw==
X-Gm-Message-State: AOAM531QvEKAqL39/XuiJR5n6DUc/i8tW3zH+fjm964b9WumORl+ei9t
        /KPZ512u4w80RNGMjN/Azcc=
X-Google-Smtp-Source: ABdhPJwCIJGZcoYl8+1xDZoULgzVXnjluO077d61/nE3jbLEV0gRpRVHtJ8udlI5N1u2qZkBLWuhrw==
X-Received: by 2002:a17:906:c244:: with SMTP id bl4mr20250819ejb.430.1607387898842;
        Mon, 07 Dec 2020 16:38:18 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id q4sm11590147ejc.78.2020.12.07.16.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:38:18 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 14/17] target/mips: Declare gen_msa/_branch() in 'translate.h'
Date:   Tue,  8 Dec 2020 01:36:59 +0100
Message-Id: <20201208003702.4088927-15-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make gen_msa() and gen_msa_branch() public declarations
so we can keep calling them once extracted from the big
translate.c in the next commit.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.h | 2 ++
 target/mips/translate.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index 765018beeea..c26b0d9155d 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -82,5 +82,7 @@ extern TCGv bcond;
 
 /* MSA */
 void msa_translate_init(void);
+void gen_msa(DisasContext *ctx);
+void gen_msa_branch(DisasContext *ctx, uint32_t op1);
 
 #endif
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 8b1019506fe..d8553c626f3 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28668,7 +28668,7 @@ static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
     return true;
 }
 
-static void gen_msa_branch(DisasContext *ctx, uint32_t op1)
+void gen_msa_branch(DisasContext *ctx, uint32_t op1)
 {
     uint8_t df = (ctx->opcode >> 21) & 0x3;
     uint8_t wt = (ctx->opcode >> 16) & 0x1f;
@@ -30444,7 +30444,7 @@ static void gen_msa_vec(DisasContext *ctx)
     }
 }
 
-static void gen_msa(DisasContext *ctx)
+void gen_msa(DisasContext *ctx)
 {
     uint32_t opcode = ctx->opcode;
 
-- 
2.26.2

