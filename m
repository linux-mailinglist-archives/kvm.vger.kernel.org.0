Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11CC618F51F
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 13:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgCWM7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 08:59:02 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:21744 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727582AbgCWM7B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 08:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584968340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4HTzcRz3o3qfXex5hqeXQ2T6ofF+yWf+Qi36UvhbgGw=;
        b=WWqhrv4KQVT+H9DSogKuqUZa4Tb/8gDeUTUgXGdCUOUXiCo0a8aQljT5zvklTZVM5kBi2G
        7kMdg9+jeelyHh8O2OvVkDEmvRJ3yYfALjzG/kYSOAnsklf2lFPnCCWVtwTm3n79XR1Urm
        UTlGeexGW+KFP6t+w8Gsdzu+SSH6ggY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-PmQFysFEOsGzbTAWyeX7XA-1; Mon, 23 Mar 2020 08:58:59 -0400
X-MC-Unique: PmQFysFEOsGzbTAWyeX7XA-1
Received: by mail-wr1-f71.google.com with SMTP id p2so7329517wrw.8
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 05:58:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4HTzcRz3o3qfXex5hqeXQ2T6ofF+yWf+Qi36UvhbgGw=;
        b=cYgK01wHy0incSCQ85knfFac4C6KcwKMDTVjB3ujazZAHOyYPyqAwugIGYSnIeVIxQ
         rx7fUrTNX9Dh4KCJ89B/a8qTQx3Uob5LJct8q0/RTDD/PZArbbR7HcW0kHbkmHlzTNrB
         yWa/mm/FV5YVAKA2r3DdBp8HqwchZgJ5NbbS5jMdFheqh7E68S2ZA3h8DAC6YHlstBbf
         unGHD8QpgekR9jp8+vTKkezcHAvcM7FnUlDA58RZ+5NKX0tzYwlmeZ2y7CNkHEQ3WZJY
         WpERMNBA52Ea1ew9sNf4nxtxZ6nADZk3wtEksrxoN/c6Y1HMCKZxwMe45kCpIvdbtOur
         lzZw==
X-Gm-Message-State: ANhLgQ2WcnAbBhswrGcuyev22D8cecyDBp+z/9LLIcSBDuPGmG9b47aV
        jzHIBu19SyALtmzO4n0llZgw5bmpZa2LOgyvPQuTUmseh1SI89z2va+BJN51bcYPHRnLpNdwhZ4
        jA9NuXIfq/Tfx
X-Received: by 2002:adf:aacc:: with SMTP id i12mr31396968wrc.116.1584968338289;
        Mon, 23 Mar 2020 05:58:58 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu6lNHTTDFNS1+6/voSjetJ50D0n//DWfUviVLJPhmz+dU6+d94lOeUVvb31wDc7vbhL+vjfQ==
X-Received: by 2002:adf:aacc:: with SMTP id i12mr31396943wrc.116.1584968337983;
        Mon, 23 Mar 2020 05:58:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24d8:ed40:c82a:8a01? ([2001:b07:6468:f312:24d8:ed40:c82a:8a01])
        by smtp.gmail.com with ESMTPSA id g14sm22381288wme.32.2020.03.23.05.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 05:58:57 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Expose fast short REP MOV for supported cpuid
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200323092236.3703-1-zhenyuw@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5bf4035d-4c37-be3f-cfe2-759ccc0bc17d@redhat.com>
Date:   Mon, 23 Mar 2020 13:58:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200323092236.3703-1-zhenyuw@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/20 10:22, Zhenyu Wang wrote:
> For CPU supporting fast short REP MOV (XF86_FEATURE_FSRM) e.g Icelake,
> Tigerlake, expose it in KVM supported cpuid as well.
> 
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 435a7da07d5f..cf6da12bd17a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -338,7 +338,7 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_mask(CPUID_7_EDX,
>  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> -		F(MD_CLEAR) | F(AVX512_VP2INTERSECT)
> +		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> 

Queued, thanks.

Paolo

