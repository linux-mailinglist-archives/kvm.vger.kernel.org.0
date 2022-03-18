Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DE14DDF68
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 17:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbiCRQ4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 12:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbiCRQ4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 12:56:50 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F185A2976C7
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 09:55:31 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mz9-20020a17090b378900b001c657559290so8517972pjb.2
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 09:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=85DsX9iAoK+Khgdz60GqS5EZIHIVR2Lk1qUZhsxGck4=;
        b=EWThS7pMmJmQgmqSCZt9bVbV1I6+i3QqeGMPIPhBVDE4X14ssW35/E8zX3u4nfZRgk
         xPckckr0H3JQgbMcIl8KfzND7vsO5ycvzyzOBgdpQC65omr58eEmOsl1M6eHa5kTy+x/
         P98Bsn4I06VTvu/6U1h+HPZ+PSjyBEOK2FLolDfv4ibfdLORLc2v21ZrxnP1kUVcMmLq
         cmrQe4gxwf+15jucScLdESpf9IQlgxiIUO0hC1XViH+nVkngRUpE6aM4jpTotI9y5Y+N
         adPj547GKsLMmwTKjqgBT4Z/mGKBBJ0wsgsYw1S3v1XGFpEnWqMeow/UEDjxlxh0l6lr
         6iWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=85DsX9iAoK+Khgdz60GqS5EZIHIVR2Lk1qUZhsxGck4=;
        b=DnlftvfziiOzt4KkbgFMTJgHOqWrhd87qgVto8Nxjf1JUHuQ8qisS7BBKGKMX1B9/j
         Iosi8biGZerA7QT6mm0Uj2TzraEmzUpADZe3ORDfZY9Sb5faOSUwxjMf0qndWVWKmAtT
         BB27QiObkZCjDmfzIq2cKw1yo7LRFfzt2xGRtIgheR/EEET39vqvKpKmpkAVTni6vZTr
         l77UzMxMYf9JSaRr6/TH+xbHHbCUCFJB+pCSj8eUtL8yPKBabBJpocdjnAeE/4qXpKFU
         zVNHcQeDER6B+GOaGFxoQeONq3le6tzH7/GDlEAu76t+DAPfUYd8PMZOLSQ976yJ5e87
         BrLA==
X-Gm-Message-State: AOAM533KCQ/tBQMAs0kjIpLLaXrRik9ztKXrmlb112R8ueAlHdEan1RO
        DGMVT8Ca5tGItFC/iV2ztgo=
X-Google-Smtp-Source: ABdhPJwacY4yXiPfU7XNJqw3YTmgi6wntHkHwGLOlua0+WHEulFIM+YFXX7I/hT8oAd1l0g6hhm0lA==
X-Received: by 2002:a17:902:b113:b0:153:1d99:9cc7 with SMTP id q19-20020a170902b11300b001531d999cc7mr389590plr.6.1647622531307;
        Fri, 18 Mar 2022 09:55:31 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090a858a00b001c6a874142esm2395094pjn.17.2022.03.18.09.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:55:30 -0700 (PDT)
Date:   Fri, 18 Mar 2022 09:55:29 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 08/36] i386/tdx: Adjust get_supported_cpuid() for
 TDX VM
