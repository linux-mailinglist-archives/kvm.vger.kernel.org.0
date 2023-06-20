Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948497369E0
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 12:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjFTKuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 06:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjFTKuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 06:50:15 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1F38F;
        Tue, 20 Jun 2023 03:50:14 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b50e309602so36936625ad.0;
        Tue, 20 Jun 2023 03:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687258214; x=1689850214;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7951XL+AGyfPDPVBcyQBGj0fPAuFilMzcMu5/OoYt74=;
        b=fnS8a/4VYBS/vSvyHGdyP24ps8Kq8sr63Wr4Cn+CKBIdCwmniMmjJQIShB7fHbhPok
         4Tz8DOApK/lZNktEbFb0CTD55Axu4zROPjHAYc6+zmDoDqX+AqohriDpOOaQN3d3t6YO
         WubwljD9DnaVkMpJ+ANgkaj8164ZY2AQrv3cSKs4osSMUdtI8cdJt59XQ6OQPKBDN4BA
         HGG2Pm6f8Vl5/IatHvIGVKuiGYw4tRpj875PHbwE+48tkD2gtAT0If5GHBzB/ngA9yVU
         rfO//WK2++e6S9Hf+ak9ebcfkvZQo9JogK4XbUn/3EtRLurzh5eH86GEuU3AVAYEbRDN
         BmUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687258214; x=1689850214;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7951XL+AGyfPDPVBcyQBGj0fPAuFilMzcMu5/OoYt74=;
        b=EUOGPWmEfb9oD87ZbOa1fcfNDN7DL1K+kSqerGnXpb+uFrJa+X1vTQ2ULrqrh7ajYt
         3bqfsJMejDvOgwB49/eYbym2t2eSP9F6KU5oUzpfqs1DD4BM6Br4+rxDju4qUorFBoog
         +w2sS9zvurFm1mpO9YyymOk1cfcVHEW2i/VuaQtjF9iqYETCGkUfabt12lMIES3Dacgq
         /7WCaaB+gUdrL7Xoak6sUdt5tK9825KEOZU25dnmi4X/y7DArp/JrUNM8DeRQ1zluxBo
         m3AeYxNcfawzcck1Mu+nbKi1MpMblPr0cDzIJ0HuIaSwjUn0MJx9z0GRsso59Apu+H3Z
         oHnQ==
X-Gm-Message-State: AC+VfDxEE97Ly5qhf94zS2QyZts2/LUBEyNckbNhrFgWn5AHQJt7nrkY
        jtcVwnQcj8XxtjcHg4sEjLc=
X-Google-Smtp-Source: ACHHUZ7CSMfgUHDwU9KLFxwcxS1szXOVyovRvhTVEH1gWS7z37bysU3PrZvvl2rPP84okj3F8GtMVA==
X-Received: by 2002:a17:902:6b8b:b0:1b2:1a79:147d with SMTP id p11-20020a1709026b8b00b001b21a79147dmr10591794plk.2.1687258214282;
        Tue, 20 Jun 2023 03:50:14 -0700 (PDT)
Received: from localhost ([124.170.190.103])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902e74200b001b3c892c367sm1368654plf.63.2023.06.20.03.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 03:50:13 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 20 Jun 2023 20:49:56 +1000
Message-Id: <CTHF42QOSYR0.1Y16SFUF11F3X@wheely>
Cc:     "Andrew Morton" <akpm@linux-foundation.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Alistair Popple" <apopple@nvidia.com>,
        "Anup Patel" <anup@brainfault.org>,
        "Ben Gardon" <bgardon@google.com>,
        "Borislav Petkov" <bp@alien8.de>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Chao Peng" <chao.p.peng@linux.intel.com>,
        "Christophe Leroy" <christophe.leroy@csgroup.eu>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Fabiano Rosas" <farosas@linux.ibm.com>,
        "Gaosheng Cui" <cuigaosheng1@huawei.com>,
        "Gavin Shan" <gshan@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Marc Zyngier" <maz@kernel.org>,
        "Masami Hiramatsu" <mhiramat@kernel.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Michael Larabel" <michael@michaellarabel.com>,
        "Mike Rapoport" <rppt@kernel.org>,
        "Oliver Upton" <oliver.upton@linux.dev>,
        "Paul Mackerras" <paulus@ozlabs.org>,
        "Peter Xu" <peterx@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Thomas Huth" <thuth@redhat.com>, "Will Deacon" <will@kernel.org>,
        "Zenghui Yu" <yuzenghui@huawei.com>, <kvmarm@lists.linux.dev>,
        <kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-trace-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-mm@google.com>
