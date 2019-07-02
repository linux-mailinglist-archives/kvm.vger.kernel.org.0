Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29DF75C8CA
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 07:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbfGBF3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 01:29:15 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44158 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfGBF3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 01:29:15 -0400
Received: by mail-ot1-f65.google.com with SMTP id b7so15903126otl.11;
        Mon, 01 Jul 2019 22:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nMeuKVP5xHWRmp/QJV2LOMXx1ct1Sq9+ppDYbGmyz8M=;
        b=G/eaWFJgqLZY97MUoeQaDbFgyhg1b86IPIq834i8jCbOmO1k++pSEN8JwvtmIPZ/m8
         42d76ZRx7T7HAAUWew2uukxjpIcMLXDplGjj3sYLv2ZrRzVB8qdI8x9wO1lI9dYQ28y/
         ybA8ZfE15GU5OMj134WX9/IAmC6+ZHz3ZiGT+3kLs8b1zI590wgKu5NW6nG/NDpu035c
         cjlFqu66aof+Sjfbq8xkWN6JL+e1/NgU/JMKcJlQeN6KndiHh8MoViv3jjIQOHdqyy5Y
         zMzzVPG4GyaV+n1riYdFtrhsLeZ5bK5GuUinaM3DZ/wH337xnFyX7McPrqzA9hSMK4kg
         xFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nMeuKVP5xHWRmp/QJV2LOMXx1ct1Sq9+ppDYbGmyz8M=;
        b=SlahniNbhgOOPfrOhmcr4R/iK6yI5s/tCs7B3ZTjN5oTztZsM0vZzjlfLofrwHd8xO
         Ej/IPkqtMBudW8G0RUo6L90KHPtYz03Dvyl4F44hyCqwZJrx/kfe70kFlwmmwNkNPVMW
         OcaEVheZ5R+m9/CYNmcyPKuPitOYoJuokRQQsG+7lWN05Cm4diZ7JYIZ8RHcka5kfk1U
         7V43+H7FdP1/y427Z3cVqZ+1N7i6yEBUZr4+dICkDBsFCjXdo+uDrbhCXaX/2U3/BRfq
         IUMi21Mfk8iBJsjaIHv+YgUGkGgatKxrURrxXgvfrDJPxb8So/a8gsWrmhLVcoX6PwVT
         ul4Q==
X-Gm-Message-State: APjAAAWIrlWq9G4/kTyMEfFOj3gDNoEnEPvFYvcNxXnJ49qR9Fubgh/b
        z/lbO60ALrtaUzTZ9hBvtRRMwlpZOPrsEGYglMc=
X-Google-Smtp-Source: APXvYqw2daIWXI1P0wI1eAPLhykUPS9zWzRXNuHUbiYiFq3TEoffpquAv8QjqIer/hO7uCJqTSPUYzJ9DZ0MvT5KMCQ=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr22159415otk.56.1562045354208;
 Mon, 01 Jul 2019 22:29:14 -0700 (PDT)
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
In-Reply-To: <alpine.DEB.2.21.1907012011460.1802@nanos.tec.linutronix.de>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 2 Jul 2019 13:29:06 +0800
Message-ID: <CANRm+CyQy+=fzY7jn6Q=q6C4ucHS-Z37rq87sOJT-yO0ECiHFw@mail.gmail.com>
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

Hi Thomas,
On Tue, 2 Jul 2019 at 06:44, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Folks,
>
> after chasing a 0-day test failure for a couple of days, I was finally able
> to reproduce the issue.
>
> Background:
>
>    In preparation of supporting IPI shorthands I changed the CPU offline
>    code to software disable the local APIC instead of just masking it.
>    That's done by clearing the APIC_SPIV_APIC_ENABLED bit in the APIC_SPIV
>    register.
>
> Failure:
>
>    When the CPU comes back online the startup code triggers occasionally
>    the warning in apic_pending_intr_clear(). That complains that the IRRs
>    are not empty.
>
>    The offending vector is the local APIC timer vector who's IRR bit is set
>    and stays set.
>
> It took me quite some time to reproduce the issue locally, but now I can
> see what happens.
>
> It requires apicv_enabled=0, i.e. full apic emulation. With apicv_enabled=1
> (and hardware support) it behaves correctly.
>
> Here is the series of events:
>
>     Guest CPU
>
>     goes down
>
>       native_cpu_disable()
>
>         apic_soft_disable();
>
>     play_dead()
>
>     ....
>
>     startup()
>
>       if (apic_enabled())
>         apic_pending_intr_clear()       <- Not taken
>
>      enable APIC
>
>         apic_pending_intr_clear()       <- Triggers warning because IRR is stale
>
> When this happens then the deadline timer or the regular APIC timer -
> happens with both, has fired shortly before the APIC is disabled, but the
> interrupt was not serviced because the guest CPU was in an interrupt
> disabled region at that point.
>
> The state of the timer vector ISR/IRR bits:
>
>                               ISR     IRR
> before apic_soft_disable()    0       1
> after apic_soft_disable()     0       1
>
> On startup                    0       1
>
> Now one would assume that the IRR is cleared after the INIT reset, but this
> happens only on CPU0.
>
> Why?
>
> Because our CPU0 hotplug is just for testing to make sure nothing breaks
> and goes through an NMI wakeup vehicle because INIT would send it through
> the boots-trap code which is not really working if that CPU was not
> physically unplugged.
>
> Now looking at a real world APIC the situation in that case is:
>
>                               ISR     IRR
> before apic_soft_disable()    0       1
> after apic_soft_disable()     0       1
>
> On startup                    0       0
>
> Why?
>
> Once the dying CPU reenables interrupts the pending interrupt gets
> delivered as a spurious interupt and then the state is clear.
>
> While that CPU0 hotplug test case is surely an esoteric issue, the APIC
> emulation is still wrong, Even if the play_dead() code would not enable
> interrupts then the pending IRR bit would turn into an ISR .. interrupt
> when the APIC is reenabled on startup.

From SDM 10.4.7.2 Local APIC State After It Has Been Software Disabled
* Pending interrupts in the IRR and ISR registers are held and require
masking or handling by the CPU.

In your testing, hardware cpu will not respect soft disable APIC when
IRR has already been set or APICv posted-interrupt is in flight, so we
can skip soft disable APIC checking when clearing IRR and set ISR,
continue to respect soft disable APIC when attempting to set IRR.
Could you try below fix?

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 05d8934..f857a12 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2376,7 +2376,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
     struct kvm_lapic *apic = vcpu->arch.apic;
     u32 ppr;

-    if (!apic_enabled(apic))
+    if (!kvm_apic_hw_enabled(apic))
         return -1;

     __apic_update_ppr(apic, &ppr);

Regards,
Wanpeng Li
