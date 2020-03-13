Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3D5183EE2
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 02:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCMBzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 21:55:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60566 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726194AbgCMBzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 21:55:42 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3CC268047441D80DBB2B;
        Fri, 13 Mar 2020 09:55:38 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 13 Mar 2020
 09:55:31 +0800
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
To:     Auger Eric <eric.auger@redhat.com>
CC:     Marc Zyngier <maz@kernel.org>, <eric.auger.pro@gmail.com>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <drjones@redhat.com>, <andre.przywara@arm.com>,
        <peter.maydell@linaro.org>, <alexandru.elisei@arm.com>,
        <thuth@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
 <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
 <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
 <301a8b402ff7e480e927b0f8f8b093f2@kernel.org>
 <7fb9f81f-6520-526d-7031-d3d08cb1dd6a@huawei.com>
 <acc652b7-f331-1e48-160c-f07e0e5283b3@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <160015aa-f5d7-2fdc-8d06-1322af241896@huawei.com>
Date:   Fri, 13 Mar 2020 09:55:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <acc652b7-f331-1e48-160c-f07e0e5283b3@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/3/12 17:59, Auger Eric wrote:
> Hi Zenghui,
> 
> On 3/12/20 10:19 AM, Zenghui Yu wrote:
>> On 2020/3/11 22:00, Marc Zyngier wrote:
>>> That is still a problem with the ITS. There is no architectural way
>>> to report an error, even if the error numbers are architected...
>>>
>>> One thing we could do though is to implement the stall model (as
>>> described
>>> in 5.3.2). It still doesn't give us the error, but at least the command
>>> queue would stop on detecting an error.
>>
>> It would be interesting to see the buggy guest's behavior under the
>> stall mode. I've used the following diff (absolutely *not* a formal
>> patch, don't handle CREADR.Stalled and CWRITER.Retry at all) to have
>> a try, and caught another command error in the 'its-trigger' test.
>>
>> logs/its-trigger.log:
>> " INT dev_id=2 event_id=20
>> lib/arm64/gic-v3-its-cmd.c:194: assert failed: false: INT timeout! "
>>
>> dmesg:
>> [13297.711958] ------------[ cut here ]------------
>> [13297.711964] ITS command error encoding 0x10307
>>
>> It's the last INT test in test_its_trigger() who has triggered this
>> error, Eric?
> 
> Yes it may be the culprit. Anyway I removed the collection unmap in v6.

I forgot to mention that this is based on your v6. I'll reply to it.

> 
> By the way are you OK now with v6? I think Drew plans to send a pull
> request by the end of this week.

Sorry I haven't looked at it yet (v5 already looks good except for
some minor issues).


Thanks,
Zenghui

