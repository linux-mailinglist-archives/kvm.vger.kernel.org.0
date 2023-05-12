Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A901700E51
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 20:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238220AbjELSCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 14:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238306AbjELSBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 14:01:52 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90483100DD
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 11:01:12 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-645538f6101so35001691b3a.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 11:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683914472; x=1686506472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/RyvdhRSuvZsZhvfHUuTowaban3YDaGtW+c8hQBLj0=;
        b=IJUktVCGqDdARLcamFDMEGSu8Z3sEjpHgueFS689K9Sln+F1ZGXbN/RSV+LQ3Dw8iH
         1POCGYUyEgMXCbp1UoBZNPItAbqDglVKm5aWwVriowPVm3/AMSe0QeSQn2CfIgWFYpM+
         rwDcXZo/18l663XXEP4qehDysj6U7SqreJc/HM5j4K6KgrZgxyOQtItkOmKecWap8eKL
         k8bFwDCsTjB9oGGwIz4EDUpqhwcPoF9TUPFHWbmu7gbNxjoriwITGY3+xm/TogF/AYcM
         0kr1jp+FwqqLYYG/ing9cEa7NxSFX9x9t0wBcM+quZH+7NQkWvDzvrTnimYk6JemPdEN
         g/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683914472; x=1686506472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/RyvdhRSuvZsZhvfHUuTowaban3YDaGtW+c8hQBLj0=;
        b=VCH1SHYF3zFJiL4mZbX4mVdOds2I5pdUBjMJ2nCfa37Vrdcq0y+es+v+7BFKLjXB9r
         esKn1J8cabBR1d4/j9Jx0FAbuwT7cFvzXadFiTbQxiN4Qe1J++3Qrl90iyHU7De6BKI7
         1vEBTrpBKIL/fHvMvkA5epAjpGWVfcd0nqgEIFrkQvs1OFjrYVhijBtKHUBtssXbPnd+
         cvfudWQ7mb8VBEEJODH6VIue+u6ZEdT4WUgP9z459FMpBTzM+2yx16fwIoC745c9gnLk
         3gdn50OeSgs6ysbzptw+IER9mF5wMJtziu6XX+4RysqhajxHWc48Pgw0rki+upBA9a+H
         cHNA==
X-Gm-Message-State: AC+VfDwzqnBnXKKh/9ZlE4r1utJO5RlNecTU+3OI1GSEcGoqezVb/MAY
        c96prMAXm3FxUKmr0oGhCFKC6ToVQzQ=
X-Google-Smtp-Source: ACHHUZ6oEKN9QtM/X1xSAjt1bTyG5mjGAb2SF6yxjS3NMaTWMLy0GKhsobVe8roxJleXWQIy9F0G7Q5iU20=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:288d:b0:1ad:b459:a7e8 with SMTP id
 ku13-20020a170903288d00b001adb459a7e8mr2366446plb.1.1683914471769; Fri, 12
 May 2023 11:01:11 -0700 (PDT)
Date:   Fri, 12 May 2023 11:01:10 -0700
In-Reply-To: <20230512002124.3sap3kzxpegwj3n2@amd.com>
Mime-Version: 1.0
References: <ZD1oevE8iHsi66T2@google.com> <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com> <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEM5Zq8oo+xnApW9@google.com> <20230512002124.3sap3kzxpegwj3n2@amd.com>
Message-ID: <ZF5+5g5hI7xyyIAS@google.com>
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

On Thu, May 11, 2023, Michael Roth wrote:
> On Fri, Apr 21, 2023 at 06:33:26PM -0700, Sean Christopherson wrote:
> > 
> > Code is available here if folks want to take a look before any kind of formal
> > posting:
> > 
> > 	https://github.com/sean-jc/linux.git x86/kvm_gmem_solo
> 
> Hi Sean,
> 
> I've been working on getting the SNP patches ported to this but I'm having
> some trouble working out a reasonable scheme for how to work the
> RMPUPDATE hooks into the proposed design.
> 
> One of the main things is kvm_gmem_punch_hole(): this is can free pages
> back to the host whenever userspace feels like it. Pages that are still
> marked private in the RMP table will blow up the host if they aren't returned
> to the normal state before handing them back to the kernel. So I'm trying to
> add a hook, orchestrated by kvm_arch_gmem_invalidate(), to handle that,
> e.g.:
> 
>   static long kvm_gmem_punch_hole(struct file *file, int mode, loff_t offset,
>                                   loff_t len)
>   {
>           struct kvm_gmem *gmem = file->private_data;
>           pgoff_t start = offset >> PAGE_SHIFT;
>           pgoff_t end = (offset + len) >> PAGE_SHIFT;
>           struct kvm *kvm = gmem->kvm;
>   
>           /*
>            * Bindings must stable across invalidation to ensure the start+end
>            * are balanced.
>            */
>           filemap_invalidate_lock(file->f_mapping);
>           kvm_gmem_invalidate_begin(kvm, gmem, start, end);
>   
>           /* Handle arch-specific cleanups before releasing pages */
>           kvm_arch_gmem_invalidate(kvm, gmem, start, end);
>           truncate_inode_pages_range(file->f_mapping, offset, offset + len);
>   
>           kvm_gmem_invalidate_end(kvm, gmem, start, end);
>           filemap_invalidate_unlock(file->f_mapping);
>   
>           return 0;
>   }
> 
> But there's another hook, kvm_arch_gmem_set_mem_attributes(), needed to put
> the page in its intended state in the RMP table prior to mapping it into the
> guest's NPT.

