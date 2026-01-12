Return-Path: <kvm+bounces-67836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 176F7D1556A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 21:55:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7971F3053331
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 20:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8DC835581F;
	Mon, 12 Jan 2026 20:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vF8+dA+X"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9F2326D65
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 20:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768251268; cv=none; b=JOpifpB52K4Jnx/tIYVFSJV82gP2LTpl2oQ1LjNJYFWGH3E/QdOLWzhokhSNamHdCi+stlQIuvjMVO+smc8maaqspJ4Ksyh4epua2l/Akutp5v3isRquQGAWd40jO/fh3/2eNdJb9vzowZYFI3U3txP0CQ7jAb8CoORUdjfFyQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768251268; c=relaxed/simple;
	bh=enphMKn741WxytpPsJ+KollcbPbt7rYvowcwokdsYog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=br1pqPcVCkfohqda9hknQCQM6464cwdLEoZGNOIxgR8gZ9aS1hFUFzctfOsfG4p7nPT13BAe9RDO2lJVryuYkG8QJ0TS1Dh6PcZb0ZEMI8OkqRWX0Kci8mWAhvOu+Ph3oBNsjcCdEcXZQiXGkrsh8OC5anwk2XguPsRjHqdMXdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vF8+dA+X; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Jan 2026 20:54:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768251264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jz63S2LyAgpzrZgYUADqkKWEgAw4QSW911fC1uiD7HI=;
	b=vF8+dA+XoihD8yat97X8osxnP38/rSjEj+isbgPDDvBXby/WwygFhA2ii1+rhksmmr/Efi
	Ef64+s3+dgVJi1RLxt52wScjhsWzt9nLmsg6wtreYMv+OaRvK/VCMsiWdqoVXV83vdxACg
	GNLdkB29OJtJnlSdBz+wBG508aTytgY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kevin Cheng <chengkev@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 5/5] KVM: SVM: Raise #UD if VMMCALL instruction is not
 intercepted
Message-ID: <fhulbo7k7nqjv423zqgb5octf2xardhjpjyhu7lqec54fjaaye@wlyr7rci2tnc>
References: <20260112174535.3132800-1-chengkev@google.com>
 <20260112174535.3132800-6-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112174535.3132800-6-chengkev@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 12, 2026 at 05:45:35PM +0000, Kevin Cheng wrote:
> The AMD APM states that if VMMCALL instruction is not intercepted, the
> instruction raises a #UD exception.
> 
> Create a vmmcall exit handler that generates a #UD if a VMMCALL exit
> from L2 is being handled by L0, which means that L1 did not intercept
> the VMMCALL instruction.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kevin Cheng <chengkev@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 92a66b62cfabd..805267a5106ac 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3180,6 +3180,20 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static int vmmcall_interception(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
> +	 * and only if the VMMCALL intercept is not set in vmcb12.
> +	 */
> +	if (is_guest_mode(vcpu)) {
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +		return 1;
> +	}
> +
> +	return kvm_emulate_hypercall(vcpu);
> +}
> +
>  static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_READ_CR0]			= cr_interception,
>  	[SVM_EXIT_READ_CR3]			= cr_interception,
> @@ -3230,7 +3244,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
>  	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
>  	[SVM_EXIT_VMRUN]			= vmrun_interception,
> -	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
> +	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
>  	[SVM_EXIT_VMLOAD]			= vmload_interception,
>  	[SVM_EXIT_VMSAVE]			= vmsave_interception,
>  	[SVM_EXIT_STGI]				= stgi_interception,
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

