Return-Path: <kvm+bounces-59687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 123CCBC7A58
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 09:14:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FF124209A1
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 07:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7986D2D0C64;
	Thu,  9 Oct 2025 07:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zo6aIWc0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE7F296BB7
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 07:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759993970; cv=none; b=hDUOzsaKcF/yyNwqnDR7QZTUFoyqG454x2/MNz2lDDENenAZOPIhogARODDSXV023CwrVfpoKEFlUzI4GH8bHQ/DI1sVlaoWNF6++nElpfbSuXt4Po6bV0/pDd7sZCkKRbKBvCBrvTK4XCCjCd1gU4hUPay43MO1iidcJtTsUgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759993970; c=relaxed/simple;
	bh=j8D6lhpn+DvzIQLbN0xjFG5MUcZv6Y4XKehAfbA8pDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pripksT+E6vJXaq6DR1mR+tIusNNruquaMDFe8PTYxfFSdCvfM66qrYnAa89Ms4XLwj0tpSd4/HCtDXRkRc+01JH/Mu3h3cNYuZTn1Ew0dyZpdDv9IvNy4OyOgH0Fe+sz3Uet3mLFZNKgwUSkw0jKd1dfAYpC0OakL3FNgFPDII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zo6aIWc0; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759993968; x=1791529968;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j8D6lhpn+DvzIQLbN0xjFG5MUcZv6Y4XKehAfbA8pDA=;
  b=Zo6aIWc0kymtATlsoT5fzmUPrdIHLEK684PRP6zy10am93YcRaUgqZ1Z
   S1ULxJk6ETauQY74YJrzUcG0xcUArT03eMgXrpv2JzAlbsMWhqMGIs38v
   s9IEayIq5qz48sRukClSBQ3st2/4dCu4qN7r53bL80PV91NjTASsW0nKG
   8Onl1KpKZjWpO+Dbq8q5MoGU2c+ns7+rFKOmAHCIIAg+oC9h0kvzo8gN8
   5EkGVZSicbZVH9z2QYfewM+qGsoZYuparDFJBIdfw0lpFgYqit+4g4/sx
   b6S1/xE6JZqTlWq4b9diI2MW3aP42/vCJmhiYvv07DAtCF0fKeoahr2oN
   g==;
X-CSE-ConnectionGUID: fAAO4t4hSCijXE6F3C6wYw==
X-CSE-MsgGUID: xW71f30ZTo+qx2hF3XFY5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="62228446"
X-IronPort-AV: E=Sophos;i="6.19,215,1754982000"; 
   d="scan'208";a="62228446"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 00:12:47 -0700
X-CSE-ConnectionGUID: +dq2x9SWSBuW0bGxn5PcRA==
X-CSE-MsgGUID: 0WFjPuc6TUG7Aps4ldM5Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,215,1754982000"; 
   d="scan'208";a="180582050"
Received: from guptapa-dev.ostc.intel.com (HELO desk) ([10.54.69.136])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 00:12:47 -0700
Date: Thu, 9 Oct 2025 00:12:39 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, qemu-devel@nongnu.org, 
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] i386/kvm: Expose ARCH_CAP_FB_CLEAR when invulnerable to
 MDS
Message-ID: <upvij3mabr6bahxotydtuha6hsvfritx7bn3fqyptmk5ckga2k@gcl6mlol2wbx>
References: <20251008202557.4141285-1-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008202557.4141285-1-jon@nutanix.com>

On Wed, Oct 08, 2025 at 01:25:57PM -0700, Jon Kohler wrote:
> Newer Intel hardware (Sapphire Rapids and higher) sets multiple MDS
> immunity bits in MSR_IA32_ARCH_CAPABILITIES but lacks the hardware-level
> MSR_ARCH_CAP_FB_CLEAR (bit 17):
>     ARCH_CAP_MDS_NO
>     ARCH_CAP_TAA_NO
>     ARCH_CAP_PSDP_NO
>     ARCH_CAP_FBSDP_NO
>     ARCH_CAP_SBDR_SSDP_NO
> 
> This prevents VMs with fb-clear=on from migrating from older hardware
> (Cascade Lake, Ice Lake) to newer hardware, limiting live migration
> capabilities. Note fb-clear was first introduced in v8.1.0 [1].
> 
> Expose MSR_ARCH_CAP_FB_CLEAR for MDS-invulnerable systems to enable
> seamless migration between hardware generations.

LGTM, thanks!

