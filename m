Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C0A5FB9CC
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 19:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJKRiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 13:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiJKRiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 13:38:22 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A414F12AFB
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 10:38:15 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id x18so9170635ljm.1
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 10:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ASTy3jp38n51CkkEO2l/MmR02UbjdKNfCtO2dYm1obw=;
        b=Y7Ji+9EE6yHJ/lLNaqSZcPo4O4aRr56qhFXjXUYPQzTOnzptuMwe8kepBEjSO0s8rT
         5OIMCMpi9AqfiPy/rlelt5Tces3luVxuKjj0/09SRBZT/tQk4hgIbCBDob9CNKLLUltF
         ZYq+A91X3Vx7N+9zhe/PctUTfyPWXoIcLDGjsahVOTaiuq3eNbM1Hfbgp7i3+uq128Iv
         r6ySpiDZK7sOY+udbAZVjI6sEm11O+aqYcHySZuWb5MuqOiYV2CEF72cF+Y9y+yqcmMh
         8UZiywRV6+vPEp3qkDyN3cME+dPnuLN0QNOMDkcbWXizYFMQn3rUwZQEfDiOJHBwr3OH
         lM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ASTy3jp38n51CkkEO2l/MmR02UbjdKNfCtO2dYm1obw=;
        b=n7HEtHSEywxC2ptFnOMD2WkJtW5bMOTs6IHjeC+fci+sDfVW/2EyyXyfytH5bm8aQK
         XsCybivewFptARWnM6dX/Zux2hj08nw/W3vAGnDbXyJiWwsETBQ8UQi0NWVCdBmfLksA
         foPfOYrTCUQVASI0QDJzEUprSt0b4IcK22yjYmz5AL264OFO8y5CQgHT8fJr5yhGQrdG
         6i5zLOqVJNN2rGWT9KzR59UfQSQeZ0yeKPuOkYEP7HvLaGpR1WPFA+u5EhhGtjY1RbTf
         5XqVHsff0MmgycCVE+FnlE+UCkquveEkG/dy5pO4PG2k+XnpuFucz2dA83bPkJKioMWm
         4aMw==
X-Gm-Message-State: ACrzQf2krCXCE/eX629dMzL0MHv/D/P3Rx5dclVKKILxclHTs02/Uv4/
        Owe+mVBcHy+KSKFZ0no2aJewyOV4bhQFzULn2O7HGA==
X-Google-Smtp-Source: AMsMyM7xO4MkCPUjy69frHSk+iYYvoEEAbwPa+iw5sCPNlkqqWHHHZalHxJvMqmz/w22JhcaiWQAmaASxLFaamAiTuI=
X-Received: by 2002:a2e:7c17:0:b0:26e:4f7:3c95 with SMTP id
 x23-20020a2e7c17000000b0026e04f73c95mr9634809ljc.455.1665509893631; Tue, 11
 Oct 2022 10:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com> <20220829171021.701198-4-pgonda@google.com>
 <Yz8U2k7Tu8QQNhhq@google.com>
