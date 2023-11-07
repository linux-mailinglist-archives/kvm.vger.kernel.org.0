Return-Path: <kvm+bounces-1044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D90AE7E4821
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:21:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97122280FFB
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204B1358B0;
	Tue,  7 Nov 2023 18:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Is1/D5kU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F8C358A5
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:21:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A90125
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699381283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+GcT82eNb/SFzSP35zWzQQO+F/hul/YMHV+lLW3et8=;
	b=Is1/D5kUnkhrpjV9fQlqSvuyScmKX9Y6VSnynRCNv983zdmaBeqYxz6hdxkp0iDKRVt7nz
	trfdiY7i2EYplQjutc04MVm1forjtD3nfGHx/llyCkbE0unu9z1xTeV/CAL2/or990W/zO
	UGF7wkNj4mX2DSVt6hik2eOXwvphCp4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-f4-RFPatMTC-zFzgiUGkrQ-1; Tue, 07 Nov 2023 13:21:21 -0500
X-MC-Unique: f4-RFPatMTC-zFzgiUGkrQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40855a91314so39744215e9.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:21:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699381280; x=1699986080;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U+GcT82eNb/SFzSP35zWzQQO+F/hul/YMHV+lLW3et8=;
        b=Iwa+k0GHuXbH0p450kVtR5nA8YuiTaHlBofDxdkeQoQRhcn2Q70pNpSyQUgdSVajTG
         6dxHcI3iW5M8eBxhwEZLU5+4DINn2vN1KSdDKkm3vgB9J3pUG1Gf9G1+Pfy+xZGE4CcM
         35w5mt3sHcQcHJ+efwU7elJuQO2GNE+XPkVmKuneMmHlitAq+sGlK+dYe/8lQazlDVbD
         MDvizvEsZ6FTk7KMsZGC3l9eWDY9ou6KTg60KTxV1z3JXduCZ2XxFhcWKWMqsPpiuJiG
         9x3sSS3Oe6Wp6w3MBn1NGqpCyitEQ2tUYqmoTi1ruW1uBMlx9W6c0n13X9BKwttqJc26
         mLMQ==
X-Gm-Message-State: AOJu0YxCHH0bCC3xYqrWzU9UhfruTkjVn45Cl2+rflZ7BqjVBSlsyn7Q
	FUxeZ6cWSPEENp+dDL4L1EwP640uqnOA+/zy89Dlk4QrPCd/YEEtQhjFE3ptzvWL43HW1oGpmnX
	msHFTjaXl/0XX
X-Received: by 2002:a05:600c:3d9a:b0:407:5de2:ea4d with SMTP id bi26-20020a05600c3d9a00b004075de2ea4dmr4385268wmb.13.1699381280076;
        Tue, 07 Nov 2023 10:21:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgebMStnVPX77gZSwX8QEuIQGBlqWLIcaSuttikvXYt02mLAiVSykG1hMPfysRMfSBsxMJnw==
X-Received: by 2002:a05:600c:3d9a:b0:407:5de2:ea4d with SMTP id bi26-20020a05600c3d9a00b004075de2ea4dmr4385247wmb.13.1699381279673;
        Tue, 07 Nov 2023 10:21:19 -0800 (PST)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id i12-20020a05600c354c00b004042dbb8925sm16551465wmq.38.2023.11.07.10.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:21:19 -0800 (PST)
Message-ID: <cefa30d9728704a0f5c50cb61412978d60cac3d6.camel@redhat.com>
Subject: Re: [PATCH 02/14] KVM: x86: hyper-v: Move Hyper-V partition assist
 page out of Hyper-V emulation context
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Nov 2023 20:21:17 +0200
In-Reply-To: <20231025152406.1879274-3-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
	 <20231025152406.1879274-3-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-10-25 at 17:23 +0200, Vitaly Kuznetsov wrote:
> Hyper-V partition assist page is used when KVM runs on top of Hyper-V and
> is not used for Windows/Hyper-V guests on KVM, this means that 'hv_pa_pg'
> placement in 'struct kvm_hv' is unfortunate. As a preparation to making
> Hyper-V emulation optional, move 'hv_pa_pg' to 'struct kvm_arch' and put it
> under CONFIG_HYPERV.
> 
> While on it, introduce hv_get_partition_assist_page() helper to allocate
> partition assist page. Move the comment explaining why we use a single page
> for all vCPUs from VMX and expand it a bit.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/kvm_onhyperv.h     | 20 ++++++++++++++++++++
>  arch/x86/kvm/svm/svm_onhyperv.c | 10 +++-------
>  arch/x86/kvm/vmx/vmx.c          | 14 +++-----------
>  arch/x86/kvm/x86.c              |  4 +++-
>  5 files changed, 30 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d107516b4591..7fb2810f4573 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1125,7 +1125,6 @@ struct kvm_hv {
>  	 */
>  	unsigned int synic_auto_eoi_used;
>  
> -	struct hv_partition_assist_pg *hv_pa_pg;
>  	struct kvm_hv_syndbg hv_syndbg;
>  };
>  
> @@ -1447,6 +1446,7 @@ struct kvm_arch {
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	hpa_t	hv_root_tdp;
>  	spinlock_t hv_root_tdp_lock;
> +	struct hv_partition_assist_pg *hv_pa_pg;
>  #endif
>  	/*
>  	 * VM-scope maximum vCPU ID. Used to determine the size of structures
> diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
> index f9ca3e7432b2..eefab3dc8498 100644
> --- a/arch/x86/kvm/kvm_onhyperv.h
> +++ b/arch/x86/kvm/kvm_onhyperv.h
> @@ -10,6 +10,26 @@
>  int hv_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, gfn_t nr_pages);
>  int hv_flush_remote_tlbs(struct kvm *kvm);
>  void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
> +static inline hpa_t hv_get_partition_assist_page(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Partition assist page is something which Hyper-V running in L0
> +	 * requires from KVM running in L1 before direct TLB flush for L2
> +	 * guests can be enabled. KVM doesn't currently use the page but to
> +	 * comply with TLFS it still needs to be allocated. For now, this
> +	 * is a single page shared among all vCPUs.
Perfect!

> +	 */
> +	struct hv_partition_assist_pg **p_hv_pa_pg =
> +		&vcpu->kvm->arch.hv_pa_pg;
> +
> +	if (!*p_hv_pa_pg)
> +		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
> +
> +	if (!*p_hv_pa_pg)
> +		return INVALID_PAGE;
> +
> +	return __pa(*p_hv_pa_pg);
> +}
>  #else /* !CONFIG_HYPERV */
>  static inline int hv_flush_remote_tlbs(struct kvm *kvm)
>  {
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
> index 7af8422d3382..3971b3ea5d04 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.c
> +++ b/arch/x86/kvm/svm/svm_onhyperv.c
> @@ -18,18 +18,14 @@
>  int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  {
>  	struct hv_vmcb_enlightenments *hve;
> -	struct hv_partition_assist_pg **p_hv_pa_pg =
> -			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
> +	hpa_t partition_assist_page = hv_get_partition_assist_page(vcpu);
>  
> -	if (!*p_hv_pa_pg)
> -		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
> -
> -	if (!*p_hv_pa_pg)
> +	if (partition_assist_page == INVALID_PAGE)
>  		return -ENOMEM;
>  
>  	hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
>  
> -	hve->partition_assist_page = __pa(*p_hv_pa_pg);
> +	hve->partition_assist_page = partition_assist_page;
>  	hve->hv_vm_id = (unsigned long)vcpu->kvm;
>  	if (!hve->hv_enlightenments_control.nested_flush_hypercall) {
>  		hve->hv_enlightenments_control.nested_flush_hypercall = 1;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index be20a60047b1..cb4591405f14 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -523,22 +523,14 @@ module_param(enlightened_vmcs, bool, 0444);
>  static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  {
>  	struct hv_enlightened_vmcs *evmcs;
> -	struct hv_partition_assist_pg **p_hv_pa_pg =
> -			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
> -	/*
> -	 * Synthetic VM-Exit is not enabled in current code and so All
> -	 * evmcs in singe VM shares same assist page.
> -	 */
> -	if (!*p_hv_pa_pg)
> -		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
> +	hpa_t partition_assist_page = hv_get_partition_assist_page(vcpu);
>  
> -	if (!*p_hv_pa_pg)
> +	if (partition_assist_page == INVALID_PAGE)
>  		return -ENOMEM;
>  
>  	evmcs = (struct hv_enlightened_vmcs *)to_vmx(vcpu)->loaded_vmcs->vmcs;
>  
> -	evmcs->partition_assist_page =
> -		__pa(*p_hv_pa_pg);
> +	evmcs->partition_assist_page = partition_assist_page;
>  	evmcs->hv_vm_id = (unsigned long)vcpu->kvm;
>  	evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d632931fa545..cc2524598368 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12425,7 +12425,9 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  
>  void kvm_arch_free_vm(struct kvm *kvm)
>  {
> -	kfree(to_kvm_hv(kvm)->hv_pa_pg);
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	kfree(kvm->arch.hv_pa_pg);
> +#endif
>  	__kvm_arch_free_vm(kvm);
>  }
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



