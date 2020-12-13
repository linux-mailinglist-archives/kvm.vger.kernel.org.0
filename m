Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DA52D9077
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406196AbgLMUWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406110AbgLMUWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:22:40 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE442C06179C
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:59 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 190so1722479wmz.0
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fVAITAmVV88TOoHja8gyTESqhv1q8JBRT/l8262AHZk=;
        b=NHiRLFi7tQsiEdJAPcfC0zbPhb6JmiwS/yPCkgmKA9XgHdOL9CAVSFJ33hrEG9NHuk
         VxTcak9a3ybUtHDn9Qb0ouA4nIAia2K4rA/4l6Ig1P4lPMTng48qsVzi4B7S0hIxSLTm
         ddoXqoZDDnR5r+msyxywj9pFkwuO8SQ8WQfGjlOowyZPmRVMzEfVyfRIU9bvBg4/pbRJ
         I/sjyV5KIyMcdT8b1EL3CLmKYB7LO8uRj3yt7Sx46ML2k/59VEmyABz/jy8/TJGc/6kV
         RAXzO4La7/sbECmoZWL4AGWSXTuA96vW92ne1NtkbXnFaXBBorVRToQyofsAZOz5723t
         adRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=fVAITAmVV88TOoHja8gyTESqhv1q8JBRT/l8262AHZk=;
        b=opgpfYzUfo+Wf1h4Pc9ohuJ5Rqz02L+zLa/+CK3CLLHswYI5U9DYeMbD8lqW/Nymrm
         FA4CA67iCT9sYLD+A5a1/7av1GqYTTZ84USIDQKnpcZn0jyRwY9boUr4Wb8EjDJuIsht
         K/ivtRm27kCtJUB+KGkpea5QeHVx0k9wV60aAclyKENZJVkQAVWkFOmto/e5a6CBJhtF
         5YZVo3SE8Q/uPe2X59jTrA6kkSzPtVphOdEg3SQWo1vOBdsQ1RUtdU+EGrSgyrSlDJJN
         IJoiErgrK59gWsshTsZVtUnP3GLiP9hjpWtRJzbcLhF4EbGY37ZbP9t6WRy2KcaDgUG9
         BPwg==
X-Gm-Message-State: AOAM531KCQEtk/otgDIXWkkKEUuaSz8vyTrYPBAR1q/bNYhx6AxTAQbW
        CDZ2K26lzICwPUShf7E95Ik=
X-Google-Smtp-Source: ABdhPJz0CPv/da6KphdHRQ8txpNwxGAeqv36g/49a8+2n8jK31ow8jEvleGDUtARLN/jfRXupU+u2w==
X-Received: by 2002:a1c:cc19:: with SMTP id h25mr24645226wmb.124.1607890918580;
        Sun, 13 Dec 2020 12:21:58 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id f16sm27335349wmh.7.2020.12.13.12.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:58 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 26/26] target/mips: Use FloatRoundMode enum for FCR31 modes conversion
Date:   Sun, 13 Dec 2020 21:19:46 +0100
Message-Id: <20201213201946.236123-27-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
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
index 0515966469b..e4d2d9f44f9 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -223,7 +223,8 @@ bool mips_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
 uint32_t float_class_s(uint32_t arg, float_status *fst);
 uint64_t float_class_d(uint64_t arg, float_status *fst);
 
-extern unsigned int ieee_rm[];
+extern const FloatRoundMode ieee_rm[4];
+
 void update_pagemask(CPUMIPSState *env, target_ulong arg1, int32_t *pagemask);
 
 static inline void restore_rounding_mode(CPUMIPSState *env)
diff --git a/target/mips/fpu_helper.c b/target/mips/fpu_helper.c
index 956e3417d0f..bdb65065ee7 100644
--- a/target/mips/fpu_helper.c
+++ b/target/mips/fpu_helper.c
@@ -38,7 +38,7 @@
 #define FP_TO_INT64_OVERFLOW 0x7fffffffffffffffULL
 
 /* convert MIPS rounding mode in FCR31 to IEEE library */
-unsigned int ieee_rm[] = {
+const FloatRoundMode ieee_rm[4] = {
     float_round_nearest_even,
     float_round_to_zero,
     float_round_up,
-- 
2.26.2