Message-ID: <20220318165529.GA4049379@ls.amr.corp.intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-9-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317135913.2166202-9-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 09:58:45PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> For TDX, the allowable CPUID configuration differs from what KVM
> reports for KVM scope via KVM_GET_SUPPORTED_CPUID.
> 
> - Some CPUID bits are not supported for TDX VM while KVM reports the
>   support. Mask them off for TDX VM. e.g., CPUID_EXT_VMX, some PV
>   featues.
> 
> - The supported XCR0 and XSS bits needs to be caped by tdx_caps, because
>   KVM uses them to setup XFAM of TD.
> 
> Introduce tdx_get_supported_cpuid() to adjust the
> kvm_arch_get_supported_cpuid() for TDX VM.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/cpu.h     |  5 +++++
>  target/i386/kvm/kvm.c |  4 ++++
>  target/i386/kvm/tdx.c | 39 +++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h |  2 ++
>  4 files changed, 50 insertions(+)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 5e406088a91a..7fa30f4ed7db 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -566,6 +566,11 @@ typedef enum X86Seg {
>  #define ESA_FEATURE_XFD_MASK            (1U << ESA_FEATURE_XFD_BIT)
>  
>  
> +#define XCR0_MASK       (XSTATE_FP_MASK | XSTATE_SSE_MASK | XSTATE_YMM_MASK | \
> +                         XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK | \
> +                         XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | \
> +                         XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK)
> +
>  /* CPUID feature words */
>  typedef enum FeatureWord {
>      FEAT_1_EDX,         /* CPUID[1].EDX */
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 26ed5faf07b8..ddbe8f64fadb 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -486,6 +486,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>          ret |= 1U << KVM_HINTS_REALTIME;
>      }
>  
> +    if (is_tdx_vm()) {
> +        tdx_get_supported_cpuid(function, index, reg, &ret);
> +    }
> +
>      return ret;
>  }
>  
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 846511b299f4..e4ee55f30c79 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -14,6 +14,7 @@
>  #include "qemu/osdep.h"
>  #include "qapi/error.h"
>  #include "qom/object_interfaces.h"
> +#include "standard-headers/asm-x86/kvm_para.h"
>  #include "sysemu/kvm.h"
>  
>  #include "hw/i386/x86.h"
> @@ -110,6 +111,44 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
>      return 0;
>  }
>  
> +void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
> +                             uint32_t *ret)
> +{
> +    switch (function) {
> +    case 1:
> +        if (reg == R_ECX) {
> +            *ret &= ~CPUID_EXT_VMX;
> +        }
> +        break;
> +    case 0xd:
> +        if (index == 0) {
> +            if (reg == R_EAX) {
> +                *ret &= (uint32_t)tdx_caps->xfam_fixed0 & XCR0_MASK;
> +                *ret |= (uint32_t)tdx_caps->xfam_fixed1 & XCR0_MASK;
> +            } else if (reg == R_EDX) {
> +                *ret &= (tdx_caps->xfam_fixed0 & XCR0_MASK) >> 32;
> +                *ret |= (tdx_caps->xfam_fixed1 & XCR0_MASK) >> 32;
> +            }
> +        } else if (index == 1) {
> +            /* TODO: Adjust XSS when it's supported. */
> +        }
> +        break;
> +    case KVM_CPUID_FEATURES:
> +        if (reg == R_EAX) {
> +            *ret &= ~((1ULL << KVM_FEATURE_CLOCKSOURCE) |
> +                      (1ULL << KVM_FEATURE_CLOCKSOURCE2) |
> +                      (1ULL << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
> +                      (1ULL << KVM_FEATURE_ASYNC_PF) |
> +                      (1ULL << KVM_FEATURE_ASYNC_PF_VMEXIT) |
> +                      (1ULL << KVM_FEATURE_ASYNC_PF_INT));

Because new feature bit may be introduced in future (it's unlikely though),
*ret &= (supported_bits) is better than *ret &= ~(unsupported_bits)

Thanks,

> +        }
> +        break;
> +    default:
> +        /* TODO: Use tdx_caps to adjust CPUID leafs. */
> +        break;
> +    }
> +}
> +
>  /* tdx guest */
>  OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
>                                     tdx_guest,
> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> index 4036ca2f3f99..06599b65b827 100644
> --- a/target/i386/kvm/tdx.h
> +++ b/target/i386/kvm/tdx.h
> @@ -27,5 +27,7 @@ bool is_tdx_vm(void);
>  #endif /* CONFIG_TDX */
>  
>  int tdx_kvm_init(MachineState *ms, Error **errp);
> +void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
> +                             uint32_t *ret);
>  
>  #endif /* QEMU_I386_TDX_H */
> -- 
> 2.27.0
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
