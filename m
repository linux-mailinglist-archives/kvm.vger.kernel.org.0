Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD977250C5
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 01:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbjFFXZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 19:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbjFFXZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 19:25:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF97E6C
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 16:25:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8337ade1cso10725018276.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 16:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686093948; x=1688685948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vNeZUKbrxXwLC0WoXDLFx2bOjpqlBZbUbWeyaSf8iSk=;
        b=TtD9SoeTO+i/9oaLhBo44Jf3BOElOvYjKPFvmn9nlhApFZsStSSrt/NJtz/Bc/CxeP
         bdjUx4vDUgrH5q542Km+rSwxLVyBl4zlz3aUt6QD48UOA9m3gJe9I6kDjfNQTJp4zcXX
         Vc0LPbzEnxN/Vuq/p58vsmo/PuQ9ajPlGNzNv/cVeejHK4Oqac/JQFSzlnwO0JnouYG5
         TN0sdfnwHMse8SEeHPAIaxG5TTs7xqCb8Az7Ry3mgYVF8LQ8jkZ25sFaEUfh1daqeimU
         7oArhHSEyy8appHn+AjUJd38QZocGwC1VTceigKvcnQ4aaRkKLVWmjf0TKFSxn+Hu5UU
         nD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686093948; x=1688685948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vNeZUKbrxXwLC0WoXDLFx2bOjpqlBZbUbWeyaSf8iSk=;
        b=f6s9SNofOjq0freJwdKIszqvS4acZYH0duvUZEI5LRTG6SXhyf2F9wOwdCNoGYp4sU
         dpNbGe1yt7R5BUotcJzTbIrTNaC0c9Y+sirPZzHEiGpvhRZJe4UJa7Fck0pBp51e6151
         xACRFRmATIhId2Nt0LJLwnSciMTHqXmqXg0zePXCf/FLE4OMDN3INlp57h8L0mwVm8Ss
         llynmfh+GLdOmhh+hv9f03KbOVEfmsVlmIaBa5iiRH0qw1xi5oOaj8YvqD+wzUlI15Ag
         wvYyYmGiopPrA7LHFAayPwHWEQSzgfK8f0sn1Bdu3xjwiL1CqcuISNmeYzgfZejZKr3m
         ZFZw==
X-Gm-Message-State: AC+VfDylJI8TNWRncVPG7dn94uwpLGEeqZypSBEWwYhnx2vNy8TtOQZf
        A6QdjeVvhlCEG2WZfPIUU0sy1XzLiIo=
X-Google-Smtp-Source: ACHHUZ4HrqMd6MVfOPtIgZ+5J8gEfQaacfL92xIU/U9tjPXRSGTvf9Ag0poRQpEuNOza3T8T5k6ox29THZc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:600b:0:b0:b8f:6b84:33cb with SMTP id
 u11-20020a25600b000000b00b8f6b8433cbmr1279205ybb.11.1686093947932; Tue, 06
 Jun 2023 16:25:47 -0700 (PDT)
Date:   Tue, 6 Jun 2023 16:25:46 -0700
In-Reply-To: <diqz8rcwjtck.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <ZEM5Zq8oo+xnApW9@google.com> <diqz8rcwjtck.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <ZH/Aem0hX4p3wtFW@google.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Sean Christopherson <seanjc@google.com>
To:     Ackerley Tng <ackerleytng@google.com>
Cc:     david@redhat.com, chao.p.peng@linux.intel.com, pbonzini@redhat.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        mail@maciej.szmigiero.name, vbabka@suse.cz, vannapurve@google.com,
        yu.c.zhang@linux.intel.com, kirill.shutemov@linux.intel.com,
        dhildenb@redhat.com, qperret@google.com, tabba@google.com,
        michael.roth@amd.com, wei.w.wang@intel.com, rppt@kernel.org,
        liam.merwick@oracle.com, isaku.yamahata@gmail.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com, brauner@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023, Ackerley Tng wrote:
