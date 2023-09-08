Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC74798B87
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 19:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245084AbjIHRhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 13:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjIHRhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 13:37:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EA71FE2
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 10:37:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7b980794easo2144571276.2
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 10:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694194619; x=1694799419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6nicQbI8zy2fRwaqSHLwr5Q5Poe1yZSBcRJgMX/w6Yc=;
        b=kpV+s+xEMc8y5ViCeFZWC5IJydaAjZzHAq1g5khESAaq1qiLBL/uXWZFpFSuCcZiT6
         r8zA9iK0dgwsCLQXEL1mFUAvRP/xKRgVkqoqq9lRkJ0Y9L7FTmtad00k6U9YARIAXXrk
         gv6TQO1JM3Lc0pD+iLUgqtahHtAQlnE68QhQ/jO9AOmj7T1m1DhcDwiWd+kaYiEeSitl
         yGi6vTSGqPxxsz45seqDL53GFplRMVkX6VLFwGoHy/HQ7lJhnXtO1BbCK8TiaeK2YnAy
         a2Pmyq1UcDh0M8bKjgN9m7k6/mCsDYhfEBc1p0w8X4qSEz9Ymai3pT+aCxAKrAuwwdzu
         WgGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694194619; x=1694799419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nicQbI8zy2fRwaqSHLwr5Q5Poe1yZSBcRJgMX/w6Yc=;
        b=OPRUReX282xy8O1fpct51FagKkJiwvXhunV1dq38WB4+Y+fAGQob10ztyowmS9iUxh
         4qn2Ksnj2uDxDoISI+23fhQrSkgR/A1FWI+FclZ5MBDmhd84QDyb7tRaF0WBG+hiBPLv
         TpFryBM5gOIlQL4I+J6L2eTN87byzxfNKr9X1LFaxU9c6Dr4YmALUzYYM5sgARpTvsZG
         cIXlIswHOQjxh6QsrKoCRFasT/UEW5CAWzWJlBNJ9+XRGryPPD9vKr84FD1UKrtwdq/a
         V2jtKl91FcXcw0yQar4vqdDiUOPPAZ8S8ZuWn6ZhqYe2XTd6UEYf4+LKHhGAvdOG8Vw1
         ExBA==
X-Gm-Message-State: AOJu0Yw9WEpymJymvxLzxGzYEvOxaVQZHtyGJBnoQy768YKVw5pPnNs8
        a2+ojpW0wo8/bULRVgPN3+qBYQ21UhE=
X-Google-Smtp-Source: AGHT+IEOPRoZ696kU3Oabw4/49onsj3NOwtlodStbyApow+uZGU16RJTFgSztx+IhLDi6NvRyziDQXB/ZO0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dad6:0:b0:d0c:c83b:94ed with SMTP id
 n205-20020a25dad6000000b00d0cc83b94edmr70393ybf.10.1694194619480; Fri, 08 Sep
 2023 10:36:59 -0700 (PDT)
Date:   Fri, 8 Sep 2023 10:36:57 -0700
In-Reply-To: <01d077d89d22cce541784be25c2f5c2143f8b5da.camel@intel.com>
Mime-Version: 1.0
References: <20230825020733.2849862-1-seanjc@google.com> <20230825020733.2849862-2-seanjc@google.com>
 <01d077d89d22cce541784be25c2f5c2143f8b5da.camel@intel.com>
