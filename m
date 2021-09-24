Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E87416FBC
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 11:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245329AbhIXJ6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 05:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245519AbhIXJ6G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 05:58:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632477392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WVyfoPUAjI4ViCHo+gUhfDLFvOKlEdycoa2FgP4WzVo=;
        b=Fk77QDq24tOP6lq+EQOSNmPPhgEqHrFZzZQGkIWpLHeXPob7Har5psivyLS3d6KMyCy/SN
        I1Kc8NhjHFB4movI0MiGAMfv+pmOq/Gq7n8ryLR0na0feHjVwq2ZJkwe2+oT9fn2RRe5t4
        rI0JpYQJBKHY7UODEkHnfwaR2NfPCSA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-4CeZISWGPrakR1UNM0S-Tw-1; Fri, 24 Sep 2021 05:56:30 -0400
X-MC-Unique: 4CeZISWGPrakR1UNM0S-Tw-1
Received: by mail-ed1-f69.google.com with SMTP id h24-20020a50cdd8000000b003d8005fe2f8so9717077edj.6
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 02:56:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WVyfoPUAjI4ViCHo+gUhfDLFvOKlEdycoa2FgP4WzVo=;
        b=feBbb7xwzV25JxHmsfNZqa2gzeNuDurpkipM/n+y8shxqBx6iVdOTArgsfL4ns9CZT
         X5GyqRg0pTfIrOypu+2P3lsP7ysL917lMLGvCoQRKITlMQFqtZ0E1XChiReDeSNm3VHd
         5ZFaFn4E5biIsUVz/jfwsQaJy+oXvT9EFYitJm+RR/Gdpuv7r/XrQo2YLvOr2xndtVDD
         CXDUfZD3VAFatGiLEYQFysSDdxathoruelA0rWK0Be1SYcSJTooiMSepAGW6nJ6yvoE5
         8WlbCQYMBCfZ8Hbir4l3HL8N2vFGPhjqR8ACMTF6hGdeBNwRiSabF9Gx4fR0DI1112NQ
         1ghg==
X-Gm-Message-State: AOAM531wTc49zoT1w5PDB+MpGzIAV+Tp9miI/6daS6q7oYzriLx9Gi0F
        iOb0YwFTUQ6SgAOVss+sDwcNiWFZC+QRqlZ3Kt5x5dfZXBcHBKfxHSnyZBa340qliV6tGzD0Cit
        7FTEnnsaXAvM3
X-Received: by 2002:a50:9d83:: with SMTP id w3mr3940186ede.305.1632477389512;
        Fri, 24 Sep 2021 02:56:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDjmMD9CVLHQdEu7vQ5KM2Yw3E/kP1qYaTPrxc1Lm2b1XmlJC/yclfrfrE8Oy7wVD7FDnM4g==
X-Received: by 2002:a50:9d83:: with SMTP id w3mr3940164ede.305.1632477389296;
        Fri, 24 Sep 2021 02:56:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ck10sm5526275edb.43.2021.09.24.02.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 02:56:28 -0700 (PDT)
Message-ID: <4743aa1d-cae7-11a0-03f1-160617ae9a89@redhat.com>
Date:   Fri, 24 Sep 2021 11:56:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH V3 2/2] KVM: X86: Move PTE present check from loop body to
 __shadow_walk_next()
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <YTE3bRcZv2BiVxzH@google.com>
 <20210906122547.263316-1-jiangshanlai@gmail.com>
 <20210906122547.263316-2-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210906122547.263316-2-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/21 14:25, Lai Jiangshan wrote:
> But checking pte present in __shadow_walk_next() is a more prudent way of
> programing and loop bodies will not need to always check it. It allows us
> removing unneeded is_shadow_present_pte() in the loop bodies.
> 
> Terminating on !is_shadow_present_pte() is 100% the correct behavior, as
> walking past a !PRESENT SPTE would lead to attempting to read a the next
> level SPTE from a garbage iter->shadow_addr.  Even some paths that do_not_
> currently have a !is_shadow_present_pte() in the loop body is Ok since
> they will install present non-leaf SPTEs and the additional present check
> is just an NOP.
> 
> The checking result in __shadow_walk_next() will be propagated to
> shadow_walk_okay() for being used in any for(;;) loop.
> 
> Reviewed-by: Sean Christopherson<seanjc@google.com>
> Signed-off-by: Lai Jiangshan<laijs@linux.alibaba.com>
> ---
> Changed from V2:
> 	Fix typo in the changelog reported by Sean
> 	Add Reviewed-by from Sean
> Changed from V1:
> 	Merge the two patches
> 	Update changelog
> 	Remove !is_shadow_present_pte() in FNAME(invlpg)
>   arch/x86/kvm/mmu/mmu.c         | 13 ++-----------
>   arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>   2 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 538be037549d..26f6bd238a77 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2223,7 +2223,7 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
>   static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
>   			       u64 spte)
>   {
> -	if (is_last_spte(spte, iterator->level)) {
> +	if (!is_shadow_present_pte(spte) || is_last_spte(spte, iterator->level)) {
>   		iterator->level = 0;
>   		return;
>   	}
> @@ -3159,9 +3159,6 @@ static u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
>   	for_each_shadow_entry_lockless(vcpu, gpa, iterator, old_spte) {
>   		sptep = iterator.sptep;
>   		*spte = old_spte;
> -
> -		if (!is_shadow_present_pte(old_spte))
> -			break;
>   	}
>   
>   	return sptep;
> @@ -3721,9 +3718,6 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
>   		spte = mmu_spte_get_lockless(iterator.sptep);
>   
>   		sptes[leaf] = spte;
> -
> -		if (!is_shadow_present_pte(spte))
> -			break;
>   	}
>   
>   	return leaf;
> @@ -3838,11 +3832,8 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
>   	u64 spte;
>   
>   	walk_shadow_page_lockless_begin(vcpu);
> -	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
> +	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte)
>   		clear_sp_write_flooding_count(iterator.sptep);
> -		if (!is_shadow_present_pte(spte))
> -			break;
> -	}
>   	walk_shadow_page_lockless_end(vcpu);
>   }
>   
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 4d559d2d4d66..72f358613786 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -982,7 +982,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>   			FNAME(update_pte)(vcpu, sp, sptep, &gpte);
>   		}
>   
> -		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
> +		if (!sp->unsync_children)

Queued both, thanks.

Paolo

