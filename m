Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184086BF23D
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 21:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjCQURb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 16:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCQURa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 16:17:30 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED98437B6B
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 13:17:24 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d5-20020a17090ac24500b0023cb04ec86fso2765938pjx.7
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 13:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679084244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4+lVK1Wnprnquy3/uUii/WTEmQ7okuIAsjSnsb67Fgs=;
        b=QXwZMDbtVM2W6MeMzdcK/EaVGH1b8HfM3XeaZQGAIyvA4fBZviIyjuAeylgbaUTUJR
         L8bhn3jO8yoHCM7Plpr3ouOISQ+f4YLHKbvkfDRMCfqY03YdOi17u7yBbzLxesLtmYa5
         yBFLMhQQXywzh+iPfy0essiFdFeoF3m3mplYc2OCpTRSs8VW5Tkb5BuWUJQhUztj4+U0
         ZjzODAXo7yJ8f0U2qckQC0O3EAp1ASRjxI70oLH5HuDrxO7oHkFkSa1uUGRTP7P10i+i
         geQGWh/EXtZKJ2aB+4fEAhmlr5xG4NJa3bbZ0TQyPMwZ12/btT6Zc5Xcp+PnvNhg17Ds
         w3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679084244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4+lVK1Wnprnquy3/uUii/WTEmQ7okuIAsjSnsb67Fgs=;
        b=lxsjxSieGR6dgDED2kAt5KZMfedg3Z6c++gpk0oIjiGaJtJcSRriAXaYooINbwO3bi
         p/ub27iEdMDQY2diJAfnFL6BjmNp4rL/5z2vW4aZF95WQo9UEbKoUUjxtuc46AGP/vJ9
         DVULr3r2eLfZ9QS8r5eeOVWmeSX2u1UZ6sgNeg8Oph0BS/8QcEXGSrNkxhVTQ441dKf1
         E2AhDcc6Xlyrwa3sDK0yU9fPEVmP5ORXr+EL/+XDT/xImASiU0f3bmqFDodYNfYgE5cX
         mi1B0ma+rSYHLnKnqPf2J7dfT2LnK5/iwjF3J8nx0A1QJxiJEM3BPaV4obywfjBKnnXX
         EYlA==
X-Gm-Message-State: AO0yUKXZWJnPldy5JPDOPaXEPZn7XMtKjTFNo/D+JBmVxOQAzILS8vZe
        LyHWvfgHir0f65OO22TzpLF+1ZW+TiU=
X-Google-Smtp-Source: AK7set/GgLA5PvylIqqFnZs0M9C+EY+kUsKtYDUfW15tAqhbxOPlYAizltQL/W1HO/4UsdQFtOs3t6mk6jQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4ac7:b0:5a8:daec:c325 with SMTP id
 ds7-20020a056a004ac700b005a8daecc325mr1929487pfb.1.1679084244547; Fri, 17 Mar
 2023 13:17:24 -0700 (PDT)
Date:   Fri, 17 Mar 2023 13:17:22 -0700
In-Reply-To: <ZBS4o75PVHL4FQqw@linux.dev>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-10-amoorthy@google.com>
 <ZBS4o75PVHL4FQqw@linux.dev>
Message-ID: <ZBTK0vzAoWqY1hDh@google.com>
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Anish Moorthy <amoorthy@google.com>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023, Oliver Upton wrote:
> On Wed, Mar 15, 2023 at 02:17:33AM +0000, Anish Moorthy wrote:
> > Add documentation, memslot flags, useful helper functions, and the
> > actual new capability itself.
> > 
> > Memory fault exits on absent mappings are particularly useful for
> > userfaultfd-based live migration postcopy. When many vCPUs fault upon a
> > single userfaultfd the faults can take a while to surface to userspace
> > due to having to contend for uffd wait queue locks. Bypassing the uffd
> > entirely by triggering a vCPU exit avoids this contention and can improve
> > the fault rate by as much as 10x.
> > ---
> >  Documentation/virt/kvm/api.rst | 37 +++++++++++++++++++++++++++++++---
> >  include/linux/kvm_host.h       |  6 ++++++
> >  include/uapi/linux/kvm.h       |  3 +++
> >  tools/include/uapi/linux/kvm.h |  2 ++
> >  virt/kvm/kvm_main.c            |  7 ++++++-
> >  5 files changed, 51 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index f9ca18bbec879..4932c0f62eb3d 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
> >    /* for kvm_userspace_memory_region::flags */
> >    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
> >    #define KVM_MEM_READONLY	(1UL << 1)
> > +  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
> 
> call it KVM_MEM_EXIT_ABSENT_MAPPING

Ooh, look, a bikeshed!  :-)

I don't think it should have "EXIT" in the name.  The exit to userspace is a side
effect, e.g. KVM already exits to userspace on unresolved userfaults.  The only
thing this knob _directly_ controls is whether or not KVM attempts the slow path.
If we give the flag a name like "exit on absent userspace mappings", then KVM will
appear to do the wrong thing when KVM exits on a truly absent userspace mapping.

And as I argued in the last version[*], I am _strongly_ opposed to KVM speculating
on why KVM is exiting to userspace.  I.e. KVM should not set a special flag if
the memslot has "fast only" behavior.  The only thing the flag should do is control
whether or not KVM tries slow paths, what KVM does in response to an unresolved
fault should be an orthogonal thing.

E.g. If KVM encounters an unmapped page while prefetching SPTEs, KVM will (correctly)
not exit to userspace and instead simply terminate the prefetch.  Obviously we
could solve that through documentation, but I don't see any benefit in making this
more complex than it needs to be.

[*] https://lkml.kernel.org/r/Y%2B0RYMfw6pHrSLX4%40google.com

> > +7.35 KVM_CAP_MEMORY_FAULT_NOWAIT
> > +--------------------------------
> > +
> > +:Architectures: x86, arm64
> > +:Returns: -EINVAL.
> > +
> > +The presence of this capability indicates that userspace may pass the
> > +KVM_MEM_ABSENT_MAPPING_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
> > +to exit to populate 'kvm_run.memory_fault' and exit to userspace (*) in response
> > +to page faults for which the userspace page tables do not contain present
> > +mappings. Attempting to enable the capability directly will fail.
> > +
> > +The 'gpa' and 'len' fields of kvm_run.memory_fault will be set to the starting
> > +address and length (in bytes) of the faulting page. 'flags' will be set to
> > +KVM_MEMFAULT_REASON_ABSENT_MAPPING.
> > +
> > +Userspace should determine how best to make the mapping present, then take
> > +appropriate action. For instance, in the case of absent mappings this might
> > +involve establishing the mapping for the first time via UFFDIO_COPY/CONTINUE or
> > +faulting the mapping in using MADV_POPULATE_READ/WRITE. After establishing the
> > +mapping, userspace can return to KVM to retry the previous memory access.
> > +
> > +(*) NOTE: On x86, KVM_CAP_X86_MEMORY_FAULT_EXIT must be enabled for the
> > +KVM_MEMFAULT_REASON_ABSENT_MAPPING_reason: otherwise userspace will only receive
> > +a -EFAULT from KVM_RUN without any useful information.
> 
> I'm not a fan of this architecture-specific dependency. Userspace is already
> explicitly opting in to this behavior by way of the memslot flag. These sort
> of exits are entirely orthogonal to the -EFAULT conversion earlier in the
> series.

Ya, yet another reason not to speculate on why KVM wasn't able to resolve a fault.
