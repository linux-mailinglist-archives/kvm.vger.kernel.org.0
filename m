Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318A52D0819
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgLFXlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgLFXlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:19 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3CCC061A52
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:29 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 3so12019844wmg.4
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nvvnuVAXyMXpDzWyrVINIXmEpj3Xa1vtGYGPNmttFgg=;
        b=n88N84E/kJAVo0Mxv3CD6rucxKCZvjzDLCaLmUaDQq7FtRotXM5HNe+7mTUSvR0xw2
         e+nh5+7e7RxkOcIpAN2a2l2lagy9R6AgbXqmKb3gjMtVS1rHZ24aRbBB8lKg3Dfwhrdt
         m/uqQbHQE3GChYP9x8yxehO52L680Z91+AKqEpWZungeZHoMVteAU9JqSw2NQ3oGmo4Z
         yamgUSSLJVXaHyJxIoLCczu+vMChZUaLx/8CqTsxii9Oql71csY140FfWl1VDk1vysui
         PgDlYmZUw/2UQRF8XdM7RZsCY9HV3vf9kq8vGtuHY8TV0g2w3o7Yh33h2p0uYQN7chvi
         cmpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=nvvnuVAXyMXpDzWyrVINIXmEpj3Xa1vtGYGPNmttFgg=;
        b=DqjkuTiTOllMmUZ3rh1/1DKQSE05knxa7JQgNCurA+A+LPNdSo8SXnN2PMh/A7luHx
         tMQNh/JXHCALoao44lAZ4UZLo7xQn3HPTDdph+kROhhPyI7upbF/45JC+m1XMkaQYHFO
         v5LuAqXOSZzHm1nEyCjXYHkzKPUX4aIPQTWNgLWo/LiDBv0NqFVDQHLMwZYLa70wTYfN
         dPTcxwz59qUyw0fQSMpHJUd3bnmxCPv3sNmq115w9/YVHlHVnh8O3D9cx7D5OXOjmKtm
         4Oq1q/NNCMrq1J0LmgkSNDYMF3Y7472H/GvwTc9rQivDA8aBfmDxQbIwSivHslJYs6Wr
         FyVA==
X-Gm-Message-State: AOAM531hRAJ1jVM9EhQzlm8BhFQawtCE1BIn60n4z3m+7R76R83MoDdY
        WtvU5HOAkxx84ZSy2EBMlNU=
X-Google-Smtp-Source: ABdhPJw3Z/Cg8aKrlfWwSiz6cd42kt3hOEz7TpaPUsuc69JEMA3JkZ1sJCT+n/WH6cgUMPmM3FmWTw==
X-Received: by 2002:a1c:5f54:: with SMTP id t81mr15343246wmb.77.1607298027981;
        Sun, 06 Dec 2020 15:40:27 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id c4sm13758103wrw.72.2020.12.06.15.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:27 -0800 (PST)
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
Subject: [PATCH 07/19] target/mips: Include "exec/memattrs.h" in 'internal.h'
Date:   Mon,  7 Dec 2020 00:39:37 +0100
Message-Id: <20201206233949.3783184-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mips_cpu_do_transaction_failed() requires MemTxAttrs
and MemTxResult declarations.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
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
index b3f193f7764..7a6ea5299fb 100644
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

