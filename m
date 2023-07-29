Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A21B767B43
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237747AbjG2Biu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbjG2BiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:38:13 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164FA4EDD
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb98659f3cso18398745ad.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594600; x=1691199400;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DwvbUo0YFwD2y5U7V+bjb1xFYzZ0nLkltBIeETbMd6E=;
        b=Ge68nujbq9a2/5qupOk7vKqq3XlDn5p8ntiVpmK47hZYN+/QS4qy0wLj6mzi//Ln3N
         bjIWafKzZtkd8LQqhjRdZON3HDXB5fCK9FhlneYcw4v+xtAWX9E4CPS0ddxUxM1BU+ou
         uqsJv3tEk+OkpS9BfP1CupF2QdoKOH02fs1K3Ib89GUvvYmRfPRX9GXq8Qk6hWUr/tNP
         U7vyKG8jPeUgErUAu/w48/FjAGWgL+fFw7j74vkaZbaqjcBqf1vC9GEbvdtcM9pxV6mC
         P1Ioi1DZwQV+4ATKOYarBouEJgAG/V3mHWk+Hvgxt1vW2YDRiU63dl0VSgEIpd2po20a
         NDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594600; x=1691199400;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DwvbUo0YFwD2y5U7V+bjb1xFYzZ0nLkltBIeETbMd6E=;
        b=fiyM1hwU2lYGDMoWXn9I4dkak1Aro1f10UuA0fxKTBF1NSf4xEIGf2cYaMXlTEV9Ta
         F+uHwIlqNgvTps8w/TzuA1o0w3zr9G+Q3cqMWZWMN3SVnOWWHR10ebXrOc66pVTRXNav
         jwgQaJc057C+mPTns4kBBd+bIzWBcymkMkONkkAQdpw4yN1ivpOzCeYJs5Bkbsy8Z2oP
         a+eJE22v8O3JZ0p90aiwfqiHKU2xbVJakAnoCV3s/+nrduIgWwBuED16zAia27esVeo2
         pouHdES0Y782ZzvA5zvZFjqVo301mnz/5jxJtNhL+FGkt1XJumjULdUIBRSzZPBwjgxs
         7OPw==
X-Gm-Message-State: ABy/qLbBOPX+2PGqCwZbfUnc1Mh7eHjf6AnnIeuxRpYOrD1HxwcIOy05
        ADn4BPCzpgDZ2Vuo64G0JTaUMigDO6M=
X-Google-Smtp-Source: APBJJlEZ24/UIUc9lE3mpH4b4NTm9trjEBiNa0Xf1jgeOJ+PFmgDRd7JQ2suy7GGPER95kXMryrtDNI0qhM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da83:b0:1b3:c62d:71b5 with SMTP id
 j3-20020a170902da8300b001b3c62d71b5mr12428plx.0.1690594599204; Fri, 28 Jul
 2023 18:36:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:35 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-30-seanjc@google.com>
Subject: [PATCH v4 29/29] drm/i915/gvt: Drop final dependencies on KVM
 internal details
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Open code gpa_to_gfn() in kvmgt_page_track_write() and drop KVMGT's
dependency on kvm_host.h, i.e. include only kvm_page_track.h.  KVMGT
assumes "gfn == gpa >> PAGE_SHIFT" all over the place, including a few
lines below in the same function with the same gpa, i.e. there's no
reason to use KVM's helper for this one case.

No functional change intended.

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/gvt.h   | 3 ++-
 drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 2d65800d8e93..53a0a42a50db 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -34,10 +34,11 @@
 #define _GVT_H_
 
 #include <uapi/linux/pci_regs.h>
-#include <linux/kvm_host.h>
 #include <linux/vfio.h>
 #include <linux/mdev.h>
 
+#include <asm/kvm_page_track.h>
+
 #include "i915_drv.h"
 #include "intel_gvt.h"
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index eb50997dd369..aaed3969f204 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1585,7 +1585,7 @@ static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
 
 	mutex_lock(&info->vgpu_lock);
 
-	if (kvmgt_gfn_is_write_protected(info, gpa_to_gfn(gpa)))
+	if (kvmgt_gfn_is_write_protected(info, gpa >> PAGE_SHIFT))
 		intel_vgpu_page_track_handler(info, gpa,
 						     (void *)val, len);
 
-- 
2.41.0.487.g6d72f3e995-goog

