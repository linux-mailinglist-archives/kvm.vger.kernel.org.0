Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A4E27DC3C
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgI2Won (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729077AbgI2Won (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VMKffrN5obKOm6UxS550K4u6DmnYBBMm9AG93ufLP5A=;
        b=P/j9ak1iWY31QwB+H3Ib0oWDOUlaqqGD6QoZnM7NJ3UxtwiT/o12Z8i0LSe3uYymnOkkIx
        3+yRDAomXAbdE+91Wo/1k+39sqaO/n7oeGrjha1hbKuUUhf2x7ky7zYZC392xA5rUX9Gxq
        IDjGRPVvqaUu5GC3KTpiVS5kvoPKHDk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-lQ74zRzpMoaEudBtCcxLzQ-1; Tue, 29 Sep 2020 18:44:40 -0400
X-MC-Unique: lQ74zRzpMoaEudBtCcxLzQ-1
Received: by mail-wr1-f71.google.com with SMTP id d13so2328904wrr.23
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VMKffrN5obKOm6UxS550K4u6DmnYBBMm9AG93ufLP5A=;
        b=UCizQgMdhVntD0tSWp1MEidzp4Di5OWwExI/UjKzS03zBZGJHDK7mi1u0gp2s0Tvfm
         zPbRdZ8aYFjkpChfg94b+1BdFTHIvufrGN6vzll/gJpaEAdC4J+C1x0V7tv4Tv9tvtrv
         Y+I9676P2/Po0zmfzI7JnhjYr1jNHa1/5TGEErjMPcLl3+MFjBL1+Pbt6De8yrt582dz
         etgCoysOyhcrOXeL3QDOByrz4ajetziLjZObyq7IEa6zVJCmUrsxtQQWSxmfZGDI+AXU
         OtJ0Vu8HzmIQYa8MQtEP0EWQRGL9SIGydV7kXpkEhMkzpMZSxEd9EOD6CS42BLFCW0to
         0akQ==
X-Gm-Message-State: AOAM532dAm404zkuAyX5PtO7v0Rx3iM8NwNVQFHxKHJE6cYhadZQmo/C
        ytW6XPLu/Vm/XhiqHxcpVdtPEVE4Q86CsBm1+Rf0575kxhW0EHH5ogiU1G76OeY0eFYmiGQ+jCe
        jil48mNazIzIh
X-Received: by 2002:a7b:c76d:: with SMTP id x13mr6762359wmk.10.1601419478956;
        Tue, 29 Sep 2020 15:44:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxd5/l6Pz82+iT32jI8EMtGES+WPwtktxL0xH6iDe0EYmyk+iEByXkfuzuL6KdhyW+6NVNK1w==
X-Received: by 2002:a7b:c76d:: with SMTP id x13mr6762351wmk.10.1601419478789;
        Tue, 29 Sep 2020 15:44:38 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id l17sm6922065wme.11.2020.09.29.15.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:38 -0700 (PDT)
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
Subject: [PATCH v4 08/12] target/arm: Restrict ARMv7 M-profile cpus to TCG accel
Date:   Wed, 30 Sep 2020 00:43:51 +0200
Message-Id: <20200929224355.1224017-9-philmd@redhat.com>
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

A KVM-only build won't be able to run M-profile cpus.

Only enable the following ARMv7 M-Profile CPUs when TCG is available:

  - Cortex-M0
  - Cortex-M3
  - Cortex-M4
  - Cortex-M33

We don't need to enforce CONFIG_ARM_V7M in default-configs because
all machines using a Cortex-M are already explicitly selected.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 default-configs/arm-softmmu.mak | 3 ---
 hw/arm/Kconfig                  | 4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
index 08a32123b4..002c97862b 100644
--- a/default-configs/arm-softmmu.mak
+++ b/default-configs/arm-softmmu.mak
@@ -1,8 +1,5 @@
 # Default configuration for arm-softmmu
 
-# TODO: ARM_V7M is currently always required - make this more flexible!
-CONFIG_ARM_V7M=y
-
 # CONFIG_PCI_DEVICES=n
 # CONFIG_TEST_DEVICES=n
 
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index 7f19872722..15faa2f2d7 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -14,6 +14,10 @@ config ARM_V7R
     bool
     select TCG
 
+config ARM_V7M
+    bool
+    select TCG
+
 config ARM_VIRT
     bool
     imply PCI_DEVICES
-- 
2.26.2

