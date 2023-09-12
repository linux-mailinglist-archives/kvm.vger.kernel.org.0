Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0815B79D8EF
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 20:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237494AbjILSqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 14:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237492AbjILSqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 14:46:06 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C6310F4
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 11:46:02 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-267f00f6876so7058297a91.3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 11:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694544362; x=1695149162; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mMn9wfgwSNeBQXqC1xBrAj9DL3zD7p3ffh9VRzzCD10=;
        b=S3Rp41f5pj9Xq0M0JICGfaFghn6ICKnxgTM9yCGAeXmGyJlC44I732tpv1fT+chYcQ
         ZDtTodqENBFq1gDBu65cXYQvK9sjFeu+gm/exz1DJ3Rvpqhcz6hbBkrI0hSn9j/4eUE8
         CJq9qtA0y6x3jnfuta+LmY5WQeTrbxalxrFavt4DsyRKKQ2rFTrvZEwyDp9sNlCNp6oV
         daau+6OQLLmTIq3dNVmRIohVO9tVZkThMw3Gyh3VrtML9u+e05ppukjKjI7ElQlo4Y8F
         TtQzpcBTL7Hm4Kv0g9CJJLm2SlwkKZHsFMrwu6T383d+kYoZwAK8ZhngosHyqRYq6Xsd
         FPXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694544362; x=1695149162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mMn9wfgwSNeBQXqC1xBrAj9DL3zD7p3ffh9VRzzCD10=;
        b=p/efavnfSOTAOJXkb05steYpzgyQ1hG4IC7n9jgb8VkB5AbovUdCTL3yzoCdW/zc6I
         fo56ARGRxArvrmKuxOmbQTvcCxZR4QSM8FyYdM8L1llsOkIXyhOwbtQuz7h2DBe14684
         nw+mxeIdEHmr3eTyf0PtfARiLNt8SNDoN+Y4TA2UQC0OWsjAQwcRWMEddx1qVMMqMQaF
         NoisUxi+lGbkJ6dLO81RM70PIjkV3loSfWmF3nqLmhpVD5sNXaFOUKpCg0NwyMd1Jlov
         dfdFTsg0OZAeguJHO45N+YGr//yGNwdZM8MHTWacJVgbM70IBiPWKO/fH6OZYtfwnPbO
         1rYQ==
X-Gm-Message-State: AOJu0YxrRlduLkq8Hf2jSkHHih8RbmhhV3CTjaSaXxyfzORPkwulSFYR
        hmjDYw3WDAVABMbGlz1qnbLpSBld12NC
X-Google-Smtp-Source: AGHT+IH2ju4PxTOUbeBNOmPUAvNt/h8Wx/ykN1r+31ERSCan0rZqj213XzGxPXFcP/vgRsmo6KWk3swmsvTL
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:90b:110a:b0:268:2de3:e6b2 with SMTP id
 gi10-20020a17090b110a00b002682de3e6b2mr2664pjb.5.1694544361761; Tue, 12 Sep
 2023 11:46:01 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 12 Sep 2023 18:45:50 +0000
In-Reply-To: <20230912184553.1887764-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230912184553.1887764-1-mizhang@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230912184553.1887764-4-mizhang@google.com>
Subject: [PATCH v4 3/6] KVM: Documentation: Add the missing description for
 ptep in kvm_mmu_page
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the missing description for ptep in kvm_mmu_page description. ptep is
used when TDP MMU is enabled and it shares the storage with parent_ptes.
Update the doc to help readers to get up-to-date info.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index f659f282357d..22d221c180d7 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -239,6 +239,9 @@ Shadow pages contain the following information:
     parent_ptes points at this single spte, otherwise, there exists multiple
     sptes pointing at this page and (parent_ptes & ~0x1) points at a data
     structure with a list of parent sptes.
+  ptep:
+    The kernel virtual address of the SPTE that points at this shadow page.
+    Used exclusively by the TDP MMU, this field is a union with parent_ptes.
   unsync:
     If true, then the translations in this page may not match the guest's
     translation.  This is equivalent to the state of the tlb when a pte is
-- 
2.42.0.283.g2d96d420d3-goog

