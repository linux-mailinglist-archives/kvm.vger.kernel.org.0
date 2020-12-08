Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599F42D1F11
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgLHAiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgLHAiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:38:06 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D01C06138C
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:16 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id p22so3722576edu.11
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cBcAqpVeWvYa5kT7ybzBYVgh68psdEjYqVlt8VyNVPI=;
        b=EF+mKy3oCXc7rxnqO3XKMyE5cT6yoc49bbljauyDu8Z4h4SwLe3V+8SOQCrOGhM34b
         OY1WUXROwPnpHjU5K+jvVZEEK3nuKQeMJgUnE/b+cMiD0JaKD68B0XSYqn1vCtaKv059
         FKEWGFrVf5rbcdQ0WMCtJt6dtSQXd4rRTdjpg/DqjKi8d1qlXLJ4z1oqIIQoV8fg8+Bg
         W0uaSc11640bqgGyejQegNrJ3M8Lg/twsTuSmtKA+VI/mgd0eDPA2UzTyhsJ1f/0nOiG
         NR6vJJKDBeHqXG1iDQXftECja90SlFss0TsGl3GkCc7FyPipxp/aiDgm0p5pPytrzTvY
         5jCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=cBcAqpVeWvYa5kT7ybzBYVgh68psdEjYqVlt8VyNVPI=;
        b=jaCnrJH8C8WQh8ymqWdKWgq4pRnbGicfbfm8/dii8GNJxBY8quxofuITYyZYLpls5M
         DyipMiC2Rai9wCB13O5WRO2dfu+J3zudMDryNFXtMnW/D7RhGxDwqliNCxeBSvLqZyH/
         K8adNSBHPOjbCxUHL+qN3Q/JeeI//aPzVOr8h4ZrtS9WdrkzkOlNHYoj986QgtAaLQU5
         FhWUqQ+lt/90Up18Y7wCo+un1VuFLGKhkrQuoXgjw2JZm+j9AqoW53ZoTvXZ+HAL9Stu
         f75bVE00pN50D/Y9qUSDS1nl6L+AGPQdOmMMAdIpf28tatS6VX+EoAcOCFH8vJ3o0MF+
         eM5A==
X-Gm-Message-State: AOAM533Yll0/5sCVbRhb1IV4tco/5UOuiKRl5PxS3Sm3wjkSzVQlf7BI
        eNury79q8eYel5xbUB6jtzc=
X-Google-Smtp-Source: ABdhPJwYUp7Xv29jcHxIdBN4YcvGvOJHHFZ1ZiLF9SaK7CNzI6qtsm7cRuqA13vmJvwaMSH62iP6GA==
X-Received: by 2002:aa7:c749:: with SMTP id c9mr18694617eds.3.1607387835615;
        Mon, 07 Dec 2020 16:37:15 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id c5sm15390194edm.35.2020.12.07.16.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:15 -0800 (PST)
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
Subject: [PATCH 02/17] target/mips: Simplify msa_reset()
Date:   Tue,  8 Dec 2020 01:36:47 +0100
Message-Id: <20201208003702.4088927-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call msa_reset() unconditionally, but only reset
the MSA registers if MSA is implemented.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c          | 5 +----
 target/mips/translate_init.c.inc | 4 ++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index cb822e52c4b..b20cf1b52d9 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31876,10 +31876,7 @@ void cpu_state_reset(CPUMIPSState *env)
         env->hflags |= MIPS_HFLAG_M16;
     }
 
-    /* MSA */
-    if (ase_msa_available(env)) {
-        msa_reset(env);
-    }
+    msa_reset(env);
 
     compute_hflags(env);
     restore_fp_status(env);
diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index cac3d241831..3c9ec7e940a 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -1024,6 +1024,10 @@ static void mvp_init(CPUMIPSState *env)
 
 static void msa_reset(CPUMIPSState *env)
 {
+    if (!ase_msa_available(env)) {
+        return;
+    }
+
 #ifdef CONFIG_USER_ONLY
     /* MSA access enabled */
     env->CP0_Config5 |= 1 << CP0C5_MSAEn;
-- 
2.26.2

