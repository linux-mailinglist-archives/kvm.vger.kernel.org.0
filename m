Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0824627DC37
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbgI2WoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728860AbgI2WoR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:17 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVtzhoPQ9oRe5A4whgi5/tX3r24KuxvOyig0n+4hw6k=;
        b=PHWvgZgwnPBuN08mYdI+e2MAUd+frzRoOP6kAdur50LRba23uRMnxy1PxPYUS/g8Zvt0Ai
        mhRWblm4vru1xWeL0rym3WSaECPAFbhyNSFl5sABrfT07JDPNRnwH26EWUquVfaL8R957N
        jqEpRu6WAtf9+OQGWxORim+xxnUNeM0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-tVekPGQTNHOEcxQWK9vNmA-1; Tue, 29 Sep 2020 18:44:14 -0400
X-MC-Unique: tVekPGQTNHOEcxQWK9vNmA-1
Received: by mail-wr1-f72.google.com with SMTP id a2so2345762wrp.8
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:44:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fVtzhoPQ9oRe5A4whgi5/tX3r24KuxvOyig0n+4hw6k=;
        b=RGz71pSRV1nmQMI0KcvQt+RW8miWP9nlYsSvIA+TBzmRntxa9fIZByoLepxrp36FTo
         m1gEmd8bcdEheiJQ+4WtFaREkkJEVIeoggbRfUvQfwyYx630oyLFhHnZWqorViuN2pr/
         stQvYyA5soiziph5JdPb4shpE4GVVd7lZWiAlF43nbIVinw4/yO3adZoPlBUUhfC/zOf
         3DKPy9lgbOzEPkdL1FCkmPRemLjkHU4pkLKWa4fM8O1qchayzIepaPln1SBOEAQ9AHvm
         u6EdYnCUY3nsPQtE9x6XOnYP/AK5pTnKL10O68LItsxpQN0vgIAI9QujSti62lFD6rYx
         2XYA==
X-Gm-Message-State: AOAM533OvhiiP2id5X9oZLPM1W2jGc6t/9UStWtKSwRpyS8afYMxkaKv
        q/oE3aCFEqwti4COSwbRBziRQB0BZc/3FM+okdjA+KnKjKiKm0bhuLgXSCdWuOirg5txCecbCFV
        nsSSP2yvKxcUA
X-Received: by 2002:a5d:5261:: with SMTP id l1mr6619428wrc.193.1601419453411;
        Tue, 29 Sep 2020 15:44:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeOEbx68Td8hBaYyIFzxkCzoKhQ+EE4XU8IG3LB8RbTCWtKeOlhoOS8sgyI3yT3aeSBndgRw==
X-Received: by 2002:a5d:5261:: with SMTP id l1mr6619416wrc.193.1601419453250;
        Tue, 29 Sep 2020 15:44:13 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id l18sm7902646wrp.84.2020.09.29.15.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:12 -0700 (PDT)
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
Subject: [PATCH v4 03/12] target/arm: Select SEMIHOSTING if TCG is available
Date:   Wed, 30 Sep 2020 00:43:46 +0200
Message-Id: <20200929224355.1224017-4-philmd@redhat.com>
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

Add a kconfig entry which not explicitly selected by another
entry, but which selects SEMIHOSTING if TCG is available.

This avoids:

  /usr/bin/ld: libqemu-aarch64-softmmu.fa.p/target_arm_arm-semi.c.o: in function `do_arm_semihosting':
  target/arm/arm-semi.c:784: undefined reference to `qemu_semihosting_console_outc'
  target/arm/arm-semi.c:787: undefined reference to `qemu_semihosting_console_outs'
  /usr/bin/ld: target/arm/arm-semi.c:815: undefined reference to `qemu_semihosting_console_inc'

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/arm/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)
 create mode 100644 target/arm/Kconfig

diff --git a/target/arm/Kconfig b/target/arm/Kconfig
new file mode 100644
index 0000000000..972d9a1b9a
--- /dev/null
+++ b/target/arm/Kconfig
@@ -0,0 +1,4 @@
+# arch-specific rule to select SEMIHOSTING if ARM && TCG
+config ARM_SEMIHOSTING
+    default y if TCG
+    select SEMIHOSTING
-- 
2.26.2

