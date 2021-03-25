Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393AF3488AC
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 06:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYF4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 01:56:53 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14468 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCYF4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 01:56:24 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5Z71353SzwPVX;
        Thu, 25 Mar 2021 13:54:21 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 13:56:11 +0800
Subject: Re: [PATCH v5 0/6] KVM: arm64: Add VLPI migration support on GICv4.1
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        <yuzenghui@huawei.com>, <wanghaibin.wang@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20210322060158.1584-1-lushenming@huawei.com>
 <161660992482.2080654.11109199563385851665.b4-ty@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <5c966333-97ec-aa52-068e-b037b42baf2c@huawei.com>
Date:   Thu, 25 Mar 2021 13:56:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <161660992482.2080654.11109199563385851665.b4-ty@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/25 2:19, Marc Zyngier wrote:
> On Mon, 22 Mar 2021 14:01:52 +0800, Shenming Lu wrote:
>> In GICv4.1, migration has been supported except for (directly-injected)
>> VLPI. And GICv4.1 Spec explicitly gives a way to get the VLPI's pending
>> state (which was crucially missing in GICv4.0). So we make VLPI migration
>> capable on GICv4.1 in this series.
>>
>> In order to support VLPI migration, we need to save and restore all
>> required configuration information and pending states of VLPIs. But
>> in fact, the configuration information of VLPIs has already been saved
>> (or will be reallocated on the dst host...) in vgic(kvm) migration.
>> So we only have to migrate the pending states of VLPIs specially.
>>
>> [...]
> 
> Applied to next, thanks!

Thanks a lot again for all the comments and suggestions. :-)

Shenming

> 
> [1/6] irqchip/gic-v3-its: Add a cache invalidation right after vPE unmapping
>       commit: 301beaf19739cb6e640ed44e630e7da993f0ecc8
> [2/6] irqchip/gic-v3-its: Drop the setting of PTZ altogether
>       commit: c21bc068cdbe5613d3319ae171c3f2eb9f321352
> [3/6] KVM: arm64: GICv4.1: Add function to get VLPI state
>       commit: 80317fe4a65375fae668672a1398a0fb73eb9023
> [4/6] KVM: arm64: GICv4.1: Try to save VLPI state in save_pending_tables
>       commit: f66b7b151e00427168409f8c1857970e926b1e27
> [5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to physical side
>       commit: 12df7429213abbfa9632ab7db94f629ec309a58b
> [6/6] KVM: arm64: GICv4.1: Give a chance to save VLPI state
>       commit: 8082d50f4817ff6a7e08f4b7e9b18e5f8bfa290d
> 
> Cheers,
> 
> 	M.
> 
