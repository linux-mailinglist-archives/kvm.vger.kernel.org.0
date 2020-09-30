Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03A027DDAF
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 03:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgI3BVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 21:21:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14784 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729179AbgI3BVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 21:21:43 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1D670E2F40661DD61525;
        Wed, 30 Sep 2020 09:21:41 +0800 (CST)
Received: from [10.174.187.69] (10.174.187.69) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 30 Sep 2020 09:21:31 +0800
Subject: Re: [RFC PATCH 0/4] Add support for ARMv8.6 TWED feature
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <will@kernel.org>,
        <catalin.marinas@arm.com>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <yezengruan@huawei.com>,
        <shameerali.kolothum.thodi@huawei.com>, <fanhenglong@huawei.com>,
        <prime.zeng@hisilicon.com>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
 <913250ae919fb9453feadd0527827d55@kernel.org>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <21241889-7fca-5cd3-a5d3-41eb34f9c960@huawei.com>
Date:   Wed, 30 Sep 2020 09:21:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <913250ae919fb9453feadd0527827d55@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 9/29/2020 6:50 PM, Marc Zyngier wrote:
> On 2020-09-29 10:17, Jingyi Wang wrote:
>> TWE Delay is an optional feature in ARMv8.6 Extentions. There is a
>> performance benefit in waiting for a period of time for an event to
>> arrive before taking the trap as it is common that event will arrive
>> “quite soon” after executing the WFE instruction.
> 
> Define "quite soon". Quantify "performance benefits". Which are the
> workloads that actually benefit from this imitation of the x86 PLE?
> 
> I was opposed to this when the spec was drafted, and I still am given
> that there is zero supporting evidence that it bring any gain over
> immediate trapping in an oversubscribed environment (which is the only
> case where it matters).
> 
> Thanks,
> 
>          M.

Sure, I will do more performance tests and post the results as soon as
possible.

Thanks,
Jingyi
