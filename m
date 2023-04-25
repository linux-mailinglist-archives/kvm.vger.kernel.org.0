Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CEB6EDBA1
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 08:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjDYGc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 02:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjDYGc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 02:32:26 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED9C359C;
        Mon, 24 Apr 2023 23:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682404345; x=1713940345;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ewRnyN7g2P6ZwWl0nhwSgtmxbilVWfDk8RAWBRdlT2Q=;
  b=Kc3j2YYn1gvNw5DsjpKgEF0ipOqsL3oaykruyeJLZ9aYuJ5Ce4IN1AgJ
   pqTK8/kecm6vgVyVslrt/pQ32Ha/aAejqiYN5R8EfmXw9fr60Dp6Y5E3i
   e3jhiJtHcZq3m5b64VoAH6TCzS2KLCuWxSjB6P8PmbpXCkWX/3VPNDQSw
   vOIqfxlxnqu5YMqZyrr27qxVi6NAgWaNcrtFE7GINVZM9uzzi2DLEQUf3
   lj4yutx84X38XJ6GAfv02tHmMJjnJGTXviTB5eMK+CAGwD4X6UkhWFo3Z
   pRmOLFsVU2Gt8VDeDPptyxYzF4lHOcWCtHqgLzrHoUDCf+8B75SDyjhdv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="345428180"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="345428180"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 23:32:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="696055458"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="696055458"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 24 Apr 2023 23:32:21 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1prCDs-000j5u-1M;
        Tue, 25 Apr 2023 06:32:20 +0000
Date:   Tue, 25 Apr 2023 14:31:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Grzegorz Jaszczyk <jaz@semihalf.com>, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com
Cc:     oe-kbuild-all@lists.linux.dev, dmy@semihalf.com, tn@semihalf.com,
        dbehr@google.com, dbehr@chromium.org, upstream@semihalf.com,
        dtor@google.com, jgg@ziepe.ca, kevin.tian@intel.com,
        cohuck@redhat.com, abhsahu@nvidia.com, yishaih@nvidia.com,
        yi.l.liu@intel.com, kvm@vger.kernel.org, libvir-list@redhat.com,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Subject: Re: [PATCH v2] vfio/pci: Propagate ACPI notifications to user-space
 via eventfd
Message-ID: <202304251437.hZVFw4GS-lkp@intel.com>
References: <20230424162748.2711945-1-jaz@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424162748.2711945-1-jaz@semihalf.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Grzegorz,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/for-linus]
[also build test WARNING on linus/master v6.3 next-20230424]
[cannot apply to awilliam-vfio/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Grzegorz-Jaszczyk/vfio-pci-Propagate-ACPI-notifications-to-user-space-via-eventfd/20230425-002935
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20230424162748.2711945-1-jaz%40semihalf.com
patch subject: [PATCH v2] vfio/pci: Propagate ACPI notifications to user-space via eventfd
config: i386-randconfig-s001 (https://download.01.org/0day-ci/archive/20230425/202304251437.hZVFw4GS-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/62d759059cd5e6dab70052027e1b69c5d5cdc0f2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Grzegorz-Jaszczyk/vfio-pci-Propagate-ACPI-notifications-to-user-space-via-eventfd/20230425-002935
        git checkout 62d759059cd5e6dab70052027e1b69c5d5cdc0f2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 olddefconfig
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash drivers/vfio/pci/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304251437.hZVFw4GS-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   drivers/vfio/pci/vfio_pci_core.c:244:33: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:244:41: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:248:25: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:248:43: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:248:56: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:248:65: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:253:25: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:253:44: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:253:57: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:253:66: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:261:39: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/vfio/pci/vfio_pci_core.c:261:58: sparse: sparse: restricted pci_power_t degrades to integer
>> drivers/vfio/pci/vfio_pci_core.c:709:6: sparse: sparse: symbol 'vfio_pci_acpi_notify_close_device' was not declared. Should it be static?

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
