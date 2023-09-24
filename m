Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50D17AC6A3
	for <lists+kvm@lfdr.de>; Sun, 24 Sep 2023 07:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjIXFT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 01:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjIXFT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 01:19:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E384511D
        for <kvm@vger.kernel.org>; Sat, 23 Sep 2023 22:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695532760; x=1727068760;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZVGxuFAQWceZXoSUYCCW5E1Bk3FBdhz5SySROx/a4mw=;
  b=lz6WDdDcutgevGKroOc3L1uuislwKGiZ5RKetncl4XfYzZszUZ0XXHDE
   RMCVy1BW69q8ccIHlNnD4kMAwy0NSmSxmopwE6FMB7YZk7AqPyq17HDrd
   WPjCyQE7lkVQfPJFDTuvZNn4hn/1N09UZ7CNysmKVKWtw7Gyaxddf0deG
   YK36pwN/CZFAuxmm/beg/CEA3cHgeHJqFxs3IdZ/pJR/+dhF2W996j2iX
   J4a1lYj9pm8528bwiqCtkJl4/9MHcd5OQySViPohN0Z2Sc7xB1REQSZnD
   az8bbRJ5dgiNBjyqqvRaOzIzpyVA1z7YbB5/KEJHehcqtJQl5x/QpE+Sg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10842"; a="445181100"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="445181100"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 22:19:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10842"; a="891279479"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="891279479"
Received: from lkp-server02.sh.intel.com (HELO 493f6c7fed5d) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2023 22:18:18 -0700
Received: from kbuild by 493f6c7fed5d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qkHWU-0003Fd-38;
        Sun, 24 Sep 2023 05:19:14 +0000
Date:   Sun, 24 Sep 2023 13:18:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        mst@redhat.com, jasowang@redhat.com, jgg@nvidia.com
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 07/11] virtio-pci: Introduce admin commands
Message-ID: <202309241353.ykr3cC2K-lkp@intel.com>
References: <20230921124040.145386-8-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921124040.145386-8-yishaih@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yishai,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/for-linus]
[also build test ERROR on mst-vhost/linux-next linus/master v6.6-rc2 next-20230921]
[cannot apply to awilliam-vfio/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/virtio-pci-Use-virtio-pci-device-layer-vq-info-instead-of-generic-one/20230922-062611
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20230921124040.145386-8-yishaih%40nvidia.com
patch subject: [PATCH vfio 07/11] virtio-pci: Introduce admin commands
config: i386-randconfig-012-20230924 (https://download.01.org/0day-ci/archive/20230924/202309241353.ykr3cC2K-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230924/202309241353.ykr3cC2K-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309241353.ykr3cC2K-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
>> ./usr/include/linux/virtio_pci.h:250:9: error: unknown type name 'u8'
     250 |         u8 offset; /* Starting offset of the register(s) to write. */
         |         ^~
   ./usr/include/linux/virtio_pci.h:251:9: error: unknown type name 'u8'
     251 |         u8 reserved[7];
         |         ^~
   ./usr/include/linux/virtio_pci.h:252:9: error: unknown type name 'u8'
     252 |         u8 registers[];
         |         ^~
   ./usr/include/linux/virtio_pci.h:256:9: error: unknown type name 'u8'
     256 |         u8 offset; /* Starting offset of the register(s) to read. */
         |         ^~
   ./usr/include/linux/virtio_pci.h:266:9: error: unknown type name 'u8'
     266 |         u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
         |         ^~
   ./usr/include/linux/virtio_pci.h:267:9: error: unknown type name 'u8'
     267 |         u8 bar; /* BAR of the member or the owner device */
         |         ^~
   ./usr/include/linux/virtio_pci.h:268:9: error: unknown type name 'u8'
     268 |         u8 padding[6];
         |         ^~

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
