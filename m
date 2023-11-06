Return-Path: <kvm+bounces-725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D18AB7E1F9F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:10:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2BF41C20ACB
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432D01EB31;
	Mon,  6 Nov 2023 11:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MMtJICmw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCAA1EB36
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:10:03 +0000 (UTC)
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44437A3
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:10:01 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2c6efcef4eeso52292941fa.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268999; x=1699873799; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGUqOvUDBSiuVjcJL6HNGd3FosLBI9RMurHd3wgpnc0=;
        b=MMtJICmw8xZsbWMl95HK0UcTLUBTOMOKhw9r9EwYdG1y5PvVKXwg0Hb4acJYG3/Xza
         xXkxXG1BWeC/V+GvA5Df0ZE7BR8kKQ8v/iGi+HudFnpZEuxNQspAWKbsaS2kUNOxISiZ
         mY4ATkzBVETelURQuBDZvjsQZw0OjdcOhwgQ9vUPM84ggBHs0bFTrKDZcMlzS7n4Xw49
         P1h9dzAOA6N/l3nUxWK1C3AWK/TYba7fTwZ1m0fIqbkeDOTy8rRsS4+WS6wgI4T++0xD
         ijJQHCJJa1PXBx2090j21prbJsPvYSV3/XOHF6NxelSWL/5Vjp/jrjjdPfo9nd+qbQva
         XuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268999; x=1699873799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGUqOvUDBSiuVjcJL6HNGd3FosLBI9RMurHd3wgpnc0=;
        b=T1ZDbZNnYE/MvevPnK2ntSmTt1mjYtAh6QhbVxjXYNfMtiifa64xOXsSwJ73MiY9qK
         VZaK378cdi8oewYk3yKSEU9VTNQ73mLOWAr1R4BPz8DZuu2vnHHR+ymB/hbCyScEtyBt
         m06BTscPA8/OImuRmx7iO80eHwwGv6JHz1d1Fp9ZPKBfbo/vT2ROPkN/EkBIuKe4SJ+t
         f6C/DHADUgS/+cKAerm71TJpFwVpUE5PAzbDSVoXnuE2JGCEIF7QjVSvPuj8WqJ2CoUH
         JeseNEK2y2kYaYAo4Oep7mnZ979xigxM9xqLXxFzbOShXL3XGOV/VHHiNJBlSIpcFk1g
         SbaA==
X-Gm-Message-State: AOJu0Yz0sN7Yu/JXbn6VGXSHahEnjtOcmwPmQDAE/NFYXGXwGxzkCGHb
	NPJROsnm7XEE0b7l7EXozTrXkA==
X-Google-Smtp-Source: AGHT+IFzu+WNTNvikEhT3RfrTXgUYqfUsIePLUoFbNzyRmjcJbd74z4iaBvydg4KqQIGnFcZE2qYAg==
X-Received: by 2002:a2e:8719:0:b0:2c5:1075:5ec9 with SMTP id m25-20020a2e8719000000b002c510755ec9mr21956567lji.13.1699268999654;
        Mon, 06 Nov 2023 03:09:59 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b0040596352951sm11684422wmq.5.2023.11.06.03.09.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:09:59 -0800 (PST)
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
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PULL 56/60] hw/i2c: pmbus: reset page register for out of range reads
Date: Mon,  6 Nov 2023 12:03:28 +0100
Message-ID: <20231106110336.358-57-philmd@linaro.org>
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

The linux pmbus driver scans all possible pages and does not reset the
current page after the scan, making all future page reads fail as out of range
on devices with a single page.

This change resets out of range pages immediately on write.

Also added a qtest for simultaneous writes to all pages.

Reviewed-by: Hao Wu <wuhaotsh@google.com>
Signed-off-by: Titus Rwantare <titusr@google.com>
Message-ID: <20231023-staging-pmbus-v3-v4-8-07a8cb7cd20a@google.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i2c/pmbus_device.c       | 18 +++++++++---------
 tests/qtest/max34451-test.c | 24 ++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/hw/i2c/pmbus_device.c b/hw/i2c/pmbus_device.c
