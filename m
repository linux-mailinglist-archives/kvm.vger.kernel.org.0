Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5371572A37
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 02:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiGMAYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 20:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGMAYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 20:24:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF60CCC79A
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 17:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657671882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SQg/ZuurNtuJGT4UxamLRinnCHuDLCOaHNIjKN/8jDQ=;
        b=IkGRJwXbe4u4jPhTmySJ53si4QIKU5PuS/hXSWmh1A8Q9OQO/4itDbM6q1+QObJjCNTyd7
        Pv5d3nhwuIpMzfPzldHGkDueqkj4fgM8KE6gvOsDBAXaF7kZEb0ONJ3ltkYCyWlc66xsPm
        eauMbP+LjY3IXAfsISdohYGuBzIGo0o=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-C569DY3UP66d6-_52USGiw-1; Tue, 12 Jul 2022 20:24:41 -0400
X-MC-Unique: C569DY3UP66d6-_52USGiw-1
Received: by mail-qt1-f200.google.com with SMTP id v13-20020a05622a014d00b0031ea4c5d35dso7919237qtw.9
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 17:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SQg/ZuurNtuJGT4UxamLRinnCHuDLCOaHNIjKN/8jDQ=;
        b=y+OJD8C0uXaT66hSnMVSG8AtEzABqTC5nIH9EDNrD+9ZL9Q2bxJtQbjB7sv0Ppsx24
         Da+l332hERW/ZBfQ1+JZwqH1RbV9wxdvP/KBNWAiKXh8/RW67HIxbO6mHxMD7yH9dI/q
         4a7D7vCzSWTd8DqeMRNrvOfKe0V3PeaLzulj6dXUBzrP1lYOOsIr7OybydrE4fsb1PuB
         XjuOVf5Vf6TbKA8q72+S+JQNvmIIjSdWVOntOOztO/WQ0bcdI+e0wgSGHFSLEedfvTJU
         D40Jtsmw+7UM5uOtpn2DNgyD1Pc1f0GL9F64qbV68BTGfvQash1HM4haUzihSsO8fHt1
         yNkg==
X-Gm-Message-State: AJIora+C3tUMoT4GY2Ned+KIEzxq6iDL8gtDCj7gKGMCCjpu83E2vdO+
        E/nUFhfmyhTN+QJW/uxtTq5we6IHD3t0b19pzZDuRZt/U5rK0CUVxaFj/3rzeC2TXnozamZMKj/
        E/IVGcE1HEMwX
X-Received: by 2002:a37:6541:0:b0:6b5:8ade:9dba with SMTP id z62-20020a376541000000b006b58ade9dbamr781892qkb.330.1657671881182;
        Tue, 12 Jul 2022 17:24:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uYMT8ACHE8hPbNTCM0ua19jfLqlv/B9h6ELouoQCNktD1qaygNamgYNh8M/DbFYcJMQkir6w==
X-Received: by 2002:a37:6541:0:b0:6b5:8ade:9dba with SMTP id z62-20020a376541000000b006b58ade9dbamr781877qkb.330.1657671880908;
        Tue, 12 Jul 2022 17:24:40 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id w16-20020a05620a0e9000b006b4880b08a9sm4250840qkm.88.2022.07.12.17.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 17:24:40 -0700 (PDT)
Date:   Tue, 12 Jul 2022 20:24:39 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Shrink pte_list_desc size when KVM is
 using TDP
Message-ID: <Ys4Qx1RxmWrtQ8it@xz-m1.local>
References: <20220624232735.3090056-1-seanjc@google.com>
 <20220624232735.3090056-4-seanjc@google.com>
 <Ys33RtxeDz0egEM0@xz-m1.local>
 <Ys37fNK6uQ+YTcBh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ys37fNK6uQ+YTcBh@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 10:53:48PM +0000, Sean Christopherson wrote:
