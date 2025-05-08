Return-Path: <kvm+bounces-45852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5CC8AAFB12
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D24EA3AD7EA
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FEF422AE59;
	Thu,  8 May 2025 13:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dBrhXZe4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2060F17BA5;
	Thu,  8 May 2025 13:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746710217; cv=none; b=Dmw8jH5feG6T7RvrRcjFWpJ4SGsrWGaEX6pHkmojAFK7p1CebJo2/XsEsSbrPYrI1ILPV7sEMTp9i68EIlugu8Lbqzy7eBKAj+OUdin0Alxj7ztSLZtewJj2sUWkI2S8r964NIuLAFYS6pYm5xS6efskh/fNZKuc9LDedw/JcwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746710217; c=relaxed/simple;
	bh=DmYv1BhRdwdssj9Hn9d+R6TbeoEowIXHu2HfHaVqAF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOkyb6/P4CFAB04qQQ/W+1DYtw29Wgdllmb85km7k2e8vSApRi0zvs6SK0umMv8PszTwAKDewu274Y/tP1YZtQSp6OfLBt7E7lz9fEaYDzib3K/7+78eR+wPKgwM1RQtbubzmKMviflREuWToEaGifTF+TkpkNSr0RAZvr998sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dBrhXZe4; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746710216; x=1778246216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DmYv1BhRdwdssj9Hn9d+R6TbeoEowIXHu2HfHaVqAF8=;
  b=dBrhXZe4kNjoOFDU8j2Jc48JyMEsu0rQP/y/RezaGRPY3aXo1+NgBmVM
   XAI32Wi9cJLoi9TGOri6MNqXhkKAG/FIreZxal6PtE/loMJ6VJSwOZOkH
   HKJS8gBngkvFxosPzEztgwCVYbZu2Jn3ydbJ9yAOUjjHCq/vAJe87SE1C
   E+62ja3sBzYHkPkFowhSxyn6D5KKC5o13DPCfeDk2Ij8Q09ZMk/BccDzs
   x2TWzqUISzWW4uCupYrUWAQytnWlL/470ZrR8fkT0I3k0iBEGOfpW25L8
   C9qCLMcpmRyutXtWQ2bwL5JuCmgB2wySikMfMOMq18WXqcIgGC8Rtir6R
   Q==;
X-CSE-ConnectionGUID: DfoMcpNeQi6+EKy0A51l0w==
X-CSE-MsgGUID: apikCU3bQ4yk3Yq9zV3sdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="52300270"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="52300270"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 06:16:55 -0700
X-CSE-ConnectionGUID: dieNcDOZTKOjMru2aC3yxw==
X-CSE-MsgGUID: kAVd3o24S3it0zdYcVDrjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="159595613"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 08 May 2025 06:16:52 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 0FD5119D; Thu, 08 May 2025 16:16:50 +0300 (EEST)
Date: Thu, 8 May 2025 16:16:50 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <cu332ci4fvpgb6akgpg3p53336qndi36px5osfv57vcq5u3din@kxu2diy723tq>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
 <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com>
 <4bb2119a-ff6d-42b6-acf4-86d87b0e9939@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bb2119a-ff6d-42b6-acf4-86d87b0e9939@intel.com>

On Wed, May 07, 2025 at 09:31:22AM -0700, Dave Hansen wrote:
> On 5/5/25 05:44, Huang, Kai wrote:
> >> +static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> >> +			struct list_head *pamt_pages)
> >> +{
> >> +	u64 err;
> >> +
> >> +	hpa = ALIGN_DOWN(hpa, SZ_2M);
> >> +
> >> +	spin_lock(&pamt_lock);
> > Just curious, Can the lock be per-2M-range?
> 
> Folks, please keep it simple.
> 
> If there's lock contention on this, we'll fix the lock contention, or
> hash the physical address into a fixed number of locks.

I had this idea in mind as well.

> But having it be
> per-2M-range sounds awful. Then you have to size it, and allocate it and
> then resize it if there's ever hotplug, etc...
> 
> Kirill, could you put together some kind of torture test for this,
> please? I would imagine a workload which is sitting in a loop setting up
> and tearing down VMs on a bunch of CPUs would do it.

It has to be multiple parallel creation/teardown loops. With single TD we
won't see much concurrency. Most of PAMT allocations comes from single
VCPU.

And it makes sense to do with huge pages as it cuts number of allocated
PAMT memory allocated on TD creation by factor of 10 in my setup.

JFYI, booting a TD with huge pages consumes 1-2MB of PAMT memory. I doubt
any optimization here is justifiable.

> That ^ would be the worst possible case, I think. If you don't see lock
> contention there, you'll hopefully never see it on real systems.
> 
> I *suspect* that real systems will get bottlenecked somewhere in the
> page conversion process rather than on this lock. But it should be a
> pretty simple experiment to run.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

