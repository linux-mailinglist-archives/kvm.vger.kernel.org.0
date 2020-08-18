Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81C8247BEE
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 03:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHRBlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 21:41:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49702 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbgHRBlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 21:41:12 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D5BE16434618C83809CA;
        Tue, 18 Aug 2020 09:41:06 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 18 Aug 2020 09:40:56 +0800
Subject: Re: [PATCH 1/2] clocksource: arm_arch_timer: Simplify and fix count
 reader code logic
To:     Marc Zyngier <maz@kernel.org>
References: <20200817122415.6568-1-zhukeqian1@huawei.com>
 <20200817122415.6568-2-zhukeqian1@huawei.com>
 <267c5f9151c39fd2dcd0ce0b09d96545@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <2093b7c1-6ef4-c0ff-e9df-1f493fccdda8@huawei.com>
Date:   Tue, 18 Aug 2020 09:40:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <267c5f9151c39fd2dcd0ce0b09d96545@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/8/17 20:52, Marc Zyngier wrote:
> On 2020-08-17 13:24, Keqian Zhu wrote:
>> In commit 0ea415390cd3 (clocksource/arm_arch_timer: Use arch_timer_read_counter
>> to access stable counters), we separate stable and normal count reader. Actually
>> the stable reader can correctly lead us to normal reader if we has no
>> workaround.
> 
> Resulting in an unnecessary overhead on non-broken systems that can run
> without CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND. Not happening.
OK, so I got the purpose of that patch wrong.
> 
>> Besides, in erratum_set_next_event_tval_generic(), we use normal reader, it is
>> obviously wrong, so just revert this commit to solve this problem by the way.
> 
> If you want to fix something, post a patch that does exactly that.
> 
I will.

Thanks,
Keqian
>         M.
