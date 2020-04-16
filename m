Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C219B1AB597
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 03:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733158AbgDPBi5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 15 Apr 2020 21:38:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2114 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbgDPBiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 21:38:51 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 079307B60A37B2BB8BEE;
        Thu, 16 Apr 2020 09:38:48 +0800 (CST)
Received: from DGGEMM421-HUB.china.huawei.com (10.1.198.38) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 16 Apr 2020 09:38:47 +0800
Received: from DGGEMM506-MBX.china.huawei.com ([169.254.3.76]) by
 dggemm421-hub.china.huawei.com ([10.1.198.38]) with mapi id 14.03.0487.000;
 Thu, 16 Apr 2020 09:38:46 +0800
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
Thread-Index: AdYJhvrCKEKaxySRQua1lfr4U9NN2v//iESA//MqKcCAGX9aAP/4ImVg
Date:   Thu, 16 Apr 2020 01:38:45 +0000
Message-ID: <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
        <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
        <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
 <86r1wus7df.wl-maz@kernel.org>
In-Reply-To: <86r1wus7df.wl-maz@kernel.org>
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

Got it.
Really a bit patch set :)

BTW, I have done a basic kvm unit test
git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
And I find that after apply the patch KVM: arm64: VNCR-ize ELR_EL1,
The psci test failed for some reason, I can't understand why, this
is only the test result.(find the patch by git bisect + kvm test)

My platform: Hisilicon D06 board.
Linux kernel: Linux 5.6-rc6 + nv patches(some rebases)
Could you help to take a look?

Thanks 
Zengtao 

> -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: Saturday, April 11, 2020 5:24 PM
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
> Hi Zengtao,
> 
> On Sat, 11 Apr 2020 05:10:05 +0100,
> "Zengtao (B)" <prime.zeng@hisilicon.com> wrote:
> >
> > Hi Marc:
> >
> > Since it's a very large patch series, I want to test it on my platform
> >  which don't support nv, and want to make sure if this patch series
> > affects the existed virtualization functions or not.
> >
> > Any suggestion about the test focus?
> 
> Not really. Given that the NV patches affect absolutely every
> architectural parts of KVM/arm64, everything needs careful
> testing. But more than testing, it needs reviewing.
> 
> Thanks,
> 
> 	M.
> 
> --
> Jazz is not dead, it just smells funny.
