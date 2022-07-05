Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9556F566292
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 07:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiGEFAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 01:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiGEFAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 01:00:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960C813CEA;
        Mon,  4 Jul 2022 22:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656997232; x=1688533232;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bqRp1IxoetQDUHTUe7ctAtgUSeYkiq7MsRv1B+UfGX4=;
  b=myuztOVgn5IZTCed9quutMVBlSj3gEqaSEyZWmzIMkh4Cub7wEKDcMqg
   l0D6iCdZ92WC7EfGgk70DeV4k/mzv6jrOa3FoKW7T6idlBYdaL9lKoEN3
   FXP0wFmXd4ssaoGGmKKlIcQXWvQ3R9HZVv0jpnHnunkSYCbQwRh75AAHr
   RsY8IvflEwqK8Qbb7PYX8/K8WhXwzEinYpWR7g/sL63KaCs8TwXt72LyA
   eTFNnbFGs1tQP+6Ce+Hi1R5YPNRoWVH0hWjKMfl8gSBBlMmpLuAMZ5bwf
   2AxEOQtpi9TypmfXk2rgRoHNOLC59P3J9GUYqZ3RFJROy9k3woW6ybs2C
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="280805516"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="280805516"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 22:00:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="660403877"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 04 Jul 2022 22:00:29 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8afk-000Ilv-N6;
        Tue, 05 Jul 2022 05:00:28 +0000
Date:   Tue, 5 Jul 2022 12:59:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, jjherne@linux.ibm.com,
        freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH v20 19/20] s390/Docs: new doc describing lock usage by
 the vfio_ap device driver
Message-ID: <202207051236.URA7Qn9x-lkp@intel.com>
References: <20220621155134.1932383-20-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621155134.1932383-20-akrowiak@linux.ibm.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tony,

I love your patch! Perhaps something to improve:

[auto build test WARNING on s390/features]
[also build test WARNING on mst-vhost/linux-next linus/master v5.19-rc5 next-20220704]
[cannot apply to kvms390/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Tony-Krowiak/s390-vfio-ap-dynamic-configuration-support/20220621-235654
base:   https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
reproduce: make htmldocs

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/s390/vfio-ap-locking.rst:10: WARNING: Inline emphasis start-string without end-string.
>> Documentation/s390/vfio-ap-locking.rst:15: WARNING: Title underline too short.
>> Documentation/s390/vfio-ap-locking.rst:22: WARNING: Definition list ends without a blank line; unexpected unindent.

vim +10 Documentation/s390/vfio-ap-locking.rst

     9	
  > 10	struct ap_matrix_dev *matrix_dev;
    11	struct ap_matrix_mdev *matrix_mdev;
    12	struct kvm *kvm;
    13	
    14	The Matrix Devices Lock (drivers/s390/crypto/vfio_ap_private.h)
  > 15	--------------------------------------------------------------
    16	
    17	struct ap_matrix_dev {
    18		...
    19		struct list_head mdev_list;
    20		struct mutex mdevs_lock;
    21		...
  > 22	}
    23	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
