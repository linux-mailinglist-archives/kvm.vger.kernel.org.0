Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005272D11AA
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 14:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgLGNRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 08:17:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726076AbgLGNRF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 08:17:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607346938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6EJ4iyK07Ty3dzRyIkzOuiJNHq5RuTRyKsBVarixwBA=;
        b=IHyMtIXD7TANrj3jfNr05Jy4SgPy//KTjAZzakE8dyMMy6rrFboFhpiz1oslqSDQ2Wj8aZ
        ga7hyqa9+aUP2uZXK6dGeV8/vm8b4Tkdm8UuZaascv+3vbHcNXJNNU72zvS9KWb5uiwd8j
        fAuaSsErcCYSMvcyn7SpGl3DQrwm5gA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-5Ldi9ZuTOIqXt_sQBh6ZYA-1; Mon, 07 Dec 2020 08:15:35 -0500
X-MC-Unique: 5Ldi9ZuTOIqXt_sQBh6ZYA-1
Received: by mail-wm1-f71.google.com with SMTP id u123so4118568wmu.5
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 05:15:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6EJ4iyK07Ty3dzRyIkzOuiJNHq5RuTRyKsBVarixwBA=;
        b=o+1KVaWp7VNF1Y/lPTI+eari0S6Rp3NJeuF6o7s+HojV+bGogjBZycJdKZhZUOxJZW
         aQCA3NFw53CZNR3xJdcsR9XfIFV0+8gRFCY0Eo5G4xtGDpGTl+gjltzhnKQ22j8gbTz8
         gmQoYDiEcTLSRQvAtyNPime/pxjbDz9cOE0zS5tTJs4uEfJFs87n7S343W1etSM9ArsN
         q3wmGTRhptQVXXuPLumeURbvCZtffRIAbMo/mOOJKJ/jqoln33lSKo02rJZK0pd6vuCg
         +CcjmLRU8JOc7pfn7SHgnzR0JURBkldABNOLHrEznnhvSrqzLP8BREelJaFARE03oGu6
         AziQ==
X-Gm-Message-State: AOAM531Y/rxxOOOueKz9Jlr3r+dggl5aPkVnN4T0qitG9yx+9BE/iscK
        ZHeVMMUAuOFTOLimp++Ka0W26KUD6stNINSiU00vEm8MPIKky6C/srdCkS7Qb0MHEWdBsOhvnPr
        CijcXeHBYsVkR
X-Received: by 2002:a5d:4c49:: with SMTP id n9mr20011857wrt.30.1607346934122;
        Mon, 07 Dec 2020 05:15:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9XTTmfTlfqcd6ffk3O9VyZaaUJTIkcE7tELrfEhCU+PvMWzkv9xF2oA2F54WLRjz0+k84yQ==
X-Received: by 2002:a5d:4c49:: with SMTP id n9mr20011839wrt.30.1607346933986;
        Mon, 07 Dec 2020 05:15:33 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id c190sm14567845wme.19.2020.12.07.05.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 05:15:33 -0800 (PST)
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
Subject: [PATCH v3 5/5] gitlab-ci: Add Xen cross-build jobs
Date:   Mon,  7 Dec 2020 14:15:03 +0100
Message-Id: <20201207131503.3858889-6-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207131503.3858889-1-philmd@redhat.com>
References: <20201207131503.3858889-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cross-build ARM and X86 targets with only Xen accelerator enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.d/crossbuilds.yml | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
index 51896bbc9fb..bd6473a75a7 100644
--- a/.gitlab-ci.d/crossbuilds.yml
+++ b/.gitlab-ci.d/crossbuilds.yml
@@ -134,3 +134,17 @@ cross-win64-system:
   extends: .cross_system_build_job
   variables:
     IMAGE: fedora-win64-cross
+
+cross-amd64-xen-only:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-amd64-cross
+    ACCEL: xen
+    ACCEL_CONFIGURE_OPTS: --disable-tcg --disable-kvm
+
+cross-arm64-xen-only:
+  extends: .cross_accel_build_job
+  variables:
+    IMAGE: debian-arm64-cross
+    ACCEL: xen
+    ACCEL_CONFIGURE_OPTS: --disable-tcg --disable-kvm
-- 
2.26.2

