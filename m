Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB8246DB31
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 19:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbhLHSjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 13:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238997AbhLHSjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 13:39:12 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545A3C0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 10:35:40 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id l64so2777849pgl.9
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 10:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ECqrcggOkdznl5re9oGFK7ZI8Du24aPTOb53ONKb1g8=;
        b=pt5Av/rJ0X0DCFI36JlgNlkQlSiRHGafG2Vzlw0ecTT5pJ/Ih257FQtCzrIEeZYxus
         jiEvVXdop7qCE8M2yoPrwnJkTSOPoFszlu5GAB6NoD7pSpM/Rg19c01udlNhR47DqBRL
         dnGWCKM0JcOb2Ta39ykxncVXMBHVXjrgeWkXqfESuw9zpiUsKH0DkjI7nRq6DazqbKyq
         zCRymmrt99tMvj4vJ4xnPR1u1R6ywRGnc/YnF9pRIknCG3o3n7ZIc/ZhiTJvk/nBAa2T
         pNC58/O3iXnn/pGzz4iJSLBeAhGue8D2W+uh7WumsM4Mv2gTIGnD019O6YaLfnZLJyct
         MRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ECqrcggOkdznl5re9oGFK7ZI8Du24aPTOb53ONKb1g8=;
        b=Atg+zl2BCwTXIvZ7LHqJQdTcAj/RpY1YYaU9OdvoD78YQ8TgOVpPJ6mH/M19w4/FbY
         KVz41doeEYlSiP04qrlJuwLUHKGW8jC5eW68UipBUdJyXGyx3VBu7pt7s3A9AqxFRhU0
         y/VK3RIErvIvn7v1lMrXbNjkUYQ9eJYRvn2xl4MhOIGLVIARIWUSye+l2B3PC8PiE05D
         tuGoPb6Fdxp6IzMUyFMxpBeyk55EK2tkR3PfItIDlHWFI4SoOFRkruz6i2pwUHA0tLig
         ILOwe2SGHRh0PQARtLucs2KYfbk9GQb4lwqCQ7AAbjYXPH3w3u34+d40LoTg9UTTdi92
         Bpwg==
X-Gm-Message-State: AOAM533yUMx+2ou7XgNYXPWqj67Y9iJrMuMjvoIwtORCB6NovwazWV1R
        vjPbz6wrfXm9tzZcql4nSstf9dcILZ8UtQ==
X-Google-Smtp-Source: ABdhPJw6GYauTEVER0R86DnpQ+Ah9xmnHGFQqqyD5T8BuCkZBXZ0YUzeA3subYfQPE883zhgmhGLOw==
X-Received: by 2002:a63:f003:: with SMTP id k3mr21684913pgh.260.1638988539639;
        Wed, 08 Dec 2021 10:35:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lb4sm7561563pjb.18.2021.12.08.10.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 10:35:39 -0800 (PST)
Date:   Wed, 8 Dec 2021 18:35:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] KVM: x86: Introduce definitions to support static
 calls for kvm_pmu_ops
Message-ID: <YbD691K7B9VVbswI@google.com>
References: <20211108111032.24457-1-likexu@tencent.com>
 <20211108111032.24457-7-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108111032.24457-7-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 08, 2021, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Use static calls to improve kvm_pmu_ops performance. Introduce the
> definitions that will be used by a subsequent patch to actualize the
> savings. Add a new kvm-x86-pmu-ops.h header that can be used for the
> definition of static calls. This header is also intended to be
> used to simplify the defition of amd_pmu_ops and intel_pmu_ops.
> 
> Like what we did for kvm_x86_ops, 'pmu_ops' can be covered by
> static calls in a simlilar manner for insignificant but not
> negligible performance impact, especially on older models.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---

This absolutely shouldn't be separated from patch 7/7.  By _defining_ the static
calls but not providing the logic to actually _update_ the calls, it's entirely
possible to add static_call() invocations that will compile cleanly without any
chance of doing the right thing at runtime.  

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0236c1a953d0..804f98b5552e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -99,7 +99,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)

 static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 {
-       return kvm_pmu_ops.pmc_is_enabled(pmc);
+       return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
 }

 static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,

> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#if !defined(KVM_X86_PMU_OP) || !defined(KVM_X86_PMU_OP_NULL)
> +BUILD_BUG_ON(1)
> +#endif
> +
> +/*
> + * KVM_X86_PMU_OP() and KVM_X86_PMU_OP_NULL() are used to

Please use all 80 chars.

> + * help generate "static_call()"s. They are also intended for use when defining
> + * the amd/intel KVM_X86_PMU_OPs. KVM_X86_PMU_OP() can be used

AMD/Intel since this is referring to the vendor and not to function names (like
the below reference).

> + * for those functions that follow the [amd|intel]_func_name convention.
> + * KVM_X86_PMU_OP_NULL() can leave a NULL definition for the

As below, please drop the _NULL() variant.

> + * case where there is no definition or a function name that
> + * doesn't match the typical naming convention is supplied.
> + */

...

> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 353989bf0102..bfdd9f2bc0fa 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -50,6 +50,12 @@
>  struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
>  EXPORT_SYMBOL_GPL(kvm_pmu_ops);
>  
> +#define	KVM_X86_PMU_OP(func)	\
> +	DEFINE_STATIC_CALL_NULL(kvm_x86_pmu_##func,	\
> +				*(((struct kvm_pmu_ops *)0)->func))
> +#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
> +#include <asm/kvm-x86-pmu-ops.h>
> +
>  static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
>  {
>  	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index b2fe135d395a..40e0b523637b 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -45,6 +45,11 @@ struct kvm_pmu_ops {
>  	void (*cleanup)(struct kvm_vcpu *vcpu);
>  };
>  
> +#define	KVM_X86_PMU_OP(func)	\
> +	DECLARE_STATIC_CALL(kvm_x86_pmu_##func, *(((struct kvm_pmu_ops *)0)->func))
> +#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP

I don't want to proliferate the pointless and bitrot-prone KVM_X86_OP_NULL macro,
just omit this.  I'll send a patch to drop KVM_X86_OP_NULL.

> +#include <asm/kvm-x86-pmu-ops.h>
> +
>  static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> -- 
> 2.33.0
> 
