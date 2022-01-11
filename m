Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3BB48BA9A
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 23:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiAKWQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 17:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiAKWQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 17:16:14 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6D0C06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 14:16:14 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id u6so1425414uaq.0
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 14:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AF3AnK5QyRYkI5duIqUXZZyuc4HWRw2U/KYG/ayPad0=;
        b=kqs/HwY3kdGXMoeolWYAyWUmTsR5sUhlpiLE8CAWHX6TaOVUKEGXDoxHbcTKLmVCG0
         IhtAfUwVRh7KP08av16i05Pd8FSrwjNjdtpPbMsBBI6PnKm01aCOykc8ytoDzIF+jZDB
         ucnSWegydwRYmRG2G1HxICSrD5e0tifOqyBR84K9SvrJc3dFdKb2+NJk33fJ7KcgEmCj
         8My/Dr+oFtLZiKHrhV+u2262tUuikggcl6klljuaZ7xfc240+z/kd9ZN5q+lHPduYO6Z
         h7M0lXflluwxEqTugcPItRA1FJLHtUckpYA1aVFTZM2fVFlq5m8B05K0fMNvQZ60va7a
         9NAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AF3AnK5QyRYkI5duIqUXZZyuc4HWRw2U/KYG/ayPad0=;
        b=glHc/0FSjH6Rp8FptJ7lxIR3ZOTJN/xgDKjVo01+egqQh74xEhSHC3edFx1Mdv4ra5
         jIdl2DQ04jK87A2aZj3Posg6Ma7Dry8Zu1hxPloEn7uLnwpwZB3qUMp9EqRKYqhqCNEY
         5xurgebLEPR8thq1Oc9L81MZ6FO2UkEiZIComQdN4a5hsktOX2C6D06DLWSF/AVqkBp4
         5PKueHgiPK+/7sJFLLIeQdHzRjSwoQoa2RBucAZ7ELENhB91/qkPPDmzSyUnQtGGt30U
         Zio2msd610QodkmndQ3EunbTPIRiPq04cnUUJ1Wpw2HdvtREs18hKySnFdCrTHS0VFJi
         9VpA==
X-Gm-Message-State: AOAM532Y4ZVKGaYBnJeebFAI1lAMVNPWodl0DGuBKSWTienVm4/OMbct
        BIq+utlfM8JBMwggB8+qKdVJ8E0H2nT0qh+sjM8IIg==
X-Google-Smtp-Source: ABdhPJwH0XMvSBmXysbrAE0IMAmKDuqLdVGaZMH4BqCu7B80Ul8RetTLJ2iipZWKkFFmI8wAVmH1SRHloobnvEvWEdg=
X-Received: by 2002:a05:6102:c46:: with SMTP id y6mr3408907vss.82.1641939373465;
 Tue, 11 Jan 2022 14:16:13 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-4-jingzhangos@google.com> <87a6g2tvia.wl-maz@kernel.org>
In-Reply-To: <87a6g2tvia.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 11 Jan 2022 14:16:01 -0800
Message-ID: <CAAdAUthmAMy3UE3_C_CitW9MWWMGcOPHu0x9aV72YEUL2kpO=g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] KVM: selftests: Add vgic initialization for dirty
 log perf test for ARM
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 2:30 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 10 Jan 2022 21:04:41 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > For ARM64, if no vgic is setup before the dirty log perf test, the
> > userspace irqchip would be used, which would affect the dirty log perf
> > test result.
>
> Doesn't it affect *all* performance tests? How much does this change
> contributes to the performance numbers you give in the cover letter?
>
This bottleneck showed up after adding the fast path patch. I didn't
try other performance tests with this, but I think it is a good idea
to add a vgic setup for all performance tests. I can post another
patch later to make it available for all performance tests after
finishing this one and verifying all other performance tests.
Below is the test result without adding the vgic setup. It shows
20~30% improvement for the different number of vCPUs.
+-------+------------------------+
    | #vCPU | dirty memory time (ms) |
    +-------+------------------------+
    | 1     | 965                    |
    +-------+------------------------+
    | 2     | 1006                    |
    +-------+------------------------+
    | 4     | 1128                    |
    +-------+------------------------+
    | 8     | 2005                   |
    +-------+------------------------+
    | 16    | 3903                   |
    +-------+------------------------+
    | 32    | 7595                   |
    +-------+------------------------+
    | 64    | 15783                  |
    +-------+------------------------+
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
>
> How did you pick these values?
I used the same values from other tests.
Talked with Raghavendra about the values. It could be arbitrary and he
chose these values from QEMU's configuration.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
