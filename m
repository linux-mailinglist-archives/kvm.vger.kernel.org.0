Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5262058DC7D
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 18:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245080AbiHIQwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 12:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245072AbiHIQwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 12:52:41 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC99622BC2
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 09:52:37 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id c185so14530203oia.7
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 09:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=U/D22wA89KCZ8FoM5lxlmalnb8zbCkLG8x+Wao6IKHs=;
        b=gri5en4j1Nf3AVExb/xtD1i/SndOYTeJjQtSC4usRK/O5d48jIap8p682Zeazqp1Pe
         ipEbBmYcoxs2HYZIFr0omCnqtPLNcjZBirFyZdioPg2ZHJTdjjl3rybGv5A8NN8sEr2D
         j/46Th9HahRaqHle8jwPoK5mftTBUmii9vmBapkxypM1FxDjqyr8XLKNjh7zeXnt2/do
         wB/lJlW0htmLpjlsTEnwrlPtWZEKxAXiszhwYqKQSPvWhm0V6psnPZtA7vYtrguTQ8qm
         P0tnIJh4/g7qzJlNnNSX9XeWQuoDh5KaFvMiDWpq29FKzA3WM7kDA7XCjhYsgnVyiCoB
         uyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=U/D22wA89KCZ8FoM5lxlmalnb8zbCkLG8x+Wao6IKHs=;
        b=1S83R3nUtuEHYAa+cjtNV8UiYtJBeapXAvrQnUMASPj8Wxz+aOjQhCI4veOUzyd0U0
         iwyDCHSQYS+XFBPLBiO6wiRPqvDEA5kFAy1MTFQtmRt0Y2T9Y9y/qpWQuBDCl9xmdlB9
         ujc4O59HJva7gfRxCq6XZxnTanLlcBE317HhCzu7AK6wM50MIwfaLGDrTpXj0Z9vpnQn
         A0T2YcrIQ/by5gA0sBSziairNVNOIZEDTBpa+o+Z0KmM1sm5Uo00W8UxKBot90dSH3DH
         UerBfAOqxmDR8xNYgpH02q8PSERhixYpmAhYKPU3nFfIjrQZNOcK3La6IA2QtIqxVyOP
         6B2g==
X-Gm-Message-State: ACgBeo2q4zfyxi9UTG1dVrBsoUsqrbT7mn6Zr9D8NpQ88nzuTW6iwbMa
        poUnNdwaOCz3mnNeyIs8hWbYqWa2gu4AYCWM48L/Pw==
X-Google-Smtp-Source: AA6agR4EANbHbB06m6UK0Z8LDAx9jyRV3DCFcB8+aJ4dmS8ZHdO7iP7HvmWEfgbIWxIpnUmtw3QmaRRsASv33ufBVR4=
X-Received: by 2002:a05:6808:16a3:b0:326:a585:95b8 with SMTP id
 bb35-20020a05680816a300b00326a58595b8mr13853758oib.281.1660063957038; Tue, 09
 Aug 2022 09:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220801151928.270380-1-vipinsh@google.com> <YuhPT2drgqL+osLl@google.com>
 <YuhoJUoPBOu5eMz8@google.com> <YulRZ+uXFOE1y2dj@google.com>
 <YuldSf4T2j4rIrIo@google.com> <4ccbafb5-9157-ec73-c751-ec71164f8688@redhat.com>
 <Yul3A4CmaAHMui2Z@google.com> <cedcced0-b92c-07bd-ef2b-272ae58fdf40@redhat.com>
 <CAHVum0c=s8DH=p8zJcGzYDsfLY_qHEmvD1uF58h5WoUk6ZF8rQ@mail.gmail.com>
In-Reply-To: <CAHVum0c=s8DH=p8zJcGzYDsfLY_qHEmvD1uF58h5WoUk6ZF8rQ@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 9 Aug 2022 09:52:10 -0700
Message-ID: <CALzav=ccxkAWk7ddqbJ_qPL2-=bXVZUEpWgwKpJ1oCtc_8w7WQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Make page tables for eager page splitting
 NUMA aware
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 5, 2022 at 4:30 PM Vipin Sharma <vipinsh@google.com> wrote:
[...]
>
> Here are the two approaches, please provide feedback on which one
> looks more appropriate before I start spamming your inbox with my
> patches
>
> Approach A:
> Have per numa node cache for page table pages allocation
>
> Instead of having only one mmu_shadow_page_cache per vcpu, we provide
> multiple caches for each node
>
> either:
> mmu_shadow_page_cache[MAX_NUMNODES]
> or
> mmu_shadow_page_cache->objects[MAX_NUMNODES * KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE]

I think the former approach will work better. The objects[] array is
allocated dynamically during top-up now, so if a vCPU never allocates
a page table to map memory on a given node, KVM will never have to
allocate an objects[] array for that node. Whereas with the latter
approach KVM would have to allocate the entire objects[] array
up-front.

>
> We can decrease KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE to some lower value
> instead of 40 to control memory consumption.

I'm not sure we are getting any performance benefit from the cache
size being so high. It doesn't fundamentally change the number of
times a vCPU thread will have to call __get_free_page(), it just
batches more of those calls together. Assuming reducing the cache size
doesn't impact performance, I think it's a good idea to reduce it as
part of this feature.

KVM needs at most PT64_ROOT_MAX_LEVEL (5) page tables to handle a
fault. So we could decrease the mmu_shadow_page_cache.objects[]
capacity to PT64_ROOT_MAX_LEVEL (5) and support up to 8 NUMA nodes
without increasing memory usage. If a user wants to run a VM on an
even larger machine, I think it's safe to consume a few extra bytes
for the vCPU shadow page caches at that point (the machine probably
has 10s of TiB of RAM).

>
> When a fault happens, use the pfn to find which node the page should
> belong to and use the corresponding cache to get page table pages.
>
> struct *page = kvm_pfn_to_refcounted_page(pfn);
> int nid;
> if(page) {
>       nid = page_to_nid(page);
> } else {
>      nid = numa_node_id();
> }
>
> ...
> tdp_mmu_alloc_sp(nid, vcpu);
> ...
>
> static struct kvm_mmu_page *tdp_mmu_alloc_sp(int nid, struct kvm_vcpu *vcpu) {
> ...
>       sp->spt = kvm_mmu_memory_cache_alloc(nid,
> &vcpu->arch.mmu_shadow_page_cache);
> ...
> }
>
>
> Since we are changing cache allocation for page table pages, should we
> also make similar changes for other caches like mmu_page_header_cache,
> mmu_gfn_array_cache, and mmu_pte_list_desc_cache? I am not sure how
> good this idea is.

We don't currently have a reason to make these objects NUMA-aware, so
I would only recommend it if it somehow makes the code a lot simpler.

>
> Approach B:
> Ask page from the specific node on fault path with option to fallback
> to the original cache and default task policy.
>
> This is what Sean's rough patch looks like.

This would definitely be a simpler approach but could increase the
amount of time a vCPU thread holds the MMU lock when handling a fault,
since KVM would start performing GFP_NOWAIT allocations under the
lock. So my preference would be to try the cache approach first and
see how complex it turns out to be.
