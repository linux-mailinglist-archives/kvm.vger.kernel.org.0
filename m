Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13441AE969
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 04:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgDRCt1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 17 Apr 2020 22:49:27 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2060 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725320AbgDRCt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 22:49:27 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 97116A319AD7B1B2AC2E;
        Sat, 18 Apr 2020 10:49:25 +0800 (CST)
Received: from DGGEMM526-MBX.china.huawei.com ([169.254.8.234]) by
 DGGEMM406-HUB.china.huawei.com ([10.3.20.214]) with mapi id 14.03.0487.000;
 Sat, 18 Apr 2020 10:49:24 +0800
From:   "Zengtao (B)" <prime.zeng@hisilicon.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     George Cherian <gcherian@marvell.com>,
        "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
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
Thread-Index: AdYJhvrCKEKaxySRQua1lfr4U9NN2v//iESA//MqKcCAGX9aAP/4ImVggBBPsoCAAVt7AP/+wAyA
Date:   Sat, 18 Apr 2020 02:49:23 +0000
Message-ID: <678F3D1BB717D949B966B68EAEB446ED3A545C71@dggemm526-mbx.china.huawei.com>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
        <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
        <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
        <86r1wus7df.wl-maz@kernel.org>
        <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
        <3e84aaf8b757bc5a7685a291e54c232b@kernel.org> <20200417160602.26706917@why>
In-Reply-To: <20200417160602.26706917@why>
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

 -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: Friday, April 17, 2020 11:06 PM
> To: Zengtao (B)
> Cc: George Cherian; Dave.Martin@arm.com; alexandru.elisei@arm.com;
> andre.przywara@arm.com; christoffer.dall@arm.com;
> james.morse@arm.com; jintack@cs.columbia.edu;
> julien.thierry.kdev@gmail.com; kvm@vger.kernel.org;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org;
> suzuki.poulose@arm.com; Anil Kumar Reddy H; Ganapatrao Kulkarni
> Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
> Virtualization support
> 
> On Thu, 16 Apr 2020 19:22:21 +0100
> Marc Zyngier <maz@kernel.org> wrote:
> 
> > Hi Zengtao,
> >
> > On 2020-04-16 02:38, Zengtao (B) wrote:
> > > Hi Marc:
> > >
> > > Got it.
> > > Really a bit patch set :)
> >
> > Well, yeah... ;-)
> >
> > >
> > > BTW, I have done a basic kvm unit test
> > > git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> > > And I find that after apply the patch KVM: arm64: VNCR-ize ELR_EL1,
> > > The psci test failed for some reason, I can't understand why, this
> > > is only the test result.(find the patch by git bisect + kvm test)
> >
> > That it is that mechanical, we should be able to quickly nail that one.
> >
> > > My platform: Hisilicon D06 board.
> > > Linux kernel: Linux 5.6-rc6 + nv patches(some rebases)
> > > Could you help to take a look?
> >
> > I'll have a look tomorrow. I'm in the middle of refactoring the series
> > for 5.7, and things have changed quite a bit. Hopefully this isn't a VHE
> > vs non-VHE issue.
> 
> So I've repeatedly tried with the current state of the NV patches[1],
> on both an ARMv8.0 system (Seattle) and an ARMv8.2 pile of putrid junk
> (vim3l). PSCI is pretty happy, although I can only test with at most 8
> vcpus (GICv2 gets in the way).
> 
> Can you please:
> 
> - post the detailed error by running the PSCI unit test on its own
I tried to trace the error, and I found in kernel function kvm_mpidr_to_vcpu,
casually, mpidr returns zero and we can't get the expected vcpu, and psci
 test failed due to this.
And as I mentioned in my last before, the psci error is introduced by the
 patch KVM: arm64: VNCR-ize ELR_EL1.(Only test result)
Maybe you have to try tens of times to reproduce. :)
Deep into the patch itself, I don't find any connection between the patch
and the issue.

> - test with the current state of the patches
I test with your nv-5.7-rc1-WIP branch and latest kvm_unit_test, the 
error still exist.

Thanks.
zengtao

> 


> Thanks,
> 
> 	M.
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/l
> og/?h=kvm-arm64/nv-5.7-rc1-WIP
> --
> Jazz is not dead. It just smells funny...
