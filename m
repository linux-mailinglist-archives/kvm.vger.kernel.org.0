Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909184D75C1
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 15:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiCMONm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiCMONl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:13:41 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149531BEAF;
        Sun, 13 Mar 2022 07:12:34 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 19so7850618wmy.3;
        Sun, 13 Mar 2022 07:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mb7PDca+3I5O8BOlO0II3uFS6ORKg+kbdWf9TIxP6CY=;
        b=ETKsPGKKAJ3tRSNQKgguN8zvUj+K0x8GhMG7KFv+nNSK94YaOumma0fRosLB08nNCo
         EyXD+4ysbaHq5Vna64YndfQXQYDcB+r6at4PjPf6VrnEJzNplaa1cKBQxqrCN3x3y0gi
         J+6h3+SQlAaHasRYzdkoEZX1vByp4uLZhw7MLY/Jlr19Jp5LASp7T3kQux5Z5Rq50L51
         ChiUyisQMtNy3rAhdS+pgrQp4O7KJnv4KOsbvCV+QodA9FvBfR7T08vVIdzU98hLLFYL
         njn92R1yaf0rChegNntpNj2Yy82HTLYbjZDnqqQXJwtYMrvnujH16vg7acGs/9Akueve
         s7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mb7PDca+3I5O8BOlO0II3uFS6ORKg+kbdWf9TIxP6CY=;
        b=4bRL058itaOYVStCIgEMrCFgaO0WCh/3+Sn7Zb8t7HtXRGPA+V8y1i7ED8gPNlQMQe
         oGyQzlFpNZ82CqSaoCA+Zle9Nv2G0IeSc1icj1TS9DHJwY31eIw/8C9woWXN9qFPgqBT
         7XVwZrBDYFr34lQvdVeLN06Tk5ECmwhPeOFKFetSPmNn7He4cnoNBkKECkvC8bVe1fP8
         jghJ5sp9Y/7O/fAwB4ke8mPhMx1WuNlsTsJ3hN9gP8nloqNnC4MFC+tfefi7GXGI2z+L
         +t+V3EdlPJFBN88WjpVo+DtIwM9ckTfENxXXiT08zXrjWo5NheRZKspWKrxghPKzRgmp
         w0iQ==
X-Gm-Message-State: AOAM532vMWeG6G/obZ0DZEbRYFJSGJ23rqyx0RZ33A8DmS8UJD8yQF8U
        CKSWg/OgJ89WfJ2NVYKeF6QvbIHYJGw=
X-Google-Smtp-Source: ABdhPJwgl4zCSyLoWbiJH3eBM899dcFaDThhGF3Y9cQbVSI0HYB8bywhF0pxGJ6ApV1ouL2Jj/gaTg==
X-Received: by 2002:a05:600c:190e:b0:389:d75e:2a66 with SMTP id j14-20020a05600c190e00b00389d75e2a66mr14286752wmq.124.1647180752658;
        Sun, 13 Mar 2022 07:12:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id n8-20020adf8b08000000b001f046cc8891sm11364972wra.24.2022.03.13.07.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 07:12:32 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <be3b3abe-688d-42b3-ed5e-3927538a30cc@redhat.com>
Date:   Sun, 13 Mar 2022 15:12:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 017/104] KVM: TDX: Add helper functions to print
 TDX SEAMCALL error
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <7d89296e776b125b75762c040879c16afa7b6da6.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <7d89296e776b125b75762c040879c16afa7b6da6.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add helper functions to print out errors from the TDX module in a uniform
> manner.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/Makefile        |  2 +-
>   arch/x86/kvm/vmx/seamcall.h  |  2 ++
>   arch/x86/kvm/vmx/tdx_error.c | 22 ++++++++++++++++++++++
>   3 files changed, 25 insertions(+), 1 deletion(-)
>   create mode 100644 arch/x86/kvm/vmx/tdx_error.c
> 
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index e8f83a7d0dc3..3d6550c73fb5 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -24,7 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
>   kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>   			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
>   kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> -kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o vmx/seamcall.o
> +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o vmx/seamcall.o vmx/tdx_error.o
>   
>   kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
>   
> diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
> index 604792e9a59f..5ac419cd8e27 100644
> --- a/arch/x86/kvm/vmx/seamcall.h
> +++ b/arch/x86/kvm/vmx/seamcall.h
> @@ -16,6 +16,8 @@ struct tdx_module_output;
>   u64 kvm_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
>   		struct tdx_module_output *out);
>   
> +void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out);
> +
>   #endif /* !__ASSEMBLY__ */
>   
>   #endif	/* CONFIG_INTEL_TDX_HOST */
> diff --git a/arch/x86/kvm/vmx/tdx_error.c b/arch/x86/kvm/vmx/tdx_error.c
> new file mode 100644
> index 000000000000..61ed855d1188
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_error.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* functions to record TDX SEAMCALL error */
> +
> +#include <linux/kernel.h>
> +#include <linux/bug.h>
> +
> +#include "tdx_ops.h"
> +
> +void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_output *out)
> +{
> +	if (!out) {
> +		pr_err_ratelimited("SEAMCALL[%lld] failed: 0x%llx\n",
> +				op, error_code);
> +		return;
> +	}
> +
> +	pr_err_ratelimited(
> +		"SEAMCALL[%lld] failed: 0x%llx "
> +		"RCX 0x%llx, RDX 0x%llx, R8 0x%llx, R9 0x%llx, R10 0x%llx, R11 0x%llx\n",
> +		op, error_code,
> +		out->rcx, out->rdx, out->r8, out->r9, out->r10, out->r11);
> +}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
