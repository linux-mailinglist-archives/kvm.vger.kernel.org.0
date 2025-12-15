Return-Path: <kvm+bounces-66001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A1CCBF731
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DDBD23012273
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C88B30BF67;
	Mon, 15 Dec 2025 18:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LygnQKlX"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8526020DD48
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 18:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765823940; cv=none; b=ang7qomdhvOsv+wmIcICueW8yJeZcqHLf3piBfYAmSC/r4YXu2rZRey4i6rI7tgN9oXeXWit6C0liXvQ0xMFV6+BdnYyd6JH5yUNWnLYlWtFjeTQAdMs4LYHC7kgBnKoQoWOEUx603hWZTlQipZM+X5Lns1FB/fnhlLQDvVS8KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765823940; c=relaxed/simple;
	bh=s0SWtJ5ngiOWpkWjLbRhySsDdgyVxSEghYVCgJ2p0Go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mJwD4uJu8e802TH5zzqogoxR+ks1kxt+greAUxVrgVoN6j6TIEs691No7laN+IimxYmP2txjdhh4eNkuNPfVxGGY6XY04UF7vu5W0G3clWoDCxjLNW+1chSGbYtYhzrgPzszZ0DCNYZHaEbXRfxUWO5wyYnPS0B+BNNSjOuT0qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LygnQKlX; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 15 Dec 2025 18:38:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765823936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GXSxiYoQtWBh4BkZcER2iRIW2SY/gLDdzoqwz2ipYiY=;
	b=LygnQKlXVUBykazeRo1lXTPGkK9esVHZsz3vtakO+ii3o/8bCwBntnhVsdHekFTg1BX5oM
	k9Qd5YFZvBveohvAc0pZunDa7C3dK/JSHJqWNb+VhVuWm5f/T6DZaXUk4mSd2i8Q2X+G8O
	gtlSudmE/M7JTaDyDSMJMWyqzz/FvWk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/16] KVM: selftests: Stop passing VMX metadata to
 TDP mapping functions
Message-ID: <5mubxlnxqtsn3oewixpvl4snjxhzbacuxbnqznxt3iei5wjbvx@466awypcjc3k>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <20251127013440.3324671-10-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127013440.3324671-10-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 27, 2025 at 01:34:33AM +0000, Yosry Ahmed wrote:
> @@ -87,11 +86,11 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
>  
>  	vm_enable_ept(vm);
>  	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> -		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
> +		vcpu_alloc_vmx(vm, &vmx_gva);
>  
>  		/* The EPTs are shared across vCPUs, setup the mappings once */
>  		if (vcpu_id == 0)
> -			memstress_setup_ept_mappings(vmx, vm);
> +			memstress_setup_ept_mappings(vm);

I think at this point we can actually move
memstress_setup_ept_mappings() before the loop similar to
vm_enable_ept().

I can send a patch on top or a new version, let me know if you prefer
that I do either, or fix it up while applying.

