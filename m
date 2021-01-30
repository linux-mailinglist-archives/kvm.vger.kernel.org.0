Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA68309419
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 11:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhA3KL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 05:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbhA3Bye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 20:54:34 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B09C061788
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:02 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o10so7987918wmc.1
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g1KU5IE9TGCZM/lU61E2LYHQF94GVZ2sjp5LehjcIJU=;
        b=mFXWLnEV2J7F5vMWemzgA7H5rDlvI6++w0fS0CrZkpYvnv+K+N3XgEO3GKqwwuaANV
         d0g2d43AkRHBIhnX13fL4uJHnEss03yuMlReAv0aU0IicAz94GcfWh5K7Snxt8N8VR2K
         m2+R3VOFvTNVyzdmxAUUMMumOrI7WSHzLPeDPs3BE1Awvg7fhIjOEoY+KbEEZ3F+6VdF
         6FPqa4w4nqQkxvEZACD/7lmP+n2g0PSuWwn57rp18al9fjHH4i5rs8wkEYgX4/S1vteX
         co1K1JfSZCh937LeyFh7KfxD9XXT2OfA3b5Ooc/YPg83R/j8K/T+OOmAzvb9jg4OXvX5
         t53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=g1KU5IE9TGCZM/lU61E2LYHQF94GVZ2sjp5LehjcIJU=;
        b=VtDTRKVMMeq/SWbL1sEWbSWgHgmGX2PxH5Vp/dZ+5pufXT6nij6HCg2GZC7RtSjecB
         QR9UJXoKr4PJg5UwAafgTjStresCVKjakNaANDU5e8k+M9Iw9/oxOpkgljiewUHFRviZ
         dj5+UvhSb0dWllnXbL6S5OvGPtQKMQEzDrZG+qwfmVpq5qXzsfdy15kzoptimpcausk7
         IoZH4Uegkv9kR2k2h+AiktuVpuKEiwwTqO5DY1G9sCLt+QThirKOOmMYVZwC+BIJsRN2
         JP/cYTIv5lQIOkVRT0ZkyDUa24I9QehTMiQcXwkOceK2siBKHybSzb/HhAGK8WbZ1Ika
         Zv7Q==
X-Gm-Message-State: AOAM530lOWfO7ioil5Pzupx8rQyb7ROKaelCW2GC6Qy1BgCMmD8P5T3t
        AKjBrsUPSD+XKQr1IxGonPo=
X-Google-Smtp-Source: ABdhPJyA4Coz/8piVvaPk4EIcoOTmtcPznXjAqGGyUN4FELubBKdNdl58zv0jN7k1O/K2eCj4Luk0Q==
X-Received: by 2002:a1c:b78b:: with SMTP id h133mr6103963wmf.151.1611971581368;
        Fri, 29 Jan 2021 17:53:01 -0800 (PST)
Received: from localhost.localdomain (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id w25sm12591514wmc.42.2021.01.29.17.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 17:53:00 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v5 06/11] target/arm: Restrict ARMv7 R-profile cpus to TCG accel
Date:   Sat, 30 Jan 2021 02:52:22 +0100
Message-Id: <20210130015227.4071332-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210130015227.4071332-1-f4bug@amsat.org>
References: <20210130015227.4071332-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A KVM-only build won't be able to run R-profile cpus.

Only enable the following ARMv7 R-Profile CPUs when TCG is available:

  - Cortex-R5
  - Cortex-R5F

The following machine is no more built when TCG is disabled:

  - xlnx-zcu102          Xilinx ZynqMP ZCU102 board with 4xA53s and 2xR5Fs

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 default-configs/devices/aarch64-softmmu.mak | 1 -
 hw/arm/Kconfig                              | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

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
index daab7081994..320428bf97e 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -11,6 +11,11 @@ config ARM_V6
     depends on TCG
     select ARM_COMPATIBLE_SEMIHOSTING
 
+config ARM_V7R
+    bool
+    depends on TCG
+    select ARM_COMPATIBLE_SEMIHOSTING
+
 config ARM_VIRT
     bool
     imply PCI_DEVICES
@@ -377,8 +382,10 @@ config STM32F405_SOC
 
 config XLNX_ZYNQMP_ARM
     bool
+    default y if TCG
     select AHCI
     select ARM_GIC
+    select ARM_V7R
     select CADENCE
     select DDC
     select DPCD
-- 
2.26.2

