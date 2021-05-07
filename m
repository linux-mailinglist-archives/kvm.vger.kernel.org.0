Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E115A376910
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 18:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbhEGQxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 12:53:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49406 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233797AbhEGQxS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 12:53:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620406337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h+S8doMBTdYelFV+sS7BmEZ8OEDR2ZNO9i+PaJSM0AA=;
        b=CneR1B49BjclH6XNs1j487ddELgcvC6svCreXqoi8ijzV18nrCb0q7gAtiY8SVUEi3rUpQ
        3zUMfYwZPpiynSgfOUFEbeHXpSdmMUxIiYPctlperjPT1G6vYhBQ9YsrMJIWX6qcx57mdF
        Ecmzujcv85OKpp7KxRP5su9BlWC6vUI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-PTY1eAWuOOSoDscDlKTH9g-1; Fri, 07 May 2021 12:52:16 -0400
X-MC-Unique: PTY1eAWuOOSoDscDlKTH9g-1
Received: by mail-wr1-f69.google.com with SMTP id t18-20020adfdc120000b02900ffe4432d8bso3848573wri.6
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 09:52:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h+S8doMBTdYelFV+sS7BmEZ8OEDR2ZNO9i+PaJSM0AA=;
        b=YCcAQ+KF2h0MZ1ZKdJHNZPC4sCbV+qcxo/eSUOhTpeYNbVqkc4CtSocKaDoW+93UPZ
         YWurnvTWLZrXM7u3ZnCnNJa/Tf2OkbFNcmQ0B7W0vqX4h1oy1JRc6bmZ434wFmafzWXj
         qzxRgKvcOZEydhV+2MWmtJrgYR9etFfDJzXTEHGCmBHVDvbcPn+vbY57ZzExPn/D1Voi
         bXFgOJWQgwjgA/zIMfwur35ufpBmovu0xBk01lhJmGvLbzC+nxRihvaKLMqada0w2/KM
         Uejxy/5yCQJzZPGhC31L2w9IMHy+V73tXEMD5pyYcXtCXYtiFA/br9/jThZB/o1CPfH7
         /18w==
X-Gm-Message-State: AOAM531iUzHzfAkZH+2m0MnjzdJmTYuKM6VypR7n3MvZB+DomlBh9btA
        3cv2oQ5M0LmljxruF+qXjxvmu37QOTk2OgRLmOlJCLocDqdfi6BiwnBLCZV+Ou7MFqrk4Yx04l2
        ZfzXm1MEVW2pNdgZ621ehtjeu9n0WWEwIOA9BjQOZeu8OSsnqmhOJSCL31qW4KzEX
X-Received: by 2002:adf:f2ce:: with SMTP id d14mr8283561wrp.384.1620406334784;
        Fri, 07 May 2021 09:52:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuHIzab3som8mEifHdG6z6H0HXWrTHx5n8FsQjFIT8yASS8a8NGyLOblNiq/WP2hLJEnnaxQ==
X-Received: by 2002:adf:f2ce:: with SMTP id d14mr8283517wrp.384.1620406334515;
        Fri, 07 May 2021 09:52:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f3sm8460641wrp.7.2021.05.07.09.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 09:52:13 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
To:     Jon Kohler <jon@nutanix.com>
Cc:     Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210507164456.1033-1-jon@nutanix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <16af038e-5b30-2509-4e3b-3b3ed9d4b81e@redhat.com>
Date:   Fri, 7 May 2021 18:52:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210507164456.1033-1-jon@nutanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nice one.  The patch can be made simpler though (I think).

On 07/05/21 18:44, Jon Kohler wrote:
  @@ -122,7 +124,7 @@ static inline u32 rdpkru(void)
>   	return 0;
>   }
> 
> -static inline void __write_pkru(u32 pkru)
> +static inline void __write_pkru(u32 pkru, bool skip_comparison)
>   {
>   }
>   #endif
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cebdaa1e3cf5..cd95adbd140c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -912,10 +912,10 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>   	}
> 
>   	if (static_cpu_has(X86_FEATURE_PKU) &&
> -	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
> -	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
> -	    vcpu->arch.pkru != vcpu->arch.host_pkru)
> -		__write_pkru(vcpu->arch.pkru);
> +	    vcpu->arch.pkru != vcpu->arch.host_pkru &&
> +	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
> +	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE)))
> +		__write_pkru(vcpu->arch.pkru, false);

This can be optimized as well, can't it?  This means that the only case 
that needs the rdpkru is in switch_fpu_finish, and __write_pkru can be 
removed completely:

- do the rdpkru+wrpkru in switch_fpu_finish

- just use wrpkru in KVM

Paolo


>   }
>   EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
> 
> @@ -925,11 +925,11 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>   		return;
> 
>   	if (static_cpu_has(X86_FEATURE_PKU) &&
> -	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
> -	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
> +	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
> +	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE))) {
>   		vcpu->arch.pkru = rdpkru();
>   		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
> -			__write_pkru(vcpu->arch.host_pkru);
> +			__write_pkru(vcpu->arch.host_pkru, true);
>   	}
> 
>   	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
> --
> 2.30.1 (Apple Git-130)
> 

