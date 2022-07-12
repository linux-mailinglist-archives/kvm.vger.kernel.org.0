Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE8357275D
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 22:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiGLUfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 16:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGLUfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 16:35:47 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B065FA58D3;
        Tue, 12 Jul 2022 13:35:46 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r186so1398915pgr.2;
        Tue, 12 Jul 2022 13:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dsj65B36SHPt1jY+YKCsF4AuEiEfb/4USf5ig8Q6FVI=;
        b=NJGklDrevQF1++hLN9JDPGMlqEzdKsU4Peytf0ZZzfqMs6sNclbuhwaOtG4jXAXHvo
         mFiUc0qGy4UZ5Q53GbZCfhZJEDrI2q97Q6YuNudNLrYulDhc+dq9pXbrkxvMv2VUftWy
         w+o+Bu9wFUXcbDemgk8dc68ZQqp9kn0Wqv+JKu9EyTxj3Fg4l/7KcmGQ1pw4DEQpcV8C
         R/JGB5ZeQa+RbFWGTfKMJ4rxIyx4g+x7KnVkeAdgoz9HuD0nHYDO7oJRaJeEllhTwKmr
         aKT6EWDJINf/xtf569hyKTMXVrog1fUamgpdCeMbYaDOVummSChk3Ap4YLnNK00uvsm6
         ZPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dsj65B36SHPt1jY+YKCsF4AuEiEfb/4USf5ig8Q6FVI=;
        b=S9puBipwVGmx+GzDQwnByAtw54sLqJFmeGfSiVbWwkMpOL7sm/PA9L+oryX4VSNCPi
         C8yLYZfwwkvbS7iD10RCJGkst/RvxEISH8kATcnwjdB5SQD6kvv3eNqmeRzKZmlxzvG1
         MPAp7mxnn3zLVie8H23ID/ivV8pqnmy7Ae0LMDJa0HRxSGMz71wwJKswQeMpMrbXrvmo
         UlykO1XiSxqSGlIRARIk0I6H/jFepuIZ78hKFWAcu4WPHlgdBglZBbAyWfD67beQK5Zs
         75UtHrW83e+sNwtt0Q6PEkVgethLA2GlZYHGe/t1msjDP21j3NaLt3ie/PDKtDkwKvcm
         4DGA==
X-Gm-Message-State: AJIora9Z8rRYSbMk/PNA9Q88q0ydBF+ixjLV410Obph48r5F6yRbX9F2
        vvmggI88uVGxyjlWqBNKqyFNKjl2nqg=
X-Google-Smtp-Source: AGRyM1vkrAwfzqqqFig6+mSzDiboUBQemdM5KezzgflIeKQTAkuvA5GgVeO8La6fgwwfxp5v8r1pPw==
X-Received: by 2002:a63:6c06:0:b0:40d:e2a0:278c with SMTP id h6-20020a636c06000000b0040de2a0278cmr58333pgc.328.1657658146056;
        Tue, 12 Jul 2022 13:35:46 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id d3-20020a17090ae28300b001ef8ab65052sm20883pjz.11.2022.07.12.13.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:35:44 -0700 (PDT)
Date:   Tue, 12 Jul 2022 13:35:42 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 030/102] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <20220712203542.GN1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <e05ce01e400f80437803146564d4c351bf1df047.1656366338.git.isaku.yamahata@intel.com>
 <20220708021443.v4frmpcqgbk23hkp@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220708021443.v4frmpcqgbk23hkp@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08, 2022 at 10:14:43AM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Mon, Jun 27, 2022 at 02:53:22PM -0700, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > TD guest vcpu need to be configured before ready to run which requests
> > addtional information from Device model (e.g. qemu), one 64bit value is
> > passed to vcpu's RCX as an initial value.  Repurpose KVM_MEMORY_ENCRYPT_OP
> > to vcpu-scope and add new sub-commands KVM_TDX_INIT_VCPU under it for such
> > additional vcpu configuration.
> >
> > Add callback for kvm vCPU-scoped operations of KVM_MEMORY_ENCRYPT_OP and
> > add a new subcommand, KVM_TDX_INIT_VCPU, for further vcpu initialization.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h    |  1 +
> >  arch/x86/include/asm/kvm_host.h       |  1 +
> >  arch/x86/include/uapi/asm/kvm.h       |  1 +
> >  arch/x86/kvm/vmx/main.c               |  9 +++++++
> >  arch/x86/kvm/vmx/tdx.c                | 36 +++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/tdx.h                |  4 +++
> >  arch/x86/kvm/vmx/x86_ops.h            |  2 ++
> >  arch/x86/kvm/x86.c                    |  6 +++++
> >  tools/arch/x86/include/uapi/asm/kvm.h |  1 +
> >  9 files changed, 61 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 3677a5015a4f..32a6df784ea6 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -119,6 +119,7 @@ KVM_X86_OP(leave_smm)
> >  KVM_X86_OP(enable_smi_window)
> >  KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
> >  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
> > +KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
> >  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
> >  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
> >  KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 81638987cdb9..e5d4e5b60fdc 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1595,6 +1595,7 @@ struct kvm_x86_ops {
> >
> >  	int (*dev_mem_enc_ioctl)(void __user *argp);
> >  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> > +	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
> >  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> >  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> >  	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index f89774ccd4ae..399c28b2f4f5 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -538,6 +538,7 @@ struct kvm_pmu_event_filter {
> >  enum kvm_tdx_cmd_id {
> >  	KVM_TDX_CAPABILITIES = 0,
> >  	KVM_TDX_INIT_VM,
> > +	KVM_TDX_INIT_VCPU,
> >
> >  	KVM_TDX_CMD_NR_MAX,
> >  };
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 4f4ed4ad65a7..ce12cc8276ef 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -113,6 +113,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> >  	return tdx_vm_ioctl(kvm, argp);
> >  }
> >
> > +static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> > +{
> > +	if (!is_td_vcpu(vcpu))
> > +		return -EINVAL;
> > +
> > +	return tdx_vcpu_ioctl(vcpu, argp);
> > +}
> > +
> >  struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.name = "kvm_intel",
> >
> > @@ -255,6 +263,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >
> >  	.dev_mem_enc_ioctl = tdx_dev_ioctl,
> >  	.mem_enc_ioctl = vt_mem_enc_ioctl,
> > +	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
> >  };
> >
> >  struct kvm_x86_init_ops vt_init_ops __initdata = {
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index d9fe3f6463c3..2772775457b0 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -83,6 +83,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> >  	return kvm_tdx->hkid > 0;
> >  }
> >
> > +static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
> > +{
> > +	return kvm_tdx->finalized;
> > +}
> > +
> >  static void tdx_clear_page(unsigned long page)
> >  {
> >  	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > @@ -805,6 +810,37 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> >  	return r;
> >  }
> >
> > +int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	struct kvm_tdx_cmd cmd;
> > +	u64 err;
> > +
> > +	if (tdx->initialized)
> 
> Minor: How about "tdx_vcpu->initialized" ? there's
> "is_td_initialized()" below, the "tdx" here may lead guys to treat it
> as whole td vm until they confirmed it's type again.

I think you man tdx->vcpu_initialized.  If so, makes sense. I'll rename it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
