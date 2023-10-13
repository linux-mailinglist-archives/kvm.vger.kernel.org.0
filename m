Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABDF7C8E5A
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 22:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjJMU2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 16:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjJMU2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 16:28:19 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F44DD9
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 13:28:11 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1c9c145bb5bso10635ad.1
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 13:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697228891; x=1697833691; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQUYjiIQQuKU5hgKTdO4y33bIv6BP+oihrBBQRGii7o=;
        b=UYA8RGf51Wm2aL9KLEoBcMOSHOhgyks35se5vv9WlreKNxE3WgsMtlPVMUcq+IxrZU
         F2CqkLOyuyzm1XTZ/zMScp7bY9uAyYB7ZViTjBDlyGgvby1D/naFJrFTrcW5sf/ysRRZ
         IKexW0WeDXtOiKJE0RSYvyLXvwNEQ2t9GRWQS7kYUCnAQHCVsp0Nl4MMvUT5mwiJHO1E
         bX0Ka8j8xIznky4MbbX5FFjE48eST84GA8Hjoqb3wUTDyA+vgXa4KNR+ejkuuU68Dd7C
         jNWoZtN8YV4P3Cn9sEZ0mQbZt/iySIABLjl2w/r3yyuLcbyPJ3IlDottr7dviW9ITdyJ
         viXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697228891; x=1697833691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hQUYjiIQQuKU5hgKTdO4y33bIv6BP+oihrBBQRGii7o=;
        b=PDIpMaJJyH5v2B7as6gHXMwapC95Zt+dxXg78/RD7CSYIEOrxqINWy/ncI6ts+iMkt
         v8cIkTA/9qbpwBRa+S22eqAwFiNqt8MCp9oRgu3aZWEA3oIAvKY4lE+Wbg6xefJ0Dm9/
         78MTQK9g4ht6iwc/ct9hCMFawR1IiYXL8GOBOggSp30nh9X0w7sWdxVZzXqq6k6VFNvg
         ThF6C9Dv0H+hIFpcYHQickV+LjCaf05Ya5IAlsJwhxYQrSYQy6TPzP1+itLEc/Ys31RY
         jIIjAaLdAfrhJFPw4srnVtCLoVAi7FZ6BB0Ze/zVIDOBNTjVqmLC16G7YDpSLkhydPgf
         fi8Q==
X-Gm-Message-State: AOJu0Ywze9kn5MnnvjAg3BwX9suO3/Wp2Nb29w05grVrJgMIuSnW0MVk
        CCym47b7z5lhbHGZ+A+IM7YR/KxirjPQUGyc7ZgQXw==
X-Google-Smtp-Source: AGHT+IF+wbBQUzCClYbIsavRQnVYMQpZNLI2ELD+7IF1suaSE/kY6/BRJ0kMNOpbN7SpoHfHj5jpKNFUpadFhMTbM8Q=
X-Received: by 2002:a17:903:40c1:b0:1ca:42a:1773 with SMTP id
 t1-20020a17090340c100b001ca042a1773mr33105pld.12.1697228890595; Fri, 13 Oct
 2023 13:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-3-rananta@google.com>
 <ZSXPbKH519uWXytf@linux.dev>
In-Reply-To: <ZSXPbKH519uWXytf@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 13 Oct 2023 13:27:58 -0700
Message-ID: <CAJHc60yBnA00Vv=vVeDuS=ccN-Ak4ZEgYvCfGWcfP3g3Zq+Uzg@mail.gmail.com>
Subject: Re: [PATCH v7 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest before vCPU reset
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 3:25=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghu,
>
> On Mon, Oct 09, 2023 at 11:08:48PM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > The following patches will use the number of counters information
> > from the arm_pmu and use this to set the PMCR.N for the guest
> > during vCPU reset. However, since the guest is not associated
> > with any arm_pmu until userspace configures the vPMU device
> > attributes, and a reset can happen before this event, assign a
> > default PMU to the guest just before doing the reset.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/arm.c      | 20 ++++++++++++++++++++
> >  arch/arm64/kvm/pmu-emul.c | 12 ++----------
> >  include/kvm/arm_pmu.h     |  6 ++++++
> >  3 files changed, 28 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 78b0970eb8e6..708a53b70a7b 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1313,6 +1313,23 @@ static bool kvm_vcpu_init_changed(struct kvm_vcp=
u *vcpu,
> >                            KVM_VCPU_MAX_FEATURES);
> >  }
> >
> > +static int kvm_vcpu_set_pmu(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm *kvm =3D vcpu->kvm;
> > +
> > +     if (!kvm_arm_support_pmu_v3())
> > +             return -EINVAL;
>
> This check is pointless; the vCPU feature flags have been sanitised at
> this point, and a requirement of having PMUv3 is that this predicate is
> true.
>
Oh yes. I'll avoid this in v8.

> > +     /*
> > +      * When the vCPU has a PMU, but no PMU is set for the guest
> > +      * yet, set the default one.
> > +      */
> > +     if (unlikely(!kvm->arch.arm_pmu))
> > +             return kvm_arm_set_default_pmu(kvm);
> > +
> > +     return 0;
> > +}
> > +
>
> Apologies, I believe I was unclear last time around as to what I was
> wanting here. Let's call this thing kvm_setup_vcpu() such that we can
> add other one-time setup activities to it in the future.
>
> Something like:
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 96641e442039..4896a44108e0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1265,19 +1265,17 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu=
 *vcpu,
>                              KVM_VCPU_MAX_FEATURES);
>  }
>
> -static int kvm_vcpu_set_pmu(struct kvm_vcpu *vcpu)
> +static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
>  {
>         struct kvm *kvm =3D vcpu->kvm;
>
> -       if (!kvm_arm_support_pmu_v3())
> -               return -EINVAL;
> -
>         /*
>          * When the vCPU has a PMU, but no PMU is set for the guest
>          * yet, set the default one.
>          */
> -       if (unlikely(!kvm->arch.arm_pmu))
> -               return kvm_arm_set_default_pmu(kvm);
> +       if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
> +           kvm_arm_set_default_pmu(kvm))
> +               return -EINVAL;
>
>         return 0;
>  }
> @@ -1297,7 +1295,8 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *v=
cpu,
>
>         bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEAT=
URES);
>
> -       if (kvm_vcpu_has_pmu(vcpu) && kvm_vcpu_set_pmu(vcpu))
> +       ret =3D kvm_setup_vcpu(vcpu);
> +       if (ret)
>                 goto out_unlock;
>
>         /* Now we know what it is, we can reset it. */
>
Introducing kvm_setup_vcpu() seems better than directly calling
kvm_vcpu_set_pmu(), which feels like it's crashing a party.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver
