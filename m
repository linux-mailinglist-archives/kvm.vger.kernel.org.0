Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D9339A134
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFCMju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:39:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229994AbhFCMjt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 08:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622723884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6k5ciUK+sIaydjgCr/sudyzMRQeRQr7DMKnBdxTkkZE=;
        b=BH5ZnRJ19k9yQN/KajHlq+lwhdHN4rbmWI9hTbEoCcqo9I8TWVN0/D23rJPZlJFKfKvW04
        70L0NM6k/OUijMa7iew90WSSnDWVmtwGL8GPrtO7s/snTfHwSDggxbJZ6TeDTBMwwIDlm+
        P/j74fTIpHpX0bH3l070CTCjkSQ6R8c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-sb95rwDGOraIAPhEN80vPQ-1; Thu, 03 Jun 2021 08:38:03 -0400
X-MC-Unique: sb95rwDGOraIAPhEN80vPQ-1
Received: by mail-wm1-f72.google.com with SMTP id n127-20020a1c27850000b02901717a27c785so3387948wmn.9
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 05:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6k5ciUK+sIaydjgCr/sudyzMRQeRQr7DMKnBdxTkkZE=;
        b=rqSwo3qAC0K0S0gJnid0BSKRLp5Y72MO62Zv/KScubeFT5C8pRKDpsbnY91l67RgYq
         cgNQfHPiORH+aNYQr6LLZG56SC0y1dU+8bJzSF6WpHt/kPgmgxFHdWwpibQFSRNlFQaB
         vYkDAwMtUgcHqraYx5FWsBytrVPApLp0WNIUQrRp04huI0DnoBhkVSCh6flAQDaReDSj
         gGros5H4Zw9Dhksz+rBdx2QpL3o/3cLfScMEWSdkCpagVFz/CVgWqswpKGZorLIPkXY3
         0v1ULCeMZNHkrVoPohsnS6brRjva6NIpNhl9wRRQZJgkhk8FLREKozv1nbc363AnrSM2
         mNrQ==
X-Gm-Message-State: AOAM533QIwmksv0+JEXQ7bVX3BTkc9Oeu9CXQ7L0oiHtrdpX7lV/3/dn
        9FLyugU/wB1OY67jpxPDbwcw/Tc3E9+IpY/BmtXySJS3EA6OkQtwHQjgSH+bbvQmpZQfK+xzlp6
        0ZRQL/ADmfuzf
X-Received: by 2002:a5d:4287:: with SMTP id k7mr25571964wrq.98.1622723882437;
        Thu, 03 Jun 2021 05:38:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxM5Eysmn7AfpvK4TGIsHHlar7/8HnQegM1qMM4zo5AgkevEN94wjMw62F9oOehTj6OT0PCOA==
X-Received: by 2002:a5d:4287:: with SMTP id k7mr25571955wrq.98.1622723882264;
        Thu, 03 Jun 2021 05:38:02 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id c7sm5445129wml.33.2021.06.03.05.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 05:38:01 -0700 (PDT)
Date:   Thu, 3 Jun 2021 14:37:59 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Cc:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] selftests: kvm: fix overlapping addresses in
 memslot_perf_test
Message-ID: <20210603123759.ovlgws3ycnem4t3d@gator.home>
References: <20210528191134.3740950-1-pbonzini@redhat.com>
 <285623f6-52e4-7f8d-fab6-0476a00af68b@oracle.com>
 <fc41bfc4-949f-03c5-3b20-2c1563ad7f62@redhat.com>
 <73511f2e-7b5d-0d29-b8dc-9cb16675afb3@oracle.com>
 <68bda0ef-b58f-c335-a0c7-96186cbad535@oracle.com>
 <DM8PR11MB5670B1AA392BF7502501D43B923C9@DM8PR11MB5670.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM8PR11MB5670B1AA392BF7502501D43B923C9@DM8PR11MB5670.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 05:26:33AM +0000, Duan, Zhenzhong wrote:
