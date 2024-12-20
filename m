Return-Path: <kvm+bounces-34215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1589F925A
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 13:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5966F1897F05
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 12:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F65215793;
	Fri, 20 Dec 2024 12:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H4iB2OAr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C4E2153C5
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 12:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734698244; cv=none; b=sBSg+KN/VHeA/1DdSOgnUPoRtvH5Pl8ZqViqcYKRfpcbKQMDxU+sC3XlnqryvBfNNBItiJZXpz4IXy0hHFUf2NI8fNZGHspoF+ibCpFaVaCGrn5V5IT9PLDr9XdPeMGiAKysZbHbfGKpGLH2w3hUkC3bKEK/eOD6+0WoiDHsWB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734698244; c=relaxed/simple;
	bh=zBvA3EztS0Oc7nfkMBWGnmh+NQXN4hNClTFmx4wxEgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPpRiKKacSvnH021gFoW6R81LsrZx8/HyBwtUKQndJt555sQamtDXby76hlmUXPrNwMR0eCSNsvPDKsYu9q7/OvWp4T2G21Fs/JyNKqT8j5iIMuiM0vovylJMJc4rxdDQw16Elu6DGB86yQwtPH+DCl6+GEPJN2Z6TA9oY4gcl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H4iB2OAr; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734698241; x=1766234241;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zBvA3EztS0Oc7nfkMBWGnmh+NQXN4hNClTFmx4wxEgE=;
  b=H4iB2OAr+0neT+FHLRgiMnoZrgxuoPXWZPnqPW07NXPzdkZvbIxkRFwJ
   CUrH1jRXyJZRaD9No+dT2MybTvTaEL3sPg4XHK2WZS7+DWpRp29rN/1yN
   Bc09jpBPh7vKRlH0rRtDbhsoBhvFzudq2gDfXPYpSbfWqVI8DrkNyhhuN
   CYNWq8Pb7I/R2eNl1WAia95Gko22KHk+fyu3awFX+dVIamXwVRmDMYCPC
   qKTKI4pbZ27ruXxx0EL4S8BTC6FN7Wt8PQeH4G8PxEV9FJVyZ7uyf3oko
   pg6sTtkSamPtNMX/pDC1s/fLofr3sPdgdp4RqWmlxZU89H9dnz2xzAcdK
   w==;
X-CSE-ConnectionGUID: 6huID16MRnik6gUUdxrZaA==
X-CSE-MsgGUID: CVuGAZrETBW/1Zg2bVisDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="52650728"
X-IronPort-AV: E=Sophos;i="6.12,250,1728975600"; 
   d="scan'208";a="52650728"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 04:37:21 -0800
X-CSE-ConnectionGUID: HirqjVbTQ9+IbdRLhll5AA==
X-CSE-MsgGUID: aiQLDMY9QAWFpPE3kt4YXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103121750"
Received: from lkp-server01.sh.intel.com (HELO a46f226878e0) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 20 Dec 2024 04:37:19 -0800
Received: from kbuild by a46f226878e0 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tOcFp-00018l-09;
	Fri, 20 Dec 2024 12:37:17 +0000
Date: Fri, 20 Dec 2024 20:36:25 +0800
From: kernel test robot <lkp@intel.com>
To: Yunxiang Li <Yunxiang.Li@amd.com>, kvm@vger.kernel.org,
	alex.williamson@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, kevin.tian@intel.com, yishaih@nvidia.com,
	ankita@nvidia.com, jgg@ziepe.ca, Yunxiang Li <Yunxiang.Li@amd.com>
Subject: Re: [PATCH 2/3] vfio/pci: refactor vfio_pci_bar_rw
Message-ID: <202412202034.alL3D6CO-lkp@intel.com>
References: <20241212205050.5737-2-Yunxiang.Li@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212205050.5737-2-Yunxiang.Li@amd.com>

