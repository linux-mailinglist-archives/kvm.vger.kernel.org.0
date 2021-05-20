Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F088D38ADB6
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbhETMKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237335AbhETMKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:10:04 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3573C00F78E;
        Thu, 20 May 2021 03:44:45 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c12so462511pfl.3;
        Thu, 20 May 2021 03:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ZiFgLWMWvuZRELwo2jd+K7U5Q4HIOe8SBImsjcWPpg=;
        b=PEGXZmX1QZg5eZN102ymP6m47ZpJDcsahQdFjSm6a/+FEr02vOmCcLQWSAm6hZxP3r
         JO5wS7RX1ObsIwWuIKV7DYdVNiWMTqv7+/wwIFqBwsW505FTcwRiiOuiFJOeI/ILVjFz
         GoAQUrP7+2JWnX7Zt/+Cnqhkib1bkAJcHlgKmG6ozF8voutTIl2ZURlzfRvhIn2iCA/J
         HOtK7rSzHTX7ZuT7ynRcid8yAogEpyjHZic8qeQlDQ1Y3jRgOkosl8jAT/T/ro8FYExl
         QJPx1DAMTmEVxbu3/CnafFrVTODY8Q15UDAstGwLkfNLOrtbge2+C8zytnVgU2zSVJSt
         Btjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ZiFgLWMWvuZRELwo2jd+K7U5Q4HIOe8SBImsjcWPpg=;
        b=CMTqDYDYg1b6tjffK8ckFAOf02owkiV+APFNkguhJUeMDiqBuvSnd52990I0/T5YQn
         251ihEyZGiNT4y52iu0TUmqG2AD/ot4YqQTysjdBkacxWO+9CJ3ch8hT5OIF91WvnrwR
         wKTXcY1cU74UlpSbJlatLBUMPIWjAan68vZ/c2AuFCDIAvH7Ss88bQY84Bu5g6UCGJ5m
         12HrohKX8gg1npNwiR7ODY5iOBF3iVda9dZwSmY6QCLo5KWoEtUFk9IP6Nmptgvg4k4W
         LvAL9oySYVWUknGDh8J+fbHjj8SbOq5362MnTZVN7eINCLGW9+OG6UMkIiTJhQG6SDgj
         NT4A==
X-Gm-Message-State: AOAM533gJBsER3+SWE/1Pb8myDx/C+au7TpUEsxP/RdmKaN1ONzAftb0
        LBTgA3Jupo7YXn1fKtqthQA=
X-Google-Smtp-Source: ABdhPJxoh1IwwPMV1InzW2164Znzz0uMx6+mRF33S95Wu+6uvNRGeG1KcrO6dglWETXatjWGjDn2fA==
X-Received: by 2002:a62:f24b:0:b029:2dc:9098:c14c with SMTP id y11-20020a62f24b0000b02902dc9098c14cmr3833071pfl.19.1621507485397;
        Thu, 20 May 2021 03:44:45 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id z12sm1762572pfk.45.2021.05.20.03.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 03:44:45 -0700 (PDT)
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
Subject: [PATCH 4/6] uacce: Don't use BIT() macro in UAPI headers
Date:   Thu, 20 May 2021 03:43:41 -0700
Message-Id: <20210520104343.317119-5-joerichey94@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520104343.317119-1-joerichey94@gmail.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Richey <joerichey@google.com>

A previous patch [1] used the BIT() macro to define UACCE_DEV_SVA.

This macro is defined in the kernel but not in the UAPI headers.

[1] https://lore.kernel.org/patchwork/patch/11334877/

Signed-off-by: Joe Richey <joerichey@google.com>
---
 include/uapi/misc/uacce/uacce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/misc/uacce/uacce.h b/include/uapi/misc/uacce/uacce.h
index cc7185678f47..a404ec40e000 100644
--- a/include/uapi/misc/uacce/uacce.h
+++ b/include/uapi/misc/uacce/uacce.h
@@ -23,7 +23,7 @@
  *		  Support PASID
  *		  Support device page faults (PCI PRI or SMMU Stall)
  */
-#define UACCE_DEV_SVA		BIT(0)
+#define UACCE_DEV_SVA		(1 << 0)
 
 /**
  * enum uacce_qfrt: queue file region type
-- 
2.31.1

