Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285B13B3991
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 00:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhFXW4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 18:56:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232300AbhFXW4O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 18:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624575234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7r+X1wvVKiDgmMsGCMuXmUq9oap3F+bJKVEdUAVTkX0=;
        b=MEITQ0R5rLYEv+XxBms/xeHpY+NCuiGz7jxz4f0qo1DdPjfClqJDltjBR7QGSJfQVUk9A7
        yqAEifu/khPp0n59Iy5GKDmIl73mAlsGplW/cVYaRXwFt0KzEJPn7nThBH5AU3Onsz6PU5
        lAwOOnpVxfAMnKbslXM88Hzn52kQTE8=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-WUW9YpjiM2-gE6RLUBaozQ-1; Thu, 24 Jun 2021 18:53:52 -0400
X-MC-Unique: WUW9YpjiM2-gE6RLUBaozQ-1
Received: by mail-il1-f197.google.com with SMTP id g12-20020a056e021a2cb02901dfc46878d8so5011318ile.4
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 15:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7r+X1wvVKiDgmMsGCMuXmUq9oap3F+bJKVEdUAVTkX0=;
        b=UUCX87tse3HkxwZorfVFGh8Lh5gIUhItdM0Sp9lhgNRBf5iUJzCJtSXkUmbTmJEx3n
         ma012AQdiFrxyEydosydKJXrAExC8KvRd/mNkmTUQqHXSP7nZpduxCpB/SmnXK9C4X49
         suKqXvN8+vDd+iR3lT6VtnQ64Cz9GXj47IkfF5UheAFX7b+rzWz5W0oIinBfTtSg/kmB
         ics4dxUAbL4NTpK4hBb3/dpfXIOG5kRLCctkYBbJsPejOiywjIOY/jZO2CLpchXc4nTH
         EsdISI9EGE5qw2l6RAbmkm7DO7P9wbZbp1o2avoAG/dmHVwuG0MJ4RvvOXR1PyHPYaT4
         JpwA==
X-Gm-Message-State: AOAM532bnxMARISBt73CuwmgZ5hqLUhJ1yVBz2CerL6mytosCPxq6EUn
        za/j4vzXnrlfjP9sDzJ0LXZR/f7iApzgdt+Q1QYLQ/RKolUT4HvV8EJoArsCggFHyHPMGaSQo9I
        ghXiOmEIT3HtngK9tF2PAObsSP0G273/wH74zvjvDkbJjbje3Og80I+cbG100/Q==
X-Received: by 2002:a92:c704:: with SMTP id a4mr5388345ilp.157.1624575231862;
        Thu, 24 Jun 2021 15:53:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwT4W+cer0THjmGy28gbUs6250CbTBm3uu+V0S1jl/n5W3lpuvzpMhAaD1iJueN5ox+E0DV4g==
X-Received: by 2002:a92:c704:: with SMTP id a4mr5388326ilp.157.1624575231648;
        Thu, 24 Jun 2021 15:53:51 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id a18sm2355666ilc.31.2021.06.24.15.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 15:53:50 -0700 (PDT)
Date:   Thu, 24 Jun 2021 18:53:49 -0400
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 8/9] KVM: X86: Optimize pte_list_desc with per-array
 counter
Message-ID: <YNUM/W9uXWficCiN@t490s>
References: <20210624181356.10235-1-peterx@redhat.com>
 <20210624181520.11012-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210624181520.11012-1-peterx@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021 at 02:15:20PM -0400, Peter Xu wrote:
