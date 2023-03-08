Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AA46B1268
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 20:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjCHTr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 14:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjCHTrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 14:47:32 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25020D23BF
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 11:47:04 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id x10-20020a170902ea8a00b0019cdb7d7f91so9861690plb.4
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 11:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678304799;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8K+skstIorBf4DO4xiKvTjFg8B1guHfyomv2cSoRlkU=;
        b=oscWZyVIKuD+5RN/CYMNwzMIZRLVDkku3qenfsQklmPOETHDtIdc1HtIwUHIZhvNs4
         4AhSIzg9/KYMps9YAxzd4/K479WPdDZ2cct89YxB13X70dp9Hx2SVrC6Hw3gcvMNYKOD
         lx6Yo1IbkjZorpNEAhs/1YwbbEK0ZnP+qwNQcAGJ5TD5sjpY1oR9t/VAfHTB1Oj8AQVc
         IjtnWHCsZvBruZaKWuYjMdxmelLbl+hWLHRflroo0mEsX6nKF7CD0hyKbHfxuNIpueqT
         rFE6YjRv1hsThI05exIfK5ifiSQjo4qQ+cJX4Ru0Hddox6g7T/fB0CySPV6lSO2iOfmu
         fcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678304799;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8K+skstIorBf4DO4xiKvTjFg8B1guHfyomv2cSoRlkU=;
        b=nupsV1F055hzuanYjye8qqrx/MMXIgrYKLbH2KZiM+AtRH0OMDn7TcflRZ5Lj8bdpM
         X6sZZmWX+1UGC5+++vdm78/i5I5lzXmWSRCClxuEnxMYSkAvXuvtMbel9v+R+bGLW9K2
         S/+r2m4NB1QxI9iR6aroBEfPdx73rIKfxF+5NqqyIQgCs69X8oGGOOr6FWaGjGUQUSt9
         Tc0uaiEi0faFmO6VoDKC7v6ks1VUy9nLHVgluajqH/s03rnRsfsMixWMFr3lHLUFEYJe
         4cwbZ2oEttLShE95tTwDM4xihp9K0jYaSbtDd5+kewvENpQ9rLYuQ9uAJozVi3sjq4OO
         AYaQ==
X-Gm-Message-State: AO0yUKWBqXnDmPbo7t+G3Xf9JON+A6mpUoZqkLhEXO8ZF2kGt7iRn4P3
        wo2Hdhmp9WALaln3GfiTHC8T2VIbHqc=
X-Google-Smtp-Source: AK7set/V5smxoJB3Uf+v02cnHqPtoI8uSrm7wsi5KeYdHlf3zS7j38lBDNPFF3dK/Og9SWFRvxn78SKancI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9512:b0:237:50b6:9a09 with SMTP id
 t18-20020a17090a951200b0023750b69a09mr7273568pjo.0.1678304798958; Wed, 08 Mar
 2023 11:46:38 -0800 (PST)
Date:   Wed, 8 Mar 2023 11:46:37 -0800
In-Reply-To: <741d411a-c5a2-71ae-fba9-52cdebb88cfd@gmail.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com>
 <20230307141400.1486314-2-aaronlewis@google.com> <1c7a20c4-742c-9c42-970e-19626323e367@gmail.com>
 <CAAAPnDFuEhhv+3orZ0EGMq4kAm3_p335kRAMOf=ZcLi_pcnPKQ@mail.gmail.com>
 <ZAdfX+S323JVWNZC@google.com> <741d411a-c5a2-71ae-fba9-52cdebb88cfd@gmail.com>
Message-ID: <ZAjmHbG9h+gut0bs@google.com>
Subject: Re: [PATCH v3 1/5] KVM: x86/pmu: Prevent the PMU from counting
 disallowed events
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, pbonzini@redhat.com,
        jmattson@google.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023, Like Xu wrote:
