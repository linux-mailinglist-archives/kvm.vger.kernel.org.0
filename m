Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF7C161892
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 18:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbgBQRLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 12:11:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59183 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727277AbgBQRLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 12:11:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581959508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=leoJMIVrujXHR+1B3Le9Ku9YRkCu9ED/B2eHIqy0AMM=;
        b=C5nvWqFKEZYCaP0LO7QQ0NOB/cCAzQvSreM8sKeE2udW3/3lWUbn0i+MUzFmX2j919qFll
        jYmqXAgeI4EJgpXM1NZ7Br7hNQrJIoephW1R84aj+V2CojblMb/3l4b2xbr0cq0xAZhu/F
        +A+v/chpAMgeJ+9cyD7LEneGOw77Jyg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-BgAGEHmNOmOW1qtBTu9Pyw-1; Mon, 17 Feb 2020 12:11:47 -0500
X-MC-Unique: BgAGEHmNOmOW1qtBTu9Pyw-1
Received: by mail-wr1-f71.google.com with SMTP id 90so9245424wrq.6
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:11:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=leoJMIVrujXHR+1B3Le9Ku9YRkCu9ED/B2eHIqy0AMM=;
        b=mokYUr6iDkNLdB74yiMwdM1/KTXwoASrtOwzhkt9MohFepwmLE1PM6qlcgX7NA7bw1
         1wBWIHaPWirDyo8wFMalTfj4G3EOPxtB5Y8R0ia4uWlgFGITxu8QnegC9tjc4ESOqdB8
         vNxSHXTQBYDPuYyYYHvTQdkctwr3+RkQ17WVLVrCx7XhG1sh5j6eadLH7FgNVXKJMoT7
         Ug8jt88/XtC5BaIr0fExCjuI3z18sMaWeW1COJ49VBUBV4eevqbzL+SChbH02xvw99sy
         xhmVSwPgrRv/agyZHdSuXTvM3o1FkR/lzvc1dKsCznri9aLld2iObV3drANxZlZAXfOU
         SpJQ==
X-Gm-Message-State: APjAAAUXTBwnH+MhXYK+iq6lqDKomP6jr/ueOQzJvYw++VIdouoiPOv3
        c+CagSo5qHu/EfgQHHESLta2QcZLU3zb52PQp0eGkd8QYCIPXXIP0YhVcCiETvMQ4Pco9lxhXD7
        2XksbxKyqd4fW
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr53661wma.84.1581959505682;
        Mon, 17 Feb 2020 09:11:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqyc3kAzEzp60v3wlpcZz3+V4nTnF88wgPHYMMKj2MdprBmNt1fNlvlTiF7mjwEkOVmMJb97RA==
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr53647wma.84.1581959505445;
        Mon, 17 Feb 2020 09:11:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id 133sm74730wme.32.2020.02.17.09.11.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 09:11:44 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: eliminate some unreachable code
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1581562405-30321-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <534d00dd-ca31-b0d1-d9be-1324a851005e@redhat.com>
Date:   Mon, 17 Feb 2020 18:11:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1581562405-30321-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/20 03:53, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> These code are unreachable, remove them.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 1 -
>  arch/x86/kvm/x86.c     | 3 ---
>  2 files changed, 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bb5c33440af8..b6d4eafe01cf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4505,7 +4505,6 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
>  	case GP_VECTOR:
>  	case MF_VECTOR:
>  		return true;
> -	break;
>  	}
>  	return false;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fbabb2f06273..a597009aefd7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3081,7 +3081,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		break;
>  	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
>  		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
> -		break;
>  	case MSR_IA32_TSCDEADLINE:
>  		msr_info->data = kvm_get_lapic_tscdeadline_msr(vcpu);
>  		break;
> @@ -3164,7 +3163,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		return kvm_hv_get_msr_common(vcpu,
>  					     msr_info->index, &msr_info->data,
>  					     msr_info->host_initiated);
> -		break;
>  	case MSR_IA32_BBL_CR_CTL3:
>  		/* This legacy MSR exists but isn't fully documented in current
>  		 * silicon.  It is however accessed by winxp in very narrow
> @@ -8471,7 +8469,6 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  		break;
>  	default:
>  		return -EINTR;
> -		break;
>  	}
>  	return 1;
>  }
> 

Queued, thanks.

Paolo

