Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315043EDE60
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 22:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhHPUBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 16:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhHPUBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 16:01:45 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8038FC061764
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 13:01:13 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id j186so9075640vsc.10
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 13:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/KwqlZeT6sdGRreX5g/ke/YMCXwSEo7rp8jOlCMxsII=;
        b=mwdSDvWVIjvElZeYJ1YVAkD625BhTxrGwgCGPtGfzVVFj5UFz7ScpbHXnydzovM1vP
         BJ+axQl4nEU4wZJrpsSc5OkDPMXIS8f797JO2zCwFnhDH9rVz/PbVoqPggcufln3CPRo
         uC5KIxcBFNbdxVURt2NmdkT+8YaMmGaT1s4I39BmyKCOvPZmCL7iHW1BSbHcb6cnbtUD
         42SM2ypUxKkEl7j/69NEOpyMr624OI4qWWlIjMlJ9yutTN/YO5MG4s+CXb80XJUSIpTE
         2X6qTZIRp1c7Ldk40dyAbgFKkfI3y9YCVF3knkWftif0DugP9qDBWnSAABR+lZaKLCQE
         +rYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/KwqlZeT6sdGRreX5g/ke/YMCXwSEo7rp8jOlCMxsII=;
        b=ZKPDVqZVmYwta0aTjgzWEJQ//WPK8mQKeVDLTjaekdxLJpac0iCsO02zvb2Pu0CnQf
         pg6apN7Or+S1bJ0yRpgG2VQ9hrrvyPjGoOUEgXKufF19kn20Br/ZhvcaEAUARCoDMNUB
         tCrzEL1Xy0QcDsW+cq8Qk0htoQoWCfQFVM0o4uvqnfmae12Bk+rQWQxbXRHIhPa4pcOB
         H/sYe5ExnKbXXdi1uHMDBDT5Wbvn75Y4XHrlYoynkTdA0F150gCUea4JZzyEgVf5ksd1
         S5gsyI186Mkj0C4Ausy2jv9/zLXzpM6faPsmoIw2Ibs2n+ySi8Fuxg/OjCcRCGAt1CI5
         PqBw==
X-Gm-Message-State: AOAM531uy47x8nsfm7laY/JiCrGeP647wXpFhuMZZlgcudX3V+sK08f3
        pV5vWBV1KbcTNnyUVID1pmB6zidJmLPoTcD14bzcvQ==
X-Google-Smtp-Source: ABdhPJynTv01BWxGnAkTuRLxJ40jk1zjrNBPt6FCIz1AgO0PbibFSIyewQo/9Ua+dYvwQmQ2ZPLZIIOLv9nOWuE2siM=
X-Received: by 2002:a67:ec88:: with SMTP id h8mr8108vsp.47.1629144072541; Mon,
 16 Aug 2021 13:01:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com> <20210813211211.2983293-5-rananta@google.com>
 <35c06dff-36cf-3836-e469-bedcf3c04a4d@huawei.com>
In-Reply-To: <35c06dff-36cf-3836-e469-bedcf3c04a4d@huawei.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 16 Aug 2021 13:01:01 -0700
Message-ID: <CAJHc60x2XdRKywRytMG-B95ZYd5fdrybau0mXp1UrHngyWiuDA@mail.gmail.com>
Subject: Re: [PATCH 04/10] KVM: arm64: selftests: Add basic support for arch_timers
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On Sat, Aug 14, 2021 at 2:10 AM Zenghui Yu <yuzenghui@huawei.com> wrote:
>
> On 2021/8/14 5:12, Raghavendra Rao Ananta wrote:
> > Add a minimalistic library support to access the virtual timers,
> > that can be used for simple timing functionalities, such as
> > introducing delays in the guest.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../kvm/include/aarch64/arch_timer.h          | 138 ++++++++++++++++++
> >  1 file changed, 138 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> >
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> > new file mode 100644
> > index 000000000000..e6144ab95348
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> > @@ -0,0 +1,138 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * ARM Generic Interrupt Controller (GIC) specific defines
>
> This isn't GIC specific, but arch timer.

You are right. That's my bad.
>
>
> > + */
> > +
> > +#ifndef SELFTEST_KVM_ARCH_TIMER_H
> > +#define SELFTEST_KVM_ARCH_TIMER_H
> > +
> > +#include <linux/sizes.h>
>
> Do we really need it?


I must have left it from some code re-org. We don't need it anymore.
Will remove.
>
>
> > +
> > +#include "processor.h"
> > +
> > +enum arch_timer {
> > +     VIRTUAL,
> > +     PHYSICAL,
> > +};
> > +
> > +#define CTL_ENABLE   (1 << 0)
> > +#define CTL_ISTATUS  (1 << 2)
> > +#define CTL_IMASK    (1 << 1)
>
> nitpick: Move CTL_IMASK before CTL_ISTATUS ?


Sure, that's cleaner!
>
>
> > +
> > +#define msec_to_cycles(msec) \
> > +     (timer_get_cntfrq() * (uint64_t)(msec) / 1000)
> > +
> > +#define usec_to_cycles(usec) \
> > +     (timer_get_cntfrq() * (uint64_t)(usec) / 1000000)
> > +
> > +#define cycles_to_usec(cycles) \
> > +     ((uint64_t)(cycles) * 1000000 / timer_get_cntfrq())
> > +
> > +static inline uint32_t timer_get_cntfrq(void)
> > +{
> > +     return read_sysreg(cntfrq_el0);
> > +}
> > +
> > +static inline uint64_t timer_get_cntct(enum arch_timer timer)
> > +{
> > +     isb();
> > +
> > +     switch (timer) {
> > +     case VIRTUAL:
> > +             return read_sysreg(cntvct_el0);
> > +     case PHYSICAL:
> > +             return read_sysreg(cntpct_el0);
> > +     default:
> > +             GUEST_ASSERT_1(0, timer);
> > +     }
> > +
> > +     /* We should not reach here */
> > +     return 0;
> > +}
> > +
> > +static inline void timer_set_cval(enum arch_timer timer, uint64_t cval)
> > +{
> > +     switch (timer) {
> > +     case VIRTUAL:
> > +             return write_sysreg(cntv_cval_el0, cval);
> > +     case PHYSICAL:
> > +             return write_sysreg(cntp_cval_el0, cval);
> > +     default:
> > +             GUEST_ASSERT_1(0, timer);
> > +     }
> > +
> > +     isb();
>
> ISB should be performed before 'return'. And the same for
> timer_set_{tval,ctl}.


Seems like a copy-paste error on my side. The timer_set_*() functions
shouldn't even have a 'return'. Thanks for catching this! Will fix it.
>
>
> Thanks,
> Zenghui


Regards,
Raghavendra
