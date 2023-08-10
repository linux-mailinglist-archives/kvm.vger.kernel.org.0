Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4F1778459
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 01:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjHJXx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 19:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjHJXx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 19:53:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A853526BC;
        Thu, 10 Aug 2023 16:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691711606; x=1723247606;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5JIN1Yu4mUkxQTHvXnfAGLOJxcyhh/wZyopkkYQtIuo=;
  b=ix9GZsVn6x/6OELVvd7FHj+YyLU6uWn93NnF4ShO54pUvaK8TgoatOOl
   6bCyujTRLYoAnBWAHJ7HXYvvVBsUW0JDj8SfKxvEw/+8Q2JviYkIDMA9L
   mJ4vtwyRPT0IjsR/MnzBPWsAHweHtbm0oo32HlFgTIIAnrRX5ONTqhLI3
   flDLJkn8utBlPPRKwCpVoPePvYV2pyEJQm8iR8UYiBJOb+qOauanHgVOn
   V+8tZgAjZs3rkQdXfOzsrHvtFrEHlJm3mvcImMlUIcHwYviv6hW8kJeOP
   /D4r0VMP6XvGQheYVRxdBAIj9wOwk4RCPrOZYBW8HoG1FQ6kvJ3i5jjya
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="351872279"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="351872279"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 16:53:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="856092397"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="856092397"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 10 Aug 2023 16:53:24 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qUFT1-0007LM-0U;
        Thu, 10 Aug 2023 23:53:23 +0000
Date:   Fri, 11 Aug 2023 07:53:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maxime Coquelin <maxime.coquelin@redhat.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: [mst-vhost:vhost 34/46] drivers/vdpa/vdpa_user/vduse_dev.c:1812:23:
 error: use of undeclared identifier 'VIRTIO_RING_F_INDIRECT_DESC'
Message-ID: <202308110712.wCQoOG00-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
head:   bb59e1f960bd07f70a4b3d8de99bfd8d71835199
commit: 334f48a83105ebe129a660d1ea1a0c29f87d50c7 [34/46] vduse: Temporarily disable control queue features
config: x86_64-buildonly-randconfig-r001-20230811 (https://download.01.org/0day-ci/archive/20230811/202308110712.wCQoOG00-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce: (https://download.01.org/0day-ci/archive/20230811/202308110712.wCQoOG00-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308110712.wCQoOG00-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/vdpa/vdpa_user/vduse_dev.c:1812:23: error: use of undeclared identifier 'VIRTIO_RING_F_INDIRECT_DESC'
                   config->features &= VDUSE_NET_VALID_FEATURES_MASK;
                                       ^
   drivers/vdpa/vdpa_user/vduse_dev.c:66:11: note: expanded from macro 'VDUSE_NET_VALID_FEATURES_MASK'
            BIT_ULL(VIRTIO_RING_F_INDIRECT_DESC) | \
                    ^
>> drivers/vdpa/vdpa_user/vduse_dev.c:1812:23: error: use of undeclared identifier 'VIRTIO_F_EVENT_IDX'
   drivers/vdpa/vdpa_user/vduse_dev.c:67:11: note: expanded from macro 'VDUSE_NET_VALID_FEATURES_MASK'
            BIT_ULL(VIRTIO_F_EVENT_IDX) |          \
                    ^
>> drivers/vdpa/vdpa_user/vduse_dev.c:1812:23: error: use of undeclared identifier 'VIRTIO_F_IOMMU_PLATFORM'
   drivers/vdpa/vdpa_user/vduse_dev.c:69:11: note: expanded from macro 'VDUSE_NET_VALID_FEATURES_MASK'
            BIT_ULL(VIRTIO_F_IOMMU_PLATFORM) |     \
                    ^
   drivers/vdpa/vdpa_user/vduse_dev.c:2007:51: warning: shift count >= width of type [-Wshift-count-overflow]
           ret = dma_set_mask_and_coherent(&vdev->vdpa.dev, DMA_BIT_MASK(64));
                                                            ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:77:54: note: expanded from macro 'DMA_BIT_MASK'
   #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
                                                        ^ ~~~
   1 warning and 3 errors generated.


vim +/VIRTIO_RING_F_INDIRECT_DESC +1812 drivers/vdpa/vdpa_user/vduse_dev.c

  1804	
  1805	static void vduse_dev_features_filter(struct vduse_dev_config *config)
  1806	{
  1807		/*
  1808		 * Temporarily filter out virtio-net's control virtqueue and features
  1809		 * that depend on it while CVQ is being made more robust for VDUSE.
  1810		 */
  1811		if (config->device_id == VIRTIO_ID_NET)
> 1812			config->features &= VDUSE_NET_VALID_FEATURES_MASK;
  1813	}
  1814	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
