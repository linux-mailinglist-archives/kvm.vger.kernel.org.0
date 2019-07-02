Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B987A5CCD6
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 11:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfGBJoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 05:44:09 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39605 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbfGBJoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 05:44:09 -0400
Received: by mail-ot1-f65.google.com with SMTP id r21so15869833otq.6;
        Tue, 02 Jul 2019 02:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9j8FE0yS4BbQGQXPJ0hZG1mtgrc4IiA+27vNRTbC7BM=;
        b=MFTUdMwnRK0dv3ncQrDorUTNSubUaJIKovgpe0ebHT/lHHEzS9ley4sjjDyRQ6p9r7
         /Tu/aApwhLdkmRoSJN5WsN+Zj+FGxxOkIZ+Ap8Dh5tX8qejcx9L+Ki/NkPTTfDg8MQ2f
         Z7Uyoa8oObRyeCzQF1acxlZRyBDFGcQH5BWg8Hi55T+EFfm+6iKggus2e28roR8iOkfN
         FTi3LKPJIkMTUWbN+Uanu31H8V+ITbLmIQtLX3/5yeYb4TIsYM6+8tTTLwSJ7SRslVJd
         rH8D9C5XyvwNH9ihcwuj4BW3YxTGskpa4bT/LdHfr/dyihKV0ygXgKNqLnFjn+yFYtqP
         aMNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9j8FE0yS4BbQGQXPJ0hZG1mtgrc4IiA+27vNRTbC7BM=;
        b=eWT9PQqzojqRucB8WPOEvEBkjd3NnPnCBIC14CUryvhQw9JZmLajAfqRLIH5Cit89+
         Uqnc1IsbhkS/2SsRut9hddJxdDbUHzoaey74rbzNHpN+K97Dc47LtqHw6AvVXWjdmJXQ
         llqTnmT63/R+NXhqKfLn5CoKs/JLfQ6OVSJ1THS+IxKqPVxkzep3Q5sL84uTsSSz55Aw
         L/KIszUaMMqyIPE7W0WW4HNXawXzimvtP7muCsTc4MWigwyxlmDxwv7CS5wHrN+CYiPU
         u6K0x84NNk0EbY5HWDH1YBW8MCFFuorqtMEUQfRSx7w/cP5qLxc1usOjGjzqR3zI3fyd
         4Hgg==
X-Gm-Message-State: APjAAAW/4ZuQcTTj10LtKI30bX4JbvBWpq/wzISvMNZUWE2DhHUkkMgY
        6zeoEbrf5K/l1O6UivlSJj3GB0W52HCeKusChgw=
X-Google-Smtp-Source: APXvYqwa+Dq/l4kHweyQkXdMAVKhDZdjuNNm0Cj3TNuPwW4T2lv4ATydcstAKkx8Mk73a7zTXAOwyo4ptQ+FeJk3avk=
X-Received: by 2002:a9d:6312:: with SMTP id q18mr16540158otk.45.1562060648265;
 Tue, 02 Jul 2019 02:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.21.1906250821220.32342@nanos.tec.linutronix.de>
 <f5c36f89-61bf-a82e-3d3b-79720b2da2ef@intel.com> <alpine.DEB.2.21.1906251330330.32342@nanos.tec.linutronix.de>
 <20190628063231.GA7766@shbuild999.sh.intel.com> <alpine.DEB.2.21.1906280929010.32342@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1906290912390.1802@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1906301334290.1802@nanos.tec.linutronix.de>
 <20190630130347.GB93752@shbuild999.sh.intel.com> <alpine.DEB.2.21.1906302021320.1802@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1907010829590.1802@nanos.tec.linutronix.de>
 <20190701083654.GB12486@shbuild999.sh.intel.com> <alpine.DEB.2.21.1907011123220.1802@nanos.tec.linutronix.de>
 <d08d55c5-bb02-f832-4306-9daf234428a8@intel.com> <alpine.DEB.2.21.1907012011460.1802@nanos.tec.linutronix.de>
 <CANRm+CyQy+=fzY7jn6Q=q6C4ucHS-Z37rq87sOJT-yO0ECiHFw@mail.gmail.com> <alpine.DEB.2.21.1907020837020.1802@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1907020837020.1802@nanos.tec.linutronix.de>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 2 Jul 2019 17:44:00 +0800
Message-ID: <CANRm+CwttRaBUgL=OO0MkziD+qkj2GEXaDZfAZ9ZHAcC736kLA@mail.gmail.com>
Subject: Re: [BUG] kvm: APIC emulation problem - was Re: [LKP] [x86/hotplug] ...
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Rong Chen <rong.a.chen@intel.com>, Feng Tang <feng.tang@intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "tipbuild@zytor.com" <tipbuild@zytor.com>,
        "lkp@01.org" <lkp@01.org>, Ingo Molnar <mingo@kernel.org>,
        kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Jul 2019 at 14:40, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Wanpeng,
>
> On Tue, 2 Jul 2019, Wanpeng Li wrote:
> > On Tue, 2 Jul 2019 at 06:44, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >
> > > While that CPU0 hotplug test case is surely an esoteric issue, the APIC
> > > emulation is still wrong, Even if the play_dead() code would not enable
> > > interrupts then the pending IRR bit would turn into an ISR .. interrupt
> > > when the APIC is reenabled on startup.
> >
> > >From SDM 10.4.7.2 Local APIC State After It Has Been Software Disabled
> > * Pending interrupts in the IRR and ISR registers are held and require
> > masking or handling by the CPU.
>
> Correct.
>
> > In your testing, hardware cpu will not respect soft disable APIC when
> > IRR has already been set or APICv posted-interrupt is in flight, so we
> > can skip soft disable APIC checking when clearing IRR and set ISR,
> > continue to respect soft disable APIC when attempting to set IRR.
> > Could you try below fix?
>
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 05d8934..f857a12 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2376,7 +2376,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
> >      struct kvm_lapic *apic = vcpu->arch.apic;
> >      u32 ppr;
> >
> > -    if (!apic_enabled(apic))
> > +    if (!kvm_apic_hw_enabled(apic))
> >          return -1;
> >
> >      __apic_update_ppr(apic, &ppr);
>
> Yes. That fixes it and works as expected. Thanks for the quick resolution.

No problem. :)

> I surely stared at that function, but was not sure how to fix
> it proper.
>
> Tested-by: Thomas Gleixner <tglx@linutronix.de>
>
> Please add a Cc: stable... tag when you post the patch.

Ok.

Regards,
Wanpeng Li
