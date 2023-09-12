Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73AA79C46B
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbjILDw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237771AbjILDwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:52:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880B6AF;
        Mon, 11 Sep 2023 20:52:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A10CC433C9;
        Tue, 12 Sep 2023 03:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694490733;
        bh=WqtyR6TyE2OiwN9Ksz+X7wHBgrKGw+Y7ijGlSzfZmqw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=H+83pHrfPKWcgEp4xNyLlDqq2G+A7bJcjbqLZcTgEPHze/tRozW+wdUIzLWlQK+fl
         9lGaj325gIxmAvSRrOIiGs8lCzsgqSW5zjvEu5a1HfbUoIXJAtJP+Yndo0/HM2RIFQ
         9sLIfuhIMGRGsLEjxXVS+Hdh1JHFUKkR2wzpOlRSL2JwSRGv5A8QsvZJfdKCdUapXG
         ALV8zCO1wmsV4JNHYm+2yqpcT4H5/fLzGy8LKX7RTo64hqsWdtXXQZB2xnneyOFZFN
         qOHM2P4Gpn8Q9euuw+W37cPATd7d5eeli2lNbwyziLYL0mBAlblVGJtk6wSTfxAxo7
         Gi7k3tEw+wksA==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2bceca8a41aso82494191fa.0;
        Mon, 11 Sep 2023 20:52:13 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx4wHgcQQjbRoY4o1baAWl033QhGmDCksLf82DugLuFuFdTtaad
        y9YuxJPd7hZW6hbxdceUt5XGZDrg0+ndEedxV/c=
X-Google-Smtp-Source: AGHT+IFTeWfLmYlpWNn+ra8nqvwqS5UVyI2/EdimCPz3OodsUCMrXm5acnaN1t3VEu17oBXGrc+tsWOOlAASLGgO9bM=
X-Received: by 2002:a2e:9bcf:0:b0:2bc:b6b0:1c4d with SMTP id
 w15-20020a2e9bcf000000b002bcb6b01c4dmr9287945ljj.10.1694490731299; Mon, 11
 Sep 2023 20:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-17-zhaotianrui@loongson.cn> <CAAhV-H497R=B3KaO8Z5ig2Nwst10dm63eiPnDpfNbFCxG4uVKg@mail.gmail.com>
 <7379be58-30a5-1f0f-2e13-ca51b7cff096@loongson.cn>
In-Reply-To: <7379be58-30a5-1f0f-2e13-ca51b7cff096@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Tue, 12 Sep 2023 11:51:58 +0800
X-Gmail-Original-Message-ID: <CAAhV-H51vjwuUgS-GEkMbDs+JAdmT0i3vd13RwuvYju=GwELFw@mail.gmail.com>
Message-ID: <CAAhV-H51vjwuUgS-GEkMbDs+JAdmT0i3vd13RwuvYju=GwELFw@mail.gmail.com>
Subject: Re: [PATCH v20 16/30] LoongArch: KVM: Implement update VM id function
To:     bibo mao <maobibo@loongson.cn>
Cc:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023 at 6:23=E2=80=AFPM bibo mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> =E5=9C=A8 2023/9/11 18:00, Huacai Chen =E5=86=99=E9=81=93:
> > Hi, Tianrui,
> >
> > On Thu, Aug 31, 2023 at 4:30=E2=80=AFPM Tianrui Zhao <zhaotianrui@loong=
son.cn> wrote:
> >>
> >> Implement kvm check vmid and update vmid, the vmid should be checked b=
efore
> >> vcpu enter guest.
> >>
> >> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> >> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> >> ---
> >>  arch/loongarch/kvm/vmid.c | 66 ++++++++++++++++++++++++++++++++++++++=
+
> >>  1 file changed, 66 insertions(+)
> >>  create mode 100644 arch/loongarch/kvm/vmid.c
> >>
> >> diff --git a/arch/loongarch/kvm/vmid.c b/arch/loongarch/kvm/vmid.c
> >> new file mode 100644
> >> index 0000000000..fc25ddc3b7
> >> --- /dev/null
> >> +++ b/arch/loongarch/kvm/vmid.c
> >> @@ -0,0 +1,66 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> >> + */
> >> +
> >> +#include <linux/kvm_host.h>
> >> +#include "trace.h"
> >> +
> >> +static void _kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
> >> +{
> >> +       struct kvm_context *context;
> >> +       unsigned long vpid;
> >> +
> >> +       context =3D per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
> >> +       vpid =3D context->vpid_cache + 1;
> >> +       if (!(vpid & vpid_mask)) {
> >> +               /* finish round of 64 bit loop */
> >> +               if (unlikely(!vpid))
> >> +                       vpid =3D vpid_mask + 1;
> >> +
> >> +               /* vpid 0 reserved for root */
> >> +               ++vpid;
> >> +
> >> +               /* start new vpid cycle */
> >> +               kvm_flush_tlb_all();
> >> +       }
> >> +
> >> +       context->vpid_cache =3D vpid;
> >> +       vcpu->arch.vpid =3D vpid;
> >> +}
> >> +
> >> +void _kvm_check_vmid(struct kvm_vcpu *vcpu)
> >> +{
> >> +       struct kvm_context *context;
> >> +       bool migrated;
> >> +       unsigned long ver, old, vpid;
> >> +       int cpu;
> >> +
> >> +       cpu =3D smp_processor_id();
> >> +       /*
> >> +        * Are we entering guest context on a different CPU to last ti=
me?
> >> +        * If so, the vCPU's guest TLB state on this CPU may be stale.
> >> +        */
> >> +       context =3D per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
> >> +       migrated =3D (vcpu->cpu !=3D cpu);
> >> +
> >> +       /*
> >> +        * Check if our vpid is of an older version
> >> +        *
> >> +        * We also discard the stored vpid if we've executed on
> >> +        * another CPU, as the guest mappings may have changed without
> >> +        * hypervisor knowledge.
> >> +        */
> >> +       ver =3D vcpu->arch.vpid & ~vpid_mask;
> >> +       old =3D context->vpid_cache  & ~vpid_mask;
> >> +       if (migrated || (ver !=3D old)) {
> >> +               _kvm_update_vpid(vcpu, cpu);
> >> +               trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
> >> +               vcpu->cpu =3D cpu;
> >> +       }
> >> +
> >> +       /* Restore GSTAT(0x50).vpid */
> >> +       vpid =3D (vcpu->arch.vpid & vpid_mask)
> >> +               << CSR_GSTAT_GID_SHIFT;
> >> +       change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
> >> +}
> > I believe that vpid and vmid are both GID in the gstat register, so
> > please unify their names. And I think vpid is better than vmid.
>
> For processor 3A5000 vpid is the same with vmid, with next generation pro=
cessor
> like 3A6000, it is seperated. vpid is for vcpu specific and represents
> translation from gva to gpa; vmid is the whole vm and represents translat=
ion
> from gpa to hpa, all vcpus shares the same vmid, so that tlb indexed with=
 vpid
> will be still in effective when flushing shadow tlbs indexed with vmid.
>
> Only that VM patch for 3A6000 is not submitted now, generation method for
> vpid and vmid will be much different. It is prepared for future processor
> update :)
If so, then I think there should be a 'vmid' in kvm_arch and a 'vpid'
in kvm_vcpu_arch?
This patch only handles kvm_vcpu_arch so I think all should be vpid here.

And again, this code can be just put in main.c.

Huacai

>
> Regards
> Bibo Mao
>
> >
> > Moreover, no need to create a vmid.c file, just putting them in main.c =
is OK.
> >
> > Huacai
> >
> >> --
> >> 2.27.0
> >>
>
