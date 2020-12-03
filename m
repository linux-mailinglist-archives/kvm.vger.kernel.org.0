Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08542CD8D6
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 15:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730866AbgLCOTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 09:19:00 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8629 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgLCOTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 09:19:00 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CmybY5N94z15VPL;
        Thu,  3 Dec 2020 22:17:45 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Dec 2020 22:18:03 +0800
Subject: Re: [PATCH v2 0/2] clocksource: arm_arch_timer: Some fixes
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
References: <20200818032814.15968-1-zhukeqian1@huawei.com>
CC:     Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
        "Andrew Jones" <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <will@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <63334212-e151-07f4-ccf6-63eedaaf33bc@huawei.com>
Date:   Thu, 3 Dec 2020 22:18:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200818032814.15968-1-zhukeqian1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Found that this bugfix series is not applied for now.
Does it need some modification? Wish you can pick it up :-)

Thanks,
Keqian

On 2020/8/18 11:28, Keqian Zhu wrote:
> change log:
> 
> v2:
>  - Do not revert commit 0ea415390cd3, fix it instead.
>  - Correct the tags of second patch.
> 
> Keqian Zhu (2):
>   clocksource: arm_arch_timer: Use stable count reader in erratum sne
>   clocksource: arm_arch_timer: Correct fault programming of
>     CNTKCTL_EL1.EVNTI
> 
>  drivers/clocksource/arm_arch_timer.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
