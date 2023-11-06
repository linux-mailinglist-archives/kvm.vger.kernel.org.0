Return-Path: <kvm+bounces-722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EBB77E1F9C
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:09:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D7E1B2313D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD0A51A72A;
	Mon,  6 Nov 2023 11:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s32bxmwS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C721A71D
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:09:44 +0000 (UTC)
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CA398
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:09:41 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c6ef6c1ec2so52813641fa.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268980; x=1699873780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iac5EYIzrukJRvlyPwy92lw3bSASiGn2WGuusjle2eY=;
        b=s32bxmwSxoYxfVA2bkchUQIgjX04xg8ge1hW1eCSIbn6lv3GIbNtYt/0W7ncdrsqig
         MCKYp5TF7Z62b+WzW5Tm7QqHNjybAQWpQp6sabBfZvwO1suupc8flxUminjJpvsii/zM
         XdzyQqyTzJrPKSfq/b7t5GEXFAKuJtzqrcZ01vFvJVXbiujTzWRB7+JRPA73IqzO8WTM
         x2B0RK0+QTd6CPiJ2fXmW7+1Q56GMgGxwds1XSE+juzjwOqOHHyaDeNmKeaLMF8qtpYG
         D/mv5DFS5NQ+UGLz2D0iOVclupT1N++2Z4bbti8kjqC9ttIPpJKHY2wDGcPl5iObtF07
         zkEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268980; x=1699873780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iac5EYIzrukJRvlyPwy92lw3bSASiGn2WGuusjle2eY=;
        b=lnkyhBYTID72+lbM1pQNL/deCpigiRcMBgxOADKz8fVg0avUPJFwxOFT4m4q57nPXt
         MvF2h9j/ctaaGlCmRJwZ9AmRRNZEUiqlHSbEA0Q4HVC4Sc++FWt9V+OF9R135GhnDqjN
         TlY7v3Bgv60Bf/yrqyCvBz/NFTByewqHsMVYAdrOl+QKNwxLscydUfCSGJRSWk1WZTXS
         mcaB86fNRoAzMyE4ZQ6NVsrQCMTp6pIs84dYcr+t+Mf1MoPwh5DAKUKoVVuFgit3p+C6
         Hng257YpT2IAn+F1xX8pJ9O94V7v/aD/pvQKcctQGocBhrwYPidCJ+PU9QvBbko0Izvi
         71cA==
X-Gm-Message-State: AOJu0YyyP1Km/6Ael8KhGFxAj8TiVFyYG9VPmG4RYozusp+kS1fa+X5N
	jaeh/xuxITxGMAGmOn/pO+JaMA==
X-Google-Smtp-Source: AGHT+IGtnXRrMjhzzRV0caLFucBfgjOr7PtrWkTJeCvHRsyO/ZH9DcpMWWGhJ2druMFWhmrbO+CNOw==
X-Received: by 2002:a05:651c:11d3:b0:2bc:b75e:b88 with SMTP id z19-20020a05651c11d300b002bcb75e0b88mr23964902ljo.18.1699268979795;
        Mon, 06 Nov 2023 03:09:39 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id ew3-20020a05600c808300b004054dcbf92asm11515737wmb.20.2023.11.06.03.09.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:09:39 -0800 (PST)
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
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Tyrone Ting <kfting@nuvoton.com>
Subject: [PULL 53/60] hw/sensor: add ADM1266 device model
Date: Mon,  6 Nov 2023 12:03:25 +0100
Message-ID: <20231106110336.358-54-philmd@linaro.org>
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

The ADM1266 is a cascadable super sequencer with margin control and
fault recording.
This commit adds basic support for its PMBus commands and models
the identification registers that can be modified in a firmware
update.

Reviewed-by: Hao Wu <wuhaotsh@google.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Titus Rwantare <titusr@google.com>
[PMD: Cover file in MAINTAINERS]
Message-ID: <20231023-staging-pmbus-v3-v4-5-07a8cb7cd20a@google.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 MAINTAINERS           |   1 +
 hw/sensor/adm1266.c   | 254 ++++++++++++++++++++++++++++++++++++++++++
 hw/arm/Kconfig        |   1 +
 hw/sensor/Kconfig     |   5 +
 hw/sensor/meson.build |   1 +
 5 files changed, 262 insertions(+)
 create mode 100644 hw/sensor/adm1266.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 126cddd285..e6a2f57442 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -859,6 +859,7 @@ M: Hao Wu <wuhaotsh@google.com>
 L: qemu-arm@nongnu.org
 S: Supported
 F: hw/*/npcm*
+F: hw/sensor/adm1266.c
 F: include/hw/*/npcm*
 F: tests/qtest/npcm*
 F: pc-bios/npcm7xx_bootrom.bin
