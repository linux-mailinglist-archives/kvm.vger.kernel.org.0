Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E45327DC3B
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgI2Wok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729077AbgI2Wok (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:40 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O2ptRm8f/lOeml0jS1cRqmJHNlSkXaKtAQigKfi/TLU=;
        b=VDeS28/5DLv9Nbk/QM0vSy1hMBwn4jw8NplhkjiCQF2pTcWYhQBoPn0+a11LLURSnjQ/b4
        SEERYJeLnhs8XwRF1wzD0TpGR7bALTFJ1H24H0M5H43kX1LI5BgDkyFUPeVn27ncFyf4ET
        XTYjH23bVkZhRKsCCW+ACkSo3KE2WFw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-d8IMP6GhMsyiEKjvsHM7JQ-1; Tue, 29 Sep 2020 18:44:35 -0400
X-MC-Unique: d8IMP6GhMsyiEKjvsHM7JQ-1
Received: by mail-wr1-f72.google.com with SMTP id v12so2361965wrm.9
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O2ptRm8f/lOeml0jS1cRqmJHNlSkXaKtAQigKfi/TLU=;
        b=R+RkHVGZpBZNhJYWIcvG3CtouJR7cUzFcYb/0TbbVGQUgr2GrO7u5UNoCB+2Rxc8cK
         h6luXYyHL2EdstzHnXDr6QO/P9Lan0xlG4Wkskedpbv3CqjYapaY8dFe0IXReUl8FfxI
         BuosFfFg155VkNhm0SiOWvAexMNKR21Ar8XDquyOVQc/ULFoh9ePu2t3KKkAn5UIRLeb
         +pOePBufRDP01uj9t6JXp24ZbP8Q9nv/s3zla/10yWxiGBQNBbpDx2Uuszp3Cc1wQwQz
         +ZRYh2A/QOom9gyTR+h5LcFvaBi/YjAzqeBJlGdpQqplVNhfyhAxzlQVTpT9pjNNqTPE
         52cQ==
X-Gm-Message-State: AOAM531ahnbJdcB1IgIu3l7XkYW5ZQh6OarG0MrBgqpS+VsnjDsmu4xC
        UMTcXP0Dj1yJQp2bhHhLq9uzu+grdpBun2QlXdBQwhcMwrxniLLBpulSQxxrC4BQ7Y8+H+H0Kwt
        w1SiAwEqmWpH8
X-Received: by 2002:a5d:444b:: with SMTP id x11mr6634813wrr.402.1601419473912;
        Tue, 29 Sep 2020 15:44:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4aaS54Wk933OJIRQKbP4cZ/YFPBu2pchNU62vp4qGrFYgoGCxMVfKfqvmCyuVMDLcMh8vXQ==
X-Received: by 2002:a5d:444b:: with SMTP id x11mr6634802wrr.402.1601419473707;
        Tue, 29 Sep 2020 15:44:33 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id m10sm7056524wmi.9.2020.09.29.15.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:33 -0700 (PDT)
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
Subject: [PATCH v4 07/12] target/arm: Restrict ARMv7 R-profile cpus to TCG accel
Date:   Wed, 30 Sep 2020 00:43:50 +0200
Message-Id: <20200929224355.1224017-8-philmd@redhat.com>
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

A KVM-only build won't be able to run R-profile cpus.

Only enable the following ARMv7 R-Profile CPUs when TCG is available:

  - Cortex-R5
  - Cortex-R5F

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/arm/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index e01eb55bc0..7f19872722 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -10,6 +10,10 @@ config ARM_V6
     bool
     select TCG
 
+config ARM_V7R
+    bool
+    select TCG
+
 config ARM_VIRT
     bool
     imply PCI_DEVICES
@@ -358,6 +362,7 @@ config XLNX_ZYNQMP_ARM
     bool
     select AHCI
     select ARM_GIC
+    select ARM_V7R
     select CADENCE
     select DDC
     select DPCD
-- 
2.26.2

