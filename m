Return-Path: <kvm+bounces-31005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B717D9BF399
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C6DC2847DC
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF982205E2D;
	Wed,  6 Nov 2024 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fvdHYxXe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3A884039;
	Wed,  6 Nov 2024 16:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911891; cv=none; b=dKrJG4cM3gf+g0H7FeBYyJazicJnD2g7sZe/BO5/ufrDJVZgPIG0Or+JjbnqRF/RELhnHrrlUsHDaNSvMFbQoAqOW394vNF+FUGk2IaMK1fk8BOA8dndQoJBC77kPVTs7qkxCJeWkOqXCp0pHn15OjJMBlRoNGKtwEOlSRcSOfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911891; c=relaxed/simple;
	bh=1M7Bj+5VS5H515hcMISSA+Rb5xUvbQ88kk6eO60py2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gbxfV01KAPtDnssnPCYv8YDLNZWHO8RIu92yEtXgpfICr70X5dld59Dn4NqAbntUdqSdVNm2Qp7lPvpNGVTEAijS/xD4gu98kYW1iasrizQ9PZIIkv+RUEe5sJZ5fagbZ4FhLt5unPDaIerk3hWv+oPil0dJaqRK0nn+YB9okVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fvdHYxXe; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730911890; x=1762447890;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1M7Bj+5VS5H515hcMISSA+Rb5xUvbQ88kk6eO60py2I=;
  b=fvdHYxXeR5/awiXgM3IJq3wwnq9Jl8a+PVNlIVyjeIvpDwNcElHBm9LM
   K/VIiebP9zDrRI/SZuRl0jc63Mnn00LrFMPDOdq6/9bFSeY5QEjlBWr6X
   m5GA3rFdZuT1GQkv2E0DPF9jBbQ4vQhioIQiKm1U0n6JSyYtdARiBVTD2
   T3TGoZHan3fWe0DWRPgHEI7MYgEXtTuzM7v2DI/N4lv/iInDkCMe+xIJW
   K2hdeBYP+mOk2a0qZdO/vmEe/So2wSip+9fnmoLiX0iKN26pTFTPqsul0
   PCgsy04xK1y/o4zWFtqkh7tpYk3vMI/mVqR7ywm8J32klW1ztwRYdJrBn
   Q==;
X-CSE-ConnectionGUID: g1W4XU3SRiKVwLyRfXMxkA==
X-CSE-MsgGUID: pSGipyI6TSqy28UMshvGjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="34421268"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="34421268"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 08:51:29 -0800
X-CSE-ConnectionGUID: wIbpXI4ERrGR0Wz2x3vH5Q==
X-CSE-MsgGUID: yaKF7mI5R0yZbu3xgKqINg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="88606389"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 06 Nov 2024 08:51:26 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t8jFc-000p9s-0j;
	Wed, 06 Nov 2024 16:51:24 +0000
Date: Thu, 7 Nov 2024 00:50:45 +0800
From: kernel test robot <lkp@intel.com>
To: Longfang Liu <liulongfang@huawei.com>, alex.williamson@redhat.com,
	jgg@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	jonathan.cameron@huawei.com
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
	liulongfang@huawei.com
Subject: Re: [PATCH v13 3/4] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Message-ID: <202411070027.p1xVCxxs-lkp@intel.com>
References: <20241106100343.21593-4-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106100343.21593-4-liulongfang@huawei.com>

Hi Longfang,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on awilliam-vfio/for-linus linus/master v6.12-rc6 next-20241106]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Longfang-Liu/hisi_acc_vfio_pci-extract-public-functions-for-container_of/20241106-182913
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20241106100343.21593-4-liulongfang%40huawei.com
patch subject: [PATCH v13 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20241107/202411070027.p1xVCxxs-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241107/202411070027.p1xVCxxs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411070027.p1xVCxxs-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'hisi_acc_vf_dev_read':
>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1397:9: error: too many arguments to function 'seq_puts'
    1397 |         seq_puts(seq,
         |         ^~~~~~~~
   In file included from include/linux/debugfs.h:16,
                    from include/linux/hisi_acc_qm.h:7,
                    from drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:9:
   include/linux/seq_file.h:122:29: note: declared here
     122 | static __always_inline void seq_puts(struct seq_file *m, const char *s)
         |                             ^~~~~~~~
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'hisi_acc_vf_migf_read':
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1429:9: error: too many arguments to function 'seq_puts'
    1429 |         seq_puts(seq, "migrate data length: %lu\n", debug_migf->total_length);
         |         ^~~~~~~~
   include/linux/seq_file.h:122:29: note: declared here
     122 | static __always_inline void seq_puts(struct seq_file *m, const char *s)
         |                             ^~~~~~~~


vim +/seq_puts +1397 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c

  1364	
  1365	static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
  1366	{
  1367		struct device *vf_dev = seq->private;
  1368		struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
  1369		struct vfio_device *vdev = &core_device->vdev;
  1370		struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
  1371		size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
  1372		struct acc_vf_data *vf_data;
  1373		int ret;
  1374	
  1375		mutex_lock(&hisi_acc_vdev->open_mutex);
  1376		ret = hisi_acc_vf_debug_check(seq, vdev);
  1377		if (ret) {
  1378			mutex_unlock(&hisi_acc_vdev->open_mutex);
  1379			return ret;
  1380		}
  1381	
  1382		mutex_lock(&hisi_acc_vdev->state_mutex);
  1383		vf_data = kzalloc(sizeof(*vf_data), GFP_KERNEL);
  1384		if (!vf_data) {
  1385			ret = -ENOMEM;
  1386			goto mutex_release;
  1387		}
  1388	
  1389		vf_data->vf_qm_state = hisi_acc_vdev->vf_qm_state;
  1390		ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
  1391		if (ret)
  1392			goto migf_err;
  1393	
  1394		seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
  1395			     (const void *)vf_data, vf_data_sz, false);
  1396	
> 1397		seq_puts(seq,
  1398			 "guest driver load: %u\n"
  1399			 "data size: %lu\n",
  1400			 hisi_acc_vdev->vf_qm_state,
  1401			 sizeof(struct acc_vf_data));
  1402	
  1403	migf_err:
  1404		kfree(vf_data);
  1405	mutex_release:
  1406		mutex_unlock(&hisi_acc_vdev->state_mutex);
  1407		mutex_unlock(&hisi_acc_vdev->open_mutex);
  1408	
  1409		return ret;
  1410	}
  1411	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

