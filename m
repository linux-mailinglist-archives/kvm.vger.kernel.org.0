Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD535B0BE9
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 19:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiIGR64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 13:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiIGR6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 13:58:46 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A96EB3B01
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 10:58:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id o126so6397582pfb.6
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 10:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=JosmKe55eMvtdWJAk2/K7bgaMfcAyJS6d8V5bk/Iy/Q=;
        b=M9duQpQgiVR2qqyQRMcacCLJUB7ATcc2aEiWckiVEm8/X26zXJ0vulFKycghe636bz
         KTwW7i5nNKa2VXYxMOqrJ1oQLsK6hPh2bPVd4MvG9NVDM735/LplTk8vZzP9qEtJ/1Bv
         U+CffkxbwN0SdsX1AyiS4uNMdgsJoJ+Y2uPBDauOn8l3pcOHwya9M6mg2ImRuGkDxdzu
         uttSjXwyn/5fb7L+7apyE1GjY+E9y3WqiYLxytLMQGNJASYUghhib1uL5Krrp6Oide7b
         7FuAHYX5fzdnVZgXGAs9uCtHRiDsZewI+6Gwg7ofY3YH57N1BFG76hK612EqmvQIJvkQ
         MCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JosmKe55eMvtdWJAk2/K7bgaMfcAyJS6d8V5bk/Iy/Q=;
        b=2F/ysZsKjc8UbIcOVH0VQ2A2bQ0W7aE5WN2zigoJKtMfE/6gYBIYkEgxYKHoOcbkfg
         ZNo6Zz7mYc1IzzOdD3F6jvIylY3Rlacx0V5QXUXmLhHPH8vFWHgzS3X8gAl89Fp35Ump
         8/EQT7IOFmkReDTgLUiPpflyLRhZS/Qm6+/Us9DJUADQrEhNy/4P5ZBSYHaUJBh/1EE6
         egLgBLxu6P8/m0b9zFfEjig5Q9+xwocsJ2/lDEF7T+41kwIZVP98lCkp2Rgjm2KLQZRw
         RXICMTvoyQE2rhErtbqLgHzeAKcvDKmjvqx8HGcU9VHSSQ7D6ikfRxr+Aw3LzB7a1W2D
         zaqQ==
X-Gm-Message-State: ACgBeo3U5LXdmg0ezzHfr00yi+4fTb2C5NL1jJtgS7JlJYNxtZb6sPe1
        cw56lj4r3OlQ858MnCIet1jB4Q==
X-Google-Smtp-Source: AA6agR6Oog6qB7ydq9drsmkjBwefKUtH9bLORqyDvcbr5gINuaolywYDuunfdOskLPE4S3kZlnzJ2g==
X-Received: by 2002:a05:6a02:10e:b0:42a:b42b:5692 with SMTP id bg14-20020a056a02010e00b0042ab42b5692mr4275717pgb.67.1662573525372;
        Wed, 07 Sep 2022 10:58:45 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902a70300b00172eb493487sm4353105plq.167.2022.09.07.10.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 10:58:44 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:58:39 -0700
From:   David Matlack <dmatlack@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: Reduce gfn range of tlb flushing in
 tdp_mmu_map_handle_target_level()
Message-ID: <Yxjbz4tTnqMLWcU6@google.com>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <85f889ce6eb6b330d86fa74c6e84d22d98ddc2cf.1661331396.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85f889ce6eb6b330d86fa74c6e84d22d98ddc2cf.1661331396.git.houwenlong.hwl@antgroup.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 05:29:20PM +0800, Hou Wenlong wrote:
> Since the children SP is zapped, the gfn range of tlb flushing should be
> the range covered by children SP not parent SP. Replace sp->gfn which is
> the base gfn of parent SP with iter->gfn and use the correct size of
> gfn range for children SP to reduce tlb flushing range.
> 

Fixes: bb95dfb9e2df ("KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow pages")

> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bf2ccf9debca..08b7932122ec 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1071,8 +1071,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  		return RET_PF_RETRY;
>  	else if (is_shadow_present_pte(iter->old_spte) &&
>  		 !is_last_spte(iter->old_spte, iter->level))
> -		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
> -						   KVM_PAGES_PER_HPAGE(iter->level + 1));
> +		kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter->gfn,
> +						   KVM_PAGES_PER_HPAGE(iter->level));
>  
>  	/*
>  	 * If the page fault was caused by a write but the page is write
> -- 
> 2.31.1
> 
