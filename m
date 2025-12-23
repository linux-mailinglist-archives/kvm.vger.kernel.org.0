Return-Path: <kvm+bounces-66638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AAF2CDADCC
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:48:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CCF56304A29F
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C7F2F1FC3;
	Tue, 23 Dec 2025 23:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WJ2ExA1m"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013C11A2C0B
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766533723; cv=none; b=eZt9zlZgdvYpYtgpMtXk2QyaDm7g3N5DIsiE1Vhef/qrinoxq+qXTU3gshS3UqagxT9rS5UYKQ7ObmHZyu4wZ9Irg53m1Mrv9+Y1xthrw9IVOQcURE3+FdYqCV1+sxzqY6JK5mT+AU3bKrFXcrKuBRRYl7RbvrKf3nEqUZ8oNSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766533723; c=relaxed/simple;
	bh=bhpZsNmDLgq+AzoKSmdW1PaYd3OEAVGTNJ2wO3s82qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKs+OhS/MxowRZDvS/7QxeNnQ1yKA6DtH4Il6aUtdV+4bx8oJpL9oUlZ2fsldD3HyBVwx+APZubMZSoCrpsc9ZEAULQDfmnLIZz/AAAFQ9Visy6j4SAdRGoSNIWG2U+Lg0rujXNnqvlVsaIRjQJdIzxAk/vRsfvkhrJSWzCsZyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WJ2ExA1m; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 23 Dec 2025 23:48:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766533720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7S2AHVbxRBo2XmEiH6YRfMT02PCl4ry2HOPoPqRgmjQ=;
	b=WJ2ExA1mZ002aSjEtF8DOnNnud1axEsKMX2OB1n4Y7T5F7SfMB2+BHYtLDV4NaSu5j8rQC
	CnKuV7fOs152zKqqDZ7dNfpQSlNSU2wx2lZ0C5kvLKovFqEbcqzCQpSsyoXAo5VFYTWHeW
	yzboai7rQ+gp1l9/OdsBhHl3dMhHHRI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/16] Add Nested NPT support in selftests
Message-ID: <bqq5iht35entb5oayouofi4o3v3adfjyi62dsjl6k7wdwkaaw4@ui4v7hymrn7w>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <aUsRQMYwmYOUCXvp@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUsRQMYwmYOUCXvp@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 23, 2025 at 02:01:36PM -0800, Sean Christopherson wrote:
> On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> > Yosry Ahmed (16):
> >   KVM: selftests: Make __vm_get_page_table_entry() static
> >   KVM: selftests: Stop passing a memslot to nested_map_memslot()
> >   KVM: selftests: Rename nested TDP mapping functions
> >   KVM: selftests: Kill eptPageTablePointer
> >   KVM: selftests: Stop setting AD bits on nested EPTs on creation
> >   KVM: selftests: Introduce struct kvm_mmu
> >   KVM: selftests: Move PTE bitmasks to kvm_mmu
> >   KVM: selftests: Use a nested MMU to share nested EPTs between vCPUs
> >   KVM: selftests: Stop passing VMX metadata to TDP mapping functions
> >   KVM: selftests: Reuse virt mapping functions for nested EPTs
> >   KVM: selftests: Move TDP mapping functions outside of vmx.c
> >   KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
> >   KVM: selftests: Add support for nested NPTs
> >   KVM: selftests: Set the user bit on nested NPT PTEs
> >   KVM: selftests: Extend vmx_dirty_log_test to cover SVM
> >   KVM: selftests: Extend memstress to run on nested SVM
> 
> Lot's of feedback incoming, but no need for you to doing anything unless you
> disagree with something.  I have all the "requested" changes in a local branch,
> and will post v4 (probably next week).

Thanks a lot for taking care of this. No disagreements, just a couple of
comments/questions in the replies.

