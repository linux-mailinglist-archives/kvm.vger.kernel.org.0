Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98443423CE9
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 13:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbhJFLjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 07:39:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238265AbhJFLjs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 07:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633520276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tLSJ+0G6GaESS3A8wROTGiXCvt9MmKxGWQIQfuIzv50=;
        b=PZou4TXLbMlhmkMfilag7ylf2LfKZGSdyyLP/c8Vu4YWo2uDFF2ZyUo1ukbm2A0g92uspw
        2ySyjkKTNGyaLY8YcyiCZSSl0AuYVKBVotlQ2S+neFPddyEfaO+JJq6yYZKv7YuFe4NIX/
        eSzUYZiW2/iu1Ge9uDFeILc99YYX7N4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-vFdWf101PHmMmsupUT8RQA-1; Wed, 06 Oct 2021 07:37:55 -0400
X-MC-Unique: vFdWf101PHmMmsupUT8RQA-1
Received: by mail-ed1-f71.google.com with SMTP id bo2-20020a0564020b2200b003db3540f206so2144628edb.23
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 04:37:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tLSJ+0G6GaESS3A8wROTGiXCvt9MmKxGWQIQfuIzv50=;
        b=niukty7m+DwivSn5CW9ND2jfiWLzV120jZbDyRQLNGXX2IB6dEg+MnglKYNC6yBwoy
         k412zVVS5ht3l2x9A2UcwVuX96RbL2ydSeo5qHBmD6mUSBq8NeazqZtTW/RqSgChr+4u
         voPYPS8J6ogFWB1QQXsbhV9QM84wm3Z9z1fFm8TwDfGPBD2A15mX4WKeOxS93J3xOr90
         /mGoPGYIXQ2aZ6mIt2hApfM+uj+VdPQlMw7iUSWZPZnRPk/duEYbAEx8fbugHDYAxNMb
         zK0Y1yFmy0QJgTKfKrsePYWROIK3b3DZ2u+7OHeZVE01Bsy4TP6S2OYmYrIHJfBzELI2
         QvfQ==
X-Gm-Message-State: AOAM5328yG/8lLqNFkPKeZ2mgjVV//80OPbBEdrjTtNS2+TpijO9vhZE
        VGbhDW2mv1HL3m6s0BRqZ0sFjrLuqBDP/QDuXlWH5YmGyOgTJrv6Wn51GVhUHqN6MXmVBhjvH0m
        H9WEnyYr3GY7N
X-Received: by 2002:a17:907:628d:: with SMTP id nd13mr32691152ejc.7.1633520274160;
        Wed, 06 Oct 2021 04:37:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEEcX7nQiCt05CZwz558uZNZfwfw1lYcM5ACjQLLwDhsTkZqZlZFhhEMl7qA8+8LcuiVSErA==
X-Received: by 2002:a17:907:628d:: with SMTP id nd13mr32691131ejc.7.1633520273957;
        Wed, 06 Oct 2021 04:37:53 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id dh16sm9840424edb.63.2021.10.06.04.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:37:53 -0700 (PDT)
