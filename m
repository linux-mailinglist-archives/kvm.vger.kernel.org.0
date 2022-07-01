Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0CB562D4C
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 10:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbiGAH6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 03:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbiGAH6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 03:58:51 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D16564D6A
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 00:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656662331; x=1688198331;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=VJejyouKW9/czk6l1Lmvad6clDecjfEujTrLe/gh4Zc=;
  b=KfetSCn9vtMPzZKcOU78YUhSV7BCTO4eM56Bfk/u2Tm4/D2mT+O8/JcK
   +1Mj484yKlX9uzqOCWyf5NzWIA6csOTByDpvFPWTakv6vu5Y5xNMksiuT
   3Q+24ggOYwbYiEONv+yMu8U8o7McRoVfOa7xP3RP2OisZfbsDw+JM7zWi
   whPevN8hhJi3utdh3pSHXVCb9S3yo3+WrdrnCyxrrwam9SPmCcMe2kcEm
   AwSvkLbSltwaBsHHE4r4MZ7XWIvJ1sYu3/0kTk66UNqLH2Z/x7/16DRNM
   gkNkak9e/1Ufr6AWHADBfAcLhjX2VYIHEXTeUgI2pV31oo/9AIVdGuP0S
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="283316803"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="283316803"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 00:58:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="681310234"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Jul 2022 00:58:33 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o7BXs-000DiF-Ea;
        Fri, 01 Jul 2022 07:58:32 +0000
Date:   Fri, 1 Jul 2022 15:57:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [awilliam-vfio:next 2/11] drivers/vfio/vfio_iommu_type1.c:2147:35:
 warning: cast to smaller integer type 'enum iommu_cap' from 'void *'
Message-ID: <202207011538.py9XU340-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://github.com/awilliam/linux-vfio.git next
head:   7654a8881a54c335f176c7dc0a923480228497de
commit: eed20c782aea57b7efb42af2905dc381268b21e9 [2/11] vfio/type1: Simplify bus_type determination
config: x86_64-randconfig-a001 (https://download.01.org/0day-ci/archive/20220701/202207011538.py9XU340-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a9119143a2d1f4d0d0bc1fe0d819e5351b4e0deb)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/awilliam/linux-vfio/commit/eed20c782aea57b7efb42af2905dc381268b21e9
        git remote add awilliam-vfio https://github.com/awilliam/linux-vfio.git
        git fetch --no-tags awilliam-vfio next
        git checkout eed20c782aea57b7efb42af2905dc381268b21e9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/vfio/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/vfio/vfio_iommu_type1.c:2147:35: warning: cast to smaller integer type 'enum iommu_cap' from 'void *' [-Wvoid-pointer-to-enum-cast]
           return device_iommu_capable(dev, (enum iommu_cap)data);
                                            ^~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +2147 drivers/vfio/vfio_iommu_type1.c

  2143	
  2144	/* Redundantly walks non-present capabilities to simplify caller */
  2145	static int vfio_iommu_device_capable(struct device *dev, void *data)
  2146	{
> 2147		return device_iommu_capable(dev, (enum iommu_cap)data);
  2148	}
  2149	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
