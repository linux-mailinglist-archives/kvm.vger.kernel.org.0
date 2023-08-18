Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC64780509
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 06:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357823AbjHRELN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 00:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357832AbjHREKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 00:10:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554753A89;
        Thu, 17 Aug 2023 21:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692331847; x=1723867847;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y2djJBYqGtFodSH9SQOROqUVVnPYUs6bFkWU16CvT7w=;
  b=Q/RsIkP80wRTaVc+3LNxd+OGTdqoOLrzsa4ER62mAoMRBbti0dL53caE
   r+q8ES+RKPMQagy+zoIHR8pt8kzFfRXATDje5WNVmQY/EF/URoU1PXdwK
   w5haT5qiYqQn+RYgGMmv7OaHroY9PUOAnAV1nagM9M7u5osJU1BNvjXdc
   ZTu1bJpowxnGCDIp9kMJLKv5d0ESBWOEjKhigtvqSSK1+wUzr+Tcz2RTK
   8MSd3qvmHPkCAKyuo/wywGHhTj/HQ9qNCtciEywYhAcnmnUrx0yaAW9jz
   pqXnsWej+klOX3inQITcOBV4DBXFeJfnNntnm1bz5jcQPB7O5dEKK6KKd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="363167365"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="363167365"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 21:10:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="684717365"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="684717365"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 17 Aug 2023 21:10:44 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qWqot-00025G-1l;
        Fri, 18 Aug 2023 04:10:43 +0000
Date:   Fri, 18 Aug 2023 12:09:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com, jgg@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com
Cc:     oe-kbuild-all@lists.linux.dev, shannon.nelson@amd.com,
        brett.creeley@amd.com
