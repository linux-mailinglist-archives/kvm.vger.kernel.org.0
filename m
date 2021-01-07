Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F4D2EE88C
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbhAGW0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbhAGW0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:26:34 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF154C0612F8
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:18 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 190so6378610wmz.0
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lMAe3ErcpY6GT5lLpyLZ/gixtllrok8K5UMFavL1mtI=;
        b=PWPFGmWNroy2+z8o046XV+RRv5ussCHdG8BVtGR00vYOqM9oX9LgL8nM6wOfr7q+9Y
         nzfGMFsMNq7GXwYqFxprRvZ3rQttFpo1vdLm08aKLmNfHhcpdVwN5L/4UBReJ6TY63KQ
         WWzsliI/pIz/Bx05xQ4XrJdUJHPHHq0unkex/6xe2UnUtwXlMMIT9E/QZrxtxkot08oA
         iaTh7YelP6zcHWaTMh2VFmgUOCeqhAIIAE80zpOr4LYQBj4KEBvhTp6Ei9Idq0zX6iDE
         +ZK2ZCgJ90WtNKH4N0IbrZCKk1Vpmbml60Vu0AR/u39KP11q2FrwE9jZvBbZ/2BNJqg0
         F2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=lMAe3ErcpY6GT5lLpyLZ/gixtllrok8K5UMFavL1mtI=;
        b=hiQLKoEHBgWB1Jllot4VAf5Ozz4nbn61v0masduZG9hwz+0VQuxqxIRteOcHvkcGkO
         4xSvwxVCzRZP3YdM4ifxYFCD5oNyW4bweBwZPqzDRMW34GgOBJoD56xOCTyyjFHulsVO
         /fYgfRzMCI/s8VuEwN9AlruIf9rcSimg1yDbTsLlRJur2wB9ap1OhJKPCHr0CapJegUc
         aoCW0DS2x20xJAlU8cIqEK3ZIaXbx4zkCGhlqQ145KXQ0yC3IgbSKGQWUOGRVZk+QGzj
         vWL9Dy4p1O9LIASbXPo3ICMnwUHr4diKTGgagQg1h+fk00AdtbjKqzrKlsR1DshUfND2
         0BBA==
X-Gm-Message-State: AOAM530AuSgYqOBpm+AmIXNn/6M4cvl9qnAaNusWHUOrg1SiehmdvD3s
        YXnJu2yhXWIqWV3NyFHA1HY=
X-Google-Smtp-Source: ABdhPJyGDwF7m1uVQYBA4ggoEa6lGAw05oUCdgZak1buPwMk2BLm6IfyffQb+MhOHXU/UoyBigfjwQ==
X-Received: by 2002:a05:600c:d8:: with SMTP id u24mr499760wmm.103.1610058377747;
        Thu, 07 Jan 2021 14:26:17 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id i7sm10218260wrv.12.2021.01.07.14.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:17 -0800 (PST)
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
Subject: [PULL 39/66] target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA
Date:   Thu,  7 Jan 2021 23:22:26 +0100
Message-Id: <20210107222253.20382-40-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-Id: <20201208003702.4088927-4-f4bug@amsat.org>
---
 target/mips/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 9a7698019e2..1048781bcf4 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -378,7 +378,7 @@ static inline void compute_hflags(CPUMIPSState *env)
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

