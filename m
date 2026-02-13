Return-Path: <kvm+bounces-71031-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLOCOTtyjmmrCQEAu9opvQ
	(envelope-from <kvm+bounces-71031-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 01:37:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5020E13219A
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 01:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 394A03030B28
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C16B20A5C4;
	Fri, 13 Feb 2026 00:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WfQNKnNe"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64111428F4;
	Fri, 13 Feb 2026 00:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770942993; cv=none; b=YdqxV+CO1TwUzelY8YjA/q1+5dP6uRb0WOgtsttgNSOXalAh2BiJx7mh3s3Kcwuw+rFJLQddjtSMlwirZsxtE3tupdff+EVmN1bye/h6vL+6DCn01hbxOBkHloA7zuTracMccAlwpxq16UHklqAN10vIXhugAGYaW9LJw3ee2eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770942993; c=relaxed/simple;
	bh=yO0zytHOlL7IzwyCTxK7PnBLlVbzzRZC0lMvbt+GO4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F4FYdcOER3iBfUHDSqn7dfgVGygHpL90nkdGftYE4xXe4OSgbQdUJkW0tBVnOjAC5dkrYhoVFCjkJpnPhs+O9jrIGN53trVLv01T+PrFjv3bbafMyfnxKPdnzVZH0vwDtPk8d3hI+rPMvE/RsyZYzJtdAh9wpZH+K7UCfsSTlNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WfQNKnNe; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 13 Feb 2026 00:36:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770942980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OsC42DDml1a2fAwZMLJMiopANdzd7MG2cQ1RRCUDwb4=;
	b=WfQNKnNeQ+D1JsPSGoOGryI/021453zlwxqI0jyOUjQek1lojVruZZlQ3mcemsgSvQ8Iuv
	j5ywURZ902Q9PTWmjd71qkkkaq78QOQ4ImEY//1eoaSn7Pew3EhA/wPYZwtwsYU8gG9l+H
	qCLNdLxDXtPYg1/v/9i9lirbTsbhyA0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 6/8] KVM: x86: nSVM: Save/restore gPAT with
 KVM_{GET,SET}_NESTED_STATE
Message-ID: <bpb7wp5ktdkpo5pohb5ougugd6itwzpmulpqcnnfut552qpbeb@4ww7ytghrsym>
References: <20260212155905.3448571-1-jmattson@google.com>
 <20260212155905.3448571-7-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212155905.3448571-7-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-71031-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,linux.dev:dkim]
X-Rspamd-Queue-Id: 5020E13219A
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 07:58:54AM -0800, Jim Mattson wrote:
> Add a 'flags' field to the SVM nested state header, and use bit 0 of the
> flags to indicate that gPAT is stored in the nested state.
> 
> If in guest mode with NPT enabled, store the current vmcb->save.g_pat value
> into the header of the nested state, and set the flag.
> 
> Note that struct kvm_svm_nested_state_hdr is included in a union padded to
> 120 bytes, so there is room to add the flags field and the gpat field
> without changing any offsets.
> 
> Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/include/uapi/asm/kvm.h |  5 +++++
>  arch/x86/kvm/svm/nested.c       | 16 ++++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 846a63215ce1..664d04d1db3f 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -495,6 +495,8 @@ struct kvm_sync_regs {
>  
>  #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
>  
> +#define KVM_STATE_SVM_VALID_GPAT	0x00000001
> +
>  /* vendor-independent attributes for system fd (group 0) */
>  #define KVM_X86_GRP_SYSTEM		0
>  #  define KVM_X86_XCOMP_GUEST_SUPP	0
> @@ -531,6 +533,9 @@ struct kvm_svm_nested_state_data {
>  
>  struct kvm_svm_nested_state_hdr {
>  	__u64 vmcb_pa;
> +	__u32 flags;
> +	__u32 reserved;
> +	__u64 gpat;
>  };
>  
>  /* for KVM_CAP_NESTED_STATE */
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 26f758e294ab..f73f3e586012 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1893,6 +1893,10 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
>  	/* First fill in the header and copy it out.  */
>  	if (is_guest_mode(vcpu)) {
>  		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
> +		if (nested_npt_enabled(svm)) {
> +			kvm_state.hdr.svm.flags |= KVM_STATE_SVM_VALID_GPAT;
> +			kvm_state.hdr.svm.gpat = svm->nested.save.g_pat;
> +		}
>  		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
>  		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
>  
> @@ -2022,6 +2026,14 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	    !nested_vmcb_check_save(vcpu, &save_cached, false))
>  		goto out_free;
>  
> +	/*
> +	 * Validate gPAT, if provided. This is done separately from the
> +	 * vmcb_save_area_cached validation above, because gPAT is L2
> +	 * state, but the vmcb_save_area_cached is populated with L1 state.
> +	 */
> +	if ((kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) &&
> +	    !kvm_pat_valid(kvm_state->hdr.svm.gpat))
> +		goto out_free;
>  
>  	/*
>  	 * All checks done, we can enter guest mode. Userspace provides
> @@ -2061,6 +2073,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (ret)
>  		goto out_free;
>  
> +	if (nested_npt_enabled(svm) &&
> +	    (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
> +		svm_set_gpat(svm, kvm_state->hdr.svm.gpat);
> +
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
>  	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
>  
> -- 
> 2.53.0.239.g8d8fc8a987-goog
> 

