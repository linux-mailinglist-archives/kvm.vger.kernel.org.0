Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C1A76A573
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 02:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjHAAVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 20:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjHAAVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 20:21:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEECD19A4
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so3911684276.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 17:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690849295; x=1691454095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X6gKOGhlGB8pLW0DYtQuv9ffBJaXjDy6pmjMuBOFYgg=;
        b=kQoqrjZUSpYSVWxRkD8CyHapEmqNssIKnU0p8DbOeOtORHqvQa2sRcXhVsWCzU4YXH
         zZKas3OblcCNpHead2nGTkpMYThMQMfZeHh41WgRE1hPLNiwbHntVRxHiv/NqnNsu6We
         KNZIuYEWFnyjDmvXcOy5RwHVYQaGudAGf1nLCyRoZSHMxNSpdZrY7aU4AzRIfp1+8ha8
         gqHlW5ZZCXCmF7ZW8oxl02SvyyCRoY3Egwy9Mv5L85kKyaSF/yQkV7Trl0FnFZ+9EL1R
         mMTvAT/jSm6uCb3HkZgyPqa4An9p+T65XcE0u04cE0v+XXg1hINDwPuIhtIjwA+Za4dr
         /fEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690849295; x=1691454095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X6gKOGhlGB8pLW0DYtQuv9ffBJaXjDy6pmjMuBOFYgg=;
        b=fScxLYzKlc2/v3WDSCf6rl8n/F91A9wd9GMMH46fFPOFrDRDDtXyDEWDxMkilzLfgx
         FZgxXbauaGwhcH0y93eiK2dX9tPz6ZXi4EhnXCVP0xkNvI2qNsox6N9WW/Ug3KUW06Cx
         4dpJIgaErOTA/KsZ0EImh7ByNvm6D6bxXPi6Jj37Y7M4xeggoQ1G2Qeuz/Mnd5vvFL02
         11F/mERIGY0MRhYCNlRSUAnsKUYqolH4gM4VRezqqR/cxKcto0/TJqiutpm/BKMtVUJx
         z4CP2eCmbLaRwJBr/XOPWOb7TOKwe/y3D/kdqutHbxRkZAw0GzMA2fCIzGUQtV/Nk9RE
         NwjA==
X-Gm-Message-State: ABy/qLavUe6T8aUW2YHi3dnbDBagfSIC4OIzK6xuuyWX7qlUfC7TOOTY
        +HhCl/1ibTKec7FfkWOap4KjFta0JPjx
X-Google-Smtp-Source: APBJJlGQXpt19T8IbJ/4u2FYTII6o/ixlgwOW+5f/+XsCEFskp5UWl0qK1dtlRzD0c0+xHtP+LDk5mW3oGkO
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:11ca:b0:d09:b19:fe2c with SMTP id
 n10-20020a05690211ca00b00d090b19fe2cmr70907ybu.12.1690849294946; Mon, 31 Jul
 2023 17:21:34 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  1 Aug 2023 00:21:23 +0000
In-Reply-To: <20230801002127.534020-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230801002127.534020-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801002127.534020-4-mizhang@google.com>
Subject: [PATCH v3 3/6] KVM: Documentation: Add the missing description for
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 35e642303962..17d90974204e 100644
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
2.41.0.585.gd2178a4bd4-goog

