Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2648232C6A7
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451066AbhCDA3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:47 -0500
Received: from foss.arm.com ([217.140.110.172]:53200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1386023AbhCCRd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 12:33:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFF7A31B;
        Wed,  3 Mar 2021 09:32:39 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6C2C3F7D7;
        Wed,  3 Mar 2021 09:32:38 -0800 (PST)
Date:   Wed, 3 Mar 2021 17:32:34 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 4/6] lib: arm64: Consolidate register
 definitions to sysreg.h
Message-ID: <20210303173234.6d6cec51@slackpad.fritz.box>
In-Reply-To: <20210227104201.14403-5-alexandru.elisei@arm.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
        <20210227104201.14403-5-alexandru.elisei@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 27 Feb 2021 10:41:59 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Move system register field definitions to sysreg.h, where the opcodes for
> system register access are defined, to align ourselves with the Linux
> kernel. EL2 support, needed for EFI and nested virtualization testing, will
> require additional register and field definions, and having them in the
> same place as Linux will make maintenance easier.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Checked to be just moves, and it compiles, so:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  lib/arm64/asm/arch_gicv3.h |  6 ------
>  lib/arm64/asm/processor.h  | 10 ----------
>  lib/arm64/asm/sysreg.h     | 17 +++++++++++++++++
>  arm/cstart64.S             |  2 +-
>  4 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
> index a7994ec2fbbe..fdee4de1f1f6 100644
> --- a/lib/arm64/asm/arch_gicv3.h
> +++ b/lib/arm64/asm/arch_gicv3.h
> @@ -10,12 +10,6 @@
>  
>  #include <asm/sysreg.h>
>  
> -#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
> -#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
> -#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> -#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
> -#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
> -
>  #ifndef __ASSEMBLY__
>  
>  #include <libcflat.h>
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index cdc2463e1981..4a3d826ab560 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -6,16 +6,6 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  
> -/* System Control Register (SCTLR_EL1) bits */
> -#define SCTLR_EL1_EE	(1 << 25)
> -#define SCTLR_EL1_WXN	(1 << 19)
> -#define SCTLR_EL1_I	(1 << 12)
> -#define SCTLR_EL1_SA0	(1 << 4)
> -#define SCTLR_EL1_SA	(1 << 3)
> -#define SCTLR_EL1_C	(1 << 2)
> -#define SCTLR_EL1_A	(1 << 1)
> -#define SCTLR_EL1_M	(1 << 0)
> -
>  #ifndef __ASSEMBLY__
>  #include <asm/ptrace.h>
>  #include <asm/esr.h>
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index 378bf7ebb3b5..9d6b4fc66936 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -70,4 +70,21 @@ asm(
>  "	.endm\n"
>  );
>  #endif /* __ASSEMBLY__ */
> +
> +#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
> +#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
> +#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> +#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
> +#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
> +
> +/* System Control Register (SCTLR_EL1) bits */
> +#define SCTLR_EL1_EE	(1 << 25)
> +#define SCTLR_EL1_WXN	(1 << 19)
> +#define SCTLR_EL1_I	(1 << 12)
> +#define SCTLR_EL1_SA0	(1 << 4)
> +#define SCTLR_EL1_SA	(1 << 3)
> +#define SCTLR_EL1_C	(1 << 2)
> +#define SCTLR_EL1_A	(1 << 1)
> +#define SCTLR_EL1_M	(1 << 0)
> +
>  #endif /* _ASMARM64_SYSREG_H_ */
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index c1deff842f03..f6c5d2ebccf3 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -10,9 +10,9 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/assembler.h>
>  #include <asm/ptrace.h>
> -#include <asm/processor.h>
>  #include <asm/page.h>
>  #include <asm/pgtable-hwdef.h>
> +#include <asm/sysreg.h>
>  
>  .section .init
>  

