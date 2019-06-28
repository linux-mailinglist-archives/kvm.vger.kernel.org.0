Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE36596FE
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 11:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfF1JMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 05:12:36 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34691 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfF1JMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 05:12:36 -0400
Received: by mail-oi1-f196.google.com with SMTP id l12so3775631oil.1;
        Fri, 28 Jun 2019 02:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wJy0ShVCPuRJt2ekXMAtR/Y2ur+z0e0mc3qX7mlZ/Ng=;
        b=EaPzFbKnQkZ1Wu1UqvnLqRHXla+DOPY+BVh3mY4rVjnB8Y1ezRLVEjKTyv/HzP4AAt
         T2Czb32Y+aDvaYaSGnq5Pix+NTsBiTZTV4IKqPFUc6Fn+JlxWpeUqZHQ25Qx62ZjenwU
         X1e3jt8FPYeyhBITx8rTwSENMm91a0uvSGhHH9d2H4BOg7xZ/x7r6HgW7auT/TIhs1Gj
         Ws2tWStY0xQ1QFNkyXiZ4YxHgDGRM2h2sHhkqs1M1htop1FPC5b+lPYfNBGScHH2MWCG
         mrKCVGm539ufiBygOapBmmETx9nk43bQiriCjf0p7smFXcwiYDDvUadlt1NdUCPVDvu3
         krbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wJy0ShVCPuRJt2ekXMAtR/Y2ur+z0e0mc3qX7mlZ/Ng=;
        b=c7n8ZlFuKlwxw2UiqbsUdDDvqTdvXPAVa49Hy9WRAgSO5z48ODhWHM1TnHnMZspe1I
         0dTMudmS+OnW4gMEvKXoedQaizmwpuxmxdkYajM9DOy/+JpdiAlKaiFSQAvfsbEqzQ+J
         d4Cf8ismP/6Obw8UyFRn/YX4Jwp5Xj9Ely4OhnOvP4zUaTqeQRZvl4t4r+X2EftaGjqp
         exqcGvDg43EQVj8MRElw6bstYtFRC+VUy8rtzhTCHeihExfVmceHCPR6jgcjmfXe99Y7
         jEw6URT/aW0qqb/kYFhK3F4sLnfU5zUunVd3+n0YuiveD1X1O5WcH/af4dHClGsUjeYA
         71Vg==
X-Gm-Message-State: APjAAAWje39nSW3THDxyhbrwaBx2y5qV8JkZqnVYyeTGXONPhY7EcfEa
        65q+cxX0u9LXBPDuOdcYXwIrMM7gu4WNuAePtxM=
X-Google-Smtp-Source: APXvYqzXAEzxbJ/ThObRmHO6WgbC4Wu5Ba1vNRMnK+ZZPW8aqljOvjyTdBvddhB7GSOu8EE+wEJpwXV8nc94Ce12rS4=
X-Received: by 2002:aca:51ce:: with SMTP id f197mr1088398oib.33.1561713155301;
 Fri, 28 Jun 2019 02:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <20190610143420.GA6594@flask> <20190611011100.GB24835@linux.intel.com>
 <CANRm+Cwv5jqxBW=Ss5nkX7kZM3_Y-Ucs66yx5+wN09=W4pUdzA@mail.gmail.com>
 <F136E492-5350-49EE-A856-FBAEDB12FF99@gmail.com> <CANRm+CyZcvuT80ixp9f0FNmjN+rTUtw8MshtBG0Uk4L1B1UjDw@mail.gmail.com>
 <153047ED-75E2-4E70-BC33-C5FF27C08638@gmail.com> <CANRm+Cx6Z=jxLaXqwhBDpVTsKH8mgoo4iC=U8GbAAJz-5gk5ZA@mail.gmail.com>
 <28BF5471-57E8-41FE-B401-D49D57D01A63@gmail.com>
