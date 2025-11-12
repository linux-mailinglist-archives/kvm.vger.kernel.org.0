Return-Path: <kvm+bounces-62866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 88D2CC513A5
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 09:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AB8AB4F4328
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 08:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441142FD7DD;
	Wed, 12 Nov 2025 08:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jcH30y2b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAA52EE5FE;
	Wed, 12 Nov 2025 08:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762937617; cv=none; b=KtPUD+7d01fZf167RFN2ns+NEuSDm47gXVQZjka4RuxhSQa5K3ZtOO9Z02CtV9aW72k8OeXVYW0bsihwjWLgspZaobrExmQYKwVHdVp7sVR9ft56rwjXIazapsQCg+vKyxGkBKxyuQVlUDnfCfWX4VHcMawK3+S38rQKXGhK4HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762937617; c=relaxed/simple;
	bh=pjxiwBubEaNKJ/nTiFrobQwVMbkHpsPzm4BgKDwGVKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=avNEmiEdU2hHlZ7zN/EnhpezL/aRm2xuHIWykaYgOMkNF6m1b1uzNN26TU9GXqV7rih0OqIe6H9+D3WkcC6nMbk6A3KVSjcdhgSZgde5QwG4kIPismB4l1uPtoiN52kvdSoxxZQmaOO2cg53fdLxP30s9+pQ8fdxM5iDU8KbcgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jcH30y2b; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762937616; x=1794473616;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pjxiwBubEaNKJ/nTiFrobQwVMbkHpsPzm4BgKDwGVKU=;
  b=jcH30y2bU+/AroLaPL94zlPhhwBWGyuotdOjNfVIn9jQB8jjMr33IIMC
   VtMt98LWZDzPcpbbaY+Ip/bJkPOF0BYRtoskc+QElBKswJ7OTXzWdLR9P
   Md1x8k+wRKZxyB6JWkq/cjjnfRPGEQ5eSC0L0F4u1UvH6LWOcfK6ByeHa
   E3ZI4RhFhUNGglKhqNBYfmsRnVQMS+hR7z7kLZ8RkO83ZJwpJvrf9YAFk
   /SBkMusZH/qb/j8QzsigCo5ax6eT1nciAxvdHJ+Fu6FQtyGDiuwG3oA1B
   N/oxvic9fE9Cs/XPRF6OgXZcofS1Wm614zWhhmbiTg256UmVIbx+V+gXV
   Q==;
X-CSE-ConnectionGUID: JQyTiKh9RIq5yifbmQnsLw==
X-CSE-MsgGUID: rK1HTh3vRCWkFIyMaTcjtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="82392755"
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="82392755"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 00:53:35 -0800
X-CSE-ConnectionGUID: Ow3E/Gl7QD2RmMHthFmdWw==
X-CSE-MsgGUID: UDf+sN02Raek9Ap4NdIqig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="189011973"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 12 Nov 2025 00:53:29 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJ6bW-000434-1M;
	Wed, 12 Nov 2025 08:53:26 +0000
Date: Wed, 12 Nov 2025 16:52:42 +0800
From: kernel test robot <lkp@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org, afael@kernel.org,
	bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com,
	kevin.tian@intel.com
Cc: oe-kbuild-all@lists.linux.dev, will@kernel.org, robin.murphy@arm.com,
	lenb@kernel.org, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
	helgaas@kernel.org, etzhao1900@gmail.com
Subject: Re: [PATCH v5 3/5] iommu: Add iommu_driver_get_domain_for_dev()
 helper
Message-ID: <202511121645.Oi9e0lrt-lkp@intel.com>
References: <0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc@nvidia.com>

Hi Nicolin,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20251110]
[cannot apply to pci/next pci/for-linus awilliam-vfio/next awilliam-vfio/for-linus rafael-pm/linux-next rafael-pm/bleeding-edge linus/master v6.18-rc5 v6.18-rc4 v6.18-rc3 v6.18-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nicolin-Chen/iommu-Lock-group-mutex-in-iommu_deferred_attach/20251111-131520
base:   next-20251110
patch link:    https://lore.kernel.org/r/0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc%40nvidia.com
patch subject: [PATCH v5 3/5] iommu: Add iommu_driver_get_domain_for_dev() helper
config: microblaze-randconfig-r072-20251112 (https://download.01.org/0day-ci/archive/20251112/202511121645.Oi9e0lrt-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251112/202511121645.Oi9e0lrt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511121645.Oi9e0lrt-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/iommu/iommu.c:2229 function parameter 'dev' not described in 'iommu_get_domain_for_dev'
>> Warning: drivers/iommu/iommu.c:2250 function parameter 'dev' not described in 'iommu_driver_get_domain_for_dev'
>> Warning: drivers/iommu/iommu.c:2229 function parameter 'dev' not described in 'iommu_get_domain_for_dev'
>> Warning: drivers/iommu/iommu.c:2250 function parameter 'dev' not described in 'iommu_driver_get_domain_for_dev'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

