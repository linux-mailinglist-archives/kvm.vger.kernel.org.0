Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8307F7A50EA
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjIRRZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjIRRZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:25:12 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF21102
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:25:06 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-41761e9181eso18801cf.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695057905; x=1695662705; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JpfHnxzUVMMWabALTl0v26Xf5DOzz1X5VHLZhINkdjo=;
        b=Rx7BWbbsqSZUN3PlfQCPOn0ru+O9NrYRPW+FT3auwtXTMBE6kxtr3EGnc6ujY2qs4j
         EyS5QoVem2C9Fm3S/RQsjW5mFOXqKP3OJ/4Y98+FiZRGHfpECcXpc3Hi/ObQ8gKS393p
         BgRypIto5q6EOFDiL9ScWOJpyZPH1fOgoMC3JbJz2vUVY83kh55JZdS94pcGzZyARZXR
         3+XK2XLEZYU1vlzLCJnlxWdJbMgiM99nOQahjDZBaDxeMEQa08aJ/afoQGwzUJlYH9aB
         eoHJSX72vJuRIonKnpV8HqOz1QRr6hEk0VUtywxNP1YcdNx1+ZIEMwOPWZyVb0rYLcFU
         kA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695057905; x=1695662705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JpfHnxzUVMMWabALTl0v26Xf5DOzz1X5VHLZhINkdjo=;
        b=V7A9QZwkEUf4d2N0Nb/BUuaBTAGOCYyf11S+8u0mvbOGy8J3xMn1/GXw3URiT4lV/k
         Sab/qeltefCSLhaskWLdDHEdBvJZh3imf9pAZithOxymuXDOI/JckcgDqpdjeHdBwtGg
         a8d2OWGC3mVywbciCFin2vdAzRYm0hhnXvAW90HS3wasSYtNtWDwfu+nJS369sX0uMK0
         /PYsUi5i4ytghI3vjOwvq47dAQ/tXnu2PFHwmxg+U9EWN/agfCInxSA+ib3fwFYPFQdS
         2t/cnjVeKIsK8HNdjR1tWkc7daD1fVcVD9PsO2IPXqOdR8SF9EJdvrVJt3OR0817Wfzf
         vxpQ==
X-Gm-Message-State: AOJu0YxUWYSs7qV1fWQO00i+ZZR5PLsu8b0ZBmzyvEAiNqLQA6LBzgOG
        7SNZYp+Q2VjdPQvN3mEFTtQ1/cGZMuudI5ucq4AhUg==
X-Google-Smtp-Source: AGHT+IGXcCZbbS4ArJa/YBg3SDkl1c2jMvOnRFmN6r7bxpBzmZyDDMDABzE75sg1fulhUmN1NSPOxFtp0zWGBCHDd4c=
X-Received: by 2002:a05:622a:1b9f:b0:3de:1aaa:42f5 with SMTP id
 bp31-20020a05622a1b9f00b003de1aaa42f5mr440373qtb.15.1695057905499; Mon, 18
 Sep 2023 10:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-2-rananta@google.com>
 <ZQSvB4ZZ25eIHt/G@linux.dev>
In-Reply-To: <ZQSvB4ZZ25eIHt/G@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 18 Sep 2023 10:24:53 -0700
Message-ID: <CAJHc60zdow4OPTh27V=LR3TNHjUqtuxq5KOqKrAj0Fyw9VORBA@mail.gmail.com>
Subject: Re: [PATCH v5 01/12] KVM: arm64: PMU: Introduce a helper to set the
 guest's PMU
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023 at 12:22=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Raghu,
>
> On Thu, Aug 17, 2023 at 12:30:18AM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Introduce a new helper function to set the guest's PMU
> > (kvm->arch.arm_pmu), and use it when the guest's PMU needs
> > to be set. This helper will make it easier for the following
> > patches to modify the relevant code.
> >
> > No functional change intended.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 52 +++++++++++++++++++++++++++------------
> >  1 file changed, 36 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 5606509724787..0ffd1efa90c07 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -865,6 +865,32 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int =
irq)
> >       return true;
> >  }
> >
> > +static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu=
)
> > +{
> > +     lockdep_assert_held(&kvm->arch.config_lock);
> > +
> > +     if (!arm_pmu) {
> > +             /*
> > +              * No PMU set, get the default one.
> > +              *
> > +              * The observant among you will notice that the supported=
_cpus
> > +              * mask does not get updated for the default PMU even tho=
ugh it
> > +              * is quite possible the selected instance supports only =
a
> > +              * subset of cores in the system. This is intentional, an=
d
> > +              * upholds the preexisting behavior on heterogeneous syst=
ems
> > +              * where vCPUs can be scheduled on any core but the guest
> > +              * counters could stop working.
> > +              */
> > +             arm_pmu =3D kvm_pmu_probe_armpmu();
> > +             if (!arm_pmu)
> > +                     return -ENODEV;
> > +     }
> > +
> > +     kvm->arch.arm_pmu =3D arm_pmu;
> > +
> > +     return 0;
> > +}
> > +
>
> I'm not too big of a fan of adding the 'default' path to this helper.
> I'd prefer it if kvm_arm_set_vm_pmu() does all the necessary
> initialization for a valid pmu instance. You then avoid introducing
> unexpected error handling where it didn't exist before.
>
>   static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
>   {
>         lockdep_assert_held(&kvm->arch.config_lock);
>
>         kvm->arch.arm_pmu =3D arm_pmu;
>   }
>
>   /*
>    * Blurb about default PMUs I'm too lazy to copy/paste
>    */
>   static int kvm_arm_set_default_pmu(struct kvm *kvm)
>   {
>         struct arm_pmu *arm_pmu =3D kvm_pmu_probe_armpmu();
>
>         if (!arm_pmu)
>                 return -ENODEV;
>
>         kvm_arm_set_pmu(kvm, arm_pmu);
>         return 0;
>   }
>
Sounds good. We can adapt to your suggestion.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver
