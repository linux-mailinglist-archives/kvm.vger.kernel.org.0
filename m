Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBA6CFB47
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 15:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbfJHNZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 09:25:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51390 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730301AbfJHNZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 09:25:56 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3AF3468A6E58B3089D74;
        Tue,  8 Oct 2019 21:25:51 +0800 (CST)
Received: from [127.0.0.1] (10.133.224.57) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 8 Oct 2019
 21:25:44 +0800
Subject: Re: [Qemu-devel] [PATCH v18 2/6] docs: APEI GHES generation and CPER
 record description
To:     Igor Mammedov <imammedo@redhat.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>, <wanghaibin.wang@huawei.com>
References: <20190906083152.25716-1-zhengxiang9@huawei.com>
 <20190906083152.25716-3-zhengxiang9@huawei.com>
 <20191004102051.4e45cbd2@redhat.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <70a22014-27f8-0fd0-3547-e814bd1a822a@huawei.com>
Date:   Tue, 8 Oct 2019 21:25:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191004102051.4e45cbd2@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Igor,

Thanks for your review!

On 2019/10/4 16:20, Igor Mammedov wrote:
> On Fri, 6 Sep 2019 16:31:48 +0800
> Xiang Zheng <zhengxiang9@huawei.com> wrote:
> 
>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>
> [...]
>> +
>> +(9) When QEMU gets SIGBUS from the kernel, QEMU formats the CPER right into
>> +    guest memory, and then injects whatever interrupt (or assert whatever GPIO
> s/whatever .../platform specific/
> 
> and add concrete impl info like:
>   "in case of arm/virt machine it's ..."

OK, I will add the concrete impl info.

> 
>> +    line) as a notification which is necessary for notifying the guest.
> [...]
> 
> .
> 

-- 

Thanks,
Xiang

