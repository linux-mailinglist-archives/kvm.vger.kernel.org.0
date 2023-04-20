Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428E96E9E80
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 00:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbjDTWBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 18:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbjDTWBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 18:01:30 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490502128
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 15:01:27 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-5144a9c11c7so1522942a12.2
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 15:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682028086; x=1684620086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2Ev3XkqPH6pBRfYHzJ+uQ7XVHtYSI/8IWEmQRBv/YI=;
        b=XccRPyOwGtCXf7M5O+HNfS7PIZwaQD/v87OkbY9kPKXbSXCwAHUwb77DmpKXQM0oF7
         R0iGe67jW+b5DNWOVTJNemJXy3OKOX6KdYoUmETuzx9PGEbJFJQ2pUniMRMuVPMdDiGU
         /5tCrXANgIgLRaYyadJDbdo+RbIOZFK426WywYo54ew0ofNLXcABU5+/CMzqIREzPHeY
         nozuQwG7Zt6NpmqIblntxNB1TQq9MjpSBvyrh0FYtiq26IkPB90nc3IN0Z5SPpjDuFAg
         Uf2dafkB6vN/Ipj35Qgs/T7S7nQT6pBp/glwP+uShCgN0NssPyN9BTUsrhgWhmezZtGB
         kVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682028086; x=1684620086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m2Ev3XkqPH6pBRfYHzJ+uQ7XVHtYSI/8IWEmQRBv/YI=;
        b=I/h/e3ZZalZv0qAQ8i5evKRN2/Fc7ebQCBXfcF0SYGhJsYQElCw/cuy8lFuz2j9UJu
         0Y5NwlzutQraqS0gBN03Z1fYPuKZ1q7hQyY12rQVBPjvX123Od/+kEFRPLvdpriXrWdw
         pks/3E6RHNKDXB7AXyqtq/OiFm5sve0uX3DORaGoxSQQ0VJhWei16ijEwraSKi4rgWPn
         5w25W52FM7X5l0BEbWBd1YSIJ0K37cj2XOzZn5X7Iw+jC2FfCofOsbaTcMsCVtC7ipr6
         ubgM/pySustD3q0ItYHKSpMULXKewyzU9M6qkUJqzIWGwADzA5tLoH3Zw1uLzOmLBAYO
         oeuw==
X-Gm-Message-State: AAQBX9e8aIipI6rESv0OY0fHuGY58G7D32xZiJrD4H4R+vFl7rzJbObt
        tMJEhkUg3X+LCTX8qDZOPXckckgQCDZzgnSRfCmkLQ==
X-Google-Smtp-Source: AKy350ZODjmhBgPpSK9yTOVPr1QR4R227MhIwe3aNJJTXaij0JPaPQ4lg0m0d3q6HUIib6fUODiqrkndxcAY/A+hkAo=
X-Received: by 2002:a17:90a:5509:b0:247:a272:71d1 with SMTP id
 b9-20020a17090a550900b00247a27271d1mr3035541pji.7.1682028086370; Thu, 20 Apr
 2023 15:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230419221716.3603068-1-atishp@rivosinc.com> <20230419221716.3603068-2-atishp@rivosinc.com>
 <b58eadb7-c80c-42fe-b803-09f2f466c0bd@lucifer.local>
In-Reply-To: <b58eadb7-c80c-42fe-b803-09f2f466c0bd@lucifer.local>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Fri, 21 Apr 2023 03:31:15 +0530
Message-ID: <CAHBxVyE3G975UZBhcSsJN1bUFGtnRLSuY=OLMreu5orgc2zKQw@mail.gmail.com>
Subject: Re: [RFC 01/48] mm/vmalloc: Introduce arch hooks to notify
 ioremap/unmap changes
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 1:12=E2=80=AFAM Lorenzo Stoakes <lstoakes@gmail.com=
> wrote:
>
> I'm a vmalloc reviewer too now -next/mm-unstable get_maintainer.pl should=
 say
> so, but forgivable because perhaps you ran against another tree but FYI f=
or
> future I'd appreciate a cc- :)
>

Ahh. Thanks for pointing that out. I see the patch for that now
https://lkml.org/lkml/2023/3/21/1084

