Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A4F6AD3C3
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 02:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjCGBTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 20:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCGBTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 20:19:50 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73B32A157
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 17:19:44 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id cp12so7104760pfb.5
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 17:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678151984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XlvRoDOZGkFFgyhD/mAoM2l807X5W3icksKBlwcwVSw=;
        b=QInKjmq1d/lftVQQm3th9Xnc9fmHpsAazEnocQ1JESHI8/EHInm050AJuFFRaHY10m
         ohkGhMwSBZENGVjd97tBBfwhB8GwQoCyj7YgC4WAcDqaujdeRIlnwLU98cHu1pkCkjoA
         Yn1jRMWpPHTd0U4EIJLiTQ4iKqrIOD1tMAQZKNFI1rnkucCttBvcGXGWSRh4QqKBQAKF
         df51ZCR6fxjvrJ+f2l254vk7RSNii9/N+X9HlgcpOkIJymtRVu0ErufD9BUtoiBBEqGU
         oInYp9F5TxJAV0DGVmNo5vy55b+Xtismbdjmym/uV0oCnSQnQcWM1WLeainoOjxfh7Re
         0WnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678151984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XlvRoDOZGkFFgyhD/mAoM2l807X5W3icksKBlwcwVSw=;
        b=Cr/g3xPXSx4jObutUQ7h7IWFGE3nIv/GNL04wNfpErRMx0yZba0jjybvVetIsZgEg7
         XL58Z1Faj4O7YMLnH1Ab/1xOqGOyDMn9GNe+bOsCByqxlDsE2MXRtPz3QQkoWDC/ZKZ5
         bkJS7eMRdJav4prEvw7OZRVvKnN0jOAnXJOytdK7pztZ5zHzIiUtvFMIFjQ6ydnsudN5
         T3w+/85NHbu0Ba9VUqM6LohRUm8too4WG5lXsuOeqsVjfyGrrGtGu7pgVDlGizMVW8Es
         60x2NuhibaQr6sZqi5tqw0lqK3UKFYNhl0jmDLYmCK7bEea2OPIYeT8ErKE59QbGheWR
         Mqig==
X-Gm-Message-State: AO0yUKUUEsQ9ZNBc+Y6E/wv5X+G66s7Uf9kN/pD0mNhUW3UFOuI7zqlE
        GW28D5WAJ5AKdq8/eC/bqI3T4E4FlcEHq5JDkudUFg==
X-Google-Smtp-Source: AK7set/8/oT7jPhV0zxjPPXpQxyJk5AbN05kjN+U/CvY4iejQ8uOmh0pRiMH5vHPQJuCpzoyHo13sQlQyXOv4EyoHrU=
X-Received: by 2002:a63:7356:0:b0:4fc:a80e:e6ec with SMTP id
 d22-20020a637356000000b004fca80ee6ecmr4270561pgn.5.1678151983944; Mon, 06 Mar
 2023 17:19:43 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-11-rananta@google.com>
