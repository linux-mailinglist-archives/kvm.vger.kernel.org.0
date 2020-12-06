Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4899B2D06B1
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 19:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgLFS5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 13:57:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727750AbgLFS5V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 13:57:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607280954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i1vxVlVvkT3sP8apHjKZ3bpOmMfnVbEari6EJ9mVBVw=;
        b=iGDNmebkOhWUfG8LT03wEQ5zmhbG2UMW+jLtEA5KbVdcKuV/FX5Pmhah+79/YCrPlcej+A
        nyYbYWIjiCjxpDVZbVe/jODP3vP5UuBR/ftWqpT4iKdQf+r8vbFSGASNmOH0KJStUboXyT
        5LxU36mGwZYuwj4Pymf9XPf1IjxMaks=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-X6uSv3DCN4-kSZnsijMDRw-1; Sun, 06 Dec 2020 13:55:53 -0500
X-MC-Unique: X6uSv3DCN4-kSZnsijMDRw-1
Received: by mail-wm1-f70.google.com with SMTP id k126so1497566wmb.0
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 10:55:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i1vxVlVvkT3sP8apHjKZ3bpOmMfnVbEari6EJ9mVBVw=;
        b=i8H+seoLBWPorW9G6W8aGk8WWvqvvoGcxgzHwQherikV9Z6MIyGl+eZFCMV5n0KiI8
         ERqNneeTUrYeMwJc9Kw/yxCnR9vja6gOmxkTd3r7HJ0pVW0JC+WziywwBI1hT7vRQaHp
         /x5UuM0cws7+YZIZFYReR99zdizjBrC3RfSxrM96/gxsdFa3toE6RM2Ag95uE+Lv9Fl+
         wPi75FIIeGxZ8nIqeY4hqNjSH1+53jI3zOZtCSW8ENPSosGPqSvNBkum/ZQ6vrgu1Cjw
         INP0d4DfxOYbMJgrPo2VmaUIW6WM8duiNbKdNtv8VBHS7r6+m+tNFvVTkNnNAkEcgb6Z
         QPgw==
X-Gm-Message-State: AOAM532SJ+2D9D7otPfD1OJRsajqEJurMyeGMleCjaeXBhGYynVf3zbS
        O8tnrfXs2MMj2NBPmNPZNZYf8b3rHqKhl4y5Jw+BbG5rK1uOKNbJQP2gv+uu539tN1+YyGfLGFb
        9oM/exeDWg0pF
X-Received: by 2002:adf:9b9b:: with SMTP id d27mr13324086wrc.125.1607280951438;
        Sun, 06 Dec 2020 10:55:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjk3rMrzMdcRMBa9qbGydj+XoVJdnBoRtt4fTfXKTXx014IQZfLKKyL1tpFnUZLU9IFuOQ5Q==
X-Received: by 2002:adf:9b9b:: with SMTP id d27mr13324062wrc.125.1607280951287;
        Sun, 06 Dec 2020 10:55:51 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id v20sm10922213wml.34.2020.12.06.10.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:55:50 -0800 (PST)
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
Subject: [PATCH 7/8] gitlab-ci: Add KVM MIPS cross-build jobs
Date:   Sun,  6 Dec 2020 19:55:07 +0100
Message-Id: <20201206185508.3545711-8-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206185508.3545711-1-philmd@redhat.com>
References: <20201206185508.3545711-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross-build mips target with KVM and TCG accelerators enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
later we'll build KVM-only.
---
 .gitlab-ci.d/crossbuilds-kvm-mips.yml | 5 +++++
 .gitlab-ci.yml                        | 1 +
 MAINTAINERS                           | 1 +
 3 files changed, 7 insertions(+)
 create mode 100644 .gitlab-ci.d/crossbuilds-kvm-mips.yml

diff --git a/.gitlab-ci.d/crossbuilds-kvm-mips.yml b/.gitlab-ci.d/crossbuilds-kvm-mips.yml
new file mode 100644
index 00000000000..81eeeb315bb
--- /dev/null
+++ b/.gitlab-ci.d/crossbuilds-kvm-mips.yml
@@ -0,0 +1,5 @@
+cross-mips64el-kvm:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-mips64el-cross
+    TARGETS: mips64el-softmmu
diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 024624908e8..5f607fc7b48 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -16,6 +16,7 @@ include:
   - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
   - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
   - local: '/.gitlab-ci.d/crossbuilds-kvm-ppc.yml'
+  - local: '/.gitlab-ci.d/crossbuilds-kvm-mips.yml'
 
 .native_build_job_template: &native_build_job_definition
   stage: build
diff --git a/MAINTAINERS b/MAINTAINERS
index c7766782174..5f26626a512 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -392,6 +392,7 @@ MIPS KVM CPUs
 M: Huacai Chen <chenhc@lemote.com>
 S: Odd Fixes
 F: target/mips/kvm.c
+F: .gitlab-ci.d/crossbuilds-kvm-mips.yml
 
 PPC KVM CPUs
 M: David Gibson <david@gibson.dropbear.id.au>
-- 
2.26.2

