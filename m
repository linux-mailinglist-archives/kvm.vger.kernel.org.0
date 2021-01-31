Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86B1309C55
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 14:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhAaNa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 08:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhAaLwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:52:14 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988BBC061793
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:50:43 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id g10so13507481wrx.1
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fh28JukriQ8n71FXrOcLQmLKpZgUpaavJogE1lG2lKE=;
        b=V9jvv1aL3pv839Xy1/0k6WXm66MH9MuJ++7EvsG8qCa8S/wu6yqaRlsHWM/6QNB9nq
         otF67bI38HB/w9Q6MYBXxVOV5UBCfzchBKzB7qzo23tC+CtVSDEiuDhSZgH2dTnQIoYd
         6joAcsNUIBk61d62T+9j0tEWV0NdSA6ytJkUxnBG0i3S908YNLWEon8evQ47X9B2sLl4
         nYV4yaQ2owvFrejRRcFu4R05XEV7WMKV9GrqyrPq04KqW0pgCUzJ6KMZIWHx1H0HXq9X
         d3lwh952RSMVU6+mG+0RM+tLEOoLrQ673P9FK4aAUMuTDxUGUjXBbhRSvwjSbsfKJ1+J
         eQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=fh28JukriQ8n71FXrOcLQmLKpZgUpaavJogE1lG2lKE=;
        b=uc5C/oEg6bdbMsE5XMIWg6LNT6G66/86Hm9lskh/QJ7eQt8ZdfeKguJJ0uX4eDAFWe
         bWlxmom/O4et8xwn2G9I90mJljbJ+C1R3+myfhz8SD97BzecAQCpjgCyXiPNVCjW62N1
         M6v0x+fMtncNom3+XI+enHnOk2PIJx3DnUKe8FBEqvblluQEh1A8jB4IGYZv+qiWzdBg
         uKFvvZTPXgkt/9ZU7YGf3LxqSzNG1vKZODLMR1Y+YC0Xzx65r5uST7O7P59JdjPMIqsj
         ++LxQGXY2AKcB4R9k3A4PBK33UpuS6pON4+92z3ksRBkEfgHHDpxxQ2m96GKNRCQAJgL
         nNPA==
X-Gm-Message-State: AOAM531JxmnzBK+YNYUZlJ8yl4XdI26GvQobYSjrYnWHWsI/kgXREBmS
        uN6gZhKFbOX5fFwhbbWAZg4=
X-Google-Smtp-Source: ABdhPJzPZYCyk9Lid3tGRWhj4ZiT3g9tiJCZJewZhjiHAEXNm3DGC368mGAO4xLutOTTbFfAQmbXoQ==
X-Received: by 2002:adf:f303:: with SMTP id i3mr13248696wro.60.1612093842413;
        Sun, 31 Jan 2021 03:50:42 -0800 (PST)
Received: from localhost.localdomain (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id c18sm27536097wmk.0.2021.01.31.03.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 03:50:41 -0800 (PST)
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
Subject: [PATCH v6 03/11] target/arm: Restrict ARMv4 cpus to TCG accel
Date:   Sun, 31 Jan 2021 12:50:14 +0100
Message-Id: <20210131115022.242570-4-f4bug@amsat.org>
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

Only enable the following ARMv4 CPUs when TCG is available:

  - StrongARM (SA1100/1110)
  - OMAP1510 (TI925T)

The following machines are no more built when TCG is disabled:

  - cheetah              Palm Tungsten|E aka. Cheetah PDA (OMAP310)
  - sx1                  Siemens SX1 (OMAP310) V2
  - sx1-v1               Siemens SX1 (OMAP310) V1

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 default-configs/devices/arm-softmmu.mak | 2 --
 hw/arm/Kconfig                          | 4 ++++
 target/arm/Kconfig                      | 4 ++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
index 0824e9be795..6ae964c14fd 100644
--- a/default-configs/devices/arm-softmmu.mak
+++ b/default-configs/devices/arm-softmmu.mak
@@ -14,8 +14,6 @@ CONFIG_INTEGRATOR=y
 CONFIG_FSL_IMX31=y
 CONFIG_MUSICPAL=y
 CONFIG_MUSCA=y
-CONFIG_CHEETAH=y
-CONFIG_SX1=y
 CONFIG_NSERIES=y
 CONFIG_STELLARIS=y
 CONFIG_REALVIEW=y
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index f3ecb73a3d8..f2957b33bee 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -31,6 +31,8 @@ config ARM_VIRT
 
 config CHEETAH
     bool
+    default y if TCG && ARM
+    select ARM_V4
     select OMAP
     select TSC210X
 
@@ -249,6 +251,8 @@ config COLLIE
 
 config SX1
     bool
+    default y if TCG && ARM
+    select ARM_V4
     select OMAP
 
 config VERSATILE
diff --git a/target/arm/Kconfig b/target/arm/Kconfig
index ae89d05c7e5..811e1e81652 100644
--- a/target/arm/Kconfig
+++ b/target/arm/Kconfig
@@ -6,6 +6,10 @@ config AARCH64
     bool
     select ARM
 
+config ARM_V4
+    bool
+    depends on TCG && ARM
+
 config ARM_V7M
     bool
     select PTIMER
-- 
2.26.2

