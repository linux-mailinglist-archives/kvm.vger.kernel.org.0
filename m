Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7ABD62DDA
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 04:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfGICGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 22:06:23 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]:42359 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGICGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 22:06:23 -0400
Received: by mail-ot1-f46.google.com with SMTP id l15so18274513otn.9;
        Mon, 08 Jul 2019 19:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eYj1Urt4ysIwReYjMONvvY2aZqx7qW5Uw8WC3wX0qTM=;
        b=Kfr1/PGaDTHZN+rc71J4dPZNBWAv4j4riuKHstTdGOUsVcFydKW0hO0SoalCguALTJ
         d1cMyr9glOWx3Ol2ooCuBlqbk3DkWf86IdkZcOkMDiJPPT13HKh0I7Syx1E30SeSxT7g
         J4v03dIzz/P8o9pOJOe5bUjRdpnPGcWC9Mga+h/6L/iiVL60ci1KZbBfwEF571y5+IOi
         Y+RggHRAdUk1Y5uYJ//1b0SRgAkZKVUcI3mjVrqWqO0TInjS+wY252phx6ZyJH09U4r2
         jWP96H7vtBlFcV3uXTJ/fotr2Gkqsnv2jACBEMrr931A0hK34o1/Vt0jAUTlTA7fIoXC
         LtyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eYj1Urt4ysIwReYjMONvvY2aZqx7qW5Uw8WC3wX0qTM=;
        b=XvIqI7ufGlV7s6hnpBrG4M8v5zFrX7EmVq8T/IgtMrLEInar+0Rgh/W2kiS59JPU89
         ejUE7HD3X7vai5e5+csN3nMlYMKwy65LOSgS9BfP4QD38eZJ/n0ZFbU2sBdkc88ri4ua
         IlSJUfv3OEWOde+L+XCq4ezy7MtBxEv535jaGms5xyClYPzP9k1TRoLanN6fHhKQYPn0
         vM/+3IGzh0eQ9akhNH1W27HDz4MgOYrU9AmeMyyhWpkIMRWBMQT8V6L7ptwj0ze3ynun
         76R7RwrGvVLqIMdzzNi8u8jVQGqNah5DWaGP/yA2xyJ+7koOoBPXNWTKhf60HAngnV0Y
         Vffg==
X-Gm-Message-State: APjAAAUDGjte5a4ybB4rI9wZ75zNIuBmrhLjhpa724AAJfZVnI+5Szeo
        HaGNr1igDG6+F/6xlZEMev7Cq/rx1aENFI/QrCI=
X-Google-Smtp-Source: APXvYqwZZGXm4qZQ5vlJLgNOFcE9Od7u3DJSijuuWu8K/Rkg/4jLqywIFFvortUDZfDdG6JgF5cm/7G/iQCxw1EIPng=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr2358135otk.56.1562637982324;
 Mon, 08 Jul 2019 19:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
 <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
 <20190626145413.GE6753@char.us.oracle.com> <1561575536.25880.10.camel@amazon.de>
 <alpine.DEB.2.21.1906262119430.32342@nanos.tec.linutronix.de> <7f721d94-aa19-20a4-6930-9ed4d1cd4834@oracle.com>
In-Reply-To: <7f721d94-aa19-20a4-6930-9ed4d1cd4834@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 9 Jul 2019 10:06:09 +0800
Message-ID: <CANRm+CyCwz7V3fvx48FXiSXkDer1B6bMGwzvoA9vgccxK6gqZw@mail.gmail.com>
Subject: Re: cputime takes cstate into consideration
To:     Ankur Arora <ankur.a.arora@oracle.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

also Cc Frederic,
On Tue, 9 Jul 2019 at 10:00, Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
> On 2019-06-26 12:23 p.m., Thomas Gleixner wrote:
> > On Wed, 26 Jun 2019, Raslan, KarimAllah wrote:
> >> On Wed, 2019-06-26 at 10:54 -0400, Konrad Rzeszutek Wilk wrote:
> >>> There were some ideas that Ankur (CC-ed) mentioned to me of using the perf
> >>> counters (in the host) to sample the guest and construct a better
> >>> accounting idea of what the guest does. That way the dashboard
> >>> from the host would not show 100% CPU utilization.
> >>
> >> You can either use the UNHALTED cycles perf-counter or you can use MPERF/APERF
> >> MSRs for that. (sorry I got distracted and forgot to send the patch)
> >
> > Sure, but then you conflict with the other people who fight tooth and nail
> > over every single performance counter.
> How about using Intel PT PwrEvt extensions? This should allow us to
> precisely track idle residency via just MWAIT and TSC packets. Should
> be pretty cheap too. It's post Cascade Lake though.
>
> Ankur
>
> >
> > Thanks,
> >
> >       tglx
> >
>
