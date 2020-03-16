Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2209186FC8
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 17:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732084AbgCPQOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 12:14:35 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:29663 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731992AbgCPQOf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 12:14:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584375273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7+HmyV0D4vFSs4ZL/u4BopejDTWdgLZjfeVHLnQ9M4=;
        b=DS/6rMY33zEHCE6VfPG1hhaj/nKTlvHOjuAb8PiUrheBYsuA+43m6qkycieOuMF3GaczUI
        EfeP6T+kRv1KPRTexamJWAhnfKimm8y22KcGvapijNaAPAzCU+t8XNpD0vXG0Otvlee4CP
        pQnyvgfLM0IejgYDOkHyyQg2OlQBLMY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-CiUXNBgWOjOH8dLE4p7DVw-1; Mon, 16 Mar 2020 12:08:23 -0400
X-MC-Unique: CiUXNBgWOjOH8dLE4p7DVw-1
Received: by mail-wr1-f69.google.com with SMTP id p5so9176589wrj.17
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 09:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7+HmyV0D4vFSs4ZL/u4BopejDTWdgLZjfeVHLnQ9M4=;
        b=aArtDaeKkrpfx6TXb8YRQ90aIF++Cs7GUEO60YlZjVOO0VOfh4TaiOHK97q5U3pHgG
         298uPuAbOMbUnIBdXw1/GYCXMvvfZ3a3uWkgdhv+jZuWquZeHf7IhL8XpXnCcC/k3/ts
         qWucUgqhB0apRRdB3vY/L/zIAuJHS6GZQfRgYtvvDgTd7HvdPJiS9mJQQw08N4Nu176C
         HBBZM6r6BYcJzzDSb5V/vWo7gbMY9E2dDea/yf6Hzt5pKR8OD841rgiAvk+EBaQjLP3V
         u7VBweY0lHy6XS+fVDA7HXAGhy/arpW2Q4w9dnJ/udCh9O/yxNB96G+E7ozoNcCj+j+I
         S52A==
X-Gm-Message-State: ANhLgQ23uCp+vIY7ipTT5wifivlcovpWM8G66YTgCMIs+MZKEklVog7b
        IzHbYcEgiPLTryo0EW9Ej6KKu+iwMey7BZoJuEs2cZTpevc2FGxrIrY83WmCz7mALlQcl1cE2eL
        PZFhjFJLR0Cxl
X-Received: by 2002:a1c:984a:: with SMTP id a71mr29937835wme.185.1584374902205;
        Mon, 16 Mar 2020 09:08:22 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vssyfrGmsyQfMixG6XPmVZD6SHgaog1D2LjTAVp2uFXc9h0dhfPsS644yu8c8+ZyHwycJ4JHQ==
X-Received: by 2002:a1c:984a:: with SMTP id a71mr29937801wme.185.1584374901937;
        Mon, 16 Mar 2020 09:08:21 -0700 (PDT)
Received: from localhost.localdomain (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id v10sm170121wml.44.2020.03.16.09.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 09:08:21 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 19/19] .travis.yml: Add a KVM-only Aarch64 job
Date:   Mon, 16 Mar 2020 17:06:34 +0100
Message-Id: <20200316160634.3386-20-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200316160634.3386-1-philmd@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a job to build QEMU on Aarch64 with TCG disabled, so
this configuration won't bitrot over time.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
Job ran for 13 min 1 sec
https://travis-ci.org/github/philmd/qemu/jobs/663122258
---
 .travis.yml | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index b92798ac3b..ea3c0df185 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -450,6 +450,38 @@ jobs:
         - TEST_CMD="make check check-tcg V=1"
         - CONFIG="--disable-containers --target-list=${MAIN_SOFTMMU_TARGETS}"
 
+    - name: "[aarch64] GCC check (KVM)"
+      arch: arm64
+      dist: xenial
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
+        - CONFIG="--disable-containers --disable-tcg --enable-kvm --enable-fdt --disable-tools"
+        - TEST_CMD="make check-unit"
+      script:
+        # Only select the 'virt' machine.
+        - echo CONFIG_ARM_VIRT=y > ${SRC_DIR}/default-configs/aarch64-softmmu.mak
+        - make -j3 && travis_retry ${TEST_CMD}
+
     - name: "[ppc64] GCC check-tcg"
       arch: ppc64le
       dist: xenial
-- 
2.21.1

