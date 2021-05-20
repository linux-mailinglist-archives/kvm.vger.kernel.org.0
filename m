Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A2A38ADA8
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbhETMKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbhETMKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:10:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F13C00F78A;
        Thu, 20 May 2021 03:44:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q6so8916895pjj.2;
        Thu, 20 May 2021 03:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RFZzbSCSG3liEBFzsFBndnKLD/Fxvy9/A4lnI3gqTkk=;
        b=JIRPPqQQnCwSCGUt//YCjOWHq2ypvad/gMkV8o3aD7q2iXNGsOkmPuyuSearwgsQZF
         dBrrjWfXFgsidXWuwCdUHWdEjruWKbKlRC883fPbdU3s/ElPPKF3ZXZ/gWHCqTpIEZvh
         D+uTuT7SiiMX8uqyVF6zFDrCeScNYWjtipxI9AvISF9jEU+FC+bja7YGzlh0zshKSB9w
         uqaLECyB3jTOI6BpGLpdaYdQ/kmEOJd+E1Y05e4fQpsdyBlY2V3a8pta9xzuGIU42sn4
         6lLd/A7a6q1oaC1xHBsBMNq14JwG5y8FApd0SEjIcybEYr0aJgPfW7rQQG37AU7e0WSQ
         DHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RFZzbSCSG3liEBFzsFBndnKLD/Fxvy9/A4lnI3gqTkk=;
        b=PKS++gee56PAZd04TIFX4K+nHNcG0s3gUnuobeScL3E4IxBSfGOFIjGfXjmNoIIAv2
         QT94ElMqPgjj88B9rTzd1v1IfGMxXHCGAB1L0uJm2DoKTwnK809tRQLIZkeG3feAcRH7
         HKoLivjGKseXfd8kb/jyjR7VlPBAZIY3IShdeRr25HCV35qhPLBZI94+hxRip9OruJH3
         DwEbIcuyVdT4MNa5pEk9QQ+yHag/V6XOO//SQ9RmOI8OUbAIESROjGmsSdxJI2cBlWO/
         9gkIDDxjcuqyN5Ix3J1LV2+mRafW3bp9Dor2P6Tahow2VaySrq3k4d6G7eAxaryUZ4zf
         icAg==
X-Gm-Message-State: AOAM530iqjfYf86uWkkQ7BZqFo/CvKXeCNji8vgBzS5tyRauld6rQCXR
        MrckDt2NZqOC9kcFnOrAXhA=
X-Google-Smtp-Source: ABdhPJxx1dTd0Y3Xng3m8t0IBTSlLbvNI9PVElP0v8+VI4s1saDnixJ2q3TyYoXNuylaWlJKnSm3bw==
X-Received: by 2002:a17:902:8ecc:b029:ef:6471:dc08 with SMTP id x12-20020a1709028eccb02900ef6471dc08mr5094131plo.5.1621507482766;
        Thu, 20 May 2021 03:44:42 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id z12sm1762572pfk.45.2021.05.20.03.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 03:44:42 -0700 (PDT)
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
Subject: [PATCH 2/6] KVM: X86: Don't use BIT() macro in UAPI headers
Date:   Thu, 20 May 2021 03:43:39 -0700
Message-Id: <20210520104343.317119-3-joerichey94@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520104343.317119-1-joerichey94@gmail.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Richey <joerichey@google.com>

A previous patch [1] used the BIT() macro to define the
KVM_DIRTY_GFN_F_* constants in KVM's UAPI header.

This macro is defined in the kernel but not in the UAPI headers.

[1] https://patchwork.kernel.org/patch/11854393

Signed-off-by: Joe Richey <joerichey@google.com>
---
 include/uapi/linux/kvm.h       | 4 ++--
 tools/include/uapi/linux/kvm.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3fd9a7e9d90c..8f8a0fd7cd65 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1879,8 +1879,8 @@ struct kvm_hyperv_eventfd {
  * conversion after harvesting an entry.  Also, it must not skip any
  * dirty bits, so that dirty bits are always harvested in sequence.
  */
-#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
-#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_DIRTY           (1 << 0)
+#define KVM_DIRTY_GFN_F_RESET           (1 << 1)
 #define KVM_DIRTY_GFN_F_MASK            0x3
 
 /*
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 3fd9a7e9d90c..8f8a0fd7cd65 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1879,8 +1879,8 @@ struct kvm_hyperv_eventfd {
  * conversion after harvesting an entry.  Also, it must not skip any
  * dirty bits, so that dirty bits are always harvested in sequence.
  */
-#define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
-#define KVM_DIRTY_GFN_F_RESET           BIT(1)
+#define KVM_DIRTY_GFN_F_DIRTY           (1 << 0)
+#define KVM_DIRTY_GFN_F_RESET           (1 << 1)
 #define KVM_DIRTY_GFN_F_MASK            0x3
 
 /*
-- 
2.31.1

