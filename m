Return-Path: <kvm+bounces-15896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 609F28B1DDE
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 11:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD14FB27C8B
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 09:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B5812AACC;
	Thu, 25 Apr 2024 09:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nja5vq31"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEC4129E76;
	Thu, 25 Apr 2024 09:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714036856; cv=none; b=aovM4AKbnbX5DMPs686SQGVjaq/WRuNCU0SzJ7aha+PN1olV1O4+vf90EABYzHucPofwB93/2rsMhJsufR+82nXTiE/pOGcmLhWJbIynfHRZOks2aNSnapIH7YZNDIsIfmRC5Y/UC4Af/HamMjt+R3VBj8rF8S1ChuhYRoiZIFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714036856; c=relaxed/simple;
	bh=56+KNS01PCOjWwYjwjaGsvb46v0Ao5OptS1cbXOHyss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qY+k/emY6l2N/NovTDhCp9TVBH32apxUWhBl+ulfegL7HJBi0o+LZ62ybSOcmf/wVSZ1Fa289k/t4qNKOu3HQHmRCHT3cxSuDywyp5JrFpMFgoPH4xG4uIqMiYG09/eq/mCq3KKOwVNVoB3/v+GV6HCmDY3dMEupx0BaiPBEazQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nja5vq31; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714036855; x=1745572855;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=56+KNS01PCOjWwYjwjaGsvb46v0Ao5OptS1cbXOHyss=;
  b=nja5vq31KYDEde+mcrst42Gh3RxcylA7vHXKeSscF4wM8c9OO5Otk/89
   y4QRRnTCWQ4jUP0ZKFPb7c+0KLxn08G25RIBhecEN+/WAs0BmqB7eAZzc
   KPrrN0fFeveZDwRFMoXU2F2OqY+Yxz8nGrKOwToyhqS+tDExrnqWKAqzl
   zdY2uS7ibAMMjz0BfKC+GVktvCNEyjcyX78Xg6stVwvvSu8RS18LyV24U
   PEXWXe5d1JCmkZXRp7fxFfngpw0B1kLkZizVLgqWVF+9iPszR9fWgCj8/
   aPbgfDH7ScnPfPEV2I15NTgcwXxcZM/Eqy0gMk96+LsYPJ4u/DtJCybeO
   Q==;
X-CSE-ConnectionGUID: fhwHYSkKSDineZyklEhBmQ==
X-CSE-MsgGUID: KMQbxzUnTvig+sQRnajdYg==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="13495384"
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="13495384"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 02:20:54 -0700
X-CSE-ConnectionGUID: 0rplidixRX2DYUVdbvgiYw==
X-CSE-MsgGUID: VoMqXVL9Rn2AG9GLOcHtyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="24877026"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 25 Apr 2024 02:20:52 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rzvHe-0002DE-02;
	Thu, 25 Apr 2024 09:20:50 +0000
Date: Thu, 25 Apr 2024 17:20:14 +0800
From: kernel test robot <lkp@intel.com>
To: Longfang Liu <liulongfang@huawei.com>, alex.williamson@redhat.com,
	jgg@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	jonathan.cameron@huawei.com
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
	liulongfang@huawei.com
Subject: Re: [PATCH v5 4/5] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Message-ID: <202404251733.qOuGkmpU-lkp@intel.com>
References: <20240424085721.12760-5-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424085721.12760-5-liulongfang@huawei.com>

Hi Longfang,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on linus/master v6.9-rc5 next-20240424]
[cannot apply to awilliam-vfio/for-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Longfang-Liu/hisi_acc_vfio_pci-extract-public-functions-for-container_of/20240424-170806
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20240424085721.12760-5-liulongfang%40huawei.com
patch subject: [PATCH v5 4/5] hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20240425/202404251733.qOuGkmpU-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240425/202404251733.qOuGkmpU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404251733.qOuGkmpU-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'hisi_acc_vf_debug_cmd':
>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1370:53: error: macro "dev_err" requires 3 arguments, but only 1 given
    1370 |         dev_err("mailbox cmd channel state is OK!\n");
         |                                                     ^
   In file included from include/linux/device.h:15,
                    from drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:6:
   include/linux/dev_printk.h:143: note: macro "dev_err" defined here
     143 | #define dev_err(dev, fmt, ...) \
         | 
>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1370:9: error: 'dev_err' undeclared (first use in this function); did you mean '_dev_err'?
    1370 |         dev_err("mailbox cmd channel state is OK!\n");
         |         ^~~~~~~
         |         _dev_err
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1370:9: note: each undeclared identifier is reported only once for each function it appears in


vim +/dev_err +1370 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c

  1345	
  1346	static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
  1347	{
  1348		struct device *vf_dev = seq->private;
  1349		struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
  1350		struct vfio_device *vdev = &core_device->vdev;
  1351		struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
  1352		struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
  1353		u64 value;
  1354		int ret;
  1355	
  1356		mutex_lock(&hisi_acc_vdev->enable_mutex);
  1357		ret = hisi_acc_vf_debug_check(seq, vdev);
  1358		if (ret) {
  1359			mutex_unlock(&hisi_acc_vdev->enable_mutex);
  1360			return ret;
  1361		}
  1362	
  1363		value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
  1364		if (value == QM_MB_CMD_NOT_READY) {
  1365			mutex_unlock(&hisi_acc_vdev->enable_mutex);
  1366			dev_err(vf_dev, "mailbox cmd channel not ready!\n");
  1367			return -EINVAL;
  1368		}
  1369		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> 1370		dev_err("mailbox cmd channel state is OK!\n");
  1371	
  1372		return 0;
  1373	}
  1374	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

