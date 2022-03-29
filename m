Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD3F4EA4D1
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 03:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiC2B7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 21:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiC2B7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 21:59:13 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1713523EC57
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 18:57:31 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id m18so11426384plx.3
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 18:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zzqizdfMhDFC7k74H2iOE4HZaWJn95Ti241LRXZIhhE=;
        b=R+kN3S1eIzfKeFkGBaiwxiQv3/FBJUHyJTljzyH/at/8lhwM3QIGA8hie5RdzRkWEC
         nUV8gAiqCi97QePeoKIV3IxBAfuYxYF2+8ZKXY2E5Kpr9zcELASArzOYw9EZ7jh++gqP
         PUOYnaON9OnNyzIjO13iUV9mX5aV0Xw3uf5qLK9Ucmg9lEMd8MzWOaq6SyaLAicsJyHX
         L/fcITcIQBl6KE/B8piUe2muqXybOXtPn1eKT6pwbr6pTGvKQOk65RRSSA4n8ebb6/vl
         BqQvnaTHAfc8M2t5TJ5TxbNTs5a9nv1tTi0ex/NY5WTEcms4QyXB2J/iG9D+4Ybr8FPK
         a0Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zzqizdfMhDFC7k74H2iOE4HZaWJn95Ti241LRXZIhhE=;
        b=mLTN69L0C2NgbPjOTskBbiSQzaI28+vBjfIHriSbd4D4QhuW/it0ALNnuTcdvpF5+M
         PLtt3ykDbDTWLTR9H3lOxcauRpgIm372Pa9jAwQ28B5wWMX8tx/CM9PprdlDQASS0ewT
         w93t7lOPeawPIfmBi5KBb2CVxA/UH4oh09NtTHCzSDZ7UR/a2oC0v0atk5PUDcq/BbBy
         UPRnUT6fNIMRyYdocq0eXUSlUtU7IAPQT5jaV8iN8/aldbfD6LPpfm+2K3PK4S38uaT1
         yGmNMZsil2hiJwpM9zU4UCw/XS5MMQBlmOcLRoY+pO2MA5OeCoivSgzks1WnhGUJLnVa
         IG7g==
X-Gm-Message-State: AOAM530ekLxe37wlU3REBHFceAdyxZhe7QwsVe06zmjQSKjkc5OjQK3i
        ccrhmQlM2WVcrW222f90PmIsa2fAE7Q+CzdkR/nMqg==
X-Google-Smtp-Source: ABdhPJx/ElUzxz1e2uidlOy7bhAdJuoC2iXQEVXSzT96Z/EvE7bvbDGmuHu9ZA3ZdG8FIZnitaqcRTmGjB/tzJBxpTU=
X-Received: by 2002:a17:902:da88:b0:156:2b13:81c5 with SMTP id
 j8-20020a170902da8800b001562b1381c5mr1572397plx.138.1648519050367; Mon, 28
 Mar 2022 18:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com> <20220311044811.1980336-2-reijiw@google.com>
 <Yjl96UQ7lUovKBWD@google.com> <CAAeT=FzELqXZiWjZ9aRNqYRbX0zx6LdhETiZUS+CMvax2vLRQw@mail.gmail.com>
 <YjrG0xiubC108tIN@google.com> <CAAeT=FxEwuwg310vhWQeBJ9UouHNaJNcPqvbLYh7nXp7aFFq=Q@mail.gmail.com>
 <Yjwf1BpigvzlT8r9@google.com>
In-Reply-To: <Yjwf1BpigvzlT8r9@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 28 Mar 2022 18:57:14 -0700
Message-ID: <CAAeT=FySq8rWnyxwgdbgdfDQDk=be0=PhsnKTyZhuvU5-=kU7g@mail.gmail.com>
Subject: Re: [PATCH v6 01/25] KVM: arm64: Introduce a validation function for
 an ID register
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 Hi Oliver,

> > > implicitly trusts the cpufeature code filtering and applies additional
> > > limitations on top of what we get back. Similarly, there are fields
> > > where KVM is more restrictive than cpufeature (ID_AA64DFR0_PMSVER).
> > >
> > > Each of those constraints could theoretically be expressed as an
> > > arm64_ftr_bits structure within KVM.
> >
> > It's not impossible but it's a bit tricky (With __arm64_ftr_reg_valid(),
> > it might look straight forward, but I don't think that treats FTR_EXACT
> > correctly. Please see update_cpu_ftr_reg).
> >
>
> Ah right. __arm64_ftr_reg_valid() needs to trust either the value that
> comes from the boot CPU, or ->safe_val if the cores are different in the
> system. And what does it mean if the caller specified FTR_EXACT?

What I was trying to say is __arm64_ftr_reg_valid() should check
if the 'bits' are the same as 'safe_bits' and should treat 'bits'
as safe if they are the same instead of calling arm64_ftr_field_valid()
as update_cpu_ftr_reg does.
In my understanding, FTR_EXACT doesn't mean only 'ftrp->safe_val'
is a safe value, but if two values are different, 'ftrp->safe_val'
is the only safe value.

