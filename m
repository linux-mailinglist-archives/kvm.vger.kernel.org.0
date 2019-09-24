Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A6BBC3DD
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 10:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504020AbfIXIJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 04:09:06 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:43943 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409379AbfIXIJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 04:09:06 -0400
Received: by mail-yb1-f193.google.com with SMTP id m143so366059ybf.10
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 01:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oytvwTJ/h++ppV0afAZb6O2XZSdvl/Vc69K9QBOB/1I=;
        b=nsB7Q+qjaMYUId+8LsfJGaz0hmV70zOa+b32OgGfRwJiHbfQ/Qh3Wuq1hdAYuLsScy
         GCFwfdqUZj9Twgo/ZDpsOICE2FztUhXDuDGl4Rfqm7QHou3CPGBwjPRhkkAj90y1nVhf
         J6QiHjDnwuRo+2YP44RMBn3wXMrOR1UKgUmMagAz1sIHPfcHm/IepjBNIjJwL6OJHpL1
         LKEiZAeNGqjhQ2c4EvkDWaz6sGUi5oHuyILSJHo/gWd8KP4yCYApb1ZqTucdWowT7BHn
         k2BpmoXk1E3/Fra3cyexYK0s5IqTkN0gD6ZLlGCo7txBa77c0j3OZMPC5V7HQFyZwpoq
         LuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oytvwTJ/h++ppV0afAZb6O2XZSdvl/Vc69K9QBOB/1I=;
        b=MpwAYaCaOztLQwcfkW0G/rWByTygpnBUVj4upCt4Dh0bC2VT3BV6yfo3faEDe+yHvE
         sKHVzYj6vF29uh1ZNMnXVNtnT0C8G2oedPF0AhGXrj64qx8W404IogLcMJWB7Y7aOsxf
         8c4N1FzpFTr5c5rrqmSOaGCpbSR83GUpkToqjtr+etXLaQqZc0GXBrwi8D9tsyJ7aNOB
         loo/i4AuRWRJFQEodjVMo+IR2SsK+z0OHFlZxvI7h1175m/wID6udohjDQTz2jmS/auK
         gIsA/QR6nHaupEp0dM54tYE2oZpLS3Tcs3ypcn72xOFpj0g+uy9JMpu8TPOMMJP5jNEg
         JdRA==
X-Gm-Message-State: APjAAAXSnDLm3XeWbUXp3dovAQ+7AIZtugMrkqi74PdTDcUA3k7eOJ8w
        +OMytIA4UV+DLayzri1cKo6wS4+RIVkNElw87f/blA==
X-Google-Smtp-Source: APXvYqw27y/Qen9avOGLVC1H7Ty4V0crxs6S2bV+PW+p3P+bzFt3FmBWB9gwHx9i22bWEUc/UxHPSbS2ENiDKbUB7eA=
X-Received: by 2002:a25:a421:: with SMTP id f30mr1060469ybi.287.1569312545144;
 Tue, 24 Sep 2019 01:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190920062713.78503-1-suleiman@google.com> <1ec0b238-61a7-8353-026e-3a2ee23e6240@redhat.com>
 <alpine.DEB.2.21.1909201221070.1858@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1909201221070.1858@nanos.tec.linutronix.de>
From:   Suleiman Souhlal <suleiman@google.com>
Date:   Tue, 24 Sep 2019 17:08:53 +0900
Message-ID: <CABCjUKA4gPScr7oTWMpthtH-tz51Z8_cUvm6r779Y-G_qCHo=Q@mail.gmail.com>
Subject: Re: [RFC 0/2] kvm: Use host timekeeping in guest.
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        john.stultz@linaro.org, sboyd@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Tomasz Figa <tfiga@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 20, 2019 at 7:23 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Fri, 20 Sep 2019, Paolo Bonzini wrote:
>
> > On 20/09/19 08:27, Suleiman Souhlal wrote:
> > > To do that, I am changing kvmclock to request to the host to copy
> > > its timekeeping parameters (mult, base, cycle_last, etc), so that
> > > the guest timekeeper can use the same values, so that time can
> > > be synchronized between the guest and the host.
> > >
> > > Any suggestions or feedback would be highly appreciated.
> >
> > I'm not a timekeeping maintainer, but I don't think the
> > kernel/time/timekeeping.c changes are acceptable.
>
> Indeed. #ifdef WHATEVERTHEHECK does not go anywhere. If at all this needs
> to be a runtime switch, but I have yet to understand the whole picture of
> this.

Yeah, I will try to make this a runtime switch.

As for the PTP driver, I don't think it will work for us because we
need CLOCK_MONOTONIC and CLOCK_BOOTTIME to match the host, and from my
understanding, PTP doesn't solve that.

Thanks,
-- Suleiman
