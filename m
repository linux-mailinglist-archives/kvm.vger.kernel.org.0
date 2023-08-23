Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177FC784E65
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 03:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjHWBsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 21:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjHWBsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 21:48:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37439E4A;
        Tue, 22 Aug 2023 18:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692755302; x=1724291302;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/UX/VJr+eHMWDrw7OUXO6P7GMzF6UwuOSz3W+cQBqmI=;
  b=b9eBDBCFiBaKZAh5PQ6sBUvHPFU9PieFIDo57k7X1rYT6HSbMUuKLnFa
   zTD7LJB8O0xIbKvDVJYzbBGCyYOBdirRx9NubP13NPr8OiiEVxmwQumED
   pBm47YuwAF6nzBDN94x61ImlQnCORgpX8kSJNR3TAtlHHTJssnwR7+nHq
   ODP5xOoLW+c0IZIgrrRrWKL02u8VJwN1XRa2fDkYrwDwefyk9AAZt9l70
   yZaOgzjhHGRlq1U10jAJT48nIZtDZ6yq4YyYNujJYVJ/VAaJG5YnSna0V
   8bEVa2tEBPDUigjZl8ewjptacoaIe1eZUcvU+jr93ZdNV+6s6mq5tQFu5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="371452638"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="371452638"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 18:48:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="860142153"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="860142153"
Received: from lkp-server02.sh.intel.com (HELO daf8bb0a381d) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 22 Aug 2023 18:48:18 -0700
Received: from kbuild by daf8bb0a381d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qYcyn-0000ja-2I;
        Wed, 23 Aug 2023 01:48:17 +0000
Date:   Wed, 23 Aug 2023 09:47:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Huang Jiaqing <jiaqing.huang@intel.com>, kvm@vger.kernel.org,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, joro@8bytes.org, will@kernel.org,
        robin.murphy@arm.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com, jiaqing.huang@intel.com
Subject: Re: [PATCH] iommu/vt-d: Introduce a rb_tree for looking up device
Message-ID: <202308230922.9PKf5JkV-lkp@intel.com>
References: <20230821071659.123981-1-jiaqing.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230821071659.123981-1-jiaqing.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Huang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v6.5-rc7]
[also build test WARNING on linus/master]
[cannot apply to joro-iommu/next next-20230822]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Huang-Jiaqing/iommu-vt-d-Introduce-a-rb_tree-for-looking-up-device/20230821-151945
base:   v6.5-rc7
patch link:    https://lore.kernel.org/r/20230821071659.123981-1-jiaqing.huang%40intel.com
patch subject: [PATCH] iommu/vt-d: Introduce a rb_tree for looking up device
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20230823/202308230922.9PKf5JkV-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230823/202308230922.9PKf5JkV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308230922.9PKf5JkV-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/iommu/intel/iommu.c:239:28: warning: no previous prototype for 'device_rbtree_find' [-Wmissing-prototypes]
     239 | struct device_domain_info *device_rbtree_find(struct intel_iommu *iommu, u8 bus, u8 devfn)
         |                            ^~~~~~~~~~~~~~~~~~


vim +/device_rbtree_find +239 drivers/iommu/intel/iommu.c

   237	
   238	
 > 239	struct device_domain_info *device_rbtree_find(struct intel_iommu *iommu, u8 bus, u8 devfn)
   240	{
   241		struct device_domain_info *data = NULL;
   242		struct rb_node *node;
   243	
   244		down_read(&iommu->iopf_device_sem);
   245	
   246		node = iommu->iopf_device_rbtree.rb_node;
   247		while (node) {
   248			data = container_of(node, struct device_domain_info, node);
   249			s16 result = RB_NODE_CMP(bus, devfn, data->bus, data->devfn);
   250	
   251			if (result < 0)
   252				node = node->rb_left;
   253			else if (result > 0)
   254				node = node->rb_right;
   255			else
   256				break;
   257		}
   258		up_read(&iommu->iopf_device_sem);
   259	
   260		return node ? data : NULL;
   261	}
   262	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
