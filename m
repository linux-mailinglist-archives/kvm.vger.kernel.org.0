Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1B138C267
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 10:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhEUJAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbhEUJAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 05:00:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30C5C061763;
        Fri, 21 May 2021 01:59:17 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p6so10610743plr.11;
        Fri, 21 May 2021 01:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J2YdikRzDA0+TJpu2vHIxRfLfNi2y/X1orUObOJPMcQ=;
        b=YPWezR8rmITdukllwU88BHwlaqRM1dPHToJuAi/XZT4/apUsiR2eBO7sBJjPLlr8bz
         A+ZJ/F2lBzogpk4U2KC4tEjqlKJcytL9Mc1y9bitI7M8IdQpJY16ZqVeieIMbJTaXtcG
         k0CaQj/1LQiU8yyP4itYEL1YcUoHTSQKtSI+6BogDR79h2KNPNDzIr5AUViL+Ru9Wxv6
         SIoBrpB2Dt9sjglTXzAG9CoOSBBj3Weu5HfJtvvXqvFYcW4LkHJU25b8YXekuYPZ6YKN
         kY/aFaavE7V1kunGfNIwPpISOYxvM2WeOdRTzHtYeR+wh58PQZMe2SNWFsDrEDFsE+Xp
         xGtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J2YdikRzDA0+TJpu2vHIxRfLfNi2y/X1orUObOJPMcQ=;
        b=IIiuPWTX59Ujk7C4rrdT2fxej/jbM5ssLwjSNzKHLT3t0ZWGlyb3QtmCzLVBK6sl/q
         pedmaRSbKcqr2SD0oeL6Dn1SFtfxqxECSrtA4KJyFJhYMYxBJqekLutQi51LQt34ndZr
         Dl8n377d8brpcjFXyuqG4j0KLrweuk5yBKTCNIYOthO08Wmsumn2iiIWkxQHnYMgTMmI
         gs2+yHuvCUYce6OoZ7BeZkmqKOub/XQFT2HBCBu4muht/+ytGUFkiHTk5OlGEmHHrqRY
         005raDyrIqvLPQ5gYtdaUy7ifXwqxkiyY1/d1zUxxCO8v7avJG79VkPJS1ffcup3qQPi
         Kutg==
X-Gm-Message-State: AOAM53063KX+cVwQF6dRocV8AjnT31jpwo90NjM0tBLUCh23wB3pXKkw
        3ozEZFmEerxYmXo3msd0eww=
X-Google-Smtp-Source: ABdhPJxJdEKyYhdH0U2LbRsagJ5Z264nhWDwj8nq800bCnlPbJ3QlLY4Cn8Acsh5KjT8jB1Tw01H4A==
X-Received: by 2002:a17:90a:c792:: with SMTP id gn18mr9489955pjb.44.1621587557337;
        Fri, 21 May 2021 01:59:17 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id q3sm3914489pff.142.2021.05.21.01.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 01:59:17 -0700 (PDT)
From:   Joe Richey <joerichey94@gmail.com>
To:     trivial@kernel.org
Cc:     Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Sasha Levin <sashal@kernel.org>, Peter Xu <peterx@redhat.com>,
        Lei Cao <lei.cao@stratus.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH v2 1/7] x86/elf: Use _BITUL() macro in UAPI headers
Date:   Fri, 21 May 2021 01:58:42 -0700
Message-Id: <20210521085849.37676-2-joerichey94@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210521085849.37676-1-joerichey94@gmail.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
 <20210521085849.37676-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Richey <joerichey@google.com>

Replace BIT() in x86's UPAI header with _BITUL(). BIT() is not defined
in the UAPI headers and its usage may cause userspace build errors.

Fixes: 742c45c3ecc9 ("x86/elf: Enumerate kernel FSGSBASE capability in AT_HWCAP2")
Signed-off-by: Joe Richey <joerichey@google.com>
---
 arch/x86/include/uapi/asm/hwcap2.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/hwcap2.h b/arch/x86/include/uapi/asm/hwcap2.h
index 5fdfcb47000f..054604aba9f0 100644
--- a/arch/x86/include/uapi/asm/hwcap2.h
+++ b/arch/x86/include/uapi/asm/hwcap2.h
@@ -2,10 +2,12 @@
 #ifndef _ASM_X86_HWCAP2_H
 #define _ASM_X86_HWCAP2_H
 
+#include <linux/const.h>
+
 /* MONITOR/MWAIT enabled in Ring 3 */
-#define HWCAP2_RING3MWAIT		(1 << 0)
+#define HWCAP2_RING3MWAIT		_BITUL(0)
 
 /* Kernel allows FSGSBASE instructions available in Ring 3 */
-#define HWCAP2_FSGSBASE			BIT(1)
+#define HWCAP2_FSGSBASE			_BITUL(1)
 
 #endif
-- 
2.31.1

