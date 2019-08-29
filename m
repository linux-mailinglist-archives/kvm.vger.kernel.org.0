Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7F7A19CF
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfH2MQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 08:16:09 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39488 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfH2MQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 08:16:09 -0400
Received: by mail-oi1-f196.google.com with SMTP id 16so2339542oiq.6;
        Thu, 29 Aug 2019 05:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZJ52Xwnuz86LA+OndXIVKURqQP4L9RyMWjskSBWJHfk=;
        b=QrFj1YIF09DrXwvt39jlEC1w2Frhv2LdhQUAWc60IHe4VMj5bieyIaP365ob6DgLtp
         3DtgykIGgmh7DD0JhhmkeSsOlZKewX5DRq9rrgHmmCmicxGieAr2Hq46INW1O1uCNMm9
         09xQ/6zLKIRpRD/8NrHHDW/GH2RoMQ3lhrzlT4EHsSTsqCq8KMWwPS665zb+bjdsp0Nr
         UdNckSqBFGoycBaCeYfbhQBei52da8py9Xxm65qJGYo7QM2Kv4GZ6YTis/BQN1htKDFa
         osjx/O7xc6RTquVh9ShigWMmQhqfnYt9Z/bDm7rLbUBoASnaKG/b05PbafSqLHc+Gdcf
         xGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZJ52Xwnuz86LA+OndXIVKURqQP4L9RyMWjskSBWJHfk=;
        b=OHKLEcI1dwHXzLwGy809q7Q8DV+eWoowQ31upYbOv4tUmHlBm7j8OUy1TsCs3TlT4q
         iejA9lZZd7wlk3oKpLny6H4rGsprn9CMuJP8CF6J20/M3frMGcLrahsl2Z2Qrn/MmYfB
         1m0cl6jkOJliaQxsoiEbwg5IIuPoCZKLLmiL3JS3mTUeZk5h2R3liROA3/3qFX+5GRbO
         d7tSINMhZSCqzWUfvz0fUGr/ZeH7If2nWK9fkbpIdGlnoesV651DhxohSz9mN547gWJ8
         dq56Sr/Fen/zsXIhLTspHjAIbM9TwrTyOTA1MGJXrvNfutLQkfS0rB6ASPuQ6baVGv8D
         y6WQ==
X-Gm-Message-State: APjAAAXTGj+8HfPPrZ+oKFZpcH5xd+2wgJOQNDbk1vIWUKH2yF8u2G8e
        SfvngBiYmrxjN1qx7uVXojJacYm1NiQ+74/WQQA=
X-Google-Smtp-Source: APXvYqyCRNfos6DQxO12QxxXYeJRgZJKDcoFbYZ2ozhLfSA0XcHv9fgr+95Faw7ADONtBP2NBanXzk/LFdxwX/wkHQU=
X-Received: by 2002:a54:488e:: with SMTP id r14mr6328224oic.174.1567080967669;
 Thu, 29 Aug 2019 05:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com>
 <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com> <20190803202058.GA9316@amt.cnet>
 <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
 <20190826204045.GA24697@amt.cnet> <CANRm+Cx0+V67Ek7FhSs61ZqZL3MgV88Wdy17Q6UA369RH7=dgQ@mail.gmail.com>
 <CANRm+CxqYMzgvxYyhZLmEzYd6SLTyHdRzKVaSiHO-4SV+OwZUQ@mail.gmail.com>
 <CAJZ5v0iQc0-WzqeyAh-6m5O-BLraRMj+Z7sqvRgGwh2u2Hp7cg@mail.gmail.com>
 <20190828143916.GA13725@amt.cnet> <CAJZ5v0jiBprGrwLAhmLbZKpKUvmKwG9w4_R7+dQVqswptis5Qg@mail.gmail.com>
 <20190829120422.GC4949@amt.cnet>
