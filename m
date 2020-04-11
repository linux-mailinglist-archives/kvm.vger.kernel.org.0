Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA751A4DBC
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 06:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgDKEKJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 11 Apr 2020 00:10:09 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3430 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725855AbgDKEKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Apr 2020 00:10:09 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id BA23A3A4DAD75E537C19;
        Sat, 11 Apr 2020 12:10:07 +0800 (CST)
Received: from DGGEMM526-MBX.china.huawei.com ([169.254.8.54]) by
 DGGEMM404-HUB.china.huawei.com ([10.3.20.212]) with mapi id 14.03.0487.000;
 Sat, 11 Apr 2020 12:10:05 +0800
From:   "Zengtao (B)" <prime.zeng@hisilicon.com>
To:     Marc Zyngier <maz@kernel.org>,
        George Cherian <gcherian@marvell.com>
CC:     "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "jintack@cs.columbia.edu" <jintack@cs.columbia.edu>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        Anil Kumar Reddy H <areddy3@marvell.com>,
        Ganapatrao Kulkarni <gkulkarni@marvell.com>
Subject: RE: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Topic: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Index: AdYJhvrCKEKaxySRQua1lfr4U9NN2v//iESA//MqKcA=
Date:   Sat, 11 Apr 2020 04:10:05 +0000
Message-ID: <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
 <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
In-Reply-To: <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.221.187]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc:

Since it's a very large patch series, I want to test it on my platform
 which don't support nv, and want to make sure if this patch series
affects the existed virtualization functions or not.
 
Any suggestion about the test focus?

Thanks.
> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org]
> On Behalf Of Marc Zyngier
> Sent: Friday, April 03, 2020 4:02 PM
> To: George Cherian
> Cc: Dave.Martin@arm.com; alexandru.elisei@arm.com;
> andre.przywara@arm.com; christoffer.dall@arm.com;
> james.morse@arm.com; jintack@cs.columbia.edu;
> julien.thierry.kdev@gmail.com; kvm@vger.kernel.org;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org;
> suzuki.poulose@arm.com; Anil Kumar Reddy H; Ganapatrao Kulkarni
> Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
> Virtualization support
> 
> Hi George,
> 
> On 2020-04-03 08:27, George Cherian wrote:
> > Hi Marc,
> >
> > On 2/11/20 9:48 AM, Marc Zyngier wrote:
> >> This is a major rework of the NV series that I posted over 6 months
> >> ago[1], and a lot has changed since then:
> >>
> >> - Early ARMv8.4-NV support
> >> - ARMv8.4-TTL support in host and guest
> >> - ARMv8.5-GTG support in host and guest
> >> - Lots of comments addressed after the review
> >> - Rebased on v5.6-rc1
> >> - Way too many patches
> >>
> >> In my defence, the whole of the NV code is still smaller that the
> >> 32bit KVM/arm code I'm about to remove, so I feel less bad inflicting
> >> this on everyone! ;-)
> >>
> >> >From a functionality perspective, you can expect a L2 guest to work,
> >> but don't even think of L3, as we only partially emulate the
> >> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug,
> PMU,
> >> as well as anything that would require a Stage-1 PTW. What we want
> to
> >> achieve is that with NV disabled, there is no performance overhead
> and
> >> no regression.
> >>
> >> The series is roughly divided in 5 parts: exception handling, memory
> >> virtualization, interrupts and timers for ARMv8.3, followed by the
> >> ARMv8.4 support. There are of course some dependencies, but you'll
> >> hopefully get the gist of it.
> >>
> >> For the most courageous of you, I've put out a branch[2]. Of course,
> >> you'll need some userspace. Andre maintains a hacked version of
> >> kvmtool[3] that takes a --nested option, allowing the guest to be
> >> started at EL2. You can run the whole stack in the Foundation
> >> model. Don't be in a hurry ;-).
> >>
> > The full series was tested on both Foundation model as well as Marvell
> > ThunderX3
> > Emulation Platform.
> > Basic boot testing done for Guest Hypervisor and Guest Guest.
> >
> > Tested-by:  George Cherian <george.cherian@marvell.com>
> 
> Thanks for having given this a go.
> 
> However, without more details, it is pretty hard to find out what you
> have tested.
> What sort of guest have you booted, with what configuration, what
> workloads did you
> run in the L2 guests and what are the architectural features that TX3
> implements?
> 
> The last point is specially important, as the NV architecture spans two
> major
> revisions of the architecture and affects tons of other extensions that
> are
> themselves optional. Without any detail on that front, I have no idea
> what the
> coverage of your testing is.
> 
> Thanks,
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
