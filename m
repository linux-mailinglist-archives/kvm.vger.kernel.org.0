Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E4049B501
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 14:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1576746AbiAYNZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 08:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576576AbiAYNXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 08:23:21 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BF9C061747
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 05:23:20 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id x193so31036395oix.0
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 05:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QmffA1fbeAbx/qMfx78H51dt2gVeXfmIyiPPBL6SKTQ=;
        b=G/gdmh3WdhdjeY9vF1/SCa1s+oJjrvWa4A+zMWHzWB1BMUFrNit6/xrXAgdyPFVbGh
         ja6vutkqjtUKZTZC8woSZcQ+lTIbgHJadM45P4bBEhI8gqko4/daeLBxgyvhPemguDOs
         Mr8uMALqIlHQFu+jNsccypX3FvKn2z7x5VIENtJTH5j2AB2uc/kEYKzQqUJRcRP0OmiV
         lehQiIbSSuqTp+ujyhxicUs+cg1Cm9+lkbsxi/HOMxUylJBx5cPhIxo+0NHEZ3qLrs+4
         gj18GHbZHEw0TPfTCw7Q0isTynNiXypAWNPRRXKPwxMChFS523eJOuv7X68DViKBJrcJ
         NdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QmffA1fbeAbx/qMfx78H51dt2gVeXfmIyiPPBL6SKTQ=;
        b=4YH7eAfkvsleo4VfUPCQOBjKGFWIiNXzgajFhatMDCaVAkMiWEBhmbZ5Jftx8pYpEA
         pFAIqzBhMuLLFYRoJf8fsJ1WTDn+WZYr4qhvjOO+ws4J4xvjJmNTBT16f/tH5+u1aKIV
         yVEk08dPT8j6bluK6+UrmQDf0GwZ4Q6u1pmd+XXylqYV2pVpgJxwmNmC7R4+53cYNNDx
         folGRDICcY3X0SX928s/iTdDtZmluoziNxNWb9SfUjXp0M01bX9YBjTm+cm/Ud4+wDEr
         KO2eBeygRhWz2ACv46VCI4KknE1gxtJyvNZFmaVFxcT2EwU4vmD6UJgEEx0yhDkRg6Q7
         UfiA==
X-Gm-Message-State: AOAM532wd1WMhojaQtGA/W9KzUoS4neNJmnuZ4lCD6O+I9Jnkji9VSNu
        q+m3SqPr7dvysfofCAZCR4xKlYbPjjOmvyoZv7pkRw==
X-Google-Smtp-Source: ABdhPJy5EDCOUygXVL1MR05NfKr1mCxSmEry6ObNNVYcmqV5BWVopmYamb6bVVpdjEkQDkhQEBhfYj6vFaTPhWjf0ZU=
X-Received: by 2002:a05:6808:1785:: with SMTP id bg5mr579957oib.171.1643116999914;
 Tue, 25 Jan 2022 05:23:19 -0800 (PST)
MIME-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com> <20220118015703.3630552-4-jingzhangos@google.com>
In-Reply-To: <20220118015703.3630552-4-jingzhangos@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 25 Jan 2022 13:22:44 +0000
Message-ID: <CA+EHjTz+76bD1Lcr8bmdo9W71yaqLpfEKf1jt=2m2DMqwTd=ag@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Add vgic initialization for dirty
 log perf test for ARM
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Tue, Jan 18, 2022 at 1:57 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> For ARM64, if no vgic is setup before the dirty log perf test, the
> userspace irqchip would be used, which would affect the dirty log perf
> test result.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 1954b964d1cf..b501338d9430 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -18,6 +18,12 @@
>  #include "test_util.h"
>  #include "perf_test_util.h"
>  #include "guest_modes.h"
> +#ifdef __aarch64__
> +#include "aarch64/vgic.h"
> +
> +#define GICD_BASE_GPA                  0x8000000ULL
> +#define GICR_BASE_GPA                  0x80A0000ULL
> +#endif

As you'd mentioned in a previous email, these values are used by other
tests as well as QEMU.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad




>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
>  #define TEST_HOST_LOOP_N               2UL
> @@ -200,6 +206,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                 vm_enable_cap(vm, &cap);
>         }
>
> +#ifdef __aarch64__
> +       vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> +#endif
> +
>         /* Start the iterations */
>         iteration = 0;
>         host_quit = false;
> --
> 2.34.1.703.g22d0c6ccf7-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
