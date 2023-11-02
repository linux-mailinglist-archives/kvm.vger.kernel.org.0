Return-Path: <kvm+bounces-450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B0617DFA13
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C391281D99
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329211DA39;
	Thu,  2 Nov 2023 18:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQ1WMGB1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD51179BF
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:38:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6730128
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698950299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gcxyLn+j42pQ4O/S+kERc6I/oidQhojoanYwpge7F0M=;
	b=EQ1WMGB1YOwVgGItqHt1x0ehiKTudIGLn1ZYbmPukiSolgrshqxD5Kiyt5T50r3SgdGsIE
	Zlx99QX+pvV/49kwGeqgYI1wA4+741Lyx9mP9YUgIZCAkhqMGhi7pN5orrfi5NAJSa2c1q
	Of8GAtHkZU2qorcLOiNdqJjthK/fqCM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-gYopT5CVPAyMK19ZQ9OIyw-1; Thu, 02 Nov 2023 14:38:17 -0400
X-MC-Unique: gYopT5CVPAyMK19ZQ9OIyw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2c6ed315cc3so13757481fa.2
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698950295; x=1699555095;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gcxyLn+j42pQ4O/S+kERc6I/oidQhojoanYwpge7F0M=;
        b=F+iXQ6YLd+IgYJXb4qHKBSLQvv6fQd3ZdT/ivM+58tNSTLlhu1itKqZepJ1D2pzOdQ
         gL+GCsNvGHlCAqDlO7c0MMevwOKYVKReBIuUj55HkNEDhEhevNGKBOrllXWnYu6iDcnH
         Q50PO79H9G1N9I0dBX5TvOFVjdUwToQUNnLHEhnwH7Y12txluggW/gV57EYxH1lFUN9f
         ddvb8eikAs97g54bA58jaTSdVwHxKwaw2/51w0/tk67QEDn5hE2Vi+LugJ5OFJyHy4bG
         Lj3hlRp+7FfWkDC1+Y2W+HYuxYGfjldTSR/Hw8Ejtqe5ZXHzHhkBknJ9dzpx7A5zMTB/
         6dGw==
X-Gm-Message-State: AOJu0YyKS9wxw3FOV4wbR6d2SxDaJkC6cAcPPM2dHlx89Ip8XoKjJPUo
	WZgs3s29zHLUz/oByVb6rjqc0vlsNweg+V60IeLJXt+ktuASc/JDN7viyTq+1YvR38gRczii306
	jRjbfbJ7dnVmoB7MDpaAS
X-Received: by 2002:a2e:9246:0:b0:2c5:724:fd64 with SMTP id v6-20020a2e9246000000b002c50724fd64mr14938880ljg.46.1698950295633;
        Thu, 02 Nov 2023 11:38:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETpjEQuLp/YLIGLU/uCXNKi9ikEizahd/fHeez4QkxXxrfARhFToG4SyaI8Sn9obRou8ayDw==
X-Received: by 2002:a2e:9246:0:b0:2c5:724:fd64 with SMTP id v6-20020a2e9246000000b002c50724fd64mr14938863ljg.46.1698950295255;
        Thu, 02 Nov 2023 11:38:15 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id p22-20020a05600c1d9600b004060f0a0fd5sm328240wms.13.2023.11.02.11.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:38:14 -0700 (PDT)
Message-ID: <ff6b7e9d90d80feb9dcabb0fbd3808c04db3ff94.camel@redhat.com>
Subject: Re: [PATCH v6 19/25] KVM: VMX: Emulate read and write to CET MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com, 
	peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 02 Nov 2023 20:38:12 +0200
In-Reply-To: <ZUJ9fDuQUNe9BLUA@google.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-20-weijiang.yang@intel.com>
	 <d67fe0ca19f7aef855aa376ada0fc96a66ca0d4f.camel@redhat.com>
	 <ZUJ9fDuQUNe9BLUA@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-01 at 09:31 -0700, Sean Christopherson wrote:
