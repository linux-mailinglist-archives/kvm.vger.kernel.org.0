Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA674E88F
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 15:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfFUNIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 09:08:15 -0400
Received: from foss.arm.com ([217.140.110.172]:60162 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbfFUNIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 09:08:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F03B2142F;
        Fri, 21 Jun 2019 06:08:13 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C25193F246;
        Fri, 21 Jun 2019 06:08:06 -0700 (PDT)
Subject: Re: [PATCH 03/59] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-4-marc.zyngier@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <41b1ae35-5b48-7118-3d3e-e227af43010e@arm.com>
Date:   Fri, 21 Jun 2019 14:08:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-4-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/06/2019 10:37, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Add a new ARM64_HAS_NESTED_VIRT feature to indicate that the
> CPU has the ARMv8.3 nested virtualization capability.
> 
> This will be used to support nested virtualization in KVM.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  4 +++
>  arch/arm64/include/asm/cpucaps.h              |  3 ++-
>  arch/arm64/include/asm/sysreg.h               |  1 +
>  arch/arm64/kernel/cpufeature.c                | 26 +++++++++++++++++++
>  4 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 138f6664b2e2..202bb2115d83 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2046,6 +2046,10 @@
>  			[KVM,ARM] Allow use of GICv4 for direct injection of
>  			LPIs.
>  
> +	kvm-arm.nested=
> +			[KVM,ARM] Allow nested virtualization in KVM/ARM.
> +			Default is 0 (disabled)
> +

Once the kernel has been built with nested guest support, what do we
gain from having it disabled by default?

It seems a bit odd since the guests have to opt-in for the capability of
running guests of their own.

Is it it likely to have negative impact a negative impact on the host
kernel? Or on guests that do not request use of nested virt?

If not I feel that this kernel parameter should be dropped.

Cheers,

-- 
Julien Thierry
