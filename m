Return-Path: <kvm+bounces-718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB69E7E1F93
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18D871C20BFF
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC841A735;
	Mon,  6 Nov 2023 11:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TH8UyjV/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495C21A708
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:09:16 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095BBDB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:09:15 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-32db188e254so2655319f8f.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268953; x=1699873753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gh2da5PI+FWVTGRmyCu8rnn16q3Vdl/J/DOzB/U83Dc=;
        b=TH8UyjV/8lCS4aHRZiXTzO21dnKP0scR73v6DFF/nNcOlurSUO4s/85jxqYA/x2eVn
         EVSfr+9UI0QQZ6i8J3iJ+oMXllmiYvYuO1Hg1k/TGRz92D1cxUFFP/1HNSh8n5v9PoMX
         T3XvobkSaPSf8Kc80Kh5Csc+WU/g8TvlKuW93/PdS3+Ge8brAAwEb8YZsEBENDN4zDb7
         1uY7enMwlIjmoXheY4UdcHEdlLJDr213kd56IDbsB5eBwrlMymicOoxA4sgJ+RtNasNC
         cX0qdA4Aa8poOKcnxnRoorO99gtBt43zUK7hJEF/nhocvJhaN4IlPqWs9XU1fD/N4+/M
         Eilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268953; x=1699873753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gh2da5PI+FWVTGRmyCu8rnn16q3Vdl/J/DOzB/U83Dc=;
        b=VCRDILJbRQCQPMHKcZGDqLve/cBKjh1L+kbfcITvP+v9MP+8Pz3GBd5vWJSQPX4ntD
         wYf1Gr5hCYKdbiROevI2dZCpMm8n3WKUOrqIk3PVmQLKDq+r0ozF3so02y2PFWm7eicp
         mqoRbn8RK8Z1JhoqkGO9iaqc6VIh1T7e7mvmFmqA6/ZIQXVIsEeyGSVn/h9ooU0Z7e3+
         5T5x9DIZyP1Mg+ux03vFHK6dhE8ESqFqZQuXCmz7PZe0z+xpk1Zk+5wEuGFeyykRzRze
         q43uz4TeiNJgR0RGuAUTfjG39sZBeiIfpMzjFLMfk/uHbTr4vX7A2D33RZQN7yu1EmLA
         zgLQ==
X-Gm-Message-State: AOJu0YzvKBYyyz08W8+GlB895Wkg1YCCfHlZj8aUCOfyBBbCLbzOrP/W
	qTPqgX2Zcp0JuN9FN91svgzonA==
X-Google-Smtp-Source: AGHT+IEhelvYuVMEs34Z0aXzBUC/ehzDXNQDAvKbf9n6MtiLZ1bFBIXsaS/OCjeLNPDbQR8d540Asw==
X-Received: by 2002:a5d:5a06:0:b0:32d:a101:689d with SMTP id bq6-20020a5d5a06000000b0032da101689dmr35272735wrb.56.1699268953327;
        Mon, 06 Nov 2023 03:09:13 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id j17-20020a056000125100b0032db4e660d9sm9181558wrx.56.2023.11.06.03.09.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:09:12 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Titus Rwantare <titusr@google.com>,
	Hao Wu <wuhaotsh@google.com>,
	Corey Minyard <cminyard@mvista.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PULL 49/60] hw/i2c: pmbus add support for block receive
Date: Mon,  6 Nov 2023 12:03:21 +0100
Message-ID: <20231106110336.358-50-philmd@linaro.org>
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

PMBus devices can send and receive variable length data using the
block read and write format, with the first byte in the payload
denoting the length.

This is mostly used for strings and on-device logs. Devices can
respond to a block read with an empty string.

Reviewed-by: Hao Wu <wuhaotsh@google.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Titus Rwantare <titusr@google.com>
Message-ID: <20231023-staging-pmbus-v3-v4-1-07a8cb7cd20a@google.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/i2c/pmbus_device.h |  7 +++++++
 hw/i2c/pmbus_device.c         | 30 +++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/hw/i2c/pmbus_device.h b/include/hw/i2c/pmbus_device.h
index 93f5d57c9d..7dc00cc4d9 100644
--- a/include/hw/i2c/pmbus_device.h
+++ b/include/hw/i2c/pmbus_device.h
@@ -501,6 +501,13 @@ void pmbus_send64(PMBusDevice *state, uint64_t data);
  */
 void pmbus_send_string(PMBusDevice *state, const char *data);
 
+/**
+ * @brief Receive data sent with Block Write.
+ * @param dest - memory with enough capacity to receive the write
+ * @param len - the capacity of dest
+ */
+uint8_t pmbus_receive_block(PMBusDevice *pmdev, uint8_t *dest, size_t len);
+
 /**
  * @brief Receive data over PMBus
  * These methods help track how much data is being received over PMBus
diff --git a/hw/i2c/pmbus_device.c b/hw/i2c/pmbus_device.c
index cef51663d0..ea15490720 100644
--- a/hw/i2c/pmbus_device.c
+++ b/hw/i2c/pmbus_device.c
@@ -102,7 +102,6 @@ void pmbus_send_string(PMBusDevice *pmdev, const char *data)
     }
 
     size_t len = strlen(data);
-    g_assert(len > 0);
     g_assert(len + pmdev->out_buf_len < SMBUS_DATA_MAX_LEN);
     pmdev->out_buf[len + pmdev->out_buf_len] = len;
 
@@ -112,6 +111,35 @@ void pmbus_send_string(PMBusDevice *pmdev, const char *data)
     pmdev->out_buf_len += len + 1;
 }
 
+uint8_t pmbus_receive_block(PMBusDevice *pmdev, uint8_t *dest, size_t len)
+{
+    /* dest may contain data from previous writes */
+    memset(dest, 0, len);
+
+    /* Exclude command code from return value */
+    pmdev->in_buf++;
+    pmdev->in_buf_len--;
+
+    /* The byte after the command code denotes the length */
+    uint8_t sent_len = pmdev->in_buf[0];
+
+    if (sent_len != pmdev->in_buf_len - 1) {
+        qemu_log_mask(LOG_GUEST_ERROR,
+                      "%s: length mismatch. Expected %d bytes, got %d bytes\n",
+                      __func__, sent_len, pmdev->in_buf_len - 1);
+    }
+
+    /* exclude length byte */
+    pmdev->in_buf++;
+    pmdev->in_buf_len--;
+
+    if (pmdev->in_buf_len < len) {
+        len = pmdev->in_buf_len;
+    }
+    memcpy(dest, pmdev->in_buf, len);
+    return len;
+}
+
 
 static uint64_t pmbus_receive_uint(PMBusDevice *pmdev)
 {
-- 
2.41.0