Subject: Re: [PATCH mm-unstable v2 06/10] kvm/powerpc: make radix page
 tables RCU safe
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Yu Zhao" <yuzhao@google.com>
X-Mailer: aerc 0.14.0
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-7-yuzhao@google.com>
 <CTH9N6UYDUM2.1974CRL32YFQC@wheely>
 <CAOUHufY8egkNrxQwd6ms4j6ziyUW5uDjD=yhkxHLqAAOGB4Ccw@mail.gmail.com>
In-Reply-To: <CAOUHufY8egkNrxQwd6ms4j6ziyUW5uDjD=yhkxHLqAAOGB4Ccw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue Jun 20, 2023 at 6:00 PM AEST, Yu Zhao wrote:
> On Tue, Jun 20, 2023 at 12:33=E2=80=AFAM Nicholas Piggin <npiggin@gmail.c=
om> wrote:
> >
> > On Sat May 27, 2023 at 9:44 AM AEST, Yu Zhao wrote:
> > > KVM page tables are currently not RCU safe against remapping, i.e.,
> > > kvmppc_unmap_free_pmd_entry_table() et al. The previous
> >
> > Minor nit but the "page table" is not RCU-safe against something. It
> > is RCU-freed, and therefore some algorithm that accesses it can have
> > the existence guarantee provided by RCU (usually there still needs
> > to be more to it).
> >
> > > mmu_notifier_ops members rely on kvm->mmu_lock to synchronize with
> > > that operation.
> > >
> > > However, the new mmu_notifier_ops member test_clear_young() provides
> > > a fast path that does not take kvm->mmu_lock. To implement
> > > kvm_arch_test_clear_young() for that path, orphan page tables need to
> > > be freed by RCU.
> >
> > Short version: clear the referenced bit using RCU instead of MMU lock
> > to protect against page table freeing, and there is no problem with
> > clearing the bit in a table that has been freed.
> >
> > Seems reasonable.
>
> Thanks. All above points taken.
>
> > > Unmapping, specifically kvm_unmap_radix(), does not free page tables,
> > > hence not a concern.
> >
> > Not sure if you really need to make the distinction about why the page
> > table is freed, we might free them via unmapping. The point is just
> > anything that frees them while there can be concurrent access, right?
>
> Correct.
>
> > > Signed-off-by: Yu Zhao <yuzhao@google.com>
> > > ---
> > >  arch/powerpc/kvm/book3s_64_mmu_radix.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kv=
m/book3s_64_mmu_radix.c
> > > index 461307b89c3a..3b65b3b11041 100644
> > > --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > > +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > > @@ -1469,13 +1469,15 @@ int kvmppc_radix_init(void)
> > >  {
> > >       unsigned long size =3D sizeof(void *) << RADIX_PTE_INDEX_SIZE;
> > >
> > > -     kvm_pte_cache =3D kmem_cache_create("kvm-pte", size, size, 0, p=
te_ctor);
> > > +     kvm_pte_cache =3D kmem_cache_create("kvm-pte", size, size,
> > > +                                       SLAB_TYPESAFE_BY_RCU, pte_cto=
r);
> > >       if (!kvm_pte_cache)
> > >               return -ENOMEM;
> > >
> > >       size =3D sizeof(void *) << RADIX_PMD_INDEX_SIZE;
> > >
> > > -     kvm_pmd_cache =3D kmem_cache_create("kvm-pmd", size, size, 0, p=
md_ctor);
> > > +     kvm_pmd_cache =3D kmem_cache_create("kvm-pmd", size, size,
> > > +                                       SLAB_TYPESAFE_BY_RCU, pmd_cto=
r);
> > >       if (!kvm_pmd_cache) {
> > >               kmem_cache_destroy(kvm_pte_cache);
> > >               return -ENOMEM;
> >
> > KVM PPC HV radix PUD level page tables use the arch/powerpc allocators
> > (for some reason), which are not RCU freed. I think you need them too?
>
> We don't. The use of the arch/powerpc allocator for PUD tables seems
> appropriate to me because, unlike PMD/PTE tables, we never free PUD
> tables during the lifetime of a VM:

Ah you're right, the pud_free only comes from the double alloc case
so it's never visible to concurrent threads.

> * We don't free PUD/PMD/PTE tables when they become empty, i.e., not
> mapping any pages but still attached. (We could in theory, as
> x86/aarch64 do.)

We may try to do that at some point, but that's not related to your
patch for now so no worries.

Thanks,
Nick
