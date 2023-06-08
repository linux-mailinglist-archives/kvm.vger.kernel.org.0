Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E69872860D
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 19:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbjFHRN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 13:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236191AbjFHRNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 13:13:55 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AC92D7E
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 10:13:37 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53fa6346e9dso414182a12.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 10:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686244416; x=1688836416;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nx+n2F/WScfnT6i8uQu3m0jKyiS0VKR1jetoRFKNgPw=;
        b=iyjxKk4z6jWUBL/xei2QcYmMKBG+0gFJq60qj2/caN+iA85NoFBM0cTlLNrpqW+1yu
         r7i1W3a77tQyBW40WJ7PXORP12Bz/S5NdFj2zcNtKD3oKU9pMUZAjhsRzGtf06G4dySy
         9a1s4mpuop4er3vikGQYN2MDpu0F9Mi8tgvxRFjN7x4+CkXgWvagaZy/L97gWj1ggQr6
         n5Je36AE0ffewvRaN6WOrmzGxpJvthOD/xyX6CejdYzOGWuMxgo+GLn+QgcukWYbmB+6
         Kj5Yeu5+Bkbh6fvmW+GUikdJebzo/bMQzy3M+Izw58PmiGrz2u0ELtqmQjV3mFhR+AKs
         qpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686244416; x=1688836416;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nx+n2F/WScfnT6i8uQu3m0jKyiS0VKR1jetoRFKNgPw=;
        b=Xs1sOHlOXvHD4j4ncbJCgXxvuGEHxd7Bzjt8d7WV8NIh9kngUU6Qc+3/iiOBQjBdqU
         JLKHwX+IqETPbHBI1zLowdg4jNMc37laMbPfwtqxkBANUghrvoC8ioifkCZLkkux8L6d
         B1IM9bF7FbaWuFLV1wBTuE+6Gj9B810a9I/mZFbJxrw60Q5UFDjnVPBme8nNuW4OfZsR
         jb65svvvRzys8juKrTIVgvNlF/tBLDBEiOEaaaHNwxn9dMw/uN/zBAgodOIldoDDS4zM
         JOGQ+AqGns01soKoJJZkz3g3CbpOAD/lTzDU7Sp2u4PVwEy3cQAFLUaZRJ4uThbgfTNr
         EpXw==
X-Gm-Message-State: AC+VfDzHq+rhk3E5TEGQ6YCOMP6nUk9XFsq3/r5u7VULqfJr4qAJ9Xjo
        IbRAlNTZsdw2E5cuoz+ky2t9CFOaiZd8m7qRGg==
X-Google-Smtp-Source: ACHHUZ6ovShBo2ITZoAxYJrbn8iXvyy/UH7+UNcrWE1RIG/XC2zy53gThCB5tGD8tux9JHIVejigrze7F/uEQj7vuw==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a63:4105:0:b0:51f:15bf:c3c7 with SMTP
 id o5-20020a634105000000b0051f15bfc3c7mr17010pga.11.1686244416485; Thu, 08
 Jun 2023 10:13:36 -0700 (PDT)
Date:   Thu, 08 Jun 2023 17:13:35 +0000
In-Reply-To: <ZH/Aem0hX4p3wtFW@google.com> (message from Sean Christopherson
 on Tue, 6 Jun 2023 16:25:46 -0700)
Mime-Version: 1.0
Message-ID: <diqzfs71j2rk.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Ackerley Tng <ackerleytng@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     david@redhat.com, chao.p.peng@linux.intel.com, pbonzini@redhat.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        mail@maciej.szmigiero.name, vbabka@suse.cz, vannapurve@google.com,
        yu.c.zhang@linux.intel.com, kirill.shutemov@linux.intel.com,
        dhildenb@redhat.com, qperret@google.com, tabba@google.com,
        michael.roth@amd.com, wei.w.wang@intel.com, rppt@kernel.org,
        liam.merwick@oracle.com, isaku.yamahata@gmail.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> ...

> Probably not.  And as you note below, it's all pretty nonsensical anyways.