Date:   Wed, 6 Oct 2021 13:37:51 +0200
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
Subject: Re: [PATCH v2 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <20211006113751.damskwaz7akpk5fc@gator.home>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004174849.2831548-5-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:48:37PM +0100, Marc Zyngier wrote:
> Introduce the infrastructure required to identify an IPA region
> that is expected to be used as an MMIO window.
> 
> This include mapping, unmapping and checking the regions. Nothing
> calls into it yet, so no expected functional change.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |   2 +
>  arch/arm64/include/asm/kvm_mmu.h  |   5 ++
>  arch/arm64/kvm/mmu.c              | 109 ++++++++++++++++++++++++++++++
>  3 files changed, 116 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f63ca8fb4e58..ba9781eb84d6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -125,6 +125,8 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
>  	/* Memory Tagging Extension enabled for the guest */
>  #define KVM_ARCH_FLAG_MTE_ENABLED			1
> +	/* Gues has bought into the MMIO guard extension */
> +#define KVM_ARCH_FLAG_MMIO_GUARD			2
>  	unsigned long flags;
>  
>  	/*
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 02d378887743..454a6265d45d 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -170,6 +170,11 @@ phys_addr_t kvm_mmu_get_httbr(void);
>  phys_addr_t kvm_get_idmap_vector(void);
>  int kvm_mmu_init(u32 *hyp_va_bits);
>  
> +/* MMIO guard */
> +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> +bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> +bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> +
>  static inline void *__kvm_vector_slot2addr(void *base,
>  					   enum arm64_hyp_spectre_vector slot)
>  {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1a94a7ca48f2..2470a55ca675 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1172,6 +1172,115 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  		kvm_set_pfn_accessed(pte_pfn(pte));
>  }
>  
> +/* Replace this with something more structured once day */

one day

> +#define MMIO_NOTE	(('M' << 24 | 'M' << 16 | 'I' << 8 | 'O') << 1)

Would it be better to have kvm_pgtable_stage2_annotate() shift its
inputs (<< 1) instead of requiring all annotations to remember that
requirement? Although the owner id is shifted 2 bits, but I'm not
sure why.

> +
> +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	struct kvm_mmu_memory_cache *memcache;
> +	struct kvm_memory_slot *memslot;
> +	struct kvm *kvm = vcpu->kvm;
> +	int ret, idx;
> +
> +	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &kvm->arch.flags))
> +		return false;
> +
> +	/* Must be page-aligned */
> +	if (ipa & ~PAGE_MASK)
> +		return false;
> +
> +	/*
> +	 * The page cannot be in a memslot. At some point, this will
> +	 * have to deal with device mappings though.
> +	 */
> +	idx = srcu_read_lock(&kvm->srcu);
> +	mutex_lock(&kvm->slots_arch_lock);
> +	memslot = gfn_to_memslot(kvm, ipa >> PAGE_SHIFT);
> +	if (memslot) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Guest has direct access to the GICv2 virtual CPU interface */
> +	if (irqchip_in_kernel(kvm) &&
> +	    kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
> +	    ipa == kvm->arch.vgic.vgic_cpu_base) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	memcache = &vcpu->arch.mmu_page_cache;
> +	if (kvm_mmu_topup_memory_cache(memcache,
> +				       kvm_mmu_cache_min_pages(kvm))) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	spin_lock(&kvm->mmu_lock);
> +	ret = kvm_pgtable_stage2_annotate(vcpu->arch.hw_mmu->pgt,
> +					  ipa, PAGE_SIZE, memcache,
> +					  MMIO_NOTE);
> +	spin_unlock(&kvm->mmu_lock);
> +
> +out:
> +	mutex_unlock(&kvm->slots_arch_lock);
> +	srcu_read_unlock(&kvm->srcu, idx);
> +	return ret == 0;

I guess the callers need this to return a boolean? Just seems odd that
pains were taken above to set ret to EINVAL/ENOMEM just to translate
that to true/false here though.

> +}
> +
> +static bool __check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	kvm_pte_t pte = 0;
> +	u32 level = 0;
> +	int ret;
> +
> +	lockdep_assert_held(&vcpu->kvm->mmu_lock);
> +
> +	ret = kvm_pgtable_get_leaf(vcpu->arch.hw_mmu->pgt, ipa, &pte, &level);
> +	VM_BUG_ON(ret);
> +	VM_BUG_ON(level >= KVM_PGTABLE_MAX_LEVELS);
> +
> +	/* Must be a PAGE_SIZE mapping with our annotation */
> +	return (BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level)) == PAGE_SIZE &&
> +		pte == MMIO_NOTE);
> +}
> +
> +bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	bool ret;
> +
> +	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
> +		return false;
> +
> +	/* Keep the PT locked across the two walks */
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +
> +	ret = __check_ioguard_page(vcpu, ipa);
> +	if (ret)		/* Drop the annotation */
> +		kvm_pgtable_stage2_unmap(vcpu->arch.hw_mmu->pgt,
> +					 ALIGN_DOWN(ipa, PAGE_SIZE), PAGE_SIZE);

How about

 if (ret) {
         /* Drop the annotation */
         kvm_pgtable_stage2_unmap(vcpu->arch.hw_mmu->pgt,
                                  ALIGN_DOWN(ipa, PAGE_SIZE), PAGE_SIZE);
 }

to be a bit easier to read.

> +
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +	return ret;
> +}
> +
> +bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	bool ret;
> +
> +	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
> +		return true;
> +
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +	ret = __check_ioguard_page(vcpu, ipa & PAGE_MASK);
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +
> +	if (!ret)
> +		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
> +
> +	return ret;
> +}
> +
>  /**
>   * kvm_handle_guest_abort - handles all 2nd stage aborts
>   * @vcpu:	the VCPU pointer
> -- 
> 2.30.2
>

Besides the nits

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew 

