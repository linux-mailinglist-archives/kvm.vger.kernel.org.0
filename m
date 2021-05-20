Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E375638ADB3
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbhETMKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbhETMKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:10:04 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BFEC00F603;
        Thu, 20 May 2021 03:44:47 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v13so8776410ple.9;
        Thu, 20 May 2021 03:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B5ZWzUeYqTQLFzLVEG/RxjgILJ2YZIhD7PbaUbwdicw=;
        b=Zpd70lXIV/eUnVrI8F4+xjxllQR6HyPP1iaCcElNF5O1IUn2zHjs9Ucbu1M9iZuNn/
         9YmiF6pX3Gfy9DMn/15SOarhogNZqzhqItsmjel2+dcIfIuTOW6hbplNW20GcoDWMaeF
         NDrqzILNelFbOlWqKcmwoNszt0Ijd7b/dVf5IqRLB9gpLgwchqOddFfoXkkvZm/XAceG
         gEY+3Hewfs12i/vSpcjxEmbUK4vkKFvyG9y7WnbFmlzQcY8yYImONbmRltNM9mibaX4h
         HsL6l9MFFh6ObQPecz8LoXNwcM8IwI2dXvU+EYXQuGPwa1hBeQo4Nzie51bb/A6McqJL
         O1kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B5ZWzUeYqTQLFzLVEG/RxjgILJ2YZIhD7PbaUbwdicw=;
        b=B2sakbTUOvnJ7CD2UsFn9rdThvHYLc4neA4FhcfNjUrOzirpqCdHlwBCGQal1nG6e6
         rIopxSXOEFaJoEnK06O52/v4OAVlaYWp5i2j70DEFrcyMUIfuprVxuSxd3XL3MP84euX
         kiO4lcvMQGrMPRtOT+ZwH/eLkfDk72+fzcf2gsldzM4MQEQ8ujL1fTEHuc2W11escF/x
         CRXnlYDk5KMkHBPoWkAHywBGT7hJApQDjgoeVyNuZq+4tISXcvkR9/cMp8qqYq5H9eZA
         qcYJqssq8afTTUGPU6ZiPrgKM1IftDAFyhdr5GQusnk2c2xpJw8OPSoK5i/OEzRgQLcD
         S2Wg==
X-Gm-Message-State: AOAM531VoN/hf8aUxWI2qRgtVE77kSvOKKXoPP9wOKnuiH5X9CSHbZod
        lUscmKklSNt+Mw5fUvZ7w+U=
X-Google-Smtp-Source: ABdhPJyLlYQXZjXviGINknEFBWgEqraOFrpfGwkNKpdsDEW6vI6pdjv2iIyooBg0qMZQiifEGrFSEQ==
X-Received: by 2002:a17:90a:b382:: with SMTP id e2mr4165874pjr.171.1621507486794;
        Thu, 20 May 2021 03:44:46 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id z12sm1762572pfk.45.2021.05.20.03.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 03:44:46 -0700 (PDT)
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
Subject: [PATCH 5/6] media: vicodec: Don't use BIT() macro in UAPI headers
Date:   Thu, 20 May 2021 03:43:42 -0700
Message-Id: <20210520104343.317119-6-joerichey94@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520104343.317119-1-joerichey94@gmail.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Richey <joerichey@google.com>

A previous patch [1] used the BIT() macro to define the V4L2_FWHT_FL_*
constants in the UAPI header file.

This macro is defined in the kernel but not in the UAPI headers. Seems
like this was caused by moving code from inside the kernel.

[1] https://lore.kernel.org/patchwork/patch/11933745/

Signed-off-by: Joe Richey <joerichey@google.com>
---
 include/uapi/linux/v4l2-controls.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index d43bec5f1afd..6ecefeceba9d 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -1602,30 +1602,30 @@ struct v4l2_ctrl_h264_decode_params {
 #define V4L2_FWHT_VERSION			3
 
 /* Set if this is an interlaced format */
-#define V4L2_FWHT_FL_IS_INTERLACED		BIT(0)
+#define V4L2_FWHT_FL_IS_INTERLACED		(1 << 0)
 /* Set if this is a bottom-first (NTSC) interlaced format */
-#define V4L2_FWHT_FL_IS_BOTTOM_FIRST		BIT(1)
+#define V4L2_FWHT_FL_IS_BOTTOM_FIRST		(1 << 1)
 /* Set if each 'frame' contains just one field */
-#define V4L2_FWHT_FL_IS_ALTERNATE		BIT(2)
+#define V4L2_FWHT_FL_IS_ALTERNATE		(1 << 2)
 /*
  * If V4L2_FWHT_FL_IS_ALTERNATE was set, then this is set if this
  * 'frame' is the bottom field, else it is the top field.
  */
-#define V4L2_FWHT_FL_IS_BOTTOM_FIELD		BIT(3)
+#define V4L2_FWHT_FL_IS_BOTTOM_FIELD		(1 << 3)
 /* Set if the Y' plane is uncompressed */
-#define V4L2_FWHT_FL_LUMA_IS_UNCOMPRESSED	BIT(4)
+#define V4L2_FWHT_FL_LUMA_IS_UNCOMPRESSED	(1 << 4)
 /* Set if the Cb plane is uncompressed */
-#define V4L2_FWHT_FL_CB_IS_UNCOMPRESSED		BIT(5)
+#define V4L2_FWHT_FL_CB_IS_UNCOMPRESSED		(1 << 5)
 /* Set if the Cr plane is uncompressed */
-#define V4L2_FWHT_FL_CR_IS_UNCOMPRESSED		BIT(6)
+#define V4L2_FWHT_FL_CR_IS_UNCOMPRESSED		(1 << 6)
 /* Set if the chroma plane is full height, if cleared it is half height */
-#define V4L2_FWHT_FL_CHROMA_FULL_HEIGHT		BIT(7)
+#define V4L2_FWHT_FL_CHROMA_FULL_HEIGHT		(1 << 7)
 /* Set if the chroma plane is full width, if cleared it is half width */
-#define V4L2_FWHT_FL_CHROMA_FULL_WIDTH		BIT(8)
+#define V4L2_FWHT_FL_CHROMA_FULL_WIDTH		(1 << 8)
 /* Set if the alpha plane is uncompressed */
-#define V4L2_FWHT_FL_ALPHA_IS_UNCOMPRESSED	BIT(9)
+#define V4L2_FWHT_FL_ALPHA_IS_UNCOMPRESSED	(1 << 9)
 /* Set if this is an I Frame */
-#define V4L2_FWHT_FL_I_FRAME			BIT(10)
+#define V4L2_FWHT_FL_I_FRAME			(1 << 10)
 
 /* A 4-values flag - the number of components - 1 */
 #define V4L2_FWHT_FL_COMPONENTS_NUM_MSK		GENMASK(18, 16)
-- 
2.31.1

