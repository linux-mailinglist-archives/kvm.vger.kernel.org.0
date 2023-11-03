Return-Path: <kvm+bounces-533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33BAF7E0B0A
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 23:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80478B21521
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 22:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6B2249EA;
	Fri,  3 Nov 2023 22:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IQwxyHfC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB53B2376B
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 22:26:48 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E8AD61
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 15:26:46 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc23f2226bso20039025ad.2
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 15:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699050406; x=1699655206; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5qz3lxpTjwV7uKrVt1pa7AdPIpFhmvNL57r88OWBGAs=;
        b=IQwxyHfCAuD/AEJWllqin+xq06mvClt7YSuq/rtrDGScuqZ/cRhZf/YNCrTxSxp/Cd
         VRNhPgV/zK4OCWwX4WXXorxDGZ7g/wt+ggwKbEdUn+4VRXSnc7i+3BtRk20pmUzFKGQC
         rvx4jcb3bJkmq/zfWner9cNaB0au79HMXmDDmDkpiQBTfs1eGElp6TqTdYpxET0nw/2c
         pN+LrmSGPjK1BPXKhvrm4wMdxK7l/rqhk2GxTOVA3Dkv4gsbAcFoi0jOvuuaUXx2CcXf
         6QkZklFSyA1OIRXbBU1EVCqqBY4D7kT1LMlKt3XOhe+HHQGTYxJYFnPmFEXaJhDOH6TL
         a+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699050406; x=1699655206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5qz3lxpTjwV7uKrVt1pa7AdPIpFhmvNL57r88OWBGAs=;
        b=psM5533vrswm3OiGtl/K1NGe/ak99lY2wlKx7da+maynCNCHNoTUYmnfJERWA2bc3k
         rJ0Gooc2CsiXyz7klFTsTxrN6MCNIcN5mujzudQXnMYEIOMfI3yf2NNkLIqQehIJ0DbY
         TogDPDllruM9nqV8jzJzBNw96qsQYuTqRMocRbe/TVwrsuopNZKoTRewD3JOa5GoQUdd
         d6bDOzac0qU8Xrea8xZCZ1YGZV7E/ZgZEsayMiRPqtVDFeHjTI+Ggk5Pq7ymIcKRpLJl
         NgFHndb4rSdXNRUm4fMEKzQb6N4Dbv4xeGgr471dBclkhAo9jt/3mJebxU+q9TLVPsbT
         ZuKw==
X-Gm-Message-State: AOJu0YxgQjjHYNXZSJ9MDjh2NMyJHcDsvXAA34XLBH3Gk4II3qVyTWO6
	U8Ue+sIbSifhujkGTcI7JOVaWBE8src=
X-Google-Smtp-Source: AGHT+IFeq7cdSJcWPrN+bNFUJYmnJmsZZZr44kVjASAIEmkPN7hPLrgXLlkfdFkrHpJgynav7YkKwmOhOvs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7293:b0:1ca:8e79:53b7 with SMTP id
 d19-20020a170902729300b001ca8e7953b7mr386188pll.9.1699050405789; Fri, 03 Nov
 2023 15:26:45 -0700 (PDT)
Date: Fri, 3 Nov 2023 15:26:44 -0700
In-Reply-To: <d1166177-c0ab-a8a5-94a6-e4e7ebdeb1c0@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-20-weijiang.yang@intel.com> <d67fe0ca19f7aef855aa376ada0fc96a66ca0d4f.camel@redhat.com>
 <ZUJ9fDuQUNe9BLUA@google.com> <d1166177-c0ab-a8a5-94a6-e4e7ebdeb1c0@intel.com>
