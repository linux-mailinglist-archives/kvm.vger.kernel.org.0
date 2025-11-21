Return-Path: <kvm+bounces-64222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7C4C7B563
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8E363A3EFF
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD7729E10C;
	Fri, 21 Nov 2025 18:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k6q7ho09"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9AE224AF2;
	Fri, 21 Nov 2025 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763749786; cv=none; b=tClMGNj6/7BPe+8qpUg+R0NrnvGXkixNv6tscDzfkYregL005XLUY2bsubpJL0x0c5NSVVgzeZRYfrThharqXkgtrmDQQ0QX12w/+9LKhGLvsub1gNykbu7AP3uzagvZ3lZdv4T7fJuHNpVb1il+wxn2Iu+k8dCN9MB4eX5jams=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763749786; c=relaxed/simple;
	bh=rL5LzIA2Q2jdtnILojs1yQuUeaL7ZX2FLwj9i8bSyDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4Zp327Cu0D7V5d+8ysUjBvj7OEqYAlbHzabQ00roTrqSpBZq9i1p5tikypDYL3fVREsDZtpcge/gucm9Tnml6tQUobSxtMBrWznyUlvaQARoZwXoVCCJXKLJaNsVgHVmejZJQPs5Js7DqpECqEeCHu5eVEx2NvQR8qttOVJaCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k6q7ho09; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763749783; x=1795285783;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rL5LzIA2Q2jdtnILojs1yQuUeaL7ZX2FLwj9i8bSyDs=;
  b=k6q7ho09EpFBhDS6qO7Fx7fkd6s9g1EbEknybOC2wHbJFlA6FHbMAuuU
   duDqzEEMHoRS1JjS3E5sYt+MgreBsmTQevOUpOpNGBG+oM5dtOVrIj2aP
   stSHRjT/yE2kojJ3AKRGLaaQz+GnsCCaENYOJIHeGWBLGj6718uyEDlV3
   BomnICfsiUnRiwljPCy6PIWxK4udqmn4DnRZdMZTXJJigYNODhuXmtteb
   e0/2fB9rENIVJ5hTYTIweT6YUyoKpCQQylSZeAbSzVMQ8GoIjH9YUiaSK
   s94Umd0+Ga7C/DsfjRk/IECgHdyfoT5UrHx38Maos5/6bvdIGH7Ayd93x
   g==;
X-CSE-ConnectionGUID: RPeUemgqSbC9Va2f/QglqQ==
X-CSE-MsgGUID: 13+dnaFGRACPsPmVNVSlDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="65039700"
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="65039700"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 10:29:42 -0800
X-CSE-ConnectionGUID: EyKQ9qqmQYKAGwc/li/Wdg==
X-CSE-MsgGUID: CN1HmjwORyCD2yTUjUCVCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="192014286"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 10:29:41 -0800
Date: Fri, 21 Nov 2025 10:29:35 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v4 09/11] x86/vmscape: Deploy BHB clearing mitigation
Message-ID: <20251121182935.klm43ygvtoni4y7a@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-9-1adad4e69ddc@linux.intel.com>
 <67b9ad70-71ed-44ee-bc45-e02eb75043d2@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67b9ad70-71ed-44ee-bc45-e02eb75043d2@suse.com>

On Fri, Nov 21, 2025 at 04:18:09PM +0200, Nikolay Borisov wrote:
> 
> 
> On 11/20/25 08:19, Pawan Gupta wrote:
> > IBPB mitigation for VMSCAPE is an overkill on CPUs that are only affected
> > by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> > indirect branch isolation between guest and host userspace. However, branch
> > history from guest may also influence the indirect branches in host
> > userspace.
> > 
> > To mitigate the BHI aspect, use clear_bhb_loop().
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> <snip>
> 
> > @@ -3278,6 +3290,9 @@ static void __init vmscape_apply_mitigation(void)
> >   {
> >   	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER)
> >   		static_call_update(vmscape_predictor_flush, write_ibpb);
> > +	else if (vmscape_mitigation == VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER &&
> > +		 IS_ENABLED(CONFIG_X86_64))
> 
> why the x86_64 dependency ?

BHI sequence mitigation is only supported in 64-bit mode. I will add a
comment. Looking at it again, I realized that 64-bit check should be in
vmscape_select_mitigation(), otherwise we report incorrectly on 32-bit.

> > +		static_call_update(vmscape_predictor_flush, clear_bhb_loop);
> >   }
> >   #undef pr_fmt
> > @@ -3369,6 +3384,7 @@ void cpu_bugs_smt_update(void)
> >   		break;
> >   	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
> >   	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
> > +	case VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER:
> >   		/*
> >   		 * Hypervisors can be attacked across-threads, warn for SMT when
> >   		 * STIBP is not already enabled system-wide.
> > 
> 

