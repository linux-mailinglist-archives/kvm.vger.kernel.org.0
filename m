Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877BA7ACEA5
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 05:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjIYDT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 23:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjIYDT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 23:19:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D20A3
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 20:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695611960; x=1727147960;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vy/Xo+gzkc5yJcEHuTcjeuI7dv1QqXm6C+kdkDWEFlo=;
  b=dCHcd59RT8npNbqbp3vEowF6jC8I3aYDbwgLMzqNohvI4fE9JzVumhV8
   v32z4348yobkiHyIRASI46LyhBe+0sUKzwEPnisMecVno+UQOY8eg6Gy5
   j0tBZWyWdoY06Emv3k7TvIqM5U9iXVj1IFmc8RNDg0yOlrbC6i/gtQmkj
   Xu2oq8DYX+Z7cJFVj2bVEeAlxwXnIb2pFQ9Znqxtu4GwGcF629ejaI8NR
   gdv6BxHBD7P1nXy2b3ukAhq4bNxjjao/PmhawA6UrQuakWXHp+GI2raBS
   uGMpbeia1XgO/qCuSQNxEVatUb5uRL2yqjI6LHS8rHVWykTGwdEkcUGoc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="371476827"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="371476827"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 20:19:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="748207659"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="748207659"
Received: from lkp-server02.sh.intel.com (HELO 32c80313467c) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 24 Sep 2023 20:19:15 -0700
Received: from kbuild by 32c80313467c with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qkc7t-00018X-01;
        Mon, 25 Sep 2023 03:19:13 +0000
Date:   Mon, 25 Sep 2023 11:18:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        mst@redhat.com, jasowang@redhat.com, jgg@nvidia.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        yishaih@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 07/11] virtio-pci: Introduce admin commands
Message-ID: <202309251120.rWbiAZYM-lkp@intel.com>
References: <20230921124040.145386-8-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921124040.145386-8-yishaih@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yishai,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/for-linus]
[also build test WARNING on linus/master v6.6-rc3 next-20230921]
[cannot apply to awilliam-vfio/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/virtio-pci-Use-virtio-pci-device-layer-vq-info-instead-of-generic-one/20230922-062611
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20230921124040.145386-8-yishaih%40nvidia.com
patch subject: [PATCH vfio 07/11] virtio-pci: Introduce admin commands
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20230925/202309251120.rWbiAZYM-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230925/202309251120.rWbiAZYM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309251120.rWbiAZYM-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/virtio/virtio_pci_modern_dev.c:3:
   In file included from include/linux/virtio_pci_modern.h:6:
>> include/uapi/linux/virtio_pci.h:270:4: warning: attribute '__packed__' is ignored, place it after "struct" to apply attribute to type declaration [-Wignored-attributes]
   }; __packed
      ^
   include/linux/compiler_attributes.h:304:56: note: expanded from macro '__packed'
   #define __packed                        __attribute__((__packed__))
                                                          ^
   1 warning generated.


vim +270 include/uapi/linux/virtio_pci.h

   264	
   265	struct virtio_admin_cmd_notify_info_data {
   266		u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
   267		u8 bar; /* BAR of the member or the owner device */
   268		u8 padding[6];
   269		__le64 offset; /* Offset within bar. */
 > 270	}; __packed
   271	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
