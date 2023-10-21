Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3929E7D1C50
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 11:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjJUJ6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Oct 2023 05:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjJUJ6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Oct 2023 05:58:30 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2E51A4;
        Sat, 21 Oct 2023 02:58:27 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id 4fb4d7f45d1cf-53f6ccea1eeso2397648a12.3;
        Sat, 21 Oct 2023 02:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697882306; x=1698487106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1p+SZNKsZJwWwe/OiDFcu5HQt0qGCn56Wthh9+M5hU0=;
        b=ERTH3yXklY/bkYThWzjBnlEMnzjwIL1OQdpv1r/uYyCrduPwJTnZdfor2cuEBKP3Yp
         Qy1pzkmZn9rZCg8dKCPg0LpVHW8np3Wud6nKMDdkDuj1pfxs+tTAu2X79s+hSepgzbn8
         zBbRwcb4+hs0fpvXx3RX2K1PE4vB7RPYG9zb/ROTBrZaJI7RPqkF1uL7iwMGqaWQMaQE
         QHGMNuBkEAEv+U8BXVvTnGQ/iQlreIMNsn9BqN1t/uBwqBdWPecS8V1cUH8BWd/+Z+Nn
         LvfJCuyEWnQsnak4mtGPPQi9Lq3gIqs0kvIJYjbWuGGkmhDW2ZHe49Hpr6UId5hp2Lyt
         Eh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697882306; x=1698487106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1p+SZNKsZJwWwe/OiDFcu5HQt0qGCn56Wthh9+M5hU0=;
        b=GTjYOaGL7v0D9wamHTW1/0zRAEfWe8F5Q++RVmrDEp2JzROY9dmeVyb6ZCqDSv463d
         7Di7nXV4aOuNmRpSBU22HNsYoCVPOvWDFZr5O1Sx19wWijI0QHYNJEpDLGSTH8PdkWEc
         0lXpupXlhuqhByht0YxvnT/RfdW0U+Tq2GvbEa+AY/vnaPBb8KAjCBJgh14OjF7RwSbu
         XOk388/N3x1Ut0sWp7+UjVpZas9AiBitC1qXpEcFORhRTllH4CaZzQ8jb6z/e869svx0
         VhdhsEiQ1E98mR1MHygZ/z/QZHW8etUMAE9tcyPX/9TYu5yCYg31An/sgINIcNJ7KbwH
         ZD7g==
X-Gm-Message-State: AOJu0YyDpDTZJkYbArSlsmQKRHplO9Y24i7ij50igVxvQlI8lvGQldql
        Ly6GDW+Llw2+zVQ0oikXc++FMYRHrzqLHGBP8WA=
X-Google-Smtp-Source: AGHT+IGW4eucEcJPD3vvV1GcCgDDiQS8IluIqklKbt1eRIGgRmoxjZVZzbyOo0mc9JKhDPRfyZU4bq+xBEI5j/9Coqg=
X-Received: by 2002:a05:6402:3512:b0:53e:775e:9761 with SMTP id
 b18-20020a056402351200b0053e775e9761mr3544911edd.36.1697882305562; Sat, 21
 Oct 2023 02:58:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230911114347.85882-1-cloudliang@tencent.com>
 <20230911114347.85882-9-cloudliang@tencent.com> <ZTLPy9SYzJmgMxw9@google.com>
