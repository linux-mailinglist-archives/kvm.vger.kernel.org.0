Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5220018CD80
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 13:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCTMJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 08:09:26 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43746 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726969AbgCTMJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 08:09:26 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 01604CD906C56B9B967F;
        Fri, 20 Mar 2020 20:09:21 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 20:09:13 +0800
Subject: Re: [PATCH v5 23/23] KVM: arm64: GICv4.1: Expose HW-based SGIs in
 debugfs
To:     Marc Zyngier <maz@kernel.org>
CC:     Auger Eric <eric.auger@redhat.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "Robert Richter" <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-24-maz@kernel.org>
 <4cb4c3d4-7b02-bb77-cd7a-c185346b6a2f@redhat.com>
 <45c282bddd43420024633943c1befac3@kernel.org>
 <e1a1e537-9f8e-5cfb-0132-f796e8bf06c9@huawei.com>
 <b63950513f519d9a04f9719f5aa6a2db@kernel.org>
 <8d7fdb7f-7a21-da22-52a2-51ee8ac9393f@huawei.com>
 <40cbdf23c0f8bfc229400c14899ecbe0@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <facb4eb5-57c6-e0d0-003d-ebaa0b83e6f2@huawei.com>
Date:   Fri, 20 Mar 2020 20:09:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <40cbdf23c0f8bfc229400c14899ecbe0@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/3/20 19:46, Marc Zyngier wrote:
>>> Side note: it'd be good to know what the rules are for your own GICv4
>>> implementations, so that we can at least make sure the current code 
>>> is safe.
>>
>> As far as I know, there will be some clean and invalidate operations
>> when v4.0 VPENDBASER.Valid gets programmed.
> 
> Interesting. The ideal behaviour would be that the VPT is up-to-date and
> the caches clean when Valid is cleared (and once Dirty flips to 0).
> 
>> But not sure about behaviors
>> on VMAPP (unmap), it may be a totally v4.1 stuff. I'll have a talk with
>> our SOC team.
> 
> The VMAPP stuff is purely v4.1.
> 
>> But how can the current code be unsafe? Is anywhere in the current code
>> will peek/poke the vpt (whilst GIC continues writing things into it)?
> 
> No. But on VM termination, the memory will be freed, and will eventually be
> reallocated. If the GIC can still write to that memory after it has been
> freed, you end-up with memory corruption... Which is why I'm curious of
> what ensures that on your implementation.

Ah, I got it. I will check it with HiSilicon people next week and go
back to you if the code becomes unsafe due to the incomplete GICv4.


Thanks,
Zenghui

