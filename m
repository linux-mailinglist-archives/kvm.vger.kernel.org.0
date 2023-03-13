Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301C26B80EA
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 19:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjCMSlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 14:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjCMSlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 14:41:40 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEAA12F38;
        Mon, 13 Mar 2023 11:41:06 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so4373801pjt.5;
        Mon, 13 Mar 2023 11:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678732827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FJcEThXMBvASmpf8pfcTYJJBOWHOXUgvGhcvNRjTK9w=;
        b=mAF2PRe3Tw9v89lzR9Z3XggpQAqecTM0Gk41pGPJkf99LGEKCtwihWbdb0mrpYFzVC
         MO4N87VGH9kKqPyQXbKP44Og0WvCuHP3UIsDRmt8D9UKG9EmQdQyZ24GEy8DUpDyxglJ
         vzVpwN6bujuzRyFxbgR0GiKR++WrJNy66C9mcl5m3h73y23kQ+bZmosfbV1P3Eev/+ZA
         4zqZtYO+tv46Akgb4pdqisFTftt45aeG6KJ6q+/w5G7X1t0TKJT8pJiBjZDfTipwY97d
         j1sj1GmOrkugAj/g4VrU48+vE+AfXUpW9b3Ig9GNspn5TeEb5KrvVbJLvrsls276scgh
         YNfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678732827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FJcEThXMBvASmpf8pfcTYJJBOWHOXUgvGhcvNRjTK9w=;
        b=MADYuJVGjkTKq9bAMDdt/i37gEelV318rI47atr1kAvaueXiqw24Gtoq9+c9vSmpJr
         lvf97iEaQo0FktJ4lwA7Xdy0EC3UwbrxRqXwt7w+MiDDoVsBdtUgMSctd0zNRpArhEGs
         ruoQvmBJ1edfj3nDnz2JhrQb0eig9oqwajM+U4471RXH7yXj1CK4bniPBQnMm5OBQnXM
         G5ThWlxcHN6ggtOYXQFpEhvIXkZYg+JPUU21zt7/98BQn+k2RIggzL7bV2Ww0Q7V1VfD
         fiWUcBDcBX4J9BApyr6xkS4NFkwPwNS6gKherVFVX9bCY0XGmW8/7yFNOo0EpYe13Pog
         rb3w==
X-Gm-Message-State: AO0yUKX3+yRPCl8+E/5vHrGlkl/QE5dEy6mDJwMzIhFX70QElSueejqC
        L4lBwoueedjAcxLOC6MlFHM=
X-Google-Smtp-Source: AK7set+vgQiMYh5C4eni0jBrKO5gchwAa7g9isoJ7fTIzAsqCN4BZxXEoEqYT5RsNutZlfd8r7StSQ==
X-Received: by 2002:a05:6a20:6a03:b0:cc:f9f2:3034 with SMTP id p3-20020a056a206a0300b000ccf9f23034mr36952373pzk.40.1678732826462;
        Mon, 13 Mar 2023 11:40:26 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id y3-20020a62b503000000b005a75d85c0c7sm70268pfe.51.2023.03.13.11.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 11:40:25 -0700 (PDT)
Date:   Mon, 13 Mar 2023 11:40:24 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v13 002/113] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Message-ID: <20230313184024.GA3922605@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <e4d32af22f0a540c62fffaa17fe478a723e109ea.1678643052.git.isaku.yamahata@intel.com>
 <DS0PR11MB63735A7EEC68894923925ECEDCB99@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DS0PR11MB63735A7EEC68894923925ECEDCB99@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023 at 02:49:03PM +0000,
"Wang, Wei W" <wei.w.wang@intel.com> wrote:

