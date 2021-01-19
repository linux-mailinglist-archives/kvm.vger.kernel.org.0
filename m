Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA2F2FAE54
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 02:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392140AbhASB2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 20:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731837AbhASB2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 20:28:17 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFB2C061574;
        Mon, 18 Jan 2021 17:27:36 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id y14so4530221oom.10;
        Mon, 18 Jan 2021 17:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZU9lb0gFwAiVxebjP8MY9Tj0+cnu+M7cp3y/G+AYdA=;
        b=Pgb3CRFFIZw0s2KoQaFK+XlRDx4+qu6UGDflszF1+a0NXL14M5X+dthe2n9dsTbKmz
         oPpG+71PvnbCzbqaUjlMj5bERh7BWnpWAPBkoIN1kFEJRKhpC4MEKsjRfFL45FIno+5m
         6dZlB1KBmrqvkNcJpG3Xbjth+mPoYSGHlIkuVptQ8unQ4/HNU2bfgBK7jA+Zzd/BjGud
         mGmHPrVzKHqD3OY2mxbSqUumcVAlLOkE6xOgvZ8tPD4RQPpvUkX+rNHWzXaGRBBY231G
         Zy6+KNXsaEj5eCSp6UI9BdJP8vWPnOzo0bIqEfiTxa2NzvGZouEdFAX+IZpptxtoLt4R
         qWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZU9lb0gFwAiVxebjP8MY9Tj0+cnu+M7cp3y/G+AYdA=;
        b=ZgKBeVJgt3REavH4Cjz2ooZv+ucrdr3hev/wUVQSIFtym990aC0CdOqIL5o96tTvJL
         5W2ZxF1yKxVkTgIQAcCo3XdJtI5QZisRKBq2cO62XaLNjGrFQPZoCaCuWKxYDsYFoxmX
         h6JQQkNga51AQVX1jnUi1+NYKp1kBD0SLX1mWa8iYM+0hCbB19Z3FHvQzUJR09qArTBI
         etrZysEAFPGB/KFRtEM2P+WIo2enA5KDHPK37iXKMTkHFJFFIB5ykAqvu1QTRJHIbEkg
         QpdPEWVLK9zvNtRir9HNQkH8ub5IHjoB67kJRmelMMnuqxu/z33FzAuZisN+U6Tri95x
         SIHg==
X-Gm-Message-State: AOAM531qP8A3IDOstgLeOQxmh6dkfBxk93tvvMXNslCrc7lVL1GU1BXM
        eqjj6Bp5zYApLDaZo+lEDdRkjxL3Kbxmvgzm8VQ=
X-Google-Smtp-Source: ABdhPJyBQqesydIzsVse3Ol3uz2LTkTj1R2bgjIV3Lg88TwudoTK2p193rtSKqMbNpn9cuNm8iBitVo++Zcv9++uFPM=
X-Received: by 2002:a05:6820:41:: with SMTP id v1mr1227340oob.41.1611019644070;
 Mon, 18 Jan 2021 17:27:24 -0800 (PST)
MIME-Version: 1.0
References: <20210105192844.296277-1-nitesh@redhat.com> <X/UIh1PqmSLNg8vM@google.com>
 <CANRm+Cz1nHkLm=hg-JN3j-s-w1_c0zWm=EYLJ7hzPW-2k_a2Gw@mail.gmail.com>
In-Reply-To: <CANRm+Cz1nHkLm=hg-JN3j-s-w1_c0zWm=EYLJ7hzPW-2k_a2Gw@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 19 Jan 2021 09:27:13 +0800
Message-ID: <CANRm+CwCqnNWr3KELG=6DLkOdWMnMP3uuyyROgXpZrPyo2A+bA@mail.gmail.com>
Subject: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest context"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        w90p710@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Jan 2021 at 11:20, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Wed, 6 Jan 2021 at 08:51, Sean Christopherson <seanjc@google.com> wrote:
> >
> > +tglx
> >
> > On Tue, Jan 05, 2021, Nitesh Narayan Lal wrote:
> > > This reverts commit d7a08882a0a4b4e176691331ee3f492996579534.
> > >
> > > After the introduction of the patch:
> > >
> > >       87fa7f3e9: x86/kvm: Move context tracking where it belongs
> > >
> > > since we have moved guest_exit_irqoff closer to the VM-Exit, explicit
> > > enabling of irqs to process pending interrupts should not be required
> > > within vcpu_enter_guest anymore.
> >
> > Ugh, except that commit completely broke tick-based accounting, on both Intel
> > and AMD.  With guest_exit_irqoff() being called immediately after VM-Exit, any
> > tick that happens after IRQs are disabled will be accounted to the host.  E.g.
> > on Intel, even an IRQ VM-Exit that has already been acked by the CPU isn't
> > processed until kvm_x86_ops.handle_exit_irqoff(), well after PF_VCPU has been
> > cleared.
> >
>
> This issue can be 100% reproduced.
> https://bugzilla.kernel.org/show_bug.cgi?id=204177

Sorry, the posted link should be
https://bugzilla.kernel.org/show_bug.cgi?id=209831

    Wanpeng
