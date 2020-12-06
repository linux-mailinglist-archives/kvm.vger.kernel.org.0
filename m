Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964552D06AB
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 19:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgLFS4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 13:56:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgLFS4r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 13:56:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607280920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J0caE/rg850u7bwr+Q+jKihpcnbP+o9Z+fIMhlSMarg=;
        b=P4Z0ATzxM3uQDdwrsK6NPVownN6Vh+jBf4n3ODAK1USO/vJkWtEq1fS3XVAStP9lHUi67h
        DXQhgJabcFgtRXmBgqWLIvkq4K7qDiYSc9Ir4b2KnA2+74GOqu4ghOJFX4Ov6GhvlNy0mq
        EOgAjr9IyO3oJOxUL+q/I8fiNahWczg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-xQnfcX6bN-WR8heqSQl_GA-1; Sun, 06 Dec 2020 13:55:18 -0500
X-MC-Unique: xQnfcX6bN-WR8heqSQl_GA-1
Received: by mail-wm1-f71.google.com with SMTP id l5so3280988wmi.4
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 10:55:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J0caE/rg850u7bwr+Q+jKihpcnbP+o9Z+fIMhlSMarg=;
        b=hpmOoKPMHoscwijxkyJ1Ih0D4ejKgTvzwj+PQlNSeNdro+vYr8rUjRQI2wL5A9qvpZ
         8WFbtZFf4kxzrQVll/o7CaLBk0q1OsXmnSN/3cOfPyu8hC0fMT/JL6YWF7u3b/P/eYLT
         iRaZUNcFOLPQboo7EvHNCcforeFtNK6ENsH6tkD2MtL6P7pQsG6iI1ockyP2Q0frxwZw
         EkJJ2DE4UpLGsIv9bPJivRBRHzZU23Gdrh+tGJMlWUs3qR6yIWDcuHxofbMYzrIgfybp
         r8e5ZNRZykRcoforVf6L4l1s28tRUTDPsJsValwDljUne70RkmTZo+L9M2KLo2mRN/gr
         n8Yw==
X-Gm-Message-State: AOAM532M8D3e472/yjJRJPnvRX5XqflHmcXJS/CoYmkuzhkSvSV9BvVo
        U0J9JNYxiqiuoxmOXXBELSWMNnYK+P/H0yvKJmLEfibiO9NNIqw58uT3VdinOW3lssYG80qKxG3
        GBhsTK8fX6Zui
X-Received: by 2002:a5d:6447:: with SMTP id d7mr15842839wrw.96.1607280917540;
        Sun, 06 Dec 2020 10:55:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5Mv3+kYooSf15r+r2aJLz/Qnqkoua9wFQmOH5L1QMkE6WgvTm77oljoy/QdNzxy3aicjEtQ==
X-Received: by 2002:a5d:6447:: with SMTP id d7mr15842818wrw.96.1607280917387;
        Sun, 06 Dec 2020 10:55:17 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id v7sm11353163wma.26.2020.12.06.10.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:55:16 -0800 (PST)
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
Subject: [PATCH 1/8] gitlab-ci: Replace YAML anchors by extends (cross_system_build_job)
Date:   Sun,  6 Dec 2020 19:55:01 +0100
Message-Id: <20201206185508.3545711-2-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206185508.3545711-1-philmd@redhat.com>
References: <20201206185508.3545711-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'extends' is an alternative to using YAML anchors
and is a little more flexible and readable. See:
https://docs.gitlab.com/ee/ci/yaml/#extends

More importantly it allows exploding YAML jobs.

Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds.yml | 40 ++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
index 03ebfabb3fa..099949aaef3 100644
--- a/.gitlab-ci.d/crossbuilds.yml
+++ b/.gitlab-ci.d/crossbuilds.yml
@@ -1,5 +1,5 @@
 
-.cross_system_build_job_template: &cross_system_build_job_definition
+.cross_system_build_job:
   stage: build
   image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
   timeout: 80m
@@ -13,7 +13,7 @@
           xtensa-softmmu"
     - make -j$(expr $(nproc) + 1) all check-build
 
-.cross_user_build_job_template: &cross_user_build_job_definition
+.cross_user_build_job:
   stage: build
   image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
   script:
@@ -24,91 +24,91 @@
     - make -j$(expr $(nproc) + 1) all check-build
 
 cross-armel-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-armel-cross
 
 cross-armel-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-armel-cross
 
 cross-armhf-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-armhf-cross
 
 cross-armhf-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-armhf-cross
 
 cross-arm64-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-arm64-cross
 
 cross-arm64-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-arm64-cross
 
 cross-mips-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-mips-cross
 
 cross-mips-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-mips-cross
 
 cross-mipsel-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-mipsel-cross
 
 cross-mipsel-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-mipsel-cross
 
 cross-mips64el-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-mips64el-cross
 
 cross-mips64el-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-mips64el-cross
 
 cross-ppc64el-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-ppc64el-cross
 
 cross-ppc64el-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-ppc64el-cross
 
 cross-s390x-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: debian-s390x-cross
 
 cross-s390x-user:
-  <<: *cross_user_build_job_definition
+  extends: .cross_user_build_job
   variables:
     IMAGE: debian-s390x-cross
 
 cross-win32-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: fedora-win32-cross
 
 cross-win64-system:
-  <<: *cross_system_build_job_definition
+  extends: .cross_system_build_job
   variables:
     IMAGE: fedora-win64-cross
-- 
2.26.2

