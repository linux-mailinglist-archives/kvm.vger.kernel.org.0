Return-Path: <kvm+bounces-63489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EBBD6C67AC5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9993A365B86
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 06:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F61B2DE70B;
	Tue, 18 Nov 2025 06:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XPsjrVM3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10422DCF4C;
	Tue, 18 Nov 2025 06:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763446373; cv=none; b=Faj/VjLlNzcMcBP5AUzGbbH3eDb1+kTk6WQKNq2Sb9ql7o9LRETtvoXtq2OZQlzSOu3qc5kXqP8YO10z38itFJU12VgPBUBsAza2WE5w/DUiL5cr8PoA5ZpBhlAUx+Bse21QQ+bThVmBSJYS9lN/SopAN2ZUFbeNf+HrUUdxur0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763446373; c=relaxed/simple;
	bh=Mi/FGY0AldYv8jIMCw/K8ZWAynugDfR6VbgvzYmnNLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OcpB9kPSwTkUHvNjmikKtKXD3PkMpH1+G2pQFUthNFgAGOJLKiGUjFDY3I65xlQfnJCkhQ6bNYGp8CR37oeaVAUpreU/dV7EweqBhoinVVC18LEeKnyOLqrQ/SAUX73sNNpaO/ec5lPcrptVwn299FQKD6o5acC/gyc7pbCMD0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XPsjrVM3; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763446371; x=1794982371;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mi/FGY0AldYv8jIMCw/K8ZWAynugDfR6VbgvzYmnNLI=;
  b=XPsjrVM3FwnBMAvPQRmH1mwoSHa4Im4pDtlLLeAko8kiQe7CQ6emnWqc
   qI6b2YaN6xvMrVU094gAPa1tQ5TEIzkgYiCa/r4Juzh1olOtqtFytrmq7
   nOktxfiXPjxjC35tMAyMI09NHkSdd2oiFosrphaIjwo3CAGr9JTpjmuJ6
   up6TmizfTcBHQikBtU8+k6PrV3heSUUhQJR3Bd1dzZu3MFp0y719onY9E
   YT8eEtjQvdn0jGrqUsCfVRta1VKErKxIGTHmnPRbpcR+j5NUd7rwTuQDr
   OPdI4xkF+SzhwM9yo3fzfpRyR5GBUwneFhTIAlGzGxSAnP4evqcplt+XS
   A==;
X-CSE-ConnectionGUID: OvycTDhORAWCQqtdZIYNJA==
X-CSE-MsgGUID: KBLNQSdDTxScVi7yNzkFVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="64460121"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="64460121"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 22:12:51 -0800
X-CSE-ConnectionGUID: 1Kcl6wRNQLeZvc8lnWZFog==
X-CSE-MsgGUID: nkUcfL4sSWurp79yFqKkTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190461208"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 17 Nov 2025 22:12:46 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vLExH-0001Nr-00;
	Tue, 18 Nov 2025 06:12:43 +0000
Date: Tue, 18 Nov 2025 14:12:16 +0800
From: kernel test robot <lkp@intel.com>
To: ankita@nvidia.com, jgg@ziepe.ca, yishaih@nvidia.com,
	skolothumtho@nvidia.com, kevin.tian@intel.com, alex@shazbot.org,
	aniketa@nvidia.com, vsethi@nvidia.com, mochs@nvidia.com
Cc: oe-kbuild-all@lists.linux.dev, Yunxiang.Li@amd.com, yi.l.liu@intel.com,
	zhangdongdong@eswincomputing.com, avihaih@nvidia.com,
	bhelgaas@google.com, peterx@redhat.com, pstanner@redhat.com,
	apopple@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiw@nvidia.com, danw@nvidia.com,
	dnigam@nvidia.com, kjaju@nvidia.com
Subject: Re: [PATCH v1 3/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Message-ID: <202511181317.hOMn5k0o-lkp@intel.com>
References: <20251117124159.3560-4-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117124159.3560-4-ankita@nvidia.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/next]
[also build test WARNING on awilliam-vfio/for-linus linus/master v6.18-rc6 next-20251118]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/ankita-nvidia-com/vfio-nvgrace-gpu-Use-faults-to-map-device-memory/20251117-205950
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20251117124159.3560-4-ankita%40nvidia.com
patch subject: [PATCH v1 3/6] vfio/nvgrace-gpu: Add support for huge pfnmap
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20251118/202511181317.hOMn5k0o-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251118/202511181317.hOMn5k0o-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511181317.hOMn5k0o-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/vfio/pci/nvgrace-gpu/main.c: In function 'nvgrace_gpu_aligned_devmem_size':
>> drivers/vfio/pci/nvgrace-gpu/main.c:179:7: warning: 'CONFIG_ARCH_SUPPORTS_PUD_PFNMAP' is not defined, evaluates to '0' [-Wundef]
     179 | #elif CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
         |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +179 drivers/vfio/pci/nvgrace-gpu/main.c

   174	
   175	static size_t nvgrace_gpu_aligned_devmem_size(size_t memlength)
   176	{
   177	#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
   178		return ALIGN(memlength, PMD_SIZE);
 > 179	#elif CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
   180		return ALIGN(memlength, PUD_SIZE);
   181	#endif
   182		return memlength;
   183	}
   184	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

