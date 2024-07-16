Return-Path: <kvm+bounces-21686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B4CB931F34
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 05:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3F1A1F21C6E
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 03:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E3BDF6C;
	Tue, 16 Jul 2024 03:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aBcDDdDv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B077EF
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 03:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721099991; cv=none; b=XJlgp80Eh0bW6bWIGfw9xNES0xuZH3IcIsrH9HbCmgegllRn9ac54m8iRGjb7ZaSZvOv/RAzfhKYEjtCzh3G9/DbjMF4Cc8VknCIhw4tobx0Stz3ApxsSFzGiK9cNC5OOGPWlli02Q2SoiC7ZzatKt5CGSgxBomKU6goD+Y43D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721099991; c=relaxed/simple;
	bh=5hwE8jefYu3wzgfHPUKdIBBuEEdxSZRNn2cQHsoVJPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvsPECTfexTSS4ta5/96xhDLIQg3bYqlVkGo2TaFRPv4tu9TMg/uDyNpnwBHDgJYvtAMiN2s+lnEfVsXtFKGhoEqp9CqI7/2OrF2O1KNrPswfm72lINppqJA2fDrfOFxTlG3huJ1P4pDFtA98O2gmKHOSTQoyKXYZTf9Xckqk0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aBcDDdDv; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721099990; x=1752635990;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5hwE8jefYu3wzgfHPUKdIBBuEEdxSZRNn2cQHsoVJPk=;
  b=aBcDDdDv2bosM4YNKkQsxmH6Ind0MfsyB4CNv1iWBMVfmWymjgr2ouP4
   /1E+23IKjzYGXonBaoHoKytvVTi+J8Fl0jWSV+8MQAUsqsgr3RlVqh8pn
   d81JXm1J3auxbca2NdUuxbSJVAbrZw+z1XQN5gns3hZ1nuoWy8wxRGdAD
   KXV0aQaT0p1SacPCrVdCMjcCkD+2ZofJq1TOf8dzk+tMvCMDlqKRrrD88
   tb4FebD50rkOQ72PFhx+UIsNNpRNRVn6z5sn4GSOXRXkCCN8jrAhyWhW/
   ZXBppzOM1ewqsQ3003h9I2CdwDUG7+GY+hcAmhca52oGY51fXMpkf4jg7
   Q==;
X-CSE-ConnectionGUID: 18ndl1u8RDOndKUVswIcXQ==
X-CSE-MsgGUID: 68/OrUaYT5O82hTGOrHAfQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11134"; a="18628019"
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="18628019"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 20:19:50 -0700
X-CSE-ConnectionGUID: 5hS9BWRlSvqlT35x19A8rA==
X-CSE-MsgGUID: iwZQFyToTjmx6zBNzEJFWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="49788264"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 15 Jul 2024 20:19:46 -0700
Date: Tue, 16 Jul 2024 11:35:27 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: "Chen, Zide" <zide.chen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v3 7/8] target/i386/kvm: Clean up return values of MSR
 filter related functions
Message-ID: <ZpXqf7Pc5shZ8osj@intel.com>
References: <20240715044955.3954304-1-zhao1.liu@intel.com>
 <20240715044955.3954304-8-zhao1.liu@intel.com>
 <f8f2cfb9-1128-4e1f-a152-3f88587927a1@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8f2cfb9-1128-4e1f-a152-3f88587927a1@intel.com>

Hi Zide,

On Mon, Jul 15, 2024 at 03:18:07PM -0700, Chen, Zide wrote:
> Date: Mon, 15 Jul 2024 15:18:07 -0700
> From: "Chen, Zide" <zide.chen@intel.com>
> Subject: Re: [PATCH v3 7/8] target/i386/kvm: Clean up return values of MSR
>  filter related functions
> 
> On 7/14/2024 9:49 PM, Zhao Liu wrote:
> > @@ -5274,13 +5272,13 @@ void kvm_arch_update_guest_debug(CPUState *cpu, struct kvm_guest_debug *dbg)
> >      }
> >  }
> >  
> > -static bool kvm_install_msr_filters(KVMState *s)
> > +static int kvm_install_msr_filters(KVMState *s)
> >  {
> >      uint64_t zero = 0;
> >      struct kvm_msr_filter filter = {
> >          .flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
> >      };
> > -    int r, i, j = 0;
> > +    int ret, i, j = 0;
> >  
> >      for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
> 
> Nit: Since it's a clean up patch, how about replace
> KVM_MSR_FILTER_MAX_RANGES with ARRAY_SIZE(msr_handlers), to make the
> code consistent in other places to refer to the array size of
> msr_handlers[].

Yes, that's fine, I'll add a new small trivial patch to clean up this.

> >          KVMMSRHandlers *handler = &msr_handlers[i];
> > @@ -5304,18 +5302,18 @@ static bool kvm_install_msr_filters(KVMState *s)
> >          }
> >      }
> >  
> > -    r = kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
> > -    if (r) {
> > -        return false;
> > +    ret = kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
> > +    if (ret) {
> > +        return ret;
> >      }
> >  
> > -    return true;
> > +    return 0;
> >  }
> 
> Nit: Seems ret is not needed here, and can directly return kvm_vm_ioctl();

Yes, good catch!

Thanks for you review!
Zhao



