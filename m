Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E46246386
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 11:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHQJjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 05:39:14 -0400
Received: from foss.arm.com ([217.140.110.172]:52092 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728434AbgHQJjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 05:39:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 247BE31B;
        Mon, 17 Aug 2020 02:39:06 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B62C43F6CF;
        Mon, 17 Aug 2020 02:39:04 -0700 (PDT)
Subject: Re: [PATCH 1/3] KVM: arm64: Some fixes of PV-time interface document
To:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-2-zhukeqian1@huawei.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <ee7e726a-324f-16d6-7888-508ce7a2e19d@arm.com>
Date:   Mon, 17 Aug 2020 10:39:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817033729.10848-2-zhukeqian1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/2020 04:37, Keqian Zhu wrote:
> Rename PV_FEATURES tp PV_TIME_FEATURES
                      ^^
Typos are sadly far too easy in documentation...

> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>   Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
> index 687b60d..94bffe2 100644
> --- a/Documentation/virt/kvm/arm/pvtime.rst
> +++ b/Documentation/virt/kvm/arm/pvtime.rst
> @@ -3,7 +3,7 @@
>   Paravirtualized time support for arm64
>   ======================================
>   
> -Arm specification DEN0057/A defines a standard for paravirtualised time
> +Arm specification DEN0057/A defines a standard for paravirtualized time
>   support for AArch64 guests:
>   
>   https://developer.arm.com/docs/den0057/a
> @@ -19,8 +19,8 @@ Two new SMCCC compatible hypercalls are defined:
>   
>   These are only available in the SMC64/HVC64 calling convention as
>   paravirtualized time is not available to 32 bit Arm guests. The existence of
> -the PV_FEATURES hypercall should be probed using the SMCCC 1.1 ARCH_FEATURES
> -mechanism before calling it.
> +the PV_TIME_FEATURES hypercall should be probed using the SMCCC 1.1
> +ARCH_FEATURES mechanism before calling it.
>   
>   PV_TIME_FEATURES
>       ============= ========    ==========
> 

