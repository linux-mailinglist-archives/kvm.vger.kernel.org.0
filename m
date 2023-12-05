Return-Path: <kvm+bounces-3480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1018804FD2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F276A1C20D9D
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D7D4CDFA;
	Tue,  5 Dec 2023 10:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g3ZHFsKE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A4BA7
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701770844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x148bBHLIWoRdTIuSUDsms3L0/kz5tEEM1BzickcGxY=;
	b=g3ZHFsKECa76kGlDPIPzFPs+zeaX+SM5sKwUZq4PPh9QYrTvzKauR+tBpn2Z9PyasF/ock
	2fUnJ/Kcmk7xO6tE5Hy1AZG/hlgqIznvTxN2U2CIvBIQ1PcibxtKXegg+7LMJn5vCudwLW
	fC63qoP3xerczIIvdJodFOQaCceuH9s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-B3eIdJD8OkagfVtLjmBb6Q-1; Tue, 05 Dec 2023 05:07:22 -0500
X-MC-Unique: B3eIdJD8OkagfVtLjmBb6Q-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40bd5ea7aeaso21358935e9.2
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 02:07:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701770841; x=1702375641;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x148bBHLIWoRdTIuSUDsms3L0/kz5tEEM1BzickcGxY=;
        b=cDjI4JWjR+QdjnIPvEyRLkiEoljirfshlPlZXcVLO9NXzFHM5euVtUIMxa9TQof6nt
         GQIlTZbidVUhibgrhLiW+OdMQSCkXRTvFE0ugZbnmP9O5HZt32ygQgq0OkdPzPMUWCy0
         5Px3VDfnwSxDV1g80TqZL9XmX5/oh9TsVEApVgtBGr9C1tCgO29JYKfEPQkwC8WOhJWU
         wYQkA3bwTUhzsg1mz+lMtIIV/L9mwqmzAHeixdsQGfU0aAzT2Mwc+av/i2ZtRvkzk5pE
         hgvQEQFtZhlfXbDG4TSqsWn0SiC/jjKiKd8Jz3by50Db3Fqt8xMuT4wZS6pf32aboTx2
         B94g==
X-Gm-Message-State: AOJu0YxtIDSn6swg+B1BLrUuOm98eBPQpWB6keuJBk70Qbue/urWuEoo
	4+TKS1jgIQYbGvGCkac9spyvq1o+FpYOt/sT41JmiiBJxdkc0cWUFkR0bVCgQXyM4ElCXWh0rd3
	tXAC84yJFkup+
X-Received: by 2002:a05:600c:46d3:b0:40b:377a:2ac1 with SMTP id q19-20020a05600c46d300b0040b377a2ac1mr3593102wmo.20.1701770841144;
        Tue, 05 Dec 2023 02:07:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0lSfh68UPYOAWd1S8YfHqq7SycLvmqL+oKUOwuh/VYpRm0gR7TN7zf/DTs9+twZs6uWVcXQ==
X-Received: by 2002:a05:600c:46d3:b0:40b:377a:2ac1 with SMTP id q19-20020a05600c46d300b0040b377a2ac1mr3593096wmo.20.1701770840798;
        Tue, 05 Dec 2023 02:07:20 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id n10-20020a05600c4f8a00b004053e9276easm21629722wmq.32.2023.12.05.02.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 02:07:20 -0800 (PST)
Message-ID: <be5cc36e1bb618aab666a2148e5a376b2d39a297.camel@redhat.com>
Subject: Re: [PATCH v7 22/26] KVM: VMX: Set up interception for CET MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, dave.hansen@intel.com
Date: Tue, 05 Dec 2023 12:07:18 +0200
In-Reply-To: <e79d43ea-3ca0-44ca-9a55-b8e2c5094cf2@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-23-weijiang.yang@intel.com>
	 <393d82243b7f44731439717be82b20fbeda45c77.camel@redhat.com>
	 <e79d43ea-3ca0-44ca-9a55-b8e2c5094cf2@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-12-01 at 17:45 +0800, Yang, Weijiang wrote:
