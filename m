Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE7A606891
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 21:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJTTCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 15:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJTTCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 15:02:30 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F9618A01C
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:02:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d24so186747pls.4
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8KAlJQQJ5FQu1qVFxkgATPb3Wj8F4GmKPCoxa33rfgg=;
        b=QLNqximVI/V3mdyjitNFfUihsv+HeepAILjBFnKhghdqvGcJJj/er21FcCm+sLs9vD
         1h8VRqjOtIIUE73W8dsBAjvTOKXMaMFUzUHF6ukR/uped7cUQDThCTfCfW2Wc4Hf8RGH
         E13rtEwhIx+GsJOnehJekQSlPZpU8rv8yKSN1fq9Kkz5CqWAn5cge4dQD1qrC2n8tsEq
         8UYNV3i7mTogPUviLaFOxIYENu9aWCnOdh+cIWoI/8jdoVJ8BFoBvGFyI1MS2EsmRoy1
         9kE3d1JFDtXlQ6p+XN3e8Dr/5g6wrBzpXygvuLk4ZYcuGV3WYKMbLRDrPz6soMkUYoGZ
         1adQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8KAlJQQJ5FQu1qVFxkgATPb3Wj8F4GmKPCoxa33rfgg=;
        b=RCbAkWBHl0mDV0H1fe7KdNeasxZwe5KIQEc29wfTlZ7Zt4BT5ppemadHOPWyhIl/we
         47roeNKIu/0uTo+q21/klbZ9++20rTgIeNTMDN8ZtILHUsCPg3WcYMIsHFxncVC24yAF
         FOznwYNI8ObrZmFsLn39xzacggoE51UN100TtqQ8C0qdypKr1E5YTn5Y18gu2Ci/YHlJ
         1cfcWBzmemZMcnj92rxr3Wg9PylCaY3TWq9HAt08ja+8JsF8eGwsLPEnFwxcTcJhqdak
         Ik/FW8Rekk/CVPIltxeDwNpR7zRED63kHqwFXdmCURJ2DaAPDJrMlqUa/1Tp0GCjsB+w
         KJBw==
X-Gm-Message-State: ACrzQf1053BGlgmlL5KB3jyFx/+QYiBqAVarjW79bbxqSTiUXiW51LOD
        1Ow5TjbE7uVhJbROD7GvOZkcYA==
X-Google-Smtp-Source: AMsMyM6wc+43w/dyEP+67NFvqLgsRvL1q29RwqOwBgR4H4Vym7aZKlwRpLfzDVQft99d6sTvY7FHTw==
X-Received: by 2002:a17:90b:3b8d:b0:20d:5c7a:abf1 with SMTP id pc13-20020a17090b3b8d00b0020d5c7aabf1mr18276779pjb.118.1666292549183;
        Thu, 20 Oct 2022 12:02:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g135-20020a62528d000000b0056328e516f4sm13967173pfb.148.2022.10.20.12.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 12:02:28 -0700 (PDT)
Date:   Thu, 20 Oct 2022 19:02:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 15/16] svm: introduce svm_vcpu
Message-ID: <Y1GbQbJxEAGqIP93@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-16-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020152404.283980-16-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> This adds minimum amout of code to support tests that
> run SVM on more that one vCPU.

s/that/than

> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/svm_lib.c |   9 +
>  lib/x86/svm_lib.h |  10 +
>  x86/svm.c         |  37 ++-
>  x86/svm.h         |   5 +-
>  x86/svm_npt.c     |  44 ++--
>  x86/svm_tests.c   | 615 +++++++++++++++++++++++-----------------------
>  6 files changed, 362 insertions(+), 358 deletions(-)
> 
> diff --git a/lib/x86/svm_lib.c b/lib/x86/svm_lib.c
> index 2b067c65..1152c497 100644
> --- a/lib/x86/svm_lib.c
> +++ b/lib/x86/svm_lib.c
> @@ -157,3 +157,12 @@ void vmcb_ident(struct vmcb *vmcb)
>  		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
>  	}
>  }
> +
> +void svm_vcpu_init(struct svm_vcpu *vcpu)
> +{
> +	vcpu->vmcb = alloc_page();
> +	vmcb_ident(vcpu->vmcb);
> +	memset(&vcpu->regs, 0, sizeof(vcpu->regs));
> +	vcpu->stack = alloc_pages(4) + (PAGE_SIZE << 4);
> +	vcpu->vmcb->save.rsp = (ulong)(vcpu->stack);
> +}
> diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> index 59db26de..c6957dba 100644
> --- a/lib/x86/svm_lib.h
> +++ b/lib/x86/svm_lib.h
> @@ -89,6 +89,16 @@ struct svm_extra_regs
>      u64 r15;
>  };
>  
> +
> +struct svm_vcpu
> +{
> +	struct vmcb *vmcb;
> +	struct svm_extra_regs regs;
> +	void *stack;
> +};
> +
> +void svm_vcpu_init(struct svm_vcpu *vcpu);
> +
>  #define SWAP_GPRS(reg) \
>  		"xchg %%rcx, 0x08(%%" reg ")\n\t"       \
>  		"xchg %%rdx, 0x10(%%" reg ")\n\t"       \
> diff --git a/x86/svm.c b/x86/svm.c
> index 9484a6d1..7aa3ebd2 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -16,7 +16,7 @@
>  #include "apic.h"
>  #include "svm_lib.h"
>  
> -struct vmcb *vmcb;
> +struct svm_vcpu vcpu0;

It's not strictly vCPU0, e.g. svm_init_intercept_test() deliberately runs on
vCPU2, presumably to avoid running on the BSP?

Since this is churning a lot of code anyways, why not clean this all up and have
run_svm_tests() dynamically allocate state instead of relying on global data?
