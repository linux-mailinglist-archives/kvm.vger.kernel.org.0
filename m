Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87312D0EF2
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgLGLZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:25:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27372 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726405AbgLGLZm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:25:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607340255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g8YbOmB7dREvSr94Ah+ZfiHf5NH/XpXwyjPJvESlyyU=;
        b=DGWRFpjCtfNJAPsritt6jpdAM2whOtdflnDl15gJO3VgCXahYfK5R6I22hJMY1q1cvGmuo
        70DU5pWbOwaZoVRfg2QDqgj1gKoaf1puQqtvk//XVt4Bq3zRZqJW6sLwnVqT+OWpu07Lw4
        YjscbMQg/5uqkoY+flqeEtCeony7aVA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-rscSZ3wxNAe91zn_LvCaoA-1; Mon, 07 Dec 2020 06:24:14 -0500
X-MC-Unique: rscSZ3wxNAe91zn_LvCaoA-1
Received: by mail-wr1-f69.google.com with SMTP id w17so4736593wrl.8
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 03:24:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g8YbOmB7dREvSr94Ah+ZfiHf5NH/XpXwyjPJvESlyyU=;
        b=V//apsIyqnnXkNgw9pqrTZghubVI0u5opLn1leFIzHn0k48NniqtDQ3VBuuLrRNK5J
         zSshwZXQ//J0NJrDx2JNyZ0ur7a+sRYKgnhyCYL/OucS6W6p/9pl3mHeS/e0jsNalrC5
         CBTkGgFdhbojiwu2qByqz8ZphhdKlGXVGl8PfnQwvG3ENc9wzL82sND8Hzk0C2klyPW0
         ud8/knLYDyN13dcv4kOdEXp8L/TwoSZyZD9QLp8wxyPEgdMKNRZ/4OPOx0pNbu20U6Fx
         1jX0ApigyHwkT3xpS6BXP0McxHL/8mw4gFuKRTObk62yOAzKhsM7psxHut6BhHHd0U0d
         a9ig==
X-Gm-Message-State: AOAM532AKo2KeUNUaItXKlrcamokoX/rtn/jxXL+bBl3cUQr/0DJ3wmg
        a9x+ANFaCFvf65CbyDw+ZPtV9h92045VzGZkWsKt7zB0FfSMHAjF+FoGARP8nErMsR9s11+8mpR
        4d5QKtkqO+rgg
X-Received: by 2002:a5d:6805:: with SMTP id w5mr19619047wru.266.1607340253258;
        Mon, 07 Dec 2020 03:24:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRhB+8o3YIMMi0wDgCqDhu5Xr6LYssbvv4B7yWBshnzqnJb7A4bMr+1Oelyf2ZqMu7nwNEpg==
X-Received: by 2002:a5d:6805:: with SMTP id w5mr19619019wru.266.1607340253057;
        Mon, 07 Dec 2020 03:24:13 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h15sm9685217wru.4.2020.12.07.03.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 03:24:12 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Willian Rampazzo <wrampazz@redhat.com>, qemu-s390x@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        xen-devel@lists.xenproject.org, Paul Durrant <paul@xen.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: [PATCH v2 3/5] gitlab-ci: Introduce 'cross_accel_build_job' template
Date:   Mon,  7 Dec 2020 12:23:51 +0100
Message-Id: <20201207112353.3814480-4-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207112353.3814480-1-philmd@redhat.com>
References: <20201207112353.3814480-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a job template to cross-build accelerator specific
jobs (enable a specific accelerator, disabling the others).

The specific accelerator is selected by the $ACCEL environment
variable (default to KVM).

Extra options such disabling other accelerators are passed
via the $ACCEL_CONFIGURE_OPTS environment variable.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds.yml | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
index 099949aaef3..d8685ade376 100644
--- a/.gitlab-ci.d/crossbuilds.yml
+++ b/.gitlab-ci.d/crossbuilds.yml
@@ -13,6 +13,23 @@
           xtensa-softmmu"
     - make -j$(expr $(nproc) + 1) all check-build
 
+# Job to cross-build specific accelerators.
+#
+# Set the $ACCEL variable to select the specific accelerator (default to
+# KVM), and set extra options (such disabling other accelerators) via the
+# $ACCEL_CONFIGURE_OPTS variable.
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

