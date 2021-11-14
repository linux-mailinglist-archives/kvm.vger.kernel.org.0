Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F19C44F91F
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 17:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhKNQqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 11:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKNQqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 11:46:10 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A09C061746;
        Sun, 14 Nov 2021 08:43:15 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so11215977pjc.4;
        Sun, 14 Nov 2021 08:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Yx8d6qiTYuCnN0n/4csVjohFQlFV+Cv5r3+Yrax2t30=;
        b=a8QTZr46AwVtz5PUDxyaqXCUa/jm7B3dWkrhGhxBCEwi+owkmomrrt6MnRIr8Dymi1
         378Qjas4ER7lzBVfSQebkYha+1w0V09zvl863scqZ0N5uhY9G2gRAbm0YxkUy73m8+ST
         yHyQtUP5ztJZRqoAlrI0DAqNK6SoToQ0rHGCEhUWNeOmTCwQLJ4z78hokc3r0JH1cfm1
         1Snue/MP1iYZAPucvHVpnp86+QN7OgmM3uQ4g3pFGzX8TchEA+luJQEnL/2Kc7Ue7nhh
         XftHTxdT5tPkefsetqBUgYLo/B18u+yZnmZfZobwGnZG9jzYu9LmNZgy+ijuTKrS96o4
         xoow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Yx8d6qiTYuCnN0n/4csVjohFQlFV+Cv5r3+Yrax2t30=;
        b=b6WeVVA2Us0Cd6OmOpeFbkvih5pjNVm/Pt4Qhzyx4eE50bthn/152CFbEuELEFPYZe
         wIUqnWiQ4q0be9RvPKHDwUJCpUZU4gW3yS9eK7NWseeYF+NYXHwNr4gfY3u7BZSvLHHI
         2dtu9VXtkEjB5CdDA2L+dOxNBWd1socTOjnxgHRS/Wh8zSFyv1VbwaUTtwFqT7W47Qso
         gcD3Or6O1IK3bGk/nyoKnKYn517v0lP7qrlf0exS2HlmFrPjE65KByUVi4xX30h95ZCo
         U8c57mH3x6TLV+xs4yJO5/2dan/O+zdQ8+iaao2KSiRc7cHegfLNSJaAYi5+UzhqezZK
         t8KQ==
X-Gm-Message-State: AOAM531GeSwKSgVx+vWWlwuSJrs43XMq6mbs93zOYPvyNGyRpq8btTt+
        xKsibp2ecwvASqnh5tYZI7nFPEE50D/kIQjA
X-Google-Smtp-Source: ABdhPJxnjjKc9stt3/5ghte6UGoRioJVJR72NxEBsPFrhxajNCwAus173Nv6r+zoayrGnlAd5QyGuQ==
X-Received: by 2002:a17:90b:3a83:: with SMTP id om3mr38875639pjb.0.1636908194902;
        Sun, 14 Nov 2021 08:43:14 -0800 (PST)
Received: from makvihas ([103.81.92.175])
        by smtp.gmail.com with ESMTPSA id t15sm12217143pfl.186.2021.11.14.08.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 08:43:14 -0800 (PST)
Date:   Sun, 14 Nov 2021 22:13:12 +0530
From:   Vihas Mak <makvihas@gmail.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: fix cocci warnings
Message-ID: <20211114164312.GA28736@makvihas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

change 0 to false and 1 to true to fix following cocci warnings:

        arch/x86/kvm/mmu/mmu.c:1485:9-10: WARNING: return of 0/1 in function 'kvm_set_pte_rmapp' with return type bool
        arch/x86/kvm/mmu/mmu.c:1636:10-11: WARNING: return of 0/1 in function 'kvm_test_age_rmapp' with return type bool

Signed-off-by: Vihas Mak <makvihas@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/kvm/mmu/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 337943799..2fcea4a78 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1454,7 +1454,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
-	int need_flush = 0;
+	bool need_flush = false;
 	u64 new_spte;
 	kvm_pfn_t new_pfn;
 
@@ -1466,7 +1466,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		rmap_printk("spte %p %llx gfn %llx (%d)\n",
 			    sptep, *sptep, gfn, level);
 
-		need_flush = 1;
+		need_flush = true;
 
 		if (pte_write(pte)) {
 			pte_list_remove(kvm, rmap_head, sptep);
@@ -1482,7 +1482,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 	if (need_flush && kvm_available_flush_tlb_with_range()) {
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
-		return 0;
+		return false;
 	}
 
 	return need_flush;
@@ -1623,8 +1623,8 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 	for_each_rmap_spte(rmap_head, &iter, sptep)
 		if (is_accessed_spte(*sptep))
-			return 1;
-	return 0;
+			return true;
+	return false;
 }
 
 #define RMAP_RECYCLE_THRESHOLD 1000
-- 
2.25.1

