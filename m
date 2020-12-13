Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78122D9079
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405611AbgLMUXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405756AbgLMUWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:22:35 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F66C061248
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:54 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id r14so14394369wrn.0
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZtIz6icb9vG8sSEUm2p8Ck/LCv5K/GRxl6Ah3VWmmJs=;
        b=tzFWhUoChRKrYS25J+TqKbNe96+AgWzdYxtHl5ARz/GIED5fF95WrWR9oNZhmgVepK
         69DEKpPLqkWHrighpo5wbEDimB9+v3nKviX1rCmjqEW0WZJ4Hk5RUyRZPD4ZAdHTSGRE
         OJnyXS1H6XTL4vTgEn4BfWmGu9xNdhNDecJNAzG5JMR69rByBZVswORo+IBLq1RyYyNG
         4+zxsR0TUROEobAq8LyhvUlmk+mMgZDJzo5Mcsaiem95XfijzBr9ww4RJglPnJbyjIwU
         GgjEjQ7dazfh9Bjb2LJ3T8+HvJCeqEMWw+C8t5arZ0uVQMFkWgtd+NTFwP+Rq51cp8Rq
         JN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ZtIz6icb9vG8sSEUm2p8Ck/LCv5K/GRxl6Ah3VWmmJs=;
        b=XLpHis2VG3G88zq/nSZ+Jv6YwDO/5viVGEIU0R+GLu1YTUE2dubc2vSPH95EgrOdbz
         pPZL8hvaBYpRN0m8S/Nt7Ly3fwQ0cvLmGP6cSJh0MErbh58zr/AHeNffoWYV21X+OsYq
         w/IwZAVB1jEeyB803Owu7zpwBsKJDUQ4S1A17Yuih/X/LUXJclTkMCd0RRLTWmhYcuwJ
         phasxQ426tQsUAV07ici+UsWwAAlLrmrWtZs2zehkyt91z95sRQ6/fl9j7NaxQLA+DzH
         Tm1MFw0ewRY1uAERkuAPcnC85yHXzD+eaagPiOY1CwaS/glW2g9YxMihdKj2bqIrdtgi
         GHVg==
X-Gm-Message-State: AOAM530jKJaiKkXQspNjie4cH8GqpUTuSmW2m9xCAgBfrcYpB+RVcgr9
        cWnoXd1eQ5jLP5olJZ1OuBE=
X-Google-Smtp-Source: ABdhPJyDTHKNg3NgFUG7Kyp5sodkdQheiE4rdVXY7dx+4Y/b1e5AQbj1cd4FxUJbKXqxtuEHuH+OHA==
X-Received: by 2002:a5d:6503:: with SMTP id x3mr25221744wru.151.1607890913580;
        Sun, 13 Dec 2020 12:21:53 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id a14sm19603645wrn.3.2020.12.13.12.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:53 -0800 (PST)
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
Subject: [PULL 25/26] target/mips: Remove unused headers from fpu_helper.c
Date:   Sun, 13 Dec 2020 21:19:45 +0100
Message-Id: <20201213201946.236123-26-f4bug@amsat.org>
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
Message-Id: <20201206233949.3783184-4-f4bug@amsat.org>
---
 target/mips/fpu_helper.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/mips/fpu_helper.c b/target/mips/fpu_helper.c
index 020b768e87b..956e3417d0f 100644
--- a/target/mips/fpu_helper.c
+++ b/target/mips/fpu_helper.c
@@ -21,15 +21,11 @@
  */
 
 #include "qemu/osdep.h"
-#include "qemu/main-loop.h"
 #include "cpu.h"
 #include "internal.h"
-#include "qemu/host-utils.h"
 #include "exec/helper-proto.h"
 #include "exec/exec-all.h"
 #include "exec/cpu_ldst.h"
-#include "exec/memop.h"
-#include "sysemu/kvm.h"
 #include "fpu/softfloat.h"
 
 
-- 
2.26.2

