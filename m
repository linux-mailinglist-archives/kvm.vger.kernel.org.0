Return-Path: <kvm+bounces-2565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E3C7FB267
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD789B20E6F
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE8E12B95;
	Tue, 28 Nov 2023 07:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QhmFDNpk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA93D45
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701155704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIjdl3fBpy+pRgJdQZh+6AD6ZC1o3LqUiZRk3i0+Pa8=;
	b=QhmFDNpkgEbvCwpdtJB8eRJObprETWdO/oo0wtrL35ljHd/p1D3V3k8z2lhEr3tcFcwb4m
	/uJCGvYRSypLHhdD1j/oZ85W9o3AH9l0zLa19pDda0SKsmj5PPxXTEdvP3HQhc0G/EA+9s
	SsjsNs+JGYV9W3GwjFfw2P5UVfZxcvY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-5vQo_JpYMfWcphNPIfV8_Q-1; Tue, 28 Nov 2023 02:15:02 -0500
X-MC-Unique: 5vQo_JpYMfWcphNPIfV8_Q-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-332e06036b5so3807502f8f.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:15:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701155701; x=1701760501;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oIjdl3fBpy+pRgJdQZh+6AD6ZC1o3LqUiZRk3i0+Pa8=;
        b=jkHUxdzw4B2Zvgc1mrL5vRrGaqQLgoJsFAkfg0jpJS+tddedqi+j7jjA9ul2EXUZ1v
         T9nQSZ7l9jQ81f6xvQgPzNtvWIyNhjc+/AupoC/A0OfN03i1MNkXVnCWJ30igk2tiwp9
         uoLa0uiyS5PqzLNrki0LhFbAtMrEjOiodun0CBL0JEC/zfWSxpOcS0TRkfZ2q8pKyEaQ
         UVOVgAD0bkTu7s2Bgo87iO6G7+Z7vBJ4dvu6WQd19olcgmVpvxQZ1wW/bTcSZs3WzUNd
         GdsSZZB44vDbhef2STn8Ljr6/6esTnEJRQFeeYeGLMrvOyBW1ISgTJOgz/sptgYwPT6o
         y/qQ==
X-Gm-Message-State: AOJu0YxQF9XUMNTW6KRWMgYYT3ZPV/HSaCMENN/pRFkTE+EKDdcuHmL9
	yKWJrWflWtqpCyDE9o/5qgGr9znS9NwUont78Fwmq6n/85q4zxlSnOmgzn8bY1n/8exyb6zfpXj
	zVd7Vw6E8GcMpHm1mnvl7
X-Received: by 2002:adf:e692:0:b0:332:c3bf:600e with SMTP id r18-20020adfe692000000b00332c3bf600emr9680299wrm.18.1701155701309;
        Mon, 27 Nov 2023 23:15:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoLLZhOPGZQ2GYNhYzCXI+p+ecrix8FYQehMBzvTC9gRSDCBtPwIXCuYoXkKX15OSjTOoD9g==
X-Received: by 2002:adf:e692:0:b0:332:c3bf:600e with SMTP id r18-20020adfe692000000b00332c3bf600emr9680278wrm.18.1701155700918;
        Mon, 27 Nov 2023 23:15:00 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id d4-20020a05600c3ac400b0040b3e79bad3sm10993732wms.40.2023.11.27.23.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 23:15:00 -0800 (PST)
Message-ID: <9249b4b84f7b84da2ea21fbbbabf35f22e5d9f2f.camel@redhat.com>
Subject: Re: [RFC 06/33] KVM: x86: hyper-v: Introduce VTL awareness to
 Hyper-V's PV-IPIs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 anelkz@amazon.com,  graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com,
 corbert@lwn.net,  kys@microsoft.com, haiyangz@microsoft.com,
 decui@microsoft.com, x86@kernel.org,  linux-doc@vger.kernel.org
