Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0353248BA97
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 23:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346058AbiAKWNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 17:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346093AbiAKWNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 17:13:09 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2DBC06175B
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 14:13:08 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id m15so1296627uap.6
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 14:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mVqyboTrUQf4DREgs2Gld2sJABz7v9pKGO6C5NIz4lU=;
        b=tKnIVcqYQ8IH51qXU8mwqZbrbChJV08ItDElKaGcLDPbMX6bagUXInkdQQ7SX+KlDd
         BCft/nCDq1V1roh3GxIHlxxoqoLrs20C4BN+ufRrdNDSALUNUa2H52/9c6WQec7jfuXS
         7kybQhRfipMnEhOhoBfRL5MbHvzGFvJCAGihzDfHwrRpt3257iEcZ6C46HKGzEgaaK/Q
         HAqIPiGZmjEFWTtqkRY5bI0d/xox3Spp0+Q+IZ8ElcRXPER8Acj0EHiBLBx6TdfbeZEw
         lwbRgzC2wcl5fpJKZBxhMYDnO8jpfK4F2pxc7MAJQEo05J+cuQC9U7WR6TMIiT/zLHA3
         Ksdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mVqyboTrUQf4DREgs2Gld2sJABz7v9pKGO6C5NIz4lU=;
        b=uGXDhL+AgKqkBhpQgPLZsJDqjst6VoFGkwFeVPLjDUOPaV7rzOaRThJHzMiiYYFWKv
         UNHfgKpVx2P5gE/5XMklPukV0RVaLf8bQFX4y995xGyPribHIhYQ+c0oCwBldCMdxnhB
         YVgx/oP47/bWhzXSkrm46v7F8NgqF+SaXnnUWrUv2HXC8xUhnUPFhXBCvOFeQV2mqr/r
         0g0Uu8lN7p0WLns3LfrbggxpV5jXVHjGYzNetWNFESvusERIdCL4INnHAuQv1QOgBRO6
         YcFNQKiOpcEoQUtzeJAnzygQbar9YsTTvY+SqVrrjzl3BZsf1AteaqVbDFGLRKQM0vxK
         nQxw==
X-Gm-Message-State: AOAM530/67W9DL+cdg6bUfSJ8QplSqF3jecSopy4vG4YSXZkL8i34uS/
        z4063Yr0jR7a6ULje2X8ioqZMMbyyZHo9zeNmFkSSb3kWGI=
X-Google-Smtp-Source: ABdhPJy+BkpO1MwRN9S58PetXGK8On3GmtY4knYWGb93a+7u1ctUaZ8CuimluWsQBlC/QERXOTupuNqged+fF2I5Zt8=
X-Received: by 2002:ab0:13c3:: with SMTP id n3mr2983807uae.39.1641939187476;
 Tue, 11 Jan 2022 14:13:07 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-4-jingzhangos@google.com> <20220111095505.spwflhcdfxwveh3u@gator>
In-Reply-To: <20220111095505.spwflhcdfxwveh3u@gator>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 11 Jan 2022 14:12:56 -0800
Message-ID: <CAAdAUti4v-ybMvDUErUO==iAU+tt_fuUPdgq4g2D0hSx=88D8g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] KVM: selftests: Add vgic initialization for dirty
 log perf test for ARM
To:     Andrew Jones <drjones@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 1:55 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Jan 10, 2022 at 09:04:41PM +0000, Jing Zhang wrote:
> > For ARM64, if no vgic is setup before the dirty log perf test, the
> > userspace irqchip would be used, which would affect the dirty log perf
> > test result.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > index 1954b964d1cf..b501338d9430 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > @@ -18,6 +18,12 @@
> >  #include "test_util.h"
> >  #include "perf_test_util.h"
> >  #include "guest_modes.h"
> > +#ifdef __aarch64__
> > +#include "aarch64/vgic.h"
> > +
> > +#define GICD_BASE_GPA                        0x8000000ULL
> > +#define GICR_BASE_GPA                        0x80A0000ULL
> > +#endif
> >
> >  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
> >  #define TEST_HOST_LOOP_N             2UL
> > @@ -200,6 +206,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >               vm_enable_cap(vm, &cap);
> >       }
> >
> > +#ifdef __aarch64__
> > +     vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
>                                     ^^ extra parameter
The patch is based on kvm/queue, which has a patch adding an extra
parameter nr_irqs.

>
> Thanks,
> drew
>
> > +#endif
> > +
> >       /* Start the iterations */
> >       iteration = 0;
> >       host_quit = false;
> > --
> > 2.34.1.575.g55b058a8bb-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
>

Thanks,
Jing
