Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1253D59740
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 11:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfF1JSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 05:18:18 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41314 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfF1JSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 05:18:18 -0400
Received: by mail-ot1-f65.google.com with SMTP id o101so4985291ota.8;
        Fri, 28 Jun 2019 02:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wwb05O6HKmp/1+G1ivJzQDQ2IsQa1XZFAR/Po+4k1QA=;
        b=qIXffgO41fk3qz+GkeefZ8FzlqAD3+QBPcDfUGP/gv7zaLd4Bc6lYr+r8q2swc/p1O
         tFUMeUXh9ptGtZedwQcTH5gbD4jDsH1Vrkqt3f1p6WF0hPzrIE5VUOB1jDTN7rRiOECP
         phPkVkzrbtYL2ms0yv8mwz585niK0g2D3ik+RuOetz767alBYAbSJBB3JyBDk9aIiN15
         3pVJmf62/dQ6i5hGglixp5mlQTNEoHdNy+F7aHAcFmAfxDxEs+HPbjn2WXh0Qp+GJHqS
         oDTmHPamP4LtiT3RkX+QVbPJrs9Xc4alCiM9Cpx8BPyDpjJDQJGjsN4j+FATnM3PWv9p
         cAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wwb05O6HKmp/1+G1ivJzQDQ2IsQa1XZFAR/Po+4k1QA=;
        b=GxitmF+AaY1adib4jbPiqHW66HCpXZb3YnVLSwsTtQB+Zt1x27s8hXwRzTmj+eMizt
         b3ezYmY/W5Wm2nCAaDW7+2Gr2vGPtyqxpn8QtsgnvzpLqv4TL7qAcK0SGvz4bHFegsJ+
         /05yzVRRLH+FBMBbfzEpdRGHLXanr718ZHub+XS4SZRr4l699FY/81N3Ajedz4SsOBoj
         flNGpTV90dGMTjrTpBdnycft03vVXN0iAGj1yRoSXlGZjYlhGtRGxZG4ow81GVaPeBOl
         F2nI01fcj8bVpyoJbEqmDamJUxXln/gDhBrFwH6MIfA84AlheqjRmv3cG//dTm+FOAgd
         u8sA==
X-Gm-Message-State: APjAAAVRLaFoqLb7RkoVO1k1JRSmITDDHG4eIu/HOiyZpu1fOOly4/2D
        RNG1Kq14KqhLjG8GUkb0G7L2fsykgDnJ6Jz//YQ=
X-Google-Smtp-Source: APXvYqy0OGiXB+dLsI0Yi0340De/J8CNrgd9i+tIQHNw+GNxFznYrfPBXkEyoQroku6QxDaPa2OloPqCZ6rtHzcIWd0=
X-Received: by 2002:a9d:4590:: with SMTP id x16mr6707074ote.254.1561713497622;
 Fri, 28 Jun 2019 02:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <20190610143420.GA6594@flask> <20190611011100.GB24835@linux.intel.com>
 <CANRm+Cwv5jqxBW=Ss5nkX7kZM3_Y-Ucs66yx5+wN09=W4pUdzA@mail.gmail.com>
 <F136E492-5350-49EE-A856-FBAEDB12FF99@gmail.com> <CANRm+CyZcvuT80ixp9f0FNmjN+rTUtw8MshtBG0Uk4L1B1UjDw@mail.gmail.com>
 <153047ED-75E2-4E70-BC33-C5FF27C08638@gmail.com> <CANRm+Cx6Z=jxLaXqwhBDpVTsKH8mgoo4iC=U8GbAAJz-5gk5ZA@mail.gmail.com>
 <28BF5471-57E8-41FE-B401-D49D57D01A63@gmail.com> <CANRm+CwnShNXmDi7yCZNc=oWrmFO7BTQ-MHxd1f5LRV8+YMJEg@mail.gmail.com>
In-Reply-To: <CANRm+CwnShNXmDi7yCZNc=oWrmFO7BTQ-MHxd1f5LRV8+YMJEg@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 28 Jun 2019 17:18:06 +0800
Message-ID: <CANRm+CyKx4uMkAe7maTg8nwBvkA7SCi2CnSwrghDs1nPuWNg5A@mail.gmail.com>
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

