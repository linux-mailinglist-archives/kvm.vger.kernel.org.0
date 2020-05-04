Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5501C4063
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgEDQpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:45:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47128 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729634AbgEDQpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:45:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588610742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YNaKyAb40B6LULT3lpo1a7elAdvzYxfJwezsPfhvc1o=;
        b=ezrZLJcNS0haVvvTqGDCP9nVMwY1NFQN+2wVCmjipqHalMawuTdHfzRMHk/wn1yd+Y2JTj
        +/qEpS0tetVcTsW9sbIz/bfCFVREF++0ZinSQHhmEXsJNdrQNsso3PVuyZVq1zfPJwxu0W
        giATFSFKak1QPX3AOIYoAc9zdzEImt4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-75u_xqIMPbmSjIp47ti93A-1; Mon, 04 May 2020 12:45:40 -0400
X-MC-Unique: 75u_xqIMPbmSjIp47ti93A-1
Received: by mail-wr1-f70.google.com with SMTP id x8so2328078wrl.16
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:45:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YNaKyAb40B6LULT3lpo1a7elAdvzYxfJwezsPfhvc1o=;
        b=tN1D2xT7tln0unq+eAktaR+qiju+gO8K9/XMG1jAoeMhaHqjzH1YC8OT9HzgYZOUI1
         qtS5vJe2gTR5VM29m3R7sova+TUlC/BuIe3yQWUkEwpdXkvjbVoc6ZxeDn4K+xALwfkQ
         kDjSlNDm6hpgXp8kDN4Dk1RR/3AbJ9IdRnhmDcUMxiNj4jKisa95Ey3EqTJm5mbHYqqw
         sXUeuIcXzVsx8mUWL84DVUSxkXdTK+cMY96AJDm5a9BWhP4vEjeW62T6dy6hkJHj43GC
         ge3ClS4PxfqI2FK7VsCRsW4+KlxpRJxrntEq547YuXVal+OI/5QZW3jD01fCSr7Mtlxx
         hIgQ==
X-Gm-Message-State: AGi0PuZhG/9fuYOtleJ9Ybc9l31VlVG8x5CVZmuAEzK0mAFCsI4TMM/l
        OFmg5O4HC2UXqQJbbC6W9HaQDHdm8EZpqDN7isL0g5d5zJyjF1JYaTNd9Db9wszxiUZ0GBju3KK
        7hdOUEaBxxmW7
X-Received: by 2002:a5d:6107:: with SMTP id v7mr184356wrt.270.1588610739679;
        Mon, 04 May 2020 09:45:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypITUk7jCTj5Hm092AEZmgMQAQgzYeMQr4Zkt6Tf8ONMprMl7bKLDdzpLGNVy/Fusr3loI9/8A==
X-Received: by 2002:a5d:6107:: with SMTP id v7mr184342wrt.270.1588610739428;
        Mon, 04 May 2020 09:45:39 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id d18sm16408590wrv.14.2020.05.04.09.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:45:38 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Cleanup vcpu->arch.guest_xstate_size
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200429154312.1411-1-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e6371255-b3ce-b86e-a317-058740e4bf3e@redhat.com>
Date:   Mon, 4 May 2020 18:45:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200429154312.1411-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 17:43, Xiaoyao Li wrote:
> vcpu->arch.guest_xstate_size lost its only user since commit df1daba7d1cb
> ("KVM: x86: support XSAVES usage in the host"), so clean it up.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/cpuid.c            | 8 ++------
>  arch/x86/kvm/x86.c              | 2 --
>  3 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7cd68d1d0627..34a05ca3c904 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -654,7 +654,6 @@ struct kvm_vcpu_arch {
>  
>  	u64 xcr0;
>  	u64 guest_supported_xcr0;
> -	u32 guest_xstate_size;
>  
>  	struct kvm_pio_request pio;
>  	void *pio_data;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6828be99b908..f3eb4f171d3d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -84,15 +84,11 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
>  
>  	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
> -	if (!best) {
> +	if (!best)
>  		vcpu->arch.guest_supported_xcr0 = 0;
> -		vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
> -	} else {
> +	else
>  		vcpu->arch.guest_supported_xcr0 =
>  			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
> -		vcpu->arch.guest_xstate_size = best->ebx =
> -			xstate_required_size(vcpu->arch.xcr0, false);
> -	}
>  
>  	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
>  	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 856b6fc2c2ba..7cd51a3acc43 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9358,8 +9358,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	}
>  	fx_init(vcpu);
>  
> -	vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
> -
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>  
>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
> 

Queued, thanks.

Paolo

