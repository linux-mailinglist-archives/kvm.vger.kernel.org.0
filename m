Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFC92D0815
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgLFXlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbgLFXlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:00 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07F1C0613D4
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:13 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id l9so1888330wrt.13
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Huxnn0HKIdijL4gbDxvVYsr519/EqwJmDm79CM0bGZ0=;
        b=uVdfWSV6oUgZ0RiBN0VekDdzex+vaiVx3ppBSPyv8R4HRoXN21n157Z2WSmR4CJMKk
         fUz87yDqjpCG/qH9w8yUaCetBRGhe0xzl3F5Xd3pklPupaMHTSm6M7ET/yssBcOYdpGN
         2uRgK1t4dwtBQjw6zdunVOzomlQ2YacmUjTzTvri/2781e2tucLYNBD/gPWtB2TkdXs6
         CTaUmyNyHwzcHhAlEWPmkytqph/KxajjPNDXWXDaHM3+u8n4Q08nnih5MyRcn15evzpj
         26EfgVj1L6Z/9WkC72aFaU2xjXyPITodgdhCAKDZvllotVcqaV82URkQnStqKtZ/f+gH
         mT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Huxnn0HKIdijL4gbDxvVYsr519/EqwJmDm79CM0bGZ0=;
        b=O+u3MQPmtuwINm5ZM37fX6RGc8bCkqQcbIJ5AL8E7JFyeASsAtcJjDFXmw1v1Yik3F
         +N9Le7aFZ5NhdihTXiyRCfiNjT5IWojiEpJ3NHMKssGp8og6uNjofJdJj5dC835YUJcy
         OTW4dLQQ9jPZkwo2ikt+FeaqmBzlr9l63NSxmLbaPQdebitRtFNlNTjv2eh5Q1Q4hqPj
         VPzZ2sylEuQS5mEYXvzgl2SH7IYnElPG2DqsiLzJp4mGk2gTBYHCjbUD5nI0L6qjKvgs
         e0lYAeW1p90jfksquAGwATGDjqMsClbkJf4l1P8/nEDCZB6+5leE9ncAT1nTHC4VjoSd
         oE0w==
X-Gm-Message-State: AOAM5339kCIsw7Hboldl9pef0GIbWIHpLgkfxtbcvU2gfSs6oQnjM1l8
        +iY30PTmzJeO8yeqIs4VzgA=
X-Google-Smtp-Source: ABdhPJzYcEqcflYGeZNH2yRDKKaaaIcgG6lb7OML9NbCgUdNxk0iaBY70qO18HQkTUwOQy8wR+faaQ==
X-Received: by 2002:adf:db45:: with SMTP id f5mr7587571wrj.153.1607298012630;
        Sun, 06 Dec 2020 15:40:12 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id y130sm12336620wmc.22.2020.12.06.15.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:12 -0800 (PST)
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
Subject: [PATCH 04/19] target/mips: Remove unused headers from cp0_helper.c
Date:   Mon,  7 Dec 2020 00:39:34 +0100
Message-Id: <20201206233949.3783184-5-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unused headers and add missing "qemu/log.h" since
qemu_log() is called.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cp0_helper.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/target/mips/cp0_helper.c b/target/mips/cp0_helper.c
index a1b5140ccaf..d8749658945 100644
--- a/target/mips/cp0_helper.c
+++ b/target/mips/cp0_helper.c
@@ -21,15 +21,13 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/log.h"
 #include "qemu/main-loop.h"
 #include "cpu.h"
 #include "internal.h"
 #include "qemu/host-utils.h"
 #include "exec/helper-proto.h"
 #include "exec/exec-all.h"
-#include "exec/cpu_ldst.h"
-#include "exec/memop.h"
-#include "sysemu/kvm.h"
 
 
 #ifndef CONFIG_USER_ONLY
-- 
2.26.2

