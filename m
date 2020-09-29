Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EF227DC3A
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgI2Wof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729004AbgI2Wof (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:35 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i7QZwS1vfY6pxc/yL3I5YaiK5BX/yKl7ag6KjP4fakU=;
        b=O8udYsK7WOBMA9eh9Qqc5No52Atw3a0A6MIYo6jTxZx5e9rW51cZFDUhW9U+04yU3TuSdo
        Py7UnLlYayEqhDObTujQ0JkvoPVDM9Q7G6dM57TCNqnweTnYZommsu299ZdC8ZrNNLi8+2
        BlVOFh109f2rsdWlKEF70IKoOcFOvAE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-2OUza2cwMOiqxRLg0qE63A-1; Tue, 29 Sep 2020 18:44:29 -0400
X-MC-Unique: 2OUza2cwMOiqxRLg0qE63A-1
Received: by mail-wr1-f72.google.com with SMTP id w7so2370412wrp.2
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i7QZwS1vfY6pxc/yL3I5YaiK5BX/yKl7ag6KjP4fakU=;
        b=WluX6aPfdugSMCzo+6ENiW6Yo2XFEFCXCidWiT1TaVkfSgWnGwawYjWUYiqvr4/ycY
         iVizdSPcRzHX1c9dUlV0VdU9tKQHd4am3bsffTUSygN1BIJtowX9V+W7l/3M8ECi7pPj
         lCClFsAr4m/1CPnrIqNFaPv5MvakeoMik+04XM99usXkWXFXdvDtHIBkEaQ9WotAN8YG
         j5c2wyltrBGn5Ym97BzEVSS9L76zXtD+J/MvAWtQ2BMN4uGvTuLtj28kM0UHTZqtkGDd
         0YOTUSsrMOLo/tsIwcuQuf7jZHY/U8VZLuwyNkQYwTSGfIPiY6jhP1qvCpTqo8dxmNqQ
         zGDg==
X-Gm-Message-State: AOAM531DS0NCELjI3JItBeiBT9Ik5FBZCPDReUQWb+B27i9xugdD2MHq
        MaSX43dDiGboYFuLQGLfREbtitu5PVJNsmTQZn+uDz7JRGCojexyWO1QyOn2BsmzULi/4PlPUG/
        t6acO4OeO2cEP
X-Received: by 2002:adf:dcd1:: with SMTP id x17mr7104482wrm.150.1601419468593;
        Tue, 29 Sep 2020 15:44:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweTjjV4JKSEFC7bdGe1az/c9DKmrvmR/EC6wrTRHkRT+Xz0xLKGZVKIrTri3by7ejJMMBAyw==
X-Received: by 2002:adf:dcd1:: with SMTP id x17mr7104459wrm.150.1601419468383;
        Tue, 29 Sep 2020 15:44:28 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id j10sm7850036wrn.2.2020.09.29.15.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:27 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 06/12] target/arm: Restrict ARMv6 cpus to TCG accel
Date:   Wed, 30 Sep 2020 00:43:49 +0200
Message-Id: <20200929224355.1224017-7-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929224355.1224017-1-philmd@redhat.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM requires a cpu based on (at least) the ARMv7 architecture.

Only enable the following ARMv6 CPUs when TCG is available:

  - ARM1136
  - ARM1176
  - ARM11MPCore
  - Cortex-M0

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/arm/Kconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index d2876b2c8b..e01eb55bc0 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -6,6 +6,10 @@ config ARM_V5
     bool
     select TCG
 
+config ARM_V6
+    bool
+    select TCG
+
 config ARM_VIRT
     bool
     imply PCI_DEVICES
@@ -123,6 +127,7 @@ config NETDUINOPLUS2
 
 config NSERIES
     bool
+    select ARM_V6
     select OMAP
     select TMP105   # tempature sensor
     select BLIZZARD # LCD/TV controller
@@ -391,6 +396,7 @@ config FSL_IMX25
 
 config FSL_IMX31
     bool
+    select ARM_V6
     select SERIAL
     select IMX
     select IMX_I2C
-- 
2.26.2

