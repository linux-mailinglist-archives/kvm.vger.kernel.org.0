Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3752464F5
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 12:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgHQK4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 06:56:43 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727021AbgHQK4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 06:56:35 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EA7F5FA70E4499864175;
        Mon, 17 Aug 2020 18:56:31 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 18:56:26 +0800
Subject: Re: [PATCH 2/3] KVM: uapi: Remove KVM_DEV_TYPE_ARM_PV_TIME in
 kvm_device_type
To:     Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-3-zhukeqian1@huawei.com>
 <f97633b4a39c301f916bb76030dcabf0@kernel.org>
 <4cd543a2-4d5b-882c-38d6-f5055512f0dc@huawei.com>
 <72e34f84-5bea-8f69-6699-29e2970c80b4@arm.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <40a10c89-d876-5aea-dd45-b7e75ef31c71@huawei.com>
Date:   Mon, 17 Aug 2020 18:56:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <72e34f84-5bea-8f69-6699-29e2970c80b4@arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steven,

On 2020/8/17 17:49, Steven Price wrote:
> On 17/08/2020 09:43, zhukeqian wrote:
>> Hi Marc,
>>
[...]
>>>
>>> It is pretty unfortunate that PV time has turned into such a train wreck,
>>> but that's what we have now, and it has to stay.
>> Well, I see. It is a sad thing indeed.
> 
> Sorry about that, this got refactored so many times I guess I lost track of what was actually needed and this hunk remained when it should have been removed.
> 
It's fine :-) , not a serious problem.
> I would hope that I'm the only one who has any userspace code which uses this, but I guess we should still be cautious since this has been in several releases now.
> 
OK. For insurance purposes, we ought to ignore this patch to avoid breaking any user-space program.
> Steve
> .
Thanks,
Keqian
> 
