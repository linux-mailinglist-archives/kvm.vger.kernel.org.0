Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FE4308C21
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 19:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhA2SGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 13:06:39 -0500
Received: from foss.arm.com ([217.140.110.172]:52346 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231381AbhA2SG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 13:06:26 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B77713A1;
        Fri, 29 Jan 2021 10:05:40 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48D333F885;
        Fri, 29 Jan 2021 10:05:38 -0800 (PST)
Date:   Fri, 29 Jan 2021 18:04:52 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v3 05/66] KVM: arm64: nv: Add EL2 system registers to
 vcpu context
Message-ID: <20210129180452.6d527e91@slackpad.fritz.box>
In-Reply-To: <20201210160002.1407373-6-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
 <20201210160002.1407373-6-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Dec 2020 15:59:01 +0000
Marc Zyngier <maz@kernel.org> wrote:

Hi,

> Add the minimal set of EL2 system registers to the vcpu context.
> Nothing uses them just yet.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Checked against the ARM ARM that this list contains the _EL2 registers
available in ARMv8.1, minus timer and GIC registers.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre 

> ---
>  arch/arm64/include/asm/kvm_host.h | 34 ++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 11beda85ee7e..d731cf7a56cb 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -206,12 +206,44 @@ enum vcpu_sysreg {
>  	CNTP_CVAL_EL0,
>  	CNTP_CTL_EL0,
>  
> -	/* 32bit specific registers. Keep them at the end of the range */
> +	/* 32bit specific registers. */
>  	DACR32_EL2,	/* Domain Access Control Register */
>  	IFSR32_EL2,	/* Instruction Fault Status Register */
>  	FPEXC32_EL2,	/* Floating-Point Exception Control Register */
>  	DBGVCR32_EL2,	/* Debug Vector Catch Register */
>  
> +	/* EL2 registers */
> +	VPIDR_EL2,	/* Virtualization Processor ID Register */
> +	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
> +	SCTLR_EL2,	/* System Control Register (EL2) */
> +	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
> +	HCR_EL2,	/* Hypervisor Configuration Register */
> +	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
> +	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
> +	HSTR_EL2,	/* Hypervisor System Trap Register */
> +	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
> +	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
> +	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
> +	TCR_EL2,	/* Translation Control Register (EL2) */
> +	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
> +	VTCR_EL2,	/* Virtualization Translation Control Register */
> +	SPSR_EL2,	/* EL2 saved program status register */
> +	ELR_EL2,	/* EL2 exception link register */
> +	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
> +	AFSR1_EL2,	/* Auxiliary Fault Status Register 1 (EL2) */
> +	ESR_EL2,	/* Exception Syndrome Register (EL2) */
> +	FAR_EL2,	/* Hypervisor IPA Fault Address Register */
> +	HPFAR_EL2,	/* Hypervisor IPA Fault Address Register */
> +	MAIR_EL2,	/* Memory Attribute Indirection Register (EL2) */
> +	AMAIR_EL2,	/* Auxiliary Memory Attribute Indirection Register (EL2) */
> +	VBAR_EL2,	/* Vector Base Address Register (EL2) */
> +	RVBAR_EL2,	/* Reset Vector Base Address Register */
> +	RMR_EL2,	/* Reset Management Register */
> +	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
> +	TPIDR_EL2,	/* EL2 Software Thread ID Register */
> +	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
> +	SP_EL2,		/* EL2 Stack Pointer */
> +
>  	NR_SYS_REGS	/* Nothing after this line! */
>  };
>  

