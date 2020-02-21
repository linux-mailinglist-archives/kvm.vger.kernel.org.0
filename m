Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923891681BD
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgBUPeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:34:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60986 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727312AbgBUPeA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 10:34:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582299239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E+guHrGhfox0uGOVfKWJjH3Qg42hXDUOFTb9rh1W6rw=;
        b=GpJ3okpKr0UvRueKdKm6NhOBS7ixkecCr9aWMZ9/p8K2De4kqQN1/FqMzViehnxUFH24nJ
        Rs6BxZny0wUzVWqXYPIiwjVOi4hbd2GaOe0lweD5q/LDFGj6ylatGtuQ8MyWHvm9ySUyLh
        kX1omrcQIwSqzdzZ2j2LW7vw6wckpiQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-hzcvhzXiOWSwHAoxK-OAcg-1; Fri, 21 Feb 2020 10:33:57 -0500
X-MC-Unique: hzcvhzXiOWSwHAoxK-OAcg-1
Received: by mail-wr1-f69.google.com with SMTP id d7so1178312wrx.9
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 07:33:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=E+guHrGhfox0uGOVfKWJjH3Qg42hXDUOFTb9rh1W6rw=;
        b=fBTQG7/imC2hnA/05YgehqcAtUuZKf9sEjLRKRKozrWrpZmA+4tafj26WQNPX1J5MD
         pCorkbHyuG8k4kD6GX21MS0+eYY9Z0C0zh3SoWsuzPgwsvjqNb8X7y97a/oE5ncIhcEk
         gyafU7uFqcAuaKX0y2JMoRd60Zch0WU8BPfyNXc3YTx5MZUkaEDoxHEA6dYSjQ9ZShcc
         bvswEDv0GQNygftavgY/i6F/LA2gXHrN2qBRjXH+NpF6HMNRojCsOnlP3mXVOaHNUjS/
         Cs6Nq0K1pDqvWQB/xmKVNPSMMTIDHynqXW0PNGXUOdaI3Xw+SE78pECv3Pma7AR1r9w3
         EFBA==
X-Gm-Message-State: APjAAAVfx+HbbWkWY28L5i9RS75r9tnC6sbgnNWQKcd4JFslXgS1Xkv/
        qUZWjSWPhXk+eOi6a1gdjzfCf/jox2JSktK2LS8tuoB/AlifD+hTx/RsjFXXti1iCe8sk28M80x
        1vp6M0t6t4OW7
X-Received: by 2002:adf:a3ca:: with SMTP id m10mr9979650wrb.148.1582299236463;
        Fri, 21 Feb 2020 07:33:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqxOaNg350262rKP8Ewbykavm9FIuTsZJiYbkJJJHkubI4PyxMb+9IoeLOXh2iX99PyPzJ4Yhw==
X-Received: by 2002:adf:a3ca:: with SMTP id m10mr9979628wrb.148.1582299236252;
        Fri, 21 Feb 2020 07:33:56 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c9sm4209920wme.41.2020.02.21.07.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:33:55 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/61] KVM: x86: Make kvm_mpx_supported() an inline function
In-Reply-To: <20200201185218.24473-23-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-23-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 16:33:55 +0100
Message-ID: <87h7zkq7j0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Expose kvm_mpx_supported() as a static inline so that it can be inlined
> in kvm_intel.ko.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 6 ------
>  arch/x86/kvm/cpuid.h | 1 -
>  arch/x86/kvm/x86.h   | 5 +++++
>  3 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 84006cc4007c..d3c93b94abc3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -45,12 +45,6 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  	return ret;
>  }
>  
> -bool kvm_mpx_supported(void)
> -{
> -	return supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> -}
> -EXPORT_SYMBOL_GPL(kvm_mpx_supported);
> -
>  #define F feature_bit
>  
>  int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 7366c618aa04..c1ac0995843d 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -7,7 +7,6 @@
>  #include <asm/processor.h>
>  
>  int kvm_update_cpuid(struct kvm_vcpu *vcpu);
> -bool kvm_mpx_supported(void);
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>  					      u32 function, u32 index);
>  int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 02b49ee49e24..bfac4a80956c 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -283,6 +283,11 @@ enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vc
>  extern u64 host_xcr0;
>  extern u64 supported_xcr0;
>  
> +static inline bool kvm_mpx_supported(void)
> +{
> +	return supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> +}
> +
>  extern unsigned int min_timer_period_us;
>  
>  extern bool enable_vmware_backdoor;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

