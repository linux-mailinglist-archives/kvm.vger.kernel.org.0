Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8312CD8D0
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 15:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbgLCORf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 09:17:35 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8999 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgLCORe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 09:17:34 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CmyZ16TdSzhm1Q;
        Thu,  3 Dec 2020 22:16:25 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Dec 2020 22:16:43 +0800
Subject: Re: [PATCH v2 0/2] KVM: arm64: Some fixes and code adjustments for
 pvtime ST
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
References: <20200817110728.12196-1-zhukeqian1@huawei.com>
CC:     Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
        "Andrew Jones" <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <will@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <a87412a0-e0ca-d344-550a-91690ce3a612@huawei.com>
Date:   Thu, 3 Dec 2020 22:16:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200817110728.12196-1-zhukeqian1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Found that this series is not applied for now.
Does it need some modification? Wish you can pick it up :-)

Thanks,
Keqian

On 2020/8/17 19:07, Keqian Zhu wrote:
> During picking up pvtime LPT support for arm64, I do some trivial fixes for
> pvtime ST.
> 
> change log:
> 
> v2:
>  - Add Andrew's and Steven's R-b.
>  - Correct commit message of the first patch.
>  - Drop the second patch.
> 
> Keqian Zhu (2):
>   KVM: arm64: Some fixes of PV-time interface document
>   KVM: arm64: Use kvm_write_guest_lock when init stolen time
> 
>  Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
>  arch/arm64/kvm/pvtime.c               | 6 +-----
>  2 files changed, 4 insertions(+), 8 deletions(-)
> 