>>      + What is the significance of these LRU flags when gmem doesn't  
>> support
>>        swapping/eviction?

> Likely none.  I used the filemap APIs in my POC because it was easy, not  
> because
> it was necessarily the best approach, i.e. that the folios/pages show up  
> in the
> LRUs is an unwanted side effect, not a feature.  If guest_memfd only  
> needs a small
> subset of the filemap support, going with a true from-scratch  
> implemenation on
> top of xarray might be cleaner overall, e.g. would avoid the need for a  
> new flag
> to say "this folio can't be migrated even though it's on the LRUs".

For hugetlb support on gmem, using an xarray in place of a filemap should  
work
fine. Page migration could come up in future - perhaps migration code works
better with filemap? Not sure.


>> + "KVM: guest_mem: Align so that at least 1 page is allocated"
>>      + Bug in current implementation: without this alignment, fallocate()  
>> of
>>        a size less than the gmem page size will result in no allocation  
>> at all

> I'm not convinced this is a bug.  I don't see any reason to allow  
> allocating and
> punching holes in sub-page granularity.


I looked at the code more closely, you're right. len is checked to be 4K
aligned. When userspace requests a gmem page size of larger than 4K (gmem  
THP),
the allocation loop still does the right thing.

This issue only arises for hugetlb pages. I'll rebase the next revision of  
the
hugetlb series accordingly.


>>      + Both shmem and hugetlbfs perform this alignment
>> + "KVM: guest_mem: Add alignment checks"
>>      + Implemented the alignment checks for guest_mem because hugetlb on  
>> gmem
>>        would hit a BUG_ON without this check
>> + "KVM: guest_mem: Prevent overflows in kvm_gmem_invalidate_begin()"
>>      + Sean fixed a bug in the offset-to-gfn conversion in
>>        kvm_gmem_invalidate_begin() earlier, adding a WARN_ON_ONCE()

> As Mike pointed out, there's likely still a bug here[*].  I was planning  
> on
> diving into that last week, but that never happened.  If you or anyone  
> else can
> take a peek and/or write a testcase, that would be awesome.

>   : Heh, only if there's a testcase for it.  Assuming start >= the slot  
> offset does
>   : seem broken, e.g. if the range-to-invalidate overlaps multiple slots,  
> later slots
>   : will have index==slot->gmem.index > start.
>   :
>   : > Since 'index' corresponds to the gmem offset of the current slot, is  
> there any
>   : > reason not to do something like this?:
>   : >
>   : >   .start = slot->base_gfn + index - slot->gmem.index,
>   : >
>   : > But then, if that's the case, wouldn't index == slot->gmem.index?  
> Suggesting
>   : > we case just simplify to this?:
>   : >
>   : >   .start = slot->base_gfn,
>   :
>   : No, e.g. if start is partway through a memslot, there's no need to  
> invalidate
>   : the entire memslot.  I'll stare at this tomorrow when my brain is  
> hopefully a
>   : bit more functional, I suspect there is a min() and/or max() needed  
> somewhere.

> [*] https://lore.kernel.org/all/20230512002124.3sap3kzxpegwj3n2@amd.com


I think I have fixed this, please see "KVM: guest_mem: Prevent overflows in
kvm_gmem_invalidate_begin()" [1].

This patch does take into account that start could be greater than
slot->gmem.index, when userspace chooses to punch holes beginning in the  
middle
of the memslot.

The process could be split into figuring out file indices, then GFNs:

1. Figure out the start and end in terms of index in the file
     + index_start: taking max(start, slot->gmem.index)
         + start will only be greater than slot->gmem.index but not greater  
than
           the end of the slot, due to the nature of xa_for_each_range()
     + index_end: taking min(end, slot->gmem.index + slot->npages)
2. Convert indices to GFNs

This also prevents overflows as described at [1].

>> ...

[1]  
https://github.com/googleprodkernel/linux-cc/commit/bcc304e3657a998b8f61aa1b841754fbb90d8994
