Return-Path: <kvm+bounces-721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 329BF7E1F9A
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:09:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 630A71C20BAD
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 514181A705;
	Mon,  6 Nov 2023 11:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W3apIab0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3821A5A4
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:09:36 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99590BB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:09:34 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-32f737deedfso2644292f8f.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268973; x=1699873773; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3MW0tyH68/nf1rlEHwZAluKpdYAi9tPVuWOS5/QAWBA=;
        b=W3apIab0xrpXHVy4DY6TRVOPSjSpbTFoaqxbeJcsG1CGBEvtcAg2pU1lrNnp7FezNS
         lzmjwpxsmTIHsDN0A0ZDf6oTZZhkYQNHuNYC/LkR4csO7x1OXyUZq90tLDByXxIDO8GE
         2X7JYtlTEmcgLawMkNqmt5Oi0iKKlmRUnEOdWfuQ4nk8GV+u3zIFYQz+QZhfVqAJTcL5
         lFPnsjNUPuLXm7ikAgcyONYGW+XiHSjycoycqaIUCslPI0CV00qj06uMp9w5R517nvRX
         2ku0YWqmLs5tchhbwVAp+flFj/J2lCVcegJRgc2LhOLZEjZGDx48e7uPf62bnn0rQ0OK
         34pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268973; x=1699873773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MW0tyH68/nf1rlEHwZAluKpdYAi9tPVuWOS5/QAWBA=;
        b=gqdkJvFKvK/mTHa590BNF3wRVddfFrgfyFTVvQH1GRvW5LP28W76J5j0hOPTWmI0jU
         w2w5/6yI1H6EujLGYq5JPMukU9Oj+H0gf/SIFNW1Lhh588xuSV393cGgL11PMj18QN9y
         hDJSZhZnLZcGC92j6ZdhLYVj3aX8XD3IQW/Fv4GDgA04YuljHhdpl9EsFcJwbAcbmwbI
         h6pEDKu/I35BXrnYEHeyRtOB9a+mLq+Rk0uG1orJ6nBx+wglxTp01uL+Dq7ce1cXPqNE
         gxEDFSOo1uCu0g1POex0A/ItlDsgJURZmxuBhJFrm4Wu8zMRxXnIG3iVSGxdDaSctx+W
         6e6A==
X-Gm-Message-State: AOJu0YxBvq5Hhs7GLs6ZlQzzf5Ng696Td/xB4WgAPNDs7CcCzzvJrpKS
	BBNL2t5Ycb6hVk0PzBTZPwU93g==
X-Google-Smtp-Source: AGHT+IHCaN+scNB/M2tnE4QgncjJleh2dLiQpvtBfLxKZsjTqp14NEV1WX9EdfcpHqTpyU/QLx/+rg==
X-Received: by 2002:a05:6000:2c5:b0:32f:7ae2:4165 with SMTP id o5-20020a05600002c500b0032f7ae24165mr27652837wry.9.1699268972999;
        Mon, 06 Nov 2023 03:09:32 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id y8-20020a5d4708000000b0032d2f09d991sm9141944wrq.33.2023.11.06.03.09.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:09:32 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Titus Rwantare <titusr@google.com>,
	Benjamin Streb <bstreb@google.com>,
	Corey Minyard <cminyard@mvista.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PULL 52/60] hw/i2c: pmbus: add VCAP register
Date: Mon,  6 Nov 2023 12:03:24 +0100
Message-ID: <20231106110336.358-53-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106110336.358-1-philmd@linaro.org>
References: <20231106110336.358-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Titus Rwantare <titusr@google.com>

VCAP is a register for devices with energy storage capacitors.

Reviewed-by: Benjamin Streb <bstreb@google.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Titus Rwantare <titusr@google.com>
Message-ID: <20231023-staging-pmbus-v3-v4-4-07a8cb7cd20a@google.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/i2c/pmbus_device.h | 1 +
 hw/i2c/pmbus_device.c         | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/hw/i2c/pmbus_device.h b/include/hw/i2c/pmbus_device.h
index ad431bdc7c..f195c11384 100644
--- a/include/hw/i2c/pmbus_device.h
+++ b/include/hw/i2c/pmbus_device.h
@@ -243,6 +243,7 @@ OBJECT_DECLARE_TYPE(PMBusDevice, PMBusDeviceClass,
 #define PB_HAS_VIN_RATING          BIT_ULL(13)
 #define PB_HAS_VOUT_RATING         BIT_ULL(14)
 #define PB_HAS_VOUT_MODE           BIT_ULL(15)
+#define PB_HAS_VCAP                BIT_ULL(16)
 #define PB_HAS_IOUT                BIT_ULL(21)
 #define PB_HAS_IIN                 BIT_ULL(22)
 #define PB_HAS_IOUT_RATING         BIT_ULL(23)
diff --git a/hw/i2c/pmbus_device.c b/hw/i2c/pmbus_device.c
index c1d8c93056..3bce39e84e 100644
--- a/hw/i2c/pmbus_device.c
+++ b/hw/i2c/pmbus_device.c
@@ -906,6 +906,14 @@ static uint8_t pmbus_receive_byte(SMBusDevice *smd)
         }
         break;
 
+    case PMBUS_READ_VCAP:                 /* Read-Only word */
+        if (pmdev->pages[index].page_flags & PB_HAS_VCAP) {
+            pmbus_send16(pmdev, pmdev->pages[index].read_vcap);
+        } else {
+            goto passthough;
+        }
+        break;
+
     case PMBUS_READ_VOUT:                 /* Read-Only word */
         if (pmdev->pages[index].page_flags & PB_HAS_VOUT) {
             pmbus_send16(pmdev, pmdev->pages[index].read_vout);
-- 
2.41.0


