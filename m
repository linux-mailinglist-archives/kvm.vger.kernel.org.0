Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AFE2EE899
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbhAGW10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbhAGW1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:25 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18850C0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:27:10 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id c124so6334307wma.5
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lwE+1tMMYcVefJ6sciUgu2/141uGXgmmBukddjUxPuE=;
        b=FtydMcjdMGQKD9mG0EnX1OWM2EX73q9GzjKg3RG0R955kQxCTbIk2jnYwfq3tkg1KY
         iQeU/c9FlM8f2hweexU4h7MP6f0Z5l1m2jvYzzjGnn0AC+ALR6Iil2m3kFjbrJ8mjRPW
         elIveV+tX7+NYvVSd7v4nPoviMAGE/u6VkPLwpj4iW4EBZ1m77N1FLAd+2xYwqXeZ0zP
         2gt3+jwjBxqUklzYYeaxaKpufeh1vlVKJurg0IcrfkLmBf1UgghMQ2d8tCYLvKYkkYbi
         c2hMVmE505gcVsakevWMK6VQme7rLc+yJGXHU2omR6yJDtwUTN/v1is69qPHK+be8nH3
         ouug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=lwE+1tMMYcVefJ6sciUgu2/141uGXgmmBukddjUxPuE=;
        b=QiuCayE+Zcr2Dhydus/wWBp+UJjvuD78CsaYJCSUeQ3pOslPps22ZhPUNN/Wf6PNEN
         f2EPo0U/42j3F8aPyXxmHl6RaK7KzsEwSsd6tFDxUU6qJhaIiiiDPIiMwgnCl/vw1VFZ
         hJywFShdQnxNnmPLlRknTXzil4+wrh8giVINVfvmVbbCzjH4hXlGDRbSh6vgTviVqz7K
         JqKc+FAt0oDsjYfnwAJ0FSyMYPOz/zoe4rZpjduRQIp/RfFGwJsXcQAcZPqO4u5cTP5C
         /+uNJgIwVxBpSjI7G9b43SkkKVmIEcVn2qx8XAKk+IBz+qhYcn379SwHdw+MWrS6zOUL
         E52Q==
X-Gm-Message-State: AOAM5308IJkkEqmzhY6tET2l1Jziai4e447kSmnRB0ECXK7MrttoZ7x+
        ncirgABfkLH/H8BSqFmbdghQnF7dkqk=
X-Google-Smtp-Source: ABdhPJyuhUKSjnxmzTAuIU1deebNQKXXaS14b97GAjx9A7kMfekrdrz6IK3CUxsMt03XGVdSqoRC8g==
X-Received: by 2002:a05:600c:cc:: with SMTP id u12mr547735wmm.42.1610058428920;
        Thu, 07 Jan 2021 14:27:08 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id j7sm9627579wmb.40.2021.01.07.14.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:27:08 -0800 (PST)
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
Subject: [PULL 49/66] target/mips: Declare gen_msa/_branch() in 'translate.h'
Date:   Thu,  7 Jan 2021 23:22:36 +0100
Message-Id: <20210107222253.20382-50-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201215225757.764263-18-f4bug@amsat.org>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 target/mips/translate.h | 2 ++
 target/mips/translate.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index b9cd315c7f4..c61c11978c2 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -164,5 +164,7 @@ extern TCGv bcond;
 
 /* MSA */
 void msa_translate_init(void);
+void gen_msa(DisasContext *ctx);
+void gen_msa_branch(DisasContext *ctx, uint32_t op1);
 
 #endif
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 0e7b2abe8bb..e1763e5bcec 100644
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