index 481e158380..1b978e588f 100644
--- a/hw/i2c/pmbus_device.c
+++ b/hw/i2c/pmbus_device.c
@@ -1255,6 +1255,15 @@ static int pmbus_write_data(SMBusDevice *smd, uint8_t *buf, uint8_t len)
 
     if (pmdev->code == PMBUS_PAGE) {
         pmdev->page = pmbus_receive8(pmdev);
+
+        if (pmdev->page > pmdev->num_pages - 1 && pmdev->page != PB_ALL_PAGES) {
+            qemu_log_mask(LOG_GUEST_ERROR,
+                          "%s: page %u is out of range\n",
+                          __func__, pmdev->page);
+            pmdev->page = 0; /* undefined behaviour - reset to page 0 */
+            pmbus_cml_error(pmdev);
+            return PMBUS_ERR_BYTE;
+        }
         return 0;
     }
 
@@ -1268,15 +1277,6 @@ static int pmbus_write_data(SMBusDevice *smd, uint8_t *buf, uint8_t len)
         return 0;
     }
 
-    if (pmdev->page > pmdev->num_pages - 1) {
-        qemu_log_mask(LOG_GUEST_ERROR,
-                        "%s: page %u is out of range\n",
-                        __func__, pmdev->page);
-        pmdev->page = 0; /* undefined behaviour - reset to page 0 */
-        pmbus_cml_error(pmdev);
-        return PMBUS_ERR_BYTE;
-    }
-
     index = pmdev->page;
 
     switch (pmdev->code) {
diff --git a/tests/qtest/max34451-test.c b/tests/qtest/max34451-test.c
index 0c98d0764c..dbf6ddc829 100644
--- a/tests/qtest/max34451-test.c
+++ b/tests/qtest/max34451-test.c
@@ -18,6 +18,7 @@
 #define TEST_ID "max34451-test"
 #define TEST_ADDR (0x4e)
 
+#define MAX34451_MFR_MODE               0xD1
 #define MAX34451_MFR_VOUT_PEAK          0xD4
 #define MAX34451_MFR_IOUT_PEAK          0xD5
 #define MAX34451_MFR_TEMPERATURE_PEAK   0xD6
@@ -315,6 +316,28 @@ static void test_ot_faults(void *obj, void *data, QGuestAllocator *alloc)
     }
 }
 
+#define RAND_ON_OFF_CONFIG  0x12
+#define RAND_MFR_MODE       0x3456
+
+/* test writes to all pages */
+static void test_all_pages(void *obj, void *data, QGuestAllocator *alloc)
+{
+    uint16_t i2c_value;
+    QI2CDevice *i2cdev = (QI2CDevice *)obj;
+
+    i2c_set8(i2cdev, PMBUS_PAGE, PB_ALL_PAGES);
+    i2c_set8(i2cdev, PMBUS_ON_OFF_CONFIG, RAND_ON_OFF_CONFIG);
+    max34451_i2c_set16(i2cdev, MAX34451_MFR_MODE, RAND_MFR_MODE);
+
+    for (int i = 0; i < MAX34451_NUM_TEMP_DEVICES + MAX34451_NUM_PWR_DEVICES;
+         i++) {
+        i2c_value = i2c_get8(i2cdev, PMBUS_ON_OFF_CONFIG);
+        g_assert_cmphex(i2c_value, ==, RAND_ON_OFF_CONFIG);
+        i2c_value = max34451_i2c_get16(i2cdev, MAX34451_MFR_MODE);
+        g_assert_cmphex(i2c_value, ==, RAND_MFR_MODE);
+    }
+}
+
 static void max34451_register_nodes(void)
 {
     QOSGraphEdgeOptions opts = {
@@ -332,5 +355,6 @@ static void max34451_register_nodes(void)
     qos_add_test("test_ro_regs", "max34451", test_ro_regs, NULL);
     qos_add_test("test_ov_faults", "max34451", test_ov_faults, NULL);
     qos_add_test("test_ot_faults", "max34451", test_ot_faults, NULL);
+    qos_add_test("test_all_pages", "max34451", test_all_pages, NULL);
 }
 libqos_init(max34451_register_nodes);
-- 
2.41.0


