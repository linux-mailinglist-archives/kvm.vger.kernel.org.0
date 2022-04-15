Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E55502E0B
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 18:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355994AbiDOQ5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 12:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355982AbiDOQ5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 12:57:05 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FD59FC6;
        Fri, 15 Apr 2022 09:54:36 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso5343041wmz.4;
        Fri, 15 Apr 2022 09:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m2WR8HeVZxDMPBsJ2wi+S56OzUuDecjD2lzSbt+tO8w=;
        b=VpDcNv+xkhUuiD56GQAFJE4kWQUHnRxn/E0B5nRoT6txv3OM8MbEsJzh/Peu7zhHA0
         QfUmruhvzc0cgHLn9fClRghbsmuxW8Fqvr2vJYBOEZn3AfUd64WSe2pjDXocyVyXDsI+
         jYNGSeFzUOpGbTAfmZ9CRc4EVmDM0AfKViOwctjYIVl1o3fqfhHKeZrcM18RiONa1MWg
         Wg4H6ILuWaQA2o8VIm6hgmybNJmeJdP0tPXHAn7OvrB2wjp2Lc8sXq806kuDxwGXz+aa
         5kWKhJIO3IzAT96eDAJYsMTJtgn8B0k6rmBB3eo4fXYxWfFE32irfxMqmFxFMIgEAN1H
         8U3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m2WR8HeVZxDMPBsJ2wi+S56OzUuDecjD2lzSbt+tO8w=;
        b=rgUEZ+R35Nwl7j0R2NUHCQF7nsyXU73MWZOj0p5jrFMf+m9H6d3132i/oyxQR7BKsM
         itCxqWRyDJKQD4pl1MTOwXmd9KTtASsNtxH4MYj2enB9/w+KbYYjSG8so3IFmgleokXX
         YXwkxg7HgXsoCGVfLdfizrDH7kEaS7lWuJYiqKWHH4GXR1FTcE5YFaWA6iMzC/yfG+rX
         IEpIMQN06P0+S2bWX9vjwlvWUTlrCIQCyMR0acnWN7ar/sVSW0XKZmHwGMHpydtd9rTl
         goysFatgtH7q/4ZHBfW0fx6ntI4cN3KErIlAhmdOR7vc70TGjXQVrIo3APON6jrNduPl
         QqjQ==
X-Gm-Message-State: AOAM530RYDUY3Y8XpaYfRrIpjH/ikoChogQQVH95Uw7N0tX70EFRGJOn
        kPgmOy9s9yD6b/AAdgdFXqA=
X-Google-Smtp-Source: ABdhPJwOhR+ihYnd0JcIhDD0h1nkAp7TumgzKKg+StEsNj+Xbp7B+PvUsidGOx/u4dEqslH2IO/+5A==
X-Received: by 2002:a05:600c:511b:b0:392:36fd:6728 with SMTP id o27-20020a05600c511b00b0039236fd6728mr1323882wms.93.1650041674598;
        Fri, 15 Apr 2022 09:54:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id f7-20020a1c3807000000b0038ffac6f752sm4681294wma.45.2022.04.15.09.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 09:54:34 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <26d74179-55fb-b70b-8a29-67e26a032abe@redhat.com>
Date:   Fri, 15 Apr 2022 18:54:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
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
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

When rebasing against tip/x86/tdx,  the new .c file needs to include 
asm/tdx.h.

Paolo

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

