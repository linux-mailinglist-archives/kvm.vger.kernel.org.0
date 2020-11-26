Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47102C4D7B
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 03:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732996AbgKZCbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 21:31:19 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7687 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731379AbgKZCbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 21:31:18 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ChMF76C50z15R84;
        Thu, 26 Nov 2020 10:30:51 +0800 (CST)
Received: from [10.174.187.69] (10.174.187.69) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Nov 2020 10:31:04 +0800
Subject: Re: [RFC PATCH 0/4] Add support for ARMv8.6 TWED feature
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <will@kernel.org>,
        <catalin.marinas@arm.com>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <yezengruan@huawei.com>,
        <shameerali.kolothum.thodi@huawei.com>, <fanhenglong@huawei.com>,
        <prime.zeng@hisilicon.com>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
 <9d341a2d-19f8-400c-6674-ef991ab78f62@huawei.com>
 <10463cb9a0ae167a89300185c1de348c@kernel.org>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <b084262b-5563-2d80-3065-cf563d978ea3@huawei.com>
Date:   Thu, 26 Nov 2020 10:31:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <10463cb9a0ae167a89300185c1de348c@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc，

I will consider more circumstances in the later test. Thanks for the
advice.

Thanks,
Jingyi


On 11/24/2020 7:02 PM, Marc Zyngier wrote:
> On 2020-11-13 07:54, Jingyi Wang wrote:
>> Hi all，
>>
>> Sorry for the delay. I have been testing the TWED feature performance
>> lately. We select unixbench as the benchmark for some items of it is
>> lock-intensive(fstime/fsbuffer/fsdisk). We run unixbench on a 4-VCPU
>> VM, and bind every two VCPUs on one PCPU. Fixed TWED value is used and
>> here is the result.
> 
> How representative is this?
> 
> TBH, I only know of two real world configurations: one where
> the vCPUs are pinned to different physical CPUs (and in this
> case your patch has absolutely no effect as long as there is
> no concurrent tasks), and one where there is oversubscription,
> and the scheduler moves things around as it sees fit, depending
> on the load.
> 
> Having two vCPUs pinned per CPU feels like a test that has been
> picked to give the result you wanted. I'd like to see the full
> picture, including the case that matters for current use cases.
> I'm specially interested in the cases where the system is
> oversubscribed, because TWED is definitely going to screw with
> the scheduler latency.
> 
> Thanks,
> 
>          M.
