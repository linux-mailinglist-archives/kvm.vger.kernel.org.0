Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23674528B8
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 11:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfFYJ4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 05:56:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19073 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726421AbfFYJ4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 05:56:16 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B42DE6DEBFE07697B51F;
        Tue, 25 Jun 2019 17:56:14 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Jun 2019
 17:56:04 +0800
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
 <ec089c94-589b-782c-1bdc-1b2c74e0ea46@huawei.com>
 <20190624131629.7f586861@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <623d8454-6d9a-43ff-dd34-f5e0d1896f01@huawei.com>
Date:   Tue, 25 Jun 2019 17:56:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190624131629.7f586861@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/6/24 19:16, Igor Mammedov wrote:
>>>> On 2019/6/20 20:10, Igor Mammedov wrote:  
>>>>>> + */
>>>>>> +struct AcpiGenericErrorStatus {
>>>>>> +    /* It is a bitmask composed of ACPI_GEBS_xxx macros */
>>>>>> +    uint32_t block_status;
>>>>>> +    uint32_t raw_data_offset;
>>>>>> +    uint32_t raw_data_length;
>>>>>> +    uint32_t data_length;
>>>>>> +    uint32_t error_severity;
>>>>>> +} QEMU_PACKED;
>>>>>> +typedef struct AcpiGenericErrorStatus AcpiGenericErrorStatus;    
>>>>> there shouldn't be packed structures,
>>>>> is it a leftover from previous version?    
>>>> I remember some people suggest to add QEMU_PACKED before, anyway I will remove it in my next version patch.  
>>> Question is why it's  there and where it is used?  
>> sorry, it is my carelessness. it should be packed structures.
>>
>> I used this structures to get its actual total size and member offset in [PATCH v17 10/10].
>> If it is not packed structures, the total size and member offset may be not right.
> I'd suggest to drop these typedefs and use a macro with size for that purpose,
> Also it might be good to make it local to the file that would use it.
so you mean we also use macro for the  member offset  in the structures?  such as the offset of data_length,
may be there is many hardcode.

> 
>>> BTW:
>>> series doesn't apply to master anymore.

