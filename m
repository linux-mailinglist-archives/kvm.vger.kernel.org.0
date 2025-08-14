Return-Path: <kvm+bounces-54650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0C0B25DE2
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 09:47:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EA115C2ECF
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 07:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CDA285053;
	Thu, 14 Aug 2025 07:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kKCK9wZH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EF7286D7C;
	Thu, 14 Aug 2025 07:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755157455; cv=none; b=KPhd+PWqpMIMA5K23Tiqs3r14c15Nnpdxo3FRkQOUjENgLZSK0WD7KdQ9ngdFkjC/h6C8+hq/nqk1G17wThTAhy1Kd+3sCu6Sus65DQonK19Sh2Kfbow+5naR06d0MT35rH20kHabwsGx3uX9BJ5zL6dkXfjmTF486dBSb63zYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755157455; c=relaxed/simple;
	bh=blkHOHEfczNkc2vt5BMxds3HfRRJSuQ39S+5rHDxB+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FzA+oQkA3kal0aZphJGEvh/TTfKQ2GV394ZkwbiaSCJK01+J1HMlG1vI0u4dGndwzr81tHKZnt5XQbiJs6TkCjeVleDgZkKavdlD6ih3M9fHSL3eF+JVKy9kpU4zxmDlDWJlcuNcAHs1mAYQc5PJGXtIrCnGhKK/f/BSGG5EdOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kKCK9wZH; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755157454; x=1786693454;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=blkHOHEfczNkc2vt5BMxds3HfRRJSuQ39S+5rHDxB+g=;
  b=kKCK9wZHaTHgd8QtS/tzmypEar2nTER7jUhai+ZtGdF8lTbnuxATBFse
   TncjMd6JmARnDk0x9PwLBTRmojyE1JaziJEuq6ijIF08NJEjk7jq1uDx9
   Joc5aM1W/kb7DiD6H3+NrU+dHrsWyPKZU9qZuQrC6SYk3Fqf2ssZCXstF
   nGP3swTQMBt5lomiFaHrP/T3ySj1aaTYXMEnbj+KR+bl9/9R9VM44RECd
   mlSPoRyp1hxF5CRmUIyXvgmISzuOwyjtDD6rgPVwBE112lM46/4EcbvtY
   3CT7R1T4L2l5COqvbz4frpWzPNFIurL69QYmtXJSSRyKNdWz28GnFMjJG
   w==;
X-CSE-ConnectionGUID: 2oUbN6+4TuORtL1d2mCoMg==
X-CSE-MsgGUID: +Asxgz5gQIGJBuoAl5UhUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="74918024"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="74918024"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:44:14 -0700
X-CSE-ConnectionGUID: 1yKr6sy4QamA0+e78ukiIQ==
X-CSE-MsgGUID: 9p35hw8OSp2btYpLGtKG4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166677201"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 14 Aug 2025 00:44:11 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umSd6-000Aim-2n;
	Thu, 14 Aug 2025 07:44:08 +0000
Date: Thu, 14 Aug 2025 15:42:40 +0800
From: kernel test robot <lkp@intel.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, schnelle@linux.ibm.com,
	mjrosato@linux.ibm.com, alifm@linux.ibm.com,
	alex.williamson@redhat.com
Subject: Re: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific function
 reset for zPCI
Message-ID: <202508141518.Z82dHhVu-lkp@intel.com>
References: <20250813170821.1115-6-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813170821.1115-6-alifm@linux.ibm.com>

Hi Farhan,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on s390/features linus/master v6.17-rc1 next-20250814]
[cannot apply to kvms390/next awilliam-vfio/for-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Farhan-Ali/s390-pci-Restore-airq-unconditionally-for-the-zPCI-device/20250814-012243
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20250813170821.1115-6-alifm%40linux.ibm.com
patch subject: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific function reset for zPCI
config: csky-randconfig-002-20250814 (https://download.01.org/0day-ci/archive/20250814/202508141518.Z82dHhVu-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250814/202508141518.Z82dHhVu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508141518.Z82dHhVu-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from drivers/vfio/pci/vfio_pci_core.c:36:
>> drivers/vfio/pci/vfio_pci_priv.h:104:5: warning: no previous prototype for 'vfio_pci_zdev_reset' [-Wmissing-prototypes]
     104 | int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
         |     ^~~~~~~~~~~~~~~~~~~
--
   csky-linux-ld: drivers/vfio/pci/vfio_pci_intrs.o: in function `vfio_pci_zdev_reset':
>> drivers/vfio/pci/vfio_pci_priv.h:105: multiple definition of `vfio_pci_zdev_reset'; drivers/vfio/pci/vfio_pci_core.o:(.text+0x1a6c): first defined here
   csky-linux-ld: drivers/vfio/pci/vfio_pci_rdwr.o: in function `vfio_pci_zdev_reset':
>> drivers/vfio/pci/vfio_pci_priv.h:105: multiple definition of `vfio_pci_zdev_reset'; drivers/vfio/pci/vfio_pci_core.o:(.text+0x1a6c): first defined here
   csky-linux-ld: drivers/vfio/pci/vfio_pci_config.o: in function `vfio_pci_zdev_reset':
   (.text+0x1964): multiple definition of `vfio_pci_zdev_reset'; drivers/vfio/pci/vfio_pci_core.o:(.text+0x1a6c): first defined here


vim +105 drivers/vfio/pci/vfio_pci_priv.h

   101	
   102	static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
   103	{}
 > 104	int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
 > 105	{
   106		return -ENODEV;
   107	}
   108	#endif
   109	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

