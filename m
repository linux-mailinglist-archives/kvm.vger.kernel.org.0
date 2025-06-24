Return-Path: <kvm+bounces-50517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6142EAE6C65
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:24:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18C52188C472
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA6D32E1757;
	Tue, 24 Jun 2025 16:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cTtD2Dfp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E8F2D027E;
	Tue, 24 Jun 2025 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750782226; cv=none; b=rW/C4oYlTSR5wNatRsee9u18KTohrpSzGqXmbaJC0lsh6dpuTlytMLg8VDvAP5vfSZReJooNhPmSKESbCqSA8adfDBb0EiDD/9wYw2r7gFIrjxuPJDfGdOB2gHq7NJx023bCrmAQ0dRR+fUHhOYoKJUT8njDCtPjUNd0JKEkYWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750782226; c=relaxed/simple;
	bh=6CwxraP4Nk21dQLMx1bzCYs58zAEvS3CQxOQvMnWGEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U0DGKspf33QVPZL870a92e2ssvkcfoGgJrcukXAYlM5r2s6niLK0Mvh42tz6PaQz6YsrCOWAGTkre9C4sKHjOVC7Si4GYaVA5sBAqGzCjKiBqHrBq1ZWbHmZTc5msTYXaHwbv4qpn+1+Oh3CfkkaZJAqkrYVadPUqAR/Cm0G7h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cTtD2Dfp; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750782224; x=1782318224;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6CwxraP4Nk21dQLMx1bzCYs58zAEvS3CQxOQvMnWGEM=;
  b=cTtD2DfpAbz0JlIJLi9ogwmok9K1R31D5BkLUuuOx89rPWJbt7QFZhd1
   gyEM+XR6l9Cpqe9z/NpsDVxoEVcl+AR5DfAjH9QJiYT3UxsOH2JSCkAiR
   6CRjzuAfMvvsKUc5M+s9R0XcVS4oq7ixGsV+d80vsBfL3WC0iaQeq/MSC
   pWVAYnxm8/Z0JIJgi5Quh/nQZSn09dzK6AIHowbyITRyQ93pbwfPvyuiz
   xKOLqN6KT+LdRL8I3Y5wuKsf5S8/h1pne1Cxl7tiEpMG9124+SOtdRVYZ
   A0oIrnkCJMvCNjSL5gK7Q5lEUxKS3hKlF2YJoTIoUKQTyR/WBKcG4/1wY
   Q==;
X-CSE-ConnectionGUID: EmjVh3UbQEWgF9SPm0D+kw==
X-CSE-MsgGUID: tEmZEm3iRWS/GBDeBaKk1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="52262297"
X-IronPort-AV: E=Sophos;i="6.16,262,1744095600"; 
   d="scan'208";a="52262297"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 09:23:44 -0700
X-CSE-ConnectionGUID: tXzXY+Q7SPS5urIU6iDK+A==
X-CSE-MsgGUID: DMhHuhEOS2uHageWFbJ6dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,262,1744095600"; 
   d="scan'208";a="189142723"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 24 Jun 2025 09:23:42 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uU6Qs-000SJq-2L;
	Tue, 24 Jun 2025 16:23:38 +0000
Date: Wed, 25 Jun 2025 00:23:03 +0800
From: kernel test robot <lkp@intel.com>
To: lizhe.67@bytedance.com, alex.williamson@redhat.com, jgg@ziepe.ca,
	david@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, peterx@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, lizhe.67@bytedance.com
Subject: Re: [PATCH v5 1/3] vfio/type1: batch vfio_find_vpfn() in function
 vfio_unpin_pages_remote()
Message-ID: <202506250037.VfdBAPP3-lkp@intel.com>
References: <20250620032344.13382-2-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620032344.13382-2-lizhe.67@bytedance.com>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on awilliam-vfio/for-linus linus/master v6.16-rc3 next-20250624]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/lizhe-67-bytedance-com/vfio-type1-batch-vfio_find_vpfn-in-function-vfio_unpin_pages_remote/20250620-112605
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20250620032344.13382-2-lizhe.67%40bytedance.com
patch subject: [PATCH v5 1/3] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20250625/202506250037.VfdBAPP3-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250625/202506250037.VfdBAPP3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506250037.VfdBAPP3-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/vfio/vfio_iommu_type1.c: In function 'vfio_unpin_pages_remote':
>> drivers/vfio/vfio_iommu_type1.c:738:37: error: implicit declaration of function 'vpfn_pages'; did you mean 'vma_pages'? [-Werror=implicit-function-declaration]
     738 |         long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
         |                                     ^~~~~~~~~~
         |                                     vma_pages
   cc1: some warnings being treated as errors


vim +738 drivers/vfio/vfio_iommu_type1.c

   733	
   734	static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
   735					    unsigned long pfn, unsigned long npage,
   736					    bool do_accounting)
   737	{
 > 738		long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
   739		long i;
   740	
   741		for (i = 0; i < npage; i++)
   742			if (put_pfn(pfn++, dma->prot))
   743				unlocked++;
   744	
   745		if (do_accounting)
   746			vfio_lock_acct(dma, locked - unlocked, true);
   747	
   748		return unlocked;
   749	}
   750	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

