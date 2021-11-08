Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C4A449CC4
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 20:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbhKHUA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 15:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbhKHUA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 15:00:26 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF4EC061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 11:57:41 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id p18so16488938plf.13
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 11:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uKuF9bbT81/P0oenKbP52XhMdwY9YYs+WYE+Jh8MuG0=;
        b=eNc9L++fnv1teWIStDw66jKdnvXbCwbRTGweeUXUaebba9Cv/xKRCTg/D8Jd/wLc2v
         74ktCY0UXSvfohxcXgMknCuSNTOCgHtJ+kKmsoHknlf9OyNHRKXXcHfytVTbiGoRPCZm
         1WEM3DPagLTAje3rEo0XePbhMSmt6kDXo4VCt5vj5eS5yYMF0g3I3YJLVpqWn7ZyDsrl
         Jy4QPO4FyBZuliLSscNM9KzEuqkjZTnTcb23ylz3GGeabmZAr/d16yE1xrNxST0PkGv7
         tJRSB6Y2wP7yt5bwBODpUlAvr0Znx8HNw+zTudTRfZEzQYAmGqvTrmXU4SdboFbRGz1n
         nVUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uKuF9bbT81/P0oenKbP52XhMdwY9YYs+WYE+Jh8MuG0=;
        b=n0WhPRCFf7V0d54jgXDcMRI9qDrBh2Xskm/ojxZRw8X8pHpSkgWdUie7yjlG/GbwX5
         Ho+r03jFY6SjKaNxoLQZr8GS/FJ3yyUiwPvxXQ9MWIW16tm75g6R18TvPfh9KoFBaFIT
         Z0u7HM/yR0ogplJDU3cweY4X4x7WdYWZTwngUl4BQBwvzyeHA0XK71DGIZ4vkfBr+02r
         49q5HrXve8gg7lNhF6MwDDf/kOjXAfGWIHRP+ycfAwordSlBv5Ic91nrlRrzSS+xy0v8
         nnsXx8FMqwAtauKU6Gdcmdm9jkjIyuzlmnGIxfP+ADLJ+ndje3Q/ydpOKNjZ/jsiwhjz
         U+7A==
X-Gm-Message-State: AOAM533x+MO47QGXVxzFqW3fXZeyMqlA6BYKvh4PDYOb+J+8ltIX9Ewj
        u6mRw9KnK6P50xX1wevAfbRC6Q==
X-Google-Smtp-Source: ABdhPJwKca/Q29YBkTop5csJv+O+De4g5b4hzMudc6VRMqFfTxKZvZPYXjQEjm+3PDAJy+KOw99lFg==
X-Received: by 2002:a17:903:22cc:b0:142:d31:bd9 with SMTP id y12-20020a17090322cc00b001420d310bd9mr1571784plg.64.1636401460481;
        Mon, 08 Nov 2021 11:57:40 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id c25sm16029057pfn.159.2021.11.08.11.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 11:57:39 -0800 (PST)
Date:   Mon, 8 Nov 2021 19:57:36 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Subject: Re: RFC: KVM: x86/mmu: Eager Page Splitting
Message-ID: <YYmBMGvU/kthFiM9@google.com>
References: <CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com>
 <c9bd3bca-f901-d8db-c23d-5292ab7bd247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9bd3bca-f901-d8db-c23d-5292ab7bd247@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 05, 2021 at 09:44:14AM +0100, Paolo Bonzini wrote:
> On 11/4/21 23:45, David Matlack wrote:
> > The goal of this RFC is to get feedback on "Eager Page Splitting",
> > an optimization that has been in use in Google Cloud since 2016 to
> > reduce the performance impact of live migration on customer workloads.
> > We wanted to get feedback on the feature before delving too far into
> > porting it to the latest upstream kernel for submission.
> > If there is interest in adding this feature to KVM we plan to follow
> > up in the coming months with patches.
> 
> Hi David!
> 
> I'm definitely interested in eager page splitting upstream, but with a
> twist: in order to limit the proliferation of knobs, I would rather
> enable it only when KVM_DIRTY_LOG_INITIALLY_SET is set, and do the split
> on the first KVM_CLEAR_DIRTY_LOG ioctl.
> 
> Initially-all-set does not require write protection when dirty logging
> is enabled; instead, it delays write protection to the first
> KVM_CLEAR_DIRTY_LOG.  In fact, I believe that eager page splitting can
> be enabled unconditionally for initial-all-set.  You would still have
> the benefit of moving the page splitting out of the vCPU run
> path; and because you can smear the cost of splitting over multiple
> calls, most of the disadvantages go away.

