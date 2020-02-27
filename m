Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F45B17161F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 12:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgB0LgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 06:36:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728872AbgB0LgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 06:36:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582803366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uVQ4UrFOEJRzhioCmCv1VYaFqrxHNCAJFi8KjCa8cJg=;
        b=N96mK6rdIWjViAbGX8LcWWjlVecy2UxjAXQZfwmNKmqEyiuZi5ciKG+bYhLQXxuvKqkKiY
        dUu/hznAZqm5/iV9kVADzJWL2kCBMuqrbMupJI0VZuXKb+/x4cciF1yBk+uQ9iKNz/coRz
        fn2+5uUUTYTJnskUzCwkdJ4Ejy5GmPk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-geG7wH2WNc2-uuh8sbph6w-1; Thu, 27 Feb 2020 06:36:05 -0500
X-MC-Unique: geG7wH2WNc2-uuh8sbph6w-1
Received: by mail-wm1-f69.google.com with SMTP id w3so602366wmg.4
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 03:36:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uVQ4UrFOEJRzhioCmCv1VYaFqrxHNCAJFi8KjCa8cJg=;
        b=A85yMpGRodyxVvu5TPceUhqaPwH5so+VV7jWNm7s1H/3uwtMfPfU2arDRpEnV23gnd
         dlaX8Q4dL4M2vsplWljBYHcfNJo9OTgwzFbBprL7MlT/ZDDJi/RVjl0U14E2XYxsHXs0
         /TymbNaF/jriED43YbOvaaxMyna78F2cIpRRnGsKwnjLkaRCMfgVaqPbC0awYZWx4XXr
         /2fPPHQ/VcMjNkapf+dpJBBootrSJqxwmEhNG8m7vhe5FWGNQhCq7MFYP+pJN5R/4fos
         VnH6MjSQemuhNKCpN2fHBiObuMlf/vK/rc0KPyQ+XQfNbGyjqKXjfGZS7I65FnBc86Df
         DWnQ==
X-Gm-Message-State: APjAAAVZ7NZ77HQ3UDZdoW/f6j7H18y77Q0ORjwZy8j9AtiVe5NNwwHG
        ohEY0VCcq/LaC+xA6KU9jBlgAHNPHjLluNWtFtQ1yfF0f+zINTln2E2+BazXEFP4BE5VFkTM6za
        ANPjaivLwR8t8
X-Received: by 2002:adf:e8c9:: with SMTP id k9mr4544675wrn.168.1582803363754;
        Thu, 27 Feb 2020 03:36:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDaaM12pU1FU72etvD1vEMwgRRIG+zPVsAVVfIIHJu3O+u7sapzuEbKCmrJwKJUKhyeSmG6A==
X-Received: by 2002:adf:e8c9:: with SMTP id k9mr4544621wrn.168.1582803363388;
        Thu, 27 Feb 2020 03:36:03 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y17sm7457215wrs.82.2020.02.27.03.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 03:36:02 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     linmiaohe@huawei.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2] KVM: X86: deprecate obsolete KVM_GET_CPUID2 ioctl
In-Reply-To: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
References: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 27 Feb 2020 12:36:00 +0100
Message-ID: <87ftewi7of.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> When kvm_vcpu_ioctl_get_cpuid2() fails, we set cpuid->nent to the value of
> vcpu->arch.cpuid_nent. But this is in vain as cpuid->nent is not copied to
> userspace by copy_to_user() from call site. Also cpuid->nent is not updated
> to indicate how many entries were retrieved on success case. So this ioctl
> is straight up broken. And in fact, it's not used anywhere. So it should be
> deprecated.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/cpuid.c           | 20 --------------------
>  arch/x86/kvm/cpuid.h           |  3 ---
>  arch/x86/kvm/x86.c             | 16 ++--------------
>  include/uapi/linux/kvm.h       |  1 +
>  tools/include/uapi/linux/kvm.h |  1 +
>  5 files changed, 4 insertions(+), 37 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..5e041a1282b8 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -261,26 +261,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> -int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
> -			      struct kvm_cpuid2 *cpuid,
> -			      struct kvm_cpuid_entry2 __user *entries)
> -{
> -	int r;
> -
> -	r = -E2BIG;
> -	if (cpuid->nent < vcpu->arch.cpuid_nent)
> -		goto out;
> -	r = -EFAULT;
> -	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
> -			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
> -		goto out;
> -	return 0;
> -
> -out:
> -	cpuid->nent = vcpu->arch.cpuid_nent;
> -	return r;
> -}
> -
>  static __always_inline void cpuid_mask(u32 *word, int wordnum)
>  {
>  	reverse_cpuid_check(wordnum);
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 7366c618aa04..76555de38e1b 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -19,9 +19,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  			      struct kvm_cpuid2 *cpuid,
>  			      struct kvm_cpuid_entry2 __user *entries);
> -int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
> -			      struct kvm_cpuid2 *cpuid,
> -			      struct kvm_cpuid_entry2 __user *entries);
>  bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  	       u32 *ecx, u32 *edx, bool check_limit);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ddd1d296bd20..a6d99abedb2c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4295,21 +4295,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  					      cpuid_arg->entries);
>  		break;
>  	}
> +	/* KVM_GET_CPUID2 is deprecated, should not be used. */
>  	case KVM_GET_CPUID2: {
> -		struct kvm_cpuid2 __user *cpuid_arg = argp;
> -		struct kvm_cpuid2 cpuid;
> -
> -		r = -EFAULT;
> -		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
> -			goto out;
> -		r = kvm_vcpu_ioctl_get_cpuid2(vcpu, &cpuid,
> -					      cpuid_arg->entries);
> -		if (r)
> -			goto out;
> -		r = -EFAULT;
> -		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
> -			goto out;
> -		r = 0;
> +		r = -EINVAL;
>  		break;
>  	}

Braces are not really needed not but all other cases in the switch have
it so let's leave them here too.

>  	case KVM_GET_MSRS: {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4b95f9a31a2f..61524780603d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1380,6 +1380,7 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
>  #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
>  #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
> +/* KVM_GET_CPUID2 is deprecated, should not be used. */
>  #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
>  /* Available with KVM_CAP_VAPIC */
>  #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index f0a16b4adbbd..2ef719af4c57 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1379,6 +1379,7 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
>  #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
>  #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
> +/* KVM_GET_CPUID2 is deprecated, should not be used. */

"should not be used" pre-patch, post-patch we can say "Can only be used
as a reliable source of -EINVAL" :-)

>  #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
>  /* Available with KVM_CAP_VAPIC */
>  #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)

Surprisingly (or not), KVM_GET_CPUID2 is not even described in
Documentation/virt/kvm/api.txt.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