> > -----Original Message-----
> > From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > Sent: Thursday, June 3, 2021 7:07 AM
> > To: Paolo Bonzini <pbonzini@redhat.com>; Duan, Zhenzhong
> > <zhenzhong.duan@intel.com>
> > Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Andrew Jones
> > <drjones@redhat.com>
> > Subject: Re: [PATCH] selftests: kvm: fix overlapping addresses in
> > memslot_perf_test
> > 
> > On 30.05.2021 01:13, Maciej S. Szmigiero wrote:
> > > On 29.05.2021 12:20, Paolo Bonzini wrote:
> > >> On 28/05/21 21:51, Maciej S. Szmigiero wrote:
> > >>> On 28.05.2021 21:11, Paolo Bonzini wrote:
> > >>>> The memory that is allocated in vm_create is already mapped close
> > >>>> to GPA 0, because test_execute passes the requested memory to
> > >>>> prepare_vm.  This causes overlapping memory regions and the test
> > >>>> crashes.  For simplicity just move MEM_GPA higher.
> > >>>>
> > >>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > >>>
> > >>> I am not sure that I understand the issue correctly, is
> > >>> vm_create_default() already reserving low GPAs (around 0x10000000)
> > >>> on some arches or run environments?
> > >>
> > >> It maps the number of pages you pass in the second argument, see
> > >> vm_create.
> > >>
> > >>    if (phy_pages != 0)
> > >>      vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> > >>                                  0, 0, phy_pages, 0);
> > >>
> > >> In this case:
> > >>
> > >>    data->vm = vm_create_default(VCPU_ID, mempages, guest_code);
> > >>
> > >> called here:
> > >>
> > >>    if (!prepare_vm(data, nslots, maxslots, tdata->guest_code,
> > >>                    mem_size, slot_runtime)) {
> > >>
> > >> where mempages is mem_size, which is declared as:
> > >>
> > >>          uint64_t mem_size = tdata->mem_size ? : MEM_SIZE_PAGES;
> > >>
> > >> but actually a better fix is just to pass a small fixed value (e.g.
> > >> 1024) to vm_create_default, since all other regions are added by hand
> > >
> > > Yes, but the argument that is passed to vm_create_default() (mem_size
> > > in the case of the test) is not passed as phy_pages to vm_create().
> > > Rather, vm_create_with_vcpus() calculates some upper bound of extra
> > > memory that is needed to cover that much guest memory (including for
> > > its page tables).
> > >
> > > The biggest possible mem_size from memslot_perf_test is 512 MiB + 1
> > > page, according to my calculations this results in phy_pages of 1029
> > > (~4 MiB) in the x86-64 case and around 1540 (~6 MiB) in the s390x case
> > > (here I am not sure about the exact number, since s390x has some
> > > additional alignment requirements).
> > >
> > > Both values are well below 256 MiB (0x10000000UL), so I was wondering
> > > what kind of circumstances can make these allocations collide (maybe I
> > > am missing something in my analysis).
> > 
> > I see now that there has been a patch merged last week called
> > "selftests: kvm: make allocation of extra memory take effect" by Zhenzhong
> > that now allocates also the whole memory size passed to
> > vm_create_default() (instead of just page tables for that much memory).
> > 
> > The commit message of this patch says that "perf_test_util and
> > kvm_page_table_test use it to alloc extra memory currently", however both
> > kvm_page_table_test and lib/perf_test_util framework explicitly add the
> > required memory allocation by doing a vm_userspace_mem_region_add()
> > call for the same memory size that they pass to vm_create_default().
> > 
> > So now they allocate this memory twice.
> > 
> > @Zhenzhong: did you notice improper operation of either
> > kvm_page_table_test or perf_test_util-based tests (demand_paging_test,
> > dirty_log_perf_test,
> > memslot_modification_stress_test) before your patch?
> No
> 
> > 
> > They seem to work fine for me without the patch (and I guess other people
> > would have noticed earlier, too, if they were broken).
> > 
> > After this patch not only these tests allocate their memory twice but it is
> > harder to make vm_create_default() allocate the right amount of memory for
> > the page tables in cases where the test needs to explicitly use
> > vm_userspace_mem_region_add() for its allocations (because it wants the
> > allocation placed at a specific GPA or in a specific memslot).
> > 
> > One has to basically open-code the page table size calculations from
> > vm_create_with_vcpus() in the particular test then, taking also into account
> > that vm_create_with_vcpus() will not only allocate the passed memory size
> > (calculated page tables size) but also behave like it was allocating space for
> > page tables for these page tables (even though the passed memory size itself
> > is supposed to cover them).
> Looks we have different understanding to the parameter extra_mem_pages of vm_create_default().
> 
> In your usage, extra_mem_pages is only used for page table calculations, real extra memory allocation
> happens in the extra call of vm_userspace_mem_region_add().

Yes, this is the meaning that kvm selftests has always had for
extra_mem_pages of vm_create_default(). If we'd rather have a different
meaning, that's fine, but we need to change all the callers of the
function as well.

If we decide to leave vm_create_default() the way it was by reverting this
patch, then maybe we should consider renaming the parameter and/or
documenting the function.

Thanks,
drew

> 
> In my understanding, extra_mem_pages is used for a VM who wants a custom memory size in slot0, 
> rather than the default DEFAULT_GUEST_PHY_PAGES size.
> 
> I understood your comments and do agree that my patch bring some trouble to your code, sorry for that.
> I'm fine to revert that patch and I think it's better to let the maintainers to decide what extra_mem_pages
> Is used for.
> 
> Thanks
> Zhenzhong
> > 
> > Due to the above, I suspect the previous behavior was, in fact, correct.
> > 
> > Thanks,
> > Maciej

