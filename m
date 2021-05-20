Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF84138ADAA
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbhETMKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbhETMKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:10:03 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A91EC00F78D;
        Thu, 20 May 2021 03:44:44 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so5057330pjv.1;
        Thu, 20 May 2021 03:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ErpZlZtEjVnBv8JgAW5VuOM45iouE3c/zRV6fvcscso=;
        b=VoTCzqQ+AyfdLVTkMzITHdTK59fSm9bj0MwFlLrubCP2kn8gUFJEmiyAdY5QQ2p8jd
         1VaoPdnI2d3NHqK0u8afuzQT74OP+rfUcmzVnLkWxOv8RaLJI6TxvE7eD2vTwzS77aA1
         n/xlmbQ6lxgARADB0Yo0ACzkLaPUuPT+S57RfsD1PxdFfCkAqfvqBduYsE8Fd/iIV0Ch
         3bjFjefjHvuOrbmZcN9OOGhq0UKcYNOTrnwZ5SuckA+/Kc/XW5s8SBsgNb7Z3jLHV6eW
         IVhrpOZaBlldsrHJe5wpRk3k+jnoSMViUYsdRAg/x1y6M/dOrtzXHZwwIvHgHYg01oqS
         SkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ErpZlZtEjVnBv8JgAW5VuOM45iouE3c/zRV6fvcscso=;
        b=abrIdpNsCajJqrGvbQF9NX9RVvKQBHydwPS1MIAx8wYrKu4A31nsb+wb3PUWrmK+N2
         Yg3FXDBx0BWQzroF1rCwq9IZOEQNUCJd8ZlWprj/7+KARKHcn1UZgwLs4G/wSOUXk9u3
         lNX3zSpXSSzBWdI32/f5VEf152cC/FI5px8KVBKljfI9JYK6jAMRna+rh+AbX+tGhTGI
         3HM4LQ1DVuGqf/LNJRx7eXzxTEsr3IYIRTryQXqKlHnJe1cpBr85k9YDdXyiYx9GS+o0
         0/O5k/pXRQoQAkGlXTyly8e8LfoNrgOEo2qOaQDIu1eiKMcj5PrmdLtKjo/KKIzj6bS9
         B28Q==
X-Gm-Message-State: AOAM531LQGAFDhyksUro0jCfhAcKbmzJxAlqoZQ/XE77ekhfv7Ycrtt6
        Sz13wkOcuhrdub7/M29fxg4=
X-Google-Smtp-Source: ABdhPJzblwJWpZXmZ5nSjMydEL9hQ10+4wP8w4oFCgka/uj1HS7wzPRzVgi786Z/NZkZTjntrHYGQg==
X-Received: by 2002:a17:90a:3bc6:: with SMTP id e64mr4659024pjc.156.1621507484095;
        Thu, 20 May 2021 03:44:44 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id z12sm1762572pfk.45.2021.05.20.03.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 03:44:43 -0700 (PDT)
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH 3/6] drivers: firmware: psci: Don't use BIT() macro in UAPI headers
Date:   Thu, 20 May 2021 03:43:40 -0700
Message-Id: <20210520104343.317119-4-joerichey94@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520104343.317119-1-joerichey94@gmail.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Richey <joerichey@google.com>

A previous patch [1] used the BIT() macro to define
PSCI_1_0_OS_INITIATED in the UAPI header.

This macro is defined in the kernel but not in the UAPI headers.

[1] https://lore.kernel.org/patchwork/patch/949966/

Signed-off-by: Joe Richey <joerichey@google.com>
---
 include/uapi/linux/psci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/psci.h b/include/uapi/linux/psci.h
index 2fcad1dd0b0e..d7da8059cbbe 100644
--- a/include/uapi/linux/psci.h
+++ b/include/uapi/linux/psci.h
@@ -100,7 +100,7 @@
 #define PSCI_1_0_FEATURES_CPU_SUSPEND_PF_MASK	\
 			(0x1 << PSCI_1_0_FEATURES_CPU_SUSPEND_PF_SHIFT)
 
-#define PSCI_1_0_OS_INITIATED			BIT(0)
+#define PSCI_1_0_OS_INITIATED			(1 << 0)
 #define PSCI_1_0_SUSPEND_MODE_PC		0
 #define PSCI_1_0_SUSPEND_MODE_OSI		1
 
-- 
2.31.1

