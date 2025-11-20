Return-Path: <kvm+bounces-64000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 12578C76A01
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 20C6C29EB1
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A92A0221739;
	Thu, 20 Nov 2025 23:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PYAOvzc1"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60C836D51C
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681600; cv=none; b=S2guhmGgcHsNhhayCQ+0jjeceOHL8WCGj8XkcWZ0uVV9lpNIEHfsuDxjc9IST8jJkQLU9x6f7+nEQhDPxG38kJvQ10v2o9x7CVR5R+OBYhThnrcSsXUbRJxr39WCUSR4gMvnQgauH5DDxu57pYpmclnHIU5bkR+nMBO66Ob66e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681600; c=relaxed/simple;
	bh=RAPTcNsb23hxZ7t8bfr68Bf+rgKFXx8H3tX2jK3cEyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L49ToFhvp/64WQv0a4CkieNKvHnNikSTLEUDK8pmAslp9ZdZnDST/CUDo8FpYGwQvL3oUgguxXt6vAXqXSszHVt6vqcETmjHq2NI7Bdk3FydRdNQNkHwZkPW0kLdDeSO5eRp+cxo3YLgo9D3og+2dVhZTnzS1SaUz9NwKUQouSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PYAOvzc1; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 20 Nov 2025 23:32:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763681582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TJTqeKWqLQa65Gs8lub8DO0oSaBCWOp2hdHEl8lT9d4=;
	b=PYAOvzc1Mwaf76n8KQv54zxssYN807roiZABHhpTmClUThxiNl7L0xGUtA3uQNAGKm7E9O
	wjuJls6YfERS9Di9OzdmVNLXCfi4yJsIlgtY71p9L1w48lxvvU1ZJLDK+Rp3ko5Cs1Bdfm
	2EZiP+Zg12emcYLJAnqJmlasJ9tf7Qc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
Message-ID: <6r4wdlkfpnmrox2cndrg4t7ixrpqivgsehfdbvirh3skkuikwr@lauuwibj5bd2>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <aR-i6zFLGV_4VwsZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR-i6zFLGV_4VwsZ@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 20, 2025 at 03:23:23PM -0800, Sean Christopherson wrote:
> On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> > There are multiple selftests exercising nested VMX that are not specific
> > to VMX (at least not anymore). Extend their coverage to nested SVM.
> > 
> > This version is significantly different (and longer) than v1 [1], mainly
> > due to the change of direction to reuse __virt_pg_map() for nested EPT/NPT
> > mappings instead of extending the existing nested EPT infrastructure. It
> > also has a lot more fixups and cleanups.
> > 
> > This series depends on two other series:
> > - "KVM: SVM: GIF and EFER.SVME are independent" [2]
> > - "KVM: selftests: Add test of SET_NESTED_STATE with 48-bit L2 on 57-bit L1" [3]
> 
> No, it depends on local commits that are very similar to [3], but not precisely
> [3].

Hmm I just applied that series with b4 without local changes, on top of
kvm-x86/next at that time, which was kvm-x86-next-2025.09.30.

Maybe you had v2 or it was the patches that landed between
kvm-x86-next-2025.09.30 and the current tip of kvm-x86/next?

> In the future, please provide a link to a git repo+branch when posting
> series with dependencies.  It took me several attempts and a bit of conflict
> resolution to get this series applied.

Yeah I can do that, although I think it wouldn't have helped in this
case as the same conflicts would apply. Perhaps mentioning that this is
based on kvm-x86-next-2025.09.30 would have helped?

> 
> > [1]https://lore.kernel.org/kvm/20251001145816.1414855-1-yosry.ahmed@linux.dev/
> > [2]https://lore.kernel.org/kvm/20251009223153.3344555-1-jmattson@google.com/
> > [3]https://lore.kernel.org/kvm/20250917215031.2567566-1-jmattson@google.com/

