Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14180211FE4
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 11:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgGBJ3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 05:29:43 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49470 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgGBJ3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 05:29:43 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D307FD1A9224D1FEB8AD;
        Thu,  2 Jul 2020 17:29:40 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Jul 2020
 17:29:38 +0800
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
To:     Marc Zyngier <maz@kernel.org>
CC:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <fe9699e3ee2131fe800911aea1425af4@kernel.org>
 <a570c59c-965f-8832-b0c3-4cfc342f18fe@huawei.com>
 <10c3562dc019a3440d82dd507918faef@kernel.org>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <3a1533a5-bf93-4ce9-2e5c-a5c0da4cc0cc@huawei.com>
Date:   Thu, 2 Jul 2020 17:29:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <10c3562dc019a3440d82dd507918faef@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/2/2020 5:17 PM, Marc Zyngier wrote:
> On 2020-07-02 10:02, Jingyi Wang wrote:
>> Hi Marc,
>>
>> On 7/2/2020 4:22 PM, Marc Zyngier wrote:
>>> On 2020-07-02 04:01, Jingyi Wang wrote:
>>>> If gicv4.1(sgi hardware injection) supported, we test ipi injection
>>>> via hw/sw way separately.
>>>
>>> nit: active-less SGIs are not strictly a feature of GICv4.1 (you could
>>> imagine a GIC emulation offering the same thing). Furthermore, GICv4.1
>>> isn't as such visible to the guest itself (it only sees a GICv3).
>>>
>>> Thanks,
>>>
>>>          M.
>>
>> Yes, but to measure the performance difference of hw/sw SGI injection,
>> do you think it is acceptable to make it visible to guest and let it
>> switch SGI injection mode?
> 
> It is of course acceptable. I simply object to the "GICv4.1" description.
> 
>          M.

Okay, maybe description like "GICv4.1 supported kvm" is better.

Thanks,
Jingyi

