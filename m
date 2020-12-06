Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF81A2D06B0
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 19:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgLFS5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 13:57:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727750AbgLFS5Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 13:57:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607280949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OgnINeMOsSyDZG4XwDK8Xw/XSsfPDxGpQ5JDhRmZjUY=;
        b=CAopMyajJehc2dVd8qLO5n8LE/KYgBAfziz5CA88UJW6ioMSPkXrl1VFuwKm/r5a0YdvPR
        M8IhMv57l+y1tRq7ZMVWwu8Hmj0StLDsoGe+QwlSVLGQD4yGQPy4zOj81jUPw5sC98y0Aa
        cRIe7xn2ZMqY8YX1PxBOUUxgkr1DS+w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-DJPjZZc1PlGgLxe5ZIbYGA-1; Sun, 06 Dec 2020 13:55:48 -0500
X-MC-Unique: DJPjZZc1PlGgLxe5ZIbYGA-1
Received: by mail-wm1-f70.google.com with SMTP id y187so4310865wmy.3
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 10:55:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OgnINeMOsSyDZG4XwDK8Xw/XSsfPDxGpQ5JDhRmZjUY=;
        b=oYAujCfLrNpiVpccQIqX/sMjYT6H3Ic8Q04IeierfsHOUaM7QC1cFMuO8MqZaEIHAu
         AcMkpWIzdPtcOunjecpM2cuiGWCZe13VOeM17xiiAKLfHODr3kzvEb3NWfwCAU9dIwW2
         ibrNEiAscbFAfkfu1YfKrGVf/flN8D/XDi923bLJq/ge0Xq/quH6AcTdYVHSZhkkwMqm
         UYidXFUqMn8zQb8iPYVX2VLxWUow/Dk0bVywAw/rnLuGzpaPAO6iXRyAr3VvxphoAtfq
         QP1/vYn96rDpFe4AWzT2dvjLOsn+LoeflVbveZXT6qslcJDMadzY7yPyRgqS/ynOCuwM
         JDNA==
X-Gm-Message-State: AOAM530nadQuCkppyUUOCr91KduB7Ar5z07BBN7uAQG1Yx+UHY4Q7wWy
        qsrSBWbl/s07Gr1LTCgOhDmC8z339IaaqM8qL1JsEFa/GXYwRBN3DJv4YVehqT2sTfPQWApCAmo
        H0/pcR2LCKxf6
X-Received: by 2002:a1c:27c4:: with SMTP id n187mr14572199wmn.157.1607280946016;
        Sun, 06 Dec 2020 10:55:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzP5ckHKkPnoBNFErvKN6cx0NmMNVau5K2sPqOp9OxzOmSHemiybPRD6ErRhCPAEZm1F015Rw==
X-Received: by 2002:a1c:27c4:: with SMTP id n187mr14572172wmn.157.1607280945820;
        Sun, 06 Dec 2020 10:55:45 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id f16sm10763171wmh.7.2020.12.06.10.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:55:45 -0800 (PST)
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
Subject: [PATCH 6/8] gitlab-ci: Add KVM PPC cross-build jobs
Date:   Sun,  6 Dec 2020 19:55:06 +0100
Message-Id: <20201206185508.3545711-7-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206185508.3545711-1-philmd@redhat.com>
References: <20201206185508.3545711-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross-build PPC target with KVM and TCG accelerators enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
later this job build KVM-only.
---
 .gitlab-ci.d/crossbuilds-kvm-ppc.yml | 5 +++++
 .gitlab-ci.yml                       | 1 +
 MAINTAINERS                          | 1 +
 3 files changed, 7 insertions(+)
 create mode 100644 .gitlab-ci.d/crossbuilds-kvm-ppc.yml

diff --git a/.gitlab-ci.d/crossbuilds-kvm-ppc.yml b/.gitlab-ci.d/crossbuilds-kvm-ppc.yml
new file mode 100644
index 00000000000..9df8bcf5a73
--- /dev/null
+++ b/.gitlab-ci.d/crossbuilds-kvm-ppc.yml
@@ -0,0 +1,5 @@
+cross-ppc64el-kvm:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-ppc64el-cross
+    TARGETS: ppc64-softmmu
diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index a69619d7319..024624908e8 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -15,6 +15,7 @@ include:
   - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
   - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
   - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
+  - local: '/.gitlab-ci.d/crossbuilds-kvm-ppc.yml'
 
 .native_build_job_template: &native_build_job_definition
   stage: build
diff --git a/MAINTAINERS b/MAINTAINERS
index d41401f6683..c7766782174 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -397,6 +397,7 @@ PPC KVM CPUs
 M: David Gibson <david@gibson.dropbear.id.au>
 S: Maintained
 F: target/ppc/kvm.c
+F: .gitlab-ci.d/crossbuilds-kvm-ppc.yml
 
 S390 KVM CPUs
 M: Halil Pasic <pasic@linux.ibm.com>
-- 
2.26.2

