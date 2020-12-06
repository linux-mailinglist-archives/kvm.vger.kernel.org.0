Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97192D0811
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgLFXko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgLFXko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:40:44 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92B0C0613D2
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:03 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id r3so11037501wrt.2
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DEaTvj3VcNVgO4De83R7lmbSE3LG2HSypVjtVT7iMo8=;
        b=mt0wPXSaue0XcM4NwtYAtuHUaaMWvyXCJ9I38kK0npE2Urhbpu7ArEUijYEMpLXq87
         9/skJR5oZDZbsF55iCgxIUUB+WnXRSJil0LQ72VcLroRWzoVf7t8621ItqDdCvsCvDNn
         CPeRNjP1w8gxvjJrq5yz13E+7nQKxEJudCV5Q6makxw9SVMUeIcZT7iq3+Ke1ICoWvdW
         gYSWUur6AP610nzZa54XyAt/hWSdCyNAWOt9iGlOZqjqX3Fgfh4q/+FngKPFupbL/eef
         nObIJFG2MMzRgpO5Jzda3jbCcHx+J8dHkx3sDPMt0V6amiFX2lcOrm6rFQ1yYl7CLqKx
         DkXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=DEaTvj3VcNVgO4De83R7lmbSE3LG2HSypVjtVT7iMo8=;
        b=gAWXaBDFXMkYKoZ9Iy5KDJK8LwBM/gvxgHBgZBAAT3sCtfv4Z9g0aOAJLErPvTjWw8
         YuoVe/VVVSGinMNd3mhTQQfSBqLxFeo/7PtdJrc7aZCnR0KO0dA2OOkQXg6UKeGsFlhf
         wjh9pVswgEJv8oqUZvCDapAL/3/mFEIiBXMchO8hFnC1gQgPvKLkUxAAn0Wru67yA6PX
         JLWp0hzLriLLTW4vNKPUE2tKKF+s85Rthr/QGFoAKG3NzCi0STo66SPst+IRMTdxPyTK
         xA/58+61dx38tBdBHwpr7N1cGfytoVqvLqRBkcxEpgLrp3IUI+0GME3NnTtXrQvf4Pdo
         OJHg==
X-Gm-Message-State: AOAM533AY52/JjtnsJ+wNx5LAfLejP9yZ416P2v4/EWil8y93+TGoVHG
        PtM4G8Ulvo0yJp8p8LTHjmMHSv/+HpA=
X-Google-Smtp-Source: ABdhPJwA7CyhC0yC4B3t0LydZBABnTbwqeTRjimAiaidZNwnn2wU7OPS3BL/6Y/lQ7edj6etF4Gu4Q==
X-Received: by 2002:a5d:654a:: with SMTP id z10mr16447548wrv.285.1607298002625;
        Sun, 06 Dec 2020 15:40:02 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id n126sm12302988wmn.21.2020.12.06.15.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:02 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 02/19] target/mips: Remove unused headers from translate.c
Date:   Mon,  7 Dec 2020 00:39:32 +0100
Message-Id: <20201206233949.3783184-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index 87dc38c0683..346635370c4 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -24,8 +24,6 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "internal.h"
-#include "disas/disas.h"
-#include "exec/exec-all.h"
 #include "tcg/tcg-op.h"
 #include "exec/cpu_ldst.h"
 #include "exec/helper-proto.h"
-- 
2.26.2

