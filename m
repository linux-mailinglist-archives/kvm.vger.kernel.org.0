Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A7C363037
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhDQNSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 09:18:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236257AbhDQNSV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 09:18:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618665474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ciCV1LTqKSA6yKmOaXOhxINSuLAEFyVRLAAxoRtJwoM=;
        b=bibn1EDg5yfn0GR7vcZex74z5PLCaau0SmkWSLBRegbpPeXzy2YtWXo0oLI0izS0WvSuPY
        c00AkBcoMpKvMzT+P32Lgj+Gt8GpXNMWg8+u/rUEsltEESnsApu9j2cKKhXmtOPakeE3Uh
        tsZL2yAtzHJs1VlGEYglMHnMeg6Vxa0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-33d7BdAbNVKRnJGBwmFynA-1; Sat, 17 Apr 2021 09:17:50 -0400
X-MC-Unique: 33d7BdAbNVKRnJGBwmFynA-1
Received: by mail-ej1-f71.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso2580674ejn.10
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 06:17:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ciCV1LTqKSA6yKmOaXOhxINSuLAEFyVRLAAxoRtJwoM=;
        b=mP1hLWNGF518scIpcokF5SxO3s8vV5plcRlnRWT7+Rd7+Hm9ET4kw7aqU3Le3z3HFG
         DI26ggz/hTAXWH73V/jV8YjlugpG3n0BLwxXrdWiBCxPXQ0dJSVdTlUMVft9XbX9INEZ
         AwqCPAN7AYg+7vcgqCGCIhX9PzjZ9otnXsqJc/pgYUxMLuHW0MWXLjm5D2ZZt4Lo52QF
         TSVpdyx/md3Ax0RPd6dO/plrQ5hNdpea64ljUZD81iwdibIyOphjKUHb8zQ9B39meCgx
         NMixOUQ0gvFbylVC7c3zszElBhuptSK438NPeoKP5QI8VMacD5v/At03LYG7Yn/KINhJ
         FOaQ==
X-Gm-Message-State: AOAM530aCxPCQOvKxr+t82WCd8xHi8pwWafjt5iF/NEgbiPc3h5q4sFG
        w8uHsAHiSvSWc0OxMLdW0xKPUEYoCnO0GYsk79d01LrGQocJttAWEjVWmYDTtf5RUHWWfxVoCLh
        ko5LMLTnoMZdQ
X-Received: by 2002:a50:9feb:: with SMTP id c98mr7521044edf.104.1618665469402;
        Sat, 17 Apr 2021 06:17:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypcobCsRzpU30ZOTnDw84A6BtQgyuc+LOn+rxCJXVvab3FP2M7bWGGF0+hx9a2WLJH3chjIA==
X-Received: by 2002:a50:9feb:: with SMTP id c98mr7521019edf.104.1618665469222;
        Sat, 17 Apr 2021 06:17:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s9sm7789724edd.16.2021.04.17.06.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:17:48 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: vmx: add mismatched size assertions in
 vmcs_check32()
To:     lihaiwei.kernel@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
References: <20210409022456.23528-1-lihaiwei.kernel@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f3532509-c484-c980-cbef-847053050384@redhat.com>
Date:   Sat, 17 Apr 2021 15:17:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210409022456.23528-1-lihaiwei.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/21 04:24, lihaiwei.kernel@gmail.com wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> Add compile-time assertions in vmcs_check32() to disallow accesses to
> 64-bit and 64-bit high fields via vmcs_{read,write}32().  Upper level KVM
> code should never do partial accesses to VMCS fields.  KVM handles the
> split accesses automatically in vmcs_{read,write}64() when running as a
> 32-bit kernel.
> 
> Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
> v1 -> v2:
> * Improve the changelog
> 
>   arch/x86/kvm/vmx/vmx_ops.h | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
> index 692b0c3..164b64f 100644
> --- a/arch/x86/kvm/vmx/vmx_ops.h
> +++ b/arch/x86/kvm/vmx/vmx_ops.h
> @@ -37,6 +37,10 @@ static __always_inline void vmcs_check32(unsigned long field)
>   {
>   	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0,
>   			 "32-bit accessor invalid for 16-bit field");
> +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2000,
> +			 "32-bit accessor invalid for 64-bit field");
> +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2001,
> +			 "32-bit accessor invalid for 64-bit high field");
>   	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x6000,
>   			 "32-bit accessor invalid for natural width field");
>   }
> 

Queued, thanks.

paolo