> On Monday, March 13, 2023 1:55 AM, isaku.yamahata@intel.com wrote:
> > Currently, KVM VMX module initialization/exit functions are a single function
> > each.  Refactor KVM VMX module initialization functions into KVM common
> > part and VMX part so that TDX specific part can be added cleanly.
> > Opportunistically refactor module exit function as well.
> > 
> > The current module initialization flow is,
> > 0.) Check if VMX is supported,
> > 1.) hyper-v specific initialization,
> > 2.) system-wide x86 specific and vendor specific initialization,
> > 3.) Final VMX specific system-wide initialization,
> > 4.) calculate the sizes of VMX kvm structure and VMX vcpu structure,
> > 5.) report those sizes to the KVM common layer and KVM common
> >     initialization
> > 
> > Refactor the KVM VMX module initialization function into functions with a
> > wrapper function to separate VMX logic in vmx.c from a file, main.c, common
> > among VMX and TDX.  Introduce a wrapper function for vmx_init().
> > 
> > The KVM architecture common layer allocates struct kvm with reported size for
> > architecture-specific code.  The KVM VMX module defines its structure as
> > struct vmx_kvm { struct kvm; VMX specific members;} and uses it as struct vmx
> > kvm.  Similar for vcpu structure. TDX KVM patches will define TDX specific kvm
> > and vcpu structures.
> > 
> > The current module exit function is also a single function, a combination of
> > VMX specific logic and common KVM logic.  Refactor it into VMX specific logic
> > and KVM common logic.  This is just refactoring to keep the VMX specific logic
> > in vmx.c from main.c.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/main.c    | 51 +++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.c     | 54 +++++---------------------------------
> >  arch/x86/kvm/vmx/x86_ops.h | 13 ++++++++-
> >  3 files changed, 69 insertions(+), 49 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c index
> > a59559ff140e..3f49e8e38b6b 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -165,3 +165,54 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
> >  	.runtime_ops = &vt_x86_ops,
> >  	.pmu_ops = &intel_pmu_ops,
> >  };
> > +
> > +static int __init vt_init(void)
> > +{
> > +	unsigned int vcpu_size, vcpu_align;
> > +	int r;
> > +
> > +	if (!kvm_is_vmx_supported())
> > +		return -EOPNOTSUPP;
> > +
> > +	/*
> > +	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> > +	 * to unwind if a later step fails.
> > +	 */
> > +	hv_init_evmcs();
> > +
> > +	r = kvm_x86_vendor_init(&vt_init_ops);
> > +	if (r)
> > +		return r;
> > +
> > +	r = vmx_init();
> > +	if (r)
> > +		goto err_vmx_init;
> > +
> > +	/*
> > +	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> > +	 * exposed to userspace!
> > +	 */
> > +	vt_x86_ops.vm_size = sizeof(struct kvm_vmx);
> > +	vcpu_size = sizeof(struct vcpu_vmx);
> > +	vcpu_align = __alignof__(struct vcpu_vmx);
> > +	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
> > +	if (r)
> > +		goto err_kvm_init;
> > +
> > +	return 0;
> > +
> > +err_kvm_init:
> > +	vmx_exit();
> > +err_vmx_init:
> > +	kvm_x86_vendor_exit();
> > +	return r;
> > +}
> > +module_init(vt_init);
> 
> I had a patch to fix a bug here, maybe you can take it:
> 
> kvm_x86_vendor_init copies vt_x86_ops to kvm_x86_ops. vt_x86_ops.vm_size
> needs to be updated before calling kvm_x86_vendor_init so that kvm_x86_ops
> can get the correct vm_size.

Thanks for catching it.  With your patch, vm_size is always
max(sizeof struct kvm_vmx, sizeof strut kvm_tdx) even when the admin sets
kvm_intel.tdx=true and tdx is disabled by error.

option 1: Ignore such waste. Your patch. The difference is small and it's only
          the error case. Locally I have the following values.
          sizeof(struct kvm_vmx) = 44576
          sizeof(struct vcpu_vmx) = 10432
          sizeof(struct kvm_tdx)= 44632
          sizeof(struct vcpu_tdx) = 8192
          I suspect the actual allocation size for struct kvm is same.  That's
          the reason why I didn't hit problem.

option 2: Explicitly update vm_size after kvm_x86_vendor_init()
          struct kvm_x86_ops isn't exported.  It would be ugly.

option 3: Allow setup_hardware() to update vm_size.
          setup_hardware(void) => setup_hardware(unsigned int *vm_size)
          It's confusing because kvm_x86_ops.vm_size is already initialized.

Let's go with option 1(your patch).
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
