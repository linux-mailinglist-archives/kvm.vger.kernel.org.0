Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943E1183EB7
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 02:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgCMBjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 21:39:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11640 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726546AbgCMBjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 21:39:21 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F35E4EF00CE69FBB0358;
        Fri, 13 Mar 2020 09:39:17 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 13 Mar 2020
 09:39:10 +0800
Subject: Re: [PATCH v5 01/23] irqchip/gic-v3: Use SGIs without active state if
 offered
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "Robert Richter" <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Eric Auger" <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-2-maz@kernel.org>
 <63f6530a-9369-31e6-88d0-5337173495b9@huawei.com>
 <51b2c74fdbcca049cc01be6d78c7c693@kernel.org>
 <1bff1835ba7d6e22edb836d38cf16a14@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3e20f3c3-0312-bd29-dcfc-2afee764ef19@huawei.com>
Date:   Fri, 13 Mar 2020 09:39:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1bff1835ba7d6e22edb836d38cf16a14@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/3/12 20:05, Marc Zyngier wrote:
> On 2020-03-12 09:28, Marc Zyngier wrote:
>> Hi Zenghui,
>>
>> On 2020-03-12 06:30, Zenghui Yu wrote:
>>> Hi Marc,
>>>
>>> On 2020/3/5 4:33, Marc Zyngier wrote:
>>>> To allow the direct injection of SGIs into a guest, the GICv4.1
>>>> architecture has to sacrifice the Active state so that SGIs look
>>>> a lot like LPIs (they are injected by the same mechanism).
>>>>
>>>> In order not to break existing software, the architecture gives
>>>> offers guests OSs the choice: SGIs with or without an active
>>>> state. It is the hypervisors duty to honor the guest's choice.
>>>>
>>>> For this, the architecture offers a discovery bit indicating whether
>>>> the GIC supports GICv4.1 SGIs (GICD_TYPER2.nASSGIcap), and another
>>>> bit indicating whether the guest wants Active-less SGIs or not
>>>> (controlled by GICD_CTLR.nASSGIreq).
>>>
>>> I still can't find the description of these two bits in IHI0069F.
>>> Are they actually architected and will be available in the future
>>> version of the spec?  I want to confirm it again since this has a
>>> great impact on the KVM code, any pointers?
>>
>> Damn. The bits *are* in the engineering spec version 19 (unfortunately
>> not a public document, but I believe you should have access to it).
>>
>> If the bits have effectively been removed from the spec, I'll drop the
>> GICv4.1 code from the 5.7 queue until we find a way to achieve the same
>> level of support.
>>
>> I've emailed people inside ARM to find out.
> 
> I've now had written confirmation that the bits are still there.
> 
> It is just that the current revision of the documentation was cut *before*
> they made it into the architecture (there seem to be a 6 month delay 
> between
> the architecture being sampled and the documentation being released).

I see. Thanks for the confirmation!


Zenghui

