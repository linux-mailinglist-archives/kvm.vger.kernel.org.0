Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A25C9CE7
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 13:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfJCLLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 07:11:04 -0400
Received: from foss.arm.com ([217.140.110.172]:41718 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfJCLLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 07:11:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 426411000;
        Thu,  3 Oct 2019 04:11:03 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 245143F706;
        Thu,  3 Oct 2019 04:11:02 -0700 (PDT)
Subject: Re: [PATCH 5/5] arm64: Enable and document ARM errata 1319367 and
 1319537
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20190925111941.88103-1-maz@kernel.org>
 <20190925111941.88103-6-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <6d41efac-3606-328a-0a18-f86ed070932c@arm.com>
Date:   Thu, 3 Oct 2019 12:11:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190925111941.88103-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 25/09/2019 12:19, Marc Zyngier wrote:
> Now that everything is in place, let's get the ball rolling
> by allowing the corresponding config option to be selected.
> Also add the required information to silicon_arrata.rst.

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 3adcec05b1f6..c50cd4f83bc4 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -523,6 +523,16 @@ config ARM64_ERRATUM_1286807
>  	  invalidated has been observed by other observers. The
>  	  workaround repeats the TLBI+DSB operation.
>  
> +config ARM64_ERRATUM_1319367
> +	bool "Cortex-A57/A72: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
> +	default y
> +	help
> +	  This option adds work arounds for ARM Cortex-A57 erratum 1319537
> +	  and A72 erratum 1319367
> +
> +	  Cortex-A57 and A72 cores could end-up with corrupted TLBs by
> +	  speculating an AT instruction during a guest context switch.
> +
>  	  If unsure, say Y.
>  
>  config ARM64_ERRATUM_1463225
> 

Nit: You pinched someone elses "If unsure, say Y."!



Thanks,

James
