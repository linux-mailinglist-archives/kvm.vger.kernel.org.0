Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57E9189A92
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 12:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgCRL0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 07:26:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:48852 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727722AbgCRL0o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 07:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584530802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5igz5ifXUjPW3HOZrUuMXCx1D9YbVzwpu9tICwFVMz4=;
        b=Z4U2q1yqXf1zch0EcDOVh3U1K+OMXJHFv7NTspfYcSFz8HI5JHMsF9zCPoaXvjPp423ArG
        cyPa+MdL0f1+HAhdeqiqzn2HPCVyjwO7X3UJrxueIPJndBeTANhEk6IcyJu9c21YfHQCLU
        AtQCkWk/Pq4RS+K+ckR+lzP+kx/Swhc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-9MClN17aPiCqeFWywkGOlA-1; Wed, 18 Mar 2020 07:26:40 -0400
X-MC-Unique: 9MClN17aPiCqeFWywkGOlA-1
Received: by mail-wr1-f72.google.com with SMTP id t10so5872271wrp.15
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 04:26:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5igz5ifXUjPW3HOZrUuMXCx1D9YbVzwpu9tICwFVMz4=;
        b=RPOJRd1jgh7xShw1BbSOndnaPGm1vcCZ+MBsSqnP/iJBkctUQ22OiGqqn6RFCxIwaD
         H3VgQpAck+S1j07MPYAt6JtTM+bWZcZ12Vevc6yQFX7uBOJCoigLzo8ib3yJ3XvwGL1u
         GbemFBX3VwgZ1Z6EZ7KwbOAzrTwCbEK4Y1y5/CZDy6xxhnJ8j4KrbOg9qEf6e6IQbVAZ
         twD0eRKf+Wo/4M63ANS/uWH58WkvvL4gVlxDCY9jnDFtjT/WJosb1lWo2TGJYOiSCiph
         cgPR7QwP2Zih8KqFLEnnsmoLhhmmg8BTECjDMzJiV6wyVBc8Fi5xVyLwrzmqXfhx9eOP
         BgSQ==
X-Gm-Message-State: ANhLgQ1ksojKpAxZVf0bc4BX0+N5EFtQHaCUroPLvcNljFwjvPY5of/o
        cHpouYnpPBggLOGMKVvtuXwsV0U9VXh/w6jlYE7eR2KvWLJgb8AuxeLt8gBmBw086Oet7KABUWs
        EDBJP5lWMCfNa
X-Received: by 2002:adf:f807:: with SMTP id s7mr5040091wrp.49.1584530799361;
        Wed, 18 Mar 2020 04:26:39 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsNZ3RbBs/kRWmkrVpq+7LDajnIvwaWGyakEzMuR33iRe/bnqCAX/H4bBeFbfpC3O8OTc31ZQ==
X-Received: by 2002:adf:f807:: with SMTP id s7mr5040067wrp.49.1584530799133;
        Wed, 18 Mar 2020 04:26:39 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id z12sm1721100wrt.27.2020.03.18.04.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 04:26:38 -0700 (PDT)
Subject: Re: [PATCH rebase] KVM: x86: Expose AVX512 VP2INTERSECT in cpuid for
 TGL
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhong, Yang" <yang.zhong@intel.com>
References: <dcc9899c-f5af-9a4f-3ac2-f37fd8b930f7@redhat.com>
 <20200318032739.3745-1-zhenyuw@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <65e997c3-9ef9-d9f3-143e-0bc0823aad4f@redhat.com>
Date:   Wed, 18 Mar 2020 12:26:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200318032739.3745-1-zhenyuw@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/20 04:27, Zhenyu Wang wrote:
> On Tigerlake new AVX512 VP2INTERSECT feature is available.
> This trys to expose it for KVM supported cpuid.
> 
> Cc: "Zhong, Yang" <yang.zhong@intel.com>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 08280d8a2ac9..435a7da07d5f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -338,7 +338,7 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_mask(CPUID_7_EDX,
>  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> -		F(MD_CLEAR)
> +		F(MD_CLEAR) | F(AVX512_VP2INTERSECT)
>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> 

Queued, thanks.

Paolo

