Return-Path: <kvm+bounces-447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A63447DF9F3
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:31:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CC4A281D37
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD62421360;
	Thu,  2 Nov 2023 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Opf/qrBR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFDB21352
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:31:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDCDDB
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698949882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xxC28PYqiT7BcV5DEi3XMjaZ09KLMWNz9I8Ill0c/8=;
	b=Opf/qrBRu5bdyGxK9HbaGiI1S6p1cXq+ec4KzCentttMO3wwmgzC2eRzDNLDb5Vjtwiii/
	l2PBxVxqyTL+YDIY6+7DtN2inFkduFaZRqeO4GDVMbfZ4/TfV3wvTz+XNjhbu80cQ3HQBr
	zKeYanHJDvKunzPhdjmrSsAZO0vLvlw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-v59faEU7MWqVCkzTYg_boQ-1; Thu, 02 Nov 2023 14:31:18 -0400
X-MC-Unique: v59faEU7MWqVCkzTYg_boQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4083fec2c30so8216915e9.1
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698949877; x=1699554677;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5xxC28PYqiT7BcV5DEi3XMjaZ09KLMWNz9I8Ill0c/8=;
        b=F/Jocc/58KlUrz+GIbi/loeUmtEkrrfoX4xBQ0HEYeKgT2tEa4rPXCmwLw4mDBVyHW
         9RGZVPVGmpvQv03lMl8VttfR64R6VLqEYrGFJp2Mm1pgyK7CAQYV1dVi0fuIwSRkFhbJ
         h6YnLzrBauBonxySkPuYARBfQkcMuXDELm1iFvtOWGbqCDVBl45EBTHJOLyfedgHwCPk
         j7P0iSCXkt5d8fQhqZ8oLnIthAFLiMvMky+FH4JnHtitUmBv+pGUrbtRemxtnfegZT+p
         SiEDJYBM2u/YXNrb3m9dWq0AGycj2LOWiKSR9Vha99hjGEhOkx/uJT1hOCdRVSIFLTXb
         NPFA==
X-Gm-Message-State: AOJu0Yyc9AWN9eFFwzP+y/7GFs+Bveq+9r9enXpT9czBLQ66VXUZV1ba
	Z7MbLcWjqK9zu8V2wSmwX9nmR1p9vjQ+7zCPIKLJUe9NEWFA1BsdD3cxd/YJ4+PshjDL35/cB8I
	wM1lnXaDikWTA
X-Received: by 2002:a05:6000:1ac7:b0:32d:a213:4d7d with SMTP id i7-20020a0560001ac700b0032da2134d7dmr16596500wry.56.1698949877180;
        Thu, 02 Nov 2023 11:31:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/utLi6fXUliUkkLs2Oubehgwj7LYFXk+YZFFrwQgh7gri3uv7upJ9ZiWvrqkmmQv+MLY1Gg==
X-Received: by 2002:a05:6000:1ac7:b0:32d:a213:4d7d with SMTP id i7-20020a0560001ac700b0032da2134d7dmr16596481wry.56.1698949876866;
        Thu, 02 Nov 2023 11:31:16 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id k23-20020adfb357000000b0032d829e10c0sm15151wrd.28.2023.11.02.11.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:31:16 -0700 (PDT)
Message-ID: <f930aa68395d6ead6b94b1b7a6e4f3af1cfe9205.camel@redhat.com>
Subject: Re: [PATCH v6 14/25] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com, 
	peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 02 Nov 2023 20:31:14 +0200
In-Reply-To: <ZUKTd_a00fs1nyyk@google.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-15-weijiang.yang@intel.com>
	 <2b1973ee44498039c97d4d11de3a93b0f3b1d2d8.camel@redhat.com>
	 <ZUKTd_a00fs1nyyk@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-01 at 11:05 -0700, Sean Christopherson wrote:
> On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 66edbed25db8..a091764bf1d2 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -133,6 +133,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
> > >  static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
> > >  
> > >  static DEFINE_MUTEX(vendor_module_lock);
> > > +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> > > +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> > > +
> > >  struct kvm_x86_ops kvm_x86_ops __read_mostly;
> > >  
> > >  #define KVM_X86_OP(func)					     \
> > > @@ -4372,6 +4375,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_get_msr_common);
> > >  
> > > +static const u32 xstate_msrs[] = {
> > > +	MSR_IA32_U_CET, MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP,
> > > +	MSR_IA32_PL2_SSP, MSR_IA32_PL3_SSP,
> > > +};
> > > +
> > > +static bool is_xstate_msr(u32 index)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(xstate_msrs); i++) {
> > > +		if (index == xstate_msrs[i])
> > > +			return true;
> > > +	}
> > > +	return false;
> > > +}
> > 
> > The name 'xstate_msr' IMHO is not clear.
> > 
> > How about naming it 'guest_fpu_state_msrs', together with adding a comment like that:
> 
> Maybe xstate_managed_msrs?  I'd prefer not to include "guest" because the behavior
> is more a property of the architecture and/or the host kernel.  I understand where
> you're coming from, but it's the MSR *values* are part of guest state, whereas the
> check is a query on how KVM manages the MSR value, if that makes sense.
Makes sense.
> 
> And I really don't like "FPU".  I get why the the kernel uses the "FPU" terminology,
> but for this check in particular I want to tie the behavior back to the architecture,
> i.e. provide the hint that the reason why these MSRs are special is because Intel
> defined them to be context switched via XSTATE.
> 
> Actually, this is unnecesary bikeshedding to some extent, using an array is silly.
> It's easier and likely far more performant (not that that matters in this case)
> to use a switch statement.
> 
> Is this better?
> 
> /*
>  * Returns true if the MSR in question is managed via XSTATE, i.e. is context
>  * switched with the rest of guest FPU state.
>  */
> static bool is_xstate_managed_msr(u32 index)
> {
> 	switch (index) {
> 	case MSR_IA32_U_CET:
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> 		return true;
> 	default:
> 		return false;
> 	}
> }

Reasonable.

> 
> /*
>  * Read or write a bunch of msrs. All parameters are kernel addresses.
>  *
>  * @return number of msrs set successfully.
>  */
> static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
> 		    struct kvm_msr_entry *entries,
> 		    int (*do_msr)(struct kvm_vcpu *vcpu,
> 				  unsigned index, u64 *data))
> {
> 	bool fpu_loaded = false;
> 	int i;
> 
> 	for (i = 0; i < msrs->nmsrs; ++i) {
> 		/*
> 	 	 * If userspace is accessing one or more XSTATE-managed MSRs,
> 		 * temporarily load the guest's FPU state so that the guest's
> 		 * MSR value(s) is resident in hardware, i.e. so that KVM can
> 		 * get/set the MSR via RDMSR/WRMSR.
> 	 	 */
Reasonable as well.
> 		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
> 		    is_xstate_managed_msr(entries[i].index)) {
> 			kvm_load_guest_fpu(vcpu);
> 			fpu_loaded = true;
> 		}
> 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
> 			break;
> 	}
> 	if (fpu_loaded)
> 		kvm_put_guest_fpu(vcpu);
> 
> 	return i;
> }
> 

Best regards,
	Maxim Levitsky



