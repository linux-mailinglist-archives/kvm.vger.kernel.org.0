Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5355A756951
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 18:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjGQQhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 12:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjGQQhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 12:37:18 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DC3E4F
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 09:37:17 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-3460770afe2so412635ab.1
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 09:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689611836; x=1690216636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9uIEdBE5/V8mtrIJ86bMEt1YlGPQReRHT+9wS4K4FB4=;
        b=OWHrFN2QTW3UJN0pNRFGTth7sEd5Dw7sjggstuUU7FV9QMT2n63OgPRS5VJJVeGyDl
         Z1aCxXXSSL7lbOeKaqH9uzgIZoOd3a4cSFlQWY8DAAVk2hVhBktYxB3Cjl0Qr6hg0f2N
         cbxxuZL/fYo6GBCiyMmZc7+utv9P9s70Y7FI287tO+3wr0A+ZGEOlF49j/9FY9aMyq98
         SQmF6dsU04+/lJBQcBsO5YwCCOp43Pw83PRsVPqbFJUbzaSBmheT5yPv+dkXMPda7xZ+
         8g2BcY5k4LYQ+33V19zi2oOHswaaMCCFMEfRQKmssQNIZE4Z/gLXt9l18MBgmieiGH90
         hTug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689611836; x=1690216636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9uIEdBE5/V8mtrIJ86bMEt1YlGPQReRHT+9wS4K4FB4=;
        b=Rfwh9tQw6B8K3OUd4iHrQrVxwk4WgYM/6ijHvVfqYTbq1zsKA9pg9b2DyS/RDuyyFn
         ZbXf8Wla7X8PWRj+p00e0YuDCAiEqrzjbbRG1dem24fhV1tcmtFJbzCyFoB2FilsX8wq
         A+j0XO8C8ZBYAGHlBO22bCkz1Z/5i829K0SSWM0duVe2T7zWzbD9AM/C/6YNlada54W4
         H2vZ7sdsse4rFoaHgBSzmXnTUqWhZHyxuliHnM5YY2sodDHI5Wtb9UbjsqbLVpA26hkK
         wNnEVovi6JnhMuOcNeXfcE+9SxtZrfBdqERInrdq2sGD/YTF8a9TvQedavvJPt8WZljh
         9YWg==
X-Gm-Message-State: ABy/qLZkfhI3QyOLeAb//Af1xfeWbYTQh7K1dadV1ZjQySWI41KlIauV
        Q1wC+tUGkiFux4vCECrdpHlEXGnVE5Xc4L2AsN2dYQ==
X-Google-Smtp-Source: APBJJlGMfnLl/VH8ZDf7IouzF+AemA7yqLQkI7oavRJWnulUuwCOZ3ikGsNQPfEomUZ5dTddNqkXnqp2ix1LaTkk0TQ=
X-Received: by 2002:a05:6e02:1c2e:b0:348:72eb:150d with SMTP id
 m14-20020a056e021c2e00b0034872eb150dmr599165ilh.21.1689611836063; Mon, 17 Jul
 2023 09:37:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230715005405.3689586-1-rananta@google.com> <20230715005405.3689586-4-rananta@google.com>
 <199d18de-1214-7683-b87a-03cc7e49719a@redhat.com>
In-Reply-To: <199d18de-1214-7683-b87a-03cc7e49719a@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 17 Jul 2023 09:37:04 -0700
Message-ID: <CAJHc60zhVco3uTq97vDHMk8cgg1psPtwHT6MN1eKP1Yr18d9cw@mail.gmail.com>
Subject: Re: [PATCH v6 03/11] KVM: Allow range-based TLB invalidation from
 common code
To:     Shaoqin Huang <shahuang@redhat.com>
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
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
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

