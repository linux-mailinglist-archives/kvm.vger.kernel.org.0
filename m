Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920025505F
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 15:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbfFYN37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 09:29:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41044 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726506AbfFYN36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 09:29:58 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 169C71F4372C443137A0;
        Tue, 25 Jun 2019 21:29:56 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Jun 2019
 21:29:49 +0800
Subject: Re: [PATCH v17 01/10] hw/arm/virt: Add RAS platform version for
 migration
To:     Igor Mammedov <imammedo@redhat.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
 <1557832703-42620-2-git-send-email-gengdongjiu@huawei.com>
 <20190620140409.3c713760@redhat.com>
 <fbd558d5-03b7-df5c-e781-549261207221@huawei.com>
 <20190625151616.12e46566@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <a4b5706f-a8f0-0a20-b77e-4cb250159ccb@huawei.com>
Date:   Tue, 25 Jun 2019 21:29:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190625151616.12e46566@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/6/25 21:16, Igor Mammedov wrote:
>>> In light of the race for leaner QEMU and faster startup times,
>>> it might be better to make RAS optional and make user explicitly
>>> enable it using a machine option.  
>> I will add a machine option to make RAS optional, do you think we should enable or disable it by default? I think it is better if we enable it by default.
> I'd start with disabled by default as it's easy to make it
> enabled by default later and we can't do so other way around.
ok

> 
>  
>>>   
>>>>  }
>>>>  DEFINE_VIRT_MACHINE(4, 0)
>>>>  
>>>> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt

