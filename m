Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD6619D44C
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 11:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390680AbgDCJtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 05:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727912AbgDCJtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 05:49:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2143120721;
        Fri,  3 Apr 2020 09:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585907363;
        bh=j1rkDLXbFQAE/NXmh6XeWqF89l3i4DAQuEfAW/sV8Ow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JUwLEjAP/pm4XrUlhIYrO7dX/3zyEWWkp4gYZaa13i9Z9Ypw/WSesM3RnSwO2RddZ
         HSE5qcPuGNBdWOnbNJ5VCBtYorLve5luyRh+VOuMs0MuBo1MOXf0BtKq1O3JKP1ubd
         SbbBLDWhdUDMDS+EBoU/560XkGUZhe1Tz/oqVgOE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jKIwz-000Sgj-BG; Fri, 03 Apr 2020 10:49:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 03 Apr 2020 10:49:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     George Cherian <gcherian@marvell.com>
Cc:     Dave.Martin@arm.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com, christoffer.dall@arm.com,
        james.morse@arm.com, jintack@cs.columbia.edu,
        julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        suzuki.poulose@arm.com, Anil Kumar Reddy H <areddy3@marvell.com>,
        Ganapatrao Kulkarni <gkulkarni@marvell.com>
Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
In-Reply-To: <MN2PR18MB2686F84659A6A994ECDF8031C5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
References: <MN2PR18MB2686F84659A6A994ECDF8031C5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
Message-ID: <780021a37fbd0185f848566b894feb97@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gcherian@marvell.com, Dave.Martin@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, christoffer.dall@arm.com, james.morse@arm.com, jintack@cs.columbia.edu, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com, areddy3@marvell.com, gkulkarni@marvell.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-03 10:36, George Cherian wrote:
>> -----Original Message-----
>> From: Marc Zyngier <maz@kernel.org>
>> Sent: Friday, April 3, 2020 1:32 PM
>> To: George Cherian <gcherian@marvell.com>
>> Cc: Dave.Martin@arm.com; alexandru.elisei@arm.com;
>> andre.przywara@arm.com; christoffer.dall@arm.com;
>> james.morse@arm.com; jintack@cs.columbia.edu;
>> julien.thierry.kdev@gmail.com; kvm@vger.kernel.org;
>> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org;
>> suzuki.poulose@arm.com; Anil Kumar Reddy H <areddy3@marvell.com>;
>> Ganapatrao Kulkarni <gkulkarni@marvell.com>
>> Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
>> Virtualization support
>> 
>> 
>> ----------------------------------------------------------------------
>> Hi George,
>> 
>> On 2020-04-03 08:27, George Cherian wrote:
>> > Hi Marc,
>> >
>> > On 2/11/20 9:48 AM, Marc Zyngier wrote:
>> >> This is a major rework of the NV series that I posted over 6 months
>> >> ago[1], and a lot has changed since then:
>> >>
>> >> - Early ARMv8.4-NV support
>> >> - ARMv8.4-TTL support in host and guest
>> >> - ARMv8.5-GTG support in host and guest
>> >> - Lots of comments addressed after the review
>> >> - Rebased on v5.6-rc1
>> >> - Way too many patches
>> >>
>> >> In my defence, the whole of the NV code is still smaller that the
>> >> 32bit KVM/arm code I'm about to remove, so I feel less bad inflicting
>> >> this on everyone! ;-)
>> >>
>> >> >From a functionality perspective, you can expect a L2 guest to work,
>> >> but don't even think of L3, as we only partially emulate the
>> >> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug,
>> >> PMU, as well as anything that would require a Stage-1 PTW. What we
>> >> want to achieve is that with NV disabled, there is no performance
>> >> overhead and no regression.
>> >>
>> >> The series is roughly divided in 5 parts: exception handling, memory
>> >> virtualization, interrupts and timers for ARMv8.3, followed by the
>> >> ARMv8.4 support. There are of course some dependencies, but you'll
>> >> hopefully get the gist of it.
>> >>
>> >> For the most courageous of you, I've put out a branch[2]. Of course,
>> >> you'll need some userspace. Andre maintains a hacked version of
>> >> kvmtool[3] that takes a --nested option, allowing the guest to be
>> >> started at EL2. You can run the whole stack in the Foundation model.
>> >> Don't be in a hurry ;-).
>> >>
>> > The full series was tested on both Foundation model as well as Marvell
>> > ThunderX3
>> > Emulation Platform.
>> > Basic boot testing done for Guest Hypervisor and Guest Guest.
>> >
>> > Tested-by:  George Cherian <george.cherian@marvell.com>
>> 
>> Thanks for having given this a go.
>> 
>> However, without more details, it is pretty hard to find out what you 
>> have
>> tested.
>> What sort of guest have you booted, with what configuration, what
>> workloads did you run in the L2 guests and what are the architectural
>> features that TX3 implements?
>> 
> 
> We have tried the following configurations and tests (GH - Guest
> Hypervisor GG- Guest Guest).
> 1 - configuration: Host:8cpus/4GB Mem, GH:4vcpus/3GB, GG: 2vcpus/2GB
> Ran hackbench and Large Malloc tests (1GB allocations) across HOST,GH 
> and GG.
> 
> 2 - configuration: Host:8cpus/4GB Mem, GH:1vcpu/3GB, GG: 1vcpu/2GB
> Ran hackbench and Large Malloc tests across HOST,GH and GG. Host:
> 
> We used QEMU for all these testing.

Interesting. So you have added NV support to QEMU? Please be aware that
the userspace side is pretty incomplete and subject to changes.

> TX3 implements v8.4 Enhanced Nested Virtualization Support.

Hmm. Ok. This doesn't really answer my question in terms of what other
features the CPU has that would be affected by NV, but I guess that's
all we'll get at this point.

Thanks,

         M.

> 
>> The last point is specially important, as the NV architecture spans 
>> two major
>> revisions of the architecture and affects tons of other extensions 
>> that are
>> themselves optional. Without any detail on that front, I have no idea 
>> what
>> the coverage of your testing is.
>> 
>> Thanks,
>> 
>>          M.
>> --
>> Jazz is not dead. It just smells funny...

-- 
Jazz is not dead. It just smells funny...