> 
> I've ported selftests from Chao and I [1] while working on hugetlb support
> for guest_mem [2].
> 
> In the process, I found some bugs and have some suggestions for guest_mem.
> Please see separate commits at [3].
> 
> Here are some highlights/questions:
> 
> + "KVM: guest_mem: Explain the use of the uptodate flag for gmem"
>     + Generally, uptodate flags means that the contents of this page match the
>       backing store. Since gmem is memory-backed, does "uptodate" for gmem mean
>       "zeroed"?

Don't read too much into the code, my POC was very much a "beat on it until it
works" scenario.

> + "KVM: guest_mem: Don't re-mark accessed after getting a folio" and "KVM:
>   guest_mem: Don't set dirty flag for folio"
>     + Do we need to folio_mark_accessed(), when it was created with
>       FGP_ACCESSED?

Probably not.  And as you note below, it's all pretty nonsensical anyways.

>     + What is the significance of these LRU flags when gmem doesn't support
>       swapping/eviction?

Likely none.  I used the filemap APIs in my POC because it was easy, not because
it was necessarily the best approach, i.e. that the folios/pages show up in the
LRUs is an unwanted side effect, not a feature.  If guest_memfd only needs a small
subset of the filemap support, going with a true from-scratch implemenation on
top of xarray might be cleaner overall, e.g. would avoid the need for a new flag
to say "this folio can't be migrated even though it's on the LRUs".

> + "KVM: guest_mem: Align so that at least 1 page is allocated"
>     + Bug in current implementation: without this alignment, fallocate() of
>       a size less than the gmem page size will result in no allocation at all

I'm not convinced this is a bug.  I don't see any reason to allow allocating and
punching holes in sub-page granularity.

>     + Both shmem and hugetlbfs perform this alignment
> + "KVM: guest_mem: Add alignment checks"
>     + Implemented the alignment checks for guest_mem because hugetlb on gmem
>       would hit a BUG_ON without this check
> + "KVM: guest_mem: Prevent overflows in kvm_gmem_invalidate_begin()"
>     + Sean fixed a bug in the offset-to-gfn conversion in
>       kvm_gmem_invalidate_begin() earlier, adding a WARN_ON_ONCE()

As Mike pointed out, there's likely still a bug here[*].  I was planning on
diving into that last week, but that never happened.  If you or anyone else can
take a peek and/or write a testcase, that would be awesome.

 : Heh, only if there's a testcase for it.  Assuming start >= the slot offset does
 : seem broken, e.g. if the range-to-invalidate overlaps multiple slots, later slots
 : will have index==slot->gmem.index > start.
 : 
 : > Since 'index' corresponds to the gmem offset of the current slot, is there any
 : > reason not to do something like this?:
 : >
 : >   .start = slot->base_gfn + index - slot->gmem.index,
 : >
 : > But then, if that's the case, wouldn't index == slot->gmem.index? Suggesting
 : > we case just simplify to this?:
 : >
 : >   .start = slot->base_gfn,
 : 
 : No, e.g. if start is partway through a memslot, there's no need to invalidate
 : the entire memslot.  I'll stare at this tomorrow when my brain is hopefully a
 : bit more functional, I suspect there is a min() and/or max() needed somewhere.

[*] https://lore.kernel.org/all/20230512002124.3sap3kzxpegwj3n2@amd.com

>     + Code will always hit WARN_ON_ONCE() when the entire file is closed and
>       all offsets are invalidated, so WARN_ON_ONCE() should be removed
>     + Vishal noticed that the conversion might result in an overflow, so I
>       fixed that
> + And of course, hugetlb support! Please let me know what you think of the
>   approach proposed at [2].
> 
> [1] https://lore.kernel.org/all/cover.1678926164.git.ackerleytng@google.com/T/
> [2] https://lore.kernel.org/lkml/cover.1686077275.git.ackerleytng@google.com/T/
> [3] https://github.com/googleprodkernel/linux-cc/tree/gmem-hugetlb-rfc-v1
