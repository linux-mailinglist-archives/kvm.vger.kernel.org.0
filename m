Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF73C6A9040
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 05:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjCCEbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 23:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjCCEbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 23:31:12 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8730330B11
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 20:31:08 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so1089452pja.5
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 20:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677817868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nluhokzZIdfUCFwkY0qQDl9mqZxSwoOfjFeFL6kIP6U=;
        b=EFCLbHIdHgae3+6oY4bZyJSYTHH6OzxMtjVVrVUwcc/mQk+Mg6nb0sd9VTJ/U33eHo
         dIfG4HS8FAcNtszk/xeNyGOLVEBcwzA4UGX7AAz2yM+GcLMHUQArrEp0KNlZwDnEjDzJ
         8L38PifeLo7PA2wtsXUw+kXRx3vatkV1L9aj4C6KE1nhZkRV+ns7UkeqliVYidzIiGKh
         Vr0U/r5BS1IwQFCbPxNgkw78xPFjEjTgcH14PpHXCf54YPHUMjnua1tnDTsHTQ4g/nLS
         WSiqFcLqyTmxlhz2wRnm3QKwcSz2d8BLsBWfVtv0KPLiTipCQhJf4mwRoR5r3BokBbOV
         TIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677817868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nluhokzZIdfUCFwkY0qQDl9mqZxSwoOfjFeFL6kIP6U=;
        b=08uRIynrKcPJeSnmxMyen5SBL4MPsyGtBeQFgLx0dPmiUUb9ZxV5jKieYpIpNcanPZ
         cG5jaeq8l4XgOpvVrGs6NLjS6AjolCF6RLTa2CODWWoAIpTvOBO22Kw0C1b9NoL+1Fqi
         qeHI+mp6dXEcR2zdBgvRko9PRNJyfByxH+/poqX/FqkOPJb6w1wLrpaI16hAxXxlxLjf
         Biz5nBIKXpGuTDlv4enGREXffvwFXrdS2aeN/uVlwKK0KQ9njrT99PwyKV/cFwQwGQi5
         idUHSGDr6cj4vggQTpAuiCcxdWNhpNTaToK8Pnm3b6l1TFvDVnM4hHdhazU9ZiC7uPKg
         aqmg==
X-Gm-Message-State: AO0yUKXzwq2W1OBjUHwdMWzJZzMEYovx+6VF85Qa7I4S85UowLXDZ9w0
        VjONOOMUQJNkvqOAaVnZdtFkjUnTP7KPJFqaN5L0ag==
X-Google-Smtp-Source: AK7set+IFUAmsXFjvDCNiLbyLJEFEXKvKFpfoF+rTUh5RnAKunx2km5L53GaU7dqhD+GJQbh4YAIMYoj8dHFzVxz18c=
X-Received: by 2002:a17:90a:4109:b0:22c:89b:5a8d with SMTP id
 u9-20020a17090a410900b0022c089b5a8dmr91367pjf.6.1677817867772; Thu, 02 Mar
 2023 20:31:07 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-9-rananta@google.com>
In-Reply-To: <20230215010717.3612794-9-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 2 Mar 2023 20:30:51 -0800
Message-ID: <CAAeT=Fzww3z1Y47gZjmeU0p+fK=gxiqNx5DHGcu4109B7DWi4A@mail.gmail.com>
Subject: Re: [REPOST PATCH 08/16] selftests: KVM: aarch64: Consider PMU event
 filters for VM creation
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
> Accept a list of KVM PMU event filters as an argument while creating
> a VM via create_vpmu_vm(). Upcoming patches would leverage this to
> test the event filters' functionality.
>
> No functional change intended.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vpmu_test.c | 64 +++++++++++++++++--
>  1 file changed, 60 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/test=
ing/selftests/kvm/aarch64/vpmu_test.c
> index 15aebc7d7dc94..2b3a4fa3afa9c 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> @@ -15,10 +15,14 @@
>  #include <vgic.h>
>  #include <asm/perf_event.h>
>  #include <linux/bitfield.h>
> +#include <linux/bitmap.h>
>
>  /* The max number of the PMU event counters (excluding the cycle counter=
) */
>  #define ARMV8_PMU_MAX_GENERAL_COUNTERS (ARMV8_PMU_MAX_COUNTERS - 1)
>
> +/* The max number of event numbers that's supported */
> +#define ARMV8_PMU_MAX_EVENTS           64

The name and the comment would be a bit misleading.
(This sounds like a max number of events that are supported by ARMv8)

Perhaps 'MAX_EVENT_FILTER_BITS' would be more clear ?


