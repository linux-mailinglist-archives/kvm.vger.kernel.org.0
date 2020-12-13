Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF97B2D905D
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389949AbgLMUUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgLMUUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:20:51 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251ADC061794
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:10 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t16so14387414wra.3
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h9xJIRQyKnane3GYzE3+NuQLJbx63PUZ7Fm8rhK2xB8=;
        b=mbgZQSGvTX3mqzqH4M6D4PcWZL78hL4Wie0tg103QQUUWktW0cmRGQYR0h7V3slQhg
         t4gSMQ34Q5A54o0Y1Sa7R7MGoucJqp3Q0Us+rViwnYoy08Q/6oLfcMz0cdEkMESRDLRr
         Pi8LEeMxrAFFcLQoiRffdL7iBoiQ/mR2Dzj7OwnN+lylVIQ42+5OjzgEPKLsgfYebJJu
         HihK+fShS3Ky+qibhLQDYRXvfHcg3/ibMXrTXJWu5fXCMu3lLORDVMWeiJK9Sw1coYqp
         i+kYxZP+dhrTFNcy+GQGtkLBuIULoYdwIAI0mI2UoaytcdImai1YpdGbLcLvVZ4xDrrh
         X4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=h9xJIRQyKnane3GYzE3+NuQLJbx63PUZ7Fm8rhK2xB8=;
        b=A6QSLURCneUPh5FqTj3D5rM0VgTPD2n3nbMR3hvWqGtzfP+B2zZx+T38LMXZKWlJ1Y
         +5EiAgv/Xkim8QAk9PzY9ASQuroRkYNYM+aDbxVr3/DS11Xovokd32HMfkw26Zw7vW2J
         Hm5teQq7OiESxbt9l/IQQnK98ann+axRZxdlv7EuAuglE2N6lz0IXoz2qvczRQ/XUuz0
         qaX+2VsIGQ9vFD9183eHKmd4WATwohr7WbUqybn+4W5b/3GG+5PTl0QTyyAiWwqBuyfD
         74/LWu7DHtpVa9QWnGk2tnAc0rN48+LTpK9v90KbSLqWsgUekbQVzHFJnyyofkzq1ciL
         0pMA==
X-Gm-Message-State: AOAM5303L3aIjMTHJPXKQrY1GKPMhthviitlT0wIYG0xXtJteGUVsyng
        0zksVNDYzSjuGXH87gDvo10=
X-Google-Smtp-Source: ABdhPJyhMywD88l8pOLmlXDRQKN769S3On8PU2OFuV79N9zVGRbpyseC8eMUVxtOcr1kWIil4eIZuw==
X-Received: by 2002:adf:d18a:: with SMTP id v10mr25231575wrc.273.1607890808840;
        Sun, 13 Dec 2020 12:20:08 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id w189sm15877043wmg.31.2020.12.13.12.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:08 -0800 (PST)
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
Subject: [PULL 04/26] target/mips: Include "exec/memattrs.h" in 'internal.h'
Date:   Sun, 13 Dec 2020 21:19:24 +0100
Message-Id: <20201213201946.236123-5-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mips_cpu_do_transaction_failed() requires MemTxAttrs
and MemTxResult declarations.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201206233949.3783184-8-f4bug@amsat.org>
---
 target/mips/internal.h | 1 +
 target/mips/kvm.c      | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index dd8a7809b64..76b7a85cbb3 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -8,6 +8,7 @@
 #ifndef MIPS_INTERNAL_H
 #define MIPS_INTERNAL_H
 
+#include "exec/memattrs.h"
 #include "fpu/softfloat-helpers.h"
 
 /*
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 94b3a88d8f8..477692566a4 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -23,7 +23,6 @@
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "kvm_mips.h"
-#include "exec/memattrs.h"
 #include "hw/boards.h"
 
 #define DEBUG_KVM 0
-- 
2.26.2

