Return-Path: <kvm+bounces-31039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 179AC9BF855
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 22:11:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8FC6283E29
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4B120CCC8;
	Wed,  6 Nov 2024 21:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K2w5ZPXC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F55F20C473;
	Wed,  6 Nov 2024 21:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730927503; cv=none; b=WF3nLM7w9iMcfwXp3Oa7aNhrpKbFxIHZRv22oiSI0bRYirXisgEY4BqC3hyZ8bMTjkGYWDgSInJjLyLc7gfUPsxbd4Ej51170HuFq5XFHkF5uprOB2sQ622ImXXjzvl6EiCjGfUuvEpDHab7BQ9W9Sp1NRbwAziXwGU3IirWTM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730927503; c=relaxed/simple;
	bh=huYLARWenfwUcsC3qlGBR/nDXR80KJL1574pQn4aHRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQpPjpzcazDGYrwOD6JTvMb4oJTeeBoR8TdeancgV4qmSPVsIxwoaQ+vpkWjvxPdahjLdPzLsQ6QpEPKAbeTer3CWYoSc6AU6IdHEpnZMerTyLLQIFrwtuPvl8pJ7jQmhgINdOgN+pZN4TlPCO4VQ4qKfFhjOakw+KZwGwIERio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K2w5ZPXC; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730927501; x=1762463501;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=huYLARWenfwUcsC3qlGBR/nDXR80KJL1574pQn4aHRQ=;
  b=K2w5ZPXCDvFCW8+XZXWrBSv5RJbWIY5JSrZAP3dBD1g+CiV8wiuW1c8M
   2y4rLE50+9PM6IbJarxL3Q2lVhS/N2ZbctTp+ndwkdzgoE3pwQg4NVZeu
   wm+HPCrv9MLUN3LRNTFMLArxTA2o10jEyotg6+gwYPuZUsliWhu2wc7ML
   npbUug9rvKWLG5fGBBrvhmcuG49RzyRpIfkypiQWNf6gkms3gdIZuY6Nu
   uFKh6m7FgiWhRVIYzisw36kcvhT/59ifW/wPKFELBLtqpLZ70so4+WQ0t
   OZMyjbkzfhPy56kT0znCpOuh8kR20H4ODsREIHYQpeh0Y3GmXbHjwy6WY
   g==;
X-CSE-ConnectionGUID: Z+majKsRSsqtifboXAoHGA==
X-CSE-MsgGUID: V/aTrz0fSU+tmUrAHoh8mA==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="30970714"
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="30970714"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 13:11:40 -0800
X-CSE-ConnectionGUID: +xIJCD1iQhSFhOG6nRINnw==
X-CSE-MsgGUID: WPJFrZdcRNeCUd+wMt4OZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="89546581"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 06 Nov 2024 13:11:38 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t8nJO-000pQk-1w;
	Wed, 06 Nov 2024 21:11:34 +0000
Date: Thu, 7 Nov 2024 05:11:31 +0800
From: kernel test robot <lkp@intel.com>
To: Longfang Liu <liulongfang@huawei.com>, alex.williamson@redhat.com,
	jgg@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	jonathan.cameron@huawei.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxarm@openeuler.org, liulongfang@huawei.com
Subject: Re: [PATCH v13 3/4] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Message-ID: <202411070400.I8XzogJF-lkp@intel.com>
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
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20241107/202411070400.I8XzogJF-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241107/202411070400.I8XzogJF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411070400.I8XzogJF-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:9:
   In file included from include/linux/hisi_acc_qm.h:10:
   In file included from include/linux/pci.h:1650:
   In file included from include/linux/dmapool.h:14:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1400:4: error: too many arguments to function call, expected 2, have 4
    1397 |         seq_puts(seq,
         |         ~~~~~~~~
    1398 |                  "guest driver load: %u\n"
    1399 |                  "data size: %lu\n",
    1400 |                  hisi_acc_vdev->vf_qm_state,
         |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~
    1401 |                  sizeof(struct acc_vf_data));
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/seq_file.h:122:29: note: 'seq_puts' declared here
     122 | static __always_inline void seq_puts(struct seq_file *m, const char *s)
         |                             ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1429:46: error: too many arguments to function call, expected 2, have 3
    1429 |         seq_puts(seq, "migrate data length: %lu\n", debug_migf->total_length);
         |         ~~~~~~~~                                    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/seq_file.h:122:29: note: 'seq_puts' declared here
     122 | static __always_inline void seq_puts(struct seq_file *m, const char *s)
         |                             ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   4 warnings and 2 errors generated.


vim +1400 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c

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
  1397		seq_puts(seq,
  1398			 "guest driver load: %u\n"
  1399			 "data size: %lu\n",
> 1400			 hisi_acc_vdev->vf_qm_state,
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

