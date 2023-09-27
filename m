Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D917B0B28
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 19:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjI0Rgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 13:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjI0Rgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 13:36:43 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7020FE5
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 10:36:42 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c6193d6bb4so17255ad.0
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 10:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695836202; x=1696441002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qCVNsJJaiR6CMnhGVjseVngepymRi6tNcmHrCszc8zo=;
        b=1XJ1zIQeinDaZJV2XOS+9NXgpofXhIExDxbIFglZsotc8+0im3Nk9o2rDzpcCMO0h0
         rP8Vg6kU4ARl2gOUor47tpObJXZG4uzLfnwDepNqq3LyTZ7sEDypGS2hw985CBWjc0ot
         KNOJfjiUwqqHSMXLO7hj4DVCfMuein6N3eAgo0+kxvWvQ7FvHm9278D/WtIqXzPNfkr+
         FXMHgaDZzrPjfZBYWeiK/iYUOQjTq9yJQNTKUqcccb6ZsqS+mWGW/Mjq0rARbOl26Ja0
         68/G0aXl5TDoktIBASFEz9oz/rHe4RcqXdCXc+/kxkqeO4Z7apiMBAxexMzdSkvEcQAG
         /5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695836202; x=1696441002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qCVNsJJaiR6CMnhGVjseVngepymRi6tNcmHrCszc8zo=;
        b=Rf4MKueYgr8ThrhZ4wEm0bCwvbxWjTJrmCDziC/NhWOJY+aEwV5vN+SURsh+8panP/
         XsCGEwvoS8TRczm/wjsfK3/2wLdF86sMPYFuMxm0TP1THxC0tatDFEAymgfIuCCcMXz8
         zHVUL108+9tZjFjar/aOBCbhAchI0vFlJ4njeEE4b+6BfwPajZm5/jfba1HiGsYPrL5f
         M0smhNhSGuMA20qRarYKg4WEoubVIa938SqDiZ6vMR0p1FJBI9z19OpUyoW4pW4ZGIi0
         Wfk28lCJQly6EFIdtalUB0X4eky/i/RErGb1y0QwVuA1qRSThuorSmGkZfceo85TZHov
         h6cA==
X-Gm-Message-State: AOJu0YxwGSDjt2MU5loJEdZ1qZtfUQoj5GLsfE73ji5W1k98yx1a48gn
        lG6K1462UoVf3wdPrdKECigOqIfyu7b61Fe/awBEpA==
X-Google-Smtp-Source: AGHT+IEVnwRkoJxc9UMrhf/mKiCwfxKglFuJfMCXqjV+dVaug9XIC4yr0Lkz6SA1D9Le6iCxPsNM2IAH3FHBtUiQxHg=
X-Received: by 2002:a17:903:2447:b0:1bc:66f2:4bb with SMTP id
 l7-20020a170903244700b001bc66f204bbmr542482pls.8.1695836201617; Wed, 27 Sep
 2023 10:36:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com> <20230926234008.2348607-3-rananta@google.com>
 <ZRPhoExoiU3_Jvxy@linux.dev>
In-Reply-To: <ZRPhoExoiU3_Jvxy@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 27 Sep 2023 10:36:29 -0700
Message-ID: <CAJHc60wRuqo3d=7J0jkoKehsrDWbZkwy2ADrPQpqaF-YYpH6DA@mail.gmail.com>
Subject: Re: [PATCH v6 02/11] KVM: arm64: PMU: Set the default PMU for the
 guest on vCPU reset
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Wed, Sep 27, 2023 at 1:02=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghu,
>
> On Tue, Sep 26, 2023 at 11:39:59PM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > The following patches will use the number of counters information
> > from the arm_pmu and use this to set the PMCR.N for the guest
> > during vCPU reset. However, since the guest is not associated
> > with any arm_pmu until userspace configures the vPMU device
> > attributes, and a reset can happen before this event, call
> > kvm_arm_support_pmu_v3() just before doing the reset.
> >
> > No functional change intended.
>
> I would argue there still is a functional change here, as PMU
> initialization failure now shows up on a completely different ioctl for
> userspace.
>
> > @@ -216,6 +217,18 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >       vcpu->arch.reset_state.reset =3D false;
> >       spin_unlock(&vcpu->arch.mp_state_lock);
> >
> > +     if (kvm_vcpu_has_pmu(vcpu)) {
> > +             if (!kvm_arm_support_pmu_v3())
> > +                     return -EINVAL;
> > +
> > +             /*
> > +              * When the vCPU has a PMU, but no PMU is set for the gue=
st
> > +              * yet, set the default one.
> > +              */
> > +             if (unlikely(!kvm->arch.arm_pmu) && kvm_arm_set_default_p=
mu(kvm))
> > +                     return -EINVAL;
> > +     }
> > +
>
> Ah, this probably will not mix well with my recent change to get rid of
> the return value altogether from kvm_reset_vcpu() [*]. I see two ways to
> handle this:
>
>  - Add a separate helper responsible for one-time setup of the vCPU
>    called from KVM_ARM_VCPU_INIT which may fail.
>
>  - Add a check for !kvm->arch.arm_pmu to kvm_arm_pmu_v3_init().
>
> No strong preference, though.
>
Thanks for the pointer. I think adding it in kvm_arm_pmu_v3_init() may
not be feasible as the reset (reset_pmcr()) may happen before this
init and we may end up setting 0 as PMCR.N for the guest. I'll explore
the other option though.

Thank you.
Raghavendra
> [*]: https://lore.kernel.org/r/20230920195036.1169791-8-oliver.upton@linu=
x.dev
>
> --
> Thanks,
> Oliver
