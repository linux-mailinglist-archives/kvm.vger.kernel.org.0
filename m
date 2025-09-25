Return-Path: <kvm+bounces-58717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A0ABB9DF7D
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:05:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDD1C3B73A1
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 08:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C9B26C3AE;
	Thu, 25 Sep 2025 08:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G8Z4RNBi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA0F2367BF;
	Thu, 25 Sep 2025 08:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758787502; cv=none; b=qhQt0Rd4OzbTPLC2BqGbrPUfQkCxOGgM5HueYfGuPKfcpusEVMeuteYS5y3jjoZBZx3WyZcJEdj7PKRRdfTDJP+CUqCIlJj1zS0Sr9AE0wcR5gD3VhkoUhuAyAkEWC+y/Nu3+gKKssYGuo8Xh7Qm+N1+BJYCdfOCo7F5PXeWm0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758787502; c=relaxed/simple;
	bh=rYyXxlBGjW+fW8RT9+6EcT7A+KojzwwNLk/C97s3Pds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TdeZR0YoWLqv1seNs7TW+3gxKTFI4upj8Eu+GDW+9LlDiF8aWzIwdzXS7ecPvZ7CAzG1F93ylzsUwEKa0k+DG3mWUhhwqkpNZZbkp+bI0qobTIR8T449f0pa0i5xp5e/xL45bAz8fUb1XMfjZlR+iYc3z1Mtem0yQ/xJFgqp7Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G8Z4RNBi; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758787501; x=1790323501;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rYyXxlBGjW+fW8RT9+6EcT7A+KojzwwNLk/C97s3Pds=;
  b=G8Z4RNBiLugMltDZELZbARWYvXwawYG4drTevN4pZi+q5E6VPuX812rS
   CxyLxKffh3FAol2tsGIbq46rborEwf4QYbUIdz6JZLukWGCg61b0lwqCD
   u5IpRhkQg9ZmLXbVNMZ3nZnx0jrVcb5YYlkiSh9xsagfczp2ud39jF5Ia
   9cyZOY45wLlXOesGaXULekoF6TQWhj2kaF6ksvAmlDWe1QxBeVk7yqq64
   YcLZtkO0M9Z31li+5bS+TvwlbQ3QPCOUM25cikW9FwPL+/a4XzyeF4cjo
   4tn4Goj85hHI2u5cMkdvmNPjPEKJp1VYZLRIS55GbbAKk/1rOdRGQzcg0
   Q==;
X-CSE-ConnectionGUID: 87FD3K1VSBCvRyva9OG8Qw==
X-CSE-MsgGUID: hBXM6XnIRkWFVI4t5jCXZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61045267"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61045267"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 01:05:00 -0700
X-CSE-ConnectionGUID: XbP/FV+3T+Ww+hmLOgDGFQ==
X-CSE-MsgGUID: mJYZrIEfRISVYJY4vFFgvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="178031281"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 25 Sep 2025 01:04:58 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v1gy9-000537-2C;
	Thu, 25 Sep 2025 08:04:51 +0000
Date: Thu, 25 Sep 2025 16:04:05 +0800
From: kernel test robot <lkp@intel.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, alex.williamson@redhat.com,
	helgaas@kernel.org, clg@redhat.com, alifm@linux.ibm.com,
	schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 08/10] vfio-pci/zdev: Add a device feature for error
 information
Message-ID: <202509251506.Z5Ov6pYQ-lkp@intel.com>
References: <20250924171628.826-9-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924171628.826-9-alifm@linux.ibm.com>

Hi Farhan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on pci/next]
[also build test WARNING on pci/for-linus awilliam-vfio/next s390/features linus/master v6.17-rc7]
[cannot apply to awilliam-vfio/for-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Farhan-Ali/PCI-Avoid-saving-error-values-for-config-space/20250925-012105
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git next
patch link:    https://lore.kernel.org/r/20250924171628.826-9-alifm%40linux.ibm.com
patch subject: [PATCH v4 08/10] vfio-pci/zdev: Add a device feature for error information
config: csky-randconfig-002-20250925 (https://download.01.org/0day-ci/archive/20250925/202509251506.Z5Ov6pYQ-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250925/202509251506.Z5Ov6pYQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509251506.Z5Ov6pYQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/vfio/pci/vfio_pci_config.c:29:
>> drivers/vfio/pci/vfio_pci_priv.h:106:12: warning: 'vfio_pci_zdev_feature_err' defined but not used [-Wunused-function]
     106 | static int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/vfio_pci_zdev_feature_err +106 drivers/vfio/pci/vfio_pci_priv.h

   105	
 > 106	static int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
   107					     void __user *arg, size_t argsz)
   108	{
   109		return -ENODEV;
   110	}
   111	#endif
   112	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

