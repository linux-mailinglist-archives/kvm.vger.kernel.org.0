Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C77A64E311
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiLOV2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLOV2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:28:22 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E799B2EB;
        Thu, 15 Dec 2022 13:28:21 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 65so472733pfx.9;
        Thu, 15 Dec 2022 13:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ExapCx37UjEvQS309AdBd4LfWq1oEKtgEk4FcxZX3E=;
        b=NrEFFw/OaB+yEsng+HIGBE2IpckkgoJ4tIuneu+Oksbxeuf4upxITvGdJ9feXKNQF0
         aRv1602qkiYZU7JHAKVZLfo+FLo6UPertUZE5H0sO1BaBFWWCZYW4fnGMRmtjG+7PCqg
         8GvIzrnt+uEK8mp1bi58KCA9RmT7+enEEJ/03QY0qBcgFNvd06hxzDbcUCErBbK/GHW5
         jFqnbK+GhaGkvLi7cC7Vdw2SmvNu+6rXJeAMBbx0usv0dToMcdcKhf4hIsM6Cr8iSNAR
         tOmE8o8pZrBxgDgdaCMP0HCakRuBFU3afeRTRzfvMSgDJHcz9r101qF0ykGDGDxUtMgG
         6a2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ExapCx37UjEvQS309AdBd4LfWq1oEKtgEk4FcxZX3E=;
        b=8RfWA8xccxIENrlT18QyzQfu2ZrDjI3ceSEntLuyZHBBxYBZa/RXRSDFkQjoVX0Whf
         sDhgxH6yoohJqu1N+B9esnW2IlYaLWrO0d3aFJC5OgG1w8WTgtjr9STz1KyN3Sk51Zof
         VjMR3bTq8FZZsB2ZVI/mRV38QjJN0r9iBNzRTnGqNgLdFMLnmqs3JcuiwYo2ng6kfq3Q
         zWRxFvyyqBsHAvuuXNqzfEM21t6fpjk77vst9Y/WmW32/9Xp8Ef1nVYgLenN+j8SzRCs
         Lm6Or3xRdVS/wHPh5ZI1sl5/pR9RQDKm8ZcCTvUex9gAf2PyUC20WIij6FWY+n37Roqc
         APyw==
X-Gm-Message-State: ANoB5pmY4Npo9aNjnDtHzsPHTwpIok4O1JIYpZLzKW3LFW1L23tN+PJh
        Pr2nRekRWaK8IMElyrFRkPY=
X-Google-Smtp-Source: AA0mqf6mSnPF/SvhEKbZ50IHQVkbztMKiiUxpppDo6CVHa2NE6zBapoJvkpAmkQr3kj2jx6e7lHsBQ==
X-Received: by 2002:a62:6303:0:b0:578:83f5:554d with SMTP id x3-20020a626303000000b0057883f5554dmr18020023pfb.23.1671139701109;
        Thu, 15 Dec 2022 13:28:21 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id s7-20020a625e07000000b0057691fb0d37sm44298pfb.193.2022.12.15.13.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 13:28:20 -0800 (PST)
Date:   Thu, 15 Dec 2022 13:28:19 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 024/108] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20221215212819.GG3632095@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <ba773a3f779d4d9df24c03874462410d8ee9c955.1667110240.git.isaku.yamahata@intel.com>
 <20221114064622.k42nnrypr77lrmek@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221114064622.k42nnrypr77lrmek@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 02:46:22PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Sat, Oct 29, 2022 at 11:22:25PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