In-Reply-To: <20230215010717.3612794-11-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 6 Mar 2023 17:19:27 -0800
Message-ID: <CAAeT=FyCQxhhFqhfWbFQB9uAcUxmktRa3SC_Yfne2f_MEeXOJw@mail.gmail.com>
Subject: Re: [REPOST PATCH 10/16] selftests: KVM: aarch64: Add KVM EVTYPE
 filter PMU test
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
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
> KVM doest't allow the guests to modify the filter types
> such counting events in nonsecure/secure-EL2, EL3, and
> so on. Validate the same by force-configuring the bits
> in PMXEVTYPER_EL0, PMEVTYPERn_EL0, and PMCCFILTR_EL0
> registers.
>
> The test extends further by trying to create an event
> for counting only in EL2 and validates if the counter
> is not progressing.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vpmu_test.c | 85 +++++++++++++++++++
>  1 file changed, 85 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/test=
ing/selftests/kvm/aarch64/vpmu_test.c
> index 3dfb770b538e9..5c166df245589 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> @@ -15,6 +15,10 @@
>   * of allowing or denying the events. The guest validates it by
>   * checking if it's able to count only the events that are allowed.
>   *
> + * 3. KVM doesn't allow the guest to count the events attributed with
> + * higher exception levels (EL2, EL3). Verify this functionality by
> + * configuring and trying to count the events for EL2 in the guest.
> + *
>   * Copyright (c) 2022 Google LLC.
>   *
>   */
> @@ -23,6 +27,7 @@
>  #include <test_util.h>
>  #include <vgic.h>
>  #include <asm/perf_event.h>
> +#include <linux/arm-smccc.h>
>  #include <linux/bitfield.h>
>  #include <linux/bitmap.h>
>
> @@ -259,6 +264,7 @@ struct vpmu_vm {
>  enum test_stage {
>         TEST_STAGE_COUNTER_ACCESS =3D 1,
>         TEST_STAGE_KVM_EVENT_FILTER,
> +       TEST_STAGE_KVM_EVTYPE_FILTER,
>  };
>
>  struct guest_data {
> @@ -678,6 +684,70 @@ static void guest_event_filter_test(unsigned long *p=
mu_filter)
>         }
>  }
>
> +static void guest_evtype_filter_test(void)
> +{
> +       int i;
> +       struct pmc_accessor *acc;
> +       uint64_t typer, cnt;
> +       struct arm_smccc_res res;
> +
> +       pmu_enable();
> +
> +       /*
> +        * KVM blocks the guests from creating events for counting in Sec=
ure/Non-Secure Hyp (EL2),
> +        * Monitor (EL3), and Multithreading configuration. It applies th=
e mask
> +        * ARMV8_PMU_EVTYPE_MASK against guest accesses to PMXEVTYPER_EL0=
, PMEVTYPERn_EL0,
> +        * and PMCCFILTR_EL0 registers to prevent this. Check if KVM hono=
rs this using all possible
> +        * ways to configure the EVTYPER.
> +        */

I would prefer to break long lines into multiple lines for these comments
(or other comments in these patches), as "Linux kernel coding style"
suggests.
---
[https://www.kernel.org/doc/html/latest/process/coding-style.html#breaking-=
long-lines-and-strings]

The preferred limit on the length of a single line is 80 columns.

Statements longer than 80 columns should be broken into sensible
chunks, unless exceeding 80 columns significantly increases
readability and does not hide information.
---

> +       for (i =3D 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> +               acc =3D &pmc_accessors[i];
> +
> +               /* Set all filter bits (31-24), readback, and check again=
st the mask */
> +               acc->write_typer(0, 0xff000000);
> +               typer =3D acc->read_typer(0);
> +
> +               GUEST_ASSERT_2((typer | ARMV8_PMU_EVTYPE_EVENT) =3D=3D AR=
MV8_PMU_EVTYPE_MASK,
> +                               typer | ARMV8_PMU_EVTYPE_EVENT, ARMV8_PMU=
_EVTYPE_MASK);

It appears that bits[29:26] don't have to be zero depending on
feature availability to the guest (Those bits needs to be zero
only when relevant features are not available on the guest).
So, the expected value must be changed depending on the feature
availability if the test checks those bits.
I have the same comment for the cycle counter.

> +
> +               /*
> +                * Regardless of ARMV8_PMU_EVTYPE_MASK, KVM sets perf att=
r.exclude_hv
> +                * to not count NS-EL2 events. Verify this functionality =
by configuring
> +                * a NS-EL2 event, for which the couunt shouldn't increme=
nt.
> +                */
> +               typer =3D ARMV8_PMUV3_PERFCTR_INST_RETIRED;
> +               typer |=3D ARMV8_PMU_INCLUDE_EL2 | ARMV8_PMU_EXCLUDE_EL1 =
| ARMV8_PMU_EXCLUDE_EL0;
> +               acc->write_typer(0, typer);
> +               acc->write_cntr(0, 0);
> +               enable_counter(0);
> +
> +               /* Issue a hypercall to enter EL2 and return */
> +               memset(&res, 0, sizeof(res));
> +               smccc_hvc(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0, 0, 0, 0, 0,=
 &res);
> +
> +               cnt =3D acc->read_cntr(0);
> +               GUEST_ASSERT_3(cnt =3D=3D 0, cnt, typer, i);
> +       }
> +
> +       /* Check the same sequence for the Cycle counter */
> +       write_pmccfiltr(0xff000000);
> +       typer =3D read_pmccfiltr();
> +       GUEST_ASSERT_2((typer | ARMV8_PMU_EVTYPE_EVENT) =3D=3D ARMV8_PMU_=
EVTYPE_MASK,
> +                               typer | ARMV8_PMU_EVTYPE_EVENT, ARMV8_PMU=
_EVTYPE_MASK);
> +
> +       typer =3D ARMV8_PMU_INCLUDE_EL2 | ARMV8_PMU_EXCLUDE_EL1 | ARMV8_P=
MU_EXCLUDE_EL0;
> +       write_pmccfiltr(typer);
> +       reset_cycle_counter();
> +       enable_cycle_counter();
> +
> +       /* Issue a hypercall to enter EL2 and return */
> +       memset(&res, 0, sizeof(res));
> +       smccc_hvc(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0, 0, 0, 0, 0, &res);
> +
> +       cnt =3D read_cycle_counter();

Perhaps it's worth considering having the helpers for PMC registers
(e.g. write_cntr()) accepting the cycle counter as the index=3D=3D31
to simplify the test code implementation ?

Thank you,
Reiji

> +       GUEST_ASSERT_2(cnt =3D=3D 0, cnt, typer);
> +}
> +
>  static void guest_code(void)
>  {
>         switch (guest_data.test_stage) {
> @@ -687,6 +757,9 @@ static void guest_code(void)
>         case TEST_STAGE_KVM_EVENT_FILTER:
>                 guest_event_filter_test(guest_data.pmu_filter);
>                 break;
> +       case TEST_STAGE_KVM_EVTYPE_FILTER:
> +               guest_evtype_filter_test();
> +               break;
>         default:
>                 GUEST_ASSERT_1(0, guest_data.test_stage);
>         }
> @@ -1014,10 +1087,22 @@ static void run_kvm_event_filter_test(void)
>         run_kvm_event_filter_error_tests();
>  }
>
> +static void run_kvm_evtype_filter_test(void)
> +{
> +       struct vpmu_vm *vpmu_vm;
> +
> +       guest_data.test_stage =3D TEST_STAGE_KVM_EVTYPE_FILTER;
> +
> +       vpmu_vm =3D create_vpmu_vm(guest_code, NULL);
> +       run_vcpu(vpmu_vm->vcpu);
> +       destroy_vpmu_vm(vpmu_vm);
> +}
> +
>  static void run_tests(uint64_t pmcr_n)
>  {
>         run_counter_access_tests(pmcr_n);
>         run_kvm_event_filter_test();
> +       run_kvm_evtype_filter_test();
>  }
>
>  /*
> --
> 2.39.1.581.gbfd45094c4-goog
>
