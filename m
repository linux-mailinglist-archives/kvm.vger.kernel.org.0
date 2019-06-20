Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4888D4D4AF
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 19:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfFTRSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 13:18:05 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50322 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726530AbfFTRSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 13:18:05 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8DA1CE588E5E94AEC6A2;
        Fri, 21 Jun 2019 01:17:58 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Fri, 21 Jun 2019
 01:17:49 +0800
Subject: Re: [Qemu-devel] [PATCH v17 02/10] ACPI: add some GHES structures and
 macros definition
To:     Igor Mammedov <imammedo@redhat.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
 <1557832703-42620-3-git-send-email-gengdongjiu@huawei.com>
 <20190620141052.370788fb@redhat.com>
 <f4f94ecb-200c-3e18-1a09-5fb6bc761834@huawei.com>
 <20190620170934.39eae310@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <ec089c94-589b-782c-1bdc-1b2c74e0ea46@huawei.com>
Date:   Fri, 21 Jun 2019 01:17:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190620170934.39eae310@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/6/20 23:09, Igor Mammedov wrote:
> On Thu, 20 Jun 2019 22:04:01 +0800
> gengdongjiu <gengdongjiu@huawei.com> wrote:
> 
>> Hi Igor,
>>    Thanks for your review.
>>
>> On 2019/6/20 20:10, Igor Mammedov wrote:
>>>> + */
>>>> +struct AcpiGenericErrorStatus {
>>>> +    /* It is a bitmask composed of ACPI_GEBS_xxx macros */
>>>> +    uint32_t block_status;
>>>> +    uint32_t raw_data_offset;
>>>> +    uint32_t raw_data_length;
>>>> +    uint32_t data_length;
>>>> +    uint32_t error_severity;
>>>> +} QEMU_PACKED;
>>>> +typedef struct AcpiGenericErrorStatus AcpiGenericErrorStatus;  
>>> there shouldn't be packed structures,
>>> is it a leftover from previous version?  
>>
>> I remember some people suggest to add QEMU_PACKED before, anyway I will remove it in my next version patch.
> 
> Question is why it's  there and where it is used?
sorry, it is my carelessness. it should be packed structures.

I used this structures to get its actual total size and member offset in [PATCH v17 10/10].
If it is not packed structures, the total size and member offset may be not right.


> 
> BTW:
> series doesn't apply to master anymore.
> Do you have a repo somewhere available for testing?

Thanks, I appreciated that you can have a test.

I still do not upload repo, you can reset to below commit[1] in master and apply this series.

BTW：
If test series, you should make an guest memory hardware error, let guest access the error address, then it will happen RAS error.
I provide a software hard code method to test this series, you can refer to https://www.mail-archive.com/qemu-devel@nongnu.org/msg619771.html


[1]:
commit efb4f3b62c69383a7308d7b739a3193e7c0ccae8
Merge: 5f02262 e841257
Author: Peter Maydell <peter.maydell@linaro.org>
Date:   Fri May 10 14:49:36 2019 +0100



> 
>>
>>>   
>>>> +
>>>> +/*
>>>> + * Masks for block_status flags above
>>>> + */
>>>> +#define ACPI_GEBS_UNCORRECTABLE         1
>>>> +
>>>> +/*  
>>
> 
> .
> 

