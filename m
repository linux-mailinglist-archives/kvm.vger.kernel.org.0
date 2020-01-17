Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF988140811
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 11:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgAQKgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 05:36:49 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:53064 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726085AbgAQKgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 05:36:49 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 14ED5F094E649266C5B6;
        Fri, 17 Jan 2020 18:36:48 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 18:36:39 +0800
Subject: Re: [PATCH v22 5/9] ACPI: Record the Generic Error Status Block
 address
To:     Peter Maydell <peter.maydell@linaro.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Fam Zheng <fam@euphon.net>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        James Morse <james.morse@arm.com>,
        "QEMU Developers" <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
 <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
 <CAFEAcA9z9KDHmvh6WsrCPj_FTvNmOfhatxNQDftNG+ZKZN0wAA@mail.gmail.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <9110de9c-7522-2823-22be-4ba9212026fb@huawei.com>
Date:   Fri, 17 Jan 2020 18:36:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9z9KDHmvh6WsrCPj_FTvNmOfhatxNQDftNG+ZKZN0wAA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/1/17 0:44, Peter Maydell wrote:
>>      .minimum_version_id = 1,
>>      .fields = (VMStateField[]) {
>> -        VMSTATE_STRUCT(ged_state, AcpiGedState, 1, vmstate_ged_state, GEDState),
>> +        VMSTATE_STRUCT(ged_state, AcpiGedState, 1,
>> +                       vmstate_ged_state, GEDState),
>> +        VMSTATE_STRUCT(ghes_state, AcpiGedState, 1,
>> +                       vmstate_ghes_state, AcpiGhesState),
>>          VMSTATE_END_OF_LIST(),
>>      },
>>      .subsections = (const VMStateDescription * []) {
> You can't just add fields to an existing VMStateDescription
> like this -- it will break migration compatibility. Instead you
> need to add a new subsection to this vmstate, with a '.needed'
> function which indicates when the subsection should be present.
Thanks Peter's pointing out. I will change it.


> 
> thanks
> -- PMM
> .
> 

