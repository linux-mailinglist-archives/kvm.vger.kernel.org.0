Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9442DB6FE
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbgLOXG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730483AbgLOW7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:52 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C2DC0611CC
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:37 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id w1so25385407ejf.11
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e0eQHnWDCrjwoYyD2yN62FwRsv+ZXJP/kwuNsrV3YJo=;
        b=F7NZPZDcUD7tQQF+lbqopiHIMiK0uojWbK5lxme/6/QwRVdisEFjXjK30abUTagZXW
         MAaXJ+db8S92MqrPy5QO3u0hGHbUFtwKXJ6BHpi1jNULSWpvzQ0IhCLIpD/iI5WxRxGM
         c+MlCtM3XmsTpdqXphE/Tj4bPAk90PXAZbGCnhtNHTMxiJ+k05G0I/kW49VCBccTMOLp
         8/H0CXssXcWyuchAPMNZN0cdOujx5+0Kimv/iJ7Y8l78p60InnmSokUwR2aFXnOymFu9
         Twpb+jiUkSxKSbi22WC5cz0yTqIF5KWGan9n9eFhwx6EM9mQPm4coPvCiskhjLIGrYOR
         gnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=e0eQHnWDCrjwoYyD2yN62FwRsv+ZXJP/kwuNsrV3YJo=;
        b=HkYVf8k1GdyGkZWqZux8kj3qZXmp92ohbq8lg7miMlbS6lelpzHZheQSHL1lVdPkev
         HXVU1/M3ougk2aZRQul+vHAtrgQg1SkmUqYXgmjVYTfbBepTwwjA/Jcg9eo1vjsPcGcm
         ikf6RTo6gF8mAF853FRsYy3oBEh66FmL65UuoEF+s/Wv0+K9ZjXSXULFG9C1kQBcB65b
         6OQtdpUS7z/+ZAw8zJiLFvl/Lvy1u/SOhiREE5KcQ2LMMmaN0SZXvX0GfBzBofrBSjXx
         kAuFj6n3nBBRXqP1XdAf2YxCZydtMK+ERTbbJckfKB02coP3r8l/6J+VED6MIhDaSYwP
         cYxg==
X-Gm-Message-State: AOAM532rXjQ4znfoZgaR8RwuecKM6ikIZ6cxUPxa0Mi1jjVddxGJYZYd
        ttV8+dpsUYfYNeNaLCKxGps=
X-Google-Smtp-Source: ABdhPJwPcNZNoZhcI0FGmQqk+wdxQUMkkCOBpxFi85HJfy6say6TGZ/z07taAzNCIIXoMUj0zpr8VA==
X-Received: by 2002:a17:906:aeda:: with SMTP id me26mr3583681ejb.11.1608073175960;
        Tue, 15 Dec 2020 14:59:35 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id s12sm19874597edu.28.2020.12.15.14.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:59:35 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v2 17/24] target/mips: Declare gen_msa/_branch() in 'translate.h'
Date:   Tue, 15 Dec 2020 23:57:50 +0100
Message-Id: <20201215225757.764263-18-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
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
index f7e7037bab8..77dfec98792 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -163,5 +163,7 @@ extern TCGv bcond;
 
 /* MSA */
 void msa_translate_init(void);
+void gen_msa(DisasContext *ctx);
+void gen_msa_branch(DisasContext *ctx, uint32_t op1);
 
 #endif
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 9be946256b3..20174c4aa57 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28660,7 +28660,7 @@ static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
     return true;
 }
 
-static void gen_msa_branch(DisasContext *ctx, uint32_t op1)
+void gen_msa_branch(DisasContext *ctx, uint32_t op1)
 {
     uint8_t df = (ctx->opcode >> 21) & 0x3;
     uint8_t wt = (ctx->opcode >> 16) & 0x1f;
@@ -30436,7 +30436,7 @@ static void gen_msa_vec(DisasContext *ctx)
     }
 }
 
-static void gen_msa(DisasContext *ctx)
+void gen_msa(DisasContext *ctx)
 {
     uint32_t opcode = ctx->opcode;
 
-- 
2.26.2

