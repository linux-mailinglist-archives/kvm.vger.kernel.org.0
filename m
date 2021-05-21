Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206D938C26D
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 10:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbhEUJAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbhEUJAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 05:00:45 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584BEC061574;
        Fri, 21 May 2021 01:59:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso6191669pjq.3;
        Fri, 21 May 2021 01:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TzzZMridd67ro07tLm+JuMQ0CAOlJ9SkHJCUAihqZXk=;
        b=BQlYs7dJVPHEjXrQrmBRQDrbMT7YXWnYIyhEoL3fKfToRSckEDyxlBkrWW/3CIeXzx
         vmPSrNZTlIcj/xeMDzFKXSX26W04T8pG+6dwMVBaIKr1ojfSdLLAE/eNXF6a27z7/y89
         OXyF29p2YaKaKlDvIHgkPGFyJ2S/wUBbiEihnXStbTl2LQokBCY30T8qEQbB+Zl2zgdy
         QOSFfR4JYaighKeG8eIg5PMkacXypBPKR/DTgjHTiu19UiU+8VW/KKezuBLL7lhJyo2m
         v8tzNwwi34HWndUT2UAs4z7neQIbocXA5GOnHP4BzMo1tWEPjSLG9euTLU2rYWIRcPtR
         VGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TzzZMridd67ro07tLm+JuMQ0CAOlJ9SkHJCUAihqZXk=;
        b=P6Jxm6chK/KYobna1AJ3kYKo0Zmk+9vxPKoVsXEdQCyei5qmDjyDOtlF7E/kiu4lBu
         afebrZ11PYpCd1wi8vhs35KPtgLR+B8ant+HfROALXyYSDBKPDvYMRMXnpZqKE6zKpsW
         OW0XMSxMOGIfNTOckH8dJHxNQHnfIqW1ojdJGtqvag0llPz0RYFvs0Mn1dRYkqrsXqDX
         V2p7dsB/9MNIJIt4V+AM/RvnNAc4gcsay7USMk2PjuHXz4C1HGOCMnxlP/GaJFCW2aST
         vVePbsqGyzdEO8q1t/U3He9wRiDtR8rvHDJUfMiWdAm9zzow2a4p5BrcBGDaY6PxDvrz
         qmzg==
X-Gm-Message-State: AOAM5314wdQXAfn597o/XG4pfD25ACEsaev55xfIsJCxbkPahEv8trpN
        DJgN8a1LIZNPoRFpTmPcqPY=
X-Google-Smtp-Source: ABdhPJwvn9TrOUeraeP5t4DRzPjg9f8T739lppJpjyuTjmkW891QfcTscFYafTp8kQpW4q3+/BXyFA==
X-Received: by 2002:a17:90a:8d82:: with SMTP id d2mr9757052pjo.200.1621587560969;
        Fri, 21 May 2021 01:59:20 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id q3sm3914489pff.142.2021.05.21.01.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 01:59:20 -0700 (PDT)
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
        Sasha Levin <sashal@kernel.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Lei Cao <lei.cao@stratus.com>,
        Peter Xu <peterx@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH v2 3/7] drivers: firmware: psci:  Use _BITUL() macro in UAPI headers
Date:   Fri, 21 May 2021 01:58:44 -0700
Message-Id: <20210521085849.37676-4-joerichey94@gmail.com>
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

Replace BIT() in psci's UPAI header with _BITUL(). BIT() is not defined
in the UAPI headers and its usage may cause userspace build errors.

Fixes: 60dd1ead65e8 ("drivers: firmware: psci: Announce support for OS initiated suspend mode")
Signed-off-by: Joe Richey <joerichey@google.com>
---
 include/uapi/linux/psci.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
index 2fcad1dd0b0e..87afdeb95096 100644
--- a/include/uapi/linux/psci.h
+++ b/include/uapi/linux/psci.h
@@ -12,6 +12,8 @@
 #ifndef _UAPI_LINUX_PSCI_H
 #define _UAPI_LINUX_PSCI_H
 
+#include <linux/const.h>
+
 /*
  * PSCI v0.1 interface
  *
@@ -100,7 +102,7 @@
 #define PSCI_1_0_FEATURES_CPU_SUSPEND_PF_MASK	\
 			(0x1 << PSCI_1_0_FEATURES_CPU_SUSPEND_PF_SHIFT)
 
-#define PSCI_1_0_OS_INITIATED			BIT(0)
+#define PSCI_1_0_OS_INITIATED			_BITUL(0)
 #define PSCI_1_0_SUSPEND_MODE_PC		0
 #define PSCI_1_0_SUSPEND_MODE_OSI		1
 
-- 
2.31.1

