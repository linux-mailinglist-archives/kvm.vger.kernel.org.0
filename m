Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A5C49F975
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348486AbiA1MeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:34:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348420AbiA1MeB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 07:34:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643373240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7D5MGxvNeSIaDmzU5U2LWtJYI/+mf3HB+SUBlSno+yM=;
        b=PNo3vRu40NzFP2dCqwW/MUZZ/040AadGuG+ePPcdEQkL2jt7HOj1osbMjDu4SEbwEdKZau
        O3ou0B5ANqPJtqMqBf0NvpiLkgHgPSjd8Rb0BjfDXKdFDzyA53hbzk+JmQ1KZo/2rUeUz8
        BG4cLfMCJKNNelw2cp/9QSMc/FWpzSU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-PUSHtQtsOCymLV_vNi1dPQ-1; Fri, 28 Jan 2022 07:33:59 -0500
X-MC-Unique: PUSHtQtsOCymLV_vNi1dPQ-1
Received: by mail-ed1-f70.google.com with SMTP id a18-20020aa7d752000000b00403d18712beso2968562eds.17
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:33:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7D5MGxvNeSIaDmzU5U2LWtJYI/+mf3HB+SUBlSno+yM=;
        b=Lw1grdxL2GUR0h/2Oc3l0Mn0f/EkebpsqgIy0sIwAleWQGZYAsSo8u0FKadHFGxs38
         Ryb3SCam7oJmWchXvV0XC3z/d0bDWRVjS3+0NILVM0KXfuJbrCh5xFhwqq7R/VJPXy84
         DQy8v7eDc1U79HSLF4V+Qvg3Gh1RJ4IhtRsqZsgyEtU0Ly1PQEftZnx38/8o1e9uv40J
         Kq3fv4LDSMlq6UyASNIMZM4XDLjZ+mVsaVZ5+7wVP+lDa9YyOTlt8NPZ953srNTzZVbN
         q4La9VRzsgRjK0RpbCeZ2OqeGRHHgaQz+leb2kFyuBdx5koS+AJmfq+t6SCvnOTBrPXr
         /gIg==
X-Gm-Message-State: AOAM531aEeNxYtQUFYeowOQ7tt2wuHnZ/YQUXN6jqKfJhVb/DIWjbP/c
        gJrjqd5oQpAEq0VwP+pqOuCw7BJqWHyH3JlJpx8iZkW2HhL7dB7zjAnVHl+awEQiPa5wSYww1zb
        AXkW+IFX01UfA
X-Received: by 2002:a05:6402:190d:: with SMTP id e13mr8080142edz.38.1643373237887;
        Fri, 28 Jan 2022 04:33:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy52Rs6964KyARBdJjsJHusFiyPA0f3U/obO2pyNjstmroPfcuRrjSDtYQ9uiKJa9zVif1K5Q==
X-Received: by 2002:a05:6402:190d:: with SMTP id e13mr8080116edz.38.1643373237627;
        Fri, 28 Jan 2022 04:33:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id p12sm9913497ejd.180.2022.01.28.04.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 04:33:56 -0800 (PST)
Message-ID: <abfd32df-b882-a1eb-b2a0-389fd6a68fac@redhat.com>
Date:   Fri, 28 Jan 2022 13:33:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/3] KVM: x86: add system attribute to retrieve full set
 of supported xsave states
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yang.zhong@intel.com
References: <20220126152210.3044876-1-pbonzini@redhat.com>
 <20220126152210.3044876-3-pbonzini@redhat.com> <YfK71pSnmtpnSJQ8@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YfK71pSnmtpnSJQ8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/22 16:35, Sean Christopherson wrote:
> On Wed, Jan 26, 2022, Paolo Bonzini wrote:
>> +static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
>> +{
>> +	if (attr->group)
>> +		return -ENXIO;
>> +
>> +	switch (attr->attr) {
>> +	case KVM_X86_XCOMP_GUEST_SUPP:
>> +		if (put_user(supported_xcr0, (u64 __user *)attr->addr))
> 
> Deja vu[*].
> 
>    arch/x86/kvm/x86.c: In function ‘kvm_x86_dev_get_attr’:
>    arch/x86/kvm/x86.c:4345:46: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>     4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>          |                                              ^
>    arch/x86/include/asm/uaccess.h:221:31: note: in definition of macro ‘do_put_user_call’
>      221 |         register __typeof__(*(ptr)) __val_pu asm("%"_ASM_AX);           \
>          |                               ^~~
>    arch/x86/kvm/x86.c:4345:21: note: in expansion of macro ‘put_user’
>     4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>          |                     ^~~~~~~~
>    arch/x86/kvm/x86.c:4345:46: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>     4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>          |                                              ^
>    arch/x86/include/asm/uaccess.h:223:21: note: in definition of macro ‘do_put_user_call’
>      223 |         __ptr_pu = (ptr);                                               \
>          |                     ^~~
>    arch/x86/kvm/x86.c:4345:21: note: in expansion of macro ‘put_user’
>     4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>          |                     ^~~~~~~~
>    arch/x86/kvm/x86.c:4345:46: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>     4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
>          |                                              ^
>    arch/x86/include/asm/uaccess.h:230:45: note: in definition of macro ‘do_put_user_call’
>      230 |                        [size] "i" (sizeof(*(ptr)))                      \
>          |                                             ^~~
>    arch/x86/kvm/x86.c:4345:21: note: in expansion of macro ‘put_user’
>     4345 |                 if (put_user(supported_xcr0, (u64 __user *)attr->addr))
> 
> Given that we're collectively 2 for 2 in mishandling {g,s}et_attr(), what about
> a prep pacth like so?  Compile tested only...
> 
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 27 Jan 2022 07:31:53 -0800
> Subject: [PATCH] KVM: x86: Add a helper to retrieve userspace address from
>   kvm_device_attr
> 
> Add a helper to handle converting the u64 userspace address embedded in
> struct kvm_device_attr into a userspace pointer, it's all too easy to
> forget the intermediate "unsigned long" cast as well as the truncation
> check.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 28 +++++++++++++++++++++-------
>   1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8033eca6f3a1..67836f7c71f5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4335,14 +4335,28 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	return r;
>   }
> 
> +static inline void __user *kvm_get_attr_addr(struct kvm_device_attr *attr)
> +{
> +	void __user *uaddr = (void __user*)(unsigned long)attr->addr;
> +
> +	if ((u64)(unsigned long)uaddr != attr->addr)
> +		return ERR_PTR(-EFAULT);
> +	return uaddr;
> +}
> +
>   static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
>   {
> +	u64 __user *uaddr = kvm_get_attr_addr(attr);
> +
>   	if (attr->group)
>   		return -ENXIO;
> 
> +	if (IS_ERR(uaddr))
> +		return PTR_ERR(uaddr);
> +
>   	switch (attr->attr) {
>   	case KVM_X86_XCOMP_GUEST_SUPP:
> -		if (put_user(supported_xcr0, (u64 __user *)attr->addr))
> +		if (put_user(supported_xcr0, uaddr))
>   			return -EFAULT;
>   		return 0;
>   	default:
> @@ -5070,11 +5084,11 @@ static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
>   static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
>   				 struct kvm_device_attr *attr)
>   {
> -	u64 __user *uaddr = (u64 __user *)(unsigned long)attr->addr;
> +	u64 __user *uaddr = kvm_get_attr_addr(attr);
>   	int r;
> 
> -	if ((u64)(unsigned long)uaddr != attr->addr)
> -		return -EFAULT;
> +	if (IS_ERR(uaddr))
> +		return PTR_ERR(uaddr);
> 
>   	switch (attr->attr) {
>   	case KVM_VCPU_TSC_OFFSET:
> @@ -5093,12 +5107,12 @@ static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
>   static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
>   				 struct kvm_device_attr *attr)
>   {
> -	u64 __user *uaddr = (u64 __user *)(unsigned long)attr->addr;
> +	u64 __user *uaddr = kvm_get_attr_addr(attr);
>   	struct kvm *kvm = vcpu->kvm;
>   	int r;
> 
> -	if ((u64)(unsigned long)uaddr != attr->addr)
> -		return -EFAULT;
> +	if (IS_ERR(uaddr))
> +		return PTR_ERR(uaddr);
> 
>   	switch (attr->attr) {
>   	case KVM_VCPU_TSC_OFFSET: {
> --
> 

Nice, I applied it.

Paolo

