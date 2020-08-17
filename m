Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E96246083
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 10:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgHQInY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 04:43:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726544AbgHQInX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 04:43:23 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B2129354BE937E759B8A;
        Mon, 17 Aug 2020 16:43:20 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 16:43:14 +0800
Subject: Re: [PATCH 2/3] KVM: uapi: Remove KVM_DEV_TYPE_ARM_PV_TIME in
 kvm_device_type
To:     Marc Zyngier <maz@kernel.org>
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-3-zhukeqian1@huawei.com>
 <f97633b4a39c301f916bb76030dcabf0@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Steven Price" <steven.price@arm.com>, <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <4cd543a2-4d5b-882c-38d6-f5055512f0dc@huawei.com>
Date:   Mon, 17 Aug 2020 16:43:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <f97633b4a39c301f916bb76030dcabf0@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/8/17 15:39, Marc Zyngier wrote:
> On 2020-08-17 04:37, Keqian Zhu wrote:
>> ARM64 PV-time ST is configured by userspace through vCPU attribute,
>> and KVM_DEV_TYPE_ARM_PV_TIME is unused.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  include/uapi/linux/kvm.h       | 2 --
>>  tools/include/uapi/linux/kvm.h | 2 --
>>  2 files changed, 4 deletions(-)
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 4fdf303..9a6b97e 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1258,8 +1258,6 @@ enum kvm_device_type {
>>  #define KVM_DEV_TYPE_ARM_VGIC_ITS    KVM_DEV_TYPE_ARM_VGIC_ITS
>>      KVM_DEV_TYPE_XIVE,
>>  #define KVM_DEV_TYPE_XIVE        KVM_DEV_TYPE_XIVE
>> -    KVM_DEV_TYPE_ARM_PV_TIME,
>> -#define KVM_DEV_TYPE_ARM_PV_TIME    KVM_DEV_TYPE_ARM_PV_TIME
>>      KVM_DEV_TYPE_MAX,
>>  };
>>
>> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
>> index 4fdf303..9a6b97e 100644
>> --- a/tools/include/uapi/linux/kvm.h
>> +++ b/tools/include/uapi/linux/kvm.h
>> @@ -1258,8 +1258,6 @@ enum kvm_device_type {
>>  #define KVM_DEV_TYPE_ARM_VGIC_ITS    KVM_DEV_TYPE_ARM_VGIC_ITS
>>      KVM_DEV_TYPE_XIVE,
>>  #define KVM_DEV_TYPE_XIVE        KVM_DEV_TYPE_XIVE
>> -    KVM_DEV_TYPE_ARM_PV_TIME,
>> -#define KVM_DEV_TYPE_ARM_PV_TIME    KVM_DEV_TYPE_ARM_PV_TIME
>>      KVM_DEV_TYPE_MAX,
>>  };
> 
> No. You can't drop anything from UAPI, used or not. Doing so will
> break the compilation of any userspace that, for any reason, references
> this value. We cannot reuse this value in the future either, as it would
> create a we wouldn't know which device to create.
> 
> It is pretty unfortunate that PV time has turned into such a train wreck,
> but that's what we have now, and it has to stay.
Well, I see. It is a sad thing indeed.

Thanks,
Keqian
