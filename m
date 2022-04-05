Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB13D4F49AC
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443854AbiDEWUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452376AbiDEPyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:54:50 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3AF2DD63;
        Tue,  5 Apr 2022 07:54:02 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j12so12116963wrb.5;
        Tue, 05 Apr 2022 07:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+pnKCsRfb2rzqCckVdTkSoUT8v6CdUCSShmPSLzCyP0=;
        b=LX4HOgTQVkwMDbSE3DgKngp+uhFQ8ZfVZwEpwb8isiAUd8/XQmnnc769W4bGAiZCC7
         RWY38LhoMvuzKnd3jlxHJay7yUi68ecJ+e2aemylOEILuQurMuPkzYR0cixwAzcmtmxv
         GUSmMyLT4xt5C/V5FCYhJTpWYL8PosCycpY1hUagZQqT+ej+TD2klvXzeb4yf9KTg1wC
         haw47fZzkfqi/Cwb60l2uaYcl7RydVP6yRh0WTFfgx5v+zLEX3CKVvBBuEM3bEpJvYKk
         5wOwoPdIZ94XVjIEQaLE22UZreCuWjLAkhaFTrZ1IilpGD+o6Z9A3TpmwCN0K71FIP8y
         85yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+pnKCsRfb2rzqCckVdTkSoUT8v6CdUCSShmPSLzCyP0=;
        b=lXpPkzeo3DPny55NikfnbAa6MpBqcVntXCk8BUP5BVTzVFofbo4ivp6qKp9ml7U2qI
         D6LdFehhAVJCSFGFmJpPYuKGstfCgA+lFoYQAcP+hdeLxz/QbKtHQSk30J0AeLsPNjE0
         fm9iDM84Fr8KxFiolN4juPGB22ERfJOvUerNy7EdPgay2Kb3KZL/Hk+vlGxtzSdghwqB
         su4v6bIPs0jnAmYEHy0VHpi37WrQVWgQYH4KcP7svYqHIzGS/ucqhn58NBxSEFqL+jHt
         0EilWjv7viKdpYd1Kjv3TOuVm9pObronaUy3Gf/wdgKcq+wU/7AHRDnVZ/jvvAA4s1RH
         Rgdg==
X-Gm-Message-State: AOAM533MSctd5Ido8gFWxQocw5r3w7skUVh1Nqt2GLaECau2NkNyp/hK
        /SFIvzpkAsme0TBVUFMiww4=
X-Google-Smtp-Source: ABdhPJx9J+H9RdYMUjeVJaoXCv7F9LT5FTx30HNzWlpNFGTPDHPZRSy8pztLyEdDBAXRD0EY+/Dy+w==
X-Received: by 2002:a05:6000:15ce:b0:204:1113:b053 with SMTP id y14-20020a05600015ce00b002041113b053mr3006630wry.701.1649170440961;
        Tue, 05 Apr 2022 07:54:00 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id p14-20020a05600c1d8e00b0038dbb5ecc8asm2467434wms.2.2022.04.05.07.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:54:00 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <4d2e9c6c-af14-18d1-0f07-f06196543640@redhat.com>
Date:   Tue, 5 Apr 2022 16:53:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 046/104] KVM: x86/tdp_mmu: refactor
 kvm_tdp_mmu_map()
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <8ac26dfbe645aa3e9a9f39c844dfec9c0ac841ec.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8ac26dfbe645aa3e9a9f39c844dfec9c0ac841ec.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Factor out non-leaf SPTE population logic from kvm_tdp_mmu_map().  MapGPA
> hypercall needs to populate non-leaf SPTE to record which GPA, private or
> shared, is allowed in the leaf EPT entry.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

and feel free to rebase/resubmit this one, with subject "KVM: 
x86/tdp_mmu: extract tdp_mmu_populate_nonleaf()".

Paolo

> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 48 ++++++++++++++++++++++++--------------
>   1 file changed, 30 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b6ec2f112c26..8db262440d5c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -955,6 +955,31 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   	return ret;
>   }
>   
> +static bool tdp_mmu_populate_nonleaf(
> +	struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx)
> +{
> +	struct kvm_mmu_page *sp;
> +	u64 *child_pt;
> +	u64 new_spte;
> +
> +	WARN_ON(is_shadow_present_pte(iter->old_spte));
> +	WARN_ON(is_removed_spte(iter->old_spte));
> +
> +	sp = alloc_tdp_mmu_page(vcpu, iter->gfn, iter->level - 1);
> +	child_pt = sp->spt;
> +
> +	new_spte = make_nonleaf_spte(child_pt, !shadow_accessed_mask);
> +
> +	if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte)) {
> +		tdp_mmu_free_sp(sp);
> +		return false;
> +	}
> +
> +	tdp_mmu_link_page(vcpu->kvm, sp, account_nx);
> +	trace_kvm_mmu_get_page(sp, true);
> +	return true;
> +}
> +
>   /*
>    * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
>    * page tables and SPTEs to translate the faulting guest physical address.
> @@ -963,9 +988,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   {
>   	struct kvm_mmu *mmu = vcpu->arch.mmu;
>   	struct tdp_iter iter;
> -	struct kvm_mmu_page *sp;
> -	u64 *child_pt;
> -	u64 new_spte;
>   	int ret;
>   
>   	kvm_mmu_hugepage_adjust(vcpu, fault);
> @@ -1000,6 +1022,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   		}
>   
>   		if (!is_shadow_present_pte(iter.old_spte)) {
> +			bool account_nx;
> +
>   			/*
>   			 * If SPTE has been frozen by another thread, just
>   			 * give up and retry, avoiding unnecessary page table
> @@ -1008,22 +1032,10 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   			if (is_removed_spte(iter.old_spte))
>   				break;
>   
> -			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
> -			child_pt = sp->spt;
> -
> -			new_spte = make_nonleaf_spte(child_pt,
> -						     !shadow_accessed_mask);
> -
> -			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
> -				tdp_mmu_link_page(vcpu->kvm, sp,
> -						  fault->huge_page_disallowed &&
> -						  fault->req_level >= iter.level);
> -
> -				trace_kvm_mmu_get_page(sp, true);
> -			} else {
> -				tdp_mmu_free_sp(sp);
> +			account_nx = fault->huge_page_disallowed &&
> +				fault->req_level >= iter.level;
> +			if (!tdp_mmu_populate_nonleaf(vcpu, &iter, account_nx))
>   				break;
> -			}
>   		}
>   	}
>   

