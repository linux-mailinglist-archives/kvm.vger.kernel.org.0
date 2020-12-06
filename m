Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1F42D06AC
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 19:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgLFS5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 13:57:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgLFS4x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 13:56:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607280925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0Lqr22l7ATKhofbc7EdyOSapxnrV+ynGfxlD6q9jNk=;
        b=SSnMWYCsfN1oznTMN5e15j3msdb78/4wuJHDZJ3IjSJEqQglO8DyMUIEBmhwVjg/Epa5tu
        6qhnX6SOH82ORSDjgM9XAZkp1VinVgATzFdXRr+OEq6XSgAhS1CuCCzhgYu4jgniL6t3Vy
        6vPfZEEvJ0lreixQMVUmvjlz1T0R7Fc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-5PyJvqHvMQeEaYEv49NlkQ-1; Sun, 06 Dec 2020 13:55:24 -0500
X-MC-Unique: 5PyJvqHvMQeEaYEv49NlkQ-1
Received: by mail-wm1-f69.google.com with SMTP id g198so3221766wme.7
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 10:55:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r0Lqr22l7ATKhofbc7EdyOSapxnrV+ynGfxlD6q9jNk=;
        b=d8tIjmuiTCvQt+73Xhuv8wTNONSnaVDUJiE8ppaxBfU+KkwMKrbwUj/dMPE27S1KNE
         INQGAfjyoHN2I/lfofADk6colpzfWOpHZhga/bcqO7/W5DhFzZFO4s/J2TdWiAxUGAET
         0HIXJhso8CSgLWHrqs4P6cbKCAACVU5bPLeojbvaS8TtE4tdYlB+tUa8ONfEtwJ3io+0
         3BnvYkRn0ODcobEdpdV+d0S2N7FGNsPRxUGsT1gLzDhVOTno8+Q3gWE4MFbtPU4v3Na8
         YbjH3t/FKZ/uz5hoMbPRbO0CMXZII18jOBKF3tf+fjGcuqabjK5fhqapsf/onCk7OXBs
         8rAQ==
X-Gm-Message-State: AOAM5318PmIRsG+hIRunbR/i0hhY1Znd5vzpAvdkAArCMASSee+EasG2
        rI0bGWqmeDD+dptA+qvShTUPwjWsYyxTnNThA1+duZAy30HaLTmsA9JEh06BaLftFIHLf13X8yx
        i51IozvgILCl3
X-Received: by 2002:a1c:e084:: with SMTP id x126mr14748230wmg.109.1607280923050;
        Sun, 06 Dec 2020 10:55:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUdCKKWJAWPI622MaP/oFwVO6CryrIW/lu5gCYVi0AVbbug+7fy7NlRBDMxgrTLJyAtgWuOA==
X-Received: by 2002:a1c:e084:: with SMTP id x126mr14748201wmg.109.1607280922898;
        Sun, 06 Dec 2020 10:55:22 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id m8sm11324488wmc.27.2020.12.06.10.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:55:22 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Claudio Fontana <cfontana@suse.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org
Subject: [PATCH 2/8] gitlab-ci: Introduce 'cross_accel_build_job' template
Date:   Sun,  6 Dec 2020 19:55:02 +0100
Message-Id: <20201206185508.3545711-3-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206185508.3545711-1-philmd@redhat.com>
References: <20201206185508.3545711-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a job template to cross-build accelerator specific
jobs (enable a specific accelerator, disabling the others).

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds.yml | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
index 099949aaef3..be63b209c5b 100644
--- a/.gitlab-ci.d/crossbuilds.yml
+++ b/.gitlab-ci.d/crossbuilds.yml
@@ -13,6 +13,18 @@
           xtensa-softmmu"
     - make -j$(expr $(nproc) + 1) all check-build
 
+.cross_accel_build_job:
+  stage: build
+  image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
+  timeout: 30m
+  script:
+    - mkdir build
+    - cd build
+    - PKG_CONFIG_PATH=$PKG_CONFIG_PATH
+      ../configure --enable-werror $QEMU_CONFIGURE_OPTS --disable-tools
+        --enable-${ACCEL:-kvm} --target-list="$TARGETS" $ACCEL_CONFIGURE_OPTS
+    - make -j$(expr $(nproc) + 1) all check-build
+
 .cross_user_build_job:
   stage: build
   image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
-- 
2.26.2

