Return-Path: <kvm+bounces-23195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15BC094778A
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 10:46:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C188C1F220D2
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 08:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CFE14F10F;
	Mon,  5 Aug 2024 08:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ewhd8knS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3953633CA;
	Mon,  5 Aug 2024 08:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722847603; cv=none; b=GDxqtaQJ7WdJo9SOoj4oEqsGVvWUjNtfPDVIzzr+DTNf0vq1rsZnx2gQTfT/8y0hK2Lujb1R62Q9RAzcqNXsWz0Y85qOCcRsFZholaiiIdzRq4ROfdhYVrE+lL3M+Kciex9+qe+dwYF2v83l+EywBw+fHxXVK9TnJ2HjeMmIvTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722847603; c=relaxed/simple;
	bh=XXh3b2lZABj/jp80lL7QrhLvmjDd1NOLcrEenB+o3ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QyelT3IkR75u2HV0K+Ju8QKCbXQ5QK58rAzEKYFgBWKslylQsr+VWLGG72lkKIOCTMeIbBf4iHO+6XVA+PehWcfqsou3Cc+6JhQZiqwbrEwSUqk9VBGPJGCY2ndVgQQhdQrP+oGJ5satJKq6WB9i0E1rzwGxuVQ7PGl+UgYXS4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ewhd8knS; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722847602; x=1754383602;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XXh3b2lZABj/jp80lL7QrhLvmjDd1NOLcrEenB+o3ac=;
  b=Ewhd8knS58lnsN67HYHsFTa+FyqGKcdKM6PKClFY7KoMBfffBM2BCLio
   1UK74t9LbsVlbIjitM2Ve1IZn2FlpfV1WJL1A9tZacSmJu+3H4U4Y7f4R
   kW3o5KujxP/QCbrs7YuHdMNxCerlNJuRWRlg+t4Lqzq1XJZzHbpz5B/Cu
   feClAYG6t6ZWLHGyh1wH3/gYG+VklVuAYRDNHIHZDY8lW8yPgMdfWUJlq
   fL/5vJWFp3doUb7mUaG5UI6XQAh/V8JJarFdMouC0mAauLvPawYC5F1a0
   dsZ3+CHDyACdtkTrPXB2r+qQxAWrvQUrDIUHysrGqg0VmFhZ9hUCNoena
   A==;
X-CSE-ConnectionGUID: jrh712EeTRSuLfiDIOYR4w==
X-CSE-MsgGUID: TSrkTCQDT/y49znfewh5EQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11154"; a="20971077"
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="20971077"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 01:46:41 -0700
X-CSE-ConnectionGUID: eABzhGYzRjeGdxFQyP/LDA==
X-CSE-MsgGUID: Fl765BGcRAOr3EZ53gjFOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="56302588"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 01:46:40 -0700
Date: Mon, 5 Aug 2024 16:41:45 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: Assert slots_lock is held in
 __kvm_set_memory_region()
Message-ID: <ZrCQSXmbBK5XZqd8@linux.bj.intel.com>
References: <20240802205003.353672-1-seanjc@google.com>
 <20240802205003.353672-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802205003.353672-3-seanjc@google.com>

On Fri, Aug 02, 2024 at 01:49:59PM -0700, Sean Christopherson wrote:
> Add a proper lockdep assertion in __kvm_set_memory_region() instead of
> relying on a function comment.  Opportunistically delete the entire
> function comment as the API doesn't allocate memory or select a gfn,
> and the "mostly for framebuffers" comment hasn't been true for a very long
> time.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0557d663b69b..f202bdbfca9e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1973,14 +1973,6 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
>  	return false;
>  }
>  
> -/*
> - * Allocate some memory and give it an address in the guest physical address
> - * space.
> - *
> - * Discontiguous memory is allowed, mostly for framebuffers.
> - *
> - * Must be called holding kvm->slots_lock for write.
> - */
>  int __kvm_set_memory_region(struct kvm *kvm,
>  			    const struct kvm_userspace_memory_region2 *mem)
>  {
> @@ -1992,6 +1984,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	int as_id, id;
>  	int r;
>  
> +	lockdep_assert_held(&kvm->slots_lock);

How about adding this lockdep assertion in __x86_set_memory_region() to replace
this comment "/* Called with kvm->slots_lock held.  */" as well?

> +
>  	r = check_memory_region_flags(kvm, mem);
>  	if (r)
>  		return r;
> -- 
> 2.46.0.rc2.264.g509ed76dc8-goog
> 
> 