Message-ID: <ZUVzpM465isag2bj@google.com>
Subject: Re: [PATCH v6 19/25] KVM: VMX: Emulate read and write to CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Weijiang Yang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 03, 2023, Weijiang Yang wrote:
> On 11/2/2023 12:31 AM, Sean Christopherson wrote:
> > On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > > On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > > > Add emulation interface for CET MSR access. The emulation code is split
> > > > into common part and vendor specific part. The former does common check
> > > > for MSRs and reads/writes directly from/to XSAVE-managed MSRs via the
> > > > helpers while the latter accesses the MSRs linked to VMCS fields.
> > > > 
> > > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > > ---
> > ...
> > 
> > > > +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > > > +	case MSR_KVM_SSP:
> > > > +		if (host_msr_reset && kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> > > > +			break;
> > > > +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> > > > +			return 1;
> > > > +		if (index == MSR_KVM_SSP && !host_initiated)
> > > > +			return 1;
> > > > +		if (is_noncanonical_address(data, vcpu))
> > > > +			return 1;
> > > > +		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
> > > > +			return 1;
> > > > +		break;
> > > Once again I'll prefer to have an ioctl for setting/getting SSP, this will
> > > make the above code simpler (e.g there will be no need to check that write
> > > comes from the host/etc).
> > I don't think an ioctl() would be simpler overall, especially when factoring in
> > userspace.  With a synthetic MSR, we get the following quite cheaply:
> > 
> >   1. Enumerating support to userspace.
> >   2. Save/restore of the value, e.g. for live migration.
> >   3. Vendor hooks for propagating values to/from the VMCS/VMCB.
> > 
> > For an ioctl(), #1 would require a capability, #2 (and #1 to some extent) would
> > require new userspace flows, and #3 would require new kvm_x86_ops hooks.
> > 
> > The synthetic MSR adds a small amount of messiness, as does bundling
> > MSR_IA32_INT_SSP_TAB with the other shadow stack MSRs.  The bulk of the mess comes
> > from the need to allow userspace to write '0' when KVM enumerated supported to
> > userspace.
> > 
> > If we isolate MSR_IA32_INT_SSP_TAB, that'll help with the synthetic MSR and with
> > MSR_IA32_INT_SSP_TAB.  For the unfortunate "host reset" behavior, the best idea I
> > came up with is to add a helper.  It's still a bit ugly, but the ugliness is
> > contained in a helper and IMO makes it much easier to follow the case statements.
> 
> Frankly speaking, existing code is not hard to understand to me :-), the
> handling for MSR_KVM_SSP and MSR_IA32_INT_SSP_TAB is straightforward if
> audiences read the related spec.

I don't necessarily disagree, but I 100% agree with Maxim that host_msr_reset is
a confusing name.  As Maxim pointed out, '0' isn't necessarily the RESET value.
And host_msr_reset implies that userspace is emulating a RESET, which may not
actually be true, e.g. a naive userspace could be restoring '0' as part of live
migration.

> But I'll take your advice and enclose below changes. Thanks!

Definitely feel free to propose an alternative.  My goal with the suggested change
is eliminate host_msr_reset without creating creating unwieldy case statements.
Isolating MSR_IA32_INT_SSP_TAB was (obviously) the best solution I came up with.

> > get:
> > 
> > 	case MSR_IA32_INT_SSP_TAB:
> > 		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) ||
> > 		    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
> > 			return 1;
> > 		break;
> > 	case MSR_KVM_SSP:
> > 		if (!host_initiated)
> > 			return 1;
> > 		fallthrough;
> > 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > 		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> > 			return 1;
> > 		break;
> > 
> > static bool is_set_cet_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u64 data,
> > 				   bool host_initiated)
> > {
> > 	bool any_cet = index == MSR_IA32_S_CET || index == MSR_IA32_U_CET;
> > 
> > 	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
> > 		return true;
> > 
> > 	if (any_cet && guest_can_use(vcpu, X86_FEATURE_IBT))
> > 		return true;
> > 
> > 	/*
> > 	 * If KVM supports the MSR, i.e. has enumerated the MSR existence to
> > 	 * userspace, then userspace is allowed to write '0' irrespective of
> > 	 * whether or not the MSR is exposed to the guest.
> > 	 */
> > 	if (!host_initiated || data)
> > 		return false;
> > 	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> > 		return true;
> > 
> > 	return any_cet && kvm_cpu_cap_has(X86_FEATURE_IBT);
> > }
> > 
> > set:
> > 	case MSR_IA32_U_CET:
> > 	case MSR_IA32_S_CET:
> > 		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
> > 			return 1;
> > 		if (data & CET_US_RESERVED_BITS)
> > 			return 1;
> > 		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> > 		    (data & CET_US_SHSTK_MASK_BITS))
> > 			return 1;
> > 		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
> > 		    (data & CET_US_IBT_MASK_BITS))
> > 			return 1;
> > 		if (!IS_ALIGNED(CET_US_LEGACY_BITMAP_BASE(data), 4))
> > 			return 1;
> > 
> > 		/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDBR. */
> > 		if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
> > 			return 1;
> > 		break;
> > 	case MSR_IA32_INT_SSP_TAB:
> > 		if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
> > 			return 1;

Doh, I think this should be:

		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated) ||
		    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
			return 1;
> > 
> > 		if (is_noncanonical_address(data, vcpu))
> > 			return 1;
> > 		break;
> > 	case MSR_KVM_SSP:
> > 		if (!host_initiated)
> > 			return 1;
> > 		fallthrough;
> > 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > 		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
> > 			return 1;
> > 		if (is_noncanonical_address(data, vcpu))
> > 			return 1;
> > 		if (!IS_ALIGNED(data, 4))
> > 			return 1;
> > 		break;
> > 	}
> 

