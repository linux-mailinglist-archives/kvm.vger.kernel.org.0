Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16512F6C37
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 02:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfKKBXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Nov 2019 20:23:12 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:37792 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726275AbfKKBXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Nov 2019 20:23:12 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0AEF27CCDDD5308E8303;
        Mon, 11 Nov 2019 09:23:10 +0800 (CST)
Received: from [127.0.0.1] (10.133.224.57) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 11 Nov 2019
 09:23:02 +0800
Subject: Re: [PATCH v21 3/6] ACPI: Add APEI GHES table generation support
To:     gengdongjiu <gengdongjiu@huawei.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20191104121458.29208-1-zhengxiang9@huawei.com>
 <20191104121458.29208-4-zhengxiang9@huawei.com>
 <3068b1f2-7175-485a-a9a1-dcba0bf82dea@huawei.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <b32dec90-93c7-a811-f521-470dee75e5b8@huawei.com>
Date:   Mon, 11 Nov 2019 09:23:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <3068b1f2-7175-485a-a9a1-dcba0bf82dea@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/11/8 16:11, gengdongjiu wrote:
> On 2019/11/4 20:14, Xiang Zheng wrote:
>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>
>> This patch implements APEI GHES Table generation via fw_cfg blobs. Now
>> it only supports ARMv8 SEA, a type of GHESv2 error source. Afterwards,
>> we can extend the supported types if needed. For the CPER section,
>> currently it is memory section because kernel mainly wants userspace to
>> handle the memory errors.
>>
>> This patch follows the spec ACPI 6.2 to build the Hardware Error Source
>> table. For more detailed information, please refer to document:
>> docs/specs/acpi_hest_ghes.rst
>>
>> Suggested-by: Laszlo Ersek <lersek@redhat.com>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> 
> Hi Xiang,
>    please add "Reviewed-by: Michael S. Tsirkin <mst@redhat.com> " which from Michael, thanks.
> 

OK, I will add it.

> 
> .
> 

-- 

Thanks,
Xiang

