Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE53027DC40
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgI2WpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:45:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728115AbgI2WpF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:45:05 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDAC3FC/MEaPD4LUvl2bkbirLPCAiqLo/YtDEMBCclM=;
        b=MBcq+HErkyunAKFXRGXfNEMmW1C+I/t7uaVZq7oebOyPkwRklEekU9LNveaa+blSVW2Zta
        kM09w7pdt4xwL7AFuPsGScYyfwV5bqF3JDzy1YK/mbGXG7ZzMcSg6ax7UaV89FqBNrp6oN
        ydPYeowBe4mNrENq81Yq2mU+yJWDBcs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-M4ww9AR3NsSVNdfbGqvkLw-1; Tue, 29 Sep 2020 18:45:00 -0400
X-MC-Unique: M4ww9AR3NsSVNdfbGqvkLw-1
Received: by mail-wr1-f71.google.com with SMTP id b2so2336622wrs.7
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LDAC3FC/MEaPD4LUvl2bkbirLPCAiqLo/YtDEMBCclM=;
        b=nH1tWlOan+7m9bJr8iw04JXFtR+tiugEIF4A++rUu0Gaxd7LqEZq02PBaPKM0HpJWN
         MSoUc3oKM/bm0DgwO74pS7VH1BPyFYFE7VWVWB8Znuqkd+DusiOTAUrp8yUySTW9k8Y1
         IClC9nwQjPMlYIMHz/lCJk0157Y+EdEuIyu0h7/QvLT0ccwQlf9oDd0DBuIG7/uQT8pY
         L/BNbOD2Qm/On8zVvUUSjRlZvTLf+W9eoBwfa+yaGCk4S+bH+YlKJnpYCAGXqYvk+MCH
         0bnJykpkFx8zKEa0FUH1A4Dph0Cyu97HE/ENOgLDY16e8LxF2jjIcVqygVUonHDZaFMq
         sOnA==
X-Gm-Message-State: AOAM532QjUNzwF9o28wksOi0b8ErhhzFWDROsFqQqkXAlgFCUkgxUwJQ
        w90BO3xszV0VUz1S2DFVN31OXpq+Yyqw5kNQoKfhif3eU9Rmb6sEv7+H/C1lrC78tSpPE9WOMgL
        wfJe0wmBaTfRq
X-Received: by 2002:a5d:43cf:: with SMTP id v15mr6808319wrr.269.1601419499106;
        Tue, 29 Sep 2020 15:44:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwH+Rg1xe9gd9DlTZs7Ar3VzsQvPodRcCF6Ci4iIpufBqC6fONYRBje8t5F8NeD4ocLB3USiA==
X-Received: by 2002:a5d:43cf:: with SMTP id v15mr6808303wrr.269.1601419498855;
        Tue, 29 Sep 2020 15:44:58 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id 76sm7666468wma.42.2020.09.29.15.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:58 -0700 (PDT)
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
Subject: [PATCH v4 12/12] .travis.yml: Add a KVM-only Aarch64 job
Date:   Wed, 30 Sep 2020 00:43:55 +0200
Message-Id: <20200929224355.1224017-13-philmd@redhat.com>
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

Add a job to build QEMU on Aarch64 with TCG disabled, so
this configuration won't bitrot over time.

We explicitly modify default-configs/aarch64-softmmu.mak to
only select the 'virt' and 'SBSA-REF' machines.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
Job ran for 7 min 30 sec
https://travis-ci.org/github/philmd/qemu/jobs/731428859
---
 .travis.yml | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index c75221dca3..cad65cf181 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -402,6 +402,41 @@ jobs:
         - CONFIG="--disable-containers --target-list=${MAIN_SOFTMMU_TARGETS}"
         - UNRELIABLE=true
 
+    - name: "[aarch64] GCC (disable-tcg)"
+      arch: arm64
+      dist: bionic
+      addons:
+        apt_packages:
+          - libaio-dev
+          - libattr1-dev
+          - libcap-ng-dev
+          - libgcrypt20-dev
+          - libgnutls28-dev
+          - libiscsi-dev
+          - liblttng-ust-dev
+          - libnfs-dev
+          - libnss3-dev
+          - libpixman-1-dev
+          - libpng-dev
+          - librados-dev
+          - libseccomp-dev
+          - liburcu-dev
+          - libusb-1.0-0-dev
+          - libvdeplug-dev
+          - libvte-2.91-dev
+          # Tests dependencies
+          - genisoimage
+      env:
+        - CONFIG="--disable-containers --disable-tcg --enable-kvm --disable-tools"
+        - TEST_CMD="make check-unit"
+        - CACHE_NAME="${TRAVIS_BRANCH}-linux-gcc-aarch64"
+      before_script:
+        # Only use the 'virt' and 'sbsa-ref' machine which don't need TCG.
+        - echo CONFIG_ARM_VIRT=y > default-configs/aarch64-softmmu.mak
+        - echo CONFIG_SBSA_REF=y >> default-configs/aarch64-softmmu.mak
+        - mkdir -p ${BUILD_DIR} && cd ${BUILD_DIR}
+        - ${SRC_DIR}/configure ${BASE_CONFIG} ${CONFIG} || { cat config.log && exit 1; }
+
     - name: "[ppc64] GCC check-tcg"
       arch: ppc64le
       dist: xenial
-- 
2.26.2

