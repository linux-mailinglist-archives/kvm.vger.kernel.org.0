Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE02A720C7B
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 02:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbjFCADX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 20:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjFCADR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 20:03:17 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DE11BB
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 17:03:17 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1a1fa977667so2864217fac.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 17:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685750596; x=1688342596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7HShfi++5J2EhwWlVUZ0n0KinSTI5Empl7iSlltk47U=;
        b=eeOjfV1pYEoTg2ArO6FIFiv7fWCWy+1mL3j3NuPxGHOc5m4ooNise/lzcD4UY18PqL
         K5QHHZkuMXKD5WcArmWJWZyMBS1y3BQ/lyZ4VPcs0OxYDr73Vf8NEQbrqX8Rq/vdJUZF
         yEF/Xig+o1owA2qNIkaIU3TGjDRecNfY5/8GGobfhkE0J6RCH/XBQpxRxiLTAyb+NkN6
         +op/eFn+I/Y/mWAeCDzQJ0p2x9abkWtasVO0OLzHxhJBUUc37KuD0+1I14fyvZAoVIIS
         XjY9IZpJPR7GcgeYV7d83wojijNT7Ct8DwVUX/NFaTB2JsXQCMgCI1T39JkCw80fEgfE
         RJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685750596; x=1688342596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7HShfi++5J2EhwWlVUZ0n0KinSTI5Empl7iSlltk47U=;
        b=TjKVdyBvuIXhG1Hieh9hkRLxyUus20XyZDkrA9rNHfs+UmxGfavh8N07glk4ob8kox
         jIZx17UtdnrLrYCnkHs1f3ISz10Ujx8f492SK9InSZdHutBF8CWeA7F8yonSETAOoweL
         e7AzlOohbgpuu5Neo5hlL3cZH+OD3Mqzm9GctBFVhYBGGNJ4soIuVSvMriBkEEsH/5v/
         Z0VBm877W+JuoEcICGhtXjTFFh4uLklnRnYIb16cXBC81rYTPyIclwZx17mBRDNymSHZ
         qJkJ3jKICpV6NhOhZ9++CBiQcDtG6rBiGHcPWRVLuWiv5CpAmSpNNQ4ynKBTwDCXCxYX
         yQHg==
X-Gm-Message-State: AC+VfDwIdiGUZfZNDSci832J84rTwr3cxtfPU2Uj9auXRhCa0u/sA0Bj
        PeOv4HBVbuus+SewPihVwKV5R9pHRT9rFln0Sfr61y6Z7vrLosdJ3kA=
X-Google-Smtp-Source: ACHHUZ44cUV4eYucBKN3GuJX5jHZxrspSPJYCrKqKuQg9wG/63bUKJcf+/F6/ilanpB2b7C6tSLKXooDC1BXarhaxTs=
X-Received: by 2002:a05:6870:c7a5:b0:18e:8a68:fe41 with SMTP id
 dy37-20020a056870c7a500b0018e8a68fe41mr3285243oab.56.1685750596342; Fri, 02
 Jun 2023 17:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230602005118.2899664-1-jingzhangos@google.com>
 <20230602005118.2899664-6-jingzhangos@google.com> <f314beb1e53c1cbdc46909e857a246bab242b153.camel@amazon.com>
In-Reply-To: <f314beb1e53c1cbdc46909e857a246bab242b153.camel@amazon.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 2 Jun 2023 17:03:04 -0700
Message-ID: <CAAdAUtgbNax4s-Yix6ZybhyG0boxE_2O9NQGRQEsSZ-Q2BBqKQ@mail.gmail.com>
Subject: Re: [PATCH v11 5/5] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
To:     "Jitindar Singh, Suraj" <surajjs@amazon.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oupton@google.com" <oupton@google.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "rananta@google.com" <rananta@google.com>,
        "tabba@google.com" <tabba@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "reijiw@google.com" <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-14.3 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 2, 2023 at 12:22=E2=80=AFPM Jitindar Singh, Suraj
<surajjs@amazon.com> wrote:
>
> On Fri, 2023-06-02 at 00:51 +0000, Jing Zhang wrote:
> > Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> > ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> > specific to ID register.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |   1 +
> >  arch/arm64/kernel/cpufeature.c      |   2 +-
> >  arch/arm64/kvm/sys_regs.c           | 291 +++++++++++++++++++-------
> > --
> >  3 files changed, 203 insertions(+), 91 deletions(-)
> >
> >
> > +
> > +static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > +                                     const struct sys_reg_desc *rd)
> > +{
> > +       u64 val;
> > +       u32 id =3D reg_to_encoding(rd);
> > +
> > +       val =3D read_sanitised_ftr_reg(id);
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > +       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
> > kvm_arm_pmu_get_pmuver_limit());
>
> Maybe it's never possible, but does this need a:
> pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit()) ?
Yes, will fix it and also update the comment above it.
>
> > +
> > +       return val;
> >  }
> >
> >
> Thanks
> - Suraj
Thanks,
Jing
