Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1F72D1EA4
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgLGX4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgLGX4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:56:39 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F471C0617B0
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:55:58 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id g20so22108517ejb.1
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yk+4p5NVLbhbYdTmBYgtuSNG/soGvYd4+FvnWCldyIo=;
        b=Gg/Y8+1rtb3xwKY9CB5z0cBk5KutL9CyL00CS0c8blZC0aVFyaP+WgKtxqS3pGaB3H
         X1kTkQfQuKz2LtdQW9xD1pcmwAc76nK3twBAgg0X35NNq9kV9sdzLnpypLSa82DYTRIJ
         DFbBWXCdHkhXXTCPfTRn9V4RAXCbIM8Z3hrudAUHM/cGkGs5tv2zaADMEl1S+didzkrJ
         iDnzWEqAPU9/RlUBBdupPdjUmgTHbuGrCEN3On1sk7wrMVTtlCQxSdRSOggIRu1MX7+0
         wVxU4+8an/Rqh8DkSPQVQuawjZ++eyJxN/vyO0slz4Yxl6vNZ10lxJmoQ3Z082jF/JUC
         tnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Yk+4p5NVLbhbYdTmBYgtuSNG/soGvYd4+FvnWCldyIo=;
        b=qMZfTI5U3Ljx1Hhs8RLcQbswzZjEHooKGBQY5qm0pIQ8KTeCS5N0s88BeqC4N9rxWH
         cb8iWDND2SOQGkUVgfnWNrDaA8T3yd54FKI7nLQkYjG8hAedS1Y7FDNmzDnuXH4iWBXu
         W2WTtXZyohMR93F1SNLTihYKvD1OQ/PiOcBSXMyUsChzLq5GZD8CcoWkwwpjmRf0YXcv
         ad4mpIaDP12nZlJpcVdYYJldGASQtNgCChNvX1rEVXp/K1zaQVpA7bj0f+vufnvMEvTj
         JF7fQwli79Zp2o4uknB8G0zB73Mts4T7vQN1ixA4GsfN5ysh2Nu2Ms6odp8fL3TWQ9rK
         GzRA==
X-Gm-Message-State: AOAM532HesPdCLgEj42wqwycmThRm7v4N91VV3x1fHUe+sNnPr6sBlbN
        FL3HtPKemNiDbhxmcAtLORTjO3fRzjE=
X-Google-Smtp-Source: ABdhPJzGo39RgOyatmYdrC5PJJBlDjUjAhkacEaMqiF2vblIZIij08por5k4fKlPDv3V9jwDqmJnCQ==
X-Received: by 2002:a17:906:81ca:: with SMTP id e10mr20829350ejx.449.1607385357466;
        Mon, 07 Dec 2020 15:55:57 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id k2sm14013964ejp.6.2020.12.07.15.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 15:55:56 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Richard Henderson <richard.henderson@linaro.org>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 3/7] target/mips: Use FloatRoundMode enum for FCR31 modes conversion
Date:   Tue,  8 Dec 2020 00:55:35 +0100
Message-Id: <20201207235539.4070364-4-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207235539.4070364-1-f4bug@amsat.org>
References: <20201207235539.4070364-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the FloatRoundMode enum type introduced in commit 3dede407cc6
("softfloat: Name rounding mode enum") instead of 'unsigned int'.

Suggested-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201123204448.3260804-2-f4bug@amsat.org>
---
 target/mips/internal.h   | 3 ++-
 target/mips/fpu_helper.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index d290c1afe30..5d8a8a1838e 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -226,7 +226,8 @@ bool mips_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
 uint32_t float_class_s(uint32_t arg, float_status *fst);
 uint64_t float_class_d(uint64_t arg, float_status *fst);
 
-extern unsigned int ieee_rm[];
+extern const FloatRoundMode ieee_rm[4];
+
 void update_pagemask(CPUMIPSState *env, target_ulong arg1, int32_t *pagemask);
 
 static inline void restore_rounding_mode(CPUMIPSState *env)
diff --git a/target/mips/fpu_helper.c b/target/mips/fpu_helper.c
index 020b768e87b..501bd401a16 100644
--- a/target/mips/fpu_helper.c
+++ b/target/mips/fpu_helper.c
@@ -42,7 +42,7 @@
 #define FP_TO_INT64_OVERFLOW 0x7fffffffffffffffULL
 
 /* convert MIPS rounding mode in FCR31 to IEEE library */
-unsigned int ieee_rm[] = {
+const FloatRoundMode ieee_rm[4] = {
     float_round_nearest_even,
     float_round_to_zero,
     float_round_up,
-- 
2.26.2

