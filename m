Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AE147A69B
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 10:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhLTJIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 04:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhLTJIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 04:08:53 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB25C061574;
        Mon, 20 Dec 2021 01:08:52 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z29so35368645edl.7;
        Mon, 20 Dec 2021 01:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DAOnSPNG61KLraNeWXy52dn5ZnQsbbkci+rS6v0dT5o=;
        b=gIvCMQ7GVwjo2DIeT1bwOuNPCVP9xrfP3Gm32H2sjTaX7hzNmLe+rb+XWXTuhSbErt
         R8qXlpvxLteMOvKhl9hQKiEI7K91+mT4KXI+EPkptvpeied6zy8XmJJwgajrbV2+T6KD
         c14FD0Fp94mOXPsXCpB/KkaSOmEJbNqEG7DfmYjIZHGlSic3EaJirBgD2X+dG7PTtleg
         3SsjrtJI/7UOizitBvH7HYs8+DAYq2ZUAbWr8Y+dacwGGjbxVS+/dM09G1AA3uzuayHM
         3QLoBy6y9in09dYa47fqcQ3OzEHnDLFRNItyEv5s7OmqZ6A/d74ADM5jq+I7EjTOjgaU
         FMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DAOnSPNG61KLraNeWXy52dn5ZnQsbbkci+rS6v0dT5o=;
        b=0Dl+wA2Dam+SQFhP1c/AH/BaOzMTgMtawaEIsr1gJ/xuAptS/o5ZGzDSLBZ7kAojVx
         Rk3nFO6RrqJf1scacF2VVdWV2V/7sYK4Mq/6XjQoiU7LV5P2pYTXU1bSCFLmMIHl+XI6
         /oh/Yjq5J+FLlSgcxtQOfL83aSsw9U+pjZsp+ViQUFHv9j+IQ0ptfNB9Rhe68wRwC6rr
         5qU0IW9WOCFwfQHjP8geGmGSpKkl2ZC3/Sdc9HMwksorFte15TQfsGCyGybT+ysC0ujQ
         8RnPtdEsucZGGYYEaJTjuSD/R+KQPy7c4GZExTFRWrk83jMVJSeNhXBbCK9C8xvmC0Ga
         KW9w==
X-Gm-Message-State: AOAM532cdjwwglHIru26RSdS7jXGfnuaPKT7LulSNguLJ5cFsHTV+9Gr
        yUkFrvVRiVIvt5BlwE6ky0s=
X-Google-Smtp-Source: ABdhPJzYaXf3W9TNkHj6qWFzacwqQWYrHo08heW9d0zOnn1vh3bsGBk4RSjiVJb9oZ+B9TJYXp5rtA==
X-Received: by 2002:a17:906:3a8c:: with SMTP id y12mr11682490ejd.517.1639991331217;
        Mon, 20 Dec 2021 01:08:51 -0800 (PST)
Received: from [192.168.10.118] ([93.56.160.36])
        by smtp.googlemail.com with ESMTPSA id g19sm5515499edr.6.2021.12.20.01.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 01:08:50 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e6fd3fc5-ea06-30a5-29ce-1ffd6b815b47@redhat.com>
Date:   Mon, 20 Dec 2021 10:08:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 23/23] kvm: x86: Disable RDMSR interception of
 IA32_XFD_ERR
Content-Language: en-US
To:     Jing Liu <jing2.liu@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, guang.zeng@intel.com,
        wei.w.wang@intel.com, yang.zhong@intel.com
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-24-jing2.liu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211217153003.1719189-24-jing2.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 16:30, Jing Liu wrote:
> Also disable read emulation of IA32_XFD_ERR MSR at the same point
> where r/w emulation of IA32_XFD MSR is disabled. This saves one
> unnecessary VM-exit in guest #NM handler, given that the MSR is
> already restored with the guest value before the guest is resumed.
> 
> Signed-off-by: Jing Liu <jing2.liu@intel.com>

Why not do this unconditionally (i.e. in patch 13, with the call to 
vmx_disable_intercept_for_msr in function vmx_create_vcpu)?

Thanks,

Paolo

> ---
>   arch/x86/kvm/vmx/vmx.c | 2 ++
>   arch/x86/kvm/vmx/vmx.h | 2 +-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 97a823a3f23f..b66a005f076b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -163,6 +163,7 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
>   	MSR_GS_BASE,
>   	MSR_KERNEL_GS_BASE,
>   	MSR_IA32_XFD,
> +	MSR_IA32_XFD_ERR,
>   #endif
>   	MSR_IA32_SYSENTER_CS,
>   	MSR_IA32_SYSENTER_ESP,
> @@ -1934,6 +1935,7 @@ static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
>   static void vmx_set_xfd_passthrough(struct kvm_vcpu *vcpu)
>   {
>   	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R);
>   	vcpu->arch.xfd_out_of_sync = true;
>   }
>   #endif
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index bf9d3051cd6c..0a00242a91e7 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -340,7 +340,7 @@ struct vcpu_vmx {
>   	struct lbr_desc lbr_desc;
>   
>   	/* Save desired MSR intercept (read: pass-through) state */
> -#define MAX_POSSIBLE_PASSTHROUGH_MSRS	14
> +#define MAX_POSSIBLE_PASSTHROUGH_MSRS	15
>   	struct {
>   		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
>   		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
> 

