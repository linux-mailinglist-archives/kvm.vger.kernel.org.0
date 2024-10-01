Return-Path: <kvm+bounces-27763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 484E298B987
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 12:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDEE62846D8
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 10:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A2C1A08A8;
	Tue,  1 Oct 2024 10:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cxcGxd3f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573951C693;
	Tue,  1 Oct 2024 10:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727778240; cv=none; b=VvNA6sSMigrkQz+ABWY7PmuQzevP1pZVR+kC5icM4aCefMxwhaFT+ICxgvQB+1BEnhAzaVEj1PF+4b7/mM40azarvOnH/zaAU2WUJdcbbJXwVpDM2EayfXD2NFJOEGenSMTqP99IVcq0PKmEA4qobPuLeKxreuvsJm4WfX1Q0Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727778240; c=relaxed/simple;
	bh=QfR4YGvv8nGvv8L5AQB+UTys76AzcSIObvk4CN6Ql0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajNhJQv+BgbJ59X2xnpPzqT3dy6c7eaLJ4YYXUIxRdZH9iT9eD4PCTp+nGFABUD58J4eENx5b02rB+E1A8/FwywCFiRWnTy3RjRz/0kxnBGbZ3hdaGRAMy48CzVgBCnfuDmAUw+3+x+UA2/ERfs/3gnrKyLuGQs3PgFk+/jVIrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cxcGxd3f; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727778239; x=1759314239;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QfR4YGvv8nGvv8L5AQB+UTys76AzcSIObvk4CN6Ql0g=;
  b=cxcGxd3ff4d8XnmdHCGYaT/WXyzqqsA8irjsMVcuR5mpauMwAVg6Pe3e
   VnexYvjAFJ7XB9IivcUdPWjTng/7FhPDhsYxQIEau3/GX5EcBnHxQ2wql
   0iubRAaywzD6wkaFGq3aZcMaTGgv2es2OrZ1BaMVxjZUUFgmaerfl3Xyp
   KIlQ90bwCNjEXON5L3xISnl0rcWXc5nFRAYbR+8MeF8d8gfZ42yijxbQe
   sfD8ig+iAkaN3TRnjILdm/532bD485voErrhUc8s/6fqoqZKavjJ7XuFe
   4Yl0hndsZoH0wkw3/t2v7ypVWVmoDb6adfVIRTu/RGDTE0lejx8Ay10pX
   A==;
X-CSE-ConnectionGUID: ePx68PGjQfqb0t5/FTMoDg==
X-CSE-MsgGUID: vJYJZGTPSjajOWu1ujSEdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11211"; a="37463165"
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="37463165"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 03:23:58 -0700
X-CSE-ConnectionGUID: 8RK5zgbCSVKR7Z3tdALWtg==
X-CSE-MsgGUID: gtGviVxATyC6mAogzr0lXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="73664242"
Received: from carterle-desk.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.163])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 03:23:54 -0700
Date: Tue, 1 Oct 2024 13:23:49 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
	xiaoyao.li@intel.com, linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 15/25] KVM: TDX: Make pmu_intel.c ignore guest TD case
Message-ID: <ZvvNm7EhcsWE_20o@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-16-rick.p.edgecombe@intel.com>
 <d566cce2-2c78-4547-a2c0-75087e06f790@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d566cce2-2c78-4547-a2c0-75087e06f790@redhat.com>

On Tue, Sep 10, 2024 at 07:23:10PM +0200, Paolo Bonzini wrote:
> On 8/13/24 00:48, Rick Edgecombe wrote:
> > From: Isaku Yamahata<isaku.yamahata@intel.com>
> > 
> > Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
> > support as another patch series) and pmu_intel.c touches vmx specific
> > structure in vcpu initialization, as workaround add dummy structure to
> > struct vcpu_tdx and pmu_intel.c can ignore TDX case.
> > 
> > Signed-off-by: Isaku Yamahata<isaku.yamahata@intel.com>
> > Signed-off-by: Rick Edgecombe<rick.p.edgecombe@intel.com>
> 
> Would be nicer not to have this dummy member at all if possible.
>
> Could vcpu_to_lbr_desc() return NULL, and then lbr_desc can be checked in
> intel_pmu_init() and intel_pmu_refresh()?  Then the checks for
> is_td_vcpu(vcpu), both inside WARN_ON_ONCE() and outside, can also be
> changed to check NULL-ness of vcpu_to_lbr_desc().

Just catching up on this one, returning NULL works nice. Also for
vcpu_to_lbr_records() we need to return NULL.

Also the ifdefs around the is_td_vcpu() checks should not be needed as
is_td_vcpu() returns false unless CONFIG_INTEL_TDX_HOST is set.

> Also please add a WARN_ON_ONCE(is_td_vcpu(vcpu)), or WARN_ON_ONCE(!lbr_desc)
> given the above suggestion, to return early from vmx_passthrough_lbr_msrs().

Yes will add.

Regards,

Tony

