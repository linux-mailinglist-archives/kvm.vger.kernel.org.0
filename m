Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6E44903E3
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbiAQIbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:31:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232331AbiAQIbv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 03:31:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642408310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kZiUn9HGYMpstUGdIlC1VGh2Ev+eOpvhg6ZsJcnRfGw=;
        b=gQuB8vjoyvZzHC7/g+IBo963ZA+SImYL4jqqIcqC0p+14tjDM9dFM054z4tauBfaPqFa76
        9ccHMPZbe0EL13YE9onR11AWPXb7NeBpwkTk/IbbFzqUc6a6Rsr1lv+tnMJ0NsQfqVMxlg
        BMGlPU5UhjeifQIQxktCcsbX6yTTtbQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-4HWdnRl4M6aX0WQR-eUMsg-1; Mon, 17 Jan 2022 03:31:49 -0500
X-MC-Unique: 4HWdnRl4M6aX0WQR-eUMsg-1
Received: by mail-wm1-f71.google.com with SMTP id n25-20020a05600c3b9900b00348b83fbd0dso10514401wms.0
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 00:31:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kZiUn9HGYMpstUGdIlC1VGh2Ev+eOpvhg6ZsJcnRfGw=;
        b=uPv2sXyAWjjfdGd/YoN5Z7ABdceEA1oUdSV9lBWyL0pvtsv1wbuHLtSezvXUrqmyxe
         SjbP2UVEdi9nhCxz/ufYvOfp8lhaQHKHoSbNAzraJxUf5X2cqQgsVAme3nu31WlRdkrK
         7fiKJOPSRMw8z4IbbeIhwqqymxSVMG5hMCQJHjElj8Btd1/uWaRvU7KAhgFZ5zwv0ksh
         OsPObOXKI3TYurcVNT+tLZZapEEUsSmb6GVed5OC7dkcUpkWK23De0O63avb372kkuOV
         CLRc42zGMbmCW4aSOiDYiUOvA9F9AGWHca3OVXsR2L18W1K24n1N1UiIu+U3A0sWyxOF
         5w2Q==
X-Gm-Message-State: AOAM532GY1cmnrmXar1BgxNW03u9i5OLkIYKz9foZA2cC/r/w49BzkPq
        n0jMMTklotIuoVa6tDzGAhVwp7xoL8o/KMzpA5KxHuc6pUyj93mZ3c5qOplWmvTtYmR3FF0kTUb
        n2cMlXugGGcH4
X-Received: by 2002:a05:6000:1543:: with SMTP id 3mr14327433wry.683.1642408308019;
        Mon, 17 Jan 2022 00:31:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxr9+owYNFGFXo0eIoRWnDYuAoyIH41ad1EUV1B4t5z/hV+sGBIXjK2Tjm/DHQARATtQoXOhQ==
X-Received: by 2002:a05:6000:1543:: with SMTP id 3mr14327410wry.683.1642408307777;
        Mon, 17 Jan 2022 00:31:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id 9sm10836521wrb.77.2022.01.17.00.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 00:31:46 -0800 (PST)
Message-ID: <a133d6e2-34de-8a41-475e-3858fc2902bf@redhat.com>
Date:   Mon, 17 Jan 2022 09:31:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86: Fix the #GP(0) and #UD conditions for XSETBV
 emulation
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117072456.71155-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220117072456.71155-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 08:24, Like Xu wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 76b4803dd3bd..7d8622e592bb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1024,7 +1024,11 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>   
>   int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
>   {
> -	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) ||
> +	    !kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE))
> +		return kvm_handle_invalid_op(vcpu);

There's no need to check XSAVE, because it XSAVE=0 will prevent setting 
CR4.OSXSAVE.

Likewise, CPL and SS.DPL are also defined in real mode so there's no 
need to check is_protmode.  The Intel manuals sometimes still act as the 
descriptor caches don't exist, even though VMX effectively made them 
part of the architecture.

Also, the "Fixes" tag is not really correct as the behavior was the same 
before.  Rather, it fixes commit 02d4160fbd76 ("x86: KVM: add xsetbv to 
the emulator", 2019-08-22).  Checking OSXSAVE is a bug in the emulator 
path, even though it's not needed in the XSETBV vmexit case.

Thanks,

Paolo

> +	if ((is_protmode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) != 0) ||
>   	    __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
>   		kvm_inject_gp(vcpu, 0);
>   		return 1;