> On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> > On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > > Add emulation interface for CET MSR access. The emulation code is split
> > > into common part and vendor specific part. The former does common check
> > > for MSRs and reads/writes directly from/to XSAVE-managed MSRs via the
> > > helpers while the latter accesses the MSRs linked to VMCS fields.
> > > 
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > ---
> 
> ...
> 
> > > +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > > +	case MSR_KVM_SSP:
> > > +		if (host_msr_reset && kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> > > +			break;
> > > +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> > > +			return 1;
> > > +		if (index == MSR_KVM_SSP && !host_initiated)
> > > +			return 1;
> > > +		if (is_noncanonical_address(data, vcpu))
> > > +			return 1;
> > > +		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
> > > +			return 1;
> > > +		break;
> > Once again I'll prefer to have an ioctl for setting/getting SSP, this will
> > make the above code simpler (e.g there will be no need to check that write
> > comes from the host/etc).
> 
> I don't think an ioctl() would be simpler overall, especially when factoring in
> userspace.  With a synthetic MSR, we get the following quite cheaply:
> 
>  1. Enumerating support to userspace.
>  2. Save/restore of the value, e.g. for live migration.
>  3. Vendor hooks for propagating values to/from the VMCS/VMCB.
> 
> For an ioctl(), 
> #1 would require a capability, #2 (and #1 to some extent) would
> require new userspace flows, and #3 would require new kvm_x86_ops hooks.
> 
> The synthetic MSR adds a small amount of messiness, as does bundling 
> MSR_IA32_INT_SSP_TAB with the other shadow stack MSRs.  The bulk of the mess comes
> from the need to allow userspace to write '0' when KVM enumerated supported to
> userspace.


Let me put it this way - all hacks start like that, and in this case this is API/ABI hack
so we will have to live with it forever.

Once there is a precedent, trust me there will be 10s of new 'fake' msrs added, and the
interface will become one big mess.

As I suggested, if you don't want to add new capability/ioctl and vendor callback per new
x86 arch register, then let's implement KVM_GET_ONE_REG/KVM_SET_ONE_REG and then it will
be really easy to add new regs without confusing users, and without polluting msr
namespace with msrs that don't exist.


Best regards,
	Maxim Levitsky


> 
> If we isolate MSR_IA32_INT_SSP_TAB, that'll help with the synthetic MSR and with
> MSR_IA32_INT_SSP_TAB.  For the unfortunate "host reset" behavior, the best idea I
> came up with is to add a helper.  It's still a bit ugly, but the ugliness is
> contained in a helper and IMO makes it much easier to follow the case statements.
> 
> get:
> 
> 	case MSR_IA32_INT_SSP_TAB:
> 		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) ||
> 		    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
> 			return 1;
> 		break;
> 	case MSR_KVM_SSP:
> 		if (!host_initiated)
> 			return 1;
> 		fallthrough;
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> 		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> 			return 1;
> 		break;
> 
> static bool is_set_cet_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u64 data,
> 				   bool host_initiated)
> {
> 	bool any_cet = index == MSR_IA32_S_CET || index == MSR_IA32_U_CET;
> 
> 	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
> 		return true;
> 
> 	if (any_cet && guest_can_use(vcpu, X86_FEATURE_IBT))
> 		return true;
> 
> 	/* 
> 	 * If KVM supports the MSR, i.e. has enumerated the MSR existence to
> 	 * userspace, then userspace is allowed to write '0' irrespective of
> 	 * whether or not the MSR is exposed to the guest.
> 	 */
> 	if (!host_initiated || data)
> 		return false;
> 
> 	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> 		return true;
> 
> 	return any_cet && kvm_cpu_cap_has(X86_FEATURE_IBT);
> }
> 
> set:
> 	case MSR_IA32_U_CET:
> 	case MSR_IA32_S_CET:
> 		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
> 			return 1;
> 		if (data & CET_US_RESERVED_BITS)
> 			return 1;
> 		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> 		    (data & CET_US_SHSTK_MASK_BITS))
> 			return 1;
> 		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
> 		    (data & CET_US_IBT_MASK_BITS))
> 			return 1;
> 		if (!IS_ALIGNED(CET_US_LEGACY_BITMAP_BASE(data), 4))
> 			return 1;
> 
> 		/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDBR. */
> 		if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
> 			return 1;
> 		break;
> 	case MSR_IA32_INT_SSP_TAB:
> 		if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
> 			return 1;
> 
> 		if (is_noncanonical_address(data, vcpu))
> 			return 1;
> 		break;
> 	case MSR_KVM_SSP:
> 		if (!host_initiated)
> 			return 1;
> 		fallthrough;
> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> 		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
> 			return 1;
> 		if (is_noncanonical_address(data, vcpu))
> 			return 1;
> 		if (!IS_ALIGNED(data, 4))
> 			return 1;
> 		break;
> 	}
> 



