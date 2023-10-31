Return-Path: <kvm+bounces-234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC307DD5A1
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:56:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBBBB1C20CAA
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7355822301;
	Tue, 31 Oct 2023 17:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hdbiYU/q"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E3921354
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:56:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2955DF
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bzTCGiE36+QIYH5NJV9gBg/lfoaBooocnmbn0Tc7c6I=;
	b=hdbiYU/qErbS8QsFaJI6AImXlKKmpCh0hk955CYp0SIn6EwDwlZVTAPM0mmv+YYRQVCGuM
	1GdZfkRtWINCbjONS4Ptsh8t+hHz6D2WTLzs5t737/x6MiROdBy6sHFUJPVPYC1BppMG1R
	Yl73yNanGZSO5zfAE/MWLF2E7Z3n4hA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-sxHDF_BPMJmNI92-wQSf8Q-1; Tue, 31 Oct 2023 13:55:59 -0400
X-MC-Unique: sxHDF_BPMJmNI92-wQSf8Q-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4094158c899so17559865e9.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:55:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774958; x=1699379758;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bzTCGiE36+QIYH5NJV9gBg/lfoaBooocnmbn0Tc7c6I=;
        b=OPaIRxaWn3eJ4c4fanBUPkKGPfXs4fqx246wUTPKoCI9VxPa1pAERGdtvQ1LJ8DCJm
         Pjntjfb1Xyc3tuo937845s4aWhh9AY1BDWClgjvxta5rPGl1/0dAhlPfKGI3YD2lTp6V
         jsfXlDfE41k12IOO7j3aiuKRP2QImYvATDDoVSC9xLkwOWiAdwEVXzsR1yRBJxLwQhv1
         VOBk1z9Oowh2YWIoSFR8YDiJuQmBvKTS/lR/TuqlDq2pYfjOuEfoPRMNOXMuriH6lEsG
         UB+B+9P3eV4xAg94uqGDwTd9ML7f8e97yMHovbPWOQB9h/sQ7zhIPCEr4L9K/oOOE91v
         M/Ig==
X-Gm-Message-State: AOJu0YyTuqVqGjjUTUMSPQosYYfTCoUb4ma0ocA06i/Cg5aA6pfe4KyF
	wm3iYuHMUr/limcmScruNWPyR34lR3R3/tuBEL3J4RhEXQx/045Vcs2IOH3nbGZzl22S8toWZL4
	xMBMbeowzh+wR
X-Received: by 2002:a05:600c:470e:b0:409:19a0:d247 with SMTP id v14-20020a05600c470e00b0040919a0d247mr11666993wmo.18.1698774958360;
        Tue, 31 Oct 2023 10:55:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEp1WzDeNxaBgIlpKTkzCkcRCuqvCI19VrLT39GGHUC2rUCfZW1Mm76+OIEXt8GPx4rbH/UDw==
X-Received: by 2002:a05:600c:470e:b0:409:19a0:d247 with SMTP id v14-20020a05600c470e00b0040919a0d247mr11666966wmo.18.1698774957905;
        Tue, 31 Oct 2023 10:55:57 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id h19-20020a05600c30d300b003fefaf299b6sm2269842wmn.38.2023.10.31.10.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:55:57 -0700 (PDT)
Message-ID: <f654c9339f1c7d63093107410d2f81f5e4340d18.camel@redhat.com>
Subject: Re: [PATCH v6 20/25] KVM: x86: Save and reload SSP to/from SMRAM
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:55:55 +0200
In-Reply-To: <20230914063325.85503-21-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-21-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
> behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
> at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
> one of such registers on 64bit Arch, so add the support for SSP.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/smm.c | 8 ++++++++
>  arch/x86/kvm/smm.h | 2 +-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index b42111a24cc2..235fca95f103 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>  	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>  
>  	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
> +
> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_SSP, &smram->ssp),
> +			   vcpu->kvm);
>  }
>  #endif
>  
> @@ -565,6 +569,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>  	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
>  	ctxt->interruptibility = (u8)smstate->int_shadow;
>  
> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +		KVM_BUG_ON(kvm_msr_write(vcpu, MSR_KVM_SSP, smstate->ssp),
> +			   vcpu->kvm);
> +
>  	return X86EMUL_CONTINUE;
>  }
>  #endif
> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> index a1cf2ac5bd78..1e2a3e18207f 100644
> --- a/arch/x86/kvm/smm.h
> +++ b/arch/x86/kvm/smm.h
> @@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
>  	u32 smbase;
>  	u32 reserved4[5];
>  
> -	/* ssp and svm_* fields below are not implemented by KVM */
>  	u64 ssp;
> +	/* svm_* fields below are not implemented by KVM */
>  	u64 svm_guest_pat;
>  	u64 svm_host_efer;
>  	u64 svm_host_cr4;


Just one note: Due to historical reasons, KVM supports 2 formats of the SMM save area: 32 and 64 bit.
32 bit format more or less resembles the format that true 32 bit Intel and AMD CPUs used, 
while 64 bit format more or less resembles the format that 64 bit AMD cpus use (Intel uses a very different SMRAM layout)

32 bit format is used when X86_FEATURE_LM is not exposed to the guest CPUID which is very rare (only 32 bit qemu doesn't set it),
and it lacks several fields because it is no longer maintained.

Still, for the sake of completeness, it might make sense to fail enter_smm_save_state_32 (need to add return value and, do 'goto error' in
the main 'enter_smm' in this case, if CET is enabled.

I did a similar thing in SVM code 'svm_enter_smm' when it detects the lack of the X86_FEATURE_LM.

Best regards,
	Maxim Levitsky