> Add a counter field into pte_list_desc, so as to simplify the add/remove/loop
> logic.  E.g., we don't need to loop over the array any more for most reasons.
> 
> This will make more sense after we've switched the array size to be larger
> otherwise the counter will be a waste.
> 
> Initially I wanted to store a tail pointer at the head of the array list so we
> don't need to traverse the list at least for pushing new ones (if without the
> counter we traverse both the list and the array).  However that'll need
> slightly more change without a huge lot benefit, e.g., after we grow entry
> numbers per array the list traversing is not so expensive.
> 
> So let's be simple but still try to get as much benefit as we can with just
> these extra few lines of changes (not to mention the code looks easier too
> without looping over arrays).
> 
> I used the same a test case to fork 500 child and recycle them ("./rmap_fork
> 500" [1]), this patch further speeds up the total fork time of about 14%, which
> is a total of 38% of vanilla kernel:
> 
>         Vanilla:      367.20 (+-4.58%)
>         3->15 slots:  302.00 (+-5.30%)
>         Add counter:  265.20 (+-9.88%)
> 
> [1] https://github.com/xzpeter/clibs/commit/825436f825453de2ea5aaee4bdb1c92281efe5b3
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8888ae291cb9..b21e52dfc27b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -136,10 +136,15 @@ module_param(dbg, bool, 0644);
>  #include <trace/events/kvm.h>
>  
>  /* make pte_list_desc fit well in cache lines */
> -#define PTE_LIST_EXT 15
> +#define PTE_LIST_EXT 14
>  
>  struct pte_list_desc {
>  	u64 *sptes[PTE_LIST_EXT];
> +	/*
> +	 * Stores number of entries stored in the pte_list_desc.  No need to be
> +	 * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
> +	 */
> +	u64 spte_count;
>  	struct pte_list_desc *more;
>  };
>  
> @@ -830,7 +835,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>  			struct kvm_rmap_head *rmap_head)
>  {
>  	struct pte_list_desc *desc;
> -	int i, count = 0;
> +	int count = 0;
>  
>  	if (!rmap_head->val) {
>  		rmap_printk("%p %llx 0->1\n", spte, *spte);
> @@ -840,24 +845,24 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>  		desc = mmu_alloc_pte_list_desc(vcpu);
>  		desc->sptes[0] = (u64 *)rmap_head->val;
>  		desc->sptes[1] = spte;
> +		desc->spte_count = 2;
>  		rmap_head->val = (unsigned long)desc | 1;
>  		++count;
>  	} else {
>  		rmap_printk("%p %llx many->many\n", spte, *spte);
>  		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
> -		while (desc->sptes[PTE_LIST_EXT-1]) {
> +		while (desc->spte_count == PTE_LIST_EXT) {
>  			count += PTE_LIST_EXT;
> -
>  			if (!desc->more) {
>  				desc->more = mmu_alloc_pte_list_desc(vcpu);
>  				desc = desc->more;
> +				desc->spte_count = 0;
>  				break;
>  			}
>  			desc = desc->more;
>  		}
> -		for (i = 0; desc->sptes[i]; ++i)
> -			++count;
> -		desc->sptes[i] = spte;
> +		count += desc->spte_count;
> +		desc->sptes[desc->spte_count++] = spte;
>  	}
>  	return count;
>  }
> @@ -873,8 +878,10 @@ pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
>  		;
>  	desc->sptes[i] = desc->sptes[j];
>  	desc->sptes[j] = NULL;
> +	desc->spte_count--;
>  	if (j != 0)
>  		return;
> +	WARN_ON_ONCE(desc->spte_count);
>  	if (!prev_desc && !desc->more)
>  		rmap_head->val = 0;
>  	else
> @@ -930,7 +937,7 @@ static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
>  unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
>  {
>  	struct pte_list_desc *desc;
> -	unsigned int i, count = 0;
> +	unsigned int count = 0;
>  
>  	if (!rmap_head->val)
>  		return 0;
> @@ -940,8 +947,7 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
>  	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
>  
>  	while (desc) {
> -		for (i = 0; (i < PTE_LIST_EXT) && desc->sptes[i]; i++)
> -			count++;
> +		count += desc->spte_count;
>  		desc = desc->more;
>  	}

I think I still missed another loop in pte_list_desc_remove_entry() that we can
drop.  With some other cleanups, I plan to squash below into this patch too..

---8<---
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 719fb6fd0aa0..2d8c56eb36f8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -872,16 +872,13 @@ pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
                           struct pte_list_desc *desc, int i,
                           struct pte_list_desc *prev_desc)
 {
-       int j;
+       int j = desc->spte_count - 1;
 
-       for (j = PTE_LIST_EXT - 1; !desc->sptes[j] && j > i; --j)
-               ;
        desc->sptes[i] = desc->sptes[j];
        desc->sptes[j] = NULL;
        desc->spte_count--;
-       if (j != 0)
+       if (desc->spte_count)
                return;
-       WARN_ON_ONCE(desc->spte_count);
        if (!prev_desc && !desc->more)
                rmap_head->val = 0;
        else
@@ -913,7 +910,7 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
                desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
                prev_desc = NULL;
                while (desc) {
-                       for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i) {
+                       for (i = 0; i < desc->spte_count; ++i) {
                                if (desc->sptes[i] == spte) {
                                        pte_list_desc_remove_entry(rmap_head,
                                                        desc, i, prev_desc);
---8<---

-- 
Peter Xu

