Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76AF1AE0C0
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 17:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgDQPLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 11:11:35 -0400
Received: from foss.arm.com ([217.140.110.172]:52610 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbgDQPLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 11:11:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A3C230E;
        Fri, 17 Apr 2020 08:11:29 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 935F53F73D;
        Fri, 17 Apr 2020 08:11:27 -0700 (PDT)
Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
To:     "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     George Cherian <gcherian@marvell.com>,
        "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
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
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
 <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
 <86r1wus7df.wl-maz@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f55386a9-8eaa-944f-453d-9c3c4abee5fb@arm.com>
Date:   Fri, 17 Apr 2020 16:11:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/16/20 2:38 AM, Zengtao (B) wrote:
> Hi Marc:
>
> Got it.
> Really a bit patch set :)
>
> BTW, I have done a basic kvm unit test
> git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> And I find that after apply the patch KVM: arm64: VNCR-ize ELR_EL1,
> The psci test failed for some reason, I can't understand why, this
> is only the test result.(find the patch by git bisect + kvm test)

Just a heads-up, a couple of fixes to kvm-unit-tests were merged last week, and
among them was one touching the psci code, e14e6ba56f6e ("arm/arm64: psci: Don't
run C code without stack or vectors"). It might be worth checking that you have
it, and if you don't, if applying it fixes the issue.

Thanks,
Alex
>
> My platform: Hisilicon D06 board.
> Linux kernel: Linux 5.6-rc6 + nv patches(some rebases)
> Could you help to take a look?
>
> Thanks 
> Zengtao 
>
>> -----Original Message-----
>> From: Marc Zyngier [mailto:maz@kernel.org]
>> Sent: Saturday, April 11, 2020 5:24 PM
>> To: Zengtao (B)
>> Cc: George Cherian; Dave.Martin@arm.com; alexandru.elisei@arm.com;
>> andre.przywara@arm.com; christoffer.dall@arm.com;
>> james.morse@arm.com; jintack@cs.columbia.edu;
>> julien.thierry.kdev@gmail.com; kvm@vger.kernel.org;
>> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org;
>> suzuki.poulose@arm.com; Anil Kumar Reddy H; Ganapatrao Kulkarni
>> Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
>> Virtualization support
>>
>> Hi Zengtao,
>>
>> On Sat, 11 Apr 2020 05:10:05 +0100,
>> "Zengtao (B)" <prime.zeng@hisilicon.com> wrote:
>>> Hi Marc:
>>>
>>> Since it's a very large patch series, I want to test it on my platform
>>>  which don't support nv, and want to make sure if this patch series
>>> affects the existed virtualization functions or not.
>>>
>>> Any suggestion about the test focus?
>> Not really. Given that the NV patches affect absolutely every
>> architectural parts of KVM/arm64, everything needs careful
>> testing. But more than testing, it needs reviewing.
>>
>> Thanks,
>>
>> 	M.
>>
>> --
>> Jazz is not dead, it just smells funny.
