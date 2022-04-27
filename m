Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1257D5113AB
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 10:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359496AbiD0Io6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 04:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359487AbiD0Iox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 04:44:53 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A707892A;
        Wed, 27 Apr 2022 01:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651048902; x=1682584902;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Or6mGoiigOsmCY44ez//qcXP16P68GeRxhWNaqieJzE=;
  b=UHKOMuUmMvURfb7S86kysshehWml+4KUBggzZDpTgYfc1yDnqUicLQcQ
   JvCudTTcJC4YMw13XjXJlX3xdqdJG3DKn6nzeHNOqQq/scMJUZwZheMB2
   R8K/pyafYziYFa+xSaTR6M7iYpfXUBIQJzWOLZ1Sg9UvgFPSQtB7JjXGE
   totOwD+rUaS0eHG9xFB9xHwWwzZE+r70RfNWz87rfPcyegqET3GQ1J9KM
   0ECYf7gSOXn6jUG4T/ogAP2nEIog5ILhXo2v0ktRShdiLjvONWol69b2B
   BemzfcVl702oTGsnzCom3FztrSVRcZ1l7BzIZsSmrRpfNSJi7CrOkRZEy
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="253244556"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="253244556"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 01:41:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="628919321"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 27 Apr 2022 01:41:34 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njdEr-0004W9-Av;
        Wed, 27 Apr 2022 08:41:33 +0000
Date:   Wed, 27 Apr 2022 16:41:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     kbuild-all@lists.01.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 10/21] KVM: s390: pci: add basic kvm_zdev structure
Message-ID: <202204271653.1ZoYsV9W-lkp@intel.com>
References: <20220426200842.98655-11-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426200842.98655-11-mjrosato@linux.ibm.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Matthew,

I love your patch! Perhaps something to improve:

[auto build test WARNING on v5.18-rc4]
[cannot apply to s390/features kvms390/next awilliam-vfio/next next-20220427]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Rosato/KVM-s390-enable-zPCI-for-interpretive-execution/20220427-041853
base:    af2d861d4cd2a4da5137f795ee3509e6f944a25b
config: s390-defconfig (https://download.01.org/0day-ci/archive/20220427/202204271653.1ZoYsV9W-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e6d8c620090a7b184afdf5b5123d10ac45776eaf
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Matthew-Rosato/KVM-s390-enable-zPCI-for-interpretive-execution/20220427-041853
        git checkout e6d8c620090a7b184afdf5b5123d10ac45776eaf
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash arch/s390/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/s390/kvm/pci.c:14:5: warning: no previous prototype for 'kvm_s390_pci_dev_open' [-Wmissing-prototypes]
      14 | int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
         |     ^~~~~~~~~~~~~~~~~~~~~
>> arch/s390/kvm/pci.c:29:6: warning: no previous prototype for 'kvm_s390_pci_dev_release' [-Wmissing-prototypes]
      29 | void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~


vim +/kvm_s390_pci_dev_open +14 arch/s390/kvm/pci.c

    13	
  > 14	int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
    15	{
    16		struct kvm_zdev *kzdev;
    17	
    18		kzdev = kzalloc(sizeof(struct kvm_zdev), GFP_KERNEL);
    19		if (!kzdev)
    20			return -ENOMEM;
    21	
    22		kzdev->zdev = zdev;
    23		zdev->kzdev = kzdev;
    24	
    25		return 0;
    26	}
    27	EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_open);
    28	
  > 29	void kvm_s390_pci_dev_release(struct zpci_dev *zdev)

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
