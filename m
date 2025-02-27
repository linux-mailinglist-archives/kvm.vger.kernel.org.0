Return-Path: <kvm+bounces-39620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D86F5A4872C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 19:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 457E518805CC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 18:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C811F583D;
	Thu, 27 Feb 2025 18:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eZry2d5r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858401B85D1;
	Thu, 27 Feb 2025 18:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740679275; cv=none; b=oQsELHG8eJt/7NJZdOCrAU6JMMf898xNIUrLO/oj0mjC9alh90ICGjAv8G/C7v+npbROerys3UBb339a/DlIesD2WIb/bm/RsE+jZqcGIDGjm6qr0XqLiUO6i1Dxy8y0urDXFFUuBc03HXGVfX7Kwo8rVk40bfyRHuMeSQWDmbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740679275; c=relaxed/simple;
	bh=3XVFYbbjNamhUDzQJ1R+kHQaWqC9SxhecKBhmHXEdwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bhDE+IyseBxRmh+2KjXFrt3zxDRcgIIC/b8B4uCbeZY4cn101iLFZlJybsMHU6wjuKpmdHCBYDMWD+25NlbAjUnykKRTGvkJ45/w5YWJHtOXBt/20l4M6faxWx/OvOrnlwAGvaV3SYqIuF7nBKUuMObxdiPbZj5qJNBKbKhn2+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eZry2d5r; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740679274; x=1772215274;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3XVFYbbjNamhUDzQJ1R+kHQaWqC9SxhecKBhmHXEdwU=;
  b=eZry2d5rOkKoFkLbFYbMKMutmkUP+SlhezKMdtU0c1VhCCmdCZlpGcsR
   7bduBeUsMoaHBhkAp5nHfm++UKIIYsqzL74AUYlLhAkJpyJTiSBElu0GX
   y0Im5q3vfzEDj3aBPehd6b4nqTI+dGjaFHeoSxPXvr6qCpB5Dde30kvqP
   zgepH6Is5Z3EzQ3DyuqC1jPzkhmKTMTSdzWXd24IkQ9YniZtE1Fsfx2Tv
   RYJwZ+iU7ZkCiN/xFOa9jKui4GVFmmeGLyX70n32v6ulIUJh5buYT3ikT
   VEDtWbdvJfl0ccNKDAzmWWBFQooAiPSNNAzadnbQQrzGCa3lpeTW3AeGf
   w==;
X-CSE-ConnectionGUID: 0XzKtTjZSSCzS6Nb8mOuLQ==
X-CSE-MsgGUID: vYlRsMUbTDKBpFooupSwDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="41716243"
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="41716243"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 10:01:13 -0800
X-CSE-ConnectionGUID: T7NanKZkRee0egOgOybplw==
X-CSE-MsgGUID: /jHVGTofTdOOaYGs+DVVvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="122222209"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 27 Feb 2025 10:01:10 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tniC4-000DoM-1b;
	Thu, 27 Feb 2025 18:01:08 +0000
Date: Fri, 28 Feb 2025 02:00:40 +0800
From: kernel test robot <lkp@intel.com>
To: Longfang Liu <liulongfang@huawei.com>, alex.williamson@redhat.com,
	jgg@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	jonathan.cameron@huawei.com
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
	liulongfang@huawei.com
Subject: Re: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Message-ID: <202502280126.kuSX5nFF-lkp@intel.com>
References: <20250225062757.19692-2-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225062757.19692-2-liulongfang@huawei.com>

Hi Longfang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/next]
[also build test WARNING on awilliam-vfio/for-linus linus/master v6.14-rc4 next-20250227]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Longfang-Liu/hisi_acc_vfio_pci-fix-XQE-dma-address-error/20250225-143347
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20250225062757.19692-2-liulongfang%40huawei.com
patch subject: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20250228/202502280126.kuSX5nFF-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250228/202502280126.kuSX5nFF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502280126.kuSX5nFF-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'vf_qm_version_check':
>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:357:17: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
     357 |                 if (vf_data->major_ver < ACC_DRV_MAJOR_VER ||
         |                 ^~
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:360:25: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
     360 |                         return -EINVAL;
         |                         ^~~~~~
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'vf_qm_get_match_data':
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:448:30: error: 'ACC_DRV_MAR' undeclared (first use in this function)
     448 |         vf_data->major_ver = ACC_DRV_MAR;
         |                              ^~~~~~~~~~~
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:448:30: note: each undeclared identifier is reported only once for each function it appears in
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:449:30: error: 'ACC_DRV_MIN' undeclared (first use in this function)
     449 |         vf_data->minor_ver = ACC_DRV_MIN;
         |                              ^~~~~~~~~~~


vim +/if +357 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c

   352	
   353	static int vf_qm_version_check(struct acc_vf_data *vf_data, struct device *dev)
   354	{
   355		switch (vf_data->acc_magic) {
   356		case ACC_DEV_MAGIC_V2:
 > 357			if (vf_data->major_ver < ACC_DRV_MAJOR_VER ||
   358			    vf_data->minor_ver < ACC_DRV_MINOR_VER)
   359				dev_info(dev, "migration driver version not match!\n");
   360				return -EINVAL;
   361			break;
   362		case ACC_DEV_MAGIC_V1:
   363			/* Correct dma address */
   364			vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
   365			vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
   366			vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
   367			vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
   368			vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
   369			vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
   370			break;
   371		default:
   372			return -EINVAL;
   373		}
   374	
   375		return 0;
   376	}
   377	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

