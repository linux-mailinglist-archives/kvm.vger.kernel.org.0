Return-Path: <kvm+bounces-67966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E0CBD1AA6F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:34:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5CDC330640D1
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959432FDC55;
	Tue, 13 Jan 2026 17:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sfHhpkb4"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F43A1FC110
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768325534; cv=none; b=oawIDsf1DJlfETaenqshOtxl62hJt5xR51vM6rSovHPSjIvqtljSl9AyvsQo6b/SSQAy/2ojRxFVA5pxcL2hKzRaFUpVZXNmLzjUSrXdTMKSeUNqjNIlngiy7+yZCEsSi1E6NYha8m7Y/81de080/KT8eeoeDNNFKpBVSAXNVJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768325534; c=relaxed/simple;
	bh=cuhW5TwWw8zo2DQmzBuRzRNOEJTIrCQnIAQvO+sgBrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJzaJ7coZukVr9XuohZia0TIheXBMIVl4xgkiUaRLYrqpXTWrz2jLsftpcnVMPvBdGjjDD7pX8NN5gtQgts2mSwVXJB6rhc3l3zh6ebzMfoW/qsiwzH2cnQ2Nw5EWgBnsYFKs1hMhGh+R25bszXuumIuZrnSGwq1AxM+1S1tEag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sfHhpkb4; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 13 Jan 2026 17:32:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768325531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dLVvhGnFPzNzF6g8i5kDP+iRLDrGq2EjmswYWybqVIA=;
	b=sfHhpkb4uSjNjw9Lplir5t8LhbQ6+WVeodr4iBdHzJYexhHGM1RsghEj3KwmfhMp1NPX0t
	xpsCsHaCk9YymGBx0ZJs/OX1+vpvMsjizA6w3ADRDnepyl4VJVdlzLabiRZz6QYHRNLTEB
	EJ/OPG+MysvwPLZpAN/AKy0kCBIrHW4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Subject: Re: [Bug 220963] New: nSVM: missing unmap in nested_svm_vmrun()
Message-ID: <yep33jpzldlukryrdrpgyzskr6htscdj7qjfeoa3fmgtcdhygo@h7do4mufeskj>
References: <bug-220963-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-220963-28872@https.bugzilla.kernel.org/>
X-Migadu-Flow: FLOW_OUT

On Sat, Jan 10, 2026 at 07:33:25PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=220963
> 
>             Bug ID: 220963
>            Summary: nSVM: missing unmap in nested_svm_vmrun()
>            Product: Virtualization
>            Version: unspecified
>           Hardware: AMD
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: max@m00nbsd.net
>         Regression: No
> 
> In nested_svm_vmrun():
> 
>     ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
> ...
>     if (WARN_ON_ONCE(!svm->nested.initialized))
>         return -EINVAL;
> 
> A call to kvm_vcpu_unmap() is missing before the return.

I think I accidentally fixed this in
https://lore.kernel.org/kvm/20251215192722.3654335-26-yosry.ahmed@linux.dev/.

It's probably not a big deal, as reaching nested_svm_vmrun() without
svm->nested.initialized means we already have another bug :)

> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.

