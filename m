Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4310253050D
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 19:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350026AbiEVRzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 13:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiEVRzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 13:55:35 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08AB381B6
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 10:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653242134; x=1684778134;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TEHU3fRelVLGjcqtRNnrAIQLa49InoqaD0+23YUKMVQ=;
  b=I28+ww+6qRtEhOtkYLV4oT/RFQMUrkvB1qOG7+1k6rfFvMkxBsAW5SW9
   vCQ6Xm1paOrDk6d9Z5nvnjFpR8E3tHWforcpY4gy+8Fa/r3Mphsu48Giq
   UHB7S7Rcz2PgqsGsPRhaXoiV7BL1tVotGAzt60MnxVOIK4kBEH00my5OT
   3dmUvxf6sWabaqDYLPzKmiP86VQpjlKmb0QuCsAaQpHACFRG8XaP7JNSe
   u3j+mOyEjhjcgib0tdVVFsX3eWfg5Nf/KCb4+ezlzCkjFpkPg6uCgCYSM
   YXVAk8O1uzL9zl+1rN6af8GPK4RMJRf0jV7txRF5q2haY4v1I0HuJi1Br
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="336080762"
X-IronPort-AV: E=Sophos;i="5.91,244,1647327600"; 
   d="scan'208";a="336080762"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2022 10:55:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,244,1647327600"; 
   d="scan'208";a="663086316"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 22 May 2022 10:55:31 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nspne-0000X1-HZ;
        Sun, 22 May 2022 17:55:30 +0000
Date:   Mon, 23 May 2022 01:54:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, yishaih@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com
Subject: Re: [PATCH] vfio: Split migration ops from main device ops
Message-ID: <202205230157.hD7n0wig-lkp@intel.com>
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
[also build test ERROR on next-20220520]
[cannot apply to v5.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/vfio-Split-migration-ops-from-main-device-ops/20220522-174959
base:   https://github.com/awilliam/linux-vfio.git next
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20220523/202205230157.hD7n0wig-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 1443dbaba6f0e57be066995db9164f89fb57b413)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/f9fa522b20c805dbbb0907b0f90b2b7f1d260218
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yishai-Hadas/vfio-Split-migration-ops-from-main-device-ops/20220522-174959
        git checkout f9fa522b20c805dbbb0907b0f90b2b7f1d260218
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/vfio/pci/hisilicon/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1188:22: error: no member named 'migration_set_state' in 'struct vfio_device_ops'
           if (core_vdev->ops->migration_set_state) {
               ~~~~~~~~~~~~~~  ^
   1 error generated.


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