This series is based on 6.3-rc4. That's probably why get_maintainer.pl
did not pick it up.
I will make sure it includes you in the future revisions.

> On Wed, Apr 19, 2023 at 03:16:29PM -0700, Atish Patra wrote:
> > From: Rajnesh Kanwal <rkanwal@rivosinc.com>
> >
> > In virtualization, the guest may need notify the host about the ioremap
> > regions. This is a common usecase in confidential computing where the
> > host only provides MMIO emulation for the regions specified by the gues=
t.
> >
> > Add a pair if arch specific callbacks to track the ioremapped regions.
>
> Nit: typo if -> of.
>

Fixed. Thanks.

> >
> > This patch is based on pkvm patches. A generic arch config can be added
> > similar to pkvm if this is going to be the final solution. The device
> > authorization/filtering approach is very different from this and we
> > may prefer that one as it provides more flexibility in terms of which
> > devices are allowed for the confidential guests.
>
> So it's an RFC that assumes existing patches are already applied or do yo=
u mean
> something else here? What do I need to do to get to a vmalloc.c with your=
 patch
> applied?
>
> I guess this is pretty nitty since your changes are small here but be goo=
d to
> know!
>

Here is a bit more context: This patch is inspired from Marc's pkvm patch[1=
]

We haven't seen a revised version of that series. Thus, we are not
sure if this is what will be the final solution for pKVM.
The alternative solution is the guest device filtering approach. We
are also tracking that which introduces a new set of functions
(ioremap_hardned)[1] for authorized devices allowed for. That series
doesn't require any changes to the vmalloc.c and this
patch can be dropped.

As the TDX implementation is not ready yet, we chose to go this way to
get the ball rolling for implementing confidential computing
in RISC-V. Our plan is to align with the solution that the upstream
community finally agrees upon.

[1] https://lore.kernel.org/kvm/20211007143852.pyae42sbovi4vk23@gator/t/#mc=
3480e2a1d69f91999aae11004941dbdfbbdd600
[2] https://github.com/intel/tdx/commit/d8bb168e10d1ba534cb83260d9a8a3c5b26=
9eb50

> >
> > Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  mm/vmalloc.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index bef6cf2..023630e 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -304,6 +304,14 @@ static int vmap_range_noflush(unsigned long addr, =
unsigned long end,
> >       return err;
> >  }
> >
> > +__weak void ioremap_phys_range_hook(phys_addr_t phys_addr, size_t size=
, pgprot_t prot)
> > +{
> > +}
> > +
> > +__weak void iounmap_phys_range_hook(phys_addr_t phys_addr, size_t size=
)
> > +{
> > +}
> > +
>
> I'm not sure if this is for efficiency by using a weak reference, however=
, and
> perhaps a nit, but I'd prefer an arch_*() that's defined in a header some=
where,
> as it does hide the call paths quite effectively.
>

Sure. Will do that.

> >  int ioremap_page_range(unsigned long addr, unsigned long end,
> >               phys_addr_t phys_addr, pgprot_t prot)
> >  {
> > @@ -315,6 +323,10 @@ int ioremap_page_range(unsigned long addr, unsigne=
d long end,
> >       if (!err)
> >               kmsan_ioremap_page_range(addr, end, phys_addr, prot,
> >                                        ioremap_max_page_shift);
> > +
> > +     if (!err)
> > +             ioremap_phys_range_hook(phys_addr, end - addr, prot);
> > +
> >       return err;
> >  }
> >
> > @@ -2772,6 +2784,10 @@ void vunmap(const void *addr)
> >                               addr);
> >               return;
> >       }
> > +
> > +     if (vm->flags & VM_IOREMAP)
> > +             iounmap_phys_range_hook(vm->phys_addr, get_vm_area_size(v=
m));
> > +
>
> There are places other than ioremap_page_range() that can set VM_IOREMAP,
> e.g. vmap_pfn(), so this may trigger with addresses other than those spec=
ified
> in the original hook. Is this intended?
>

Thanks for pointing that out. Yeah. That is not intentional.

> >       kfree(vm);
> >  }
> >  EXPORT_SYMBOL(vunmap);
> > --
> > 2.25.1
> >