Date: Tue, 28 Nov 2023 09:14:58 +0200
In-Reply-To: <20231108111806.92604-7-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-7-nsaenz@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-08 at 11:17 +0000, Nicolas Saenz Julienne wrote:
> HVCALL_SEND_IPI and HVCALL_SEND_IPI_EX allow targeting specific a
> specific VTL. Honour the requests.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---
>  arch/x86/kvm/hyperv.c             | 24 +++++++++++++++++-------
>  arch/x86/kvm/trace.h              | 20 ++++++++++++--------
>  include/asm-generic/hyperv-tlfs.h |  6 ++++--
>  3 files changed, 33 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index d4b1b53ea63d..2cf430f6ddd8 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2230,7 +2230,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  }
>  
>  static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
> -				    u64 *sparse_banks, u64 valid_bank_mask)
> +				    u64 *sparse_banks, u64 valid_bank_mask, int vtl)
>  {
>  	struct kvm_lapic_irq irq = {
>  		.delivery_mode = APIC_DM_FIXED,
> @@ -2245,6 +2245,9 @@ static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
>  					    valid_bank_mask, sparse_banks))
>  			continue;
>  
> +		if (kvm_hv_get_active_vtl(vcpu) != vtl)
> +			continue;

Do I understand correctly that this is a temporary limitation?
In other words, can a vCPU running in VTL1 send an IPI to a vCPU running VTL0,
forcing the target vCPU to do async switch to VTL1?
I think that this is possible.


If we go with my suggestion to use apic namespaces and/or with multiple VMs per VTLs,
then I imagine it like that:

In-kernel hyperv IPI emulation works as it does currently as long as the IPI's VTL matches the VTL
which is assigned to the vCPU, and if it doesn't, it should result in a userspace VM exit.

I do think that we will need KVM to know a vCPU VTL anyway, however we might get away
(or have to if we go with multiple VMs approach) with having explicit mapping between
all KVM's vCPUs which emulate a single VM's vCPU.

Best regards,
	Maxim Levitsky


