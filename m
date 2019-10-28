Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EFFE748C
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 16:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbfJ1PK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 11:10:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33744 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728436AbfJ1PK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 11:10:56 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1047BB1C390BC2090F65;
        Mon, 28 Oct 2019 23:10:54 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Mon, 28 Oct 2019
 23:10:48 +0800
Subject: Re: [PATCH v20 0/5] Add ARMv8 RAS virtualization support in QEMU
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <peter.maydell@linaro.org>, <ehabkost@redhat.com>,
        <kvm@vger.kernel.org>, <wanghaibin.wang@huawei.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <linuxarm@huawei.com>, <shannon.zhaosl@gmail.com>,
        Xiang Zheng <zhengxiang9@huawei.com>, <qemu-arm@nongnu.org>,
        <james.morse@arm.com>, <jonathan.cameron@huawei.com>,
        <imammedo@redhat.com>, <pbonzini@redhat.com>, <xuwei5@huawei.com>,
        <lersek@redhat.com>, <rth@twiddle.net>
References: <20191026032447.20088-1-zhengxiang9@huawei.com>
 <20191027061450-mutt-send-email-mst@kernel.org>
 <6c44268a-2676-3fa1-226d-29877b21dbea@huawei.com>
 <20191028042645-mutt-send-email-mst@kernel.org>
 <1edda59a-8b3d-1eec-659a-05356d55ed22@huawei.com>
 <20191028104834-mutt-send-email-mst@kernel.org>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <a16f00df-98cd-3469-1c64-d9d7a6ccaccf@huawei.com>
Date:   Mon, 28 Oct 2019 23:10:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20191028104834-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/10/28 22:56, Michael S. Tsirkin wrote:
> On Mon, Oct 28, 2019 at 09:50:21PM +0800, gengdongjiu wrote:
>> Hi Michael,
>>
>> On 2019/10/28 16:28, Michael S. Tsirkin wrote:
>>>>> gets some testing.  I'll leave this decision to the ARM maintainer.  For
>>>>> ACPI parts:
>>>>>
>>>>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>>>> Got it, Thanks for the Reviewed-by from Michael.
>>>>
>>>> Hi Michael,
>>>>   According to discussion with QEMU community, I finished and developed the whole ARM RAS virtualization solution, and introduce the ARM APEI table in the first time.
>>>> For the newly created files, which are mainly about ARM APEI/GHES part,I would like to maintain them. If you agree it, whether I can add new maintainers[1]? thanks a lot.
>>>>
>>>>
>>>> [1]:
>>>> +ARM APEI Subsystem
>>>> +M: Dongjiu Geng <gengdongjiu@huawei.com>
>>>> +M: Xiang zheng <zhengxiang9@huawei.com>
>>>> +L: qemu-arm@nongnu.org
>>>> +S: Maintained
>>>> +F: hw/acpi/acpi_ghes.c
>>>>
>>> I think for now you want to be a designated reviewer.  So I'd use an R:
>>> tag.
>>
>>  Thanks for the reply.
>>  I want to be a maintainer for my newly created files, so whether I can use M: tag. I would like to contribute some time to maintain that, thanks a lot.
> 
> This will fundamentally be up to Peter.

Thanks.

Hi Peter,
    what do you think about it?

> 
> 
> 
>>>
>>>>>
>>>>>> ---
> .
> 

