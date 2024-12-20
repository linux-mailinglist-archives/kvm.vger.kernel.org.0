Return-Path: <kvm+bounces-34258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 357A89F9B1D
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 21:23:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88ED816A13B
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 20:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E512236E8;
	Fri, 20 Dec 2024 20:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="atFDGkeH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF95221478
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734726196; cv=none; b=N6wb1R2goIVXk4A4dy+vn8GYvRKF0hdjZ2Sb36S57NbE0/v4g3R5bQdphuxWdnQyXtowPI7jiRpV7JclXsxDOSVJFLtitxuah4FIsUYF4iarIJmvw/UgsJKZGKvbAuhLc1HjTarVOLbfVDMUDxmaoVhV8uVPEGBbbZHzSC8KPJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734726196; c=relaxed/simple;
	bh=OiEnaYKVTru9CvGb8SDnTIaGyMxvjLzhjo7l20sAJN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trO+Y9fpgUtwiFzjtc+ga8hIL9gZD0smhv7BdcoNAuX9mdS1nmhbn/DSGS6L8fzJ4r84K54XJrPBfIufZliRF7tKg+nzd/mhHid1OX7pht8X1+XHHNJ1xe3THu3F+6t/3PCT404wKUp6x9u2O82jycNyLMaQB5cvXNgfz494eh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=atFDGkeH; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734726195; x=1766262195;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OiEnaYKVTru9CvGb8SDnTIaGyMxvjLzhjo7l20sAJN4=;
  b=atFDGkeHHNnoZ2v6ABiIv6DNVqeqtj7D31VsKEexTssn8ENH09CFkUZ+
   vprIGB6ZlhmGyP4ZWyTjaOZaDSLnbRFm1Fx9it0L2UnCihOYtopP0qcnf
   Sb1PxkzU9T4VDUbpoLg0YyfHNtrOCWwL7fbSLpA5FTd8RnXb9B/dIp7Yz
   yo2caTcpPf7DefcPNeP9Iw4BMZh+h55e4c0+lliDJt3muPM338NiF1tP9
   EGg4ApIlw7v/Az+i3O1f1+QltoleCjkuGEJl2YriSEwWW9uN3jhrLmW5C
   fLP7JHbFSJsnZFJ6ZLF5nOJjdYeiu0VBacx0YEzNTLyK9KtQBlWdEPHPO
   g==;
X-CSE-ConnectionGUID: Oip0XtQ3Tf2Vpul6U0RRXg==
X-CSE-MsgGUID: gfYS7rwDQ8iu3/0UXcYrRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="39220606"
X-IronPort-AV: E=Sophos;i="6.12,251,1728975600"; 
   d="scan'208";a="39220606"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 12:23:14 -0800
X-CSE-ConnectionGUID: YCDnzWfwS9qEmJAgJimJmQ==
X-CSE-MsgGUID: RBH11xyITEi/eokTGaxxPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99082474"
Received: from lkp-server01.sh.intel.com (HELO a46f226878e0) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 20 Dec 2024 12:23:12 -0800
Received: from kbuild by a46f226878e0 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tOjWf-0001eg-1g;
	Fri, 20 Dec 2024 20:23:09 +0000
Date: Sat, 21 Dec 2024 04:22:48 +0800
From: kernel test robot <lkp@intel.com>
To: Yunxiang Li <Yunxiang.Li@amd.com>, kvm@vger.kernel.org,
	alex.williamson@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kevin.tian@intel.com, yishaih@nvidia.com, ankita@nvidia.com,
	jgg@ziepe.ca, Yunxiang Li <Yunxiang.Li@amd.com>
