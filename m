Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A4158B2C1
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 01:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241618AbiHEXaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 19:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238141AbiHEXav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 19:30:51 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08881A817
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 16:30:49 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id z25so5395447lfr.2
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 16:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=5+e88HfQH2lIucsXxwkZxdyfP+2njFIpGKdmQ0s6vaQ=;
        b=ZK8Dljk4TO46z8nvkk219ZxDRYc85V4rtZtlROQhonB3PPjOO2z0gTucP8WSJdOsKe
         qbGdeJOABn0xfboUvrMhnjnYC7+mQvxuFGsvcfVL2IdEgEOgYpgBzgQhuhgKcjZ6l80q
         7DLaTUu2PpD0ClnNPaU1NAQvEGM+Voi6VXTVzJuNxhyP4GKlyTId4Gw1eRPCfScJhoxh
         MrKfzPxGa+JXf/Skg/YJcDDyECArSk5+EuGP33YpIYG99HBZuAaCX8lzPH8g/9vmeRA1
         7lCOCLqML6TfLAOLeNOxWiaesSJor/7yCdZmoJaO1uBlXWzv0DZYj/gFyJ4jR5nUISGa
         nf7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=5+e88HfQH2lIucsXxwkZxdyfP+2njFIpGKdmQ0s6vaQ=;
        b=7no/mwuTvXBtSVGt/7vhJOsnXN7C/O67+vSmar/zyso7sz20ntw7y4KdJb0CpBMFVU
         oL7Kgr6Sxx29emMU3pxB1VhBCg2U1GOO6KyKVj/DuZU9zmjnvaCYMVXcVmyn9J+RoH8V
         pVY0YmJDx2ApaU8MAk7V2aUBzRH7yuk4p+3i3hlJlUt+5EhI8R//fi1EfySN8a6rNJq5
         2SvpxJ3DfLstRq9DcX/x7rHEi3CJFB5thDv3TcNGIQ0JkpCFAYlDfzS0TmP3hZIizmbs
         kAI7tzeuIEAre65rjqqnzXH88qXS4P3qoWKk/X/arzQePgYC3AOLlJjsLW7+99+b3n06
         Kl8Q==
X-Gm-Message-State: ACgBeo2qnY0xOoPErM1W078YqU/bXUtn7i2Mz33YHxfI58vF4cifvz82
        r+eaAJrocUgdKNTv6pC1ujUUlLJFJMEea82sDfckyg==
X-Google-Smtp-Source: AA6agR71hMou1+TenheE26zSVkyrFcJSLp/xxnA0rMCiPfBjfVp6MbcTrdFToBJoN9OoHXbHFye0UY5qBwCaNzGDYu8=
X-Received: by 2002:a05:6512:b03:b0:489:e00a:b32 with SMTP id
 w3-20020a0565120b0300b00489e00a0b32mr2883849lfu.368.1659742248023; Fri, 05
 Aug 2022 16:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220801151928.270380-1-vipinsh@google.com> <YuhPT2drgqL+osLl@google.com>
 <YuhoJUoPBOu5eMz8@google.com> <YulRZ+uXFOE1y2dj@google.com>
 <YuldSf4T2j4rIrIo@google.com> <4ccbafb5-9157-ec73-c751-ec71164f8688@redhat.com>
 <Yul3A4CmaAHMui2Z@google.com> <cedcced0-b92c-07bd-ef2b-272ae58fdf40@redhat.com>
In-Reply-To: <cedcced0-b92c-07bd-ef2b-272ae58fdf40@redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 5 Aug 2022 16:30:11 -0700
Message-ID: <CAHVum0c=s8DH=p8zJcGzYDsfLY_qHEmvD1uF58h5WoUk6ZF8rQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Make page tables for eager page splitting
 NUMA aware
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 3, 2022 at 8:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 8/2/22 21:12, Sean Christopherson wrote:
> > Ah crud, I misread the patch.  I was thinking tdp_mmu_spte_to_nid() was getting
> > the node for the existing shadow page, but it's actually getting the node for the
> > underlying physical huge page.
> >
> > That means this patch is broken now that KVM doesn't require a "struct page" to
> > create huge SPTEs (commit  a8ac499bb6ab ("KVM: x86/mmu: Don't require refcounted
> > "struct page" to create huge SPTEs").  I.e. this will explode as pfn_to_page()
> > may return garbage.
> >
> >       return page_to_nid(pfn_to_page(spte_to_pfn(spte)));
>
> I was about to say that yesterday.  However my knowledge of struct page
> things has been proved to be spotty enough, that I wasn't 100% sure of
> that.  But yeah, with a fresh mind it's quite obvious that anything that
> goes through hva_to_pfn_remap and similar paths will fail.
>
> > That said, I still don't like this patch, at least not as a one-off thing.  I do
> > like the idea of having page table allocations follow the node requested for the
> > target pfn, what I don't like is having one-off behavior that silently overrides
> > userspace policy.
>
> Yes, I totally agree with making it all or nothing.
>
> > I would much rather we solve the problem for all page table allocations, maybe
> > with a KVM_CAP or module param?  Unfortunately, that's a very non-trivial change
> > because it will probably require having a per-node cache in each of the per-vCPU
> > caches.
>
> A module parameter is fine.  If you care about performance to this
> level, your userspace is probably homogeneous enough.
>

Thank you all for the feedback and suggestions.

Regarding dirty_log_perf_test, I will send out a patch to add an
option which will tag vcpus to physical cpus using sched_setaffinity()
calls. This should increase accuracy for the test.

 It seems like we are agreeing on two things:

1. Keep the same behavior for the page table pages allocation for both
during the page fault and during eager page splitting.
2. Page table pages should be allocated on the same node where the
underlying guest memory page is residing.

Here are the two approaches, please provide feedback on which one
looks more appropriate before I start spamming your inbox with my
patches

Approach A:
Have per numa node cache for page table pages allocation

Instead of having only one mmu_shadow_page_cache per vcpu, we provide
multiple caches for each node

either:
mmu_shadow_page_cache[MAX_NUMNODES]
or
mmu_shadow_page_cache->objects[MAX_NUMNODES * KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE]

We can decrease KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE to some lower value
instead of 40 to control memory consumption.

When a fault happens, use the pfn to find which node the page should
belong to and use the corresponding cache to get page table pages.

struct *page = kvm_pfn_to_refcounted_page(pfn);
int nid;
if(page) {
      nid = page_to_nid(page);
} else {
     nid = numa_node_id();
}

...
tdp_mmu_alloc_sp(nid, vcpu);
...

static struct kvm_mmu_page *tdp_mmu_alloc_sp(int nid, struct kvm_vcpu *vcpu) {
...
      sp->spt = kvm_mmu_memory_cache_alloc(nid,
&vcpu->arch.mmu_shadow_page_cache);
...
}


Since we are changing cache allocation for page table pages, should we
also make similar changes for other caches like mmu_page_header_cache,
mmu_gfn_array_cache, and mmu_pte_list_desc_cache? I am not sure how
good this idea is.

Approach B:
Ask page from the specific node on fault path with option to fallback
to the original cache and default task policy.

This is what Sean's rough patch looks like.
