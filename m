Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946D05A1A4A
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 22:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243650AbiHYU0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 16:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243854AbiHYUZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 16:25:29 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE84518366;
        Thu, 25 Aug 2022 13:24:49 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x15so19989072pfp.4;
        Thu, 25 Aug 2022 13:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=S9g7MXdcvL7H7GmvpAVrocnqG/EzeqzT/WOXXOV+r7g=;
        b=P7Nc+wAPyu7jIH5gbbuQSHFYHvzrHfwdtcJsoDqBrU6qcVb6Ln5BcY60GKvOiFYIP2
         F3IrjARdGoonVB9h+ki4wATWsPTkHEIG6/Ketu0NeB49SuqVl26LhbHnKWjm7FITVvS9
         Uq9cQ03Zd3B7xeUNPMtm0R9La+CUImj2Znkce3/irTCpzpk5i9S1YDaE7rO85gIRkCKx
         v8Gi01wMHhRWp9mPD1BFxzxCpNFRCjqtOl4pirpwGIif8Dofv10xNV5DR34t9T2GjkF3
         mXv340l6KMLud7dBlcyvPiKcP9Ld4Q3WTZS5g9z6UNvi/MI5o8B1Vg3KFqjo+2LQDZWr
         ULzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=S9g7MXdcvL7H7GmvpAVrocnqG/EzeqzT/WOXXOV+r7g=;
        b=VUD0gyqcjQc2cKmg1ndp1rIxVLia24WWI+aKsEXiNuVg7No5lWYMrZg4MoyKZy2F56
         Se88utsdbhasVpF5QnT+taC3JCjUNx8ZKlzBlEB8zz13A8aHOGBcMAJtORl6PsnMgvBR
         8PgRs2/Jq6/wJ59XD21QcmGX9OmL7QDxaRaN46P6xjviyjVZmesYgRj7n33KWjz6EGJH
         RrSJKdgltm0EIzge+Rinx0j/RbFJi/MzMZhiD5/SDG2ithh4+Pk7iOmZu4t/wHYenxnS
         Swwk8wY9UtQAAfbLpssjWE6ThspJpfSo1tzKZoqc307hGpn9Sv1LzJUcbl4jSilXer8H
         Zntg==
X-Gm-Message-State: ACgBeo0QgXjgLFnT845Wqa7YLC6GY+oPyeRMx6Hoa3SOXNl18EukLcp/
        Y9TES/L6coBcypTQe10cUx8=
X-Google-Smtp-Source: AA6agR4lcFTN1LrYYyb5e6Puze6XoLf+UrsAmc7u0xgOpJa5pL/JP3lgXi4D2wh7NvQpuORP3BunBg==
X-Received: by 2002:a63:5d46:0:b0:41c:861:d0d2 with SMTP id o6-20020a635d46000000b0041c0861d0d2mr640095pgm.184.1661459088556;
        Thu, 25 Aug 2022 13:24:48 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id p66-20020a625b45000000b0052e5bb18a41sm50831pfb.58.2022.08.25.13.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 13:24:47 -0700 (PDT)
Date:   Thu, 25 Aug 2022 13:24:46 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 009/103] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20220825202446.GC2538772@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <b6f8588f51f530e3904d2b98199aba6547032ea4.1659854790.git.isaku.yamahata@intel.com>
 <cb23e06b-6b3e-22af-f5de-a13af7aab1e4@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cb23e06b-6b3e-22af-f5de-a13af7aab1e4@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022 at 04:18:01PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> On 2022/8/8 6:00, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX requires several initialization steps for KVM to create guest TDs.
> > Detect CPU feature, enable VMX (TDX is based on VMX), detect the TDX module
> > availability, and initialize it.  This patch implements those steps.
> > 
> > There are several options on when to initialize the TDX module.  A.) kernel
> > module loading time, B.) the first guest TD creation time.  A.) was chosen.
> > With B.), a user may hit an error of the TDX initialization when trying to
> > create the first guest TD.  The machine that fails to initialize the TDX
> > module can't boot any guest TD further.  Such failure is undesirable and a
> > surprise because the user expects that the machine can accommodate guest
> > TD, but actually not.  So A.) is better than B.).
> > 
> > Introduce a module parameter, enable_tdx, to explicitly enable TDX KVM
> > support.  It's off by default to keep same behavior for those who don't use
> > TDX.  Implement hardware_setup method to detect TDX feature of CPU.
> > Because TDX requires all present CPUs to enable VMX (VMXON).  The x86
> > specific kvm_arch_post_hardware_enable_setup overrides the existing weak
> > symbol of kvm_arch_post_hardware_enable_setup which is called at the KVM
> > module initialization.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  1 +
> >   arch/x86/kvm/Makefile           |  1 +
> >   arch/x86/kvm/vmx/main.c         | 29 ++++++++++-
> >   arch/x86/kvm/vmx/tdx.c          | 89 +++++++++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/tdx.h          |  4 ++
> >   arch/x86/kvm/vmx/x86_ops.h      |  6 +++
> >   arch/x86/kvm/x86.c              |  8 +++
> >   arch/x86/virt/vmx/tdx/tdx.c     |  1 +
> >   8 files changed, 138 insertions(+), 1 deletion(-)
> >   create mode 100644 arch/x86/kvm/vmx/tdx.c
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 3d000f060077..f432ad32515c 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1659,6 +1659,7 @@ struct kvm_x86_init_ops {
> >   	int (*cpu_has_kvm_support)(void);
> >   	int (*disabled_by_bios)(void);
> >   	int (*hardware_setup)(void);
> > +	int (*post_hardware_enable_setup)(void);
> >   	unsigned int (*handle_intel_pt_intr)(void);
> >   	struct kvm_x86_ops *runtime_ops;
> > diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> > index ee4d0999f20f..e2c05195cb95 100644
> > --- a/arch/x86/kvm/Makefile
> > +++ b/arch/x86/kvm/Makefile
> > @@ -24,6 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
> >   kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
> >   			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
> >   kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> > +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
> >   kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index a0252cc0b48d..ac788af17d92 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -7,6 +7,32 @@
> >   #include "pmu.h"
> >   #include "tdx.h"
> > +static bool __read_mostly enable_tdx = IS_ENABLED(CONFIG_INTEL_TDX_HOST);
> 
> So, if CONFIG_INTEL_TDX_HOST is opt-in in kconfig, the code will try to
> enable TDX.
> 
> The behavior seems a bit different from what you mentioned in the commit
> message about the option to "explicitly enable TDX KVM
> support".

Oops.  For least surpise, I'll fix it as follows.

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ac788af17d92..973c437f1a4e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -7,7 +7,7 @@
 #include "pmu.h"
 #include "tdx.h"
 
-static bool __read_mostly enable_tdx = IS_ENABLED(CONFIG_INTEL_TDX_HOST);
+static bool __read_mostly enable_tdx;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
 static __init int vt_hardware_setup(void)

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
