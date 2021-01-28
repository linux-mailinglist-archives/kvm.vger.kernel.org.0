Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A356306FEE
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 08:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhA1Hmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 02:42:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232152AbhA1HmZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 02:42:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611819658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/rpC7ddPFGCWpfnn+1743DPZ4Gs/0jrXdvPAj93Ra8I=;
        b=Sq+5wjhCs+iamRmV6qzGcm82iJx85k5ZwjQjl+fk1WLFaHFMsHH0YP+6FKlrwC7MB2Vm4p
        e6S918I60Yi0J+DpZJk+FY7vtubg+npUHxStZBZ6StvMVb9nWlOBRSjCkZKrjHy6I/MAPH
        MPKSl6vEw8rdIsmNHlOCfYUxjH9SVkI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-APYVHJp4NnuUFI9OWJLLjg-1; Thu, 28 Jan 2021 02:40:56 -0500
X-MC-Unique: APYVHJp4NnuUFI9OWJLLjg-1
Received: by mail-ed1-f71.google.com with SMTP id q12so2774154edr.2
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 23:40:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/rpC7ddPFGCWpfnn+1743DPZ4Gs/0jrXdvPAj93Ra8I=;
        b=rEVI4+83FwyoILhZ0tmRE/Yo7SRu6BVv7gMCdTpHta2OMp0n+TMmRiSiw66PGF4Gwe
         IPW7d6jvGkeesKaxg9NvwpaRB/w0epJwr4DPtY73dokRWSSCpTJ9xpeDI7yw2u0ZZxuY
         XnNB46Ki0gsjxougljM29nt50BnI4L3HicfQ36OWVIz/1ybFVKHTyHMrEF5BtNBc9db0
         URragUQ2ZCvl4L9rE6icT7Kwztr9yuWxgFzf6UM8bAlaANqHqJ8CN3NH1imdaOJV5VKX
         ZzQrS4znkP/LS0BLpMYvNp46mgCETqktI89R3C5lGOJ1r6H0MPkcgJ3+E5yIcE5NJAvU
         BtiQ==
X-Gm-Message-State: AOAM533TBsO/RTWxjI1bIBsge179459GDwwaJmJJLzOrueFF88BIlBkB
        Qadgj3WBeAUGmnGrFhnLpF74ssf6mEGg7Z1/8/2mJtvhn62glIsh8LC9ZDoY2lbHbYoe8M9uAzX
        GNyXEgn0ocrDv
X-Received: by 2002:aa7:c3d9:: with SMTP id l25mr13337977edr.188.1611819655516;
        Wed, 27 Jan 2021 23:40:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxFjdrmXT9dvSZ+acbS7vO5a3TnIsm96Ym62RPqqCJIS/DU2MtwL3OBa2sUxfbD2gSmy6f4Mw==
X-Received: by 2002:aa7:c3d9:: with SMTP id l25mr13337959edr.188.1611819655395;
        Wed, 27 Jan 2021 23:40:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x21sm1874078eje.118.2021.01.27.23.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 23:40:54 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: fix CPUID entries returned by KVM_GET_CPUID2
 ioctl
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com.com>
References: <20210128024451.1816770-1-michael.roth@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1aa519bb-9464-0721-17c9-7ea43ddfa536@redhat.com>
Date:   Thu, 28 Jan 2021 08:40:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210128024451.1816770-1-michael.roth@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 03:44, Michael Roth wrote:
> Recent commit 255cbecfe0 modified struct kvm_vcpu_arch to make
> 'cpuid_entries' a pointer to an array of kvm_cpuid_entry2 entries
> rather than embedding the array in the struct. KVM_SET_CPUID and
> KVM_SET_CPUID2 were updated accordingly, but KVM_GET_CPUID2 was missed.
> 
> As a result, KVM_GET_CPUID2 currently returns random fields from struct
> kvm_vcpu_arch to userspace rather than the expected CPUID values. Fix
> this by treating 'cpuid_entries' as a pointer when copying its
> contents to userspace buffer.
> 
> Fixes: 255cbecfe0c9 ("KVM: x86: allocate vcpu->arch.cpuid_entries dynamically")
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com.com>
> ---
>   arch/x86/kvm/cpuid.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 13036cf0b912..38172ca627d3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -321,7 +321,7 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>   	if (cpuid->nent < vcpu->arch.cpuid_nent)
>   		goto out;
>   	r = -EFAULT;
> -	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
> +	if (copy_to_user(entries, vcpu->arch.cpuid_entries,
>   			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
>   		goto out;
>   	return 0;
> 

Queued, thanks.  I'll also write a testcase.

Paolo