In-Reply-To: <ZTLPy9SYzJmgMxw9@google.com>
From:   Jinrong Liang <ljr.kernel@gmail.com>
Date:   Sat, 21 Oct 2023 17:58:14 +0800
Message-ID: <CAFg_LQXZ4k+K7paWXVFSpXvaqBY-2s1DNh=t91-pRBc8efwt9w@mail.gmail.com>
Subject: Re: [PATCH v4 8/9] KVM: selftests: Test Intel supported fixed
 counters bit mask
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B410=E6=9C=8821=
=E6=97=A5=E5=91=A8=E5=85=AD 03:06=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Sep 11, 2023, Jinrong Liang wrote:
> > From: Jinrong Liang <cloudliang@tencent.com>
> >
> > Add a test to check that fixed counters enabled via guest
> > CPUID.0xA.ECX (instead of EDX[04:00]) work as normal as usual.
> >
> > Co-developed-by: Like Xu <likexu@tencent.com>
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> > ---
> >  .../selftests/kvm/x86_64/pmu_counters_test.c  | 54 +++++++++++++++++++
> >  1 file changed, 54 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/t=
ools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > index df76f0f2bfd0..12c00bf94683 100644
> > --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > @@ -301,6 +301,59 @@ static void test_intel_counters_num(void)
> >       test_oob_fixed_ctr(nr_fixed_counters + 1);
> >  }
> >
> > +static void fixed_counters_guest_code(void)
> > +{
> > +     uint64_t supported_bitmask =3D this_cpu_property(X86_PROPERTY_PMU=
_FIXED_COUNTERS_BITMASK);
> > +     uint32_t nr_fixed_counter =3D this_cpu_property(X86_PROPERTY_PMU_=
NR_FIXED_COUNTERS);
> > +     uint64_t msr_val;
> > +     unsigned int i;
> > +     bool expected;
> > +
> > +     for (i =3D 0; i < nr_fixed_counter; i++) {
> > +             expected =3D supported_bitmask & BIT_ULL(i) || i < nr_fix=
ed_counter;
> > +
> > +             wrmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> > +             wrmsr_safe(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
> > +             wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(PMC_IDX_FIX=
ED + i));
> > +             __asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES})=
);
> > +             wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> > +             rdmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, &msr_val);
>
> Y'all are making this way harder than it needs to be.  The previous patch=
 already
> created a testcase to verify fixed counters, just use that!  Then test ca=
se verify
> that trying to enable unsupported fixed counters results in #GP, as oppos=
ed to the
> above which doesn't do any actual checking, e.g. KVM could completely bot=
ch the
> {RD,WR}MSR emulation but pass the test by not programming up a counter in=
 perf.
>
> I.e. rather than have a separate test for the supported bitmask goofiness=
, have
> the fixed counters test iterate over the bitmask.  And then add a patch t=
o verify
> the counters can be enabled and actually count.
>
> And peeking ahead at the vPMU version test, it's the exact same story the=
re.
> Instead of hardcoding one-off tests, iterate on the version.  The end res=
ult is
> that the test provides _more_ coverage with _less_ code.  And without any=
 of the
> hardcoded magic that takes a crystal ball to understand.
>
> *sigh*
>
> And even more importantly, this test is complete garbage.  The SDM clearl=
y states
> that
>
>   With Architectural Performance Monitoring Version 5, register CPUID.0AH=
.ECX
>   indicates Fixed Counter enumeration. It is a bit mask which enumerates =
the
>   supported Fixed Counters in a processor. If bit 'i' is set, it implies =
that
>   Fixed Counter 'i' is supported.
>
> *sigh*
>
> The test passes because it only iterates over counters < nr_fixed_counter=
.  So
> as written, the test worse than useless.  It provides no meaningful value=
 and is
> actively misleading.
>
>         for (i =3D 0; i < nr_fixed_counter; i++) {
>
> Maybe I haven't been explicit enough: the point of writing tests is to fi=
nd and
> prevent bugs, not to get the tests passing.  That isn't to say we don't w=
ant a
> clean testgrid, but writing a "test" that doesn't actually test anything =
is a
> waste of everyone's time.
>
> I appreciate that the PMU is subtle and complex (understatement), but thi=
ngs like
> this, where observing that the result of "supported_bitmask & BIT_ULL(i)"=
 doesn't
> actually affect anything, doesn't require PMU knowledge.
>
>         for (i =3D 0; i < nr_fixed_counter; i++) {
>                 expected =3D supported_bitmask & BIT_ULL(i) || i < nr_fix=
ed_counter;
>
> A concrete suggestion for writing tests: introduce bugs in what you're te=
sting
> and verify that the test actually detects the bugs.  If you tried to do t=
hat for
> the above bitmask test you would have discovered you can't break KVM beca=
use KVM
> doesn't support this!  And if your test doesn't detect the bugs, that sho=
uld also
> be a big clue that something isn't quite right.

Thank you for your detailed feedback on my patch series. I truly
appreciate the time and effort you've put into identifying the issues
in my code and providing valuable suggestions for improvement.

Your guidance have been instrumental in helping me understand the
selftests. I will make sure to strive to create more meaningful and
effective contribution in the future.
