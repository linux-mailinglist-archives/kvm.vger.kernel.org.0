Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8974D530380
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 16:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbiEVOWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 10:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346654AbiEVOW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 10:22:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544462AE08
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 07:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653229347; x=1684765347;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uB1ggbu/slRhJC6Uld62Wb80ZAEvtYljnNVAh039YKM=;
  b=JIe+7DSg09h7a99VmMRrOqAgkTZp2H8uwFYTLs9rCNbQ6LYpN+imVY4G
   V9Djnxs/H9aJ7XLGI3wMEZJFDjw+DlWNhoPYQ/MTWLwbWOsvxGjp3bASo
   ZBg2oRW+fo+NSH6u6NcN1DAMne6XSBuymicR4FGCPzzldCh9PtM/+qUKt
   H3qS2Grg7BG25BVuCUYHjOVh1eLekgH8X9HVlfSwvFoqXeXdUM7azpWy2
   8oRGyzcSTkRFzYZuxOtuGDeXSxTcpqivgs3V5NjsZttGY0q8k80pGdzxE
   wjqVM+ozKLXGW9atyv+uULRjqEb1wezsYrAL2X2+ZGhuS//glJDljI6Wj
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="272984641"
X-IronPort-AV: E=Sophos;i="5.91,244,1647327600"; 
   d="scan'208";a="272984641"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2022 07:22:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,244,1647327600"; 
   d="scan'208";a="702572572"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 22 May 2022 07:22:24 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nsmTP-0000PP-CN;
        Sun, 22 May 2022 14:22:23 +0000
Date:   Sun, 22 May 2022 22:21:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, yishaih@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com
Subject: Re: [PATCH] vfio: Split migration ops from main device ops
Message-ID: <202205222209.5JkbCwDa-lkp@intel.com>
References: <20220522094756.219881-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220522094756.219881-1-yishaih@nvidia.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yishai,

I love your patch! Yet something to improve:

[auto build test ERROR on awilliam-vfio/next]
[cannot apply to v5.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/vfio-Split-migration-ops-from-main-device-ops/20220522-174959
base:   https://github.com/awilliam/linux-vfio.git next
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20220522/202205222209.5JkbCwDa-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f9fa522b20c805dbbb0907b0f90b2b7f1d260218
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yishai-Hadas/vfio-Split-migration-ops-from-main-device-ops/20220522-174959
        git checkout f9fa522b20c805dbbb0907b0f90b2b7f1d260218
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'hisi_acc_vfio_pci_open_device':
>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1188:27: error: 'const struct vfio_device_ops' has no member named 'migration_set_state'
    1188 |         if (core_vdev->ops->migration_set_state) {
         |                           ^~
   At top level:
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1201:13: warning: 'hisi_acc_vfio_pci_close_device' defined but not used [-Wunused-function]
    1201 | static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1138:13: warning: 'hisi_acc_vfio_pci_ioctl' defined but not used [-Wunused-function]
    1138 | static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
         |             ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1124:16: warning: 'hisi_acc_vfio_pci_read' defined but not used [-Wunused-function]
    1124 | static ssize_t hisi_acc_vfio_pci_read(struct vfio_device *core_vdev,
         |                ^~~~~~~~~~~~~~~~~~~~~~
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1110:16: warning: 'hisi_acc_vfio_pci_write' defined but not used [-Wunused-function]
    1110 | static ssize_t hisi_acc_vfio_pci_write(struct vfio_device *core_vdev,
         |                ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1086:12: warning: 'hisi_acc_vfio_pci_mmap' defined but not used [-Wunused-function]
    1086 | static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
         |            ^~~~~~~~~~~~~~~~~~~~~~


vim +1188 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c

6abdce51af1a21 Shameer Kolothum 2022-03-08  1176  
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1177  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1178  {
b0eed085903e77 Longfang Liu     2022-03-08  1179  	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
b0eed085903e77 Longfang Liu     2022-03-08  1180  			struct hisi_acc_vf_core_device, core_device.vdev);
b0eed085903e77 Longfang Liu     2022-03-08  1181  	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1182  	int ret;
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1183  
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1184  	ret = vfio_pci_core_enable(vdev);
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1185  	if (ret)
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1186  		return ret;
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1187  
b0eed085903e77 Longfang Liu     2022-03-08 @1188  	if (core_vdev->ops->migration_set_state) {
b0eed085903e77 Longfang Liu     2022-03-08  1189  		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
b0eed085903e77 Longfang Liu     2022-03-08  1190  		if (ret) {
b0eed085903e77 Longfang Liu     2022-03-08  1191  			vfio_pci_core_disable(vdev);
b0eed085903e77 Longfang Liu     2022-03-08  1192  			return ret;
b0eed085903e77 Longfang Liu     2022-03-08  1193  		}
b0eed085903e77 Longfang Liu     2022-03-08  1194  		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
b0eed085903e77 Longfang Liu     2022-03-08  1195  	}
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1196  
b0eed085903e77 Longfang Liu     2022-03-08  1197  	vfio_pci_core_finish_enable(vdev);
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1198  	return 0;
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1199  }
ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1200  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
