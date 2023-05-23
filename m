Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06570CF61
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbjEWAi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235528AbjEWAbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 20:31:02 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2629E4C
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 17:21:42 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64d20f79776so2836857b3a.1
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 17:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684801302; x=1687393302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2aYdF7DTvHPO7OMZesJvRkwGqhq0minNXqz8wSE/nz4=;
        b=6hkfuhgDV+Cm6kpsvzWJ48OVTPAuJNbAy//iZV3iTyUkEm0CBAiqKh89/T3iZhHz2Q
         cS/nl4xPBMzFPSFWoI45FkfXCfhPFhmdrAtsbpG7H2XU7N4TH9lA1jBlH6doK5D5jGF9
         ssywWHAIrAIm4hg395CyoE06GD7PWLdSA8pWKEnXN5od0s8MM/vGppgN7Y1k1zVrN/5l
         t+Xuz2ALaAtGJt9hjPyJJtXoDPu6+f2qM+ISuGV3bk/DwEkTviRlnRJWj+jRfCEMNUsw
         xubELT0MLwIRN2O5A4wXqEY5VMPb6RITikcAhhPQuoPKHRCzm+uZO4JRG5iNINtlxx8O
         gjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684801302; x=1687393302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2aYdF7DTvHPO7OMZesJvRkwGqhq0minNXqz8wSE/nz4=;
        b=ZHAsPbQbp+CGwQyjqJLQqqzPiZ45wnPlGBY5WhZX7ETBAtOyVje04yUNLU930RucQq
         pLRI3YVh/4x2bi06wA4z2VC6nX0UgbPLQvwDL4gq9+uPtf6V/8FMJvFDysl4K63F0Nx1
         bF9dahIytU+ZId4uhITT8JgEm4n9wMlaTE3cltr0oApIkkLA5lBxQNQDepVUCWplTgTL
         SajzZpMfYyGGLzG7TxbGju1ia5A9DFVSZ6hT/nyit472IMRUIkkcP0Mn5fKEzqQ/ZrIv
         tQSlMux3X8qZTAwjSbb6icSHcbJ7gyAcneVc5jpIs9pbaKBhN2iSQZRPRjlPypYWDtfe
         xs5Q==
X-Gm-Message-State: AC+VfDyzt818rtw9jKU7O3Mbi1WvwGAXH0kAQ1s+gnzZWAxaE1yS8oq0
        tIiBEo4LtJqLzsqezM3ds7/ohdRiv5U=
X-Google-Smtp-Source: ACHHUZ5nM/K1msH8/300AUBbxABE1arku2Ztm2J+BPfcuobQx6fSnGZtV4PF8qqvQU3SEk0HXC++fnu3Dhw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:986:b0:63d:397a:8fdd with SMTP id
 u6-20020a056a00098600b0063d397a8fddmr5586115pfg.0.1684801302311; Mon, 22 May
 2023 17:21:42 -0700 (PDT)
Date:   Tue, 23 May 2023 00:21:40 +0000
In-Reply-To: <20230522235838.ov3722lcusotzlvo@amd.com>
Mime-Version: 1.0
References: <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com> <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com> <20230512002124.3sap3kzxpegwj3n2@amd.com>
 <ZF5+5g5hI7xyyIAS@google.com> <20230522135036.wnvsmryhkvstwvw2@amd.com>
 <ZGuh1J6AOw5v2R1W@google.com> <20230522235838.ov3722lcusotzlvo@amd.com>
Message-ID: <ZGwHFPnNK89/t7wx@google.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, wei.w.wang@intel.com,
        Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023, Michael Roth wrote:
> On Mon, May 22, 2023 at 10:09:40AM -0700, Sean Christopherson wrote:
> > On Mon, May 22, 2023, Michael Roth wrote:
> > > On Fri, May 12, 2023 at 11:01:10AM -0700, Sean Christopherson wrote:
> > > > On Thu, May 11, 2023, Michael Roth wrote:
> > > I put together a tree with some fixups that are needed for against the
> > > kvm_gmem_solo base tree, and a set of hooks to handle invalidations,
> > > preparing the initial private state as suggested above, and a
> > > platform-configurable mask that the x86 MMU code can use for determining
> > > whether a fault is for private vs. shared pages.
> > > 
> > >   KVM: x86: Determine shared/private faults using a configurable mask
> > >   ^ for TDX we could trivially add an inverted analogue of the mask/logic
> > >   KVM: x86: Use full 64-bit error code for kvm_mmu_do_page_fault
> > >   KVM: x86: Add platform hooks for private memory invalidations
> > 
> > Hrm, I'd prefer to avoid adding another hook for this case, arch code already has
> > a "hook" in the form of kvm_unmap_gfn_range().  We'd probably just need a
> > kvm_gfn_range.is_private flag to communicate to arch/vendor code that the memory
> > being zapped is private.
> 
> kvm_unmap_gfn_range() does however get called with kvm->mmu_lock held so
> it might be tricky to tie RMP updates into that path.

