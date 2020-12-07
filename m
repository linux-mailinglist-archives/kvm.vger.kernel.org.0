Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326BB2D11A8
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 14:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgLGNQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 08:16:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726076AbgLGNQ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 08:16:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607346931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R0x/t12SaUJO2Fk00rNBDpsAQee1BNuzclT5nFRV5W4=;
        b=hDDXTieIHZZkaFqpDDrWrlZF4vH4hW1anY0uUJPiDJLlRhZlUrJfGTujnJ7XbuJuSCRgbP
        GD4G7eMbbacRvu4jCbkHIr+ZMnjt/6lM0uRrFQYNwcI/ZDybSfyUmn8pEYMmJO11Siux9R
        6Qvy+YZDT7KkRDILDe5EsOTepGpRv5U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-HEkIbyXgMdqQd6G2P8z4hg-1; Mon, 07 Dec 2020 08:15:29 -0500
X-MC-Unique: HEkIbyXgMdqQd6G2P8z4hg-1
Received: by mail-wr1-f72.google.com with SMTP id j5so2762633wro.12
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 05:15:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R0x/t12SaUJO2Fk00rNBDpsAQee1BNuzclT5nFRV5W4=;
        b=NaQw/r8Rf32hV9VW26lFRUK7mDI1HTmqTI+nO67kQGqsXiZ5AwpZQFBtAlPtTxjEAw
         1EH/6PrCk+Ob99O1i1s14Fpm3UPwIa2olOETJbbkQpOdlPwsRequrQEAiUMOBoKi4WSC
         /Nwb8xAPnORo+pvuLge7wZW701efyPsgZg9b9kIM2GcUbpDT+krbekIKH23LTfghbxjW
         LQFAp8Skr1gMoaBDPQHerTYF/h5lN5OKPXtmggNXsFcHZJ2klFuZgVhMAdaM8K+1lf6i
         0NVM3ySBMcw2jxik/tDtcmOLkomXccKLclEFwAnK4vMA3+nZTiIVAOJgM173mtCJMXbQ
         rNmg==
X-Gm-Message-State: AOAM530bFfOd2CpIYA955hUh/A9wBM+ZhGU5STRCq6TrkdOUf5AmcU3h
        UB6Bj4EbtAaXDYYFbxDcahWxWNpJ9NSbVlT64q1kNX8sNiV0RnGjRjKJHrc2EfhVUJq6FyX+HOT
        V5QoxoJTzZ2OM
X-Received: by 2002:adf:fdcc:: with SMTP id i12mr1638516wrs.317.1607346928612;
        Mon, 07 Dec 2020 05:15:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/E42Mjl9lrV3uJy+mcMKaCC0ghVf2euOZZfgnjWsjT11kOCMnAwQ1c7Ca2DexAj4PkQkYFw==
X-Received: by 2002:adf:fdcc:: with SMTP id i12mr1638484wrs.317.1607346928431;
        Mon, 07 Dec 2020 05:15:28 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id a62sm7862008wmh.40.2020.12.07.05.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 05:15:27 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        qemu-s390x@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Cornelia Huck <cohuck@redhat.com>,
        xen-devel@lists.xenproject.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH v3 4/5] gitlab-ci: Add KVM s390x cross-build jobs
Date:   Mon,  7 Dec 2020 14:15:02 +0100
Message-Id: <20201207131503.3858889-5-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207131503.3858889-1-philmd@redhat.com>
References: <20201207131503.3858889-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross-build s390x target with only KVM accelerator enabled.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds.yml | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
index b59516301f4..51896bbc9fb 100644
--- a/.gitlab-ci.d/crossbuilds.yml
+++ b/.gitlab-ci.d/crossbuilds.yml
@@ -1,4 +1,3 @@
-
 .cross_system_build_job:
   stage: build
   image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
@@ -120,6 +119,12 @@ cross-s390x-user:
   variables:
     IMAGE: debian-s390x-cross
 
+cross-s390x-kvm-only:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-s390x-cross
+    ACCEL_CONFIGURE_OPTS: --disable-tcg
+
 cross-win32-system:
   extends: .cross_system_build_job
   variables:
-- 
2.26.2