In-Reply-To: <Yz8U2k7Tu8QQNhhq@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 11 Oct 2022 11:38:01 -0600
Message-ID: <CAMkAt6qQLO-6W8Ek-syUSzZpWLPDe8EzzfuWvY3iQZhczti7Pw@mail.gmail.com>
Subject: Re: [V4 3/8] KVM: selftests: add hooks for managing encrypted guest memory
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 6, 2022 at 11:48 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Aug 29, 2022, Peter Gonda wrote:
> > +static vm_paddr_t
> > +_vm_phy_pages_alloc(struct kvm_vm *vm, size_t num, vm_paddr_t paddr_min,
>
> Do not wrap before the function name.  Linus has a nice explanation/rant on this[*].
> Note to self, add a Vim macro for this...
>
> [*] https://lore.kernel.org/all/CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com
>

Fixed. Thanks. I'll work on a fix to my VIM setup.

> > +                 uint32_t memslot, bool encrypt)
> >  {
> >       struct userspace_mem_region *region;
> >       sparsebit_idx_t pg, base;
> > @@ -1152,12 +1156,22 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> >               abort();
> >       }
> >
> > -     for (pg = base; pg < base + num; ++pg)
> > +     for (pg = base; pg < base + num; ++pg) {
> >               sparsebit_clear(region->unused_phy_pages, pg);
> > +             if (encrypt)
>
> prefer s/encrypt/private, and s/encrypted_phy_pages/private_phy_pages.  pKVM
> doesn't rely on encryption, and it's not impossible that x86 will someday gain
> similar functionality.  And "encrypted" is also technically wrong for SEV and TDX,
> as shared memory can also be encrypted with a common key.

Makes sense. Private or protected sound better.

>
> > +                     sparsebit_set(region->encrypted_phy_pages, pg);
> > +     }
> >
> >       return base * vm->page_size;
> >  }
> >
> > +vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> > +                           vm_paddr_t paddr_min, uint32_t memslot)
> > +{
> > +     return _vm_phy_pages_alloc(vm, num, paddr_min, memslot,
> > +                                vm->memcrypt.enc_by_default);
>
> enc_by_default yields a bizarre API.  The behavior depends on whether or not the
> VM is protected, and whether or not the VM wants to protect memory by default.
>
> For simplicity, IMO vm_phy_pages_alloc() should allocate memory as private if the
> VM supports protected memory, i.e. just have vm->protected or whatever and use
> that here.

Removed "enc_by_default" concept.

>
> > +}
> > +
> >  vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
> >                            uint32_t memslot)
> >  {
> > @@ -1741,6 +1755,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
> >                       region->host_mem);
> >               fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
> >               sparsebit_dump(stream, region->unused_phy_pages, 0);
> > +             if (vm->memcrypt.enabled) {
>
> vm->protected

renamed memcrypt -> protected.

>
> > +                     fprintf(stream, "%*sencrypted_phy_pages: ", indent + 2, "");
> > +                     sparsebit_dump(stream, region->encrypted_phy_pages, 0);
> > +             }
> >       }
> >       fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
> >       sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
> > @@ -1989,3 +2007,31 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
> >               break;
> >       }
> >  }
> > +
> > +void vm_set_memory_encryption(struct kvm_vm *vm, bool enc_by_default, bool has_enc_bit,
> > +                           uint8_t enc_bit)
> > +{
> > +     vm->memcrypt.enabled = true;
> > +     vm->memcrypt.enc_by_default = enc_by_default;
> > +     vm->memcrypt.has_enc_bit = has_enc_bit;
> > +     vm->memcrypt.enc_bit = enc_bit;
> > +}
> > +
> > +const struct sparsebit *
> > +vm_get_encrypted_phy_pages(struct kvm_vm *vm, int slot, vm_paddr_t *gpa_start,
> > +                        uint64_t *size)
>
> Bad wrap.

Fixed.

>
> > +{
> > +     struct userspace_mem_region *region;
> > +
> > +     if (!vm->memcrypt.enabled)
>
> This seems rather silly, why not TEST_ASSERT()?
>
> > +             return NULL;
> > +
> > +     region = memslot2region(vm, slot);
> > +     if (!region)
>
> Same here, TEST_ASSERT() seems more appropriate.
>
> Actually, I can't envision a use outside of SEV.  AFAIK, no other architecture
> does the whole "launch update" thing.  I.e. just open code this in sev_encrypt().
> The more generic API that will be useful for other VM types will be to query if a
> specific GPA is private vs. shared.

Good point. I'll move this code into that sev_encrypt() flow and
remove this function completely.

>
> > +             return NULL;
> > +
> > +     *size = region->region.memory_size;
> > +     *gpa_start = region->region.guest_phys_addr;
> > +
> > +     return region->encrypted_phy_pages;
> > +}
> > --
> > 2.37.2.672.g94769d06f0-goog
> >
