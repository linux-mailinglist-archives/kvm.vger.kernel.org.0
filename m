Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D61748BD5
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 20:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjGES2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 14:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbjGES2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 14:28:32 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766A8113
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 11:28:30 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-401f4408955so40301cf.1
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 11:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688581709; x=1691173709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8dndtCGBviDKso48620x/RRDlxyTnfI7vX9Z8Kirm4=;
        b=qHerNChH5eP9A1oGMa/u9oWkmuCgznM2HVxsH+LjQhf818ADYLHImqByT6aQXQhInT
         lsPnmURbNPO6fppcnuOnamesFjBJKNU2VjGsp7/zxpl38hCRF7pbMARmx/fH4RtrBMXV
         lQCBcftHQe7vy8FS1hGBIKM2SVaXZc1yMDHJKL+p6iFTBjybLHnCmhC3ptpPAjUBADqF
         3xClQ5mQkWbYUptl2dibTwnozlhBXkK1U0l3tZ6Z5T6JHE7q8ixwHU+MB8RFml50gCT1
         uyWFL1uZ2eGNwS7NmGPjVfeFoLHTmgcENG6AZUnGhL3wV09Qm91ASD61v7QtiUdM7Tit
         M5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688581709; x=1691173709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8dndtCGBviDKso48620x/RRDlxyTnfI7vX9Z8Kirm4=;
        b=ludJHt4BUnp629n71eTi2LvgN3Vr+sMYWGHy43YRaZ8xI10Dr7B0mLGL/uKTGP4Mwh
         AqU8zMlGjL6JmgGTZe/EV7BA91DlOpdg+Ut3rwTVDPCHlPfQhkI84NXT8GYZy6BvEQU0
         mgvuSC0PJgR3BnH3n0ARGSUIlrtionUMC2eGSWDgv/+OObjH+dNalzse4LzdAd8KznM/
         DTzL5TBE0w17cs3rL3GWCg5uvZgz7esWv8Im5O3I1DdhBvgAfjxfkFIzhTf7KuhyF9Js
         VY6jDYDJPFgUq+jGEspREfi1u0A2lxz8tTH1ZIRNWdXXFwUoxgzmL2hgdaVKQ/OXPp/Z
         Q5wg==
X-Gm-Message-State: ABy/qLZ/FJSLSrwMe0NjS7Dlh0UXo8PMOdyoGk0D/eTLK6yguHFxKzmx
        HMuN+zaMc8tqAkeM/YMFpEf+Anz+NOWT/GzZSDOH0g==
X-Google-Smtp-Source: APBJJlGb5UHuGR9v4dIzL9FTRyvRdUi3B9fkgynBbnAtVZ2X8ICkvXAlrTkWscrnk/Iu+8sDpm99vm1xuq8baNEkTO8=
X-Received: by 2002:ac8:580b:0:b0:3ed:86f6:6eab with SMTP id
 g11-20020ac8580b000000b003ed86f66eabmr26383qtg.14.1688581709489; Wed, 05 Jul
 2023 11:28:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com> <20230621175002.2832640-8-rananta@google.com>
 <1fe280a7-0f10-e124-00aa-b137df722c33@redhat.com>
In-Reply-To: <1fe280a7-0f10-e124-00aa-b137df722c33@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 5 Jul 2023 11:28:18 -0700
Message-ID: <CAJHc60xQtjvVsWRE=w-pAioNJW6uh-qKuZz2wp6bkT=X4oCm5A@mail.gmail.com>
Subject: Re: [RESEND PATCH v5 07/11] KVM: arm64: Define kvm_tlb_flush_vmid_range()
To:     Gavin Shan <gshan@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 4, 2023 at 5:31=E2=80=AFPM Gavin Shan <gshan@redhat.com> wrote:
>
>
> On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
> > Implement the helper kvm_tlb_flush_vmid_range() that acts
> > as a wrapper for range-based TLB invalidations. For the
> > given VMID, use the range-based TLBI instructions to do
> > the job or fallback to invalidating all the TLB entries.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
> >   2 files changed, 30 insertions(+)
> >
>
> It may be reasonable to fold this to PATCH[08/11] since kvm_tlb_flush_vmi=
d_range() is
> only called by ARM64's kvm_arch_flush_remote_tlbs_range(), which is added=
 by PATCH[08/11].
> In either way, the changes look good to me:
>
Ah, the patches 10 and 11 also call kvm_tlb_flush_vmid_range(), so
probably it's better to keep the definition isolated?

Regards,
Raghavendra
> Reviewed-by: Gavin Shan <gshan@redhat.com>
>
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/=
asm/kvm_pgtable.h
> > index 4cd6762bda805..1b12295a83595 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -682,4 +682,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(=
kvm_pte_t pte);
> >    *     kvm_pgtable_prot format.
> >    */
> >   enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
> > +
> > +/**
> > + * kvm_tlb_flush_vmid_range() - Invalidate/flush a range of TLB entrie=
s
> > + *
> > + * @mmu:     Stage-2 KVM MMU struct
> > + * @addr:    The base Intermediate physical address from which to inva=
lidate
> > + * @size:    Size of the range from the base to invalidate
> > + */
> > +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > +                             phys_addr_t addr, size_t size);
> >   #endif      /* __ARM64_KVM_PGTABLE_H__ */
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index 3d61bd3e591d2..df8ac14d9d3d4 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -631,6 +631,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt=
)
> >       return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
> >   }
> >
> > +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> > +                             phys_addr_t addr, size_t size)
> > +{
> > +     unsigned long pages, inval_pages;
> > +
> > +     if (!system_supports_tlb_range()) {
> > +             kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > +             return;
> > +     }
> > +
> > +     pages =3D size >> PAGE_SHIFT;
> > +     while (pages > 0) {
> > +             inval_pages =3D min(pages, MAX_TLBI_RANGE_PAGES);
> > +             kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, addr, inval=
_pages);
> > +
> > +             addr +=3D inval_pages << PAGE_SHIFT;
> > +             pages -=3D inval_pages;
> > +     }
> > +}
> > +
> >   #define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fw=
b(pgt))
> >
> >   static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgt=
able_prot prot,
>
> Thanks,
> Gavin
>
