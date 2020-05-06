Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4531C6F23
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgEFLVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:21:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:38172 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725824AbgEFLVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 07:21:13 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E25B51C982E0AB317622;
        Wed,  6 May 2020 19:21:10 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 19:21:01 +0800
Subject: Re: [PATCH v25 08/10] ACPI: Record Generic Error Status Block(GESB)
 table
To:     Igor Mammedov <imammedo@redhat.com>
CC:     <mst@redhat.com>, <xiaoguangrong.eric@gmail.com>,
        <peter.maydell@linaro.org>, <shannon.zhaosl@gmail.com>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>,
        <pbonzini@redhat.com>, <zhengxiang9@huawei.com>,
        <Jonathan.Cameron@huawei.com>, <linuxarm@huawei.com>
References: <20200410114639.32844-1-gengdongjiu@huawei.com>
 <20200410114639.32844-9-gengdongjiu@huawei.com>
 <20200505124446.2972f407@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <85337ce3-4a26-31f1-752c-115fe0f4e558@huawei.com>
Date:   Wed, 6 May 2020 19:20:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20200505124446.2972f407@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/5/5 18:44, Igor Mammedov wrote:
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> Reviewed-by: Igor Mammedov <imammedo@redhat.com>
> 
> Also we should ratelimit error messages that could be triggered at runtime
> from acpi_ghes_record_errors() and functions it's calling.
> It could be a patch on top.

Ok, thanks Igor.
I can make another patch for that after this series is applied.

> 
> 