In-Reply-To: <28BF5471-57E8-41FE-B401-D49D57D01A63@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 28 Jun 2019 17:12:23 +0800
Message-ID: <CANRm+CwnShNXmDi7yCZNc=oWrmFO7BTQ-MHxd1f5LRV8+YMJEg@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: Yield to IPI target if necessary
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jun 2019 at 09:37, Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Jun 11, 2019, at 6:18 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > On Wed, 12 Jun 2019 at 00:57, Nadav Amit <nadav.amit@gmail.com> wrote:
> >>> On Jun 11, 2019, at 3:02 AM, Wanpeng Li <kernellwp@gmail.com> wrote:
> >>>
> >>> On Tue, 11 Jun 2019 at 09:48, Nadav Amit <nadav.amit@gmail.com> wrote=
:
> >>>>> On Jun 10, 2019, at 6:45 PM, Wanpeng Li <kernellwp@gmail.com> wrote=
:
> >>>>>
> >>>>> On Tue, 11 Jun 2019 at 09:11, Sean Christopherson
> >>>>> <sean.j.christopherson@intel.com> wrote:
> >>>>>> On Mon, Jun 10, 2019 at 04:34:20PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=
=99 wrote:
> >>>>>>> 2019-05-30 09:05+0800, Wanpeng Li:
> >>>>>>>> The idea is from Xen, when sending a call-function IPI-many to v=
CPUs,
> >>>>>>>> yield if any of the IPI target vCPUs was preempted. 17% performa=
nce
> >>>>>>>> increasement of ebizzy benchmark can be observed in an over-subs=
cribe
> >>>>>>>> environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-fun=
ction
> >>>>>>>> IPI-many since call-function is not easy to be trigged by usersp=
ace
> >>>>>>>> workload).
> >>>>>>>
> >>>>>>> Have you checked if we could gain performance by having the yield=
 as an
> >>>>>>> extension to our PV IPI call?
> >>>>>>>
> >>>>>>> It would allow us to skip the VM entry/exit overhead on the calle=
r.
> >>>>>>> (The benefit of that might be negligible and it also poses a
> >>>>>>> complication when splitting the target mask into several PV IPI
> >>>>>>> hypercalls.)
> >>>>>>
> >>>>>> Tangetially related to splitting PV IPI hypercalls, are there any =
major
> >>>>>> hurdles to supporting shorthand?  Not having to generate the mask =
for
> >>>>>> ->send_IPI_allbutself and ->kvm_send_ipi_all seems like an easy to=
 way
> >>>>>> shave cycles for affected flows.
> >>>>>
> >>>>> Not sure why shorthand is not used for native x2apic mode.
> >>>>
> >>>> Why do you say so? native_send_call_func_ipi() checks if allbutself
> >>>> shorthand should be used and does so (even though the check can be m=
ore
> >>>> efficient - I=E2=80=99m looking at that code right now=E2=80=A6)
> >>>
> >>> Please continue to follow the apic/x2apic driver. Just apic_flat set
> >>> APIC_DEST_ALLBUT/APIC_DEST_ALLINC to ICR.
> >>
> >> Indeed - I was sure by the name that it does it correctly. That=E2=80=
=99s stupid.
> >>
> >> I=E2=80=99ll add it to the patch-set I am working on (TLB shootdown im=
provements),
> >> if you don=E2=80=99t mind.
> >
> > Original for hotplug cpu safe.
> > https://lwn.net/Articles/138365/
> > https://lwn.net/Articles/138368/
> > Not sure shortcut native support is acceptable, I will play my
> > kvm_send_ipi_allbutself and kvm_send_ipi_all. :)
>
> Yes, I saw these threads before. But I think the test in
> native_send_call_func_ipi() should take care of it.

Good news, https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/=
?h=3DWIP.x86/ipi
Thomas who also is the hotplug state machine author introduces
shorthands support to native kernel now, I will add the support to
kvm_send_ipi_allbutself() and kvm_send_ipi_all() after his work
complete.

Regards,
Wanpeng Li
