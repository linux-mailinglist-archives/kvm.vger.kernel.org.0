Return-Path: <kvm+bounces-71017-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ELgMNZ5Yjmn2BgEAu9opvQ
	(envelope-from <kvm+bounces-71017-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:47:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81ADD13195D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9743730DF57A
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317EF3346AB;
	Thu, 12 Feb 2026 22:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TXhp6yor"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7AB29ACC6;
	Thu, 12 Feb 2026 22:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770936452; cv=none; b=liVdfpCwGtG95tMH4qkX9IziidXN+NJwXWcGhMien8X+5I2f7VWotyjIFDVOj3IDLi5C2yQZMMZdD+xQXbBR6vnJvq3v7AKr2diOTS7za+ZpSQQbA97wgFPuOkCYFuaSL+6ojpHAX8XveVq8m3gUAvB1ziMmHvXEKWJmJQiZY3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770936452; c=relaxed/simple;
	bh=AiIS+Wm375XPUvioqsfLcR/Bc/OtkuBLuqfu5HEZOEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rmMKZXvT86/abC91cnZ8zBd3TVeIiwbE66QXVJrV0cWlUvMv02KkjPmfzQv3ntpALeeqLoL7Ts4/iFSrRVXlivTbkdQS9j/spDhr1Fn3C0pqlbA24Og5/Ge+EYkDxg5k4qnYz4sUgF77UkQPBrPLH/lNH7xwafSF5xzwapaUkLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TXhp6yor; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770936451; x=1802472451;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AiIS+Wm375XPUvioqsfLcR/Bc/OtkuBLuqfu5HEZOEY=;
  b=TXhp6yorRsmKGaOmK8ephPJMtTjvxEp+SkN2cnoA+pAITQ+q1n2AhBrr
   9D2zT8hxcZ9NlPB6qtgY/4c19nL6ExOCyuuZ+OlFePgs53PC/XQBBwo3i
   wKjm22m9AH6zJ7v98BjI7UFgjzGcLSRmpaeQeoJVMR/sapJ06j05NTQvh
   jOd6dG01J0DD8AG0fmG4mhrtZkdXWnACnGNgfzMBOicee61hCBNKoh4/Z
   3IO6WI+mKHw80y8/jlDVO+89OSdbm2uyzG3wULJcwKbaIxHz7sd8HfdSH
   zUymQUd7GpHaA6j5+NrocQo2m/VPjiYQU//RrD+a88z3gv8j522Emhyvh
   w==;
X-CSE-ConnectionGUID: D5PHm02xS1mZokMn5EsfWQ==
X-CSE-MsgGUID: ikMLpPWITty3eVMKUaSnLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="72193914"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="72193914"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 14:47:31 -0800
X-CSE-ConnectionGUID: PwkwoEJQT22h09w+CL+wZw==
X-CSE-MsgGUID: LdK8fGYwRmGYFAo8AoWvDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="211954712"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 12 Feb 2026 14:47:26 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vqfT2-00000000tvY-2HJ9;
	Thu, 12 Feb 2026 22:47:24 +0000
Date: Fri, 13 Feb 2026 06:46:57 +0800
From: kernel test robot <lkp@intel.com>
To: Julian Ruess <julianr@linux.ibm.com>, schnelle@linux.ibm.com,
	wintera@linux.ibm.com, ts@linux.ibm.com, oberpar@linux.ibm.com,
	gbayer@linux.ibm.com, Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, mjrosato@linux.ibm.com,
	alifm@linux.ibm.com, raspl@linux.ibm.com, hca@linux.ibm.com,
	agordeev@linux.ibm.com, gor@linux.ibm.com, julianr@linux.ibm.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] vfio/pci: Set VFIO_PCI_OFFSET_SHIFT to 48
Message-ID: <202602130659.urh1Dx2i-lkp@intel.com>
References: <20260212-vfio_pci_ism-v1-1-333262ade074@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212-vfio_pci_ism-v1-1-333262ade074@linux.ibm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71017-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[23];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[01.org:url,intel.com:mid,intel.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 81ADD13195D
X-Rspamd-Action: no action

Hi Julian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b]

url:    https://github.com/intel-lab-lkp/linux/commits/Julian-Ruess/vfio-pci-Set-VFIO_PCI_OFFSET_SHIFT-to-48/20260212-220938
base:   05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
patch link:    https://lore.kernel.org/r/20260212-vfio_pci_ism-v1-1-333262ade074%40linux.ibm.com
patch subject: [PATCH 1/3] vfio/pci: Set VFIO_PCI_OFFSET_SHIFT to 48
config: riscv-randconfig-001-20260213 (https://download.01.org/0day-ci/archive/20260213/202602130659.urh1Dx2i-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260213/202602130659.urh1Dx2i-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602130659.urh1Dx2i-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/vfio/pci/nvgrace-gpu/main.c: In function 'addr_to_pgoff':
>> drivers/vfio/pci/nvgrace-gpu/main.c:196:22: warning: left shift count >= width of type [-Wshift-count-overflow]
     196 |                 ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
         |                      ^~
   drivers/vfio/pci/nvgrace-gpu/main.c: In function 'nvgrace_gpu_mmap':
   drivers/vfio/pci/nvgrace-gpu/main.c:272:22: warning: left shift count >= width of type [-Wshift-count-overflow]
     272 |                 ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
         |                      ^~


vim +196 drivers/vfio/pci/nvgrace-gpu/main.c

a23b10608d4203 Ankit Agrawal 2025-11-27  191  
9db65489b87298 Ankit Agrawal 2025-11-27  192  static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
9db65489b87298 Ankit Agrawal 2025-11-27  193  				   unsigned long addr)
9db65489b87298 Ankit Agrawal 2025-11-27  194  {
9db65489b87298 Ankit Agrawal 2025-11-27  195  	u64 pgoff = vma->vm_pgoff &
9db65489b87298 Ankit Agrawal 2025-11-27 @196  		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
9db65489b87298 Ankit Agrawal 2025-11-27  197  
9db65489b87298 Ankit Agrawal 2025-11-27  198  	return ((addr - vma->vm_start) >> PAGE_SHIFT) + pgoff;
9db65489b87298 Ankit Agrawal 2025-11-27  199  }
9db65489b87298 Ankit Agrawal 2025-11-27  200  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

