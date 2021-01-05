Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86492EA92A
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 11:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbhAEKtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 05:49:07 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10109 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727764AbhAEKtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 05:49:06 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D98Mj740dz15nlp;
        Tue,  5 Jan 2021 18:47:29 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 18:48:18 +0800
Subject: Re: [PATCH] arm64/smp: Remove unused variable irq in
 arch_show_interrupts()
To:     Catalin Marinas <catalin.marinas@arm.com>
References: <20210105092221.15144-1-zhukeqian1@huawei.com>
 <20210105100847.GB11802@gaia>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <ebbe8da6-bd81-f43c-8bda-cc302657d6f3@huawei.com>
Date:   Tue, 5 Jan 2021 18:48:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210105100847.GB11802@gaia>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/1/5 18:08, Catalin Marinas wrote:
> On Tue, Jan 05, 2021 at 05:22:21PM +0800, Keqian Zhu wrote:
>> The local variable irq is added in commit a26388152531 ("arm64:
>> Remove custom IRQ stat accounting"), but forget to remove in
>> commit 5089bc51f81f ("arm64/smp: Use irq_desc_kstat_cpu() in
>> arch_show_interrupts()"). Just remove it.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> 
> I already queued a similar fix in arm64 for-next/fixes (it should appear
> in linux-next at some point).
> 
OK, I see. Thanks.
