Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2868016A027
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 09:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgBXIiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 03:38:11 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:47246 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726216AbgBXIiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 03:38:11 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2F8C1EA6E341EB8B89D9;
        Mon, 24 Feb 2020 16:38:09 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Mon, 24 Feb 2020
 16:38:02 +0800
Subject: Re: [PATCH v24 00/10] Add ARMv8 RAS virtualization support in QEMU
To:     Peter Maydell <peter.maydell@linaro.org>
CC:     Fam Zheng <fam@euphon.net>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        James Morse <james.morse@arm.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Igor Mammedov" <imammedo@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        "Richard Henderson" <rth@twiddle.net>
References: <20200217131248.28273-1-gengdongjiu@huawei.com>
 <CAFEAcA9xd8fHiigZFFM7Symh0Mkm-jQ_aGJ7ifRCrXZvFY4DqQ@mail.gmail.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <acd194e5-81d8-afa7-fb6d-6b7d744b5d81@huawei.com>
Date:   Mon, 24 Feb 2020 16:37:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9xd8fHiigZFFM7Symh0Mkm-jQ_aGJ7ifRCrXZvFY4DqQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/2/21 22:09, Peter Maydell wrote:
> On Mon, 17 Feb 2020 at 13:10, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>>
>> In the ARMv8 platform, the CPU error types includes synchronous external abort(SEA) and SError Interrupt (SEI). If exception happens in guest, host does not know the detailed information of guest, so it is expected that guest can do the recovery.
>> For example, if an exception happens in a guest user-space application, host does
>> not know which application encounters errors, only guest knows it.
>>
>> For the ARMv8 SEA/SEI, KVM or host kernel delivers SIGBUS to notify userspace.
>> After user space gets the notification, it will record the CPER into guest GHES
>> buffer and inject an exception or IRQ to guest.
>>
>> In the current implementation, if the type of SIGBUS is BUS_MCEERR_AR, we will
>> treat it as a synchronous exception, and notify guest with ARMv8 SEA
>> notification type after recording CPER into guest.
> 
> Hi; I have reviewed the remaining arm bit of this series (patch 9),
> and made some comments on patch 1. Still to be reviewed are
> patches 4, 5, 6, 8: I'm going to assume that Michael or Igor
> will look at those.

Thanks very much for Peter's review.
Michael/Igor, hope you can review patches 4, 5, 6, 8, thank you very much in advance.


> 
> thanks
> -- PMM
> 
> .
> 

