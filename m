Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92757694BD3
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 16:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjBMP4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 10:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbjBMP4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 10:56:00 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A7E1F480;
        Mon, 13 Feb 2023 07:55:48 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id t7so3688689ilq.2;
        Mon, 13 Feb 2023 07:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+TZfyO96MuT6z1hpaU/81N8W1L7K7DdH8/8YCsn0po=;
        b=cPyl1tdDXZ5qYnw44R9BEJT8bydv2rE67zAHJcwa0Gjm/AAQihVKqXkGJ+WEMdvVBm
         t+rjMBR4VcGYJ4VNQekZJVijsjkK+EdlwPmNQ35ZAomo4G+JeTrSon1F1vGs57gMckwb
         55uQpCHmoXMv8KV6rL+sEQPZyKrS5dJ6dSds4J5egseJG/5bISNybr2JDBtAhzaH54Yj
         bsjPIXzqjQhDhGoO7QQ0SJT2ldbC0IXcF+j3lK6tIAA2RjdZz6pi6A4JtZd/OkhmSVEh
         S/fhCBKaqLuV0PcxTqxjfhu6JOogve1E/8rdtlcfUAIUs7IDdjwMXaUcgHrdm9fbBb5a
         BWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0+TZfyO96MuT6z1hpaU/81N8W1L7K7DdH8/8YCsn0po=;
        b=IOCQvK7JtfsbaUQmjQIJNVK2OC0IXjzHKOnQ1mCTyV0yrawr/OKmrIe0zHiMW/qoKc
         pSyCkKyV5nJOgQTsspwqLWZnzO0PjtsbgzziJbEEKZzmy4X3vJ7US04qHzCJ/uPTaWgm
         i/G7W8Qq8zE6hCHEsD+DdQ96qKbK2POxAb6vhSS39D2H8TvRtq0jUaTWA0/aZ3GlGgmu
         TDfQipp8vRblWqkFxUcqEf2OTTRLEqGUkynzJh1FgURFZm1szrr34u26fUT8ZkfDYCUr
         ep0EW+UFaK7xJUxxCRZt84fiBK9YPBLx8DopvJNpsb6mtnDHePs6cdI8RG3BSgl3cRY8
         BVEw==
X-Gm-Message-State: AO0yUKWrPeIkuuYtmjiT51d/kc9y+iw2PYoSo5heMXQxlD11JtqHLMgv
        bYVn55o886Aiu09se0P/iKU=
X-Google-Smtp-Source: AK7set+GP57b23l4H7mZbkBUG5+1tmsloUkZbk2K4Lht+GiGt0jBGf9WhoYhh29+cRjOHLVgOKAXEw==
X-Received: by 2002:a92:6801:0:b0:315:5436:a632 with SMTP id d1-20020a926801000000b003155436a632mr635911ilc.2.1676303747888;
        Mon, 13 Feb 2023 07:55:47 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id r13-20020a92d44d000000b0031550a3dc7esm399373ilm.32.2023.02.13.07.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 07:55:47 -0800 (PST)
Date:   Mon, 13 Feb 2023 17:55:41 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 04/28] arm64: RME: Check for RME support at KVM init
Message-ID: <20230213175541.00007cc9@gmail.com>
In-Reply-To: <20230127112932.38045-5-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
        <20230127112932.38045-1-steven.price@arm.com>
        <20230127112932.38045-5-steven.price@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Jan 2023 11:29:08 +0000
Steven Price <steven.price@arm.com> wrote:

