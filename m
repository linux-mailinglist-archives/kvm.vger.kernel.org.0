Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAC72CC5C4
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387938AbgLBSpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387681AbgLBSpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 13:45:38 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9790C0613CF
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 10:44:51 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id k4so5153522edl.0
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 10:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O0Gmy5kVHrWtz2x/frWgI7xbHwcEYiFbHswDBnArJKk=;
        b=Cy9L94FFo4sSHWJnhtRu1Ih4nCtDWyS9sjq2wZBOV77ZLvh8BUlgDknPH9FR1PoIzt
         Dw/0hHJ6B8ugGuyL2qEKrB6fF0GkTonB76CuDVUCU0vB4vRRjLiGquMiky7KCDI7iNEz
         n7laZwqSDybgcWtezsBFArsIEiTm+MSRfw+BTblAKpR9IUR9iuopeoqdkjlOkqU7NlHJ
         Mzc7B1uzoCREAVxXMpWU8gtXQA22fbdepHUyBbMB3jCp17yDkAyUC8K1sbNiaOkcioZU
         yb7HtSCUwL+s4z3yrJgdENlNCi+0Yctgf5pLZ3rawYbNHDPVlYlMzLsvP135t+7JS9Xs
         mUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=O0Gmy5kVHrWtz2x/frWgI7xbHwcEYiFbHswDBnArJKk=;
        b=twk641t5VKX1TPuRmjt6aUsrQey61bxu+Nk1tXcY0VS+yvi1wIhRNiZWmsJYE7tNEF
         A5l6f3NXD/aaa+igyvr9OGHJ1W6h86NR2f7P19NoSFMpOUMSzgRxeFD7/8tw3au7Rp+J
         8KbmKgAL9i1jAMseNGE7EY4437hxEK4n6RZUOAEa1YAbQyZ/YFNFGKobAl6a5Fz6l2Ne
         qDHw+At6yBcJl4RL5tiVyNT5/SXuzpm9mpw2eRFTQdabeSscsWA7KFwggfNc5PR+Rlya
         S64/8l2la03juUc0+HuGyRB2Ns1E8v6qJfC87l4niqEK1ESMQQiIutVbgojCvgCPUNL3
         IPtg==
X-Gm-Message-State: AOAM530Un0gPfTV0jET1eAVCq5xoOe8pJbNedf6mjrN4Pj6HUJDvUqCx
        j2GkZ/3OlOmFmYv54vbJQuQ=
X-Google-Smtp-Source: ABdhPJzH0s/mvRJGBWMPJEUdTKPTxukUS8ZrESWtCMCmpvq+4sQLddwuyMLZaTIeUkLh/3YtQrq5zw==
X-Received: by 2002:a50:ff0c:: with SMTP id a12mr1312530edu.79.1606934690471;
        Wed, 02 Dec 2020 10:44:50 -0800 (PST)
Received: from x1w.redhat.com (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id e12sm570657edm.48.2020.12.02.10.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:44:49 -0800 (PST)
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
Subject: [PATCH 6/9] target/mips: Alias MSA vector registers on FPU scalar registers
Date:   Wed,  2 Dec 2020 19:44:12 +0100
Message-Id: <20201202184415.1434484-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201202184415.1434484-1-f4bug@amsat.org>
References: <20201202184415.1434484-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commits 863f264d10f ("add msa_reset(), global msa register") and
cb269f273fd ("fix multiple TCG registers covering same data")
removed the FPU scalar registers and replaced them by aliases to
the MSA vector registers.
While this might be the case for CPU implementing MSA, this makes
QEMU code incoherent for CPU not implementing it. It is simpler
to inverse the logic and alias the MSA vector registers on the
FPU scalar ones.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index a05c25e50b8..41880f21abd 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31682,16 +31682,20 @@ void mips_tcg_init(void)
                                         offsetof(CPUMIPSState,
                                                  active_tc.gpr[i]),
                                         regnames[i]);
-
     for (i = 0; i < 32; i++) {
         int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
-        msa_wr_d[i * 2] =
-                tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2]);
+
+        fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2]);
+    }
+    /* MSA */
+    for (i = 0; i < 32; i++) {
+        int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
+
         /*
-         * The scalar floating-point unit (FPU) registers are mapped on
-         * the MSA vector registers.
+         * The MSA vector registers are mapped on the
+         * scalar floating-point unit (FPU) registers.
          */
-        fpu_f64[i] = msa_wr_d[i * 2];
+        msa_wr_d[i * 2] = fpu_f64[i];
         off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[1]);
         msa_wr_d[i * 2 + 1] =
                 tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2 + 1]);
-- 
2.26.2