> On 12/1/2023 1:44 AM, Maxim Levitsky wrote:
> > On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> > > Enable/disable CET MSRs interception per associated feature configuration.
> > > Shadow Stack feature requires all CET MSRs passed through to guest to make
> > > it supported in user and supervisor mode while IBT feature only depends on
> > > MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
> > > 
> > > Note, this MSR design introduced an architectural limitation of SHSTK and
> > > IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
> > > to guest from architectual perspective since IBT relies on subset of SHSTK
> > > relevant MSRs.
> > > 
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > ---
> > >   arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
> > >   1 file changed, 42 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 554f665e59c3..e484333eddb0 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -699,6 +699,10 @@ static bool is_valid_passthrough_msr(u32 msr)
> > >   	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
> > >   		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> > >   		return true;
> > > +	case MSR_IA32_U_CET:
> > > +	case MSR_IA32_S_CET:
> > > +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> > > +		return true;
> > >   	}
> > >   
> > >   	r = possible_passthrough_msr_slot(msr) != -ENOENT;
> > > @@ -7766,6 +7770,42 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> > >   		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
> > >   }
> > >   
> > > +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> > > +{
> > > +	bool incpt;
> > > +
> > > +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> > > +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> > > +
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
> > > +					  MSR_TYPE_RW, incpt);
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
> > > +					  MSR_TYPE_RW, incpt);
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
> > > +					  MSR_TYPE_RW, incpt);
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
> > > +					  MSR_TYPE_RW, incpt);
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
> > > +					  MSR_TYPE_RW, incpt);
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
> > > +					  MSR_TYPE_RW, incpt);
> > > +		if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
> > > +			vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
> > > +						  MSR_TYPE_RW, incpt);
> > > +		if (!incpt)
> > > +			return;
> > > +	}
> > > +
> > > +	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> > > +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> > > +
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
> > > +					  MSR_TYPE_RW, incpt);
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
> > > +					  MSR_TYPE_RW, incpt);
> > > +	}
> > > +}
> > > +
> > >   static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >   {
> > >   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > @@ -7843,6 +7883,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >   
> > >   	/* Refresh #PF interception to account for MAXPHYADDR changes. */
> > >   	vmx_update_exception_bitmap(vcpu);
> > > +
> > > +	vmx_update_intercept_for_cet_msr(vcpu);
> > >   }
> > >   
> > >   static u64 vmx_get_perf_capabilities(void)
> > My review feedback from the previous patch still applies as well,
> > 
> > I still think that we should either try a best effort approach to plug
> > this virtualization hole, or we at least should fail guest creation
> > if the virtualization hole is present as I said:
> > 
> > "Another, much simpler option is to fail the guest creation if the shadow stack + indirect branch tracking
> > state differs between host and the guest, unless both are disabled in the guest.
> > (in essence don't let the guest be created if (2) or (3) happen)"
> > 
> > Please at least tell me what do you think about this.
> 
> Oh, I thought I had replied this patch in v6 but I failed to send it out!
> Let me explain it a bit, at early stage of this series, I thought of checking relevant host
> feature enabling status before exposing guest CET features, but it's proved
> unnecessary and user unfriendly.
> 
> E.g., we frequently disable host CET features due to whatever reasons on host,  then
> the features cannot be used/tested in guest at all.  Technically, guest should be allowed
> to run the features so long as the dependencies(i.e., xsave related support) are enabled
> on host and there're no risks brought up by using of the features in guest.

To be honest this is a dangerous POV in regard to guest migration: If the VMM were to be lax with features
that it exposes to the guest, then the guests will start to make assumptions instead of checking CPUID
and then the guest will mysteriously fail when migrated to a machine which actually lacks the features,
in addition to not having them in the CPUID.

In other words, leaving "undocumented" features opens a slippery slope of later supporting this
undocumented behavior.

I understand though that CET is problematic, and I overall won't object much to leave things as is
but a part of me thinks that we will regret it later.

Best regards,
	Maxim Levitsky

> 
> I think cloud-computing should share the similar pain point when deploy CET into virtualization
> usages.
> 
> 





