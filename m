Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023CC769FF0
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 20:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjGaSCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 14:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjGaSCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 14:02:12 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5215171A
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:02:05 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-40c72caec5cso31701cf.0
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690826525; x=1691431325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0gCxxFfGpH7+EO1EgURYZAY2bdhrbnISyF1lBRoK6A=;
        b=qZXJd0+ffo+L4HQlrADJFOpNsrtneEkEjKGaCenKWHHQEco9dlSNxersD+gpofApiW
         o02MZh+LdJtBnpNbTaunNFo/yrUZVDlYroTi00ctwRDARSeVylQBSOGLLV6g3BPsFik1
         4KZESg4WwqRH2heMDI/gKOTA96YxqAHdeR6cwsxRS352/fhcTvniO25FMpqKBC+vkbG+
         7U3kQrA7UwBFicH5pD7tews8lYXa8aG2Rtx/WHVJ50zWYGSnD/DEpHGm5+dNWqrCjKzK
         vrB7i6HMlTdlHH7oSEErO/ezx1jdtNdTdwaGk/ao8HCv4z3XUdYfTfahIP4mt6yralea
         cWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690826525; x=1691431325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0gCxxFfGpH7+EO1EgURYZAY2bdhrbnISyF1lBRoK6A=;
        b=AqktUBnD5EMua5Ur9TlaxVyOu00JLazLaUjgQlTSzxXXsqNO8JW6UV7zxlU7xzEma6
         Zr4LdsM8vH2nUVm072sjcmxxenjWSL98uVlNtIGR8/g8CUTMMAmTMPvHlQxjTg6C2zHQ
         IbySqp8hXjtoyDZBWTQBWiNzLug4D0ENSwBRuKvdsNAWZdkAoDoOS0FyA2opCXUO3BIy
         0l1+/wWJXuiZ6WSrgcm0Dmv2I2KHHLXbONZiqWer6hIwI7Q4w7c5iUodwiwGqiy/AmKp
         Znd9NxD8xCZKQQsuG6Clqo+LXEba19ln7uGmSwf+f3hXKncGdgI0+kt+vz8tpuLUhYrN
         5Xfg==
X-Gm-Message-State: ABy/qLbx8+L76pOEGh+GNdzn3p2yUTsM83neeTdkaJmF+YS56XOYIGJu
        lYal7NK3gTzQ4u4Z0Un7HFFcWA08Jn0pbbxXShqHMw==
X-Google-Smtp-Source: APBJJlEBpxAr+gWpuQ40S4Mxoz6DvPL1ZVwppPhat0hf9uVLuJsVRwWK349Eb3xEO5XCaxjIBjS+YDqgeGbyrEVO6AI=
X-Received: by 2002:a05:622a:104d:b0:403:9572:e37f with SMTP id
 f13-20020a05622a104d00b004039572e37fmr425212qte.22.1690826524611; Mon, 31 Jul
 2023 11:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-9-rananta@google.com>
 <87o7jxr06t.wl-maz@kernel.org> <87lef1qzim.wl-maz@kernel.org>
In-Reply-To: <87lef1qzim.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 31 Jul 2023 11:01:53 -0700
Message-ID: <CAJHc60xC-Bs-0uoqkytDVcwHTxVnW7eyVxfHhO0mRrupVbdaYg@mail.gmail.com>
Subject: Re: [PATCH v7 08/12] KVM: arm64: Define kvm_tlb_flush_vmid_range()
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 6:01=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 27 Jul 2023 13:47:06 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Sat, 22 Jul 2023 03:22:47 +0100,
> > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > >
> > > Implement the helper kvm_tlb_flush_vmid_range() that acts
> > > as a wrapper for range-based TLB invalidations. For the
> > > given VMID, use the range-based TLBI instructions to do
> > > the job or fallback to invalidating all the TLB entries.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
> > >  arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
> > >  2 files changed, 30 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/includ=
e/asm/kvm_pgtable.h
> > > index 8294a9a7e566..5e8b1ff07854 100644
> > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > @@ -754,4 +754,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_pro=
t(kvm_pte_t pte);
> > >   *    kvm_pgtable_prot format.
> > >   */
> > >  enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
> > > +
> > > +/**
> > > + * kvm_tlb_flush_vmid_range() - Invalidate/flush a range of TLB entr=
ies
> > > + *
> > > + * @mmu:   Stage-2 KVM MMU struct
> > > + * @addr:  The base Intermediate physical address from which to inva=
lidate
> > > + * @size:  Size of the range from the base to invalidate
> > > + */
> > > +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > > +                           phys_addr_t addr, size_t size);
> > >  #endif     /* __ARM64_KVM_PGTABLE_H__ */
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtabl=
e.c
> > > index aa740a974e02..5d14d5d5819a 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -670,6 +670,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *p=
gt)
> > >     return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
> > >  }
> > >
> > > +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > > +                           phys_addr_t addr, size_t size)
> > > +{
> > > +   unsigned long pages, inval_pages;
> > > +
> > > +   if (!system_supports_tlb_range()) {
> > > +           kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > > +           return;
> > > +   }
> > > +
> > > +   pages =3D size >> PAGE_SHIFT;
> > > +   while (pages > 0) {
> > > +           inval_pages =3D min(pages, MAX_TLBI_RANGE_PAGES);
> > > +           kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, addr, inval=
_pages);
> > > +
> > > +           addr +=3D inval_pages << PAGE_SHIFT;
> > > +           pages -=3D inval_pages;
> > > +   }
> > > +}
> > > +
> >
> > This really shouldn't live in pgtable.c. This code gets linked into
> > the EL2 object. What do you think happens if, for some reason, this
> > gets called *from EL2*?
>
> Ah, actually, nothing too bad would happen, as we convert the
> kvm_call_hyp() into a function call.
>
> But still, we don't need two copies of this stuff, and it can live in
> mmu.c.
>
But since we have a couple of references in pgtable.c to
kvm_tlb_flush_vmid_range(), wouldn't that be an (linking) issue if we
moved the definition to mmu.c?

ld: error: undefined symbol: __kvm_nvhe_kvm_tlb_flush_vmid_range
>>> referenced by pgtable.c:1148 (./arch/arm64/kvm/hyp/nvhe/../pgtable.c:11=
48)
>>>               arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o:(__kvm_nvhe_kvm_pgtabl=
e_stage2_unmap) in archive vmlinux.a
...

Or is there some other way to make it work?

- Raghavendra

>         M.
>
> --
> Without deviation from the norm, progress is not possible.
