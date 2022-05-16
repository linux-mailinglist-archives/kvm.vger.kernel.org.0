Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620F55293B2
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 00:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbiEPWjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 18:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbiEPWjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 18:39:03 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01C93EAA0
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:39:01 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s27so19846911ljd.2
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OsCXvHfncHhlLLrTWQCdxg6hlnwasRkg1lUsw7kVNM4=;
        b=Wqf1JIa3kAP6DvSjYshspUa8R+5s/qgJeqI47XhmMO1wfeqDe6c/3vVfh1Ge4jpxAg
         g04Icq3lAdHsu1Q2cEAwavPFtjWioosuwVRUgfUGhOW6C5knC/GIqqux8VDvMtz9s8H+
         i2eXLKd3hheWBD5lmnTiZYiyvAJpz4W0G9bR8coEQnwbo24Np7KBPgK7SA8L343Nt2yE
         JzY+gD+YL/i3pGYoWaIFEzM506cBQd0MWUS/9Zw/PGkxldlpVuY88Pu3PX7WALr25XKF
         gWFhi7LXnItuRPzay+ruEEwl0+gjRHwhodL8FXsy1QEoM8Vgg8K8+oshLizzboRLB4rJ
         ztYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OsCXvHfncHhlLLrTWQCdxg6hlnwasRkg1lUsw7kVNM4=;
        b=LLAVMDQ4u3rAdPf9YnaYgOUBDzjxthgDZwn/MHIjVJc4BukoVfEPPTDLZcNb+RDQif
         opfg6ybZBMRDi+9CobKL2wk+tNhllS3YsdsQ9/4StqhrhFnEmluFGUiJEoJKjS9dC9dY
         pve/ieMjGsl+fkSimfGQoLefOop2xNX9HHW9MFyiex8h9hfOTK4BW1lSbOUhCTu5v37o
         Rn1lFhooo5mnwb/tjm/vp2FlnOJZJDmMsy+/+nAi7SXOtoMoS7adgpy5fACF8VrCVSlE
         vMA6jyPHh8RIWhoE3cEG0aPt4zxn1ioQIPzaBX9t1Phvm/n/cbHUuX3eAS/pLorfGaFJ
         FLmQ==
X-Gm-Message-State: AOAM532wGhKRwZhh13cPOyOtcwYooyZV0V47wOQXuWKpbIhXI/VYDBE1
        Zp9akuD74sX/NtU7tdMza6LDxvS1mfs1kXjn2UFzzg==
X-Google-Smtp-Source: ABdhPJyaAElq1zXBdRfYS3WLa/GHxYARp6i2qJNR8HLo3xzeheL+WMzVUPmLwI3UiyynBv9ZBa9q0SRKpfL+BCrklrU=
X-Received: by 2002:a05:651c:1792:b0:235:1df3:7b8e with SMTP id
 bn18-20020a05651c179200b002351df37b8emr12574189ljb.464.1652740740003; Mon, 16
 May 2022 15:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com> <20220429183935.1094599-3-dmatlack@google.com>
 <YoK0yptPVNqOSlD6@xz-m1.local>
In-Reply-To: <YoK0yptPVNqOSlD6@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 16 May 2022 15:38:33 -0700
Message-ID: <CALzav=cLJtezRT_Zw=_oHKc=UyX-VhbLzgcoLC65O=WYjir_bg@mail.gmail.com>
Subject: Re: [PATCH 2/9] KVM: selftests: Add option to create 2M and 1G EPT mappings
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
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

