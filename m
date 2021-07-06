Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2323BD92D
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhGFO70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:59:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232714AbhGFO7S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625583399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pphVdAY42j5vLg/LcgALH/N+rkpuRbYxBGrB4jO5HDk=;
        b=FR/h/DYWz03pd3TCT7UQofSCRVIW25yQKNCK1MThQM7Wnj8hy4MRSsgSN38uHYAVNzygj8
        YJfSQvCDEzfvibZRY7gy/eT2KjebmaJ0q5cREnuB73PfyW8VLiovcYMg4T4nrKFN+2Fxu6
        XJC9DQJurqrbchCRCCeXMc3C/Tr3js8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-BRg6xS1dOzmZZPWTSlynag-1; Tue, 06 Jul 2021 10:56:36 -0400
X-MC-Unique: BRg6xS1dOzmZZPWTSlynag-1
Received: by mail-ed1-f71.google.com with SMTP id cn11-20020a0564020cabb0290396d773d4c7so6166044edb.18
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pphVdAY42j5vLg/LcgALH/N+rkpuRbYxBGrB4jO5HDk=;
        b=ZC8UI3Z9WUEJtjg2vXNNDvn/Q2X298VnHCiTaGLqmGkKWBWKoxdSqbjK0nMMJxB5Na
         PxBnc5DjbOKjtjBFfjGhz4dJrCOwWHdlcCl3p5o6G2THViO61z9wnbHTAHxTAbUEkvlv
         AiJw6wwdRuTb3HoxL9B2dnGyZkVF/qrF/Ucu55EvhAbAirBmDBXPAVPVwFAlmOoe0o38
         rpg8rkYCthxXZ4ueQrO7PFcl2mVZ7V+VDBb+5HecivMouFVXwSeFZCA7j9rs5Y9pO6o1
         YhaQPs+Fjg8FLmxhFRFpITCmEQA48+VrG35JfNroP/PSU4uT6j5mG8FA9D4xd7QCnG1J
         XGPg==
X-Gm-Message-State: AOAM532yUm/jogXRAeOE0pLTCWxD/+gNOoEAj8Jo5e/JY7C5nbGchq1Q
        CALyKq8Esq+fvSu7lxHnrHxp5xgYMNzHxl0HhWh2JRINtkezMxEG8LJ8jWvl7/tmyy7CeML5EzA
        tgSXe/iEr/sRK
X-Received: by 2002:a05:6402:1042:: with SMTP id e2mr16431950edu.144.1625583395057;
        Tue, 06 Jul 2021 07:56:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCqnufkfdxsOpYAPxKG24EXK/at0E2Xe9ZDQJVrVJkDdwrFaCrCxs8ya2LhLdu7GUHXVnTug==
X-Received: by 2002:a05:6402:1042:: with SMTP id e2mr16431929edu.144.1625583394915;
        Tue, 06 Jul 2021 07:56:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h7sm7234037edb.13.2021.07.06.07.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:56:32 -0700 (PDT)
Subject: Re: [RFC PATCH v2 44/69] KVM: x86/mmu: Refactor shadow walk in
 __direct_map() to reduce indentation
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <702419686d5700373123f6ea84e7a946c2cad8b4.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d3ac2aa5-215e-590f-14bf-8ccc4b0d410d@redhat.com>
Date:   Tue, 6 Jul 2021 16:56:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <702419686d5700373123f6ea84e7a946c2cad8b4.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Employ a 'continue' to reduce the indentation for linking a new shadow
> page during __direct_map() in preparation for linking private pages.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1c40dfd05979..0259781cee6a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2910,16 +2910,15 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>   			break;
>   
>   		drop_large_spte(vcpu, it.sptep);
> -		if (!is_shadow_present_pte(*it.sptep)) {
> -			sp = __kvm_mmu_get_page(vcpu, base_gfn,
> -						gfn_stolen_bits, it.addr,
> -						it.level - 1, true, ACC_ALL);
> -
> -			link_shadow_page(vcpu, it.sptep, sp);
> -			if (is_tdp && huge_page_disallowed &&
> -			    req_level >= it.level)
> -				account_huge_nx_page(vcpu->kvm, sp);
> -		}
> +		if (is_shadow_present_pte(*it.sptep))
> +			continue;
> +
> +		sp = __kvm_mmu_get_page(vcpu, base_gfn, gfn_stolen_bits,
> +					it.addr, it.level - 1, true, ACC_ALL);
> +
> +		link_shadow_page(vcpu, it.sptep, sp);
> +		if (is_tdp && huge_page_disallowed && req_level >= it.level)
> +			account_huge_nx_page(vcpu->kvm, sp);
>   	}
>   
>   	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