On Mon, Jul 17, 2023 at 4:40=E2=80=AFAM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
>
>
> On 7/15/23 08:53, Raghavendra Rao Ananta wrote:
> > From: David Matlack <dmatlack@google.com>
> >
> > Make kvm_flush_remote_tlbs_range() visible in common code and create a
> > default implementation that just invalidates the whole TLB.
> >
> > This paves the way for several future features/cleanups:
> >
> >   - Introduction of range-based TLBI on ARM.
> >   - Eliminating kvm_arch_flush_remote_tlbs_memslot()
> >   - Moving the KVM/x86 TDP MMU to common code.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  3 +++
> >   arch/x86/kvm/mmu/mmu.c          |  9 ++++-----
> >   arch/x86/kvm/mmu/mmu_internal.h |  3 ---
> >   include/linux/kvm_host.h        |  9 +++++++++
> >   virt/kvm/kvm_main.c             | 13 +++++++++++++
> >   5 files changed, 29 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index a2d3cfc2eb75..08900afbf2ad 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1804,6 +1804,9 @@ static inline int kvm_arch_flush_remote_tlbs(stru=
ct kvm *kvm)
> >               return -ENOTSUPP;
> >   }
> >
> > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages);
> > +
> >   #define kvm_arch_pmi_in_guest(vcpu) \
> >       ((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ec169f5c7dce..aaa5e336703a 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -278,16 +278,15 @@ static inline bool kvm_available_flush_remote_tlb=
s_range(void)
> >       return kvm_x86_ops.flush_remote_tlbs_range;
> >   }
> >
> > -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> > -                              gfn_t nr_pages)
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages)
> >   {
> >       int ret =3D -EOPNOTSUPP;
> >
> >       if (kvm_x86_ops.flush_remote_tlbs_range)
> >               ret =3D static_call(kvm_x86_flush_remote_tlbs_range)(kvm,=
 start_gfn,
> > -                                                                nr_pag=
es);
> > -     if (ret)
> > -             kvm_flush_remote_tlbs(kvm);
> > +                                                                     p=
ages);
> This will be good if parameter pages aligned with parameter kvm.
>
Agreed, but pulling 'pages' above brings the char count to 83. If
that's acceptable, I'm happy to do it in v7.

Thank you.
Raghavendra
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > +
> > +     return ret;
> >   }
> >
> >   static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)=
;
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_int=
ernal.h
> > index d39af5639ce9..86cb83bb3480 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -170,9 +170,6 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm=
,
> >                                   struct kvm_memory_slot *slot, u64 gfn=
,
> >                                   int min_level);
> >
> > -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> > -                              gfn_t nr_pages);
> > -
> >   /* Flush the given page (huge or not) of guest memory. */
> >   static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t g=
fn, int level)
> >   {
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index e3f968b38ae9..a731967b24ff 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
> >   void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mod=
e);
> >
> >   void kvm_flush_remote_tlbs(struct kvm *kvm);
> > +void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages=
);
> >
> >   #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> >   int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int m=
in);
> > @@ -1486,6 +1487,14 @@ static inline int kvm_arch_flush_remote_tlbs(str=
uct kvm *kvm)
> >   }
> >   #endif
> >
> > +#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > +static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> > +                                                gfn_t gfn, u64 pages)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +#endif
> > +
> >   #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
> >   void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
> >   void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d6b050786155..804470fccac7 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -366,6 +366,19 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
> >
> > +void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages=
)
> > +{
> > +     if (!kvm_arch_flush_remote_tlbs_range(kvm, gfn, pages))
> > +             return;
> > +
> > +     /*
> > +      * Fall back to a flushing entire TLBs if the architecture range-=
based
> > +      * TLB invalidation is unsupported or can't be performed for what=
ever
> > +      * reason.
> > +      */
> > +     kvm_flush_remote_tlbs(kvm);
> > +}
> > +
> >   static void kvm_flush_shadow_all(struct kvm *kvm)
> >   {
> >       kvm_arch_flush_shadow_all(kvm);
>
> --
> Shaoqin
>
