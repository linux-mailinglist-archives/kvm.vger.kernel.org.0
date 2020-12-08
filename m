Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C3E2D1F12
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgLHAiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgLHAiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:38:06 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD7BC061285
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:22 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id dk8so12890472edb.1
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MK8p5/JI65dnw9C1ehTkiB134CDjpILH//LVRSp/y+4=;
        b=JQl/Lo9e1zD8sKqZt3xpzQFcocffgbQx0fKnBHhbv6FBOLuLCO9k7lVYKsJTNdKQqF
         9htsecuIE89uLySufcQcCJeDYqtqhaCzIL0Vz42GOnr/yHxj9k2ZOEbmGVDlqPepyfYR
         +oGVjn36ZaHyNmoaKv9jOU28pGlVakxJWXO6rUVJyKMP9PB1nXyCN5TLBWPKnnowyRf7
         WoU16EIQcG7jdG+GK09141mtaSlZOy+4Qufd4urUEhybldeYJPIRSE8jlQb3siR3zYPf
         WRoE2i5jXtmOdKxxBmvslG3lxAdal662tRyBzq08D98AhN+0U+i8dLD6VcH1HzLMJLHb
         3uHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=MK8p5/JI65dnw9C1ehTkiB134CDjpILH//LVRSp/y+4=;
        b=N7Z3iQ30Oe9W001tqDbItFemdE7j+tknIZaczNEw6jnxbZ+xlMVxRE8NBGWatUUcgw
         9j/77QOH4iYMiq8AtHBF9I4jsrnyy4tzWurpWAAcYj1sLG2uZoIKzCqMluGhNrz3yJP6
         yOhwbuJ21nJDtyVdIhShgYjUVVbaQDcbopOlbF+fi+cxqeW5zOtK91QTFn4a0wcJEIlp
         VggV8VfSob5NyTNxyjkfQsrhfxnNwcnJoNTc0eC5ExkEXfsZAiwcnXmJJQB9wcfJj59q
         qezcKZOZY+K1Tdxx3oG+Tbs5kD1BGTpgLL2t7hlJNAIlrBuHEuwr8r9A86GQUVRsiLzi
         9NFQ==
X-Gm-Message-State: AOAM533286yc5zDaxKJOolHJYLOdAZOliwUj3v2VvhMnpgOzVJgQ0PpJ
        U+/jrv3tbOCp2MaKfg/irSc=
X-Google-Smtp-Source: ABdhPJy0ccuK5jL3JysApdaWIyvf2n1/KBpbrQZrvbU7b+igqqSrf0FVUEuZq3kXmcBjiOns4mB5ww==
X-Received: by 2002:a05:6402:697:: with SMTP id f23mr4216622edy.318.1607387840868;
        Mon, 07 Dec 2020 16:37:20 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id v18sm15235520edx.30.2020.12.07.16.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:20 -0800 (PST)
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
Subject: [PATCH 03/17] target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA
Date:   Tue,  8 Dec 2020 01:36:48 +0100
Message-Id: <20201208003702.4088927-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSA presence is expressed by the MSAP bit of CP0_Config3.
We don't need to check anything else.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 6b9d1d4b93b..3bd41239b1d 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -379,7 +379,7 @@ static inline void compute_hflags(CPUMIPSState *env)
             env->hflags |= MIPS_HFLAG_COP1X;
         }
     }
-    if (env->insn_flags & ASE_MSA) {
+    if (ase_msa_available(env)) {
         if (env->CP0_Config5 & (1 << CP0C5_MSAEn)) {
             env->hflags |= MIPS_HFLAG_MSA;
         }
-- 
2.26.2

