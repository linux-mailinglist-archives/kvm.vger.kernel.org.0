Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DD7490FA6
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239269AbiAQRcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:32:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238040AbiAQRcD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:32:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642440723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=facGYaN7TmsTdJN/2dDbCbC61s3Aifzqr9lBPbfPM3U=;
        b=UYZY5iLKPDgxbgQfVyFh5WVN/emvJzHXEcDEDJ6yKWFM0TzaJUtNbhx35LZQXJ3G9HqL3o
        HwyK/LtN0c84GsEDzO+03S36tDOg8ZWwgMyByidM4QI0Nz1JeFi+rItfDVLBJDjpBxrOOa
        Ng23njlLXAj2S8CsG16jehl98Udf3OU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-Sb-2LeVAMsClRDjeq851gw-1; Mon, 17 Jan 2022 12:32:01 -0500
X-MC-Unique: Sb-2LeVAMsClRDjeq851gw-1
Received: by mail-wm1-f71.google.com with SMTP id p7-20020a05600c1d8700b0034a0c77dad6so282051wms.7
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 09:32:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=facGYaN7TmsTdJN/2dDbCbC61s3Aifzqr9lBPbfPM3U=;
        b=JsA+tAwMNrstTV+tG3/+btKQvvMv3ej94CmNQgJpogy4lGi5VKR4wKT9gZvQb5zeUP
         foNTNc8tenJB8Pu0mdAeJWtmohT4RD6W6PQaP9KwUHDYOjAhgF/BOLvuhSKq5T3EXqg3
         /Hara17fw9eQZ1ncC23eZxRNzHhJTViyLumVTX+TGB3XzuL/UBfw9POMOFXN44HgPNZ+
         ng93B8+DdVVf94Kk3jNn5W47Tq3Ebw8F6HWoZiS4tvbxzx2+/87HjWCbH+27MCVtUCJm
         7tTxLyNb9OpsDYkrDEPf3jkEE6+hjl7Gwno2N81eRQG3tAPkkB6qEKc/MLVbBfAk3Akl
         IMzw==
X-Gm-Message-State: AOAM53336j5fpjT6mA/+sTDWHVjrOhY02FEU3oXK0s3g/ZDQGe4uNIws
        E55DO2fuu/yQr7K1PbzS56/J6x35TAQQtAWoGuPpn2FTRLep2hNkxdFwTjuLmq1VOw86blsxtLU
        Ukigvt25dBCTX
X-Received: by 2002:adf:fdce:: with SMTP id i14mr85548wrs.576.1642440720627;
        Mon, 17 Jan 2022 09:32:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0Q5fs7xydS2XJIbfrnGOlACwSA2+DribL1EuLT7jO9E41JhIHZo1NMUFoTPYHWcS8gVfxCg==
X-Received: by 2002:adf:fdce:: with SMTP id i14mr85533wrs.576.1642440720414;
        Mon, 17 Jan 2022 09:32:00 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id w7sm13761219wrv.96.2022.01.17.09.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 09:31:59 -0800 (PST)
Message-ID: <301d4800-5eab-6e21-e8c1-2f87789fc4b9@redhat.com>
Date:   Mon, 17 Jan 2022 18:31:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86/cpuid: Clear XFD for component i if the base
 feature is missing
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Jing Liu <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117074531.76925-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220117074531.76925-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 08:45, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> According to Intel extended feature disable (XFD) spec, the sub-function i
> (i > 1) of CPUID function 0DH enumerates "details for state component i.
> ECX[2] enumerates support for XFD support for this state component."
> 
> If KVM does not report F(XFD) feature (e.g. due to CONFIG_X86_64),
> then the corresponding XFD support for any state component i
> should also be removed. Translate this dependency into KVM terms.
> 
> Fixes: 690a757d610e ("kvm: x86: Add CPUID support for Intel AMX")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/kvm/cpuid.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c55e57b30e81..e96efef4f048 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -886,6 +886,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   				--array->nent;
>   				continue;
>   			}
> +
> +			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
> +				entry->ecx &= ~BIT_ULL(2);
>   			entry->edx = 0;
>   		}
>   		break;

Generally this is something that is left to userspace.  Apart from the 
usecase of "call KVM_GET_SUPPORTED_CPUID and pass it to KVM_SET_CPUID2", 
userspace should know what any changed bits mean.

Paolo