IMO, this approach is wrong.  kvm->mem_attr_array is the source of truth for whether
userspace wants _guest_ physical pages mapped private vs. shared, but the attributes
array has zero insight into the _host_ physical pages.  I.e. SNP shouldn't hook
kvm_mem_attrs_changed(), because operating on the RMP from that code is fundamentally
wrong.

A good analogy is moving a memslot (ignoring that AFAIK no VMM actually moves
memslots, but it's a good analogy for KVM internals).  KVM needs to zap all mappings
for the old memslot gfn, but KVM does not create mappings for the new memslot gfn.
Same for changing attributes; unmap, but never map.

As for the unmapping side of things, kvm_unmap_gfn_range() will unmap all relevant
NPT entries, and the elevated mmu_invalidate_in_progress will prevent KVM from
establishing a new NPT mapping.  And mmu_invalidate_in_progress will reach '0' only
after both truncation _and_ kvm_vm_ioctl_set_mem_attributes() complete, i.e. KVM
can create new mappings only when both kvm->mem_attr_array and any relevant
guest_mem bindings have reached steady state.

That leaves the question of when/where to do RMP updates.  Off the cuff, I think
RMP updates (and I _think_ also TDX page conversions) should _always_ be done in
the context of either (a) file truncation (make host owned due, a.k.a. TDX reclaim)
or (b) allocating a new page/folio in guest_mem, a.k.a. kvm_gmem_get_folio().
Under the hood, even though the gfn is the same, the backing pfn is different, i.e.
installing a shared mapping should _never_ need to touch the RMP because pages
common from the normal (non-guest_mem) pool must already be host owned.

> Currently I'm calling that hook via kvm_vm_ioctl_set_mem_attributes(), just
> after kvm->mem_attr_array is updated based on the ioctl. The reasoning there
> is that KVM MMU can then rely on the existing mmu_invalidate_seq logic to
> ensure both the state in the mem_attr_array and the RMP table are in sync and
> up-to-date once MMU lock is acquired and MMU is ready to map it, or retry
> #NPF otherwise.
> 
> But for kvm_gmem_punch_hole(), kvm_vm_ioctl_set_mem_attributes() can potentially
> result in something like the following sequence if I implement things as above:
> 
>   CPU0: kvm_gmem_punch_hole():
>           kvm_gmem_invalidate_begin()
>           kvm_arch_gmem_invalidate()         // set pages to default/shared state in RMP table before free'ing
>   CPU1: kvm_vm_ioctl_set_mem_attributes():
>           kvm_arch_gmem_set_mem_attributes() // maliciously set pages to private in RMP table
>   CPU0:   truncate_inode_pages_range()       // HOST BLOWS UP TOUCHING PRIVATE PAGES
>           kvm_arch_gmem_invalidate_end()
> 
> One quick and lazy solution is to rely on the fact that
> kvm_vm_ioctl_set_mem_attributes() holds the kvm->slots_lock throughout the
> entire begin()/end() portion of the invalidation sequence, and to similarly
> hold the kvm->slots_lock throughout the begin()/end() sequence in
> kvm_gmem_punch_hole() to prevent any interleaving.
> 
> But I'd imagine overloading kvm->slots_lock is not the proper approach. But
> would introducing a similar mutex to keep these operations grouped/atomic be
> a reasonable approach to you, or should we be doing something else entirely
> here?
> 
> Keep in mind that RMP updates can't be done while holding KVM->mmu_lock
> spinlock, because we also need to unmap pages from the directmap, which can
> lead to scheduling-while-atomic BUG()s[1], so that's another constraint we
> need to work around.
> 
> Thanks!
> 
> -Mike
> 
> [1] https://lore.kernel.org/linux-coco/20221214194056.161492-7-michael.roth@amd.com/T/#m45a1af063aa5ac0b9314d6a7d46eecb1253bba7a
> 
> > 
> > [1] https://lore.kernel.org/all/ff5c5b97-acdf-9745-ebe5-c6609dd6322e@google.com
> > [2] https://lore.kernel.org/all/20230418-anfallen-irdisch-6993a61be10b@brauner
> > [3] https://lore.kernel.org/linux-mm/20200522125214.31348-1-kirill.shutemov@linux.intel.com
