Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D831CDC98
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 16:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgEKOFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 10:05:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4332 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730253AbgEKOFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 10:05:40 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ABE34487DBF92CA12DB6;
        Mon, 11 May 2020 22:05:36 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 11 May 2020
 22:05:29 +0800
Subject: Re: [PATCH v26 01/10] acpi: nvdimm: change NVDIMM_UUID_LE to a common
 macro
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        <imammedo@redhat.com>, <mst@redhat.com>,
        <xiaoguangrong.eric@gmail.com>, <peter.maydell@linaro.org>,
        <shannon.zhaosl@gmail.com>, <pbonzini@redhat.com>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>
CC:     <zhengxiang9@huawei.com>, <linuxarm@huawei.com>,
        <Jonathan.Cameron@huawei.com>
References: <20200507134205.7559-1-gengdongjiu@huawei.com>
 <20200507134205.7559-2-gengdongjiu@huawei.com>
 <4f29e19c-cb37-05e6-0ae3-c019370e090b@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <777c44a0-b977-a8fe-a3c6-5b217e9093af@huawei.com>
Date:   Mon, 11 May 2020 22:05:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <4f29e19c-cb37-05e6-0ae3-c019370e090b@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> +    (node3), (node4), (node5) }
>> +
>>   #define UUID_FMT "%02hhx%02hhx%02hhx%02hhx-" \
>>                    "%02hhx%02hhx-%02hhx%02hhx-" \
>>                    "%02hhx%02hhx-" \
>> diff --git a/slirp b/slirp
>> index 2faae0f..55ab21c 160000
>> --- a/slirp
>> +++ b/slirp
>> @@ -1 +1 @@
>> -Subproject commit 2faae0f778f818fadc873308f983289df697eb93
>> +Subproject commit 55ab21c9a36852915b81f1b41ebaf3b6509dd8ba
> 
> The SLiRP submodule change is certainly unrelated.

Thanks Philippe's review and comments. I submitted another patchset "[PATCH RESEND v26 00/10] Add ARMv8 RAS virtualization support in QEMU" to fix it, please review that patchset.

> 
> 
> .
> 

