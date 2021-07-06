Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAC33BD6A9
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhGFMlz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:41:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345726AbhGFMgV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:36:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625574821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dVlH/6kj9+mnyRDPxoOEz2Sc597z9B9MJB0mv+AaqxY=;
        b=AXIkrgVgOdTQEoqLDvO/8vdaZk/qkvHGxa5thJZqP7QsOLTaGZuRCj4NhXXdZUfjm9TpRq
        3wpBf3kHEMvSNhdgBiSIao/afsITQdV0GpXx5zcbfsIOjI/Xx56E4fSw0znzrh0YZ0Jt6R
        nZk7obhQlVnsrvZFnke07fMSiW9vbF0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-sc8Z2v68PxuYa1emqqLKQw-1; Tue, 06 Jul 2021 08:33:41 -0400
X-MC-Unique: sc8Z2v68PxuYa1emqqLKQw-1
Received: by mail-ej1-f71.google.com with SMTP id lb20-20020a1709077854b02904c5f93c0124so5727327ejc.14
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 05:33:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dVlH/6kj9+mnyRDPxoOEz2Sc597z9B9MJB0mv+AaqxY=;
        b=DZJlyVZe/fRy+ildsaMc/U3FtEZzfg7xCwEJfUcGjLUqQmohDF+FOqHdaOBrCJNWI6
         EOvwo4GXuf5asmsUW60A/+7eB8Tfc6Bx2CzbXRaXfOI2DicNftNsZbwPSfeJGK6uHKbE
         bVdSNlZ5yLGHgysVCXWCu6zk+LrfoQE1DNG2g7MGET2Aqy9UagqrGjG9JBuVKwjQe/Au
         uXXpdSSxoFW9F4/k00wO5+iuwcbjer75zVxHJSxjdbudRKxGAjZy9kUhiWnwChwFX5Qs
         97iAnREkgQ03gMtmx2zcywUv0qOAEDxkmBezwNKjR5uf5SzvrAd5zY1bxpDyUNLZNJvJ
         p2xw==
X-Gm-Message-State: AOAM533VMolYBbTnW5wUYLL5s1A8tCbDDZuctH2pLJ3daOcWZgSp1tz3
        oriVN3/1E40s2OVNO5bYbazk68HPFqmD/3Fgs/sBjP6cvkyUNXDeWxsAyFW6eFOrPJqpSOZ6WLJ
        VXH5MuI2K3dL7
X-Received: by 2002:a17:907:1dc9:: with SMTP id og9mr12829877ejc.152.1625574817770;
        Tue, 06 Jul 2021 05:33:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1jC3LOqlbUFJVvvl3ZZxtzmEkvsUYpeUri3OeGjcSrYQXCvfrJPaspHJQfuTfCdWG9cik5g==
X-Received: by 2002:a17:907:1dc9:: with SMTP id og9mr12829844ejc.152.1625574817565;
        Tue, 06 Jul 2021 05:33:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l16sm5338164ejb.26.2021.07.06.05.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 05:33:36 -0700 (PDT)
Subject: Re: [RFC PATCH v2 01/69] KVM: TDX: introduce config for KVM TDX
 support
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <2f265006e5cee03a5a48448c51c3632391e58ec7.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb3920be-1e53-6b5a-1b68-1fcb5d9d627c@redhat.com>
Date:   Tue, 6 Jul 2021 14:33:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2f265006e5cee03a5a48448c51c3632391e58ec7.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add new config KVM_INTEL_TDX for KVM TDX support.  This patch introduce
> a config only.  Later patch will implement feature depends on it.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/Kconfig | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index f6b93a35ce14..66622901bf7d 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -96,6 +96,17 @@ config X86_SGX_KVM
>   
>   	  If unsure, say N.
>   
> +config KVM_INTEL_TDX
> +	bool "Trusted Domain eXtensions(TDX) Host support"
> +	depends on KVM_INTEL && X86_64
> +	select FW_LOADER
> +
> +	help
> +	  Extends KVM on Intel processors to support Trusted Domain Extensions.
> +	  Intel Trust Domain eXtensions(TDX) is an architecture based on CPU
> +	  instructions and TDX module to deploy hardware-isolated virtual
> +	  machines(VMs) which is called Trust Domains(TDs).
> +
>   config KVM_AMD
>   	tristate "KVM for AMD processors support"
>   	depends on KVM
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

