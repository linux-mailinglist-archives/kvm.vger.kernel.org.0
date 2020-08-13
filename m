Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943FE2435A2
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 10:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgHMH77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 03:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgHMH75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 03:59:57 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D9FC061757
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 00:59:57 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id h3so4263716oie.11
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 00:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jr4AU44j3EXoVbjVMVeR84ycnPLdAyZ0FI1cmuvPkn0=;
        b=sqveO6hSX3DrdVOYzAHZAkjMwnWFyleTyrupuDTAdkZ6RN/IG0V2SR8bkTiULjgahn
         xh05hOXZb3SdbXKaZ8fl+o7UoG+KX/8gH9j4zgyAolv8U4rACJovn9O26Bc4oLwjhBgZ
         vk8eDWB9yAi4rFI9yQ/CxM89+Go3wKSSZ/xlHMW+0SV+VlHNwBD/3g4pQ9o6IKSSOcOm
         BrjpjPYXfHLr5WFcD9WWVbC4D/C0c8SQJIWsS73Zod1wBGFVPhZ/t8Mie+uTogWxIK7Y
         md03JEBpClsDkN/BdZqPcUvLI5JWOjnfy97CCK4VsuzDKCzFUzDcnSxjSXbpXcG/md0+
         1m9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jr4AU44j3EXoVbjVMVeR84ycnPLdAyZ0FI1cmuvPkn0=;
        b=h70sbmq5TrWeUR3niWbojfLYUW9lQstwOKprn5Am3rdVsk+naBzOqQz/5pRWO7P9zE
         E0jARHLtFqKqft/TYW2tUre6ST4qZFulcSEMr7BJqGVT4gQf6NEO8cNDU9leISO4Wevo
         w+Qd0SWg8Qg3mg55RVXfsVvFL6tTMEkeNkt+wWWA81euUVQqYNcRVAIC92haxtEpchVo
         WkZPIwm9cR8pT5JAD1LJtbMg191nIMy6ww+/Mv9ATDyR6eJh3a1SqKMZnhclcwVnCkgn
         k9mT72khcaudy/d/TxYKK6BrX6wDWpFvMaKOJMsfY2I0TjU6ijEQ8h+Xs92ygC+LT4dB
         DF/w==
X-Gm-Message-State: AOAM531afWuFRr6J8XjkbaLJjL/A6mcOzurDA4oqZG4Dp60XPz+K8i/U
        TjBk7KDMTB7KqmbooQMGqd5ML0jutFrO1jdFJSk=
X-Google-Smtp-Source: ABdhPJwvE8oLvET/rZuOyTyq5WYgxt6BC+fb3bBsoyJ8pyKBLQBnrX/lx0ZB7ts7iMM8DTk3wNjRpgtv06yyPzCtJ4Y=
X-Received: by 2002:aca:4f52:: with SMTP id d79mr2290610oib.141.1597305596991;
 Thu, 13 Aug 2020 00:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <CANRm+Cx597FNRUCyVz1D=B6Vs2GX3Sw57X7Muk+yMpi_hb+v1w@mail.gmail.com>
 <95c26b17-66c6-0050-053b-faa4d63a2347@redhat.com>
In-Reply-To: <95c26b17-66c6-0050-053b-faa4d63a2347@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 13 Aug 2020 15:59:46 +0800
Message-ID: <CANRm+CweXKPDv0KQOxPA5GQuc0-8FOPKH2dABeUra8AgMWK9yw@mail.gmail.com>
Subject: Re: IPI broadcast latency in the guest is worse when AVIC is enabled
To:     Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Wei Huang <wei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suravee, any inputs?
On Tue, 11 Aug 2020 at 16:29, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/08/20 04:04, Wanpeng Li wrote:
> > We found that the IPI broadcast latency in the guest when AVIC=1,
> > exposing xapic is worse than when AVIC=0, exposing xapic. The host is
> > AMD ROME, 2 sockets, 96 cores, 192 threads, the VM is 180 vCPUs. The
> > guest boots with kvm-hint-dedicated=on, --overcommit cpu-pm=on, -smp
> > 180,sockets=2,cores=45,threads=2, l3-cache=on qemu command-line, the
> > pCPU which vCPU is running on is isolated. Both the guest and host
> > kernel are 5.8 Linus' tree. (Note, if you fails to boot with
> > --overcommit cpu-pm=on, you can comments out commit e72436bc3a52, I
> > have a report here, https://lkml.org/lkml/2020/7/8/308)
> >
> > IPI microbenchmark(https://lkml.org/lkml/2017/12/19/141, Destination
> > Shorthand is All excluding self)
> >
> > avic0_xapic:   12313907508.50 ns
> > avic1_xapic:   19106424733.30 ns
> > avic0_x2apic: 13073988486.00 ns
>
> I think it depends on the microarchitecture implementation of AVIC?
>
> Paolo
>
