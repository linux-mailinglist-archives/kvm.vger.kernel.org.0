Return-Path: <kvm+bounces-3015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 237AC7FFB6E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9152B210EC
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6443A52F84;
	Thu, 30 Nov 2023 19:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cbmSuyw5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D32D1
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701372883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qytGX0MGJcOz7q/36mRvU0A100gsEwbWnP5WfFvyCcQ=;
	b=cbmSuyw5DV33gLMdwcXoiRaAjHcQ3wbKwvdI/1CoyLUgTeu9WBtmiPHBxYWNpZEwTkPLnT
	JJjAkFRncAIPeU+FxdBcXToDaI7HrAuADbp619SVXBurFvpA4HZH81yqp9QTDA8yS3Z8Nt
	HYpWK5A2qmrqoWm7LQqmlpv0mV5fqCM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-rOSotnwuN_mRAYZm025Vgg-1; Thu, 30 Nov 2023 14:34:42 -0500
X-MC-Unique: rOSotnwuN_mRAYZm025Vgg-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2c9c3782740so15291411fa.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:34:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701372881; x=1701977681;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qytGX0MGJcOz7q/36mRvU0A100gsEwbWnP5WfFvyCcQ=;
        b=brqcoBqgE/McXNDn0QfAlpt+9eZKdSCImRWMVnJ8x85jmv3mUWYGFxlksrUthVrSGq
         IepkDLaDbKuBBtWq4cUVgqmSYqbt2lcE+oLCWLlXOuUDcmosfOwsp4QUuwdlPFA3nOWc
         HuGFdpkW86cYfKQjZCSZrmkvdofdoAO3ICY75navtoPGea6JhgGjn5hJYBT+v6tXjnKd
         PFeKBA3aWLBFoTZcLSqM6Wq37RGIQmn1o94xbaOQI4irkGOICPOI2oGSCMwMQHFC5o8p
         jHK//MKGYJh/xs2+FHjmCbSsW0Z//AD2Df1/sJKxKG0awbuYECMxB+RaxjnfqTAjk3T2
         FhVg==
X-Gm-Message-State: AOJu0YyW0SrFjTQa/ehk9dFmVGtWm2phAUNjrGGKMnIAZMqNsrDyaqcN
	m7P3GsB008fIKO4ndvuxr1X8sGmgkDCWzbm9T/deB+wu7BRgBUU5iOZ8EXPs8m8eQPu5Kxx0xpq
	OfCUMiK8XwGVbxCdbRlpb
X-Received: by 2002:a2e:aa8b:0:b0:2c9:c662:715 with SMTP id bj11-20020a2eaa8b000000b002c9c6620715mr26255ljb.4.1701372880875;
        Thu, 30 Nov 2023 11:34:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPJcbCU4cufSDQv6f8QUMe1TA4X/6xNTeMQtfmLGplAXuJX2mk3hU8RkAtP5spjMsfxa0lKg==
X-Received: by 2002:a17:906:2086:b0:a11:d323:c1bc with SMTP id 6-20020a170906208600b00a11d323c1bcmr57445ejq.19.1701366166815;
        Thu, 30 Nov 2023 09:42:46 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id d27-20020ac25edb000000b0050933bb416csm214417lfq.74.2023.11.30.09.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:42:46 -0800 (PST)
Message-ID: <d2be8a787969b76f71194ce65bd6f35426b60dcc.camel@redhat.com>
Subject: Re: [PATCH v7 21/26] KVM: x86: Save and reload SSP to/from SMRAM
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:42:44 +0200
In-Reply-To: <20231124055330.138870-22-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-22-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
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
> index 45c855389ea7..7aac9c54c353 100644
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
> @@ -564,6 +568,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
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


My review feedback from the previous patch series still applies, and I don't
know why it was not addressed/replied to:

I still think that it is worth it to have a check that CET is not enabled in
enter_smm_save_state_32 which is called for pure 32 bit guests (guests that don't
have X86_FEATURE_LM enabled)

Best regards,
	Maxim Levitsky



