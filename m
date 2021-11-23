Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2013459C8D
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 08:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhKWHHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 02:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhKWHHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 02:07:23 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37891C061574;
        Mon, 22 Nov 2021 23:04:16 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so1341268pjc.4;
        Mon, 22 Nov 2021 23:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=tKd2LXgwcQ5xNP29ps7tF+q/XBToi67NLNIQEM3kIhQ=;
        b=PA3kJyiO9ior0JsiqUNZscApubHqocMm5To9U9sgI7J8SdAXjNq1PYXu6+UqhwaHLJ
         DtKsujvNBTHyyFRFg0uX3eu+F8kKNgyJb+kNSK+j82mhqJlPuQmA6M9QTz075L/4ZEvF
         jmyWiN2FcdE0fe7z3ywo+QB7xo16Ewm3QiLndAwF6WdjlZn1GBeGaS0/S1IrgiFSIYep
         rZizFAUkit+2S/Zhj5Hz97YEHgoGitsMnZMew0P16A7Wcpy+A0t2cmJOw82jl5YlGUJM
         AfzVDoimrFE6C0bAPf8VOyc9G2ggVXBg3ExJiRuRE3HMhsgBjkerhrthz9EbDhcroDB9
         mkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tKd2LXgwcQ5xNP29ps7tF+q/XBToi67NLNIQEM3kIhQ=;
        b=TmtPom8mORrviqOI1eBkKPAqZnDSIC7BbQtN1/kWduJEM9wyzv8IousgM0i8xw80Wq
         9sMEDAz+wULzxUqIuZEP3euIIWhoJAnhtZYh2k/du5BLzrSuTercuIxSye597KTEYKlx
         QJjDanM+0TZkUPxicUiV48e8dKi/TU/VETOUFQdMtmMqOvFKJThMPNVygsHftxgIfuly
         NZfyb/XjuFkEk3gLoQeHR5Xua+kUcMowHQnY5JeKUkPdFSuzc+mAg3Ko21xvAiTr2WxL
         CXPakurvmZ0GyxqFyWqTT+UVG/OWE6OJ7qDFKRh5sKzGTtinVfV6mZWwYcYOHHmcGmjW
         TtoA==
X-Gm-Message-State: AOAM530f2QoFQnhluq2GuFA/DPFVJDyzewMQs32Zz63bc1AXdhre+j1V
        +YLx7vORfrggDiLyfkUm7sI=
X-Google-Smtp-Source: ABdhPJwiQAL0Vq/04SRkqjhOYwkbZKw62B3J0t5AtjbaFy1AG8wKc+3O9Y7juVYO4c2/1HqJM4WkZQ==
X-Received: by 2002:a17:902:7e48:b0:142:728b:e475 with SMTP id a8-20020a1709027e4800b00142728be475mr4336159pln.15.1637651055715;
        Mon, 22 Nov 2021 23:04:15 -0800 (PST)
Received: from localhost.localdomain ([43.128.78.144])
        by smtp.gmail.com with ESMTPSA id i185sm11146185pfg.80.2021.11.22.23.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 23:04:15 -0800 (PST)
Date:   Tue, 23 Nov 2021 15:02:19 +0800
From:   Aili Yao <yaoaili126@gmail.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     "yaoaili =?UTF-8?B?W+S5iOeIseWIqV0=?=" <yaoaili@kingsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <20211123145713.76a7d5b8@gmail.com>
In-Reply-To: <CANRm+CxAM-h1F3CTNUY6wc-LAgRPDbwFrTPKXS_aoOBx9mveCQ@mail.gmail.com>
References: <20211122095619.000060d2@gmail.com>
 <YZvrvmRnuDc1e+gi@google.com>
 <CANRm+Cx+bC8D7s1qzJYbrT+1rm46wxg6bAXD+kGYAHGnruZMXw@mail.gmail.com>
 <3204a646aa9d43d0b9af8da1c5ddf79f@kingsoft.com>
 <CANRm+CxAM-h1F3CTNUY6wc-LAgRPDbwFrTPKXS_aoOBx9mveCQ@mail.gmail.com>
Organization: ksyun
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Nov 2021 14:24:19 +0800
Wanpeng Li <kernellwp@gmail.com> wrote:

