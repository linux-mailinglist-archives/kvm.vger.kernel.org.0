Return-Path: <kvm+bounces-51253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B0A6AF0A0F
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 06:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE96316D43A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 04:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B042A1E47AE;
	Wed,  2 Jul 2025 04:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ema9tQ37"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D90A4C7F
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 04:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751432295; cv=none; b=dgYi9o7OsnmN6cV0njZkxQ0yp6lyGbdCwx7+CIDAtFKWPjoJq9Wlg7Uo+f33QtY+wsSvZ2lAv/9iVmEomKgutzh8Z2eTCpE0cC8fRNXKQehWlshKHvnSNF/6tZ/vuQ0CO3EQ5u22F5YZsxhb/FlASLOg6yf2qol+jTTYHVAskME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751432295; c=relaxed/simple;
	bh=hcjSv6YuUYUHJ3M3kRfBMjY/KnSHcslCYgA8Hr9fhHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2l2bu91ourKG0Mp98lViKZ8WbwPBBABEh6ZyLAr6kWevxXEQQ+xEJa2yjwOIKjvtgaweoNpRPCEzYUD0DGK81gsJD7pXAnWS2vdXJBnDIsAh3Oq7SKAl54vujCuACsSKrpPOaES5M2nfqde3RiKqcdY8QYMSAdslyTgsXMswXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ema9tQ37; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751432294; x=1782968294;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hcjSv6YuUYUHJ3M3kRfBMjY/KnSHcslCYgA8Hr9fhHI=;
  b=ema9tQ37NfwLtg3qNt38Iet/XDSkaVv8yFBk/eEK42iolpoVORZGIbyD
   0mBojQjitlbNN1mKmhgYkK79JziApRKm95SbfAvEmRcPRl+E70jfV/Go5
   paX07OxfIfqdqu6yP8NA2qmerJ90rAjiMycHxAilSDbH4KKB612Ln3T2H
   c62yHp5+FhkgP6qzK7/UfBpXiPPDPoTzkG7+u63JwLfIFkkRFixi+Nfsw
   57QAIEYlDVIF4J7Auk0qt036h5bQAD49jLWnDZV2YJNIHtlR7UgwYfs5u
   FwufLRBAFPz7T1qwshA6BR4OxX/n0wSI4Y6R+IacY6kaH7LYXwN7rX1/5
   g==;
X-CSE-ConnectionGUID: wOl5xlkURj+4YpWegu5GVg==
X-CSE-MsgGUID: HSdX7EV/S4ixEDPyvfQYIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="57493266"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="57493266"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 21:58:14 -0700
X-CSE-ConnectionGUID: KbtBOj5hTmCzbQkpD0FVNg==
X-CSE-MsgGUID: W9Gn4OazRjOIYTE3mf/g6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="154514218"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa008.fm.intel.com with ESMTP; 01 Jul 2025 21:58:11 -0700
Date: Wed, 2 Jul 2025 13:19:36 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Igor Mammedov <imammedo@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org,
	boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <aGTBaN/Nu3AYMHUU@intel.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com>
 <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <aGPWW/joFfohy05y@intel.com>
 <20250701150500.3a4001e9@fedora>
 <aGQ-ke-pZhzLnr8t@char.us.oracle.com>
 <aGS9E6pT0I57gn+e@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGS9E6pT0I57gn+e@intel.com>

> > > > Could you please tell me what the Windows's wrong code is? And what's
> > > > wrong when someone is following the hardware spec?
> > > 
> > > the reason is that it's reserved on AMD hence software shouldn't even try
> > > to use it or make any decisions based on that.
> > > 
> > > 
> > > PS:
> > > on contrary, doing such ad-hoc 'cleanups' for the sake of misbehaving
> > > guest would actually complicate QEMU for no big reason.
> > 
> > The guest is not misbehaving. It is following the spec.
> 
> (That's my thinking, and please feel free to correct me.)
> 
> I had the same thought. Windows guys could also say they didn't access
> the reserved MSR unconditionally, and they followed the CPUID feature
> bit to access that MSR. When CPUID is set, it indicates that feature is
> implemented.
> 
> At least I think it makes sense to rely on the CPUID to access the MSR.
> Just as an example, it's unlikely that after the software finds a CPUID
> of 1, it still need to download the latest spec version to confirm
> whether the feature is actually implemented or reserved.

If the encountered feature bit is indeed not expected (truly reserved),
the processor would be considered faulty and may be fixed in a new
stepping. This is similar to the debate over whether software should
adhere to the spec or whether hardware (emulation) should comply.

> Based on the above point, this CPUID feature bit is set to 1 in KVM and
> KVM also adds emulation (as a fix) specifically for this MSR. This means
> that Guest is considered to have valid access to this feature MSR,
> except that if Guest doesn't get what it wants, then it is reasonable
> for Guest to assume that the current (v)CPU lacks hardware support and
> mark it as "unsupported processor".
 