Hi Yunxiang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/next]
[also build test WARNING on awilliam-vfio/for-linus linus/master v6.13-rc3 next-20241220]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunxiang-Li/vfio-pci-refactor-vfio_pci_bar_rw/20241213-045257
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20241212205050.5737-2-Yunxiang.Li%40amd.com
patch subject: [PATCH 2/3] vfio/pci: refactor vfio_pci_bar_rw
config: s390-randconfig-001-20241220 (https://download.01.org/0day-ci/archive/20241220/202412202034.alL3D6CO-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241220/202412202034.alL3D6CO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412202034.alL3D6CO-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/vfio/pci/vfio_pci_rdwr.c: In function 'vfio_pci_bar_rw':
>> drivers/vfio/pci/vfio_pci_rdwr.c:289:1: warning: label 'out' defined but not used [-Wunused-label]
     289 | out:
         | ^~~


vim +/out +289 drivers/vfio/pci/vfio_pci_rdwr.c

0d77ed3589ac05 Alex Williamson 2018-03-21  232  
536475109c8284 Max Gurtovoy    2021-08-26  233  ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
89e1f7d4c66d85 Alex Williamson 2012-07-31  234  			size_t count, loff_t *ppos, bool iswrite)
89e1f7d4c66d85 Alex Williamson 2012-07-31  235  {
89e1f7d4c66d85 Alex Williamson 2012-07-31  236  	struct pci_dev *pdev = vdev->pdev;
89e1f7d4c66d85 Alex Williamson 2012-07-31  237  	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
89e1f7d4c66d85 Alex Williamson 2012-07-31  238  	int bar = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
1378a17537c269 Yunxiang Li     2024-12-12  239  	size_t x_start, x_end;
89e1f7d4c66d85 Alex Williamson 2012-07-31  240  	resource_size_t end;
906ee99dd2a5c8 Alex Williamson 2013-02-14  241  	void __iomem *io;
906ee99dd2a5c8 Alex Williamson 2013-02-14  242  	ssize_t done;
89e1f7d4c66d85 Alex Williamson 2012-07-31  243  
a13b64591747e8 Alex Williamson 2016-02-22  244  	if (pci_resource_start(pdev, bar))
89e1f7d4c66d85 Alex Williamson 2012-07-31  245  		end = pci_resource_len(pdev, bar);
a13b64591747e8 Alex Williamson 2016-02-22  246  	else
a13b64591747e8 Alex Williamson 2016-02-22  247  		return -EINVAL;
89e1f7d4c66d85 Alex Williamson 2012-07-31  248  
906ee99dd2a5c8 Alex Williamson 2013-02-14  249  	if (pos >= end)
89e1f7d4c66d85 Alex Williamson 2012-07-31  250  		return -EINVAL;
89e1f7d4c66d85 Alex Williamson 2012-07-31  251  
906ee99dd2a5c8 Alex Williamson 2013-02-14  252  	count = min(count, (size_t)(end - pos));
89e1f7d4c66d85 Alex Williamson 2012-07-31  253  
89e1f7d4c66d85 Alex Williamson 2012-07-31  254  	if (bar == PCI_ROM_RESOURCE) {
1378a17537c269 Yunxiang Li     2024-12-12  255  		if (iswrite)
1378a17537c269 Yunxiang Li     2024-12-12  256  			return -EINVAL;
906ee99dd2a5c8 Alex Williamson 2013-02-14  257  		/*
906ee99dd2a5c8 Alex Williamson 2013-02-14  258  		 * The ROM can fill less space than the BAR, so we start the
906ee99dd2a5c8 Alex Williamson 2013-02-14  259  		 * excluded range at the end of the actual ROM.  This makes
906ee99dd2a5c8 Alex Williamson 2013-02-14  260  		 * filling large ROM BARs much faster.
906ee99dd2a5c8 Alex Williamson 2013-02-14  261  		 */
89e1f7d4c66d85 Alex Williamson 2012-07-31  262  		io = pci_map_rom(pdev, &x_start);
1378a17537c269 Yunxiang Li     2024-12-12  263  		if (!io)
1378a17537c269 Yunxiang Li     2024-12-12  264  			return -ENOMEM;
89e1f7d4c66d85 Alex Williamson 2012-07-31  265  		x_end = end;
1378a17537c269 Yunxiang Li     2024-12-12  266  
1378a17537c269 Yunxiang Li     2024-12-12  267  		done = vfio_pci_core_do_io_rw(vdev, 1, io, buf, pos,
1378a17537c269 Yunxiang Li     2024-12-12  268  					      count, x_start, x_end, 0);
1378a17537c269 Yunxiang Li     2024-12-12  269  
1378a17537c269 Yunxiang Li     2024-12-12  270  		pci_unmap_rom(pdev, io);
0d77ed3589ac05 Alex Williamson 2018-03-21  271  	} else {
1378a17537c269 Yunxiang Li     2024-12-12  272  		done = vfio_pci_core_setup_barmap(vdev, bar);
1378a17537c269 Yunxiang Li     2024-12-12  273  		if (done)
1378a17537c269 Yunxiang Li     2024-12-12  274  			return done;
89e1f7d4c66d85 Alex Williamson 2012-07-31  275  
89e1f7d4c66d85 Alex Williamson 2012-07-31  276  		io = vdev->barmap[bar];
89e1f7d4c66d85 Alex Williamson 2012-07-31  277  
89e1f7d4c66d85 Alex Williamson 2012-07-31  278  		if (bar == vdev->msix_bar) {
89e1f7d4c66d85 Alex Williamson 2012-07-31  279  			x_start = vdev->msix_offset;
89e1f7d4c66d85 Alex Williamson 2012-07-31  280  			x_end = vdev->msix_offset + vdev->msix_size;
1378a17537c269 Yunxiang Li     2024-12-12  281  		} else {
1378a17537c269 Yunxiang Li     2024-12-12  282  			x_start = 0;
1378a17537c269 Yunxiang Li     2024-12-12  283  			x_end = 0;
89e1f7d4c66d85 Alex Williamson 2012-07-31  284  		}
89e1f7d4c66d85 Alex Williamson 2012-07-31  285  
1378a17537c269 Yunxiang Li     2024-12-12  286  		done = vfio_pci_core_do_io_rw(vdev, pci_resource_flags(pdev, bar) & IORESOURCE_MEM, io, buf, pos,
bc93b9ae0151ae Alex Williamson 2020-08-17  287  				      count, x_start, x_end, iswrite);
1378a17537c269 Yunxiang Li     2024-12-12  288  	}
abafbc551fdded Alex Williamson 2020-04-22 @289  out:
1378a17537c269 Yunxiang Li     2024-12-12  290  	if (done > 0)
1378a17537c269 Yunxiang Li     2024-12-12  291  		*ppos += done;
906ee99dd2a5c8 Alex Williamson 2013-02-14  292  	return done;
89e1f7d4c66d85 Alex Williamson 2012-07-31  293  }
84237a826b261d Alex Williamson 2013-02-18  294  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

