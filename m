Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DC67A4FDA
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjIRQyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbjIRQyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:54:07 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A518E
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:54:01 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-34f1ffda46fso3125ab.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695056041; x=1695660841; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oHHBXB7OiO4Q0/ZpersSkTeisz2ge4lrD5qNMR0qqNg=;
        b=xWI2gTSuw6ufOhOV6L0lK0d/4g1LxKHokKok+8TaFnCb3+6YgksntfSdbbaYPF6tQp
         pjAJqVC0chNyx3sBRUdeKgtHYNNySrmMDqKWQoaWBPpVPAPTC9jNzQ6b9Dg6JCoSocJP
         58Zw/QgLcMSuqFxGj7S61OEhZJUU3hkqT6+flFgLGPlgP6b6hdtMM9P1gcq4+Hxlo5W1
         d4qVoxC1rLxdwjZ7iAxSu8ap/77+CA33QUEzLSHfV4D+wC8wdZ97Ny/1d+X7eaTJ4iNu
         btyiRCmkOIbi1jMvOBfuHZVYlWYPjmurPSfv4Dte9qrHcd+RGWrNVced3v72+lH1LIVU
         SdAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056041; x=1695660841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oHHBXB7OiO4Q0/ZpersSkTeisz2ge4lrD5qNMR0qqNg=;
        b=NNXKd28sJHCyw3Eez3MszkVOswl7ZNcJlTttW6oZp3XM+dRZzStk4agYBLM1NXFR3L
         IQSFDPuYfT1rhAexrW/TYejovAPmijDOKkWjwv2O69x88ck1iC8I7IBKo3wDmP0O8V0O
         YHzCDgaB6pB23XnXtG0BgXJCrR7eVu9P3kh1ZzvSJzxbcV68u5305JDSSE+Je8OgG3HN
         LFGElF/PT/4fk+NpHNU4hcNoKOOk6uqwlEFoe5z+2eeKIy0PZbKlrGKBIoZmOBN9R+HB
         BwX9py9ulKUrb6kb0pWDCd5tjDA30gfRRBVM2/cp30eblBvWffWoQ3qCPHFSwW/GOS1M
         rjoQ==
X-Gm-Message-State: AOJu0Yxeo0uMafYQRo4NqCOkDuETxp9eIykXwk3JU70wVhWcg9SKDJSZ
        6QOQ8fh7a2riFlyZYod3GR8VW4YvgDbbBHOmIjhW8s302isQtttuIRc=
X-Google-Smtp-Source: AGHT+IFKf7h1uNj8BiP8RqPjkOv3MhSdNsSVQ14+FdOeI1tARZhJZsMLggVxJqfdfJSHsDQPLgg4E6V1ESmorUtar5Y=
X-Received: by 2002:a05:6e02:1947:b0:34f:21e9:7239 with SMTP id
 x7-20020a056e02194700b0034f21e97239mr549614ilu.23.1695056040706; Mon, 18 Sep
 2023 09:54:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-6-rananta@google.com>
 <ZQS28e8b4YduMkdE@linux.dev>
In-Reply-To: <ZQS28e8b4YduMkdE@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 18 Sep 2023 09:53:48 -0700
Message-ID: <CAJHc60wisqXL52U_2852kbep8qQmDY7bnpbQJFP4pX9gR=Aarg@mail.gmail.com>
Subject: Re: [PATCH v5 05/12] KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Fri, Sep 15, 2023 at 12:56=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> +cc will, rutland
>
> Hi Raghu,
>
> Please make sure you cc the right folks for changes that poke multiple
> subsystems.
>
> The diff looks OK, but I'm somewhat dubious of the need for this change
> in the context of what you're trying to accomplish for KVM. I'd prefer
> we either leave the existing definition/usage intact or rework *all* of
> the PMUv3 masks to be of the shifted variety.
>
I believe the original intention was to make accessing the PMCR.N
field simple. However, if you feel its redundant and is unnecessary
for this series I'm happy to drop the patch.

