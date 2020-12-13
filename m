Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974982D907B
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405508AbgLMUX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405642AbgLMUWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:22:10 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C217AC0613D3
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:29 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a11so6649955wrr.13
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lPfxuHaLxE9K8aKuTGSCmD6sK9ifyAYTxEpcM22e690=;
        b=Pr5IDJIIy1ec3blHYUhCbSak/f0RziqCIK5su9y046d1yiq063geeiaEQ9A/rOHqS1
         YmXuZzav6vN5pAW+dNS9A6Lzm6NRFhk14UjAiKtbRPB0HT9O4oNODBBqXYvGT/IlzOrB
         jVtgM/lfkqcO/VNBCClpJZ6wRdH8eSVV36SI01vXijcQuriWNC9GMhIadVKr9TDAokcY
         ztO950eYWGI71rpLGbfq90p5IItiBoWufekxIvGfkSJnLTQwAUjFvgRKQCl9EhM0Kfux
         v3zalJvNAiSLoG5rxye32lCy3OLpmlY2Gm4I/Rn0H6Ne/scVsZg72O4oYS3QGFe6bDuc
         8eKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=lPfxuHaLxE9K8aKuTGSCmD6sK9ifyAYTxEpcM22e690=;
        b=cCKalU3G/iIDbWyJXnOsLyP5Dx8cavcSHMEfpCIE8VojZJ+F/yF5JRvoUhmkcK75QF
         1YxTsbezPaM6ozPGEzqdZBt+W7SQeF1sUE8RVU7sgkxK/ZHcZsAM3bPgsfzRZGrtSTMU
         392RHlLQ12CyV3OGYLz0TEnCTc8PKwQrpYCxgW7V23G6K5cIH+IukU32HrEkmlJs1p0l
         XFEnevh3yhwZ94ot55tRgsfNEI9p7speYx1DbNFe1w1yFN6wwQIVETREhJ55leq08GrP
         0RLWYv3RSSQXkscV7LwVQah3I0FuOM/lSrgwG7hmjYSvp4/Ii2AQlA/aLi97XyrCws8B
         Qheg==
X-Gm-Message-State: AOAM531XZTr2gvW76XIVGagMnRnFXl6YwEK7vPTduKPEstdGbyLUUszz
        A1qpGMyNhFHkdUGGjB15M2w=
X-Google-Smtp-Source: ABdhPJykEIfb+pgpzd8TM3ktlEuSMEG2GBmsebeicQwa/ZyOg087Gw/0IqJ5Ecv/dMNq7lQ3IwomKg==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr25926230wrx.170.1607890888569;
        Sun, 13 Dec 2020 12:21:28 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id n9sm10368160wrq.41.2020.12.13.12.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:27 -0800 (PST)
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
Subject: [PULL 20/26] hw/mips/malta: Rewrite CP0_MVPConf0 access using deposit()
Date:   Sun, 13 Dec 2020 21:19:40 +0100
Message-Id: <20201213201946.236123-21-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PTC field has 8 bits, PVPE has 4. We plan to use the
"hw/registerfields.h" API with MIPS CPU definitions
(target/mips/cpu.h). Meanwhile we use magic 8 and 4.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201204222622.2743175-6-f4bug@amsat.org>
---
 hw/mips/malta.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/hw/mips/malta.c b/hw/mips/malta.c
index f06cb90a44a..366f4fdfcde 100644
--- a/hw/mips/malta.c
+++ b/hw/mips/malta.c
@@ -24,6 +24,7 @@
 
 #include "qemu/osdep.h"
 #include "qemu/units.h"
+#include "qemu/bitops.h"
 #include "qemu-common.h"
 #include "qemu/datadir.h"
 #include "cpu.h"
@@ -1136,8 +1137,11 @@ static void malta_mips_config(MIPSCPU *cpu)
     CPUState *cs = CPU(cpu);
 
     if (ase_mt_available(env)) {
-        env->mvp->CP0_MVPConf0 |= ((smp_cpus - 1) << CP0MVPC0_PVPE) |
-                         ((smp_cpus * cs->nr_threads - 1) << CP0MVPC0_PTC);
+        env->mvp->CP0_MVPConf0 = deposit32(env->mvp->CP0_MVPConf0,
+                                           CP0MVPC0_PTC, 8,
+                                           smp_cpus * cs->nr_threads - 1);
+        env->mvp->CP0_MVPConf0 = deposit32(env->mvp->CP0_MVPConf0,
+                                           CP0MVPC0_PVPE, 4, smp_cpus - 1);
     }
 }
 
-- 
2.26.2