> On Tue, 23 Nov 2021 at 12:11, yaoaili [=E4=B9=88=E7=88=B1=E5=88=A9] <yaoa=
ili@kingsoft.com>
> wrote:
> > =20
> > > On Tue, 23 Nov 2021 at 03:14, Sean Christopherson
> > > <seanjc@google.com> wrote: =20
> > > >
> > > > On Mon, Nov 22, 2021, Aili Yao wrote: =20
> > > > > From: Aili Yao <yaoaili@kingsoft.com>
> > > > >
> > > > > When we isolate some pyhiscal cores, We may not use them for
> > > > > kvm guests, We may use them for other purposes like DPDK, or
> > > > > we can make some kvm guests isolated and some not, the global
> > > > > judgement pi_inject_timer is not enough; We may make wrong
> > > > > decisions:
> > > > >
> > > > > In such a scenario, the guests without isolated cores will
> > > > > not be permitted to use vmx preemption timer, and tscdeadline
> > > > > fastpath also be disabled, both will lead to performance
> > > > > penalty.
> > > > >
> > > > > So check whether the vcpu->cpu is isolated, if not, don't
> > > > > post timer interrupt.
> > > > >
> > > > > Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> > > > > ---
> > > > >  arch/x86/kvm/lapic.c | 4 +++-
> > > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c index
> > > > > 759952dd1222..72dde5532101 100644
> > > > > --- a/arch/x86/kvm/lapic.c
> > > > > +++ b/arch/x86/kvm/lapic.c
> > > > > @@ -34,6 +34,7 @@
> > > > >  #include <asm/delay.h>
> > > > >  #include <linux/atomic.h>
> > > > >  #include <linux/jump_label.h>
> > > > > +#include <linux/sched/isolation.h>
> > > > >  #include "kvm_cache_regs.h"
> > > > >  #include "irq.h"
> > > > >  #include "ioapic.h"
> > > > > @@ -113,7 +114,8 @@ static inline u32 kvm_x2apic_id(struct
> > > > > kvm_lapic *apic)
> > > > >
> > > > >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu
> > > > > *vcpu)  {
> > > > > -     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > > > > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > > > +             !housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER); =20
> > > >
> > > > I don't think this is safe, vcpu->cpu will be -1 if the vCPU
> > > > isn't scheduled in. =20
> >
> > Yes, vcpu->cpu is  -1 before vcpu create, but in my environments,
> > it didn't trigger this issue. I need to dig more, Thanks!
> > Maybe I need one valid check here.
> > =20
> > > > This also doesn't play nice with the admin forcing
> > > > pi_inject_timer=3D1. Not saying there's a reasonable use case for
> > > > doing that, but it's supported today and this would break that
> > > > behavior.  It would also lead to weird behavior if a vCPU were
> > > > migrated on/off a housekeeping vCPU.  Again, probably not a
> > > > reasonable use case, but I don't see anything =20
> > > that would outright prevent that behavior. =20
> >
> > Yes,  this is not one common operation,  But I did do test some
> > scenarios: 1. isolated cpu --> housekeeping cpu;
> >     isolated guest timer is in housekeeping CPU, for migration,
> > kvm_can_post_timer_interrupt will return false, so the timer may be
> > migrated to vcpu->cpu; This seems works in my test;
> > 2. isolated --> isolated
> >     Isolated guest timer is in housekeeping cpu, for
> > migration,kvm_can_post_timer_interrupt return true, timer is not
> > migrated 3. housekeeping CPU --> isolated CPU
> >     non-isolated CPU timer is usually in vcpu->cpu, for migration
> > to isolated, kvm_can_post_timer_interrupt will be true,  the timer
> > remain on the same CPU; This seems works in my test;
> > 4. housekeeping CPU --> housekeeping CPU
> >      timer migrated;
> > It seems this is not an affecting problem;
> > =20
> > > >
> > > > The existing behavior also feels a bit unsafe as
> > > > pi_inject_timer is writable while KVM is running, though I
> > > > supposed that's orthogonal to this =20
> > > discussion. =20
> > > >
> > > > Rather than check vcpu->cpu, is there an existing vCPU flag
> > > > that can be queried, e.g. KVM_HINTS_REALTIME? =20
> > >
> > > How about something like below:
> > >
> > > From 67f605120e212384cb3d5788ba8c83f15659503b Mon Sep 17 00:00:00
> > > 2001
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > > Date: Tue, 23 Nov 2021 10:36:10 +0800
> > > Subject: [PATCH] KVM: LAPIC: To keep the vCPUs in non-root mode
> > > for timer- pi
> > >
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via
> > > posted interrupt) mentioned that the host admin should well tune
> > > the guest setup, so that vCPUs are placed on isolated pCPUs, and
> > > with several pCPUs surplus for
> > > *busy* housekeeping.
> > > It is better to disable mwait/hlt/pause vmexits to keep the vCPUs
> > > in non-root mode. However, we may isolate pCPUs for other purpose
> > > like DPDK or we can make some guests isolated and others not,
> > > Let's add the checking kvm_mwait_in_guest() to
> > > kvm_can_post_timer_interrupt() since we can't benefit from timer
> > > posted-interrupt w/o keeping the vCPUs in non-root mode.
> > >
> > > Reported-by: Aili Yao <yaoaili@kingsoft.com>
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > >  arch/x86/kvm/lapic.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c index
> > > 759952dd1222..8257566d44c7 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -113,14 +113,13 @@ static inline u32 kvm_x2apic_id(struct
> > > kvm_lapic *apic)
> > >
> > >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> > > {
> > > -    return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > > +    return pi_inject_timer && kvm_mwait_in_guest(vcpu->kvm) &&
> > > kvm_vcpu_apicv_active(vcpu);
> > >  }
> > >
> > >  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)  {
> > >      return kvm_x86_ops.set_hv_timer
> > > -           && !(kvm_mwait_in_guest(vcpu->kvm) ||
> > > -            kvm_can_post_timer_interrupt(vcpu));
> > > +           && !kvm_mwait_in_guest(vcpu->kvm);
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer); =20
> >
> > This method seems more quick and safe, but I have one question:
> > Does this kvm_mwait_in_guest can guarantee the CPU isolated,  in
> > some production environments and usually,  MWAIT feature is
> > disabled in host and even guests with isolated CPUs.  And also we
> > can set guests kvm_mwait_in_guest true with CPUs just pinned, not
> > isolated. =20
>=20
> You won't benefit from timer posted-interrupt if mwait is not exposed
> to the guest since you can't keep CPU in non-root mode.
> kvm_mwait_in_guest() will not guarantee the CPU is isolated, but
> what's still bothering?

Sorry, Did I miss some thing?

What in my mind: MWait may be disabled in bios, so host will use halt
instruction as one replacement for idle operation, in such a
configuration, Mwait in guest will also be disabled even if you try to
set kvm_mwait_in_guest true; As a result, halt,pause may not exit the
guest, so the post interrupt still counts?

For current code, We can migrate guest between isolated and
housekeeping or we can change the cpu pinning on the fly, we allow this
even the operation is not usually used, right?

Thanks!
Aili Yao