On Fri, 28 Jun 2019 at 17:12, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Wed, 12 Jun 2019 at 09:37, Nadav Amit <nadav.amit@gmail.com> wrote:
> >
> > > On Jun 11, 2019, at 6:18 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
> > >
> > > On Wed, 12 Jun 2019 at 00:57, Nadav Amit <nadav.amit@gmail.com> wrote=
:
> > >>> On Jun 11, 2019, at 3:02 AM, Wanpeng Li <kernellwp@gmail.com> wrote=
:
> > >>>
> > >>> On Tue, 11 Jun 2019 at 09:48, Nadav Amit <nadav.amit@gmail.com> wro=
te:
> > >>>>> On Jun 10, 2019, at 6:45 PM, Wanpeng Li <kernellwp@gmail.com> wro=
te:
> > >>>>>
> > >>>>> On Tue, 11 Jun 2019 at 09:11, Sean Christopherson
> > >>>>> <sean.j.christopherson@intel.com> wrote:
> > >>>>>> On Mon, Jun 10, 2019 at 04:34:20PM +0200, Radim Kr=C4=8Dm=C3=A1=
=C5=99 wrote:
> > >>>>>>> 2019-05-30 09:05+0800, Wanpeng Li:
> > >>>>>>>> The idea is from Xen, when sending a call-function IPI-many to=
 vCPUs,
> > >>>>>>>> yield if any of the IPI target vCPUs was preempted. 17% perfor=
mance
> > >>>>>>>> increasement of ebizzy benchmark can be observed in an over-su=
bscribe
> > >>>>>>>> environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-f=
unction
> > >>>>>>>> IPI-many since call-function is not easy to be trigged by user=
space
> > >>>>>>>> workload).
> > >>>>>>>
> > >>>>>>> Have you checked if we could gain performance by having the yie=
ld as an
> > >>>>>>> extension to our PV IPI call?
> > >>>>>>>
> > >>>>>>> It would allow us to skip the VM entry/exit overhead on the cal=
ler.
> > >>>>>>> (The benefit of that might be negligible and it also poses a
> > >>>>>>> complication when splitting the target mask into several PV IPI
> > >>>>>>> hypercalls.)
> > >>>>>>
> > >>>>>> Tangetially related to splitting PV IPI hypercalls, are there an=
y major
> > >>>>>> hurdles to supporting shorthand?  Not having to generate the mas=
k for
> > >>>>>> ->send_IPI_allbutself and ->kvm_send_ipi_all seems like an easy =
to way
> > >>>>>> shave cycles for affected flows.
> > >>>>>
> > >>>>> Not sure why shorthand is not used for native x2apic mode.
> > >>>>
> > >>>> Why do you say so? native_send_call_func_ipi() checks if allbutsel=
f
> > >>>> shorthand should be used and does so (even though the check can be=
 more
> > >>>> efficient - I=E2=80=99m looking at that code right now=E2=80=A6)
> > >>>
> > >>> Please continue to follow the apic/x2apic driver. Just apic_flat se=
t
> > >>> APIC_DEST_ALLBUT/APIC_DEST_ALLINC to ICR.
> > >>
> > >> Indeed - I was sure by the name that it does it correctly. That=E2=
=80=99s stupid.
> > >>
> > >> I=E2=80=99ll add it to the patch-set I am working on (TLB shootdown =
improvements),
> > >> if you don=E2=80=99t mind.
> > >
> > > Original for hotplug cpu safe.
> > > https://lwn.net/Articles/138365/
> > > https://lwn.net/Articles/138368/
> > > Not sure shortcut native support is acceptable, I will play my
> > > kvm_send_ipi_allbutself and kvm_send_ipi_all. :)
> >
> > Yes, I saw these threads before. But I think the test in
> > native_send_call_func_ipi() should take care of it.
>
> Good news, https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/lo=
g/?h=3DWIP.x86/ipi
> Thomas who also is the hotplug state machine author introduces
> shorthands support to native kernel now, I will add the support to
> kvm_send_ipi_allbutself() and kvm_send_ipi_all() after his work
> complete.

Hmm, should fallback to native shorthands when support.

Regards,
Wanpeng Li
