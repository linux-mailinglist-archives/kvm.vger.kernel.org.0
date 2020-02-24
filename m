Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4F116A37B
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 11:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBXKGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 05:06:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38842 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726509AbgBXKGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 05:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582538810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ro7hbSrhbV6QQf7iIOQlkTIE8EO1Z4s/xtlyNWIthpI=;
        b=PIGP89ZzXIAbbeD8F7yN6Mn5Yvnz3w9cCS8TwEKR9dF81aWOYS9XTZs0eqzaQKOnTTXzgq
        dqnUEgQAb0WfXLKeiJukbMTntv/dY3f1Jp3f4GmHsMlpqxj21ZjYq1I0AliNsm4ZySi2rY
        ulHSjEHFIhT/kJvNmpFE5gHwPRnvYeo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-9mWIY8ZoP3q9EA4Jlr-l6A-1; Mon, 24 Feb 2020 05:06:48 -0500
X-MC-Unique: 9mWIY8ZoP3q9EA4Jlr-l6A-1
Received: by mail-wr1-f71.google.com with SMTP id h4so132266wrp.13
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 02:06:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ro7hbSrhbV6QQf7iIOQlkTIE8EO1Z4s/xtlyNWIthpI=;
        b=LkD9JdjhbB0p6GcpUlHiD5ZC5U8eNHV9fGg2e0fPa58vzwEYi3tJeIuzl7k24gNz85
         fc4EyNUHbYWQ+YfpEepuCuGZTprkRg2J6sGrPyw1a6eVroLlUjVXd9YkHYaTtNS8vEYT
         gTxe7kQy52coKkJ5vktTTBDgg2497Kh+J5QAkEyyHOCv/NkI+PISjZqs5ojgVoT1qTMF
         s9cU7alsgobJsIXjhuiDnd4Ow1/5Q3ONcuVMBd/O1b4WBZ2MqGP1K1P+GbQxDNXCyKgd
         3BBDrwkSO11+nS6mmBpdf6fxjstSAlwpRYg9WH/UapQ62q6sMYfx+z+FwqJhlRreYymk
         DQSQ==
X-Gm-Message-State: APjAAAU7NDlcQSRf05hk6yY29jwyKOpkSTZxAuIwCC2R7G5/xIdECl9p
        b5bHKXkMMW86AbbsAQ2+QtJ/LW9rYbJtaS2sDzzGzE0i5SOVQ4n81fXWwa3tHRrkwS6tmoguZ2y
        C+kp8hR9UNdbX
X-Received: by 2002:a05:600c:291e:: with SMTP id i30mr21938672wmd.40.1582538807598;
        Mon, 24 Feb 2020 02:06:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqx2oYNyKCIkJ9tYswwTh+AP5S3FN10V3XIgU+IuB437b4pbTmM9yfG3v2DmNnjXERGuyBka/g==
X-Received: by 2002:a05:600c:291e:: with SMTP id i30mr21938634wmd.40.1582538807266;
        Mon, 24 Feb 2020 02:06:47 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k16sm18277255wru.0.2020.02.24.02.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 02:06:46 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH RESEND] KVM: X86: eliminate obsolete KVM_GET_CPUID2 ioctl
In-Reply-To: <1582516032-5161-1-git-send-email-linmiaohe@huawei.com>
References: <1582516032-5161-1-git-send-email-linmiaohe@huawei.com>
Date:   Mon, 24 Feb 2020 11:06:45 +0100
Message-ID: <87o8topadm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> KVM_GET_CPUID2 ioctl is straight up broken 

It may make sense to add the gory details from your previous patch where
you were trying to fix it.

> and not used anywhere. Remove it directly.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/cpuid.c           | 20 --------------------
>  arch/x86/kvm/cpuid.h           |  3 ---
>  arch/x86/kvm/x86.c             | 17 -----------------
>  include/uapi/linux/kvm.h       |  1 -
>  tools/include/uapi/linux/kvm.h |  1 -
>  5 files changed, 42 deletions(-)
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
> index fbabb2f06273..ddcc51b89e2c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4286,23 +4286,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  					      cpuid_arg->entries);
>  		break;
>  	}
> -	case KVM_GET_CPUID2: {
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
> -		break;
> -	}
>  	case KVM_GET_MSRS: {
>  		int idx = srcu_read_lock(&vcpu->kvm->srcu);
>  		r = msr_io(vcpu, argp, do_get_msr, 1);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4b95f9a31a2f..b37b8c1f300e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1380,7 +1380,6 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
>  #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
>  #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
> -#define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)

Even if we decide to be strong and remove KVM_GET_CPUID2 completely, I'd
suggest we leave a comment here saying that it was deprecated. Leaving
the branch in case (returning the same -EINVAL as passing an unsupported
IOCTL) may also make sense (with a 'deprecated' comment of course).

>  /* Available with KVM_CAP_VAPIC */
>  #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
>  /* Available with KVM_CAP_VAPIC */
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index f0a16b4adbbd..431106dedd2c 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1379,7 +1379,6 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
>  #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
>  #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
> -#define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
>  /* Available with KVM_CAP_VAPIC */
>  #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
>  /* Available with KVM_CAP_VAPIC */

-- 
Vitaly

