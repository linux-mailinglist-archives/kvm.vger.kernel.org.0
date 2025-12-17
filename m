Return-Path: <kvm+bounces-66108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0954DCC6584
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 08:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6942A303D304
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 07:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E8A8335BCF;
	Wed, 17 Dec 2025 07:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bczq6gqT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE0E32825E;
	Wed, 17 Dec 2025 07:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765955643; cv=none; b=sovXKFTL9qE83eb1nnXkk8cXhr83mcil2KIAj13w44TJWOtdBqbSjxpnP3rv3TNpuJ9ue2LEtRqqOVPJ0AcNkM9ofljQn4yGHW564Cwnsb7dkgoHS8qCNKTRHqqszKi2+PSrlFWYJhZBDhx+Fzw/g0sUneEXMRX9CvTZmwXBJic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765955643; c=relaxed/simple;
	bh=KlafM7N7iuJymg3C66J7FTYUYIguvrItX8tmvCCfQec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bgu8lT+sp7i7gfPdMWIFhkpoCCL6iKyt4Y3j4WRe5u2a/h/qbzvNy/N9qG8Wukjml2SeyfYy0egVovBV2olLe9xBt6dw9vPeYtO8KzahGlg2c+BEZ/oZFe8HFfwc7upqtsAjmTFMtynNlOIehaofugVfBQkd+RufhmyVloJejLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bczq6gqT; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765955642; x=1797491642;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KlafM7N7iuJymg3C66J7FTYUYIguvrItX8tmvCCfQec=;
  b=Bczq6gqTodbOGpxwbPPe6c3vpxdlUrUS4MNSqO1pH3ZxUpZYuTPU3Nvp
   2KCzW3smPWH+olVm/UkJCDXDgM1fyqkT2BDqm2FKDqo8iwM/p3sEa/kIS
   cCxapj04REIE/UpjuLTycezvP5KlHt0r3oHmlVJVq65HK9dGGcMF6dAx5
   I0ioCOikBaS19hBom8WN6wKvPxOclKoAynNI19M7hw3ttmMPiKWXXsGII
   HenXGU2qcmlEdXoEokb2dvS5xiq8e93NABIa+zlVbzZrKODLDrMFSl6MR
   kH/2UPIbLvSTX6AYEG1jc5O7uj0/WugtgtDlnB4OGrnTQ/NjKJdN+OrJ/
   g==;
X-CSE-ConnectionGUID: K/KlBkgTSVKOxk0jodeHMg==
X-CSE-MsgGUID: mc4pOToGRuylGtNldlThUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="85476483"
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="85476483"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 23:14:01 -0800
X-CSE-ConnectionGUID: 0BFZqSWPQ5mOe9iD91sBCg==
X-CSE-MsgGUID: EHNWznC5Q6Sji/O+5wsnVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="235626648"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Dec 2025 23:13:58 -0800
Date: Wed, 17 Dec 2025 14:57:49 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Kiryl Shutsemau <kas@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev, kvm@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Message-ID: <aUJUbcyz2DXmphtU@yilunxu-OptiPlex-7050>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-3-seanjc@google.com>
 <aTe4QyE3h8LHOAMb@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTe4QyE3h8LHOAMb@intel.com>

> >+#define x86_virt_call(fn)				\
> >+({							\
> >+	int __r;					\
> >+							\
> >+	if (IS_ENABLED(CONFIG_KVM_INTEL) &&		\
> >+	    cpu_feature_enabled(X86_FEATURE_VMX))	\
> >+		__r = x86_vmx_##fn();			\
> >+	else if (IS_ENABLED(CONFIG_KVM_AMD) &&		\
> >+		 cpu_feature_enabled(X86_FEATURE_SVM))	\
> >+		__r = x86_svm_##fn();			\
> >+	else						\
> >+		__r = -EOPNOTSUPP;			\
> >+							\
> >+	__r;						\
> >+})
> >+
> >+int x86_virt_get_cpu(int feat)
> >+{
> >+	int r;
> >+
> >+	if (!x86_virt_feature || x86_virt_feature != feat)
> >+		return -EOPNOTSUPP;
> >+
> >+	if (this_cpu_inc_return(virtualization_nr_users) > 1)
> >+		return 0;
> 
> Should we assert that preemption is disabled? Calling this API when preemption
> is enabled is wrong.
> 
> Maybe use __this_cpu_inc_return(), which already verifies preemption status.
> 

Is it better we explicitly assert the preemption for x86_virt_get_cpu()
rather than embed the check in __this_cpu_inc_return()? We are not just
protecting the racing for the reference counter. We should ensure the
"counter increase + x86_virt_call(get_cpu)" can't be preempted.

Thanks,
Yilun

