Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC73B116EC2
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 15:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfLIOMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 09:12:46 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:38252 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727572AbfLIOMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 09:12:46 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D162478339045A5766C6;
        Mon,  9 Dec 2019 22:12:42 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 9 Dec 2019
 22:12:37 +0800
Subject: Re: [RESEND PATCH v21 5/6] target-arm: kvm64: handle SIGBUS signal
 from kernel or KVM
To:     Beata Michalska <beata.michalska@linaro.org>
CC:     Xiang Zheng <zhengxiang9@huawei.com>, <pbonzini@redhat.com>,
        <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        "Laszlo Ersek" <lersek@redhat.com>, <james.morse@arm.com>,
        <mtosatti@redhat.com>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <20191111014048.21296-6-zhengxiang9@huawei.com>
 <CADSWDztF=eaUDNnq8bhnPyTKW1YjAWm4UBaH-NBPkzjnzx0bxg@mail.gmail.com>
 <238ea7b3-9d6d-e3f7-40c9-e3e62b5fb477@huawei.com>
 <CADSWDzvFvS6mYiMhXu2J+u+sUxZaKcCE78EuSggv-VOY7zEN_w@mail.gmail.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <650e26cf-e007-1e31-cd0a-4042bb9fa6a8@huawei.com>
Date:   Mon, 9 Dec 2019 22:12:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CADSWDzvFvS6mYiMhXu2J+u+sUxZaKcCE78EuSggv-VOY7zEN_w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/12/9 21:05, Beata Michalska wrote:
>> Here we set the FnV to not valid, not to set it to valid.
>> because Guest will use the physical address that recorded in APEI table.
>>
> To be precise : the FnV is  giving the status of FAR - so what you are setting
> here is status of 0b0 which means FAR is valid, not FnV on it's own.
> And my point was that you are changing the prototype for syn_data_abort_no_iss
> just for this case only so I was just thinking that it might not be
> worth that, instead
> you could just set it here ... or to be more flexible , provide a way
> to set specific bits
> on demand.

No, I set the FnV to 0b1, not 0b0, the whole esr_el1's value is 0x96000410, as shown below log:
I remember changing the prototype for syn_data_abort_no_iss is suggested by Peter Maydell.


[1]:
[   62.851830] Internal error: synchronous external abort: 96000410 [#1] PREEMPT SMP
[   62.854465] Modules linked in:



> 

