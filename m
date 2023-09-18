Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A2D7A50A4
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjIRRLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjIRRLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:11:36 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DD883
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:11:30 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-34f1ffda46fso5595ab.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695057090; x=1695661890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3k+upgBrLGSSOmHlswDoCSbrUwpeYXhWKscYPZe5kLQ=;
        b=jpuEAafRAsD6rveD9aUrpLk1zUqrDaWIyMOp4DdOydmp4GJZLQXUPa3aMBbLR0ej9s
         ChNwJcbJYAJrrTYHtQOUNzNwrKy238HWQw0UeUn4fmGybS/7cV2gXKohH6GCXm8eRGwc
         MbShtu+YvojO0J97a7g1Um8g9q33qzgkjHrWTOBm8AK4iH9Ns7CRxJaJ7gYcA+Ny1jsB
         laoTmjl7CzfwyKjYRwQg1SOSO4wlASlL9WDM6aDYrzz9ccJLFGVPlHmPkcncovOQ1pRv
         ElT8yuWMjA1sq1JfjQ8L02Yf5COdZWU2NsCGiTIy9Rf8HN3FgzzojRdvKqgqYdEZb8oO
         MqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695057090; x=1695661890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3k+upgBrLGSSOmHlswDoCSbrUwpeYXhWKscYPZe5kLQ=;
        b=lenzC5wj6oyPxsq63KO5CbLX7xCno8HqvXGgNfmb8j1/vzYrohSjgyXFAos435KmX3
         S6Q0+ReHuI5SYucm/eMcI9lSiP6YQTTnK3VZkkKNneAuOxx3+NRmqfe+dwkDbUjF9LeY
         xK17jjP5deNJ86H8jZ8/v3YpNMhzmjn8K7EvxYzFXthD/SDKmIcZE/Ds8/e/bSoWjTfP
         uOU+6tMvOwir6a5pFx1NcTaFp+rVFm4QXw4kg8BjeK0zydDtLGkWhoMGc8zxuu5kvW/Y
         XfmGCy3BzWHeyqsXjd9EyQ0yxMC+lrA8lGmoJAlb4x9sOF+DdBXn8CmSOgwIHN+qrXO/
         oqgQ==
X-Gm-Message-State: AOJu0YyLI3QzSOTmAPfY3NW7bbedZBjEHdZ7GYrbSe19HClYw5PM1alN
        MWib4Li1sXc5p96UCe26fhb4CZHpK90aFEWOAKYMig==
X-Google-Smtp-Source: AGHT+IFXnWVBdmal21Mo0WOdEFrfSBufsaS+Fo7roEwvkyqUs6Wh6JTU3kxhl16Zf6PSyXCLyOwgCR1YaZoJgobr8mg=
X-Received: by 2002:a92:c247:0:b0:346:139d:4549 with SMTP id
 k7-20020a92c247000000b00346139d4549mr459650ilo.1.1695057089709; Mon, 18 Sep
 2023 10:11:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-9-rananta@google.com>
 <ZQTEN664F/5PzyId@linux.dev> <ZQTSffkkI1x5lWIG@linux.dev>
In-Reply-To: <ZQTSffkkI1x5lWIG@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 18 Sep 2023 10:11:17 -0700
Message-ID: <CAJHc60y+xwV3oYk7-YxE1WiOfnSNFzroM419UDJwTeb=MCJdkA@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
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

On Fri, Sep 15, 2023 at 2:54=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, Sep 15, 2023 at 08:53:16PM +0000, Oliver Upton wrote:
> > Hi Raghu,
> >
> > On Thu, Aug 17, 2023 at 12:30:25AM +0000, Raghavendra Rao Ananta wrote:
> > > From: Reiji Watanabe <reijiw@google.com>
> > >
> > > KVM does not yet support userspace modifying PMCR_EL0.N (With
> > > the previous patch, KVM ignores what is written by upserspace).
> >
> > typo: userspace
> >
> > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > index ce7de6bbdc967..39ad56a71ad20 100644
> > > --- a/arch/arm64/kvm/pmu-emul.c
> > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct ar=
m_pmu *arm_pmu)
> > >      * while the latter does not.
> > >      */
> > >     kvm->arch.pmcr_n =3D arm_pmu->num_events - 1;
> > > +   kvm->arch.pmcr_n_limit =3D arm_pmu->num_events - 1;
> >
> > Can't we just get at this through the arm_pmu instance rather than
> > copying it into kvm_arch?
> >
> > >     return 0;
> > >  }
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 2075901356c5b..c01d62afa7db4 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, con=
st struct sys_reg_desc *r,
> > >     return 0;
> > >  }
> > >
> > > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r,
> > > +               u64 val)
> > > +{
> > > +   struct kvm *kvm =3D vcpu->kvm;
> > > +   u64 new_n, mutable_mask;
> > > +   int ret =3D 0;
> > > +
> > > +   new_n =3D FIELD_GET(ARMV8_PMU_PMCR_N, val);
> > > +
> > > +   mutex_lock(&kvm->arch.config_lock);
> > > +   if (unlikely(new_n !=3D kvm->arch.pmcr_n)) {
> > > +           /*
> > > +            * The vCPU can't have more counters than the PMU
> > > +            * hardware implements.
> > > +            */
> > > +           if (new_n <=3D kvm->arch.pmcr_n_limit)
> > > +                   kvm->arch.pmcr_n =3D new_n;
> > > +           else
> > > +                   ret =3D -EINVAL;
> > > +   }
> >
> > Hmm, I'm not so sure about returning an error here. ABI has it that
> > userspace can write any value to PMCR_EL0 successfully. Can we just
> > ignore writes that attempt to set PMCR_EL0.N to something higher than
> > supported by hardware? Our general stance should be that system registe=
r
> > fields responsible for feature identification are immutable after the V=
M
> > has started.
>
> I hacked up my reply and dropped some context; this doesn't read right.
> Shaoqin made the point about preventing changes to PMCR_EL0.N after the
> VM has started and I firmly agree. The behavior should be:
>
>  - Writes to PMCR always succeed
>
>  - PMCR_EL0.N values greater than what's supported by hardware are
>    ignored
>
>  - Changes to N after the VM has started are ignored.
>
Reiji and I were wondering if we should proceed with this as this
would change userspace expectation. BTW, when you said "ignored", does
that mean we silently return to userspace with a success or with EBUSY
(changing the expectations)?

Thank you.
Raghavendra
> --
> Thanks,
> Oliver
