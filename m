Return-Path: <kvm+bounces-293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB547DDECB
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 10:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D86EAB20F9E
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 09:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9C6D514;
	Wed,  1 Nov 2023 09:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fqEtZMG+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1287480
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 09:54:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB86BE4
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 02:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698832486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tmky+d0S1/rhhTo9Yque25pyb/Pto+oWnWO53iebzz0=;
	b=fqEtZMG+601kYdcwRjKNLqnXP0fQp16rL6C0+RsCj8XyLNC5009/BFCsW1I6D/cfD5j1Cg
	g/U+XhaGK/IdU5Dx8UfhWPsG5+yVtfmemLZIyGxqMjCPwJQDaZG7YSvGynFVovUHHerfA+
	QSuoYgzm1suHIyWdXtMWfCfxmkZQLi8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-AIWEYUn5MUaI2Jfq4cNHNQ-1; Wed, 01 Nov 2023 05:54:45 -0400
X-MC-Unique: AIWEYUn5MUaI2Jfq4cNHNQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32d879cac50so3344020f8f.0
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 02:54:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698832484; x=1699437284;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tmky+d0S1/rhhTo9Yque25pyb/Pto+oWnWO53iebzz0=;
        b=H1TyOqRHrlFe15vOXOTCKj9GJVR+lOqprc4ceLoj1l7djH0SAQa6c5B4Sr8pBhn/Ii
         QlZ4N/8QDCxNDBhvTzqVMp7Bt1izAcf8fjY9DImbVmWYhqyw/d6frBMAx7im4uXeUgdJ
         mmGGCgWEfIYZBU+Uqy9mgx6KeiBIkSGODJsKubC9A/8wPEkfYTqJau1X/gcrzixe0Wqn
         X0BPOb80sE1s3f70esYf3+Iliz5HzDKjOcgOfWkxVKIRc9bRs6SGmmzPuK5cdTvkGz9t
         +2HA3x81gy3PnNp0YIeGOmi49lcTQKYB6TR7BAs2ogCXCbv0kq9fyvXdEhynGJ4DvgWU
         jKJg==
X-Gm-Message-State: AOJu0Yzuq5U91Fk0BQStszpzDM0lQoh26OobgpH69/ExjydF23r9FKyv
	9r6eeehheN5VOrYCw5yIIyum5IRL1M1DAVvNKeR6WrvQgxPAndnfgsLmOQu+LYOc9CQ/P6hfVP1
	9EmlykYilglmx
X-Received: by 2002:a5d:6c68:0:b0:32f:79e5:8119 with SMTP id r8-20020a5d6c68000000b0032f79e58119mr13085835wrz.1.1698832484301;
        Wed, 01 Nov 2023 02:54:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHidRT7yjwrbc9aMRfX7SAI1gpH9368tdbJJqdy+Je3huWDhjvSXSj0GTN2o0I01zEjQU3M6g==
X-Received: by 2002:a5d:6c68:0:b0:32f:79e5:8119 with SMTP id r8-20020a5d6c68000000b0032f79e58119mr13085817wrz.1.1698832483933;
        Wed, 01 Nov 2023 02:54:43 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id t4-20020adff044000000b0032dbf99bf4fsm3684189wro.89.2023.11.01.02.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 02:54:43 -0700 (PDT)
Message-ID: <e29c2c8c18f989b83ea2d696ae93590fe5c0ff53.camel@redhat.com>
Subject: Re: [PATCH v6 25/25] KVM: nVMX: Enable CET support for nested guest
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Chao Gao <chao.gao@intel.com>, Yang Weijiang <weijiang.yang@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Wed, 01 Nov 2023 11:54:41 +0200
In-Reply-To: <ZUGzZiF0Jn8GVcr+@chao-email>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-26-weijiang.yang@intel.com>
	 <ZUGzZiF0Jn8GVcr+@chao-email>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-01 at 10:09 +0800, Chao Gao wrote:
> On Thu, Sep 14, 2023 at 02:33:25AM -0400, Yang Weijiang wrote:
> > Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
> > to enable CET for nested VM.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> > arch/x86/kvm/vmx/nested.c | 27 +++++++++++++++++++++++++--
> > arch/x86/kvm/vmx/vmcs12.c |  6 ++++++
> > arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++++++-
> > arch/x86/kvm/vmx/vmx.c    |  2 ++
> > 4 files changed, 46 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 78a3be394d00..2c4ff13fddb0 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -660,6 +660,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> > 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> > 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
> > 
> > +	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
> > +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> > +					 MSR_IA32_U_CET, MSR_TYPE_RW);
> > +
> > +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> > +					 MSR_IA32_S_CET, MSR_TYPE_RW);
> > +
> > +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> > +					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
> > +
> > +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> > +					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
> > +
> > +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> > +					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
> > +
> > +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> > +					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
> > +
> > +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> > +					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
> > +
> > 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
> > 
> > 	vmx->nested.force_msr_bitmap_recalc = false;
> > @@ -6794,7 +6816,7 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
> > 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
> > #endif
> > 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
> > -		VM_EXIT_CLEAR_BNDCFGS;
> > +		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
> > 	msrs->exit_ctls_high |=
> > 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
> > 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
> > @@ -6816,7 +6838,8 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
> > #ifdef CONFIG_X86_64
> > 		VM_ENTRY_IA32E_MODE |
> > #endif
> > -		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
> > +		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
> > +		VM_ENTRY_LOAD_CET_STATE;
> > 	msrs->entry_ctls_high |=
> > 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
> > 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
> > diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> > index 106a72c923ca..4233b5ca9461 100644
> > --- a/arch/x86/kvm/vmx/vmcs12.c
> > +++ b/arch/x86/kvm/vmx/vmcs12.c
> > @@ -139,6 +139,9 @@ const unsigned short vmcs12_field_offsets[] = {
> > 	FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exceptions),
> > 	FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp),
> > 	FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip),
> > +	FIELD(GUEST_S_CET, guest_s_cet),
> > +	FIELD(GUEST_SSP, guest_ssp),
> > +	FIELD(GUEST_INTR_SSP_TABLE, guest_ssp_tbl),
> 
> I think we need to sync guest states, e.g., guest_s_cet/guest_ssp/guest_ssp_tbl,
> between vmcs02 and vmcs12 on nested VM entry/exit, probably in
> sync_vmcs02_to_vmcs12() and prepare_vmcs12() or "_rare" variants of them.
> 

Aha, this is why I suspected that nested support is incomplete, 
100% agree.

In particular, looking at Intel's SDM I see that:

HOST_S_CET, HOST_SSP, HOST_INTR_SSP_TABLE needs to be copied from vmcb12 to vmcb02 but not vise versa
because the CPU doesn't touch them.

GUEST_S_CET, GUEST_SSP, GUEST_INTR_SSP_TABLE should be copied bi-directionally.

This of course depends on the corresponding vm entry and vm exit controls being set.
That means that it is legal in theory to do VM entry/exit with CET enabled but not use 
VM_ENTRY_LOAD_CET_STATE and/or VM_EXIT_LOAD_CET_STATE,
because for example nested hypervisor in theory can opt to save/load these itself.

I think that this is all, but I also can't be 100% sure. This thing has to be tested well before
we can be sure that it works.

Best regards,
	Maxim Levitsky


