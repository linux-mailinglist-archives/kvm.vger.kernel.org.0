Return-Path: <kvm+bounces-53360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9247AB109D0
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 14:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 135EA1CE31BF
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 12:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E1D2C325F;
	Thu, 24 Jul 2025 12:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="No4s5Z+m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D714F2C08DD;
	Thu, 24 Jul 2025 12:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753358425; cv=none; b=Vqc7EtOkrUDTWK+Lps4QbcWmc1v/wVlZVWbMxP0sWD8CCYy93FreyBNOzQDTKYM0U/HuuMy9Vdit3q8oDnGw+vUckgP5KBUFhcHMVq3KyIFvPFPMcgYvpmoYFi3PkpfohcqWiKechr6yNHMY55o7zueyd2G0prdRN87IJsOXjSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753358425; c=relaxed/simple;
	bh=E959aFyB7Fz7wM1ihx+E3PvvcL2j2BmEZFA2aVmLOhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AIvqom2jDgMcY+9SlOyel/4UKeKgxK+bbVyz8nSC3rb6oh/wlZ4bYRL744ZHawP652N7vdkNP0gwT9Qdnn8rXqZuvMxItT9R2HW7wNAcNA1g25H8T7uPFfUWQWPyTbVSu2zYsTPxP6dKYE5wV2a5Kx7dJFbDrgGgJp8yu+eccsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=No4s5Z+m; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753358423; x=1784894423;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E959aFyB7Fz7wM1ihx+E3PvvcL2j2BmEZFA2aVmLOhc=;
  b=No4s5Z+muSMzeoJ0O9Dp2FEtkbJDVvTWxK7YSvSmcBnfzna6LO6RiHjE
   lCMucQTcanfVIF75dXcB7lE6dmwV4Ir017eVlrADMztQtHFRkyOAn7QeE
   0jO23TprDZW5vVrifOQcPReT66MtbjattOzdj7Am8ifoUp970YjsZ8B9e
   DtZUwQ0HSmCYIE9hgtAGLCnJcPSvViaaNCQbgxrqG5UZeZDuoK83r6QsS
   RV9KSrz21de+Jg3z4EOR2v6iYL3Tmi+j7CFBM/x5knfKRRimvygBMusTE
   xqUqfybuQAozHBJDSuS1pf6h3YDEJxt0iPI2CJAFRsEpjp59HwePSJYc3
   w==;
X-CSE-ConnectionGUID: q3b+T8ZHSOep4WtSK2bwqA==
X-CSE-MsgGUID: fESbx4CKTva3Wt3/d3YATA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55635948"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="55635948"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:00:22 -0700
X-CSE-ConnectionGUID: um94yLrvQkeieesPNbWB8Q==
X-CSE-MsgGUID: 58mHhrkeTRuAwGrnTU6UFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="165734118"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 24 Jul 2025 05:00:19 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ueucS-000KP7-03;
	Thu, 24 Jul 2025 12:00:16 +0000
Date: Thu, 24 Jul 2025 20:00:01 +0800
From: kernel test robot <lkp@intel.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>, joro@8bytes.org,
	suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
	Sairaj.ArunKodilkar@amd.com, Vasant.Hegde@amd.com,
	herbert@gondor.apana.org.au
Cc: oe-kbuild-all@lists.linux.dev, seanjc@google.com, pbonzini@redhat.com,
	will@kernel.org, robin.murphy@arm.com, john.allen@amd.com,
	davem@davemloft.net, michael.roth@amd.com, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/4] iommu/amd: Add support to remap/unmap IOMMU
 buffers for kdump
Message-ID: <202507241929.76UExdsw-lkp@intel.com>
References: <6a48567cd99a0ef915862b3c6590d1415d287870.1753133022.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a48567cd99a0ef915862b3c6590d1415d287870.1753133022.git.ashish.kalra@amd.com>

Hi Ashish,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.16-rc7 next-20250724]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ashish-Kalra/iommu-amd-Add-support-to-remap-unmap-IOMMU-buffers-for-kdump/20250722-055642
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/6a48567cd99a0ef915862b3c6590d1415d287870.1753133022.git.ashish.kalra%40amd.com
patch subject: [PATCH v4 1/4] iommu/amd: Add support to remap/unmap IOMMU buffers for kdump
config: x86_64-randconfig-r133-20250724 (https://download.01.org/0day-ci/archive/20250724/202507241929.76UExdsw-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250724/202507241929.76UExdsw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507241929.76UExdsw-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/iommu/amd/init.c:723:41: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected void * @@     got void [noderef] __iomem * @@
   drivers/iommu/amd/init.c:723:41: sparse:     expected void *
   drivers/iommu/amd/init.c:723:41: sparse:     got void [noderef] __iomem *
>> drivers/iommu/amd/init.c:723:41: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected void * @@     got void [noderef] __iomem * @@
   drivers/iommu/amd/init.c:723:41: sparse:     expected void *
   drivers/iommu/amd/init.c:723:41: sparse:     got void [noderef] __iomem *
>> drivers/iommu/amd/init.c:723:41: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected void * @@     got void [noderef] __iomem * @@
   drivers/iommu/amd/init.c:723:41: sparse:     expected void *
   drivers/iommu/amd/init.c:723:41: sparse:     got void [noderef] __iomem *

vim +723 drivers/iommu/amd/init.c

   707	
   708	static inline void *iommu_memremap(unsigned long paddr, size_t size)
   709	{
   710		phys_addr_t phys;
   711	
   712		if (!paddr)
   713			return NULL;
   714	
   715		/*
   716		 * Obtain true physical address in kdump kernel when SME is enabled.
   717		 * Currently, previous kernel with SME enabled and kdump kernel
   718		 * with SME support disabled is not supported.
   719		 */
   720		phys = __sme_clr(paddr);
   721	
   722		if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
 > 723			return ioremap_encrypted(phys, size);
   724		else
   725			return memremap(phys, size, MEMREMAP_WB);
   726	}
   727	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

