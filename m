Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076F938C272
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 10:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbhEUJAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbhEUJAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 05:00:49 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF85C06138A;
        Fri, 21 May 2021 01:59:25 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v14so10996143pgi.6;
        Fri, 21 May 2021 01:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GRgnjjTyc74OV+vFDIKTcD4cnOw31v5F87VYgn4dO00=;
        b=JFKQpqxj0ygKabhGTJJ+/xkGGepO/JNO2FMbi0BuqBuK0zIwrUvOUQfkljjTPSpSKW
         wB9aBkinNrys/SDoxg7RXc8aJBj5Mwp2cA6MVV+u7sSRFfaSYC1LMWKvfgyuFUTt9tEk
         X7orRttCgEikL7CCIYE78Z4ucQGX7v3FfRR0gQJFFn5GkC2RI9bvWMgALeGyssHK1CbM
         XDKQmzMS0Pqs4DgMm76QN6Y4mujKdjn5agq5aMlbEdWTFj4MYfc7OVQ+awIAw8hRIalj
         ZvKkLhFstreG7MxyRt3rfBSvtSfMGYO6Bk6fOCuCgWwWdFeoDMyyByeESrKDrz/fEBI2
         q64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GRgnjjTyc74OV+vFDIKTcD4cnOw31v5F87VYgn4dO00=;
        b=ufpD4rSLqTipW736xd2/4Jt1JtyN7Fu/PY+JYcweOoXyR6ZE8LbV/nluixhjakSkqw
         d7dd99u2xmA9YXOB209Pdevqpl0N925IqzvPt8JZ5jVBHP4p4rEOBN7+CRvt3r0ZPuM2
         b1YaHPFLyFRbrf1u/qHp5HhwKJV2EvLL2nkb79BIqHBe+2yGdc/Lla8MpQj8RIzocqjx
         M+MTNUox7QSdz8VA0aRsUncovlH0BqUAvMd9sffZ5LXs5fHMOG7ZlnKYkhjVUPSquUUD
         VX3JF/gzRsWxbm/2rgnPsoji8bM9wBXyEXDFI/hpiD059CAICH1TeNBXTiRGbQMuifdr
         OVag==
X-Gm-Message-State: AOAM530zjIN25pI99sgS3OJBz3N9icldwBNBzlrY6s9asDbHLyaDlXV8
        hufdz4ZoYX0BaeCz3NuTHIY=
X-Google-Smtp-Source: ABdhPJx2PTi/wpWd6gak1llMG8fVDiGbU+juhvNqBuEyttwwviuaokLn9lG3Ej6ao2/rDQ055IDIVA==
X-Received: by 2002:a05:6a00:14d0:b029:2cf:ee47:dfd9 with SMTP id w16-20020a056a0014d0b02902cfee47dfd9mr9557263pfu.31.1621587564803;
        Fri, 21 May 2021 01:59:24 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id q3sm3914489pff.142.2021.05.21.01.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 01:59:24 -0700 (PDT)
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
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, Peter Xu <peterx@redhat.com>,
        Lei Cao <lei.cao@stratus.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH v2 5/7] media: vicodec: Use _BITUL() macro in UAPI headers
Date:   Fri, 21 May 2021 01:58:46 -0700
Message-Id: <20210521085849.37676-6-joerichey94@gmail.com>
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

Replace BIT() in v4l2's UPAI header with _BITUL(). BIT() is not defined
in the UAPI headers and its usage may cause userspace build errors.

Fixes: 206bc0f6fb94 ("media: vicodec: mark the stateless FWHT API as stable")
Signed-off-by: Joe Richey <joerichey@google.com>
---
 include/uapi/linux/v4l2-controls.h | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index d43bec5f1afd..5afc19c68704 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -50,6 +50,7 @@
 #ifndef __LINUX_V4L2_CONTROLS_H
 #define __LINUX_V4L2_CONTROLS_H
 
+#include <linux/const.h>
 #include <linux/types.h>
 
 /* Control classes */
@@ -1602,30 +1603,30 @@ struct v4l2_ctrl_h264_decode_params {
 #define V4L2_FWHT_VERSION			3
 
 /* Set if this is an interlaced format */
-#define V4L2_FWHT_FL_IS_INTERLACED		BIT(0)
+#define V4L2_FWHT_FL_IS_INTERLACED		_BITUL(0)
 /* Set if this is a bottom-first (NTSC) interlaced format */
-#define V4L2_FWHT_FL_IS_BOTTOM_FIRST		BIT(1)
+#define V4L2_FWHT_FL_IS_BOTTOM_FIRST		_BITUL(1)
 /* Set if each 'frame' contains just one field */
-#define V4L2_FWHT_FL_IS_ALTERNATE		BIT(2)
+#define V4L2_FWHT_FL_IS_ALTERNATE		_BITUL(2)
 /*
  * If V4L2_FWHT_FL_IS_ALTERNATE was set, then this is set if this
  * 'frame' is the bottom field, else it is the top field.
  */
-#define V4L2_FWHT_FL_IS_BOTTOM_FIELD		BIT(3)
+#define V4L2_FWHT_FL_IS_BOTTOM_FIELD		_BITUL(3)
 /* Set if the Y' plane is uncompressed */
-#define V4L2_FWHT_FL_LUMA_IS_UNCOMPRESSED	BIT(4)
+#define V4L2_FWHT_FL_LUMA_IS_UNCOMPRESSED	_BITUL(4)
 /* Set if the Cb plane is uncompressed */
-#define V4L2_FWHT_FL_CB_IS_UNCOMPRESSED		BIT(5)
+#define V4L2_FWHT_FL_CB_IS_UNCOMPRESSED		_BITUL(5)
 /* Set if the Cr plane is uncompressed */
-#define V4L2_FWHT_FL_CR_IS_UNCOMPRESSED		BIT(6)
+#define V4L2_FWHT_FL_CR_IS_UNCOMPRESSED		_BITUL(6)
 /* Set if the chroma plane is full height, if cleared it is half height */
-#define V4L2_FWHT_FL_CHROMA_FULL_HEIGHT		BIT(7)
+#define V4L2_FWHT_FL_CHROMA_FULL_HEIGHT		_BITUL(7)
 /* Set if the chroma plane is full width, if cleared it is half width */
-#define V4L2_FWHT_FL_CHROMA_FULL_WIDTH		BIT(8)
+#define V4L2_FWHT_FL_CHROMA_FULL_WIDTH		_BITUL(8)
 /* Set if the alpha plane is uncompressed */
-#define V4L2_FWHT_FL_ALPHA_IS_UNCOMPRESSED	BIT(9)
+#define V4L2_FWHT_FL_ALPHA_IS_UNCOMPRESSED	_BITUL(9)
 /* Set if this is an I Frame */
-#define V4L2_FWHT_FL_I_FRAME			BIT(10)
+#define V4L2_FWHT_FL_I_FRAME			_BITUL(10)
 
 /* A 4-values flag - the number of components - 1 */
 #define V4L2_FWHT_FL_COMPONENTS_NUM_MSK		GENMASK(18, 16)
-- 
2.31.1

