Return-Path: <kvm+bounces-67965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 95196D1AA08
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 529E1303270E
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D6F36AB5F;
	Tue, 13 Jan 2026 17:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cd04vKDA"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F66311C05
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768325379; cv=none; b=A/pkdpsJp+hL0qQ4qsMwGE87dhaHQMsU98Zk1ORoZDrpP0o4JeKxQLXfFuTRF8c5kRF/WVIZFIvhRql+PYOnEsAUE+GWvGw7oij8A+Wzy8zgN+mVjGkWT32Q+1nDw4o4RIEoiHiZGFy7RV4M82+DBviS9RtvjKQDFn/ob/2ELA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768325379; c=relaxed/simple;
	bh=fycXvirXCWbkxuyHxkpKy5ngYjiLC0BDjh5hVjOUKQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghh7b2Ah70cb+81fq2ZDO/ANw6yrXTopoBYieNllesqH4/hWyLZ9YDePwUNWxhx3u6NZxgSNjPfEcP6QKnTucacahfmj4tpxRm6erEME/ARI/Nzfn1LXj4J4ed4SgoRMtsr9J/Qp0Fnhx0IMmEljNu4ATcf1CYNLM7gzIprOrK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cd04vKDA; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 13 Jan 2026 17:29:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768325376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2jwwQG5YFWWSUeSge6tKjEy3T+iVQKMsPx4wWN4I0E=;
	b=Cd04vKDAjWAOZiybE5qf9wgVr+dfJlWuqJAzg+GBjIfCKWplZc5plwLCmGNgnxPWorLBa8
	50rWXxy2EWzgj5xSBNE7ckEd88DGEaFCktqjAhNCahj4kH+zuuCodDs0RLnc/mDcpWIw7S
	1NqdcTeu6JTnDVBeSzISsDZTENZQQbE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nSVM: Drop redundant/wrong comment in
 nested_vmcb02_prepare_save()
Message-ID: <csyb3r77vfuzns7r4xfge7smxyw7vumdpjkntxctzkwu3cixib@dlo7kt7vgmcq>
References: <20260113172807.2178526-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113172807.2178526-1-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 13, 2026 at 05:28:07PM +0000, Yosry Ahmed wrote:
> The comment above DR6 and DR7 initializations is redundant, because the
> entire function follows the same pattern of only initializing the fields
> in vmcb02 if the vmcb12 changed or the fields are dirty, which handles
> the first execution case.
> 
> Also, the comment refers to new_vmcb12 as new_vmcs12. Just drop the
> comment.
> 
> No functional change intended.
> 
> Change-Id: Ib924765541fe3d8753b84b7ead8b47d8a24f0c8d

Lesson learned: no patch is too simple to run checkpatch.pl

> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f295a41ec659..cb00829896cc 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -699,7 +699,6 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  	vmcb02->save.rsp = vmcb12->save.rsp;
>  	vmcb02->save.rip = vmcb12->save.rip;
>  
> -	/* These bits will be set properly on the first execution when new_vmc12 is true */
>  	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
>  		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
>  		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
> 
> base-commit: f62b64b970570c92fe22503b0cdc65be7ce7fc7c
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