> +
>  /*
>   * The macros and functions below for reading/writing PMEV{CNTR,TYPER}<n=
>_EL0
>   * were basically copied from arch/arm64/kernel/perf_event.c.
> @@ -224,6 +228,8 @@ struct pmc_accessor pmc_accessors[] =3D {
>         { read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pmevt=
ypern },
>  };
>
> +#define MAX_EVENT_FILTERS_PER_VM 10

(Looking at just this patch,) it appears 'PER_VM' in the name
might be rather misleading ?

> +
>  #define INVALID_EC     (-1ul)
>  uint64_t expected_ec =3D INVALID_EC;
>  uint64_t op_end_addr;
> @@ -232,6 +238,7 @@ struct vpmu_vm {
>         struct kvm_vm *vm;
>         struct kvm_vcpu *vcpu;
>         int gic_fd;
> +       unsigned long *pmu_filter;
>  };
>
>  enum test_stage {
> @@ -541,8 +548,51 @@ static void guest_code(void)
>  #define GICD_BASE_GPA  0x8000000ULL
>  #define GICR_BASE_GPA  0x80A0000ULL
>
> +static unsigned long *
> +set_event_filters(struct kvm_vcpu *vcpu, struct kvm_pmu_event_filter *pm=
u_event_filters)

Can you add a comment that explains the function ?
(especially for @pmu_event_filters and the return value ?)

> +{
> +       int j;
> +       unsigned long *pmu_filter;
> +       struct kvm_device_attr filter_attr =3D {
> +               .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> +               .attr =3D KVM_ARM_VCPU_PMU_V3_FILTER,
> +       };
> +
> +       /*
> +        * Setting up of the bitmap is similar to what KVM does.
> +        * If the first filter denys an event, default all the others to =
allow, and vice-versa.
> +        */
> +       pmu_filter =3D bitmap_zalloc(ARMV8_PMU_MAX_EVENTS);
> +       TEST_ASSERT(pmu_filter, "Failed to allocate the pmu_filter");
> +
> +       if (pmu_event_filters[0].action =3D=3D KVM_PMU_EVENT_DENY)
> +               bitmap_fill(pmu_filter, ARMV8_PMU_MAX_EVENTS);
> +
> +       for (j =3D 0; j < MAX_EVENT_FILTERS_PER_VM; j++) {
> +               struct kvm_pmu_event_filter *pmu_event_filter =3D &pmu_ev=
ent_filters[j];
> +
> +               if (!pmu_event_filter->nevents)

What does this mean ? (the end of the valid entry in the array ?)


> +                       break;
> +
> +               pr_debug("Applying event filter:: event: 0x%x; action: %s=
\n",
> +                               pmu_event_filter->base_event,
> +                               pmu_event_filter->action =3D=3D KVM_PMU_E=
VENT_ALLOW ? "ALLOW" : "DENY");
> +
> +               filter_attr.addr =3D (uint64_t) pmu_event_filter;
> +               vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &filter_attr);
> +
> +               if (pmu_event_filter->action =3D=3D KVM_PMU_EVENT_ALLOW)
> +                       __set_bit(pmu_event_filter->base_event, pmu_filte=
r);
> +               else
> +                       __clear_bit(pmu_event_filter->base_event, pmu_fil=
ter);
> +       }
> +
> +       return pmu_filter;
> +}
> +
>  /* Create a VM that has one vCPU with PMUv3 configured. */
> -static struct vpmu_vm *create_vpmu_vm(void *guest_code)
> +static struct vpmu_vm *
> +create_vpmu_vm(void *guest_code, struct kvm_pmu_event_filter *pmu_event_=
filters)
>  {
>         struct kvm_vm *vm;
>         struct kvm_vcpu *vcpu;
> @@ -586,6 +636,9 @@ static struct vpmu_vm *create_vpmu_vm(void *guest_cod=
e)
>                     "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pm=
uver);
>
>         /* Initialize vPMU */
> +       if (pmu_event_filters)
> +               vpmu_vm->pmu_filter =3D set_event_filters(vcpu, pmu_event=
_filters);
> +
>         vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
>         vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
>
> @@ -594,6 +647,8 @@ static struct vpmu_vm *create_vpmu_vm(void *guest_cod=
e)
>
>  static void destroy_vpmu_vm(struct vpmu_vm *vpmu_vm)
>  {
> +       if (vpmu_vm->pmu_filter)
> +               bitmap_free(vpmu_vm->pmu_filter);
>         close(vpmu_vm->gic_fd);
>         kvm_vm_free(vpmu_vm->vm);
>         free(vpmu_vm);
> @@ -631,7 +686,7 @@ static void run_counter_access_test(uint64_t pmcr_n)
>         guest_data.expected_pmcr_n =3D pmcr_n;
>
>         pr_debug("Test with pmcr_n %lu\n", pmcr_n);
> -       vpmu_vm =3D create_vpmu_vm(guest_code);
> +       vpmu_vm =3D create_vpmu_vm(guest_code, NULL);
>         vcpu =3D vpmu_vm->vcpu;
>
>         /* Save the initial sp to restore them later to run the guest aga=
in */
> @@ -676,7 +731,7 @@ static void run_counter_access_error_test(uint64_t pm=
cr_n)
>         guest_data.expected_pmcr_n =3D pmcr_n;
>
>         pr_debug("Error test with pmcr_n %lu (larger than the host)\n", p=
mcr_n);
> -       vpmu_vm =3D create_vpmu_vm(guest_code);
> +       vpmu_vm =3D create_vpmu_vm(guest_code, NULL);
>         vcpu =3D vpmu_vm->vcpu;
>
>         /* Update the PMCR_EL0.N with @pmcr_n */
> @@ -719,9 +774,10 @@ static uint64_t get_pmcr_n_limit(void)
>         struct vpmu_vm *vpmu_vm;
>         uint64_t pmcr;
>
> -       vpmu_vm =3D create_vpmu_vm(guest_code);
> +       vpmu_vm =3D create_vpmu_vm(guest_code, NULL);
>         vcpu_get_reg(vpmu_vm->vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmc=
r);
>         destroy_vpmu_vm(vpmu_vm);
> +
>         return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
>  }

Thank you,
Reiji


>
> --
> 2.39.1.581.gbfd45094c4-goog
>