Subject: Re: [PATCH vfio] pds_core: Fix function header descriptions
Message-ID: <202308181138.U4cZ1nIO-lkp@intel.com>
References: <20230817224212.14266-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817224212.14266-1-brett.creeley@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Brett,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.5-rc6 next-20230817]
[cannot apply to horms-ipvs/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Brett-Creeley/pds_core-Fix-function-header-descriptions/20230818-064424
base:   linus/master
patch link:    https://lore.kernel.org/r/20230817224212.14266-1-brett.creeley%40amd.com
patch subject: [PATCH vfio] pds_core: Fix function header descriptions
config: powerpc-allyesconfig (https://download.01.org/0day-ci/archive/20230818/202308181138.U4cZ1nIO-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230818/202308181138.U4cZ1nIO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308181138.U4cZ1nIO-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/amd/pds_core/auxbus.c:18: warning: Function parameter or member 'pf_pdev' not described in 'pds_client_register'
>> drivers/net/ethernet/amd/pds_core/auxbus.c:18: warning: Excess function parameter 'pf' description in 'pds_client_register'
>> drivers/net/ethernet/amd/pds_core/auxbus.c:63: warning: Function parameter or member 'pf_pdev' not described in 'pds_client_unregister'
>> drivers/net/ethernet/amd/pds_core/auxbus.c:63: warning: Excess function parameter 'pf' description in 'pds_client_unregister'


vim +18 drivers/net/ethernet/amd/pds_core/auxbus.c

4569cce43bc61e Shannon Nelson 2023-04-19   8  
10659034c62273 Shannon Nelson 2023-04-19   9  /**
10659034c62273 Shannon Nelson 2023-04-19  10   * pds_client_register - Link the client to the firmware
5808b1c50a443e Brett Creeley  2023-08-17  11   * @pf:		ptr to the PF driver's private data struct
10659034c62273 Shannon Nelson 2023-04-19  12   * @devname:	name that includes service into, e.g. pds_core.vDPA
10659034c62273 Shannon Nelson 2023-04-19  13   *
10659034c62273 Shannon Nelson 2023-04-19  14   * Return: 0 on success, or
10659034c62273 Shannon Nelson 2023-04-19  15   *         negative for error
10659034c62273 Shannon Nelson 2023-04-19  16   */
10659034c62273 Shannon Nelson 2023-04-19  17  int pds_client_register(struct pci_dev *pf_pdev, char *devname)
10659034c62273 Shannon Nelson 2023-04-19 @18  {
10659034c62273 Shannon Nelson 2023-04-19  19  	union pds_core_adminq_comp comp = {};
10659034c62273 Shannon Nelson 2023-04-19  20  	union pds_core_adminq_cmd cmd = {};
10659034c62273 Shannon Nelson 2023-04-19  21  	struct pdsc *pf;
10659034c62273 Shannon Nelson 2023-04-19  22  	int err;
10659034c62273 Shannon Nelson 2023-04-19  23  	u16 ci;
10659034c62273 Shannon Nelson 2023-04-19  24  
10659034c62273 Shannon Nelson 2023-04-19  25  	pf = pci_get_drvdata(pf_pdev);
10659034c62273 Shannon Nelson 2023-04-19  26  	if (pf->state)
10659034c62273 Shannon Nelson 2023-04-19  27  		return -ENXIO;
10659034c62273 Shannon Nelson 2023-04-19  28  
10659034c62273 Shannon Nelson 2023-04-19  29  	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
10659034c62273 Shannon Nelson 2023-04-19  30  	strscpy(cmd.client_reg.devname, devname,
10659034c62273 Shannon Nelson 2023-04-19  31  		sizeof(cmd.client_reg.devname));
10659034c62273 Shannon Nelson 2023-04-19  32  
10659034c62273 Shannon Nelson 2023-04-19  33  	err = pdsc_adminq_post(pf, &cmd, &comp, false);
10659034c62273 Shannon Nelson 2023-04-19  34  	if (err) {
10659034c62273 Shannon Nelson 2023-04-19  35  		dev_info(pf->dev, "register dev_name %s with DSC failed, status %d: %pe\n",
10659034c62273 Shannon Nelson 2023-04-19  36  			 devname, comp.status, ERR_PTR(err));
10659034c62273 Shannon Nelson 2023-04-19  37  		return err;
10659034c62273 Shannon Nelson 2023-04-19  38  	}
10659034c62273 Shannon Nelson 2023-04-19  39  
10659034c62273 Shannon Nelson 2023-04-19  40  	ci = le16_to_cpu(comp.client_reg.client_id);
10659034c62273 Shannon Nelson 2023-04-19  41  	if (!ci) {
10659034c62273 Shannon Nelson 2023-04-19  42  		dev_err(pf->dev, "%s: device returned null client_id\n",
10659034c62273 Shannon Nelson 2023-04-19  43  			__func__);
10659034c62273 Shannon Nelson 2023-04-19  44  		return -EIO;
10659034c62273 Shannon Nelson 2023-04-19  45  	}
10659034c62273 Shannon Nelson 2023-04-19  46  
10659034c62273 Shannon Nelson 2023-04-19  47  	dev_dbg(pf->dev, "%s: device returned client_id %d for %s\n",
10659034c62273 Shannon Nelson 2023-04-19  48  		__func__, ci, devname);
10659034c62273 Shannon Nelson 2023-04-19  49  
10659034c62273 Shannon Nelson 2023-04-19  50  	return ci;
10659034c62273 Shannon Nelson 2023-04-19  51  }
10659034c62273 Shannon Nelson 2023-04-19  52  EXPORT_SYMBOL_GPL(pds_client_register);
10659034c62273 Shannon Nelson 2023-04-19  53  
10659034c62273 Shannon Nelson 2023-04-19  54  /**
10659034c62273 Shannon Nelson 2023-04-19  55   * pds_client_unregister - Unlink the client from the firmware
5808b1c50a443e Brett Creeley  2023-08-17  56   * @pf:		ptr to the PF driver's private data struct
10659034c62273 Shannon Nelson 2023-04-19  57   * @client_id:	id returned from pds_client_register()
10659034c62273 Shannon Nelson 2023-04-19  58   *
10659034c62273 Shannon Nelson 2023-04-19  59   * Return: 0 on success, or
10659034c62273 Shannon Nelson 2023-04-19  60   *         negative for error
10659034c62273 Shannon Nelson 2023-04-19  61   */
10659034c62273 Shannon Nelson 2023-04-19  62  int pds_client_unregister(struct pci_dev *pf_pdev, u16 client_id)
10659034c62273 Shannon Nelson 2023-04-19 @63  {
10659034c62273 Shannon Nelson 2023-04-19  64  	union pds_core_adminq_comp comp = {};
10659034c62273 Shannon Nelson 2023-04-19  65  	union pds_core_adminq_cmd cmd = {};
10659034c62273 Shannon Nelson 2023-04-19  66  	struct pdsc *pf;
10659034c62273 Shannon Nelson 2023-04-19  67  	int err;
10659034c62273 Shannon Nelson 2023-04-19  68  
10659034c62273 Shannon Nelson 2023-04-19  69  	pf = pci_get_drvdata(pf_pdev);
10659034c62273 Shannon Nelson 2023-04-19  70  	if (pf->state)
10659034c62273 Shannon Nelson 2023-04-19  71  		return -ENXIO;
10659034c62273 Shannon Nelson 2023-04-19  72  
10659034c62273 Shannon Nelson 2023-04-19  73  	cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
10659034c62273 Shannon Nelson 2023-04-19  74  	cmd.client_unreg.client_id = cpu_to_le16(client_id);
10659034c62273 Shannon Nelson 2023-04-19  75  
10659034c62273 Shannon Nelson 2023-04-19  76  	err = pdsc_adminq_post(pf, &cmd, &comp, false);
10659034c62273 Shannon Nelson 2023-04-19  77  	if (err)
10659034c62273 Shannon Nelson 2023-04-19  78  		dev_info(pf->dev, "unregister client_id %d failed, status %d: %pe\n",
10659034c62273 Shannon Nelson 2023-04-19  79  			 client_id, comp.status, ERR_PTR(err));
10659034c62273 Shannon Nelson 2023-04-19  80  
10659034c62273 Shannon Nelson 2023-04-19  81  	return err;
10659034c62273 Shannon Nelson 2023-04-19  82  }
10659034c62273 Shannon Nelson 2023-04-19  83  EXPORT_SYMBOL_GPL(pds_client_unregister);
10659034c62273 Shannon Nelson 2023-04-19  84  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
