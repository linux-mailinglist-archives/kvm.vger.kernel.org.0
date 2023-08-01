Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13E476A579
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 02:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjHAAVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 20:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjHAAVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 20:21:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762061BC9
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d0d27cd9db9so9401245276.0
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690849298; x=1691454098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lAQnhGDOkYRMbkZrdC3SL5zoWbQR4X7L8Yn3+Vr770Y=;
        b=mSlCLmLdSdPxkircK3iN8jwT5W5vP1eDs51MN2JElm1ENf0E0zV1+hxVIqVpBj8Lbq
         3YbA2/WyG5K4xCuq9Coj3iUMdMibr4FQcUpL6vKn/cEb0mcK+XtbQBYhpoD1utE9R/hw
         sNnyB6mq7sHFk+jZtZuvaN58hRjds+AE8Y+onHTyMUrpDQcsvWZDQTAAoX0qYG6i2kei
         BlqqustZeYnIPg8lYc6HCZmKcoW3EI/AsWv3P+mg4OOKdmJfb1bjcImHHRWilDTHx0WD
         OiGbBfE4+wE/VlffLCEkwsxzLb7nSfkAHH9Dkh8+py9OmsUsIBcfhvxGec3zqaWc+OQH
         1g3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690849298; x=1691454098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lAQnhGDOkYRMbkZrdC3SL5zoWbQR4X7L8Yn3+Vr770Y=;
        b=DVLvdwqRBoBMLp1mUp1YppAMHz6bL14tO+0RA5k5daN4y9cfxXR7R46ka127rJTwRI
         BAKOUB5Lqy4EhTngbXey8ePbu2hPLhGCo2yECW1rWeP8eqmM/riVRsTjcmvIcq2K4dXf
         u8DDKIrHH3RNiSFYX9spe0be0mkhk2PJrEDdtoQ2lNQrlKYYpcbLQixpteskfeMSYWxj
         y2ct56MvIAQ++TXEbclpLrHgiksiy6P4lysP9Fa9zd1X7O7nLDhh3mvHH2I28hbiilfd
         82+1wdyZbvmp7UAW0F8SU8mNekB+OxfIsThlxMJl8v0dP899YPJOGBsYBfOmZA8plWff
         /Jeg==
X-Gm-Message-State: ABy/qLYvb45Cst5cQXWzzY4i+JVz61BGxew6m7ahwvkQo2uY5pK6qPfi
        9QXTzVt+wcwHs2XODRiwefioN/lMUBNV
X-Google-Smtp-Source: APBJJlEbXDgaPfEPE0+Rh+gqu5EcA7wjOaPwSG51qBZAvMseTavHv77hIuRMa7UCmBrdjjzh7UNZF7RaBIf5
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a25:dfc3:0:b0:d15:53b5:509f with SMTP id
 w186-20020a25dfc3000000b00d1553b5509fmr119752ybg.2.1690849298640; Mon, 31 Jul
 2023 17:21:38 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  1 Aug 2023 00:21:25 +0000
In-Reply-To: <20230801002127.534020-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230801002127.534020-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801002127.534020-6-mizhang@google.com>
Subject: [PATCH v3 5/6] KVM: Documentation: Add the missing description for
 mmu_valid_gen into kvm_mmu_page
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the description for mmu_valid_gen into kvm_mmu_page description.
mmu_valid_gen is used in shadow MMU for fast zapping. Update the doc to
reflect that.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 40daf8beb9b1..581e53fa00a2 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -208,6 +208,16 @@ Shadow pages contain the following information:
     The page is not backed by a guest page table, but its first entry
     points to one.  This is set if NPT uses 5-level page tables (host
     CR4.LA57=1) and is shadowing L1's 4-level NPT (L1 CR4.LA57=1).
+  mmu_valid_gen:
+    The MMU generation of this page, used to fast zap of all MMU pages within a
+    VM without blocking vCPUs. Specifically, KVM updates the per-VM valid MMU
+    generation which causes the mismatch of mmu_valid_gen for each mmu page.
+    This makes all existing MMU pages obsolete. Obsolete pages can't be used.
+    Therefore, vCPUs must load a new, valid root before re-entering the guest.
+    The MMU generation is only ever '0' or '1'.  Note, the TDP MMU doesn't use
+    this field as non-root TDP MMU pages are reachable only from their owning
+    root.  Thus it suffices for TDP MMU to use role.invalid in root pages to
+    invalidate all MMU pages.
   gfn:
     Either the guest page table containing the translations shadowed by this
     page, or the base page frame for linear translations.  See role.direct.
-- 
2.41.0.585.gd2178a4bd4-goog

