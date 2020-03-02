Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1474175FAF
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 17:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgCBQcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 11:32:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45311 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727142AbgCBQcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 11:32:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583166719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SV2DzgE7/GVCHxe1MyF7cvm3oaLFW5XDl1ckEgBzooo=;
        b=HLyVTYJwLGLub/iQGFkQUC4vP3fp3+N+UVIuzfhLcE9+IjkKQ+c+Ii5d9flBxFnIK4xyOG
        AP93dm2So41DfcD1D2I8BR3Ij0tTFvgEIwycANHLpffbIaEDKmu6QAfEALk5aYKw9KQYAk
        bnoWUc8PzZxbbOoED1J30s/kKNI21to=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-T9T-YsjBNd2jfGFgxGkMaQ-1; Mon, 02 Mar 2020 11:31:58 -0500
X-MC-Unique: T9T-YsjBNd2jfGFgxGkMaQ-1
Received: by mail-wr1-f71.google.com with SMTP id d7so2074284wrr.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 08:31:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SV2DzgE7/GVCHxe1MyF7cvm3oaLFW5XDl1ckEgBzooo=;
        b=INPyoA8ls947bMmeZpEwtcPxSG73/afV+42CCSGBjHc6xLPr96j0bC0igMbeOG9Iuz
         nU2/A9cuyMzhl3IPXVFUKZ8yLbpphd4UUf1uJDSBBztVeyjTwUd9BuV1zRx40+/+NpEO
         8UPplr8wJT9wQnEIic2QDO0VxT/CZIZPpaDB6TgIjlSGIehtnhtFE5P2bWHRf8NFl3q/
         c2aJiuWanc0GbuhC2qZZ2x2NkvxY1fBJFvyBJ8a0jHVh9pQaKM4Mq4Ee8ftpm1CHhrWP
         6nnw1IK3qTbcI2zzlg/Dau+h+xT2PmEaaSRFim5d+MC6yQgN5dZ+xW609mEEV2xDo3JJ
         fDyA==
X-Gm-Message-State: ANhLgQ1nzYFKdb2409glu8F5uSNGmfv9uAuHlmikxOVl0gQketsSaJhT
        +pvKyCuaLWolUIrAI5snkxsGd+4axOJorzOT0OvU685C3O6xBHDWAAutACQRtjcw4bwfxVRA23H
        +fjTNm4liYVpx
X-Received: by 2002:a1c:ba87:: with SMTP id k129mr244108wmf.102.1583166716825;
        Mon, 02 Mar 2020 08:31:56 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuwUWhJ3l7EnEnCkmDlth1oK52o+owEznQwr9Yr2mH+gmpSnrmjs+4wXh/972NER3NftmL04w==
X-Received: by 2002:a1c:ba87:: with SMTP id k129mr244074wmf.102.1583166716453;
        Mon, 02 Mar 2020 08:31:56 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id i4sm16121618wmd.23.2020.03.02.08.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 08:31:55 -0800 (PST)
Subject: Re: [PATCH v2] KVM: X86: deprecate obsolete KVM_GET_CPUID2 ioctl
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d94a44f0-7fed-b5e4-49e8-6dd1b89185db@redhat.com>
Date:   Mon, 2 Mar 2020 17:31:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/02/20 04:21, linmiaohe wrote:
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
>  #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
>  /* Available with KVM_CAP_VAPIC */
>  #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
> 

Queued, thanks.

Paolo

