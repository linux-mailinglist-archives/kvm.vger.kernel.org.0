Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC45624493B
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 13:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgHNLtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 07:49:35 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3014 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbgHNLtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 07:49:33 -0400
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 449D8406FB90134A6F63;
        Fri, 14 Aug 2020 19:49:31 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 14 Aug 2020 19:49:30 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 14 Aug 2020 19:49:30 +0800
Subject: Re: [RFC 4/4] kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
To:     Andrew Jones <drjones@redhat.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
 <20200813060517.2360048-5-liangpeng10@huawei.com>
 <20200813091032.blyfvuiti7m2xw5i@kamzik.brq.redhat.com>
From:   Peng Liang <liangpeng10@huawei.com>
CC:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <maz@kernel.org>, <will@kernel.org>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        xiexiangyou 00584000 <xiexiangyou@huawei.com>,
        zhukeqian 00502301 <zhukeqian1@huawei.com>
Message-ID: <9bd25141-8cff-ac92-29a5-66c499d26273@huawei.com>
Date:   Fri, 14 Aug 2020 19:49:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200813091032.blyfvuiti7m2xw5i@kamzik.brq.redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.187]
X-ClientProxiedBy: dggeme703-chm.china.huawei.com (10.1.199.99) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/13/2020 5:10 PM, Andrew Jones wrote:
> On Thu, Aug 13, 2020 at 02:05:17PM +0800, Peng Liang wrote:
>> Add KVM_CAP_ARM_CPU_FEATURE extension for userpace to check whether KVM
>> supports to set CPU features in AArch64.
>>
>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>> ---
>>  arch/arm64/kvm/arm.c     | 1 +
>>  include/uapi/linux/kvm.h | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 18ebbe1c64ee..72b9e8fc606f 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -194,6 +194,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>>  	case KVM_CAP_ARM_NISV_TO_USER:
>>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
>> +	case KVM_CAP_ARM_CPU_FEATURE:
>>  		r = 1;
>>  		break;
>>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 1029444d04aa..0eca4f7c7fef 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1035,6 +1035,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_LAST_CPU 184
>>  #define KVM_CAP_SMALLER_MAXPHYADDR 185
>>  #define KVM_CAP_S390_DIAG318 186
>> +#define KVM_CAP_ARM_CPU_FEATURE 187
>>  
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>  
>> -- 
>> 2.18.4
>>
> 
> All new caps should be documented in Documentation/virt/kvm/api.rst
> 
> Thanks,
> drew 
> 
> .
> 
Sorry, I'll document it.

Thanks,
Peng
