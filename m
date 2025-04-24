Return-Path: <kvm+bounces-44071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3D6A9A24F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D0CE9234FA
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241781DCB09;
	Thu, 24 Apr 2025 06:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F2rNqUWO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5FA176AC8
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 06:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745476372; cv=none; b=SxBlCZ4YeFs+UQhAvX5ZigoJArPojqsX5IJAiroCIIXaLdgwN2v7KvGowey+vU6kds+HhrfW2IsyNNvvzRbvgKXjO6+Rn96L+UKaNS5gcXH/9FGpMxRtGNYSbXJoWMg+nAkksxhTlBo+VtZSpDjSNC7w059GWuBU7tLt3qAlBys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745476372; c=relaxed/simple;
	bh=crVvmvt20948+XIDqkkeo+K2HiFVUVQubWp6Rvxv3ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOkqNV5Z3yRiPpBptruEfVWCKHoAQQnTZNCQ4bE7kvUgYfKXToBiHDkFNh6zk6XCWAaQGKiCiZBEF367VGwLhu2ZDRWTdp+Wxd0w8MnINPRNy+W6Ga5WFl7tCfDmVLl1i0E0rwt0ufhSpuDFp3P6MgmjtrMrfvv6twdc6c+u2w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F2rNqUWO; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745476369; x=1777012369;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=crVvmvt20948+XIDqkkeo+K2HiFVUVQubWp6Rvxv3ZA=;
  b=F2rNqUWOc0vq1WPGIOswEN3+h9nSXLGvZX1xathQxCYmNl1ImkwBzyAw
   s0dm77bfKMzcWir6vzTt9kZzM25L7hyWhEkDhSbQfQEu+dU9HuuHBbvsI
   lYaYjuGrWuyIWk6KikM7KNZhqC77JY7aqYza7pftU7Y5fifhWJwexhMrn
   /8nhqfWytgJyT7UZjvbVYZsnPUm/w5j2eNTgTjqSeB07YCXXTnPgHPeXA
   K88lIjuNel1VSB7B17vwynBtZNKYCf+7Xs5eiCmmJ1GoUNUMYk1AQaOom
   A6KWq8MokOipg8TNFKyCP3TNTYWZQKdxpAAolQOw0nwoQq4bQdg0dKyo7
   Q==;
X-CSE-ConnectionGUID: emsnf2b3Q4KhebSpaNtqUQ==
X-CSE-MsgGUID: x3smqrJfQNaB3kVIgjkC+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47226572"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="47226572"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 23:32:48 -0700
X-CSE-ConnectionGUID: giu4a9VBT6uyMnrpiLBAeQ==
X-CSE-MsgGUID: r0QMmQ+gS0CiIRt5Q/1iRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="163562658"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 23 Apr 2025 23:32:45 -0700
Date: Thu, 24 Apr 2025 14:53:41 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Tejus GK <tejus.gk@nutanix.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [RFC 05/10] i386/cpu: Introduce cache model for SapphireRapids
Message-ID: <aAnf9YvevhAo+HJE@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-6-zhao1.liu@intel.com>
 <315d76f0-d81c-43ed-a13e-ef9b8e6a0e75@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <315d76f0-d81c-43ed-a13e-ef9b8e6a0e75@nutanix.com>

Hi Tejus,

> Thank you for this improvement! I see that even within the SPR-SP line of
> Processors, the cache sizes vary across different models. What happens for
> an instance when a processor only has 37.5 MiB of L3 per socket, but the CPU
> Model exposes 60 MiB of L3 to the VM?

AFAIK, the Linux scheduler doesn't take cache size into account, so
generally speaking, I think there's no impat on Linux.

If user space apps don't care about this info, then there's no problem.

However, I've met some cases where certain customers prefer that the
named cpu model also become closer to real silicon (e.g. current cache
size). The advantage of this is that an app that works fine on real
silicon is more likely to run normally in a Guest environment...
Because nobody can ensure that no user space app care about cache
size at all. And it's also unknown if there will be other OSes that
depend on the cache size (although I think it should be fine, after
all, current x86 only supports smp machines).

In contrast, the 0x1f example is more typical. By SDM, 0x1f is only
optional, and if 0x1f is not available, the one should check 0xb.
However, in Mishra's case, his windows only relies on 0x1f, so making
the named CPU model and the real silicon alignable is a better way
of avoiding all sorts of incompatibilities.

Thanks,
Zhao


