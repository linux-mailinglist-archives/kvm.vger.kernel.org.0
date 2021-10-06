Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DFB423B6F
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 12:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbhJFK0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 06:26:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237836AbhJFK0s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 06:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633515895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MmWiCgB8uSNl6DOPQQvudamwXwcTydeBRX/uLyQwgQA=;
        b=Ps6uFmceHlYkWsq0hQtEbRVq6i+J46HWCTYaWHNhJ+iF3NyDOPJ7ehcwq/arrsgjhcMgM9
        e16iV6dXwrs/dtDnreU+ODnXYiZRk64PJDQYYQ+/YQQlbsrtGVldmWzY1KAoj7KHu7erWK
        17Und4MWUuM3bavHCvfTIe1VoYEcfxY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-1qr4DPUbPDi_iyZFNeCQ-A-1; Wed, 06 Oct 2021 06:24:54 -0400
X-MC-Unique: 1qr4DPUbPDi_iyZFNeCQ-A-1
Received: by mail-ed1-f69.google.com with SMTP id p20-20020a50cd94000000b003db23619472so2165139edi.19
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 03:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MmWiCgB8uSNl6DOPQQvudamwXwcTydeBRX/uLyQwgQA=;
        b=0/gpfyZ4BK/90YYinhnGMrOzKUipWNAtk3c83IxMpbnxgrJwFcgVH6Q/a2JVQa0X2w
         j6Gz4PjRH2O8/qrHdMfeI0inPvlWU9o0hXjMGTvqednrrfDlgdewpaT2AsFQ7a/6eSCR
         oKdCQkRco2VchKN01wP2TKdbnt4QszJdb0sTHFNRcY0Oxi23F/+PapQp3GK2Fys7tYIZ
         r4WsqG1J4NtFRkLgT8rVwsy0at19Zmed7fAiVLkksOu2xnbVCKSC9uMD2scqjd0V1cT/
         krpdiIB9bs0/taUonmaXlm8XBNBy0MOVEm24a72GgDY/57EhlQOsOHeTc4LEDDs36Yy/
         JoIw==
X-Gm-Message-State: AOAM532AAgmGrNDA9+tHyjduXZWYmyKg24yrOwLHfZF6pIVbdstCkB+H
        TQiBt5MEe+7F8LNkWmUlhFf4l2S28h4EGvGFiInhNMzNTOxf8TYZLEbxZ2BXnMw8rfzzgQa5SaK
        oBatJbZVKufT2
X-Received: by 2002:a17:906:7ac4:: with SMTP id k4mr32292464ejo.430.1633515893289;
        Wed, 06 Oct 2021 03:24:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0zZ6sW7WDT3oke9j4TDRc16AgVPN/PNWxEB0jdSUXa+T95wQObvHtsiMesHktZL1B3vMLxQ==
X-Received: by 2002:a17:906:7ac4:: with SMTP id k4mr32292427ejo.430.1633515893066;
        Wed, 06 Oct 2021 03:24:53 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id m13sm3872442eda.41.2021.10.06.03.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 03:24:52 -0700 (PDT)
Date:   Wed, 6 Oct 2021 12:24:50 +0200
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
Subject: Re: [PATCH v2 01/16] KVM: arm64: Generalise VM features into a set
 of flags
Message-ID: <20211006102450.4fkn46yqfbbh7i6y@gator.home>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004174849.2831548-2-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:48:34PM +0100, Marc Zyngier wrote:
> We currently deal with a set of booleans for VM features,
> while they could be better represented as set of flags
> contained in an unsigned long, similarily to what we are
> doing on the CPU side.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 12 +++++++-----
>  arch/arm64/kvm/arm.c              |  5 +++--
>  arch/arm64/kvm/mmio.c             |  3 ++-
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..f63ca8fb4e58 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -122,7 +122,10 @@ struct kvm_arch {
>  	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
>  	 * supported.
>  	 */
> -	bool return_nisv_io_abort_to_user;
> +#define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
> +	/* Memory Tagging Extension enabled for the guest */
> +#define KVM_ARCH_FLAG_MTE_ENABLED			1
> +	unsigned long flags;
>  
>  	/*
>  	 * VM-wide PMU filter, implemented as a bitmap and big enough for
> @@ -133,9 +136,6 @@ struct kvm_arch {
>  
>  	u8 pfr0_csv2;
>  	u8 pfr0_csv3;
> -
> -	/* Memory Tagging Extension enabled for the guest */
> -	bool mte_enabled;
>  };
>  
>  struct kvm_vcpu_fault_info {
> @@ -786,7 +786,9 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  #define kvm_arm_vcpu_sve_finalized(vcpu) \
>  	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
>  
> -#define kvm_has_mte(kvm) (system_supports_mte() && (kvm)->arch.mte_enabled)
> +#define kvm_has_mte(kvm)					\
> +	(system_supports_mte() &&				\
> +	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
>  #define kvm_vcpu_has_pmu(vcpu)					\
>  	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe102cd2e518..ed9c89ec0b4f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -89,7 +89,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  	switch (cap->cap) {
>  	case KVM_CAP_ARM_NISV_TO_USER:
>  		r = 0;
> -		kvm->arch.return_nisv_io_abort_to_user = true;
> +		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> +			&kvm->arch.flags);
>  		break;
>  	case KVM_CAP_ARM_MTE:
>  		mutex_lock(&kvm->lock);
> @@ -97,7 +98,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			r = -EINVAL;
>  		} else {
>  			r = 0;
> -			kvm->arch.mte_enabled = true;
> +			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
>  		}
>  		mutex_unlock(&kvm->lock);
>  		break;
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index 3e2d8ba11a02..3dd38a151d2a 100644
> --- a/arch/arm64/kvm/mmio.c
> +++ b/arch/arm64/kvm/mmio.c
> @@ -135,7 +135,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  	 * volunteered to do so, and bail out otherwise.
>  	 */
>  	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
> -		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
> +		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
> +			     &vcpu->kvm->arch.flags)) {
>  			run->exit_reason = KVM_EXIT_ARM_NISV;
>  			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
>  			run->arm_nisv.fault_ipa = fault_ipa;
> -- 
> 2.30.2
> 

Maybe a kvm_arm_has_feature(struct kvm *kvm) helper would be nice to avoid
all the &vcpu->kvm->arch.flags types of references getting scattered
around.

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