Splitting on the first call to KVM_CLEAR_DIRTY_LOG when
initially-all-set is enabled sounds fine to me. But it does require
extra complexity versus unconditionally eager splitting the entire
memslot when dirty logging is enabled, which (I now realize) is needed
to support the ring buffer method. More below...

> 
> Initially-all-set is already the best-performing method for bitmap-based
> dirty page tracking, so it makes sense to focus on it.  Even if Google
> might not be using initial-all-set internally, adding eager page
> splitting to the upstream code would remove most of the delta related to
> it.  The rest of the delta can be tackled later;

Yeah we are still using the legacy clear-on-get-dirty interface.
Upstreaming eager page splitting for initially-all-set would address
most of the delta and give us extra motivation to switch off of
clear-on-get-dirty :).

> I'm not super
> interested in adding eager page splitting for the older methods (clear
> on KVM_GET_DIRTY_LOG, and manual-clear without initially-all-set), but
> it should be useful for the ring buffer method and that *should* share
> most of the code with the older methods.

Using Eager Page Splitting with the ring buffer method would require
splitting the entire memslot when dirty logging is enabled for that
memslot right? Are you saying we should do that?

i.e. in kvm_mmu_slot_apply_flags we'd have something like:

        if (kvm->dirty_ring_size)
                kvm_slot_split_large_pages(kvm, slot);

If so, maybe we should just unconditionally do eager page splitting for
the entire memslot, which would save us from having to add egaer page
splitting in two places.

> 
> > In order to avoid allocating while holding the MMU lock, vCPUs
> > preallocate everything they need to handle the fault and store it in
> > kvm_mmu_memory_cache structs. Eager Page Splitting does the same thing
> > but since it runs outside of a vCPU thread it needs its own copies of
> > kvm_mmu_memory_cache structs. This requires refactoring the
> > way kvm_mmu_memory_cache structs are passed around in the MMU code
> > and adding kvm_mmu_memory_cache structs to kvm_arch.
> 
> That's okay, we can move more arguments to structs if needed in the same
> was as struct kvm_page_fault; or we can use kvm_get_running_vcpu() if
> it's easier or more appropriate.
> 
> > * Increases the duration of the VM ioctls that enable dirty logging.
> > This does not affect customer performance but may have unintended
> > consequences depending on how userspace invokes the ioctl. For example,
> > eagerly splitting a 1.5TB memslot takes 30 seconds.
> 
> This issue goes away (or becomes easier to manage) if it's done in
> KVM_CLEAR_DIRTY_LOG.
> 
> > "RFC: Split EPT huge pages in advance of dirty logging" [1] was a
> > previous proposal to proactively split large pages off of the vCPU
> > threads. However it required faulting in every page in the migration
> > thread, a vCPU-like thread in QEMU, which requires extra userspace
> > support and also is less efficient since it requires faulting.
> 
> Yeah, this is best done on the kernel side.
> 
> > The last alternative is to perform dirty tracking at a 2M granularity.
> > This would reduce the amount of splitting work required
> >  by 512x, making the current approach of splitting on fault less
> > impactful to customer performance. We are in the early stages of
> > investigating 2M dirty tracking internally but it will be a while before
> > it is proven and ready for production. Furthermore there may be
> > scenarios where dirty tracking at 4K would be preferable to reduce
> > the amount of memory that needs to be demand-faulted during precopy.
> 
> Granularity of dirty tracking is somewhat orthogonal to this anyway,
> since you'd have to split 1G pages down to 2M.  So please let me know if
> you're okay with the above twist, and let's go ahead with the plan!
> 
> Paolo
> 