In-Reply-To: <20190829120422.GC4949@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 29 Aug 2019 20:16:41 +0800
Message-ID: <CANRm+CwYq7NZeKffioWcHy_oWGyeHqXsygF_cppMD17mHuVgYw@mail.gmail.com>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when dedicated
 physical CPUs are available
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Aug 2019 at 20:04, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Thu, Aug 29, 2019 at 01:37:35AM +0200, Rafael J. Wysocki wrote:
> > On Wed, Aug 28, 2019 at 4:39 PM Marcelo Tosatti <mtosatti@redhat.com> w=
rote:
> > >
> > > On Wed, Aug 28, 2019 at 10:45:44AM +0200, Rafael J. Wysocki wrote:
> > > > On Wed, Aug 28, 2019 at 10:34 AM Wanpeng Li <kernellwp@gmail.com> w=
rote:
> > > > >
> > > > > On Tue, 27 Aug 2019 at 08:43, Wanpeng Li <kernellwp@gmail.com> wr=
ote:
> > > > > >
> > > > > > Cc Michael S. Tsirkin,
> > > > > > On Tue, 27 Aug 2019 at 04:42, Marcelo Tosatti <mtosatti@redhat.=
com> wrote:
> > > > > > >
> > > > > > > On Tue, Aug 13, 2019 at 08:55:29AM +0800, Wanpeng Li wrote:
> > > > > > > > On Sun, 4 Aug 2019 at 04:21, Marcelo Tosatti <mtosatti@redh=
at.com> wrote:
> > > > > > > > >
> > > > > > > > > On Thu, Aug 01, 2019 at 06:54:49PM +0200, Paolo Bonzini w=
rote:
> > > > > > > > > > On 01/08/19 18:51, Rafael J. Wysocki wrote:
> > > > > > > > > > > On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> > > > > > > > > > >> From: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > > > > >>
> > > > > > > > > > >> The downside of guest side polling is that polling i=
s performed even
> > > > > > > > > > >> with other runnable tasks in the host. However, even=
 if poll in kvm
> > > > > > > > > > >> can aware whether or not other runnable tasks in the=
 same pCPU, it
> > > > > > > > > > >> can still incur extra overhead in over-subscribe sce=
nario. Now we can
> > > > > > > > > > >> just enable guest polling when dedicated pCPUs are a=
vailable.
> > > > > > > > > > >>
> > > > > > > > > > >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > > > > > >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > > > > > >> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > > > > > > > > >> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > > > > > > >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > > > > >
> > > > > > > > > > > Paolo, Marcelo, any comments?
> > > > > > > > > >
> > > > > > > > > > Yes, it's a good idea.
> > > > > > > > > >
> > > > > > > > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > >
> > > > > Hi Marcelo,
> > > > >
> > > > > If you don't have more concern, I guess Rafael can apply this pat=
ch
> > > > > now since the merge window is not too far.
> > > >
> > > > I will likely queue it up later today and it will go to linux-next
> > > > early next week.
> > > >
> > > > Thanks!
> > >
> > > NACK patch.
> >
> > I got an ACK from Paolo on it, though.  Convince Paolo to withdraw his
> > ACK if you want it to not be applied.
> >
> > > Just don't load the haltpoll driver.
> >
> > And why would that be better?
>
> Split the group of all kvm users in two: overcommit group and non-overcom=
mit
> group.
>
> Current situation regarding haltpoll driver is:
>
> overcommit group: haltpoll driver is not loaded by default, they are
> happy.
>
> non overcommit group: boots without "realtime hints" flag, loads haltpoll=
 driver,
> happy.
>
> Situation with patch above:
>
> overcommit group: haltpoll driver is not loaded by default, they are
> happy.
>
> non overcommit group: boots without "realtime hints" flag, haltpoll drive=
r
> cannot be loaded.

non overcommit group, if they don't care latency/performance, they
don't need to enable haltpoll, "realtime hints" etc. Otherwise, they
should better tune.

Regards,
Wanpeng Li