Message-ID: <ZPtVF5KKxLhMj58n@google.com>
Subject: Re: [PATCH 1/2] KVM: Allow calling mmu_invalidate_retry_hva() without
 holding mmu_lock
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Y Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 07, 2023, Kai Huang wrote:
> On Thu, 2023-08-24 at 19:07 -0700, Sean Christopherson wrote:
> > Allow checking mmu_invalidate_retry_hva() without holding mmu_lock, even
> > though mmu_lock must be held to guarantee correctness, i.e. to avoid
> > false negatives.  Dropping the requirement that mmu_lock be held will
> > allow pre-checking for retry before acquiring mmu_lock, e.g. to avoid
> > contending mmu_lock when the guest is accessing a range that is being
> > invalidated by the host.
> > 
> > Contending mmu_lock can have severe negative side effects for x86's TDP
> > MMU when running on preemptible kernels, as KVM will yield from the
> > zapping task (holds mmu_lock for write) when there is lock contention,
> > and yielding after any SPTEs have been zapped requires a VM-scoped TLB
> > flush.
> > 
> > Wrap mmu_invalidate_in_progress in READ_ONCE() to ensure that calling
> > mmu_invalidate_retry_hva() in a loop won't put KVM into an infinite loop,
> > e.g. due to caching the in-progress flag and never seeing it go to '0'.
> > 
> > Force a load of mmu_invalidate_seq as well, even though it isn't strictly
> > necessary to avoid an infinite loop, as doing so improves the probability
> > that KVM will detect an invalidation that already completed before
> > acquiring mmu_lock and bailing anyways.
> 
> Without the READ_ONCE() on mmu_invalidate_seq, with patch 2 and
> mmu_invalidate_retry_hva() inlined IIUC the kvm_faultin_pfn() can look like
> this:
> 
> 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;		<-- (1)
> 	smp_rmb();
> 
> 	...
> 	READ_ONCE(vcpu->kvm->mmu_invalidate_in_progress);
> 	...
> 
> 	if (vcpu->kvm->mmu_invalidate_seq != fault->mmu_seq)	<-- (2)
> 		...
> 
> Perhaps stupid question :-) Will compiler even believes both vcpu->kvm-
> >mmu_invaludate_seq and fault->mmu_seq are never changed thus eliminates the
> code in 1) and 2)?  Or all the barriers between are enough to prevent compiler

Practically speaking, no, there's far too much going on in __kvm_faultin_pfn().

But, KVM _could_ do the freshness check before __kvm_faultin_pfn() since KVM
has the memslot and thus the host virtual addess at that point.  I highly doubt
we'll ever do that, but it's possible.  At that point, there'd be no spinlocks
or other barries to ensure the load+check wouldn't get elided.  That's still
extremely theoretical though.

1) can't be eliminated because acquiring mmu_lock provides enough barries to
prevent the compiler from omitting the load, i.e. the compiler can't omit the
comparison that done inside the critical section.  (2) can theoretically be optimized
away by the compiler (when called before acquiring mmu_lock), though it's extremely
unlikely since there's sooo much going on between the load and the check.

> > Note, adding READ_ONCE() isn't entirely free, e.g. on x86, the READ_ONCE()
> > may generate a load into a register instead of doing a direct comparison
> > (MOV+TEST+Jcc instead of CMP+Jcc), but practically speaking the added cost
> > is a few bytes of code and maaaaybe a cycle or three.

...

> > -	if (kvm->mmu_invalidate_seq != mmu_seq)
> > +
> > +	if (READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq)
> >  		return 1;
> >  	return 0;
> >  }
> 
> I am not sure how mmu_invalidate_retry_hva() can be called in a loop so looks
> all those should be theoretical thing, but the extra cost should be nearly empty
> as you said.

It's not currently called in a loop, but it wouldn't be wrong for KVM to do
something like the below instead of fully re-entering the guest, in which case
mmu_invalidate_retry_hva() would be called in a loop, just a big loop :-)

And if KVM checked for freshness before resolving the PFN, it'd be possible for
the loop to read and check the sequence in the loop without any barriers that would
guarantee a reload (again, very, very theoretically).

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e340098d034..c7617991e290 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5725,11 +5725,13 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
        }
 
        if (r == RET_PF_INVALID) {
-               r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-                                         lower_32_bits(error_code), false,
-                                         &emulation_type);
-               if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
-                       return -EIO;
+               do {
+                       r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
+                                                 lower_32_bits(error_code),
+                                                 false, &emulation_type);
+                       if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
+                               return -EIO;
+               while (r == RET_PF_RETRY);
        }
 
        if (r < 0)