diff --git a/hw/sensor/adm1266.c b/hw/sensor/adm1266.c
new file mode 100644
index 0000000000..5ae4f82ba1
--- /dev/null
+++ b/hw/sensor/adm1266.c
@@ -0,0 +1,254 @@
+/*
+ * Analog Devices ADM1266 Cascadable Super Sequencer with Margin Control and
+ * Fault Recording with PMBus
+ *
+ * https://www.analog.com/media/en/technical-documentation/data-sheets/adm1266.pdf
+ *
+ * Copyright 2023 Google LLC
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "hw/i2c/pmbus_device.h"
+#include "hw/irq.h"
+#include "migration/vmstate.h"
+#include "qapi/error.h"
+#include "qapi/visitor.h"
+#include "qemu/log.h"
+#include "qemu/module.h"
+
+#define TYPE_ADM1266 "adm1266"
+OBJECT_DECLARE_SIMPLE_TYPE(ADM1266State, ADM1266)
+
+#define ADM1266_BLACKBOX_CONFIG                 0xD3
+#define ADM1266_PDIO_CONFIG                     0xD4
+#define ADM1266_READ_STATE                      0xD9
+#define ADM1266_READ_BLACKBOX                   0xDE
+#define ADM1266_SET_RTC                         0xDF
+#define ADM1266_GPIO_SYNC_CONFIGURATION         0xE1
+#define ADM1266_BLACKBOX_INFORMATION            0xE6
+#define ADM1266_PDIO_STATUS                     0xE9
+#define ADM1266_GPIO_STATUS                     0xEA
+
+/* Defaults */
+#define ADM1266_OPERATION_DEFAULT               0x80
+#define ADM1266_CAPABILITY_DEFAULT              0xA0
+#define ADM1266_CAPABILITY_NO_PEC               0x20
+#define ADM1266_PMBUS_REVISION_DEFAULT          0x22
+#define ADM1266_MFR_ID_DEFAULT                  "ADI"
+#define ADM1266_MFR_ID_DEFAULT_LEN              32
+#define ADM1266_MFR_MODEL_DEFAULT               "ADM1266-A1"
+#define ADM1266_MFR_MODEL_DEFAULT_LEN           32
+#define ADM1266_MFR_REVISION_DEFAULT            "25"
+#define ADM1266_MFR_REVISION_DEFAULT_LEN        8
+
+#define ADM1266_NUM_PAGES               17
+/**
+ * PAGE Index
+ * Page 0 VH1.
+ * Page 1 VH2.
+ * Page 2 VH3.
+ * Page 3 VH4.
+ * Page 4 VP1.
+ * Page 5 VP2.
+ * Page 6 VP3.
+ * Page 7 VP4.
+ * Page 8 VP5.
+ * Page 9 VP6.
+ * Page 10 VP7.
+ * Page 11 VP8.
+ * Page 12 VP9.
+ * Page 13 VP10.
+ * Page 14 VP11.
+ * Page 15 VP12.
+ * Page 16 VP13.
+ */
+typedef struct ADM1266State {
+    PMBusDevice parent;
+
+    char mfr_id[32];
+    char mfr_model[32];
+    char mfr_rev[8];
+} ADM1266State;
+
+static const uint8_t adm1266_ic_device_id[] = {0x03, 0x41, 0x12, 0x66};
+static const uint8_t adm1266_ic_device_rev[] = {0x08, 0x01, 0x08, 0x07, 0x0,
+                                                0x0, 0x07, 0x41, 0x30};
+
+static void adm1266_exit_reset(Object *obj)
+{
+    ADM1266State *s = ADM1266(obj);
+    PMBusDevice *pmdev = PMBUS_DEVICE(obj);
+
+    pmdev->page = 0;
+    pmdev->capability = ADM1266_CAPABILITY_NO_PEC;
+
+    for (int i = 0; i < ADM1266_NUM_PAGES; i++) {
+        pmdev->pages[i].operation = ADM1266_OPERATION_DEFAULT;
+        pmdev->pages[i].revision = ADM1266_PMBUS_REVISION_DEFAULT;
+        pmdev->pages[i].vout_mode = 0;
+        pmdev->pages[i].read_vout = pmbus_data2linear_mode(12, 0);
+        pmdev->pages[i].vout_margin_high = pmbus_data2linear_mode(15, 0);
+        pmdev->pages[i].vout_margin_low = pmbus_data2linear_mode(3, 0);
+        pmdev->pages[i].vout_ov_fault_limit = pmbus_data2linear_mode(16, 0);
+        pmdev->pages[i].revision = ADM1266_PMBUS_REVISION_DEFAULT;
+    }
+
+    strncpy(s->mfr_id, ADM1266_MFR_ID_DEFAULT, 4);
+    strncpy(s->mfr_model, ADM1266_MFR_MODEL_DEFAULT, 11);
+    strncpy(s->mfr_rev, ADM1266_MFR_REVISION_DEFAULT, 3);
+}
+
+static uint8_t adm1266_read_byte(PMBusDevice *pmdev)
+{
+    ADM1266State *s = ADM1266(pmdev);
+
+    switch (pmdev->code) {
+    case PMBUS_MFR_ID:                    /* R/W block */
+        pmbus_send_string(pmdev, s->mfr_id);
+        break;
+
+    case PMBUS_MFR_MODEL:                 /* R/W block */
+        pmbus_send_string(pmdev, s->mfr_model);
+        break;
+
+    case PMBUS_MFR_REVISION:              /* R/W block */
+        pmbus_send_string(pmdev, s->mfr_rev);
+        break;
+
+    case PMBUS_IC_DEVICE_ID:
+        pmbus_send(pmdev, adm1266_ic_device_id, sizeof(adm1266_ic_device_id));
+        break;
+
+    case PMBUS_IC_DEVICE_REV:
+        pmbus_send(pmdev, adm1266_ic_device_rev, sizeof(adm1266_ic_device_rev));
+        break;
+
+    default:
+        qemu_log_mask(LOG_UNIMP,
+                      "%s: reading from unimplemented register: 0x%02x\n",
+                      __func__, pmdev->code);
+        return 0xFF;
+    }
+
+    return 0;
+}
+
+static int adm1266_write_data(PMBusDevice *pmdev, const uint8_t *buf,
+                              uint8_t len)
+{
+    ADM1266State *s = ADM1266(pmdev);
+
+    switch (pmdev->code) {
+    case PMBUS_MFR_ID:                    /* R/W block */
+        pmbus_receive_block(pmdev, (uint8_t *)s->mfr_id, sizeof(s->mfr_id));
+        break;
+
+    case PMBUS_MFR_MODEL:                 /* R/W block */
+        pmbus_receive_block(pmdev, (uint8_t *)s->mfr_model,
+                            sizeof(s->mfr_model));
+        break;
+
+    case PMBUS_MFR_REVISION:               /* R/W block*/
+        pmbus_receive_block(pmdev, (uint8_t *)s->mfr_rev, sizeof(s->mfr_rev));
+        break;
+
+    case ADM1266_SET_RTC:   /* do nothing */
+        break;
+
+    default:
+        qemu_log_mask(LOG_UNIMP,
+                      "%s: writing to unimplemented register: 0x%02x\n",
+                      __func__, pmdev->code);
+        break;
+    }
+    return 0;
+}
+
+static void adm1266_get(Object *obj, Visitor *v, const char *name, void *opaque,
+                        Error **errp)
+{
+    uint16_t value;
+    PMBusDevice *pmdev = PMBUS_DEVICE(obj);
+    PMBusVoutMode *mode = (PMBusVoutMode *)&pmdev->pages[0].vout_mode;
+
+    if (strcmp(name, "vout") == 0) {
+        value = pmbus_linear_mode2data(*(uint16_t *)opaque, mode->exp);
+    } else {
+        value = *(uint16_t *)opaque;
+    }
+
+    visit_type_uint16(v, name, &value, errp);
+}
+
+static void adm1266_set(Object *obj, Visitor *v, const char *name, void *opaque,
+                        Error **errp)
+{
+    uint16_t *internal = opaque;
+    uint16_t value;
+    PMBusDevice *pmdev = PMBUS_DEVICE(obj);
+    PMBusVoutMode *mode = (PMBusVoutMode *)&pmdev->pages[0].vout_mode;
+
+    if (!visit_type_uint16(v, name, &value, errp)) {
+        return;
+    }
+
+    *internal = pmbus_data2linear_mode(value, mode->exp);
+    pmbus_check_limits(pmdev);
+}
+
+static const VMStateDescription vmstate_adm1266 = {
+    .name = "ADM1266",
+    .version_id = 0,
+    .minimum_version_id = 0,
+    .fields = (VMStateField[]){
+        VMSTATE_PMBUS_DEVICE(parent, ADM1266State),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
+static void adm1266_init(Object *obj)
+{
+    PMBusDevice *pmdev = PMBUS_DEVICE(obj);
+    uint64_t flags = PB_HAS_VOUT_MODE | PB_HAS_VOUT | PB_HAS_VOUT_MARGIN |
+                     PB_HAS_VOUT_RATING | PB_HAS_STATUS_MFR_SPECIFIC;
+
+    for (int i = 0; i < ADM1266_NUM_PAGES; i++) {
+        pmbus_page_config(pmdev, i, flags);
+
+        object_property_add(obj, "vout[*]", "uint16",
+                            adm1266_get,
+                            adm1266_set, NULL, &pmdev->pages[i].read_vout);
+    }
+}
+
+static void adm1266_class_init(ObjectClass *klass, void *data)
+{
+    ResettableClass *rc = RESETTABLE_CLASS(klass);
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    PMBusDeviceClass *k = PMBUS_DEVICE_CLASS(klass);
+
+    dc->desc = "Analog Devices ADM1266 Hot Swap controller";
+    dc->vmsd = &vmstate_adm1266;
+    k->write_data = adm1266_write_data;
+    k->receive_byte = adm1266_read_byte;
+    k->device_num_pages = 17;
+
+    rc->phases.exit = adm1266_exit_reset;
+}
+
+static const TypeInfo adm1266_info = {
+    .name = TYPE_ADM1266,
+    .parent = TYPE_PMBUS_DEVICE,
+    .instance_size = sizeof(ADM1266State),
+    .instance_init = adm1266_init,
+    .class_init = adm1266_class_init,
+};
+
+static void adm1266_register_types(void)
+{
+    type_register_static(&adm1266_info);
+}
+
+type_init(adm1266_register_types)
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index e35007ed41..0f22aee24b 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -489,6 +489,7 @@ config NPCM7XX
     default y
     depends on TCG && ARM
     select A9MPCORE
+    select ADM1266
     select ADM1272
     select ARM_GIC
     select SMBUS
diff --git a/hw/sensor/Kconfig b/hw/sensor/Kconfig
index e03bd09b50..bc6331b4ab 100644
--- a/hw/sensor/Kconfig
+++ b/hw/sensor/Kconfig
@@ -22,6 +22,11 @@ config ADM1272
     bool
     depends on I2C
 
+config ADM1266
+    bool
+    depends on PMBUS
+    default y if PMBUS
+
 config MAX34451
     bool
     depends on I2C
diff --git a/hw/sensor/meson.build b/hw/sensor/meson.build
index 30e20e27b8..420fdc3359 100644
--- a/hw/sensor/meson.build
+++ b/hw/sensor/meson.build
@@ -2,6 +2,7 @@ system_ss.add(when: 'CONFIG_TMP105', if_true: files('tmp105.c'))
 system_ss.add(when: 'CONFIG_TMP421', if_true: files('tmp421.c'))
 system_ss.add(when: 'CONFIG_DPS310', if_true: files('dps310.c'))
 system_ss.add(when: 'CONFIG_EMC141X', if_true: files('emc141x.c'))
+system_ss.add(when: 'CONFIG_ADM1266', if_true: files('adm1266.c'))
 system_ss.add(when: 'CONFIG_ADM1272', if_true: files('adm1272.c'))
 system_ss.add(when: 'CONFIG_MAX34451', if_true: files('max34451.c'))
 system_ss.add(when: 'CONFIG_LSM303DLHC_MAG', if_true: files('lsm303dlhc_mag.c'))
-- 
2.41.0


