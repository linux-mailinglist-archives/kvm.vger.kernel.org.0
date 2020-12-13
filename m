Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEA62D906B
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405099AbgLMUVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404225AbgLMUVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:40 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4BBC06138C
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:59 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d26so1170661wrb.12
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E1hxADG4MX0Qqgj23YttpXWtCnMPo6j/2Ptp7rd9RPE=;
        b=QJFYRIMo8edvn29D1DGA7j5LQJwzHYFijAw70dc84SW3Bf5yGOmnjKsKS20YMVf9Wt
         /BD5B0paE6WUu0sC6SPFI/4L1EkLVjUANPBop7Qd2o7tEG7H4SFdNffeLoeMrdeUyN8z
         xhz1zVIA8ydanmWq2pkfHi2+YLcjJaKSqEfen8BB77Ms4Y6KGkalcIGf9sLp2uQlBvx7
         DlsC2gtyLoRhTEL493heZAMTVZY1zTTl+3c+oQy5DXIAezp5gGPbalKVXSyPzrQN2SaJ
         h0/jSmHwfX8nYQWjO9UW2HsD0YtMOv2J4LePNa8IXiKqUHQIdHayhMfSCp+1uiqPPckO
         ALRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=E1hxADG4MX0Qqgj23YttpXWtCnMPo6j/2Ptp7rd9RPE=;
        b=HsrYmQ7PqVg4S4p5/cJnvxj/wz1+xHwuymNlTfATVpi1EW5T/vZIh6Cur/tr8lMGUB
         +N4xaPXZ+wU2O4YN9z9tREFw0bu/DICiZf6GjWeZw7I3PwdtNqymM+dHL9D04Z4g39gV
         m5o7fn0ewv3/FgQoI+qpPV1eKCmo/XEZ74hVn1SA4E5m5e6SKyCMDKfs17CIN1Sqw66j
         YQBFq9H06zcmjQ7amT2RkpX2uPNzeiI/jS/3D8ICtvzs/pPyBbvraxJ812aSqOlupMAQ
         ELCpl9pyesuCsayimO85fowcUoLCQn9Eym0QUOeLqLsNZ6IdbwBvkRyT6E5L8EdYOONp
         tT9g==
X-Gm-Message-State: AOAM530QnVyTmwfcKhTD26TiBYQP91PykM6r6JDHxMHLD5u9KmGo3+GM
        L2eEpexEfeKMI34lpt8tWLI=
X-Google-Smtp-Source: ABdhPJygLgMquJOuVDVVtUz62vwP8PWlMlcYv5NJwKGEiE1SobyrQYByafn6qthVZy6ISQ4FO2l0uA==
X-Received: by 2002:adf:90d0:: with SMTP id i74mr26003505wri.288.1607890858762;
        Sun, 13 Dec 2020 12:20:58 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id u3sm30014199wre.54.2020.12.13.12.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:58 -0800 (PST)
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
Subject: [PULL 14/26] target/mips: Remove unused headers from translate.c
Date:   Sun, 13 Dec 2020 21:19:34 +0100
Message-Id: <20201213201946.236123-15-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-3-f4bug@amsat.org>
---
 target/mips/translate.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index 4a1ae73f9d0..e87f472a8d1 100644
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

