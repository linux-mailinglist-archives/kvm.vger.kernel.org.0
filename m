Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7FB10F4D0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 03:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfLCCKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 21:10:11 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbfLCCKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 21:10:11 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AE02B229EEBA8B584857;
        Tue,  3 Dec 2019 10:10:09 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Dec 2019
 10:10:03 +0800
Subject: Re: [RESEND PATCH v21 0/6] Add ARMv8 RAS virtualization support in
 QEMU
To:     Peter Maydell <peter.maydell@linaro.org>,
        Xiang Zheng <zhengxiang9@huawei.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Richard Henderson" <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <CAFEAcA96Pk_d_T2=GL-QyEBwEXC2fV89K=5h4nEtSHUL0VKZQg@mail.gmail.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <2fc18991-ecc7-a59f-c0ec-a39786e2dbf9@huawei.com>
Date:   Tue, 3 Dec 2019 10:09:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA96Pk_d_T2=GL-QyEBwEXC2fV89K=5h4nEtSHUL0VKZQg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/12/3 2:27, Peter Maydell wrote:
>> application within guest, host does not know which application encounters
>> errors.
>>
>> For the ARMv8 SEA/SEI, KVM or host kernel delivers SIGBUS to notify userspace.
>> After user space gets the notification, it will record the CPER into guest GHES
>> buffer and inject an exception or IRQ into guest.
>>
>> In the current implementation, if the type of SIGBUS is BUS_MCEERR_AR, we will
>> treat it as a synchronous exception, and notify guest with ARMv8 SEA
>> notification type after recording CPER into guest.
> Hi; I've given you reviewed-by tags on a couple of patches; other
> people have given review comments on some of the other patches,
> so I think you have enough to do a v22 addressing those.
Thanks very much for the reviewed-by tags,  we will upload v22.


> > thanks
> -- PMM
> .
> 

