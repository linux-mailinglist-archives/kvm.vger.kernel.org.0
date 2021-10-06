Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E00423BA1
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 12:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbhJFKn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 06:43:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237836AbhJFKn1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 06:43:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633516894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pSbAB1FpLz0EqbTVsytH0ZxguGzlBKGJojYvPvVsolc=;
        b=SZDT8TQ8wOLcNtrH4GrAht9hhAQ3vICyF3WqYrn/h0ko6RaLZKW7UivZDXK+rKvxuG9Q/O
        fOZqOgqVLW4P3ukvaalimJ89dEuDn8tl90DF8OVYsO7mM+k4V6Pylo7MCgzV/d3oF9zMqU
        kCZfmW4V4HuUYS1ZigN5LlYKFlmtVL0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-3DDy3ETgMzuCf17wFqlXUQ-1; Wed, 06 Oct 2021 06:41:33 -0400
X-MC-Unique: 3DDy3ETgMzuCf17wFqlXUQ-1
Received: by mail-ed1-f69.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso2227017edw.10
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 03:41:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pSbAB1FpLz0EqbTVsytH0ZxguGzlBKGJojYvPvVsolc=;
        b=HsyXhPY1Xpg6GcrQHSIOz/PpRq5epMun/AyIN4rAWZltRhART6YTlE6sdFQFx3GKVH
         ct4blojP5tVeyccy78HDV7hvihKez54yDY5BlmmLm7ziHfR7qb2kr7S2MwPIzlEmOBMk
         lUV1uA5cfz5qSjc2LuSxkTQOUfcrJYPXRlaBy7LOjY/2tBZPTtiKSwaAURIoCtR+IZUG
         KmYh/yilI1NljcUDdc/iootGW4gT4wThr4wWWnhmvtW8jeO1Js64TqxBHiks1NdSbLfo
         b4AtShyGEbtDfqVTTVOWaCMbIPewe0paAOho53zh9aYad8ZDcTbVJwKNv2VWL0ylvdSq
         uUXg==
X-Gm-Message-State: AOAM531cviOAL2qvkAszPx4cYtSTEMEmxiu3Q5ypZdgw3GlCVWDo2Xp/
        HpsT4w6k/7gU2VhtfgMGGjPJFKl1Qxvbpt4rxLfPhbvMpmaKzrsgVl9mumAVW0zGBAh5DaiTB9n
        Yv6tRnZQItApH
X-Received: by 2002:a05:6402:1259:: with SMTP id l25mr9211089edw.344.1633516891971;
        Wed, 06 Oct 2021 03:41:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsOxOanoU2WsmUTn0+TJD/8wKuiodjYexDFyKIk7g9DkrwyVhAlxgYFvN9xA5V8tJSD+COsA==
X-Received: by 2002:a05:6402:1259:: with SMTP id l25mr9211064edw.344.1633516891776;
        Wed, 06 Oct 2021 03:41:31 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id q18sm8991596ejc.84.2021.10.06.03.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 03:41:31 -0700 (PDT)
Date:   Wed, 6 Oct 2021 12:41:29 +0200
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
Subject: Re: [PATCH v2 02/16] KVM: arm64: Check for PTE valitity when
 checking for executable/cacheable
Message-ID: <20211006104129.s5az46tpny2csfge@gator.home>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004174849.2831548-3-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

sed s/valitity/validity/ <<<"$SUBJECT"

On Mon, Oct 04, 2021 at 06:48:35PM +0100, Marc Zyngier wrote:
> Don't blindly assume that the PTE is valid when checking whether
> it describes an executable or cacheable mapping.
> 
> This makes sure that we don't issue CMOs for invalid mappings.
> 
> Suggested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index f8ceebe4982e..6bbfd952f0c5 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -638,12 +638,12 @@ static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
>  static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
>  {
>  	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
> -	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
> +	return kvm_pte_valid(pte) && memattr == KVM_S2_MEMATTR(pgt, NORMAL);
>  }
>  
>  static bool stage2_pte_executable(kvm_pte_t pte)
>  {
> -	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
> +	return kvm_pte_valid(pte) && !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
>  }
>  
>  static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
> @@ -688,8 +688,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  	/* Perform CMOs before installation of the guest stage-2 PTE */
>  	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
>  		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
> -						granule);
> -
> +					       granule);
>  	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
>  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
>  
> @@ -1091,7 +1090,7 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	kvm_pte_t pte = *ptep;
>  	kvm_pte_t *pte_follow;
>  
> -	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
> +	if (!stage2_pte_cacheable(pgt, pte))
>  		return 0;
>  
>  	pte_follow = kvm_pte_follow(pte, mm_ops);
> -- 
> 2.30.2
> 

Reviewed-by: Andrew Jones <drjones@redhat.com>

