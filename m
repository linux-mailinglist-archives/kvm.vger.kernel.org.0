Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED22744149
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 19:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjF3RdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 13:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbjF3RdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 13:33:02 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE81E77
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 10:33:01 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51d89664272so2230857a12.1
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 10:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688146380; x=1690738380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TRxnSk9kxMzaUaw9NVLI4lJ1EfwlE8b7suSgdr4IEqI=;
        b=c6JEuiDQ+wrPvK+QjxunYykvRbfHhcBKV05AoUOFRmzHswSWjmcSXPXM1ZVHkHfDqs
         vWkbiaNqkpDXdWqxfBFccdeVdepgIW86nt7v8pemIupjrVYIp8vncjQn8BxgTl6edG36
         RLNcK4EJPaBtOGWBr8ruXswZTzyWd0Z+YQ9rSRlmvF6BCz5txfyPS3R2jfAtgaovAyl1
         UfB+4hVZxyU6S8fHHeV2tvxuJjimlAeWsN9tgVTn68uMqbA8JWwRnaoYlxmE8T0FCOrF
         1AuiJAQdewxbWyHfWEkehHr0I4u93PrY8mgl4xew0ZjyUsu+4BXkbf4laP4fcAxHyaN+
         B2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688146380; x=1690738380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TRxnSk9kxMzaUaw9NVLI4lJ1EfwlE8b7suSgdr4IEqI=;
        b=eG2kZDPwg7KSlJoOiGqVNHUacmoMxsn9OVpagyKIwvO8PKpt6mAi6ezJyBW6kZKWeq
         FtpPzytj6teA+NqeynMdiXBlgrna104VBE4gU4fk0T9VJwVZxtyrGWKrBjGRG1PlfaYV
         y9nbQT8yDSpWdAiEJhMBwFWI8gPjnP70ZOZ0h1WTatHzNMbRkCKIPZ6WskbLWOkrq3tx
         vbWjCY3AfjHrdp5cp5o7Liz705IMRHTc0NBR4mCrJst4imCSXeU8KuFCVcDMj/f9xY15
         tgKyxecizsrUkxC3tWBm2H/Rux5XVHZV/0mgChxZFCehH4Ex4D+zUb7OFnVG0j5g8KC3
         EcSQ==
X-Gm-Message-State: ABy/qLZLd8ZGDzL4o7jcJ1gXkRoo+p8+1+yXHLYvo2kNc4b8FAIloaNQ
        REvZDccvunSD+bkrNYHdcbyncHj0LS5FpxPyzOXsfQ==
X-Google-Smtp-Source: APBJJlH48PHLP8a6rvcVshOZaojaPPhJAvoFbw4qR/w+S3pNxQPH3Tf0cnQsOEnoHhrj5bfcnZmvQr/PYqCOMWc4YWo=
X-Received: by 2002:a17:906:f299:b0:991:f427:2fd8 with SMTP id
 gu25-20020a170906f29900b00991f4272fd8mr2265350ejb.74.1688146379640; Fri, 30
 Jun 2023 10:32:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com> <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com> <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
 <ZJ74gELkj4DgAk4S@google.com> <CAL715WL9T8Ucnj_1AygwMgDjOJrttNZHRP9o-KUNfpx1aYZnog@mail.gmail.com>
 <CALMp9eSQ9uRBVdLDkfCdPbprZ45LpdZY5-5O9i41oJYs-dK7+Q@mail.gmail.com>
