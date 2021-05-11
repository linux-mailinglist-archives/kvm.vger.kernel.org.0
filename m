Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751A037AFEB
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 22:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhEKUFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 16:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhEKUFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 16:05:41 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D210C06174A
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 13:04:32 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x188so16867294pfd.7
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 13:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JsnqFKIC2tGbo9fUD1ZGMSarx8qK1pajpyGE4uvcpZM=;
        b=Ym1qO0z3wRDaV4Gx4Brtsa8x8M8SU+4hIdkXIRpGZrgtJm18UBlQBiNyKGGWWKq59M
         fi+8zW1hssLlj0Kkj3uY2lxK3qkXF3yULAD3iIKGzgT5jp9usBej3WqqAdzQlTK8TAft
         uGjqwoXBMbyYHIbil1nqLb6abMS24h6Bdz2EAx1I0MI7DxAJB/OFbbEe2atP/+KpBo+S
         m1Pu4IoOLll6J2cpH3xSCbBkzmDzoLvZO/YkWGKSxk2SICDz8XTCJ9diu1Fbxj7iAQYr
         w5SBDsU5+rW68vctwmzBuP0xO7PyACduokmPS5JdRJwC+QnauraDSA/lzLMo5uLklV9X
         4zgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JsnqFKIC2tGbo9fUD1ZGMSarx8qK1pajpyGE4uvcpZM=;
        b=H6JtAnIMPM7G3I6IwSThjNBjPdamcLkQItQOdMqpS9BDX8olGnzVw0L1LkX0Jzos07
         ID2HZ17o8Jn04vFcJFGKEdztoZLCtplhlUDfuAhXqNCphJCsvv2mrVHAsUKydCMzXjRb
         oda1bYSghUQNWEYBS9usItjZt3F2znE2DCIaBQG/I+O2ybqPtDVe8pucMO6bqdp8dWOu
         OQiPJpbmXWpa3Lh7QpRR8ZF2y0YXVFv5LYjXxaQOore9WHsx0yzQtKRm7jZx0/mWDfqF
         kJnYm6APSs7xLC6bdflPk5xlPzzfHBcsHsEhcbFqkdu+xxkEnTRIULi1BQE5Lvr+VwFG
         HrJQ==
X-Gm-Message-State: AOAM530rfUDE5KNgv7aJ7Vccf5+2fMZ2aaH2gAARGONqHpdTqxu4pNRX
        KGZYWZMsxusZEDd02VDFAfSLYQ==
X-Google-Smtp-Source: ABdhPJzkA/DT4VnizZ2uwFb1ufZfGOJW1BzZxpSp8cd+f8rP6C1K/K91rH5nVb3bC49PSzlOP0Qm5g==
X-Received: by 2002:a63:465b:: with SMTP id v27mr32643961pgk.445.1620763471537;
        Tue, 11 May 2021 13:04:31 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s14sm1391586pjp.16.2021.05.11.13.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 13:04:31 -0700 (PDT)
Date:   Tue, 11 May 2021 20:04:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v4 7/7] KVM: x86/mmu: Lazily allocate memslot rmaps
Message-ID: <YJrjS/83f7H10HO7@google.com>
References: <20210511171610.170160-1-bgardon@google.com>
 <20210511171610.170160-8-bgardon@google.com>
 <YJrjAt5eyCZQNSkM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJrjAt5eyCZQNSkM@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Sean Christopherson wrote:
> On Tue, May 11, 2021, Ben Gardon wrote:
> > If the TDP MMU is in use, wait to allocate the rmaps until the shadow
> > MMU is actually used. (i.e. a nested VM is launched.) This saves memory
> > equal to 0.2% of guest memory in cases where the TDP MMU is used and
> > there are no nested guests involved.
> > 
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/mmu/mmu.c          | 53 +++++++++++++++++++++++----------
> >  arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++--
> >  arch/x86/kvm/mmu/tdp_mmu.h      |  4 +--
> >  arch/x86/kvm/x86.c              | 45 +++++++++++++++++++++++++++-
> >  5 files changed, 89 insertions(+), 21 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index fc75ed49bfee..7b65f82ade1c 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1868,4 +1868,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
> >  
> >  int kvm_cpu_dirty_log_size(void);
> >  
> > +int alloc_all_memslots_rmaps(struct kvm *kvm);
> > +
> >  #endif /* _ASM_X86_KVM_HOST_H */
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index b0bdb924d519..183afccd2944 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1190,7 +1190,8 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
> >  		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
> >  				slot->base_gfn + gfn_offset, mask, true);
> >  
> > -	if (!kvm->arch.memslots_have_rmaps)
> > +	/* Read memslots_have_rmaps before the rmaps themselves */
> 
> IIRC, you open coded reading memslots_have_rmaps because of a circular
> dependency, but you can solve that simply by defining the helper in mmu.h
> instead of kvm_host.h.
> 
> And I think you could even make it static in mmu.c and omit the smp_load_acuquire
> from the three users in x86.c, though that's probably not worth it.
> 
> Either way, reading the same comment over and over and over, just to make
> checkpatch happy, gets more than a bit tedious.
> 
> That would also allow you to elaborate on why the smp_load_acquire() is
> necessary, and preferably what it pairs with.

Belated thought: you could also introduce the helper in patch 06 in order to
miminize thrash in this patch.
