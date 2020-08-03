Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16614239D6E
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 04:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgHCCPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Aug 2020 22:15:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9319 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725820AbgHCCPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 22:15:19 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 66B73CAFDBFEB9A71E88;
        Mon,  3 Aug 2020 10:15:17 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 3 Aug 2020
 10:15:06 +0800
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
To:     Andrew Jones <drjones@redhat.com>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <prime.zeng@hisilicon.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <20200731120117.5kk22hx2wpbt6kpz@kamzik.brq.redhat.com>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <b5263ff5-385f-cf03-33bd-3d4efd3bcdab@huawei.com>
Date:   Mon, 3 Aug 2020 10:15:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200731120117.5kk22hx2wpbt6kpz@kamzik.brq.redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/31/2020 8:01 PM, Andrew Jones wrote:
> On Fri, Jul 31, 2020 at 03:42:34PM +0800, Jingyi Wang wrote:
>> With the development of arm gic architecture, we think it will be useful
>> to add some performance test in kut to measure the cost of interrupts.
>> In this series, we add GICv4.1 support for ipi latency test and
>> implement LPI/vtimer latency test.
>>
>> This series of patches has been tested on GICv4.1 supported hardware.
>>
>> Note:
>> Based on patch "arm/arm64: timer: Extract irqs at setup time",
>> https://www.spinics.net/lists/kvm-arm/msg41425.html
>>
>> * From v2:
>>    - Code and commit message cleanup
>>    - Clear nr_ipi_received before ipi_exec() thanks for Tao Zeng's review
>>    - rebase the patch "Add vtimer latency test" on Andrew's patch
> 
> It'd be good if you'd reposted my patch along with this series, since we
> didn't merge mine yet either. Don't worry about now, though, I'll pick it
> up the same time I pick up this series, which I plan to do later today
> or tomorrow.
> 
> Getting this series applied will allow me to try out our new and shiny
> gitlab repo :-)
> 
> Thanks,
> drew
> 

Thanks for your reviewing and fix.

>>    - Add test->post() to get actual PPI latency
>>
>> * From v1:
>>    - Fix spelling mistake
>>    - Use the existing interface to inject hw sgi to simply the logic
>>    - Add two separate patches to limit the running times and time cost
>>      of each individual micro-bench test
>>
>> Jingyi Wang (10):
>>    arm64: microbench: get correct ipi received num
>>    arm64: microbench: Generalize ipi test names
>>    arm64: microbench: gic: Add ipi latency test for gicv4.1 support kvm
>>    arm64: its: Handle its command queue wrapping
>>    arm64: microbench: its: Add LPI latency test
>>    arm64: microbench: Allow each test to specify its running times
>>    arm64: microbench: Add time limit for each individual test
>>    arm64: microbench: Add vtimer latency test
>>    arm64: microbench: Add test->post() to further process test results
>>    arm64: microbench: Add timer_post() to get actual PPI latency
>>
>>   arm/micro-bench.c          | 256 ++++++++++++++++++++++++++++++-------
>>   lib/arm/asm/gic-v3.h       |   3 +
>>   lib/arm/asm/gic.h          |   1 +
>>   lib/arm64/gic-v3-its-cmd.c |   3 +-
>>   4 files changed, 219 insertions(+), 44 deletions(-)
>>
>> -- 
>> 2.19.1
>>
>>
> 
> 
> .
> 