> Query the RMI version number and check if it is a compatible version. A
> static key is also provided to signal that a supported RMM is available.
> 
> Functions are provided to query if a VM or VCPU is a realm (or rec)
> which currently will always return false.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 17 ++++++++++
>  arch/arm64/include/asm/kvm_host.h    |  4 +++
>  arch/arm64/include/asm/kvm_rme.h     | 22 +++++++++++++
>  arch/arm64/include/asm/virt.h        |  1 +
>  arch/arm64/kvm/Makefile              |  3 +-
>  arch/arm64/kvm/arm.c                 |  8 +++++
>  arch/arm64/kvm/rme.c                 | 49 ++++++++++++++++++++++++++++
>  7 files changed, 103 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/kvm_rme.h
>  create mode 100644 arch/arm64/kvm/rme.c
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 9bdba47f7e14..5a2b7229e83f 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -490,4 +490,21 @@ static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
>  	return test_bit(feature, vcpu->arch.features);
>  }
>  
> +static inline bool kvm_is_realm(struct kvm *kvm)
> +{
> +	if (static_branch_unlikely(&kvm_rme_is_available))
> +		return kvm->arch.is_realm;
> +	return false;
> +}
> +
> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
> +{
> +	return READ_ONCE(kvm->arch.realm.state);
> +}
> +
> +static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 35a159d131b5..04347c3a8c6b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -26,6 +26,7 @@
>  #include <asm/fpsimd.h>
>  #include <asm/kvm.h>
>  #include <asm/kvm_asm.h>
> +#include <asm/kvm_rme.h>
>  
>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>  
> @@ -240,6 +241,9 @@ struct kvm_arch {
>  	 * the associated pKVM instance in the hypervisor.
>  	 */
>  	struct kvm_protected_vm pkvm;
> +
> +	bool is_realm;
> +	struct realm realm;
>  };
>  
>  struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> new file mode 100644
> index 000000000000..c26bc2c6770d
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_KVM_RME_H
> +#define __ASM_KVM_RME_H
> +
> +enum realm_state {
> +	REALM_STATE_NONE,
> +	REALM_STATE_NEW,
> +	REALM_STATE_ACTIVE,
> +	REALM_STATE_DYING
> +};
> +

By the way, it is better to add more comments to introduce about the states
here.

> +struct realm {
> +	enum realm_state state;
> +};
> +
> +int kvm_init_rme(void);
> +
> +#endif
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 4eb601e7de50..be1383e26626 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -80,6 +80,7 @@ void __hyp_set_vectors(phys_addr_t phys_vector_base);
>  void __hyp_reset_vectors(void);
>  
>  DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> +DECLARE_STATIC_KEY_FALSE(kvm_rme_is_available);
>  
>  /* Reports the availability of HYP mode */
>  static inline bool is_hyp_mode_available(void)
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 5e33c2d4645a..d2f0400c50da 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -20,7 +20,8 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>  	 vgic/vgic-v3.o vgic/vgic-v4.o \
>  	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
>  	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
> -	 vgic/vgic-its.o vgic/vgic-debug.o
> +	 vgic/vgic-its.o vgic/vgic-debug.o \
> +	 rme.o
>  
>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9c5573bc4614..d97b39d042ab 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -38,6 +38,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_pkvm.h>
> +#include <asm/kvm_rme.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/sections.h>
>  
> @@ -47,6 +48,7 @@
>  
>  static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
>  DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> +DEFINE_STATIC_KEY_FALSE(kvm_rme_is_available);
>  
>  DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>  
> @@ -2213,6 +2215,12 @@ int kvm_arch_init(void *opaque)
>  
>  	in_hyp_mode = is_kernel_in_hyp_mode();
>  
> +	if (in_hyp_mode) {
> +		err = kvm_init_rme();
> +		if (err)
> +			return err;
> +	}
> +
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>  	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>  		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> new file mode 100644
> index 000000000000..f6b587bc116e
> --- /dev/null
> +++ b/arch/arm64/kvm/rme.c
> @@ -0,0 +1,49 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/rmi_cmds.h>
> +#include <asm/virt.h>
> +
> +static int rmi_check_version(void)
> +{
> +	struct arm_smccc_res res;
> +	int version_major, version_minor;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, &res);
> +
> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
> +		return -ENXIO;
> +
> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a0);
> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a0);
> +
> +	if (version_major != RMI_ABI_MAJOR_VERSION) {
> +		kvm_err("Unsupported RMI ABI (version %d.%d) we support %d\n",
> +			version_major, version_minor,
> +			RMI_ABI_MAJOR_VERSION);
> +		return -ENXIO;
> +	}
> +
> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
> +
> +	return 0;
> +}
> +
> +int kvm_init_rme(void)
> +{
> +	if (PAGE_SIZE != SZ_4K)
> +		/* Only 4k page size on the host is supported */
> +		return 0;
> +
> +	if (rmi_check_version())
> +		/* Continue without realm support */
> +		return 0;
> +
> +	/* Future patch will enable static branch kvm_rme_is_available */
> +
> +	return 0;
> +}