> On 8/3/2023 12:01 am, Sean Christopherson wrote:
> > On Tue, Mar 07, 2023, Aaron Lewis wrote:
> > > On Tue, Mar 7, 2023 at 7:19=E2=80=AFAM Like Xu <like.xu.linux@gmail.c=
om> wrote:
> > > > > ---
> > > > >    arch/x86/kvm/pmu.c | 13 ++++++++-----
> > > > >    1 file changed, 8 insertions(+), 5 deletions(-)
> > > > >=20
> > > > > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > > > > index 612e6c70ce2e..9914a9027c60 100644
> > > > > --- a/arch/x86/kvm/pmu.c
> > > > > +++ b/arch/x86/kvm/pmu.c
> > > > > @@ -400,6 +400,12 @@ static bool check_pmu_event_filter(struct kv=
m_pmc *pmc)
> > > > >        return is_fixed_event_allowed(filter, pmc->idx);
> > > > >    }
> > > > >=20
> > > > > +static bool event_is_allowed(struct kvm_pmc *pmc)
> > > >=20
> > > > Nit, an inline event_is_allowed() here might be better.
> > >=20
> > > I purposely didn't inline this because Sean generally discourages its
> > > use and has commented in several reviews to not use 'inline' and
> > > instead leave it up to the compiler to decide, unless using
> > > __always_inline.
> >=20
> > Ya.
>=20
> I think we all respect mainatiner's personal preferences for sure. Howeve=
r,
> I'm not sure how to define Sean's "generally discourage", nor does my
> binary bi-directional verifier-bot (losing control of these details at th=
e code
> level can be frustrating, especially for people who care about performanc=
e
> gains but can't use the fresh new tool chain for some supply chain policy
> reasons),

I'm not buying that argument.  Modern compilers are much smarter than human=
s when
it comes to performance optimizations and will do the right thing 99% of th=
e time.
There are exceptions, e.g. coercing the compiler into generating arithmetic=
 instead
of conditional branches, but those are few and far between.

If you care about performance to the point where a CALL+RET (which is not a=
t all
expensive on modern CPUs) and _maybe_ a few arithmetic ops are concerning, =
_and_
your toolchain is so awful that I can't do a good job of optimizing straigh=
tforward
code like this, then you have much bigger problems.

If someone can provide data to show that forcing a particularly function to=
 be
inlined meaningful changes runtime performance, then I'll happily take a pa=
tch.

> and we don't have someone like Sean or other kernel worlds to eliminate a=
ll
> inline in the kernel world.

Huh?  I'm not saying "inline is bad", I'm saying modern compilers are plent=
y smart
enough to inline (or not) when appropriate in the overwhelming majority of =
cases,
and that outside of select edge cases and truly performance critical paths,=
 the
days when humans can handcode better code than the compiler are long gone. =
 For
functions that should result in literally one or two instructions, I'm fine=
 with
tagging them inline even though I think it's unnecessary.  But this propose=
d
helper is not that case.

> > > I think the sentiment is either use the strong hint or don't use it a=
t all.
> > > This seems like an example of where the compiler can decide, and a st=
rong
> > > hint isn't needed.
> >=20
> > Not quite.  __always_inline is not a hint, it's a command.  The kernel =
*requires*
> > functions tagged with __always_inline to be (surprise!) always inlined,=
 even when
> > building with features that cause the compiler to generate non-inlined =
functions
> > for even the most trivial helpers, e.g. KASAN can cause a literal nop f=
unction to
> > be non-inlined.  __alway_inlined is used to ensure like no-instrumentat=
ion regions
> > and __init sections are preserved when invoking common helpers.
>=20
> So, do you think "__always_inline event_is_allowed()" in the highly recur=
ring
> path reprogram_counter() is a better move ? I'd say yes, and am not willi=
ng
> to risk paying for a function call overhead since any advancement in this
> direction is encouraged.

Absolutely not.  __always_inline is for situations where the code _must_ be=
 inlined,
or as above, where someone can prove with data that (a) modern compilers ar=
en't
smart enough to do the right thing and (b) that inlining provides meaningfu=
l
performance benefits.
