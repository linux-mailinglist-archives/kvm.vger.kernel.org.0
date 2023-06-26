Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A75B73E803
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 20:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjFZSUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 14:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjFZSUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 14:20:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890BF10D2
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:20:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bfe92598ffaso5090752276.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 11:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687803627; x=1690395627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DC1JUUoeIHOkdglYQmr1DfzfpGQE2uWlWtSL5MUhKa8=;
        b=xYtXcmWxk0P1fCDcWTRmRHQ213fqB4rQuiXjexvxKc69fWrbx+jG1hAwG0llCkpycZ
         vIxsx2SNm225hbYaBdJVqoTck9XSOJKHlXh8DXvyqKg1GDw5gd8l+hSpY9QBLAiV12RY
         rv75429GaSsLG1+mV89FXylyGQezn4c2bMvPj3UN87MBkxdRUBLLYdkdL6DAdn3RGg72
         VAUFRTosn8/60fdz9qwFv3TJRj28bLsYQui4hfKh76McyD8vBN0+at6FZ+BkOw316Td+
         oESmYoDPXCHZZNA1rzDVevcOJ+5+8ZFPleApgNlncNDFxrTYp6OUsyfuI65KKgKe+AdK
         ayrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687803627; x=1690395627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DC1JUUoeIHOkdglYQmr1DfzfpGQE2uWlWtSL5MUhKa8=;
        b=Ei8nFlRosCI0t3hyIu1LQa1FCc92OX6z+jDaEkG/KrOujPe3S3X7CED0TVLY/ApCR3
         iJFIf4BxFWyQ5wGBDAuq7SkG3nDE7ezC/bFDl0tlqOrwUaeW2durCtuFTk1h9NkUCYvS
         SwxJGP77And2r/K7seknJxdKs5Zgj754ouGuMiQuJt7wA/sDVrRnKWFYMlruzFazSGMr
         mFevNlAS2O6Oe/DsIkbXmTc6Y8I/YxKnB3JiLdCLIdkj5TtGZ0NduazAMrJjBLNH9f1q
         tprkSqCRIv2IkNkMS3K9v0AdohcGOIEYCq52GN9/vKQJpvc9oQeEi7DuzDPTJxxXR2WJ
         guAA==
X-Gm-Message-State: AC+VfDwjQAYEW+tm57A/4VcGpOmKDx9jyrKmg9nrc6mCdqLT1mf2/rcQ
        kaA0em1l2MRbjJK2AppDuJ6W4tbH2yoR
X-Google-Smtp-Source: ACHHUZ488Z5RLeNgsxoRg10Vnlrts0vwlnMOG3/l4w4TY2cIGhoT7SAOtLcxmF27YNT6IpiCb3oib0lZxORJ
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:18c4:b0:c1c:e037:136c with SMTP id
 ck4-20020a05690218c400b00c1ce037136cmr3172718ybb.0.1687803627815; Mon, 26 Jun
 2023 11:20:27 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 26 Jun 2023 18:20:14 +0000
In-Reply-To: <20230626182016.4127366-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230626182016.4127366-1-mizhang@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230626182016.4127366-5-mizhang@google.com>
Subject: [PATCH v2 4/6] KVM: Documentation: Add the missing description for
 tdp_mmu_root_count into kvm_mmu_page
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the description of tdp_mmu_root_count into kvm_mmu_page description.
tdp_mmu_root_count is an atomic counter used only in TDP MMU. Its usage and
meaning is slightly different with root_counter in shadow MMU. Update the
doc.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 Documentation/virt/kvm/x86/mmu.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 5cd6cd5e8926..97d695207e11 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -231,6 +231,11 @@ Shadow pages contain the following information:
     A counter keeping track of how many hardware registers (guest cr3 or
     pdptrs) are now pointing at the page.  While this counter is nonzero, the
     page cannot be destroyed.  See role.invalid.
+  tdp_mmu_root_count:
+    An atomic reference counter in TDP MMU root page that allows for parallel
+    accesses.  Accessing the page requires lifting the counter value. The
+    initial value is set to 2 indicating one reference from vCPU and one
+    from TDP MMU itself. Note this field is a union with root_count.
   parent_ptes:
     The reverse mapping for the pte/ptes pointing at this page's spt. If
     parent_ptes bit 0 is zero, only one spte points at this page and
-- 
2.41.0.162.gfafddb0af9-goog

