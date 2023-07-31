Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00B1769E32
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 19:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjGaRFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 13:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbjGaRFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 13:05:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861551BC7
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 10:04:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d10792c7582so3571372276.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 10:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690823044; x=1691427844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KfSgWNMsFhJfp3i+4pg02RKqbKjloChlJGxRUeeMH+8=;
        b=XmxsSZ8YI1gTXEnTcgvYTdFsp7D/Gtnnl+yTAX1w8hl10rqnm0I2V0S1CRpdRB0nIq
         DbUwMq/ZmN1VWeIcZgVvFGltYhB6Xf0Dr9C5TLMvkQU4xTHNB1OHqklHixYf/XqiRiL8
         D+efNUrTdedEpvVEg6ZlmoO1BhLwXwzhYaFQ2Kji8qkCvEBH/m/mUxuHBcrR/kXMtxUW
         8GiV3bb9VhJjaJ2zKE596RYBDeSSbSKtkVq9Z9tTnW+Jnl7/Bk+2hncZuuZyzXycRMoG
         E6WZIFuMQhTTsoJXgRaSgq9ARNAcGMJDvJ0POZ4SMvMbH8RN5fkcH/U4Lm0JuR47ecd/
         2WnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690823044; x=1691427844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KfSgWNMsFhJfp3i+4pg02RKqbKjloChlJGxRUeeMH+8=;
        b=eHw6OYubVjDdq+ALlB5pN/76d7kbXWst4P//Wo6sLrqWM9J9ykWoYw/LT1Bki/cFoi
         vSV5TBiQqbfQZG27DzsHMZ4zMds9vML51D2PmGlM6hgcb3BgNzdTyHe7L2kRGThEiPnK
         J21NSjTEttf2kkG8jubeEM1PAcXklgso0ZJW9qoZtq6tPh9sHo/w0Sel0myvHGieLnGR
         A8FwKEiRAtuH8+3RJwI+5u6pBS1omoSJ7D+LRXhxxHEOcSmGC6TZDKqpK2+3y+ZcansM
         q/4JaVEQr3wl45Gi5JN8gvk3TcLpQjHxE2mzvk5C1RiZGWq3nUn4liGkCF/ZjSVdqACu
         pumg==
X-Gm-Message-State: ABy/qLadAd1/4wmk6JH8Bk2xmECfGUNxLmr9mc4GK1msDYMkd3mFU7wi
        nrnYKvxrDGX1H9w4VY6SWh/mkKMoVR0=
X-Google-Smtp-Source: APBJJlES9j9tNYULGAVq4lgAnEqvnPcEJ6pz6+LhC1e/NDHHnYuoI1LUAaGS4uysn5IBZCe1/Lm/mrJsitU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:11ca:b0:d09:b19:fe2c with SMTP id
 n10-20020a05690211ca00b00d090b19fe2cmr63513ybu.12.1690823044560; Mon, 31 Jul
 2023 10:04:04 -0700 (PDT)
Date:   Mon, 31 Jul 2023 10:04:02 -0700
In-Reply-To: <20230731-91b64a6b787ba7e23b285785@orel>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com> <20230729003643.1053367-10-seanjc@google.com>
 <20230731-91b64a6b787ba7e23b285785@orel>
Message-ID: <ZMfpgu8bHH0jA8Si@google.com>
Subject: Re: [PATCH v4 09/34] KVM: selftests: Add a selftest for guest prints
 and formatted asserts
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        "Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023, Andrew Jones wrote:
> On Fri, Jul 28, 2023 at 05:36:18PM -0700, Sean Christopherson wrote:
> > From: Aaron Lewis <aaronlewis@google.com>
> > 
> > Add a test to exercise the various features in KVM selftest's local
> > snprintf() and compare them to LIBC's snprintf() to ensure they behave
> > the same.
> > 
> > This is not an exhaustive test.  KVM's local snprintf() does not
> > implement all the features LIBC does, e.g. KVM's local snprintf() does
> > not support floats or doubles, so testing for those features were
> > excluded.
> > 
> > Testing was added for the features that are expected to work to
> > support a minimal version of printf() in the guest.
> > 
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../testing/selftests/kvm/guest_print_test.c  | 223 ++++++++++++++++++
> >  2 files changed, 224 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/guest_print_test.c
> 
> I added this diff to this patch
> 
> diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
> index 3a9a5db9794e..602a23ea9f01 100644
> --- a/tools/testing/selftests/kvm/guest_print_test.c
> +++ b/tools/testing/selftests/kvm/guest_print_test.c
> @@ -115,7 +115,7 @@ static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
>         while (1) {
>                 vcpu_run(vcpu);
>  
> -               TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +               TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
>                             "Unexpected exit reason: %u (%s),\n",
>                             run->exit_reason,
>                             exit_reason_str(run->exit_reason));
> @@ -161,7 +161,7 @@ static void test_limits(void)
>         run = vcpu->run;
>         vcpu_run(vcpu);
>  
> -       TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +       TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
>                     "Unexpected exit reason: %u (%s),\n",
>                     run->exit_reason,
>                     exit_reason_str(run->exit_reason));
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 4cf69fa8bfba..4adf526dc378 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -6,8 +6,19 @@
>   */
>  #ifndef SELFTEST_KVM_UCALL_COMMON_H
>  #define SELFTEST_KVM_UCALL_COMMON_H
> +#include <linux/kvm.h>
>  #include "test_util.h"
>  
> +#if defined(__aarch64__)
> +#define UCALL_EXIT_REASON      KVM_EXIT_MMIO
> +#elif defined(__x86_64__)
> +#define UCALL_EXIT_REASON      KVM_EXIT_IO
> +#elif defined(__s390x__)
> +#define UCALL_EXIT_REASON      KVM_EXIT_S390_SIEIC
> +#elif defined(__riscv)
> +#define UCALL_EXIT_REASON      KVM_EXIT_RISCV_SBI
> +#endif
> +
>  /* Common ucalls */
>  enum {
>         UCALL_NONE,
> 
> and then compiled the test for riscv and it passed. I also ran all other
> riscv tests successfully.

Can I have your SoB for the ucall_common.h patch?  I'll write a changelog and fold
in a separate prep patch for that change.

> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index f65889f5a083..f2a8b3262f17 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -123,6 +123,7 @@ TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
> >  TEST_GEN_PROGS_x86_64 += demand_paging_test
> >  TEST_GEN_PROGS_x86_64 += dirty_log_test
> >  TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
> > +TEST_GEN_PROGS_x86_64 += guest_print_test

Argh, this is why ARM didn't fail for me, the test was only built for x86.  I'll
double check that ARM works with the above, and also enable the test for all
architectures.  If the printf stuff doesn't work on s390, then we definitely want
to know before this is fully merged.

Thanks Drew!
