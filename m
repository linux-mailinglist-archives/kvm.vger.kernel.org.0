Return-Path: <kvm+bounces-51894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBDAAFE1F2
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A56B1C41297
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B302309BE;
	Wed,  9 Jul 2025 08:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nhPt3EcG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548A02222D0;
	Wed,  9 Jul 2025 08:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752048426; cv=none; b=rhDxtPTctKOX+CGeHoAtP5qncJsJWap2n6zlB5MAVvq9YoioBC5d33Mp7jFtdb98WGG1nnhz1OHb6r4+9Eq5EQwuRFj9RufnfYKpSwJlVTXsqe3h0IV9vKFCYCeHa5VLBZFasZTbnp39lvwZx1RurhdoZNoI6j2H4i/vLTcD2u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752048426; c=relaxed/simple;
	bh=qHFlp0Eymzpq0DGn/ABKDHy5ssBB/JtPZafxiGG8/jk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KXXc2Z6qTcLrXxa+QlLYvFSMGpAkWwfYSsVyPwmZkp9yQRI7AHDFrAD9zLn07kIr2gIFkenQPNCEmzKZ9/wrmrprM6UkuKU9t/eCLfQmVrn1PzmBF7yeDnt/04MpGr5uqtqBqON6D5NPHEFv1Bably6Or7UGfhF+OQIMRSodO+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nhPt3EcG; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752048423; x=1783584423;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=qHFlp0Eymzpq0DGn/ABKDHy5ssBB/JtPZafxiGG8/jk=;
  b=nhPt3EcGIFWTQDTwQdQzaM3B03qRrMHiFzj0gDTT5lC6seAVLyzCemzD
   2HHn6whhbIJAoxhQMkBzizoFK/ZN0qYyKTZ5f15+wcP2OuT8QECF/hDq/
   bFLqCS/jGIftRmz8wvD6tURrOnQIfllLMk6ipl6rhgWIgSxkP8dfbWNW/
   d69KGR1YRUjyEvAPwHP6TAsQ0yrKUYRMDN0WZrkcwWw2ZVG7oB3bSeL5r
   phfog63q0VpasWgzg+YHvHWd5T73FBOMMcpOQ+INNftAzz2Jemyl9N95C
   uAGe26apIyyw3ctXPCi5VlKuGS+kRITBr5joLGSpN0bfJzvD1N55UC1SG
   w==;
X-CSE-ConnectionGUID: GgXhjHteSgOHBJQhQOpXCg==
X-CSE-MsgGUID: pak3XXKeQwOkByDRB2IXYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="58106220"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="58106220"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 01:07:03 -0700
X-CSE-ConnectionGUID: nKnaAaCNQLKlfhQL+i2/ag==
X-CSE-MsgGUID: itnNVE9jRp+vu1HGp5yBlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="156043916"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 09 Jul 2025 01:07:01 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uZPpT-0003HZ-00;
	Wed, 09 Jul 2025 08:06:59 +0000
Date: Wed, 9 Jul 2025 16:06:50 +0800
From: kernel test robot <lkp@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org
Subject: [mst-vhost:vhost 4/8] include/linux/pci.h:2738:7: error: call to
 undeclared function 'pci_device_is_present'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202507091645.aPGUJH6X-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   97d5f469f45a2312a124376fd6fa368ef8419dff
commit: b7468115b6045e555aa8a8f2fa327c1c073fc6df [4/8] pci: report surprise removal event
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20250709/202507091645.aPGUJH6X-lkp@intel.com/config)
compiler: clang version 20.1.7 (https://github.com/llvm/llvm-project 6146a88f60492b520a36f8f8f3231e15f3cc6082)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250709/202507091645.aPGUJH6X-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507091645.aPGUJH6X-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from kernel/dma/direct.c:16:
   In file included from include/linux/pci-p2pdma.h:14:
>> include/linux/pci.h:2738:7: error: call to undeclared function 'pci_device_is_present'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2738 |         if (!pci_device_is_present(pdev))
         |              ^
   include/linux/pci.h:2738:7: note: did you mean 'pci_dev_present'?
   include/linux/pci.h:2042:19: note: 'pci_dev_present' declared here
    2042 | static inline int pci_dev_present(const struct pci_device_id *ids)
         |                   ^
   kernel/dma/direct.c:148:20: warning: shift count >= width of type [-Wshift-count-overflow]
     148 |                     phys_limit < DMA_BIT_MASK(64) &&
         |                                  ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:73:54: note: expanded from macro 'DMA_BIT_MASK'
      73 | #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
         |                                                      ^ ~~~
   1 warning and 1 error generated.


vim +/pci_device_is_present +2738 include/linux/pci.h

  2722	
  2723	/*
  2724	 * Caller must initialize @pdev->disconnect_work before invoking this.
  2725	 * The work function must run and check pci_test_and_clear_disconnect_enable.
  2726	 * Note that device can go away right after this call.
  2727	 */
  2728	static inline void pci_set_disconnect_work(struct pci_dev *pdev)
  2729	{
  2730		/* Make sure WQ has been initialized already */
  2731		smp_wmb();
  2732	
  2733		WRITE_ONCE(pdev->disconnect_work_enable, 0x1);
  2734	
  2735		/* check the device did not go away meanwhile. */
  2736		mb();
  2737	
> 2738		if (!pci_device_is_present(pdev))
  2739			schedule_work(&pdev->disconnect_work);
  2740	}
  2741	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