Thank you.
Raghavendra
> On Thu, Aug 17, 2023 at 12:30:22AM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Some code extracts PMCR_EL0.N using ARMV8_PMU_PMCR_N_SHIFT and
> > ARMV8_PMU_PMCR_N_MASK. Define ARMV8_PMU_PMCR_N (0x1f << 11),
> > and simplify those codes using FIELD_GET() and/or ARMV8_PMU_PMCR_N.
> > The following patches will also use these macros to extract PMCR_EL0.N.
>
> Changelog is a bit wordy:
>
>   Define a shifted mask for accessing PMCR_EL0.N amenable to the use of
>   bitfield accessors and convert the existing, open-coded mask shifts to
>   the new definition.
>
> > No functional change intended.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/pmu-emul.c      | 3 +--
> >  arch/arm64/kvm/sys_regs.c      | 7 +++----
> >  drivers/perf/arm_pmuv3.c       | 3 +--
> >  include/linux/perf/arm_pmuv3.h | 2 +-
> >  4 files changed, 6 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index b87822024828a..f7b5fa16341ad 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -245,9 +245,8 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
> >
> >  u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
> >  {
> > -     u64 val =3D __vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SH=
IFT;
> > +     u64 val =3D FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR=
_EL0));
> >
> > -     val &=3D ARMV8_PMU_PMCR_N_MASK;
> >       if (val =3D=3D 0)
> >               return BIT(ARMV8_PMU_CYCLE_IDX);
> >       else
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 39e9248c935e7..30108f09e088b 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -750,7 +750,7 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const =
struct sys_reg_desc *r)
> >               return 0;
> >
> >       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> > -     pmcr =3D read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_=
PMU_PMCR_N_SHIFT);
> > +     pmcr =3D read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N;
> >       if (!kvm_supports_32bit_el0())
> >               pmcr |=3D ARMV8_PMU_PMCR_LC;
> >
> > @@ -858,10 +858,9 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, s=
truct sys_reg_params *p,
> >
> >  static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
> >  {
> > -     u64 pmcr, val;
> > +     u64 val;
> >
> > -     pmcr =3D __vcpu_sys_reg(vcpu, PMCR_EL0);
> > -     val =3D (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
> > +     val =3D FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0=
));
> >       if (idx >=3D val && idx !=3D ARMV8_PMU_CYCLE_IDX) {
> >               kvm_inject_undefined(vcpu);
> >               return false;
> > diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> > index 08b3a1bf0ef62..7618b0adc0b8c 100644
> > --- a/drivers/perf/arm_pmuv3.c
> > +++ b/drivers/perf/arm_pmuv3.c
> > @@ -1128,8 +1128,7 @@ static void __armv8pmu_probe_pmu(void *info)
> >       probe->present =3D true;
> >
> >       /* Read the nb of CNTx counters supported from PMNC */
> > -     cpu_pmu->num_events =3D (armv8pmu_pmcr_read() >> ARMV8_PMU_PMCR_N=
_SHIFT)
> > -             & ARMV8_PMU_PMCR_N_MASK;
> > +     cpu_pmu->num_events =3D FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr=
_read());
> >
> >       /* Add the CPU cycles counter */
> >       cpu_pmu->num_events +=3D 1;
> > diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pm=
uv3.h
> > index e3899bd77f5cc..ecbcf3f93560c 100644
> > --- a/include/linux/perf/arm_pmuv3.h
> > +++ b/include/linux/perf/arm_pmuv3.h
> > @@ -216,7 +216,7 @@
> >  #define ARMV8_PMU_PMCR_LC    (1 << 6) /* Overflow on 64 bit cycle coun=
ter */
> >  #define ARMV8_PMU_PMCR_LP    (1 << 7) /* Long event counter enable */
> >  #define ARMV8_PMU_PMCR_N_SHIFT       11  /* Number of counters support=
ed */
> > -#define ARMV8_PMU_PMCR_N_MASK        0x1f
> > +#define      ARMV8_PMU_PMCR_N        (0x1f << ARMV8_PMU_PMCR_N_SHIFT)
> >  #define ARMV8_PMU_PMCR_MASK  0xff    /* Mask for writable bits */
> >
> >  /*
> > --
> > 2.41.0.694.ge786442a9b-goog
> >
> >
>
> --
> Thanks,
> Oliver