In-Reply-To: <CALMp9eSQ9uRBVdLDkfCdPbprZ45LpdZY5-5O9i41oJYs-dK7+Q@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 30 Jun 2023 10:32:23 -0700
Message-ID: <CAL715WJDjox6AOU=gzN_E-VPL8aXMuD+SkN3k18T=imoS_dKaw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Jun 30, 2023 at 10:16=E2=80=AFAM Jim Mattson <jmattson@google.com> =
wrote:
>
> On Fri, Jun 30, 2023 at 10:08=E2=80=AFAM Mingwei Zhang <mizhang@google.co=
m> wrote:
> >
> > On Fri, Jun 30, 2023 at 8:45=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > > On Fri, Jun 30, 2023 at 07:28:29AM -0700, Sean Christopherson wrote=
:
> > > > > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > > > > On Thu, Jun 29, 2023 at 05:11:06PM -0700, Sean Christopherson w=
rote:
> > > > > > > @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct =
kvm_pmc *pmc)
> > > > > > >         return counter & pmc_bitmask(pmc);
> > > > > > >  }
> > > > > > >
> > > > > > > +static inline void pmc_write_counter(struct kvm_pmc *pmc, u6=
4 val)
> > > > > > > +{
> > > > > > > +       if (pmc->perf_event && !pmc->is_paused)
> > > > > > > +               perf_event_set_count(pmc->perf_event, val);
> > > > > > > +
> > > > > > > +       pmc->counter =3D val;
> > > > > >
> > > > > > Doesn't this still have the original problem of storing wider v=
alue than
> > > > > > allowed?
> > > > >
> > > > > Yes, this was just to fix the counter offset weirdness.  My plan =
is to apply your
> > > > > patch on top.  Sorry for not making that clear.
> > > >
> > > > Ah, got it, thanks!
> > > >
> > > > Also I'm now chasing a problem that we occasionally see
> > > >
> > > > [3939579.462832] Uhhuh. NMI received for unknown reason 30 on CPU 4=
3.
> > > > [3939579.462836] Do you have a strange power saving mode enabled?
> > > > [3939579.462836] Dazed and confused, but trying to continue
> > > >
> > > > in the guests when perf is used.  These messages disappear when
> > > > 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions") =
is
> > > > reverted.  I haven't yet figured out where exactly the culprit is.
> > >
> > > Can you reverting de0f619564f4 ("KVM: x86/pmu: Defer counter emulated=
 overflow
> > > via pmc->prev_counter")?  I suspect the problem is the prev_counter m=
ess.
> >
> > For sure it is prev_counter issue, I have done some instrumentation as =
follows:
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 48a0528080ab..946663a42326 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -322,8 +322,11 @@ static void reprogram_counter(struct kvm_pmc *pmc)
> >         if (!pmc_event_is_allowed(pmc))
> >                 goto reprogram_complete;
> >
> > -       if (pmc->counter < pmc->prev_counter)
> > +       if (pmc->counter < pmc->prev_counter) {
> > +               pr_info("pmc->counter: %llx\tpmc->prev_counter: %llx\n"=
,
> > +                       pmc->counter, pmc->prev_counter);
> >                 __kvm_perf_overflow(pmc, false);
> > +       }
> >
> >         if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
> >                 printk_once("kvm pmu: pin control bit is ignored\n");
> >
> > I find some interesting changes on prev_counter:
> >
> > [  +7.295348] pmc->counter: 12 pmc->prev_counter: fffffffffb3d
> > [  +0.622991] pmc->counter: 3 pmc->prev_counter: fffffffffb1a
> > [  +6.943282] pmc->counter: 1 pmc->prev_counter: fffffffff746
> > [  +4.483523] pmc->counter: 0 pmc->prev_counter: ffffffffffff
> > [ +12.817772] pmc->counter: 0 pmc->prev_counter: ffffffffffff
> > [ +21.721233] pmc->counter: 0 pmc->prev_counter: ffffffffffff
> >
> > The first 3 logs will generate this:
> >
> > [ +11.811925] Uhhuh. NMI received for unknown reason 20 on CPU 2.
> > [  +0.000003] Dazed and confused, but trying to continue
> >
> > While the last 3 logs won't. This is quite reasonable as looking into
> > de0f619564f4 ("KVM: x86/pmu: Defer counter emulated overflow via
> > pmc->prev_counter"), counter and prev_counter should only have 1 diff
> > in value.
>
> prev_counter isn't actually sync'ed at this point, is it? This comes
> back to that "setting a running counter" nonsense. We want to add 1 to
> the current counter, but we don't actually know what the current
> counter is.
>
> My interpretation of the above is that, in the first three cases, PMU
> hardware has already detected an overflow. In the last three cases,
> software counting has detected an overflow.
>
> If the last three occur while executing the guest's PMI handler (i.e.
> NMIs are blocked), then this could corroborate my conjecture about
> IA32_DEBUGCTL.Freeze_PerfMon_On_PMI.
>

I see. I wonder if we can just do this:

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 48a0528080ab..8d28158e58f2 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -322,7 +322,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
        if (!pmc_event_is_allowed(pmc))
                goto reprogram_complete;

-       if (pmc->counter < pmc->prev_counter)
+       if (pmc->counter =3D=3D 0)
                __kvm_perf_overflow(pmc, false);

        if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)

Since this is software emulation, we (KVM) should only handle overflow
by plusing one?
