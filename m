Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1772CC5C1
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389675AbgLBSpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387949AbgLBSpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 13:45:16 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A43C0617A7
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 10:44:30 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id g20so5997097ejb.1
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 10:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cd+cZl3lcOYz3Gxtj1/bjHSaDTLTKsW2lXk6GJRA4IU=;
        b=S2pR8EmGeeVTU63mgKk5Ud1W84JypeTfvaScnRER/pLP+zhKc7dFIbwqQywoU8Sk6l
         6hs/J8GZ4N4fmmVTk/zb4WGXKxjjY/ZZ9WW8CW0Qs7ylTTn25wfjNkppjruxwne46iAJ
         4EZYq6ljyoPw/QqwcQvsFDrcq4iEZ31gy4PcFZclYqxksynZOnjaleoZlOb3YY69+EQK
         2UwSy9tUeBNUaEyiF2s8my6cYm7deOfQb98F13nZEhSuRLY7ub88SoazSM+CpQmJYIyV
         ugiN1YMf3DE5AKJPngoLMuSsNhd9353DkzFOjasJ+E9+Xzd1pfWzHr1HW4rotZlGcKUI
         qtIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Cd+cZl3lcOYz3Gxtj1/bjHSaDTLTKsW2lXk6GJRA4IU=;
        b=r1mPu6/zJQ9XED5heLKeVmAj0e/ROxkefp4LFkVulOxv5dNr1zYwSZFb6Bpv0VlZhv
         sTtjGimr9jz1DidfTP0OyvVGJge8LUD4wEqU81mE51HLZxgewPLbcVIcvJax9EapgNR+
         FtLm5bhWrWPTzeiheVZEVwMr8AgzeO09sKjW96hFkaYAmiDPUpFQMoozqPvNGppEJtq0
         HKBcnSxEjeBG742HMLJCwQRE4eVsH+XINlozIHX27Rp7YTrftI1zY5Lxs4+AEPzflHg/
         2H+4DDGxSI64kqrezTdw8PUrY0Z89pOA/3DO+J+ijCDidP8iUQLLa1CIKBixVRO1TV7M
         dgQw==
X-Gm-Message-State: AOAM533ZAzARw1LRJmqYTQr2qameW8dcZDWc+iT/WTaIkwHKnCG6u0Y/
        nF2dv9+trBWXurqi7q0XhWM=
X-Google-Smtp-Source: ABdhPJwV+gLJt4YMjpfq4QmFKSJ/vB4g2/7zLmukJCqDsckb+0ljrPmo2gKywnORW4y3V4vD2C5YXQ==
X-Received: by 2002:a17:906:3704:: with SMTP id d4mr1151640ejc.338.1606934668730;
        Wed, 02 Dec 2020 10:44:28 -0800 (PST)
Received: from x1w.redhat.com (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id p91sm550214edp.9.2020.12.02.10.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:44:27 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 2/9] target/mips: Simplify msa_reset()
Date:   Wed,  2 Dec 2020 19:44:08 +0100
Message-Id: <20201202184415.1434484-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201202184415.1434484-1-f4bug@amsat.org>
References: <20201202184415.1434484-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call msa_reset() inconditionally, but only reset
the MSA registers if MSA is implemented.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
Maybe not very useful.
---
 target/mips/translate.c          | 5 +----
 target/mips/translate_init.c.inc | 4 ++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index a7c01c2ea5b..803ffefba2c 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31997,10 +31997,7 @@ void cpu_state_reset(CPUMIPSState *env)
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
index 79f75ed863c..3b069190ed8 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -1018,6 +1018,10 @@ static void mvp_init (CPUMIPSState *env, const mips_def_t *def)
 
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