> > structures, initialize it.  Allocate pages of TDX vcpu for the TDX module.
> >
> > In the case of the conventional case, cpuid is empty at the initialization.
> > and cpuid is configured after the vcpu initialization.  Because TDX
> > supports only X2APIC mode, cpuid is forcibly initialized to support X2APIC
> > on the vcpu initialization.
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/main.c    |  40 +++++++++--
> >  arch/x86/kvm/vmx/tdx.c     | 138 +++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/x86_ops.h |   8 +++
> >  3 files changed, 182 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index b4e4c6c677f6..c125b2e3e8b4 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -63,6 +63,38 @@ static void vt_vm_free(struct kvm *kvm)
> >  		return tdx_vm_free(kvm);
> >  }
> >
> > +static int vt_vcpu_precreate(struct kvm *kvm)
> > +{
> > +	if (is_td(kvm))
> > +		return 0;
> > +
> > +	return vmx_vcpu_precreate(kvm);
> > +}
> > +
> > +static int vt_vcpu_create(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return tdx_vcpu_create(vcpu);
> > +
> > +	return vmx_vcpu_create(vcpu);
> > +}
> > +
> > +static void vt_vcpu_free(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return tdx_vcpu_free(vcpu);
> > +
> > +	return vmx_vcpu_free(vcpu);
> > +}
> > +
> > +static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return tdx_vcpu_reset(vcpu, init_event);
> > +
> > +	return vmx_vcpu_reset(vcpu, init_event);
> > +}
> > +
> >  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> >  {
> >  	if (!is_td(kvm))
> > @@ -89,10 +121,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.vm_destroy = vt_vm_destroy,
> >  	.vm_free = vt_vm_free,
> >
> > -	.vcpu_precreate = vmx_vcpu_precreate,
> > -	.vcpu_create = vmx_vcpu_create,
> > -	.vcpu_free = vmx_vcpu_free,
> > -	.vcpu_reset = vmx_vcpu_reset,
> > +	.vcpu_precreate = vt_vcpu_precreate,
> > +	.vcpu_create = vt_vcpu_create,
> > +	.vcpu_free = vt_vcpu_free,
> > +	.vcpu_reset = vt_vcpu_reset,
> >
> >  	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
> >  	.vcpu_load = vmx_vcpu_load,
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 54045e0576e7..0625c354b341 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -49,6 +49,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> >  	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> >  }
> >
> > +static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> > +{
> > +	return tdx->tdvpr.added;
> > +}
> > +
> >  static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> >  {
> >  	return kvm_tdx->tdr.added;
> > @@ -296,6 +301,139 @@ int tdx_vm_init(struct kvm *kvm)
> >  	return 0;
> >  }
> >
> > +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	int ret, i;
> > +
> > +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> > +	if (!vcpu->arch.apic)
> > +		return -EINVAL;
> > +
> > +	fpstate_set_confidential(&vcpu->arch.guest_fpu);
> > +
> > +	ret = tdx_alloc_td_page(&tdx->tdvpr);
> > +	if (ret)
> > +		return ret;
> > +
> > +	tdx->tdvpx = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx),
> > +			GFP_KERNEL_ACCOUNT);
> > +	if (!tdx->tdvpx) {
> > +		ret = -ENOMEM;
> > +		goto free_tdvpr;
> > +	}
> > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > +		ret = tdx_alloc_td_page(&tdx->tdvpx[i]);
> > +		if (ret)
> > +			goto free_tdvpx;
> > +	}
> > +
> > +	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> > +
> > +	vcpu->arch.cr0_guest_owned_bits = -1ul;
> > +	vcpu->arch.cr4_guest_owned_bits = -1ul;
> > +
> > +	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
> > +	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> > +	vcpu->arch.guest_state_protected =
> > +		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
> > +
> > +	return 0;
> > +
> > +free_tdvpx:
> > +	/* @i points at the TDVPX page that failed allocation. */
> > +	for (--i; i >= 0; i--)
> > +		free_page(tdx->tdvpx[i].va);
> > +	kfree(tdx->tdvpx);
> > +	tdx->tdvpx = NULL;
> > +free_tdvpr:
> > +	free_page(tdx->tdvpr.va);
> > +
> > +	return ret;
> > +}
> > +
> > +void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	int i;
> > +
> > +	/* Can't reclaim or free pages if teardown failed. */
> > +	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
> > +		return;
> > +
> > +	if (tdx->tdvpx) {
> > +		for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
> > +			tdx_reclaim_td_page(&tdx->tdvpx[i]);
> > +		kfree(tdx->tdvpx);
> > +		tdx->tdvpx = NULL;
> > +	}
> > +	tdx_reclaim_td_page(&tdx->tdvpr);
> > +}
> > +
> > +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	struct msr_data apic_base_msr;
> > +	u64 err;
> > +	int i;
> > +
> > +	/* TDX doesn't support INIT event. */
> > +	if (WARN_ON_ONCE(init_event))
> > +		goto td_bugged;
> > +	if (WARN_ON_ONCE(is_td_vcpu_created(tdx)))
> > +		goto td_bugged;
> > +
> > +	err = tdh_vp_create(kvm_tdx->tdr.pa, tdx->tdvpr.pa);
> > +	if (WARN_ON_ONCE(err)) {
> > +		pr_tdx_error(TDH_VP_CREATE, err, NULL);
> > +		goto td_bugged;
> > +	}
> > +	tdx_mark_td_page_added(&tdx->tdvpr);
> > +
> > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > +		err = tdh_vp_addcx(tdx->tdvpr.pa, tdx->tdvpx[i].pa);
> > +		if (WARN_ON_ONCE(err)) {
> > +			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
> > +			goto td_bugged;
> > +		}
> > +		tdx_mark_td_page_added(&tdx->tdvpx[i]);
> > +	}
> > +
> > +	if (!vcpu->arch.cpuid_entries) {
> > +		/*
> > +		 * On cpu creation, cpuid entry is blank.  Forcibly enable
> > +		 * X2APIC feature to allow X2APIC.
> > +		 */
> > +		struct kvm_cpuid_entry2 *e;
> > +
> > +		e = kvmalloc_array(1, sizeof(*e), GFP_KERNEL_ACCOUNT);
> 
> NULL checking is necessary for kvmalloc_array.

Fixed. Because vcpu_reset() function doesn't return error, this logic is
moved to tdx_vcpu_create().

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
