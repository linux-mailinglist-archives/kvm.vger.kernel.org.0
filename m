Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55A73DE919
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 11:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhHCJAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 05:00:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234554AbhHCJAp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 05:00:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627981234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9UH0gpcsz/cdHoJVPf064lHW6QX70PQL8rmdmVm5V1c=;
        b=OZ+YEf+Ic4A0+je0njOwaLHYjr8VKuRZtztUAlhAwj7ArU3MiqtCi7f+Pt7xdORzVJQNrK
        WenNikWR6qW2vMEINZwe4UnX4ng0+eRQi0BHr4kz1kHvW/+je7MJpYAC/aIEGYfmcN/ATb
        XEP4NHDLhiof8Cbp7Wa/OiLj+xXlAZA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-wTh-Co-TNh-yZuacbrQqaQ-1; Tue, 03 Aug 2021 05:00:33 -0400
X-MC-Unique: wTh-Co-TNh-yZuacbrQqaQ-1
Received: by mail-wr1-f72.google.com with SMTP id p12-20020a5d68cc0000b02901426384855aso7312609wrw.11
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 02:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9UH0gpcsz/cdHoJVPf064lHW6QX70PQL8rmdmVm5V1c=;
        b=I4xQBZbU98QyuHyuPL+8/jeMK0j7mmhG7XunJUAwfMyzykKRb8JIzfC8aR4JFVI0SG
         DycRpNjCysL5xLs++jyvrDzKxoWV3lXJxw97fQRyRVYvOxUgQ2CMpEuwuIdN2MkSqxVU
         pAtm2Is38yGy2zYvk5EKdx7b+scPJXrbQ3xWakMp/ygUP59f8EMSIJnFEfSBportBfVn
         2KRf4UBA4UVWD6v4IuHILsgvTeWVaZYUcXn9iyiuWPMkUPan5Sq2/Lrj1FZcOeoRtlMh
         mt9+936riL0UUGJEkKmUnvcXxdI2TEAfGyq6ZpnAY+HpOBD19bJkjXxWU/gQ0R86aIju
         MIWg==
X-Gm-Message-State: AOAM530r7J75fgKAOIaXzxSqsUMdy8ezHgeQbADbPdHLBIsU4J53GI/E
        sK8d0l+5mtnUCXMv7sixopRrr0z6Q8VY2mRjgToiSmi/a9Jidyq3dnSdTCbkM3TPhai4nqbN+sG
        Xi/efW7SsWvJw
X-Received: by 2002:a1c:188:: with SMTP id 130mr3208933wmb.122.1627981231921;
        Tue, 03 Aug 2021 02:00:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlx9U65dG5iOGg+nn1zcieWJgrvlrWZan5a+mAwh+5cAXSF//R8+mFLP2xQqFq1bv7rXUQIw==
X-Received: by 2002:a1c:188:: with SMTP id 130mr3208916wmb.122.1627981231688;
        Tue, 03 Aug 2021 02:00:31 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id s1sm1873569wmj.8.2021.08.03.02.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 02:00:31 -0700 (PDT)
Subject: Re: [PATCH v3 03/12] KVM: x86/mmu: rename try_async_pf to
 kvm_faultin_pfn
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
 <20210802183329.2309921-4-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7dbd1416-5cf7-4950-e391-d45190f8313d@redhat.com>
Date:   Tue, 3 Aug 2021 11:00:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802183329.2309921-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 20:33, Maxim Levitsky wrote:
> try_async_pf is a wrong name for this function, since this code
> is used when asynchronous page fault is not enabled as well.
> 
> This code is based on a patch from Sean Christopherson:
> https://lkml.org/lkml/2021/7/19/2970
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/mmu/mmu.c         | 4 ++--
>   arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9da635e383c2..c5e0ecf5f758 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3842,7 +3842,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
>   }
>   
> -static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
> +static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>   			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
>   			 bool write, bool *writable)
>   {
> @@ -3912,7 +3912,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>   	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>   	smp_rmb();
>   
> -	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
> +	if (kvm_faultin_pfn(vcpu, prefault, gfn, gpa, &pfn, &hva,
>   			 write, &map_writable))
>   		return RET_PF_RETRY;
>   
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index ee044d357b5f..f349eae69bf3 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -881,7 +881,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>   	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>   	smp_rmb();
>   
> -	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
> +	if (kvm_faultin_pfn(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
>   			 write_fault, &map_writable))
>   		return RET_PF_RETRY;
>   
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

