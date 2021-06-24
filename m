Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC243B3578
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhFXSRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:17:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229464AbhFXSRo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 14:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624558525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EPRr+4E54rGtlJz/D76wpfJoXo3ikBD8ho8wpSiGbNg=;
        b=bG8G7MTPaCcdjWLLTKwzBedmlBHHrS1e967CmMJMOzPSA0RfIjPJZGexk+3Y9W0YBHzhqX
        5PiDz4fRFDZEanQJvDMNFsP283qNfqEv/vQyc3gVZiaCOw23zrFSr3+l4HOzFmtc+fGne5
        hfX9WjRJoKAp3Co4kTBxBjPaV8/vZfM=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-eGG1C3ZYN_as_kHqh5Bnsg-1; Thu, 24 Jun 2021 14:15:23 -0400
X-MC-Unique: eGG1C3ZYN_as_kHqh5Bnsg-1
Received: by mail-il1-f197.google.com with SMTP id f4-20020a056e020c64b02901ee69c9b838so973242ilj.20
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EPRr+4E54rGtlJz/D76wpfJoXo3ikBD8ho8wpSiGbNg=;
        b=gNK+EdM+/OJaAWygLtJJAa1DBKy17TydeDtf0eTidsB5PKkhI2we5wsVPTgaNKdaiI
         5VTmMhiyfdT+41DKPQTkPQ2zeyjxsTFrPZTER/GzPv7yLt4JH9CQtFP5fCZ4Rx76R/Yn
         k+dxishrvpYnUQNi6o2ji1RhdsJ1SsQmsqSKOdJbWCAc99QLbvczF4pEbe1JkKfiXpEh
         HgOThG0t6UL+7CJpf1mz/P8TW0Fgy2ijAcs0U5x8SjWKiIiuFNLm7xHOR4dRKd0z/JCV
         Pej03r4oAsYCoKy+gpfbDXL6ZX/XV4DzYDaIpjAQUr8ilJO9hPIxUEewSizkhrfCOq68
         sORA==
X-Gm-Message-State: AOAM532+890u7+WMPbZiCGXzNXyHNPchM1ZNBppb4EuVT7atXEnTzfLZ
        G7TC6qDpY0skKPbLqcNJq8SK4ZLEROeCUFi3MgGSqFkEpBr/GuFouKuvVcrNkGx2LNcIJIlLDQY
        TedZILr1v0gLUppvx+7MzYAXz0okZNMg6KRr5koVqEul+cpZSllAvFAG7QMxWXw==
X-Received: by 2002:a92:c152:: with SMTP id b18mr4691986ilh.282.1624558522889;
        Thu, 24 Jun 2021 11:15:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAzQfQXv5fiXNI8yt2uL42s+Rc32fWvJNBpFm0hlwRUETW7eXYH/w3gt1HorFD+WZTas4Kyg==
X-Received: by 2002:a92:c152:: with SMTP id b18mr4691963ilh.282.1624558522583;
        Thu, 24 Jun 2021 11:15:22 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id e1sm2340254ilm.7.2021.06.24.11.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:15:22 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 8/9] KVM: X86: Optimize pte_list_desc with per-array counter
Date:   Thu, 24 Jun 2021 14:15:20 -0400
Message-Id: <20210624181520.11012-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624181356.10235-1-peterx@redhat.com>
References: <20210624181356.10235-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a counter field into pte_list_desc, so as to simplify the add/remove/loop
logic.  E.g., we don't need to loop over the array any more for most reasons.

This will make more sense after we've switched the array size to be larger
otherwise the counter will be a waste.

Initially I wanted to store a tail pointer at the head of the array list so we
don't need to traverse the list at least for pushing new ones (if without the
counter we traverse both the list and the array).  However that'll need
slightly more change without a huge lot benefit, e.g., after we grow entry
numbers per array the list traversing is not so expensive.

So let's be simple but still try to get as much benefit as we can with just
these extra few lines of changes (not to mention the code looks easier too
without looping over arrays).

I used the same a test case to fork 500 child and recycle them ("./rmap_fork
500" [1]), this patch further speeds up the total fork time of about 14%, which
is a total of 38% of vanilla kernel:

        Vanilla:      367.20 (+-4.58%)
        3->15 slots:  302.00 (+-5.30%)
        Add counter:  265.20 (+-9.88%)

[1] https://github.com/xzpeter/clibs/commit/825436f825453de2ea5aaee4bdb1c92281efe5b3

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8888ae291cb9..b21e52dfc27b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -136,10 +136,15 @@ module_param(dbg, bool, 0644);
 #include <trace/events/kvm.h>
 
 /* make pte_list_desc fit well in cache lines */
-#define PTE_LIST_EXT 15
+#define PTE_LIST_EXT 14
 
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
+	/*
+	 * Stores number of entries stored in the pte_list_desc.  No need to be
+	 * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
+	 */
+	u64 spte_count;
 	struct pte_list_desc *more;
 };
 
@@ -830,7 +835,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 			struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
-	int i, count = 0;
+	int count = 0;
 
 	if (!rmap_head->val) {
 		rmap_printk("%p %llx 0->1\n", spte, *spte);
@@ -840,24 +845,24 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		desc = mmu_alloc_pte_list_desc(vcpu);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
+		desc->spte_count = 2;
 		rmap_head->val = (unsigned long)desc | 1;
 		++count;
 	} else {
 		rmap_printk("%p %llx many->many\n", spte, *spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-		while (desc->sptes[PTE_LIST_EXT-1]) {
+		while (desc->spte_count == PTE_LIST_EXT) {
 			count += PTE_LIST_EXT;
-
 			if (!desc->more) {
 				desc->more = mmu_alloc_pte_list_desc(vcpu);
 				desc = desc->more;
+				desc->spte_count = 0;
 				break;
 			}
 			desc = desc->more;
 		}
-		for (i = 0; desc->sptes[i]; ++i)
-			++count;
-		desc->sptes[i] = spte;
+		count += desc->spte_count;
+		desc->sptes[desc->spte_count++] = spte;
 	}
 	return count;
 }
@@ -873,8 +878,10 @@ pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
 		;
 	desc->sptes[i] = desc->sptes[j];
 	desc->sptes[j] = NULL;
+	desc->spte_count--;
 	if (j != 0)
 		return;
+	WARN_ON_ONCE(desc->spte_count);
 	if (!prev_desc && !desc->more)
 		rmap_head->val = 0;
 	else
@@ -930,7 +937,7 @@ static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
-	unsigned int i, count = 0;
+	unsigned int count = 0;
 
 	if (!rmap_head->val)
 		return 0;
@@ -940,8 +947,7 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
 
 	while (desc) {
-		for (i = 0; (i < PTE_LIST_EXT) && desc->sptes[i]; i++)
-			count++;
+		count += desc->spte_count;
 		desc = desc->more;
 	}
 
-- 
2.31.1

