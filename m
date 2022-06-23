Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0655571FD
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 06:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiFWEqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 00:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347068AbiFWEcT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 00:32:19 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B67C193DC;
        Wed, 22 Jun 2022 21:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655958737; x=1687494737;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Xf1ZndHIWN0yF2ATkspzO18eIZTG7iZNontCpxDrQsk=;
  b=GRdlZ1t6W9NP/n28RwgSsYrj8bRhV8bh78bMxICF0QMXiPMosck8tZjT
   FccZZ+Lq0BuxPFUR77793oh9Lbg94/HDALXDM9B2SHFeEz+rbernlVjTy
   BsDFci92/hF0KE7WHrqtPGxPZ4oQcwiERRgEiaYUMm8BWjz/r01jtTiTd
   H9DmC1nsPMTtnQBo+m9TVtooAXbLb8zp1lBwQ4XNW6K5OaxlVyDsKtCSw
   AVbd6A533/BdY4RBnkiIr+tlkdFm9ebcHc5YFtrNBmp+iJ0EfbkHkZnId
   PNG0PdTHxJ601SoA+V7/l/hsGg9pSjOFtyzMojh1bdix1VcB+YniChqJb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="263654671"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="263654671"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 21:32:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="538746728"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 22 Jun 2022 21:32:14 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o4EVp-0000hJ-Pi;
        Thu, 23 Jun 2022 04:32:13 +0000
Date:   Thu, 23 Jun 2022 12:32:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Robin Murphy <robin.murphy@arm.com>, alex.williamson@redhat.com,
        cohuck@redhat.com
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com
Subject: Re: [PATCH v2 1/2] vfio/type1: Simplify bus_type determination
Message-ID: <202206231208.PGASmlUW-lkp@intel.com>
References: <b1d13cade281a7d8acbfd0f6a33dcd086207952c.1655898523.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1d13cade281a7d8acbfd0f6a33dcd086207952c.1655898523.git.robin.murphy@arm.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin,

I love your patch! Yet something to improve:

[auto build test ERROR on v5.19-rc3]
[also build test ERROR on linus/master next-20220622]
[cannot apply to awilliam-vfio/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Robin-Murphy/vfio-type1-Simplify-bus_type-determination/20220622-200503
base:    a111daf0c53ae91e71fd2bfe7497862d14132e3e
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220623/202206231208.PGASmlUW-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/7a6e1ddc765bde40f879995137a2ff20cb0eda47
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Robin-Murphy/vfio-type1-Simplify-bus_type-determination/20220622-200503
        git checkout 7a6e1ddc765bde40f879995137a2ff20cb0eda47
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "vfio_device_get_from_iommu" [drivers/vfio/vfio_iommu_type1.ko] undefined!
>> ERROR: modpost: "vfio_device_put" [drivers/vfio/vfio_iommu_type1.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
