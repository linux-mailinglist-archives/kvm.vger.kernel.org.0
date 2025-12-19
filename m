Return-Path: <kvm+bounces-66292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E16B1CCE44F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 03:30:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 94FF3301EFC0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 02:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73391277C9E;
	Fri, 19 Dec 2025 02:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oEigF6zf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE23C20459A;
	Fri, 19 Dec 2025 02:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766111422; cv=none; b=kZJjPuvh/DQT5QW1iugnFiiBbTVJeD6sb43pzNW28GSrhpHJzMu3qhHCNJV2guMqmGGmN5KTSuk6EmFO4m9dVR6dZU7mCE+Jarqlo3eD1BKEGG1YOr32O6OEz8HqH/XZtxSYNf3xsrBvoNiduy6bg/JEpG/dvzFO5OiV/BFLfPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766111422; c=relaxed/simple;
	bh=xm94Esx+kRHRfSH0LHzzyc9t4VebPhPKDiK8jQ4Wbrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMnsx8tOb/V51zzjK8T84Q9PjsxPX5Fd9P5lI0bR+IrjhAp1xEI0FdxKLA75mhUtNhqBa4K2Sw614IfBY6XWjdfqmXnrjMlSHuwQ9LNy4U6WXew/WFyujBTCn0VIsogYlNAw70iD/UMDjCcxMyH4PvavC5w20FcfqTmUb6bvN5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oEigF6zf; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766111421; x=1797647421;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xm94Esx+kRHRfSH0LHzzyc9t4VebPhPKDiK8jQ4Wbrg=;
  b=oEigF6zfiLtzA4h2x2OLUWUvjZJyGGEINRhptbYzz1ug7uOZQCvo6y3P
   YPfopj+woSjG+rhq7D0bgL6W5MfiQJ7DeNE1iZ+JwYRqIm3l5SZ2RiBDU
   brkyC7nI+1d3MmwYXgM8kvyvCvML8HvO21WOV1JmJsxE3UTrGKUMsXj8p
   WTHubl6sGZ6mVYWzZ/weex4KVtnqtw6nnakFjBSVuwPc3j4n3dGtcEhH6
   qZm70zRKLp4UZA5IAMlyGRyS796cZb1tv9MmXhyG2D+KU+FUjmtV7CpdA
   1Zn84AGsSZZKh8L9oLhcM0raF+BUlvzt1UiVGrc01m365i2YYrpDEBeJL
   Q==;
X-CSE-ConnectionGUID: yAdla1xcTCGmhXTTHQ452Q==
X-CSE-MsgGUID: 3T/8GaBHR6aCh5GcQhqTfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="68047573"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="68047573"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 18:30:20 -0800
X-CSE-ConnectionGUID: Q5cTNuFSRZmTnDClp5p7iQ==
X-CSE-MsgGUID: 1BXdbgLJTIS6pg0VcnESMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="203641828"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 18 Dec 2025 18:30:17 -0800
Date: Fri, 19 Dec 2025 10:14:03 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Kiryl Shutsemau <kas@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Message-ID: <aUS06wE6IvFti8Le@yilunxu-OptiPlex-7050>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-3-seanjc@google.com>
 <aTe4QyE3h8LHOAMb@intel.com>
 <aUJUbcyz2DXmphtU@yilunxu-OptiPlex-7050>
 <aUL-J-MvdCrCtDp4@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUL-J-MvdCrCtDp4@google.com>

On Wed, Dec 17, 2025 at 11:01:59AM -0800, Sean Christopherson wrote:
> On Wed, Dec 17, 2025, Xu Yilun wrote:
> > > >+#define x86_virt_call(fn)				\
> > > >+({							\
> > > >+	int __r;					\
> > > >+							\
> > > >+	if (IS_ENABLED(CONFIG_KVM_INTEL) &&		\
> > > >+	    cpu_feature_enabled(X86_FEATURE_VMX))	\
> > > >+		__r = x86_vmx_##fn();			\
> > > >+	else if (IS_ENABLED(CONFIG_KVM_AMD) &&		\
> > > >+		 cpu_feature_enabled(X86_FEATURE_SVM))	\
> > > >+		__r = x86_svm_##fn();			\
> > > >+	else						\
> > > >+		__r = -EOPNOTSUPP;			\
> > > >+							\
> > > >+	__r;						\
> > > >+})
> > > >+
> > > >+int x86_virt_get_cpu(int feat)
> > > >+{
> > > >+	int r;
> > > >+
> > > >+	if (!x86_virt_feature || x86_virt_feature != feat)
> > > >+		return -EOPNOTSUPP;
> > > >+
> > > >+	if (this_cpu_inc_return(virtualization_nr_users) > 1)
> > > >+		return 0;
> > > 
> > > Should we assert that preemption is disabled? Calling this API when preemption
> > > is enabled is wrong.
> > > 
> > > Maybe use __this_cpu_inc_return(), which already verifies preemption status.
> 
> I always forget that the double-underscores have the checks.  
> 
> > Is it better we explicitly assert the preemption for x86_virt_get_cpu()
> > rather than embed the check in __this_cpu_inc_return()? We are not just
> > protecting the racing for the reference counter. We should ensure the
> > "counter increase + x86_virt_call(get_cpu)" can't be preempted.
> 
> I don't have a strong preference.  Using __this_cpu_inc_return() without any
> nearby preemption_{enable,disable}() calls makes it quite clears that preemption
> is expected to be disabled by the caller.  But I'm also ok being explicit.

Looking into __this_cpu_inc_return(), it finally calls
check_preemption_disabled() which doesn't strictly requires preemption.
It only ensures the context doesn't switch to another CPU. If the caller
is in cpuhp context, preemption is possible.

But in this x86_virt_get_cpu(), we need to ensure preemption disabled,
otherwise caller A increases counter but hasn't do actual VMXON yet and
get preempted. Caller B opts in and get the wrong info that VMX is
already on, and fails on following vmx operations.

On a second thought, maybe we disable preemption inside
x86_virt_get_cpu() to protect the counter-vmxon racing, this is pure
internal thing for this kAPI.

Thanks,
Yilun