On Mon, May 16, 2022 at 1:32 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Apr 29, 2022 at 06:39:28PM +0000, David Matlack wrote:
> > The current EPT mapping code in the selftests only supports mapping 4K
> > pages. This commit extends that support with an option to map at 2M or
> > 1G. This will be used in a future commit to create large page mappings
> > to test eager page splitting.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  tools/testing/selftests/kvm/lib/x86_64/vmx.c | 105 ++++++++++---------
> >  1 file changed, 57 insertions(+), 48 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> > index d089d8b850b5..1fa2d1059ade 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> > @@ -392,27 +392,60 @@ void nested_vmx_check_supported(void)
> >       }
> >  }
> >
> > -void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> > -                uint64_t nested_paddr, uint64_t paddr)
> > +static void nested_create_upper_pte(struct kvm_vm *vm,
> > +                                 struct eptPageTableEntry *pte,
> > +                                 uint64_t nested_paddr,
> > +                                 uint64_t paddr,
> > +                                 int current_level,
> > +                                 int target_level)
> > +{
> > +     if (!pte->readable) {
> > +             pte->writable = true;
> > +             pte->readable = true;
> > +             pte->executable = true;
> > +             pte->page_size = (current_level == target_level);
> > +             if (pte->page_size)
> > +                     pte->address = paddr >> vm->page_shift;
> > +             else
> > +                     pte->address = vm_alloc_page_table(vm) >> vm->page_shift;
> > +     } else {
> > +             /*
> > +              * Entry already present.  Assert that the caller doesn't want
> > +              * a hugepage at this level, and that there isn't a hugepage at
> > +              * this level.
> > +              */
> > +             TEST_ASSERT(current_level != target_level,
> > +                         "Cannot create hugepage at level: %u, nested_paddr: 0x%lx\n",
> > +                         current_level, nested_paddr);
> > +             TEST_ASSERT(!pte->page_size,
> > +                         "Cannot create page table at level: %u, nested_paddr: 0x%lx\n",
> > +                         current_level, nested_paddr);
> > +     }
> > +}
> > +
> > +
> > +void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> > +                  uint64_t nested_paddr, uint64_t paddr, int target_level)
> >  {
> > +     const uint64_t page_size = PG_LEVEL_SIZE(target_level);
> > +     struct eptPageTableEntry *pt;
> >       uint16_t index[4];
> > -     struct eptPageTableEntry *pml4e;
> >
> >       TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
> >                   "unknown or unsupported guest mode, mode: 0x%x", vm->mode);
> >
> > -     TEST_ASSERT((nested_paddr % vm->page_size) == 0,
> > +     TEST_ASSERT((nested_paddr % page_size) == 0,
> >                   "Nested physical address not on page boundary,\n"
> > -                 "  nested_paddr: 0x%lx vm->page_size: 0x%x",
> > -                 nested_paddr, vm->page_size);
> > +                 "  nested_paddr: 0x%lx page_size: 0x%lx",
> > +                 nested_paddr, page_size);
> >       TEST_ASSERT((nested_paddr >> vm->page_shift) <= vm->max_gfn,
> >                   "Physical address beyond beyond maximum supported,\n"
> >                   "  nested_paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
> >                   paddr, vm->max_gfn, vm->page_size);
> > -     TEST_ASSERT((paddr % vm->page_size) == 0,
> > +     TEST_ASSERT((paddr % page_size) == 0,
> >                   "Physical address not on page boundary,\n"
> > -                 "  paddr: 0x%lx vm->page_size: 0x%x",
> > -                 paddr, vm->page_size);
> > +                 "  paddr: 0x%lx page_size: 0x%lx",
> > +                 paddr, page_size);
> >       TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
> >                   "Physical address beyond beyond maximum supported,\n"
> >                   "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
> > @@ -423,49 +456,25 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> >       index[2] = (nested_paddr >> 30) & 0x1ffu;
> >       index[3] = (nested_paddr >> 39) & 0x1ffu;
> >
> > -     /* Allocate page directory pointer table if not present. */
> > -     pml4e = vmx->eptp_hva;
> > -     if (!pml4e[index[3]].readable) {
> > -             pml4e[index[3]].address = vm_alloc_page_table(vm) >> vm->page_shift;
> > -             pml4e[index[3]].writable = true;
> > -             pml4e[index[3]].readable = true;
> > -             pml4e[index[3]].executable = true;
> > -     }
> > +     pt = vmx->eptp_hva;
> >
> > -     /* Allocate page directory table if not present. */
> > -     struct eptPageTableEntry *pdpe;
> > -     pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
> > -     if (!pdpe[index[2]].readable) {
> > -             pdpe[index[2]].address = vm_alloc_page_table(vm) >> vm->page_shift;
> > -             pdpe[index[2]].writable = true;
> > -             pdpe[index[2]].readable = true;
> > -             pdpe[index[2]].executable = true;
> > -     }
> > +     for (int current_level = 3; current_level >= 0; current_level--) {
> > +             struct eptPageTableEntry *pte = &pt[index[current_level]];
> >
> > -     /* Allocate page table if not present. */
> > -     struct eptPageTableEntry *pde;
> > -     pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
> > -     if (!pde[index[1]].readable) {
> > -             pde[index[1]].address = vm_alloc_page_table(vm) >> vm->page_shift;
> > -             pde[index[1]].writable = true;
> > -             pde[index[1]].readable = true;
> > -             pde[index[1]].executable = true;
> > -     }
> > +             nested_create_upper_pte(vm, pte, nested_paddr, paddr,
> > +                                     current_level, target_level);
>
> This is going to run for the last level pte too, so maybe remove the
> "upper" prefix in the helper?

Good idea. Will do.

>
> >
> > -     /* Fill in page table entry. */
> > -     struct eptPageTableEntry *pte;
> > -     pte = addr_gpa2hva(vm, pde[index[1]].address * vm->page_size);
> > -     pte[index[0]].address = paddr >> vm->page_shift;
> > -     pte[index[0]].writable = true;
> > -     pte[index[0]].readable = true;
> > -     pte[index[0]].executable = true;
> > +             if (pte->page_size)
> > +                     break;
> >
> > -     /*
> > -      * For now mark these as accessed and dirty because the only
> > -      * testcase we have needs that.  Can be reconsidered later.
> > -      */
> > -     pte[index[0]].accessed = true;
> > -     pte[index[0]].dirty = true;
>
> Is it intended to to drop the access/dirty bits here?

This was not intentional. Thanks for catching it!
>
> > +             pt = addr_gpa2hva(vm, pte->address * vm->page_size);
> > +     }
> > +}
> > +
> > +void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> > +                uint64_t nested_paddr, uint64_t paddr)
> > +{
> > +     __nested_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
> >  }
> >
> >  /*
> > --
> > 2.36.0.464.gb9c8b46e94-goog
> >
>
> --
> Peter Xu
>
