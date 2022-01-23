Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B749449705D
	for <lists+kvm@lfdr.de>; Sun, 23 Jan 2022 07:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiAWGWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jan 2022 01:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiAWGWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jan 2022 01:22:39 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597C0C06173B;
        Sat, 22 Jan 2022 22:22:39 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id i8so12028139pgt.13;
        Sat, 22 Jan 2022 22:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=7nNuF1SdnxMhoyP6add+HcXWspOBLXOW0pQRUR9FJJY=;
        b=fkIVJBi55hdrmbtKJ6BFfYKgQa14CppyiD0sQhYJt5j5Y59Is/EgCYY+Q2N3NMme5U
         wU5qfJfA34wlMreVYEKjy6EvfmroXJKtaW1nZbRnbxw2AcrbeVBa8pqZQBgixmFPKRIH
         pnLbq1MacbJiajySAxRQxrFvLAkALG+3HXky1pxa4XfWBsuLUqoy1T3wiij9uX0tcD8n
         dT+qODwkyS3GIWZ6e6uRTHb088FmGUXB6Uw+Wa649a0HXxa8LtQNsNgHP5G1rXcZcHX5
         g1u3Tai+llRViE6LWiX7Va013mKGfH7JSTBtk7Ba0Ksnj4KK9ILzybKxKr5FCvb5AE0c
         4T/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=7nNuF1SdnxMhoyP6add+HcXWspOBLXOW0pQRUR9FJJY=;
        b=7xHfKplAIyGdWfhFlLbv1K7kS68zBXo0+yuWoACWMQvOPzhMp8NGAcYB9mwUQH3UG6
         Zb8jP2IKTqKBRB47Fw507e//aS93Oq9fDMfucIxnBd5XhKyS7Wmyf/TZImDKdYtYFVhU
         RiO72KyQJjAwDqFFLMaM26iNvn/oK+d/3bHEzMiAICNDZ0tznEuXU5Fy4Wo5aPTVpZQE
         EkVpqH5DbEythfVZu+ZLz4dXDApykAuFojgS4Bedr9BPt4LONd//bXyRHFp5jqjPAaZG
         4u+BSt2aJfJOvvEghIzXxAU44FGqrt5oRtvgvyLl8RvOAcr+U5bTm7HM6z3qIgAYjxk1
         zIXA==
X-Gm-Message-State: AOAM532S4eIqJ0ZU6XVI1r+ZrXqkGbQfqMhXYSX2Gd/ErRwKHydzCCfb
        TEKrlyMGalAMlsHamW0oAmWubdCtVPvCFg==
X-Google-Smtp-Source: ABdhPJxhU44ebUVZ8QYgtUWW60Oxt72uQ6OxQPmZcJynVnLGDqMCmcbQZcX+RqlfFp297EmiwpFtHg==
X-Received: by 2002:a63:2bd5:: with SMTP id r204mr8025431pgr.232.1642918958902;
        Sat, 22 Jan 2022 22:22:38 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v15sm8444918pgc.52.2022.01.22.22.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jan 2022 22:22:38 -0800 (PST)
Message-ID: <75fe2317-4159-adbe-30f8-5bbd2f5e9d11@gmail.com>
Date:   Sun, 23 Jan 2022 14:22:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v6 04/21] kvm: x86: Exclude unpermitted xfeatures at
 KVM_GET_SUPPORTED_CPUID
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, Jing Liu <jing2.liu@intel.com>
Cc:     guang.zeng@intel.com, kevin.tian@intel.com, seanjc@google.com,
        tglx@linutronix.de, wei.w.wang@intel.com, yang.zhong@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-5-pbonzini@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220107185512.25321-5-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/2022 2:54 am, Paolo Bonzini wrote:
> From: Jing Liu <jing2.liu@intel.com>
> 
> KVM_GET_SUPPORTED_CPUID should not include any dynamic xstates in
> CPUID[0xD] if they have not been requested with prctl. Otherwise
> a process which directly passes KVM_GET_SUPPORTED_CPUID to
> KVM_SET_CPUID2 would now fail even if it doesn't intend to use a
> dynamically enabled feature. Userspace must know that prctl is
> required and allocate >4K xstate buffer before setting any dynamic
> bit.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> Message-Id: <20220105123532.12586-5-yang.zhong@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   Documentation/virt/kvm/api.rst | 4 ++++
>   arch/x86/kvm/cpuid.c           | 9 ++++++---
>   2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 6b683dfea8f2..f4ea5e41a4d0 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1687,6 +1687,10 @@ userspace capabilities, and with user requirements (for example, the
>   user may wish to constrain cpuid to emulate older hardware, or for
>   feature consistency across a cluster).
>   
> +Dynamically-enabled feature bits need to be requested with
> +``arch_prctl()`` before calling this ioctl. Feature bits that have not
> +been requested are excluded from the result.
> +
>   Note that certain capabilities, such as KVM_CAP_X86_DISABLE_EXITS, may
>   expose cpuid features (e.g. MONITOR) which are not supported by kvm in
>   its default configuration. If userspace enables such capabilities, it
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f3e6fda6b858..eb52dde5deec 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -815,11 +815,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   				goto out;
>   		}
>   		break;
> -	case 0xd:
> -		entry->eax &= supported_xcr0;
> +	case 0xd: {
> +		u64 guest_perm = xstate_get_guest_group_perm();
> +
> +		entry->eax &= supported_xcr0 & guest_perm;
>   		entry->ebx = xstate_required_size(supported_xcr0, false);

If we choose to exclude unpermitted xfeatures in the entry->eax, why do
we choose to expose the size of unpermitted xfeatures in ebx and ecx?

This seems to be an inconsistency, how about:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1bd4d560cbdd..193cbf56a5fa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -888,12 +888,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array 
*array, u32 function)
  		}
  		break;
  	case 0xd: {
-		u64 guest_perm = xstate_get_guest_group_perm();
+		u64 supported_xcr0 = supported_xcr0 & xstate_get_guest_group_perm();

-		entry->eax &= supported_xcr0 & guest_perm;
+		entry->eax &= supported_xcr0;
  		entry->ebx = xstate_required_size(supported_xcr0, false);
  		entry->ecx = entry->ebx;
-		entry->edx &= (supported_xcr0 & guest_perm) >> 32;
+		entry->edx &= supported_xcr0 >> 32;
  		if (!supported_xcr0)
  			break;

It also helps to fix the CPUID_D_1_EBX and later for (i = 2; i < 64; ++i);

Is there anything I've missed ?

>   		entry->ecx = entry->ebx;
> -		entry->edx &= supported_xcr0 >> 32;
> +		entry->edx &= (supported_xcr0 & guest_perm) >> 32;
>   		if (!supported_xcr0)
>   			break;
>   
> @@ -866,6 +868,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   			entry->edx = 0;
>   		}
>   		break;
> +	}
>   	case 0x12:
>   		/* Intel SGX */
>   		if (!kvm_cpu_cap_has(X86_FEATURE_SGX)) {