> +
>  		/* We fail only when APIC is disabled */
>  		kvm_apic_set_irq(vcpu, &irq, NULL);
>  	}
> @@ -2257,13 +2260,19 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	struct kvm *kvm = vcpu->kvm;
>  	struct hv_send_ipi_ex send_ipi_ex;
>  	struct hv_send_ipi send_ipi;
> +	union hv_input_vtl *in_vtl;
>  	u64 valid_bank_mask;
>  	u32 vector;
>  	bool all_cpus;
> +	u8 vtl;
> +
> +	/* VTL is at the same offset on both IPI types */
> +	in_vtl = &send_ipi.in_vtl;
> +	vtl = in_vtl->use_target_vtl ? in_vtl->target_vtl : kvm_hv_get_active_vtl(vcpu);
>  
>  	if (hc->code == HVCALL_SEND_IPI) {
>  		if (!hc->fast) {
> -			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
> +			if (unlikely(kvm_vcpu_read_guest(vcpu, hc->ingpa, &send_ipi,
>  						    sizeof(send_ipi))))
>  				return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			sparse_banks[0] = send_ipi.cpu_mask;
> @@ -2278,10 +2287,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		all_cpus = false;
>  		valid_bank_mask = BIT_ULL(0);
>  
> -		trace_kvm_hv_send_ipi(vector, sparse_banks[0]);
> +		trace_kvm_hv_send_ipi(vector, sparse_banks[0], vtl);
>  	} else {
>  		if (!hc->fast) {
> -			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi_ex,
> +			if (unlikely(kvm_vcpu_read_guest(vcpu, hc->ingpa, &send_ipi_ex,
>  						    sizeof(send_ipi_ex))))
>  				return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  		} else {
> @@ -2292,7 +2301,8 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  
>  		trace_kvm_hv_send_ipi_ex(send_ipi_ex.vector,
>  					 send_ipi_ex.vp_set.format,
> -					 send_ipi_ex.vp_set.valid_bank_mask);
> +					 send_ipi_ex.vp_set.valid_bank_mask,
> +					 vtl);
>  
>  		vector = send_ipi_ex.vector;
>  		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
> @@ -2322,9 +2332,9 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
>  	if (all_cpus)
> -		kvm_hv_send_ipi_to_many(kvm, vector, NULL, 0);
> +		kvm_hv_send_ipi_to_many(kvm, vector, NULL, 0, vtl);
>  	else
> -		kvm_hv_send_ipi_to_many(kvm, vector, sparse_banks, valid_bank_mask);
> +		kvm_hv_send_ipi_to_many(kvm, vector, sparse_banks, valid_bank_mask, vtl);
>  
>  ret_success:
>  	return HV_STATUS_SUCCESS;
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 83843379813e..ab8839c47bc7 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1606,42 +1606,46 @@ TRACE_EVENT(kvm_hv_flush_tlb_ex,
>   * Tracepoints for kvm_hv_send_ipi.
>   */
>  TRACE_EVENT(kvm_hv_send_ipi,
> -	TP_PROTO(u32 vector, u64 processor_mask),
> -	TP_ARGS(vector, processor_mask),
> +	TP_PROTO(u32 vector, u64 processor_mask, u8 vtl),
> +	TP_ARGS(vector, processor_mask, vtl),
>  
>  	TP_STRUCT__entry(
>  		__field(u32, vector)
>  		__field(u64, processor_mask)
> +		__field(u8, vtl)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->vector = vector;
>  		__entry->processor_mask = processor_mask;
> +		__entry->vtl = vtl;
>  	),
>  
> -	TP_printk("vector %x processor_mask 0x%llx",
> -		  __entry->vector, __entry->processor_mask)
> +	TP_printk("vector %x processor_mask 0x%llx vtl %d",
> +		  __entry->vector, __entry->processor_mask, __entry->vtl)
>  );
>  
>  TRACE_EVENT(kvm_hv_send_ipi_ex,
> -	TP_PROTO(u32 vector, u64 format, u64 valid_bank_mask),
> -	TP_ARGS(vector, format, valid_bank_mask),
> +	TP_PROTO(u32 vector, u64 format, u64 valid_bank_mask, u8 vtl),
> +	TP_ARGS(vector, format, valid_bank_mask, vtl),
>  
>  	TP_STRUCT__entry(
>  		__field(u32, vector)
>  		__field(u64, format)
>  		__field(u64, valid_bank_mask)
> +		__field(u8, vtl)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->vector = vector;
>  		__entry->format = format;
>  		__entry->valid_bank_mask = valid_bank_mask;
> +		__entry->vtl = vtl;
>  	),
>  
> -	TP_printk("vector %x format %llx valid_bank_mask 0x%llx",
> +	TP_printk("vector %x format %llx valid_bank_mask 0x%llx vtl %d",
>  		  __entry->vector, __entry->format,
> -		  __entry->valid_bank_mask)
> +		  __entry->valid_bank_mask, __entry->vtl)
>  );
>  
>  TRACE_EVENT(kvm_pv_tlb_flush,
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index 0e7643c1ef01..40d7dc793c03 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -424,14 +424,16 @@ struct hv_vpset {
>  /* HvCallSendSyntheticClusterIpi hypercall */
>  struct hv_send_ipi {
>  	u32 vector;
> -	u32 reserved;
> +	union hv_input_vtl in_vtl;
> +	u8 reserved[3];
>  	u64 cpu_mask;
>  } __packed;
>  
>  /* HvCallSendSyntheticClusterIpiEx hypercall */
>  struct hv_send_ipi_ex {
>  	u32 vector;
> -	u32 reserved;
> +	union hv_input_vtl in_vtl;
> +	u8 reserved[3];
>  	struct hv_vpset vp_set;
>  } __packed;
>  






