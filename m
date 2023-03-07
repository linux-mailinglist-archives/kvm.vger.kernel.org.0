Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E12F6AE5FD
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 17:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCGQKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 11:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjCGQKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 11:10:11 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3242DE79
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 08:09:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id w192-20020a25dfc9000000b009fe14931caaso14521984ybg.7
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 08:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678205341;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F/kB0IypJg6aZTqiDMRZ19llJnUhGLwpqU6UaEdUNes=;
        b=Qcv9UAxgt3xsVviKCRDvfMjfSgCYyxThyJGUY1uqeSnXtz2UObx094Vce9b2Sjr0vO
         rZfRWAve4F+sOI/kLHx3odrPVjgMDXWP35fXk5n1l9aOU2uIfHqByiMqkq7HSmz36s8S
         Ry20+D8/KTN8vxqL783LbfpBBCErpSjNNZyuJGb9ZBkimBaGSQYcnFRb6TIz8Vw0ViDY
         tYgvEj3YZUTsjHevcqe4fyqrGGhIfR8AL1vfxndlyfXrDW5BYdt2Lha0/cSM149UKLgt
         BRneD96KqX1yJz9SkiYDDfefLf59pbsFXmMycCg1pu22Nmt2iVGJPrx8KLT98QHVOT0o
         qsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678205341;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F/kB0IypJg6aZTqiDMRZ19llJnUhGLwpqU6UaEdUNes=;
        b=LIwFBDhteKB7vFbXOF0TbY39mFZ09J4CtPh1PVDa+Mf1L0CsVlEFLkH19Kwh+R0AVB
         8Ub63KcKpjnCD+ny4ldFLvgOiQcd7QzeHt6lvhufU8qbT7idUhBLuqDh2xAlDhELaRJg
         iB+mnkDyl9D4Vnw07w59tYCYXhvjGeoW5gKRHwXysJstIiz46WzEY47AgEXziJ3yRw6U
         ksfyvCcygea1vV8JKKtHNa5wGkKm/Z77OnAAk1vXja21veaK3amwCl7gL10e+7rEal9t
         HsT+7opFIiUQghErzIKX4GnIyBgS8J3t969XyOZd5VItQaxJyJiJgW4t7MeTk8LMyfuC
         Fx1g==
X-Gm-Message-State: AO0yUKVdl3/W/KliQU2gLIaWbJpdaZGx2Lc19uqUyD2o5s6lQlB9GZ0m
        KUh5ZsdRs6v/+XWFkPiGM1uX4A7Yfng=
X-Google-Smtp-Source: AK7set/VaM/tRd87+KvjpO4jP7xvodLAwtiDafs6T4TQLSxQiVQL+0JvQJwZHuvJg43BGTQ4mobDppzr77s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b71c:0:b0:536:7529:55b4 with SMTP id
 v28-20020a81b71c000000b00536752955b4mr9597369ywh.3.1678205341764; Tue, 07 Mar
 2023 08:09:01 -0800 (PST)
Date:   Tue, 7 Mar 2023 08:09:00 -0800
In-Reply-To: <CAAeT=FyCQxhhFqhfWbFQB9uAcUxmktRa3SC_Yfne2f_MEeXOJw@mail.gmail.com>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-11-rananta@google.com>
 <CAAeT=FyCQxhhFqhfWbFQB9uAcUxmktRa3SC_Yfne2f_MEeXOJw@mail.gmail.com>
Message-ID: <ZAdhnOzIcjZBWgmc@google.com>
Subject: Re: [REPOST PATCH 10/16] selftests: KVM: aarch64: Add KVM EVTYPE
 filter PMU test
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RESEND is the "standard" tag, not REPOST.

On Mon, Mar 06, 2023, Reiji Watanabe wrote:
> Hi Raghu,
>=20
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > KVM doest't allow the guests to modify the filter types
> > such counting events in nonsecure/secure-EL2, EL3, and
> > so on. Validate the same by force-configuring the bits
> > in PMXEVTYPER_EL0, PMEVTYPERn_EL0, and PMCCFILTR_EL0
> > registers.
> >
> > The test extends further by trying to create an event
> > for counting only in EL2 and validates if the counter
> > is not progressing.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> > +static void guest_evtype_filter_test(void)
> > +{
> > +       int i;
> > +       struct pmc_accessor *acc;
> > +       uint64_t typer, cnt;
> > +       struct arm_smccc_res res;
> > +
> > +       pmu_enable();
> > +
> > +       /*
> > +        * KVM blocks the guests from creating events for counting in S=
ecure/Non-Secure Hyp (EL2),
> > +        * Monitor (EL3), and Multithreading configuration. It applies =
the mask
> > +        * ARMV8_PMU_EVTYPE_MASK against guest accesses to PMXEVTYPER_E=
L0, PMEVTYPERn_EL0,
> > +        * and PMCCFILTR_EL0 registers to prevent this. Check if KVM ho=
nors this using all possible
> > +        * ways to configure the EVTYPER.
> > +        */
>=20
> I would prefer to break long lines into multiple lines for these comments
> (or other comments in these patches), as "Linux kernel coding style"
> suggests.

+1.  And on the other side of the coin, wrap the changelog closer to ~75 ch=
ars,
~54 chars is waaay too aggressive.