Gah, I caught the mmu_lock issue before the end of my email, but forgot to go back
and rethink the first half.

> > That'd leave a gap for the unbind() case because kvm_unmap_gfn_range() is invoked
> > if and only if there's an overlapping memslot.  I'll chew on that a bit to see if
> > there's a way to cleanly handle that case without another hook.  I think it's worth
> > mapping out exactly what we want unbind() to look like anyways, e.g. right now the
> > code subtly relies on private memslots being immutable.
m 
> I thought the direction you sort of driving at was to completely decouple
> RMP updates for physical pages from the KVM MMU map/unmap paths since the
> life-cycles of those backing pages and associated RMP state are somewhat
> separate from the state of the GFNs and kvm->mem_attr_array. It seems to
> make sense when dealing with things like this unbind() case.
> 
> There's also cases like userspaces that opt to not discard memory after
> conversions because they highly favor performance over memory usage. In
> those cases it would make sense to defer marking the pages as shared in
> the RMP until the FALLOC_FL_PUNCH_HOLE, rather than triggering it via
> KVM MMU invalidation path after a conversion.

Hmm, right.  I got overzealous in my desire to avoid new hooks.

> > >   KVM: x86: Add platform hook for initializing private memory
> > 
> > This should also be unnecessary.  The call to kvm_gmem_get_pfn() is from arch
> > code, KVM just needs to ensure the RMP is converted before acquiring mmu_lock,
> > e.g. KVM has all the necessary info in kvm_tdp_mmu_page_fault().
> 
> I think that approach would work fine. The way I was thinking of things
> is that KVM MMU would necessarily call kvm_gmem_get_pfn() to grab the
> page before mapping it into the guest, so moving it out into an explicit
> call should work just as well. That would also drop the need for the
> __kvm_gmem_get_pfn() stuff I needed to add for the initial case where we
> need to access the PFN prior to making it private.
> 
> > 
> > The only reason to add another arch hook would be if we wanted to converted the
> > RMP when _allocating_, e.g. to preconvert in response to fallocate() instead of
> > waiting until #NPF.  But I think I would rather add a generic ioctl() to allow
> > userspace to effectively prefault guest memory, e.g. to setup the RMP before
> > running a vCPU.  Such an ioctl() would potentially be useful in other scenarios,
> > e.g. on the dest during live migration to reduce jitter.
> 
> Agreed, deferring the RMPUPDATE until it's actually needed would give us
> more flexibility on optimizing for things like lazy-acceptance.
> 
> For less-common scenarios like preallocation it makes sense to make that
> an opt-in sort of thing for userspace to configure explicitly.
> 
> > 
> > >   *fixup (kvm_gmem_solo): KVM: Fix end range calculation for MMU invalidations
> > 
> > There was another bug in this path.  The math for handling a non-zero offsets into
> > the file was wrong.  The code now looks like:
> > 
> > 	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
> > 		struct kvm_gfn_range gfn_range = {
> > 			.start = slot->base_gfn + start - slot->gmem.index,
> 
> Sorry if I'm missing something here, but isn't there a risk that:
> 
>   start - slot->gmem.index
> 
> would be less than zero? E.g. starting GFN was 0, but current slot is bound
> at some non-zero offset in the same gmem instance. I guess the warning below
> shouldn't caught that, but it seems like a real scenario.

Heh, only if there's a testcase for it.  Assuming start >= the slot offset does
seem broken, e.g. if the range-to-invalidate overlaps multiple slots, later slots
will have index==slot->gmem.index > start.

> Since 'index' corresponds to the gmem offset of the current slot, is there any
> reason not to do something like this?:
> 
>   .start = slot->base_gfn + index - slot->gmem.index,
> 
> But then, if that's the case, wouldn't index == slot->gmem.index? Suggesting
> we case just simplify to this?:
> 
>   .start = slot->base_gfn,

No, e.g. if start is partway through a memslot, there's no need to invalidate
the entire memslot.  I'll stare at this tomorrow when my brain is hopefully a
bit more functional, I suspect there is a min() and/or max() needed somewhere.
