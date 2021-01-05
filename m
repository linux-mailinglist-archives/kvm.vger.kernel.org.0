Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADA62EA990
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 12:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbhAELJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 06:09:46 -0500
Received: from foss.arm.com ([217.140.110.172]:52806 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727764AbhAELJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 06:09:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EB131FB;
        Tue,  5 Jan 2021 03:09:00 -0800 (PST)
Received: from [10.163.89.46] (unknown [10.163.89.46])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A4C113F70D;
        Tue,  5 Jan 2021 03:08:55 -0800 (PST)
Subject: Re: [PATCH] arm64/smp: Remove unused variable irq in
 arch_show_interrupts()
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        wanghaibin.wang@huawei.com, Will Deacon <will@kernel.org>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>
References: <20210105092221.15144-1-zhukeqian1@huawei.com>
 <20210105100847.GB11802@gaia>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <8deed54d-d184-69b8-fce9-d87128a7d880@arm.com>
Date:   Tue, 5 Jan 2021 16:39:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210105100847.GB11802@gaia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/5/21 3:38 PM, Catalin Marinas wrote:
> On Tue, Jan 05, 2021 at 05:22:21PM +0800, Keqian Zhu wrote:
>> The local variable irq is added in commit a26388152531 ("arm64:
>> Remove custom IRQ stat accounting"), but forget to remove in
>> commit 5089bc51f81f ("arm64/smp: Use irq_desc_kstat_cpu() in
>> arch_show_interrupts()"). Just remove it.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> 
> I already queued a similar fix in arm64 for-next/fixes (it should appear
> in linux-next at some point)

I too sent this fix yesterday as well :) as it was preventing a clean
build on v5.11-rc2. Missed to check this on arm64 for-next/fixes though
I did check on linux-next.
