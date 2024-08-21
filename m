Return-Path: <kvm+bounces-24689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A91959467
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 08:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6AFC3B22F34
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 06:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81B616D9C2;
	Wed, 21 Aug 2024 06:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IProlDxW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B111416D4D4;
	Wed, 21 Aug 2024 06:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724220900; cv=none; b=dzU/T6BRgMnnihfR1DudnWfdDL8Jq1wTLOwySNcCNx7Vo3C2e78L/p9VrNpJ6I+rMvywXkm5lnmO+tO8MXXLuxUE1OSnSdN91ix7duSADVy7kTXn52fiivR2BKCPpny9bIZ7wwngfbq5n6S3e54OcJzC3A1n7kWJNGKpZFxeoAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724220900; c=relaxed/simple;
	bh=H1b05/HU+ka20Nfd7PMa5d9q1hclwIIcJ1RdvrD8AZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=twlJEMucsKU6bLfOWEwQPP4vIToP3PbHMxKv4QGLme23mK04yTBSxSO3hUzdrDlY5cuJxpU/x5XSvH+HcmODjToqCAILJgn7Z47/f1uaibxl/zuuLZ3O1WCuOLSF8lwOaTLs0piCqfYecg8HhBYbBkXT7/hIQvjJS1IyVF9Lya0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IProlDxW; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724220898; x=1755756898;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=H1b05/HU+ka20Nfd7PMa5d9q1hclwIIcJ1RdvrD8AZw=;
  b=IProlDxW7BhivyH2+2J/v3rSzDAjtRccmZJ0JKSvdQMvj7Fb3aUAULmY
   9kV11cCXvGt6VG+JgDldVcvtjg8mKtZmprbvnv7IlKyE/vpnv/kKcFPCI
   4Ra2/CL5jOcJN1aHfrpouHbULiyaPFfMpkyN5tJQpYyVsroNRJBS/lPSt
   P4ue2QD2eY9OS3xhA3/wWEUt6RXjdZ+EU6rmJ1ce/mSXbnbEcGKZmMrDT
   BfvEoi7yrNpEPGtclsVobLuPdn0jh9di2v59+VnSU5aoxVLdFuqAysZ83
   cj/3e7HwHvWY7VGPU0XutmxFBtdzilKIH1QAKMgSFvj0jTXtZXfLRqvfJ
   g==;
X-CSE-ConnectionGUID: aWECl4IlQzujJdzfOpew7g==
X-CSE-MsgGUID: fgCOfjaMT1CBQeFZENTScg==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="22441718"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="22441718"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 23:14:58 -0700
X-CSE-ConnectionGUID: ahA/CmKNTXOfBIMvWsDElw==
X-CSE-MsgGUID: b1UyJw/VStKpHugIvEgbkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="65339014"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.248])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 23:14:54 -0700
Date: Wed, 21 Aug 2024 09:14:49 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on
 initialization
Message-ID: <ZsWF2UJmFdqlDmEs@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-10-rick.p.edgecombe@intel.com>
 <3779ae2f-610e-40b9-ad87-3882e9d88060@linux.intel.com>
 <0591ce2b1470bc5495ca0b6a5aa1376262714e97.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0591ce2b1470bc5495ca0b6a5aa1376262714e97.camel@intel.com>

On Wed, Aug 21, 2024 at 12:11:16AM +0000, Edgecombe, Rick P wrote:
> On Wed, 2024-08-14 at 14:18 +0800, Binbin Wu wrote:
> > > +#define KVM_TDX_CPUID_NO_SUBLEAF       ((__u32)-1)
> > > +
> > > +struct kvm_tdx_cpuid_config {
> > > +       __u32 leaf;
> > > +       __u32 sub_leaf;
> > > +       __u32 eax;
> > > +       __u32 ebx;
> > > +       __u32 ecx;
> > > +       __u32 edx;
> > > +};
> > 
> > I am wondering if there is any specific reason to define a new structure
> > instead of using 'struct kvm_cpuid_entry2'?
> 
> GOod question. I don't think so. 

I'll do a patch for this.

Regards,

Tony

