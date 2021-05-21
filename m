Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50AB38C26F
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 10:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhEUJAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbhEUJAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 05:00:47 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B844C0613CE;
        Fri, 21 May 2021 01:59:23 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso6829558pji.0;
        Fri, 21 May 2021 01:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yM/3QdkJCppokhFbJwJxmhjVf2nsrL4HrLq6id+fxEk=;
        b=PvEz30dm/K8/j50iH//PbpjEfJzooQ9UREv0KIGi7QlAsFEZ5CsF415d+FyDZlTfCB
         mN0snlIOptA+BBG8KbBFsYIBvkvNQAYQkfzc0Ize26XRY5tDKPFkTWOJwtugVydkywob
         RGaYHCsyOU/+UrD+KWX0uQy3fVYCrtLsoclDKCpaDogDpyQ8WVqUWtOfSve2Pedb4L4h
         pKr2NJsVdJfPFoP3zAN2nmRpOn/VdbQpnJ23AIFCpYAGrlyFXPMqHjgZyfnwgrwK7sTH
         LjaSFQ30FByisriSdtWNp5a6twgVO4Q7jnWuw48yMjjmgNsHdoXQM5y4amxAwoWAoK+W
         8PQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yM/3QdkJCppokhFbJwJxmhjVf2nsrL4HrLq6id+fxEk=;
        b=UaYwWz0yLN/wO3rZgrVZQWh+zP82QSZZDqj/tElyW5F9zndCl0ash67uy807gAG7ot
         X/FnVAtx0t/LSqQ62puI+HcWO7B7JnIW3VLgmHF6tPsFXyjMdVuvlLE9QszLE63q1ao+
         5Xzv/8gPJHFhP98ncmKWlZxz4kb5+TwJmSQDI0oOf4cHpl2cf6GMG6HTw90XpomCsjUo
         lE/GOzvBPEJEXhKc65nBdm0wSG/cWRQ7iEtnShKz0KCzvYhKa5bwdYOSUKvw6IG2B8+/
         upQvImTh4fBR/GKJjS4oSaJtX8lEKFqrH5ELDAM9Kzrag7F4PpT+uuRushkrR0pcOw+k
         eoqQ==
X-Gm-Message-State: AOAM530IF6ii63/MFSwgPnc2RKCsOmn/3tfqVhXsBY7o5E6xE5zAQMpt
        aQrVbuBmGvZRPdc5uGlEQwg=
X-Google-Smtp-Source: ABdhPJzQ+uz7ynSjk7hSnQcnNXkwicmsLqykMuigPly1P5X7ww5hgmnns91iZetd85tDoMaSYRFlBg==
X-Received: by 2002:a17:902:7e02:b029:f1:62ce:6674 with SMTP id b2-20020a1709027e02b02900f162ce6674mr11071326plm.39.1621587562995;
        Fri, 21 May 2021 01:59:22 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id q3sm3914489pff.142.2021.05.21.01.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 01:59:22 -0700 (PDT)
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
        Andi Kleen <ak@linux.intel.com>, Peter Xu <peterx@redhat.com>,
        Lei Cao <lei.cao@stratus.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH v2 4/7] uacce: Use _BITUL() macro in UAPI headers
Date:   Fri, 21 May 2021 01:58:45 -0700
Message-Id: <20210521085849.37676-5-joerichey94@gmail.com>
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

Replace BIT() in uacce's UPAI header with _BITUL(). BIT() is not defined
in the UAPI headers and its usage may cause userspace build errors.

Fixes: 015d239ac014 ("uacce: add uacce driver")
Signed-off-by: Joe Richey <joerichey@google.com>
---
 include/uapi/misc/uacce/uacce.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/misc/uacce/uacce.h b/include/uapi/misc/uacce/uacce.h
index cc7185678f47..e0b4c8a2d29c 100644
--- a/include/uapi/misc/uacce/uacce.h
+++ b/include/uapi/misc/uacce/uacce.h
@@ -2,6 +2,7 @@
 #ifndef _UAPIUUACCE_H
 #define _UAPIUUACCE_H
 
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
@@ -23,7 +24,7 @@
  *		  Support PASID
  *		  Support device page faults (PCI PRI or SMMU Stall)
  */
-#define UACCE_DEV_SVA		BIT(0)
+#define UACCE_DEV_SVA		_BITUL(0)
 
 /**
  * enum uacce_qfrt: queue file region type
-- 
2.31.1