> > More specific concern I have about providing the override (with the
> > existing arm64_ftr_bits) would be when field values of arm64_ftr_bits
> > (i.e. LOWER_SAFE to EXACT) in cpufeature are changed due to kernel's
> > implementation reasons, which might affect KVM (may need to pass
> > extra override to arm64_ftr_reg_valid).
> > But, by having cpufeature provide the validation based on the ID
> > register schemes, cpufeature should be changed to provide the same
> > validation in that case (i.e. if DFR0.PERFMON is changed from LOWER_SAFE
> > to EXACT like AA64DFR0.PMUVER, DFR0.PERFMON should be added in
> > arm64_ftr_bits_kvm_override with LOWER_SAFE).
> >
> > So, if I go with the option to provide override to cpufeature, IMHO it
> > would be preferable for cpufeature to provide the validation based
> > on ID schemes instead of with the current need-based policy (, which
> > might get changed) for clear separation.
>
> Sounds good. Per your suggestion above, changing the
> naming/documentation around what is being added to cpufeature removes
> the confusion that it relates to KVM and really is a precise
> implementation of the rules in the Arm ARM.
>
> > > cpufeature exposes a feature that we simply do not virtualize in KVM.
> > > That really can become a game of whack-a-mole. commit 96f4f6809bee
> > > ("KVM: arm64: Don't advertise FEAT_SPE to guests") is a good example,
> > > and I can really see no end to these sorts of issues without an
> > > overhaul. We'd need to also find a way to leverage the existing
> > > infrasturcture for working out a system-wide safe value, but this time
> > > with KVM's table of registers.
> > > KVM would then need to take a change to expose any new feature that has
> > > no involvement of EL2. Personally, I'd take that over the possibility of
> > > another unhandled feature slipping through and blowing up a guest kernel
> > > when running on newer hardware.
> >
> > Userspace with configurable ID registers would eliminate such problems
> > on known systems, but I agree that KVM itself should prevent it.
> > It will be inconvenient for some people, but it would be safer in general.
>
> We cannot require userspace to write to these registers to run a guest
> given the fact that the present ABI doesn't. Given that fact, KVM is
> still responsible for having sane default values for these registers.
>
> If a field that we do not handle implies a feature we do not virtualize
> on newer hardware, invariably our guest will see it and likely panic
> when it realizes the vCPU is out of spec.

I completely agree on this, and I will work on this separately from
this series as it is a different issue from what this series tries
to address.


> Maybe the feature bits tables is a bit extreme given the fact that it
> does define the architected handling of each field. I think the upper
> bound on register values I mentioned above would do the trick and avoid
> copy/pasting a whole set of structures we don't desperately need.

Yes, I have been thinking the same (having a max register value for each
register rather than having a max value for each field).


> > > > (dynamically generate during KVM's initialization)
> > >
> > > This was another one of my concerns with the current state of this
> > > patch. I found the register table construction at runtime hard to
> > > follow. I think it could be avoided with a helper that has a prescribed
> > > set of rules (caller-provided field definition takes precedence over the
> > > general one).
> >
> > Sure, I will improve that if I continue to keep the current way.
> > With the option of having a separate KVM's arm64_ftr_bits,
> > the code will be very different, but I will keep that in mind.
>
> arm64_ftr_bits might be a bit extreme in KVM after all, I'll retract
> that suggestion in favor of what I said above :)

Having a full set of arm64_ftr_bits in KVM I meant here is the one that
I mentioned earlier, and I am inclined to go with the option rather than
having cpufeature provide ID scheme based validation and the override
validation.  With that, KVM will still use a validation function that
cpufeture will provide, but as it is done only based on arm64_ftr_bits
provided by KVM (FTR_UNSIGNED + LOWER_SAFE entries will be generated
during KVM init, and the other entries will be statically defined in
KVM).

Compared to this separate arm64_ftr_bits option, there are two things
that I don't like a bit about the ID scheme based validation option.
One is special changes we will make in cpufeature to provide ID scheme based
validation (like for ID_AA64DFR0_EL0.PMUVER) as needed won't be used
by KVM when KVM needs another implementation (our efforts might be
wasted).  The other is (I think) it's pretty easy to forget to make
changes in cpufeature to provide ID scheme based validation for new
fields when needed.
Along with future changes to set the maximum limit for each ID register
field, I would think this separate arm64_ftr_bits option could provide
a safer way for KVM to control/maintain feature visibilities for the
guest more independently with smaller maintenance cost.

The downside of having the separate arm64_ftr_bits will be that there
are extra static arm64_ftr_bits entries that need to be defined for
FTR_SIGNED + LOWER_SAFE. It's a so big deal though because there are
just 6(?) of such entries, and I don't think we will newly have many
of such entries.

Thanks,
Reiji
