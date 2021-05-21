Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3DE38C26B
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 10:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhEUJAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbhEUJAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 05:00:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDB0C0613CE;
        Fri, 21 May 2021 01:59:19 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b7so6459294plg.0;
        Fri, 21 May 2021 01:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XBuT/V3P0pWC+ggnGmOX+z+lc1lWh88kce8Okb29znM=;
        b=th9xtbD/aHMHBiQSY1g07NwM3TUVpqnBAcUupD1TBpQoSsfG5Oe7BGVpfS2U/UZclg
         Xhy8zEINjoqy+dS3JRZZreMPv3kmVVhsiQTeg4OIijjOL4mxp2M+c3FJnGOODP0uX75X
         +yaMqHGoq6CFlVwzsbJc9Ar5p8shcAFQHMumoNlVXUbBW78j08UG0IydZqh+Qv6eX3X/
         XW01VeLen5pxgW5OJhJsK2bqSsP8MC6WEZ2VMw7svpBqhR3vgRJ6x7wxh+DFx9gNlKHf
         Or87tEbqDGiLmGNJ7FH7pWzJzmLZIVo7DD12Cx/LQKe11DkkbsyJe9xGm/G7n2fWjklt
         enqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XBuT/V3P0pWC+ggnGmOX+z+lc1lWh88kce8Okb29znM=;
        b=MFzPQDejX+gWvD3GWGIwpajVOKBZ1Wp3SsD4QvEDSVuC9k0zeXVq90aE4i+pP5bG5h
         j3u6xhEEwf+n8nmduUyxdAw4PBfK7Yz6fPsK6V5iuH1CQbIDdbxcmwvifawsbHmgILgY
         7x/K9QBku4VxGEassFJzRm9nmdDbJclzfoSdLqhpvLsjAlQDcc8Q4gI73WchJB50sFFv
         /kFUep7mJtPrFboSqbx6oixPhypswWgXW7nmUaFdjXCOnMo7YYhs1kBUgFvQdlBhF8pM
         16xXTu6mS/Yug1EgbuWEai4FOFqotnwCYcZfkqQ3319hXlob03/bNrxGOI9SITqXxC4i
         f4Uw==
X-Gm-Message-State: AOAM532j2P6VTXrbyeBLplykXjZotaM9aPb4NZsH0uoc95lj7aIM/8/w
        ete8uEDNNNohAbUsa4jtcCM=
X-Google-Smtp-Source: ABdhPJxN3X0zUHNKO+LXfZHgjCVL4v9DqnY3i+c5fxiXCCPHA3ZbZc9Z7NLyQm2mTJpTyKmmE4lfNg==
X-Received: by 2002:a17:90b:19c2:: with SMTP id nm2mr10180945pjb.18.1621587559209;
        Fri, 21 May 2021 01:59:19 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id q3sm3914489pff.142.2021.05.21.01.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 01:59:18 -0700 (PDT)
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
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH v2 2/7] KVM: X86: Use _BITUL() macro in UAPI headers
Date:   Fri, 21 May 2021 01:58:43 -0700
Message-Id: <20210521085849.37676-3-joerichey94@gmail.com>
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

Replace BIT() in KVM's UPAI header with _BITUL(). BIT() is not defined
in the UAPI headers and its usage may cause userspace build errors.

Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
Signed-off-by: Joe Richey <joerichey@google.com>
---
 include/uapi/linux/kvm.h       | 5 +++--
 tools/include/uapi/linux/kvm.h | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3fd9a7e9d90c..79d9c44d1ad7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -8,6 +8,7 @@
  * Note: you must update KVM_API_VERSION if you change this interface.
  */
 
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
@@ -1879,8 +1880,8 @@ struct kvm_hyperv_eventfd {
  * conversion after harvesting an entry.  Also, it must not skip any
  * dirty bits, so that dirty bits are always harvested in sequence.
  */
-#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
-#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_DIRTY           _BITUL(0)
+#define KVM_DIRTY_GFN_F_RESET           _BITUL(1)
 #define KVM_DIRTY_GFN_F_MASK            0x3
 
 /*
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 3fd9a7e9d90c..79d9c44d1ad7 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -8,6 +8,7 @@
  * Note: you must update KVM_API_VERSION if you change this interface.
  */
 
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
@@ -1879,8 +1880,8 @@ struct kvm_hyperv_eventfd {
  * conversion after harvesting an entry.  Also, it must not skip any
  * dirty bits, so that dirty bits are always harvested in sequence.
  */
-#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
-#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_DIRTY           _BITUL(0)
+#define KVM_DIRTY_GFN_F_RESET           _BITUL(1)
 #define KVM_DIRTY_GFN_F_MASK            0x3
 
 /*
-- 
2.31.1