Subject: Re: [PATCH 2/3] vfio/pci: refactor vfio_pci_bar_rw
Message-ID: <202412210450.yl9DrP8o-lkp@intel.com>
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
config: i386-buildonly-randconfig-004-20241220 (https://download.01.org/0day-ci/archive/20241221/202412210450.yl9DrP8o-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241221/202412210450.yl9DrP8o-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412210450.yl9DrP8o-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/vfio/pci/vfio_pci_rdwr.c:14:
   In file included from include/linux/pci.h:1650:
   In file included from include/linux/dmapool.h:14:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> drivers/vfio/pci/vfio_pci_rdwr.c:289:1: warning: unused label 'out' [-Wunused-label]
     289 | out:
         | ^~~~
   2 warnings generated.


vim +/out +289 drivers/vfio/pci/vfio_pci_rdwr.c

0d77ed3589ac054 Alex Williamson 2018-03-21  232  
536475109c82841 Max Gurtovoy    2021-08-26  233  ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
89e1f7d4c66d85f Alex Williamson 2012-07-31  234  			size_t count, loff_t *ppos, bool iswrite)
89e1f7d4c66d85f Alex Williamson 2012-07-31  235  {
89e1f7d4c66d85f Alex Williamson 2012-07-31  236  	struct pci_dev *pdev = vdev->pdev;
89e1f7d4c66d85f Alex Williamson 2012-07-31  237  	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
89e1f7d4c66d85f Alex Williamson 2012-07-31  238  	int bar = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
1378a17537c2699 Yunxiang Li     2024-12-12  239  	size_t x_start, x_end;
89e1f7d4c66d85f Alex Williamson 2012-07-31  240  	resource_size_t end;
906ee99dd2a5c81 Alex Williamson 2013-02-14  241  	void __iomem *io;
906ee99dd2a5c81 Alex Williamson 2013-02-14  242  	ssize_t done;
89e1f7d4c66d85f Alex Williamson 2012-07-31  243  
a13b64591747e8a Alex Williamson 2016-02-22  244  	if (pci_resource_start(pdev, bar))
89e1f7d4c66d85f Alex Williamson 2012-07-31  245  		end = pci_resource_len(pdev, bar);
a13b64591747e8a Alex Williamson 2016-02-22  246  	else
a13b64591747e8a Alex Williamson 2016-02-22  247  		return -EINVAL;
89e1f7d4c66d85f Alex Williamson 2012-07-31  248  
906ee99dd2a5c81 Alex Williamson 2013-02-14  249  	if (pos >= end)
89e1f7d4c66d85f Alex Williamson 2012-07-31  250  		return -EINVAL;
89e1f7d4c66d85f Alex Williamson 2012-07-31  251  
906ee99dd2a5c81 Alex Williamson 2013-02-14  252  	count = min(count, (size_t)(end - pos));
89e1f7d4c66d85f Alex Williamson 2012-07-31  253  
89e1f7d4c66d85f Alex Williamson 2012-07-31  254  	if (bar == PCI_ROM_RESOURCE) {
1378a17537c2699 Yunxiang Li     2024-12-12  255  		if (iswrite)
1378a17537c2699 Yunxiang Li     2024-12-12  256  			return -EINVAL;
906ee99dd2a5c81 Alex Williamson 2013-02-14  257  		/*
906ee99dd2a5c81 Alex Williamson 2013-02-14  258  		 * The ROM can fill less space than the BAR, so we start the
906ee99dd2a5c81 Alex Williamson 2013-02-14  259  		 * excluded range at the end of the actual ROM.  This makes
906ee99dd2a5c81 Alex Williamson 2013-02-14  260  		 * filling large ROM BARs much faster.
906ee99dd2a5c81 Alex Williamson 2013-02-14  261  		 */
89e1f7d4c66d85f Alex Williamson 2012-07-31  262  		io = pci_map_rom(pdev, &x_start);
1378a17537c2699 Yunxiang Li     2024-12-12  263  		if (!io)
1378a17537c2699 Yunxiang Li     2024-12-12  264  			return -ENOMEM;
89e1f7d4c66d85f Alex Williamson 2012-07-31  265  		x_end = end;
1378a17537c2699 Yunxiang Li     2024-12-12  266  
1378a17537c2699 Yunxiang Li     2024-12-12  267  		done = vfio_pci_core_do_io_rw(vdev, 1, io, buf, pos,
1378a17537c2699 Yunxiang Li     2024-12-12  268  					      count, x_start, x_end, 0);
1378a17537c2699 Yunxiang Li     2024-12-12  269  
1378a17537c2699 Yunxiang Li     2024-12-12  270  		pci_unmap_rom(pdev, io);
0d77ed3589ac054 Alex Williamson 2018-03-21  271  	} else {
1378a17537c2699 Yunxiang Li     2024-12-12  272  		done = vfio_pci_core_setup_barmap(vdev, bar);
1378a17537c2699 Yunxiang Li     2024-12-12  273  		if (done)
1378a17537c2699 Yunxiang Li     2024-12-12  274  			return done;
89e1f7d4c66d85f Alex Williamson 2012-07-31  275  
89e1f7d4c66d85f Alex Williamson 2012-07-31  276  		io = vdev->barmap[bar];
89e1f7d4c66d85f Alex Williamson 2012-07-31  277  
89e1f7d4c66d85f Alex Williamson 2012-07-31  278  		if (bar == vdev->msix_bar) {
89e1f7d4c66d85f Alex Williamson 2012-07-31  279  			x_start = vdev->msix_offset;
89e1f7d4c66d85f Alex Williamson 2012-07-31  280  			x_end = vdev->msix_offset + vdev->msix_size;
1378a17537c2699 Yunxiang Li     2024-12-12  281  		} else {
1378a17537c2699 Yunxiang Li     2024-12-12  282  			x_start = 0;
1378a17537c2699 Yunxiang Li     2024-12-12  283  			x_end = 0;
89e1f7d4c66d85f Alex Williamson 2012-07-31  284  		}
89e1f7d4c66d85f Alex Williamson 2012-07-31  285  
1378a17537c2699 Yunxiang Li     2024-12-12  286  		done = vfio_pci_core_do_io_rw(vdev, pci_resource_flags(pdev, bar) & IORESOURCE_MEM, io, buf, pos,
bc93b9ae0151ae5 Alex Williamson 2020-08-17  287  				      count, x_start, x_end, iswrite);
1378a17537c2699 Yunxiang Li     2024-12-12  288  	}
abafbc551fddede Alex Williamson 2020-04-22 @289  out:
1378a17537c2699 Yunxiang Li     2024-12-12  290  	if (done > 0)
1378a17537c2699 Yunxiang Li     2024-12-12  291  		*ppos += done;
906ee99dd2a5c81 Alex Williamson 2013-02-14  292  	return done;
89e1f7d4c66d85f Alex Williamson 2012-07-31  293  }
84237a826b261de Alex Williamson 2013-02-18  294  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

