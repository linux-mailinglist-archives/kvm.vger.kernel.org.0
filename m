Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A91309BD8
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 13:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhAaL6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 06:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhAaLxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:53:52 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2B2C061756
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:51:00 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id i9so10771703wmq.1
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=55M93vKE1ahVgefWyZvIGcKvoJvAwdKqopFIoeHKkkA=;
        b=freBR3tIPtKMjI2+MuKbji7ZAmhWoqg3OKGAyKpW5xTZpNL67hf8t/x55QZPJTsMKz
         yEgpK6BA74aoPJ3neWrEuMTCkKXHqYvDm8EEuhQyQq+J9Qdipr6EZ9TB9ia301pTOoz9
         vv9A7BlPEvFHTRQ3M8w0tWlUePeXhLMgnZjd3JfMdtm30/IKP2UnSGsQS5fQkz5uSsxt
         ceUquXDjHUU1rTo7hKFajd/mUnA7Mi6K/dt+TtlgJYUl86XLQH7/EFyjqFqD7mwzCzQ0
         iT9EJe0qFQ90dsHDB1V8YvULyo5X3sBy5qnHmUGWDwe8TzgD3Z9yRx6ltBfOJRZHPZow
         zY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=55M93vKE1ahVgefWyZvIGcKvoJvAwdKqopFIoeHKkkA=;
        b=RYdO4E7bWXH6xfHtiCF9pEQZbhBjWgyXBySN4jsklz5CMuLpibAK9T67kECiY0gE8+
         49Y9tqMtSEMdJst2b95+BMvMVff+kzHTeeQdi4kyGfPQFBy1NELEXrWS22W1s6S/ehQd
         i2YRFFs0vgE6bwx7P6DfxcrZ7vSV4lzsvF8NpxrhUQrKu+DSJ/qdN+b+ejLWQ+Wr6mXP
         L8ua1B84WOvd8g0YQw72ILJmc1u5t7bScGYWfpPMd6a22BnL4FLnutTcuqycRrFBWMmu
         uJSIE7ek+GmzQmLHNliX6m5omQ/QSiyAFNv9mOYstL0CaHoEclTLJBECAx6CZjslemRd
         W+Zw==
X-Gm-Message-State: AOAM530XI2MpMYHS8R5fnzyaKxDiZw3SLZMRWqpYJ0RnsCNa/lA9Ji1G
        c0pEmpaprbKb6P394RPbihs=
X-Google-Smtp-Source: ABdhPJwJ9hes8lhe7OgVqiDeXshE4pGmaMbjuBMuK73ScXw3dz3Zg0MEOl283XRP7LZaLbEaQLBqZA==
X-Received: by 2002:a1c:a406:: with SMTP id n6mr10935564wme.53.1612093858925;
        Sun, 31 Jan 2021 03:50:58 -0800 (PST)
Received: from localhost.localdomain (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id u5sm18602187wmg.9.2021.01.31.03.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 03:50:58 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v6 06/11] target/arm: Restrict ARMv7 R-profile cpus to TCG accel
Date:   Sun, 31 Jan 2021 12:50:17 +0100
Message-Id: <20210131115022.242570-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210131115022.242570-1-f4bug@amsat.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM requires the target cpu to be at least ARMv8 architecture
(support on ARMv7 has been dropped in commit 82bf7ae84ce:
"target/arm: Remove KVM support for 32-bit Arm hosts").

Beside, KVM only supports A-profile, thus won't be able to run
R-profile cpus.

Only enable the following ARMv7 R-Profile CPUs when TCG is available:

  - Cortex-R5
  - Cortex-R5F

The following machine is no more built when TCG is disabled:

  - xlnx-zcu102          Xilinx ZynqMP ZCU102 board with 4xA53s and 2xR5Fs

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 default-configs/devices/aarch64-softmmu.mak | 1 -
 hw/arm/Kconfig                              | 2 ++
 target/arm/Kconfig                          | 4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/default-configs/devices/aarch64-softmmu.mak b/default-configs/devices/aarch64-softmmu.mak
index 958b1e08e40..a4202f56817 100644
--- a/default-configs/devices/aarch64-softmmu.mak
+++ b/default-configs/devices/aarch64-softmmu.mak
@@ -3,6 +3,5 @@
 # We support all the 32 bit boards so need all their config
 include arm-softmmu.mak
 
-CONFIG_XLNX_ZYNQMP_ARM=y
 CONFIG_XLNX_VERSAL=y
 CONFIG_SBSA_REF=y
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index 6c4bce4d637..4baf1f97694 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -360,8 +360,10 @@ config STM32F405_SOC
 
 config XLNX_ZYNQMP_ARM
     bool
+    default y if TCG && ARM
     select AHCI
     select ARM_GIC
+    select ARM_V7R
     select CADENCE
     select DDC
     select DPCD
diff --git a/target/arm/Kconfig b/target/arm/Kconfig
index fbb7bba9018..4dc96c46520 100644
--- a/target/arm/Kconfig
+++ b/target/arm/Kconfig
@@ -18,6 +18,10 @@ config ARM_V6
     bool
     depends on TCG && ARM
 
+config ARM_V7R
+    bool
+    depends on TCG && ARM
+
 config ARM_V7M
     bool
     select PTIMER
-- 
2.26.2

