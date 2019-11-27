Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670EE10AE8F
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 12:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfK0LQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 06:16:58 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:48838 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726219AbfK0LQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 06:16:58 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 03EDC2BFAB609FA68735;
        Wed, 27 Nov 2019 19:16:55 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Wed, 27 Nov 2019
 19:16:48 +0800
Subject: Re: [RESEND PATCH v21 3/6] ACPI: Add APEI GHES table generation
 support
To:     Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     <peter.maydell@linaro.org>, <ehabkost@redhat.com>,
        <kvm@vger.kernel.org>, <wanghaibin.wang@huawei.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <linuxarm@huawei.com>, <shannon.zhaosl@gmail.com>,
        Xiang Zheng <zhengxiang9@huawei.com>, <qemu-arm@nongnu.org>,
        <james.morse@arm.com>, <jonathan.cameron@huawei.com>,
        <pbonzini@redhat.com>, <xuwei5@huawei.com>, <lersek@redhat.com>,
        <rth@twiddle.net>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <20191111014048.21296-4-zhengxiang9@huawei.com>
 <20191115103801.547fc84d@redhat.com>
 <cf5e5aa4-2283-6cf9-70d0-278d167e3a13@huawei.com>
 <87758ec2-c242-71c3-51f8-a5d348f8e7fd@huawei.com>
 <20191118082036-mutt-send-email-mst@kernel.org>
 <20191125104859.70047602@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <6a4bcef4-41f2-af5d-3cce-75718da23719@huawei.com>
Date:   Wed, 27 Nov 2019 19:16:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20191125104859.70047602@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/11/25 17:48, Igor Mammedov wrote:
>>>    ......
>>>     bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
>>>         ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id),
>>>         sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE,
>>>         source_id * sizeof(uint64_t));
>>>   .......
>>> }
>>>
>>> My previous series patch support 2 error sources, but now only enable 'SEA' type Error Source  
>> I'd try to merge this, worry about extending things later.
>> This is at v21 and the simpler you can keep things,
>> the faster it'll go in.
> I don't think the series is ready for merging yet.
> It has a number of issues (not stylistic ones) that need to be fixed first.
> 
> As for extending, I think I've suggested to simplify series
> to account for single error source only in some places so it
> would be easier on author and reviewers and worry about extending
> it later.
sure, thanks for the review, we are preparing another series which will fix the issues that you mentioned.

> 