> On Tue, Jul 12, 2022, Peter Xu wrote:
> > On Fri, Jun 24, 2022 at 11:27:34PM +0000, Sean Christopherson wrote:
> > > Dynamically size struct pte_list_desc's array of sptes based on whether
> > > or not KVM is using TDP.  Commit dc1cff969101 ("KVM: X86: MMU: Tune
> > > PTE_LIST_EXT to be bigger") bumped the number of entries in order to
> > > improve performance when using shadow paging, but its analysis that the
> > > larger size would not affect TDP was wrong.  Consuming pte_list_desc
> > > objects for nested TDP is indeed rare, but _allocating_ objects is not,
> > > as KVM allocates 40 objects for each per-vCPU cache.  Reducing the size
> > > from 128 bytes to 32 bytes reduces that per-vCPU cost from 5120 bytes to
> > > 1280, and also provides similar savings when eager page splitting for
> > > nested MMUs kicks in.
> > > 
> > > The per-vCPU overhead could be further reduced by using a custom, smaller
> > > capacity for the per-vCPU caches, but that's more of an "and" than
> > > an "or" change, e.g. it wouldn't help the eager page split use case.
> > > 
> > > Set the list size to the bare minimum without completely defeating the
> > > purpose of an array (and because pte_list_add() assumes the array is at
> > > least two entries deep).  A larger size, e.g. 4, would reduce the number
> > > of "allocations", but those "allocations" only become allocations in
> > > truth if a single vCPU depletes its cache to where a topup is needed,
> > > i.e. if a single vCPU "allocates" 30+ lists.  Conversely, those 2 extra
> > > entries consume 16 bytes * 40 * nr_vcpus in the caches the instant nested
> > > TDP is used.
> > > 
> > > In the unlikely event that performance of aliased gfns for nested TDP
> > > really is (or becomes) a priority for oddball workloads, KVM could add a
> > > knob to let the admin tune the array size for their environment.
> > > 
> > > Note, KVM also unnecessarily tops up the per-vCPU caches even when not
> > > using rmaps; this can also be addressed separately.
> > 
> > The only possible way of using pte_list_desc when tdp=1 is when the
> > hypervisor tries to map the same host pages with different GPAs?
> 
> Yes, if by "host pages" you mean L1 GPAs.  It happens if the L1 VMM maps multiple
> L2 GFNs to a single L1 GFN, in which case KVM's nTDP shadow MMU needs to rmap
> that single L1 GFN to multiple L2 GFNs.
> 
> > And we don't really have a real use case of that, or.. do we?
> 
> QEMU does it during boot/pre-boot when BIOS remaps the flash region into the lower
> 1mb, i.e. aliases high GPAs to low GPAs.
> 
> > Sorry to start with asking questions, it's just that if we know that
> > pte_list_desc is probably not gonna be used then could we simply skip the
> > cache layer as a whole?  IOW, we don't make the "array size of pte list
> > desc" dynamic, instead we make the whole "pte list desc cache layer"
> > dynamic.  Is it possible?
> 
> Not really?  It's theoretically possible, but it'd require pre-checking that aren't
> aliases, and to do that race free we'd have to do it under mmu_lock, which means
> having to support bailing from the page fault to topup the cache.  The memory
> overhead for the cache isn't so significant that it's worth that level of complexity.

Ah, okay..

So the other question is I'm curious how fundamentally this extra
complexity could help us to save spaces.

The thing is IIUC slub works in page sizes, so at least one slub cache eats
one page which is 4096 anyway.  In our case if there was 40 objects
allocated for 14 entries array, are you sure it'll still be 40 objects but
only smaller?  I'd thought after the change each obj is smaller but slub
could have cached more objects since min slub size is 4k for x86.

I don't remember the details of the eager split work on having per-vcpu
caches, but I'm also wondering if we cannot drop the whole cache layer
whether we can selectively use slub in this case, then we can cache much
less assuming we will use just less too.

Currently:

	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);

We could have the pte list desc cache layer to be managed manually
(e.g. using kmalloc()?) for tdp=1, then we'll at least in control of how
many objects we cache?  Then with a limited number of objects, the wasted
memory is much reduced too.

I think I'm fine with current approach too, but only if it really helps
reduce memory footprint as we expected.

Thanks,

-- 
Peter Xu

