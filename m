Return-Path: <kvm+bounces-328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D82D37DE5BE
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 19:05:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 146901C20C0D
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 18:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB9818E0E;
	Wed,  1 Nov 2023 18:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cV0KYCn8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EF21862A
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 18:05:50 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E207F10F
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 11:05:45 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5afe220cadeso1145937b3.3
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 11:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698861945; x=1699466745; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rL6PypGT2hlmINXu9QUwfJHSqDzRPjLPXVa5ioHlgmM=;
        b=cV0KYCn8U3gEavG+eISSGQWUwGWiGyKlJz0hIyUcqRq3sOyBpI1UF5gxACX7Lg9om9
         Wln6PNazQdGp0Qcz52443Ku6hXwMpIBpPU2WgwOqMt75SmIkiAMAk4JIFBkDPe58XTfu
         PzbS1uacqXACACPptXq697KyQTYD3J0eDPkOy5VbzTBJsAOJOg3Ol7sfhcASrTuD73Qv
         00XhjtsSKaXZQBCWOgyMtCCptnxr1erS2LhZBaN4w0ofwZxs7EIxpBUen5YhxPrfpotO
         1CcoOPcDUPBliOvsQTV50V/hBxv7j/pAPSCVIYOdmDbfmfmLQMNLuhElBxPM6IwQtp8R
         2zeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698861945; x=1699466745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rL6PypGT2hlmINXu9QUwfJHSqDzRPjLPXVa5ioHlgmM=;
        b=C/5aSBRTcwLI/MlMEyxCsFMge36l4ozkPEI2W4mlkDUxA9SaswRkgPfwfTLEx1siCg
         Ck6O/rAKy7xPmHIiPCSVYUVxINf+dHoAh1spvQNjtJxja8TTiVzB2fpqqE09ocNwT2lQ
         YfQVUk6JztMcIgLcnDdB3GcupvnkWLft3nJ+WCfb+Xu83owImFrrYZIgpz1CEsrbFHZh
         Xzqw1UYKM9STnCnEkv6rMcff6qG6OywJ+c20r0RCdN2bECmMjPPm35Phs6UNIKp2NVv8
         D2O7zNOIkV4InljOqm0sAIhedXuDVz2svIiUiClhp7F+aEsRaZyEx6MC14XotvoB7eTy
         IK7Q==
X-Gm-Message-State: AOJu0Yz3qnHFUdebGr48AvTWryoakb/onFUisMifCM8qjvPlao66PUFZ
	tkoN8+eTQOABFp+pvxlf/Ur8iW1R4rM=
X-Google-Smtp-Source: AGHT+IF0EJWzD90tR3Yra+xB6XEurYAJXQJ9oQtDBrvYG4t2cwb5yIePSuJ/SeetUVaU4iSB2o0dFSo4ZJQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a14c:0:b0:59b:e97e:f7e2 with SMTP id
 y73-20020a81a14c000000b0059be97ef7e2mr351426ywg.4.1698861945136; Wed, 01 Nov
 2023 11:05:45 -0700 (PDT)
Date: Wed, 1 Nov 2023 11:05:43 -0700
In-Reply-To: <2b1973ee44498039c97d4d11de3a93b0f3b1d2d8.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-15-weijiang.yang@intel.com> <2b1973ee44498039c97d4d11de3a93b0f3b1d2d8.camel@redhat.com>
Message-ID: <ZUKTd_a00fs1nyyk@google.com>
Subject: Re: [PATCH v6 14/25] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 66edbed25db8..a091764bf1d2 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -133,6 +133,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
> >  static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
> >  
> >  static DEFINE_MUTEX(vendor_module_lock);
> > +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> > +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> > +
> >  struct kvm_x86_ops kvm_x86_ops __read_mostly;
> >  
> >  #define KVM_X86_OP(func)					     \
> > @@ -4372,6 +4375,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_get_msr_common);
> >  
> > +static const u32 xstate_msrs[] = {
> > +	MSR_IA32_U_CET, MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP,
> > +	MSR_IA32_PL2_SSP, MSR_IA32_PL3_SSP,
> > +};
> > +
> > +static bool is_xstate_msr(u32 index)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(xstate_msrs); i++) {
> > +		if (index == xstate_msrs[i])
> > +			return true;
> > +	}
> > +	return false;
> > +}
> 
> The name 'xstate_msr' IMHO is not clear.
> 
> How about naming it 'guest_fpu_state_msrs', together with adding a comment like that:

Maybe xstate_managed_msrs?  I'd prefer not to include "guest" because the behavior
is more a property of the architecture and/or the host kernel.  I understand where
you're coming from, but it's the MSR *values* are part of guest state, whereas the
check is a query on how KVM manages the MSR value, if that makes sense.

And I really don't like "FPU".  I get why the the kernel uses the "FPU" terminology,
but for this check in particular I want to tie the behavior back to the architecture,
i.e. provide the hint that the reason why these MSRs are special is because Intel
defined them to be context switched via XSTATE.

Actually, this is unnecesary bikeshedding to some extent, using an array is silly.
It's easier and likely far more performant (not that that matters in this case)
to use a switch statement.

Is this better?

/*
 * Returns true if the MSR in question is managed via XSTATE, i.e. is context
 * switched with the rest of guest FPU state.
 */
static bool is_xstate_managed_msr(u32 index)
{
	switch (index) {
	case MSR_IA32_U_CET:
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
		return true;
	default:
		return false;
	}
}

/*
 * Read or write a bunch of msrs. All parameters are kernel addresses.
 *
 * @return number of msrs set successfully.
 */
static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
		    struct kvm_msr_entry *entries,
		    int (*do_msr)(struct kvm_vcpu *vcpu,
				  unsigned index, u64 *data))
{
	bool fpu_loaded = false;
	int i;

	for (i = 0; i < msrs->nmsrs; ++i) {
		/*
	 	 * If userspace is accessing one or more XSTATE-managed MSRs,
		 * temporarily load the guest's FPU state so that the guest's
		 * MSR value(s) is resident in hardware, i.e. so that KVM can
		 * get/set the MSR via RDMSR/WRMSR.
	 	 */
		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
		    is_xstate_managed_msr(entries[i].index)) {
			kvm_load_guest_fpu(vcpu);
			fpu_loaded = true;
		}
		if (do_msr(vcpu, entries[i].index, &entries[i].data))
			break;
	}
	if (fpu_loaded)
		kvm_put_guest_fpu(vcpu);

	return i;
}

