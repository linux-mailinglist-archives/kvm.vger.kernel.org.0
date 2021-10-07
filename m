Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AD94254CC
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 15:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241881AbhJGNzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 09:55:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241853AbhJGNzF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 09:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633614791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OCnUFCDFWcoWZv9I+WDnAKonvZ48CTfwyEqTI4QgXnI=;
        b=XRGFsxOUlL9+2m8iry7bnQ62d5LM6CsyYuF+gd6srphqY1EIQ3M5Yf/74OQz/Z9tLFc59M
        n5Oqi7+It6SO3rHCgxWyL6UQYt4iyJwuDk4ZBrCREvbLbo/R9WgznvnZodFD5AmfHvqCkc
        x9aiJX57YMdrKDTgwarq28MLCKdscgk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-ZUVEjNTpPUGrsERu1eNpZQ-1; Thu, 07 Oct 2021 09:53:08 -0400
X-MC-Unique: ZUVEjNTpPUGrsERu1eNpZQ-1
Received: by mail-qv1-f69.google.com with SMTP id if11-20020a0562141c4b00b0038317257571so4918452qvb.3
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 06:53:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OCnUFCDFWcoWZv9I+WDnAKonvZ48CTfwyEqTI4QgXnI=;
        b=1wW3Yi6plkvQVjegjII5pqWl83A2NpPyVRaX50+l3am/ZKQiO5AkCuoxgVozmz2Egm
         NjdhoLEY9CAhEzJwU2cdylXkUX0yxXLG3rEcjwVkMv+vCfqGS9o88n6lThfdUNJWafcR
         KpTvnAQ8mlVeZRpua0KXIpnELjA6I0UokOGPduXeteay3b1hJ6YrZpB1CoWLIZ83mZeS
         Q5XNV4w8z1Q3koSzzbDBJCdI6sSq5TS3YpKC+RYq4FHsL/HdPsbqkq1DnPBm8DY/9Qmd
         noiyjJzbEC3TsbGHAib/Mn1APlG9/veosG7/n47S52Bpbp7aFNlANHwNMdqrXYoWdRYq
         U8cA==
X-Gm-Message-State: AOAM531q4BQd8cDvw/vL1y2bLrYGVom7N6s9rp0GNptVd7MzbD+IpXnt
        7e2yoZ0chHrWYf7NkhEeFU3uCsObGBsPMx+NGwVyBtAV8CQvHWwyiPSMxpUPG5f9Ya7jwAruPni
        eCgtb0BclwaUH
X-Received: by 2002:ac8:404f:: with SMTP id j15mr5067188qtl.361.1633614788500;
        Thu, 07 Oct 2021 06:53:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQr9CRm+JNFfKdbw14ykOPjUDm4MfkE8BuAkCsB288O/A4ZkxEiEofqmPBzACzDam2GSnZUg==
X-Received: by 2002:ac8:404f:: with SMTP id j15mr5067165qtl.361.1633614788323;
        Thu, 07 Oct 2021 06:53:08 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id x79sm13881345qkb.65.2021.10.07.06.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:53:07 -0700 (PDT)
Date:   Thu, 7 Oct 2021 15:53:03 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 07/16] KVM: arm64: Wire MMIO guard hypercalls
Message-ID: <20211007135303.rbyvltetm3h4sqyy@gator>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-8-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004174849.2831548-8-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:48:40PM +0100, Marc Zyngier wrote:
> Plumb in the hypercall interface to allow a guest to discover,
> enroll, map and unmap MMIO regions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hypercalls.c | 28 ++++++++++++++++++++++++++++
>  include/linux/arm-smccc.h   | 28 ++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 30da78f72b3b..c39aab55ecae 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -5,6 +5,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>  
>  #include <kvm/arm_hypercalls.h>
>  #include <kvm/arm_psci.h>
> @@ -129,10 +130,37 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>  		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> +		/* Only advertise MMIO guard to 64bit guests */
> +		if (!vcpu_mode_is_32bit(vcpu)) {
> +			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO);
> +			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL);
> +			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP);
> +			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP);
> +		}
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>  		kvm_ptp_get_time(vcpu, val);
>  		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_INFO_FUNC_ID:
> +		if (!vcpu_mode_is_32bit(vcpu))
> +			val[0] = PAGE_SIZE;
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID:
> +		if (!vcpu_mode_is_32bit(vcpu)) {
> +			set_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags);
> +			val[0] = SMCCC_RET_SUCCESS;
> +		}
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID:
> +		if (!vcpu_mode_is_32bit(vcpu) &&
> +		    kvm_install_ioguard_page(vcpu, vcpu_get_reg(vcpu, 1)))
> +			val[0] = SMCCC_RET_SUCCESS;
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID:
> +		if (!vcpu_mode_is_32bit(vcpu) &&
> +		    kvm_remove_ioguard_page(vcpu, vcpu_get_reg(vcpu, 1)))
> +			val[0] = SMCCC_RET_SUCCESS;
> +		break;

Since these are all ARM_SMCCC_SMC_64 calls, can we do some sort of
refactoring first, similar to Oliver's "KVM: arm64: Clean up SMC64 PSCI
filtering for AArch32 guests", which would avoid the need for all the
!vcpu_mode_is_32bit's?

>  	case ARM_SMCCC_TRNG_VERSION:
>  	case ARM_SMCCC_TRNG_FEATURES:
>  	case ARM_SMCCC_TRNG_GET_UUID:
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 7d1cabe15262..4aab2078d8d3 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -107,6 +107,10 @@
>  /* KVM "vendor specific" services */
>  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
>  #define ARM_SMCCC_KVM_FUNC_PTP			1
> +#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO	2
> +#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL	3
> +#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP	4
> +#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP	5
>  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
>  #define ARM_SMCCC_KVM_NUM_FUNCS			128
>  
> @@ -133,6 +137,30 @@
>  #define KVM_PTP_VIRT_COUNTER			0
>  #define KVM_PTP_PHYS_COUNTER			1
>  
> +#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_INFO_FUNC_ID		\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_64,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO)
> +
> +#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID		\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_64,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL)
> +
> +#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID			\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_64,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP)
> +
> +#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID		\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_64,				\
> +			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
> +			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP)
> +
>  /* Paravirtualised time calls (defined by ARM DEN0057A) */
>  #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
>  	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> -- 
> 2.30.2
>

Besides the refactoring suggestion,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

