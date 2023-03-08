Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F25F6AFD78
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 04:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCHDkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 22:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCHDko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 22:40:44 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EF793E3F
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 19:40:41 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id i3so16472946plg.6
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 19:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678246840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QLUpNRb1Q5SbO5b6ljTZoN5cFP88001T4PHHJDtnPIY=;
        b=hvgQDq9Hx7UZ+T+wnEN/YAB03nl+H2YawT6rsZIgLQWs/jTvHj7wOlBe+kV/zOxTLL
         jftAH82U93x6DI+yV8EgM3dVqSXPKAGh1/9x69jebUA0lWdAnViH05CqLjCm6e8jI9ul
         1B08YMiyJD8CvQUNYYX8zwFzs1KEv+llJ4nK/MUMXD/uTmb7+aFpaklcGWHFjtu3ziNM
         mi2c3+ctKR2GWRPPW5dfzdAUxBQRRrndJ323cI0NoodTewkP3wPyq2jbrQPkQlMUsxha
         1cSROQvN3Od1hHzlhzQCvAJbsfgCvPuxMal2DfwqxAEhfXGkMNuqXGv/+hsxkFQWAUOS
         GuhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678246840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLUpNRb1Q5SbO5b6ljTZoN5cFP88001T4PHHJDtnPIY=;
        b=zEZRgu11MWhRdellsKcFlsVejjAzpl6VYt7Szbki/VEqiNgxGltlRjieII7ZyXccHX
         /mOriLyi4CvWxfa6CpbaCmY6imjlKtkHCfLYqmzmrOIZHUstTF0CCChTfENAxFyTokrg
         LISSa7a2dg9R/cFq64d3PjjpTGoeH9yrcwwHuA7rFF606ALfUaq1f6PzvdBmUS8oNvqH
         NA5ak6VgkFACtHeSHUh0/n4lr3is/VMCbnGCQJDhDMhNe3zR9JWJHIINbdWLkQ2QmSkv
         gEbg38A7QQgARExCGciExEXforJybls11ECSVx+Sh5s2Hthbb+OI8YCgqgTq10UXOJF3
         O2CQ==
X-Gm-Message-State: AO0yUKVNbcdVnGKsiDt2V93pz4ShuAOtquITI2gCFfNZoH3j8w1Hn58k
        sKjZLJn0m9uQvPIwnJIrm7oMm1UH4xf//gTL6BQJng==
X-Google-Smtp-Source: AK7set951PHcH/hh6Gt6p7PVv5UViZaBErCzXeuETNU4JXbZ9TJrRbhpRClK0T35JNChyp0zlzlZSL+kUVqQoNAFMXA=
X-Received: by 2002:a17:90a:f10b:b0:23a:6ed6:7817 with SMTP id
 cc11-20020a17090af10b00b0023a6ed67817mr6298116pjb.5.1678246840511; Tue, 07
 Mar 2023 19:40:40 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-15-rananta@google.com>
In-Reply-To: <20230215010717.3612794-15-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 7 Mar 2023 19:40:24 -0800
Message-ID: <CAAeT=Fyu6eoYX=1U1aXr5qrXSPmQdswcrE+Dz12SLK7R-1XDAQ@mail.gmail.com>
Subject: Re: [REPOST PATCH 14/16] selftests: KVM: aarch64: Add PMU test to
 chain all the counters
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Extend the vCPU migration test to occupy all the vPMU counters,
> by configuring chained events on alternate counter-ids and chaining
> them with its corresponding predecessor counter, and verify against
> the extended behavior.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vpmu_test.c | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/test=
ing/selftests/kvm/aarch64/vpmu_test.c
> index de725f4339ad5..fd00acb9391c8 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> @@ -710,6 +710,63 @@ static void test_chained_count(int pmc_idx)
>         pmu_irq_exit(chained_pmc_idx);
>  }
>
> +static void test_chain_all_counters(void)
> +{
> +       int i;
> +       uint64_t cnt, pmcr_n =3D get_pmcr_n();
> +       struct pmc_accessor *acc =3D &pmc_accessors[0];

How do you decide whether to test with all accessors ?
Perhaps, it might be simpler and more consistent if we implement each
test case with one specified accessor as an argument, and run those
test with each accessors?


> +
> +       /*
> +        * Test the occupancy of all the event counters, by chaining the
> +        * alternate counters. The test assumes that the host hasn't
> +        * occupied any counters. Hence, if the test fails, it could be
> +        * because all the counters weren't available to the guest or
> +        * there's actually a bug in KVM.
> +        */
> +
> +       /*
> +        * Configure even numbered counters to count cpu-cycles, and chai=
n
> +        * each of them with its odd numbered counter.
> +        */

You might want to use the cycle counter as well ?

Thank you,
Reiji

> +       for (i =3D 0; i < pmcr_n; i++) {
> +               if (i % 2) {
> +                       acc->write_typer(i, ARMV8_PMUV3_PERFCTR_CHAIN);
> +                       acc->write_cntr(i, 1);
> +               } else {
> +                       pmu_irq_init(i);
> +                       acc->write_cntr(i, PRE_OVERFLOW_32);
> +                       acc->write_typer(i, ARMV8_PMUV3_PERFCTR_CPU_CYCLE=
S);
> +               }
> +               enable_counter(i);
> +       }
> +
> +       /* Introduce some cycles */
> +       execute_precise_instrs(500, ARMV8_PMU_PMCR_E);
> +
> +       /*
> +        * An overflow interrupt should've arrived for all the even numbe=
red
> +        * counters but none for the odd numbered ones. The odd numbered =
ones
> +        * should've incremented exactly by 1.
> +        */
> +       for (i =3D 0; i < pmcr_n; i++) {
> +               if (i % 2) {
> +                       GUEST_ASSERT_1(!pmu_irq_received(i), i);
> +
> +                       cnt =3D acc->read_cntr(i);
> +                       GUEST_ASSERT_2(cnt =3D=3D 2, i, cnt);
> +               } else {
> +                       GUEST_ASSERT_1(pmu_irq_received(i), i);
> +               }
> +       }
> +
> +       /* Cleanup the states */
> +       for (i =3D 0; i < pmcr_n; i++) {
> +               if (i % 2 =3D=3D 0)
> +                       pmu_irq_exit(i);
> +               disable_counter(i);
> +       }
> +}
> +
>  static void test_event_count(uint64_t event, int pmc_idx, bool expect_co=
unt)
>  {
>         switch (event) {
> @@ -739,6 +796,9 @@ static void test_basic_pmu_functionality(void)
>
>         /* Test chained events */
>         test_chained_count(0);
> +
> +       /* Test running chained events on all the implemented counters */
> +       test_chain_all_counters();
>  }
>
>  /*
> --
> 2.39.1.581.gbfd45094c4-goog
>
