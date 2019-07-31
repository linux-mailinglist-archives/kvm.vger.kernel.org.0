Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F467BA93
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 09:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfGaHS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 03:18:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52191 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfGaHSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 03:18:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so59591189wma.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 00:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KtSNFiPVmHNMGf6EfCgApRoebnc5Uef1+tJZX1b5aA8=;
        b=houTSLkWhFruGS1YjP+F2HpMrtJKvRK3yOUcGB2tYJsjZigE90sUSKY40izByu2hKj
         Ure9Oo/Xq6LZXTR/nbw7gSnqxopbYu1OetoClC7ERoctUDTXYJlQwLBybE5F9t0F3ofF
         rE+qSdtkpKNe6aXBNmD8Hjarz9xZmxkqK0jbCnSNGOO+w3DC1u+SP3nnPYpW3+yIRvnL
         Ov45LxDeqCEV/YWYIZZhigyrxKlCiTOKqycngm3y6+Dqe7zpRJiRtqq26iDY2nZM/VXj
         jRGa5W72huDFQJUPtvtE656mqeZ9BBuJpCXC0SKZPozz1akAEzSAVEJE6wHgrQcJib0I
         0MFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KtSNFiPVmHNMGf6EfCgApRoebnc5Uef1+tJZX1b5aA8=;
        b=ERa57SxvFB0Hy6/JqtKeoJcY5iooglQ1ytY6V00KfAnAO5aN9HB+19f1mHZIUTViaK
         NFbi3ouzfDerQEBo7vv8owywBlpiNcVVL+rZ2tVEv66jqi6bJRZCBUffsM9YWA2dCg7L
         Cgw7fkivOJvxn7+aceDAZVg+K7xCNuANK0lG6EXlJ3ejxlM0Lavyc6mkdtnd5IhpsdTn
         +BEsO3je8wPnJcct0ClRXmwonXUuekWSv26IzODxvm6nchOCNbcLwbo4k2I93LjtjXUg
         8hkGjAgZfwVXXWsQN9ViQe+iq7TYooWXmlO4Ans8deByQnO1+u3lmDQkcnaLDdc529z8
         wifA==
X-Gm-Message-State: APjAAAXoDwOzTUhlNhuhlPQn+jBWY4ux7Ph9zEArl13izjcViGIUQ7A9
        aqrs4ylvp495/VyzMmK2Z8gAp2MUKY111TJXUnU=
X-Google-Smtp-Source: APXvYqy52+S5rr0NnlEGRsA77YNyOQmNKrtlbAN8NxTIIT8HZ+91Pp6OkSOIRc4QpchzintHUX5ziKABydJCtuPT/iY=
X-Received: by 2002:a1c:be05:: with SMTP id o5mr110753474wmf.52.1564557532038;
 Wed, 31 Jul 2019 00:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-14-anup.patel@wdc.com>
 <abedb067-b91f-8821-9bce-d27f6c4efdee@redhat.com> <7fe9e845c33e49e4c215e12b1ee1b5ed86a95bc1.camel@wdc.com>
 <0be68aeb-06de-71c7-375e-95f82112dae1@redhat.com>
In-Reply-To: <0be68aeb-06de-71c7-375e-95f82112dae1@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 31 Jul 2019 12:48:40 +0530
Message-ID: <CAAhSdy2KoYW0BiuUhZ9BEYH1wmh5xg6zcifF-rHPk5iktBBytQ@mail.gmail.com>
Subject: Re: [RFC PATCH 13/16] RISC-V: KVM: Add timer functionality
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Atish Patra <Atish.Patra@wdc.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "palmer@sifive.com" <palmer@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 31, 2019 at 12:28 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/07/19 03:55, Atish Patra wrote:
> > On Tue, 2019-07-30 at 13:26 +0200, Paolo Bonzini wrote:
> >> On 29/07/19 13:57, Anup Patel wrote:
> >>> +   if (delta_ns > VCPU_TIMER_PROGRAM_THRESHOLD_NS) {
> >>> +           hrtimer_start(&t->hrt, ktime_add_ns(ktime_get(),
> >>> delta_ns),
> >>
> >> I think the guest would prefer if you saved the time before enabling
> >> interrupts on the host, and use that here instead of ktime_get().
> >> Otherwise the timer could be delayed arbitrarily by host interrupts.
> >>
> >> (Because the RISC-V SBI timer is relative only---which is
> >> unfortunate---
> >
> > Just to clarify: RISC-V SBI timer call passes absolute time.
> >
> > https://elixir.bootlin.com/linux/v5.3-rc2/source/drivers/clocksource/timer-riscv.c#L32
> >
> > That's why we compute a delta between absolute time passed via SBI and
> > current time. hrtimer is programmed to trigger only after the delta
> > time from now.
>
> Nevermind, I got lost in all the conversions.
>
> One important issue is the lack of ability to program a delta between
> HS/HU-mode cycles and VS/VU-mode cycles.  Without this, it's impossible
> to do virtual machine migration (except with hcounteren
> trap-and-emulate, which I think we agree is not acceptable).  I found
> the open issue at https://github.com/riscv/riscv-isa-manual/issues/298
> and commented on it.

This Github issue is open since quite some time now.

Thanks for commenting. I have pinged RISC-V spec maintainers as well.

Regards,
Anup
