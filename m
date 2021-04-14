Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C12B35EE13
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 09:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349556AbhDNG73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 02:59:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:17330 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349592AbhDNG7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 02:59:14 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FKtYZ4WhCz9xGM;
        Wed, 14 Apr 2021 14:56:34 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 14:58:40 +0800
Subject: Re: [RFC PATCH v2 2/2] kvm/arm64: Try stage2 block mapping for host
 device MMIO
To:     Marc Zyngier <maz@kernel.org>
References: <20210316134338.18052-1-zhukeqian1@huawei.com>
 <20210316134338.18052-3-zhukeqian1@huawei.com> <878s5up71v.wl-maz@kernel.org>
 <9f74392b-1086-a85e-72d8-f7bd99d65ea7@huawei.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <f1d9f7c2-969f-336a-9744-5706d6c59298@huawei.com>
Date:   Wed, 14 Apr 2021 14:58:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <9f74392b-1086-a85e-72d8-f7bd99d65ea7@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2021/4/8 15:28, Keqian Zhu wrote:
> Hi Marc,
> 
> On 2021/4/7 21:18, Marc Zyngier wrote:
>> On Tue, 16 Mar 2021 13:43:38 +0000,
>> Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>>
[...]

>>>  
>>> +/*
>>> + * Find a mapping size that properly insides the intersection of vma and
>>> + * memslot. And hva and pa have the same alignment to this mapping size.
>>> + * It's rough because there are still other restrictions, which will be
>>> + * checked by the following fault_supports_stage2_huge_mapping().
>>
>> I don't think these restrictions make complete sense to me. If this is
>> a PFNMAP VMA, we should use the biggest mapping size that covers the
>> VMA, and not more than the VMA.
> But as described by kvm_arch_prepare_memory_region(), the memslot may not fully
> cover the VMA. If that's true and we just consider the boundary of the VMA, our
> block mapping may beyond the boundary of memslot. Is this a problem?
emm... Sorry I missed something. The fault_supports_stage2_huge_mapping() will check
the boundary of memslot, so we don't need to check it here. I have send v3, please
check that.

BRs,
Keqian
