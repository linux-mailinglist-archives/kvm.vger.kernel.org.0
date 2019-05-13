Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D05F81B270
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 11:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbfEMJMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 05:12:20 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46335 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbfEMJMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 05:12:15 -0400
Received: by mail-ot1-f66.google.com with SMTP id j49so3393906otc.13
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 02:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zNwmz7t6PBFmt5YGiQO+xKffu0RcO5OiBU8nsC1V0bQ=;
        b=bDk+mRKf1bhPVKobiF94W6w0jIYFs2nKILDbLzROMuQflfYxvHldwHhCaWN2iV7XxH
         f/EwqHFJuOdfJribj2X5FHGbCG/FEIaV4rmpf9Qz+K5xS5ZiOEalVC4JC31S2OycN1xq
         B11RH/MfgSZ9JR0q0MZVRBbs2hE7/etR9EtgPqCdD2XDDipDPBhU1n/YXzVD8xRaSCf0
         dzP1dn+qqjLOw0xzjkfZAm12TFIvv0eXdYzpI3BQLoNnagdo8hsQ8ZpoJ2/wqA4nWJzX
         QrdInrJvp1Ysll/+rl3F8FxqbdXICNWj13M/W1lFtuIomFuKirx10x4WCyU7X+/jq3Lc
         3dxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zNwmz7t6PBFmt5YGiQO+xKffu0RcO5OiBU8nsC1V0bQ=;
        b=lw8Vj181BbY3B5ivosvJ0ktZVDLuDzaNK0a3GSi++VvqjU4y1jVIn+HVQlu+LDvaY0
         soSnQUDGppPWPpDa3Sfyvmb4cYbso5UBom0s18lHOEUpOztjqO5I08YeahGkDuJ1bTWe
         K5Q6YYTAfYKNtBSh2x1qX9rhPfQFkShg4bf8pErc20s8MbuWbf0iqWHBL+cl8c1BDkRz
         GLw/hrAnnNRTRkLKDhc9kttlgZJgTDhjV1/mc5wP76SI81yOCOMDs1W935WGO26vT1MQ
         bR4O3IfsLItb775qLF0G0Zr0k8t7cBlHLXbuPcqMDRdOUj8eXrpC5UxzRasAV2Yv54DC
         X7sg==
X-Gm-Message-State: APjAAAWM9Zz+toaR8asY9hRkxJ6n1sjQkeQLdkWW0iRI8fzCEPgGJCNx
        ApFNnf0MF4PwPPmDEmNGrBdXaFvOk1TJTG62gE3uIsD1
X-Google-Smtp-Source: APXvYqwdwJCrvJIP/W9yVSMtFA+NF9tBUYgk2J8U2GT4DSFQbNkT5fpPQSiEF2tZWvMJ3BeIFBkO3PAVwcVeFjJQzso=
X-Received: by 2002:a05:6830:1389:: with SMTP id d9mr13718otq.329.1557738735013;
 Mon, 13 May 2019 02:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190415154526.64709-1-liran.alon@oracle.com> <20190415181702.GH24010@linux.intel.com>
 <AD81166E-0C42-49FD-AC37-E6F385C23B13@oracle.com> <4848D424-F852-4E1C-8A86-6AA1A26D2E90@oracle.com>
 <2dad36e7-a0e5-9670-c902-819c5200466f@oracle.com> <CANRm+CyYkjFaLZMOHP3sMYVjFNo1P7uKbrRr7U3FfRHhG5jVkA@mail.gmail.com>
 <d930e87a-fbe3-cf63-b8a0-26e9f012442a@oracle.com> <20190510171733.GA16852@linux.intel.com>
In-Reply-To: <20190510171733.GA16852@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 13 May 2019 17:13:29 +0800
Message-ID: <CANRm+Cy4GKvNpJN0ORfMGXC=BfPHZ+khKZhJQzeWvFYVmTGVfA@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Nop emulation of MSR_IA32_POWER_CTL
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 11 May 2019 at 01:17, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, May 10, 2019 at 11:34:41AM +0100, Joao Martins wrote:
> > On 5/10/19 10:54 AM, Wanpeng Li wrote:
> > > It is weird that we can observe intel_idle driver in the guest
> > > executes mwait eax=0x20, and the corresponding pCPU enters C3 on HSW
> > > server, however, we can't observe this on SKX/CLX server, it just
> > > enters maximal C1.
> >
> > I assume you refer to the case where you pass the host mwait substates to the
> > guests as is, right? Or are you zeroing/filtering out the mwait cpuid leaf EDX
> > like my patch (attached in the previous message) suggests?
> >
> > Interestingly, hints set to 0x20 actually corresponds to C6 on HSW (based on
> > intel_idle driver). IIUC From the SDM (see Vol 2B, "MWAIT for Power Management"
> > in instruction set reference M-U) the hints register, doesn't necessarily
> > guarantee the specified C-state depicted in the hints will be used. The manual
> > makes it sound like it is tentative, and implementation-specific condition may
> > either ignore it or enter a different one. It appears to be only guaranteed that
> > it won't enter a C-{sub,}state deeper than the one depicted.
>
> Yep, section "MWAIT EXTENSIONS FOR ADVANCED POWER MANAGEMENT" is more
> explicit on this point:
>
>   At CPL=0, system software can specify desired C-state and sub C-state by
>   using the MWAIT hints register (EAX).  Processors will not go to C-state
>   and sub C-state deeper than what is specified by the hint register.
>
> As for why SKX/CLX only enters C1, AFAICT SKX isn't configured to support
> C3, e.g. skx_cstates in drivers/idle/intel_idle.c shows C1, C1E and C6.
> A quick search brings up a variety of docs that confirm this.  My guess is
> that C1E provides better power/performance than C3 for the majority of
> server workloads, e.g. C3 doesn't provide enough power savings to justify
> its higher latency and TLB flush.

You are right, I figure this out by referring to the SKX/CLX EDS, the
Core C-States of these two generations just support CC0/CC1/CC1E/CC6.
The issue here is after exposing mwait to the guest, SKX/CLX guest
can't enter CC6, however, HSW guest can enter CC3/CC6. Both HSW and
SKX/CLX hosts can enter CC6. We observe SKX/CLX guests execute mwait
eax 0x20, however, we can't observe the corresponding pCPU enter CC6
by turbostat or reading MSR_CORE_C6_RESIDENCY directly.

Regards,
Wanpeng Li
