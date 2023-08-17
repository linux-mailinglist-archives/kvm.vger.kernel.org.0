Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D3277FF20
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 22:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354940AbjHQUdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 16:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354990AbjHQUdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 16:33:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EA1E7C
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 13:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692304379; x=1723840379;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=36qXCapYBm85YtMXUQ87EbsqxuvHucyrEPuH18J9Tlo=;
  b=Ffe59HQAeSOQSKi0glKjsshXgj3ZAa3hJY8r4raGPMsEFuvNWVymNe+5
   zTRZsPNjUvNRAnF47kP5wgtsd4aatQhYIcQBBwbLI68oh6ZY+fNxNOjh0
   ra5yv9diLeja2zaDOsc2M6c39pZsi9kA8F3f05K4S3KPgtSY99fV8yiHE
   OcXJ61toZqcs7d2a1/r2dQaTMHJ2abJ+MRj/V3htyoofWhU+Shp/LxyI2
   M1Juqimwm2TYBtjRrGKbhRR2hggAZ1CEYtMrJsewv8czskPLQirqSH5NK
   UwY+DJC62rWJGrIZFF6MPUg8PXFn/lR51V3IrCB9Ec2jQB8MIucjPzOMc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="403904924"
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="403904924"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 13:32:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="737852380"
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="737852380"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 17 Aug 2023 13:32:57 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qWjfs-0001SV-1t;
        Thu, 17 Aug 2023 20:32:56 +0000
Date:   Fri, 18 Aug 2023 04:32:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [awilliam-vfio:next 41/50]
 drivers/net/ethernet/amd/pds_core/auxbus.c:18: warning: Function parameter
 or member 'pf' not described in 'pds_client_register'
Message-ID: <202308180411.OSqJPtMz-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://github.com/awilliam/linux-vfio.git next
head:   a881b496941f02fe620c5708a4af68762b24c33d
commit: b021d05e106e14b603a584b38ce62720e7d0f363 [41/50] pds_core: Require callers of register/unregister to pass PF drvdata
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20230818/202308180411.OSqJPtMz-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230818/202308180411.OSqJPtMz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308180411.OSqJPtMz-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/amd/pds_core/auxbus.c:18: warning: Function parameter or member 'pf' not described in 'pds_client_register'
>> drivers/net/ethernet/amd/pds_core/auxbus.c:18: warning: Excess function parameter 'pf_pdev' description in 'pds_client_register'
>> drivers/net/ethernet/amd/pds_core/auxbus.c:58: warning: Function parameter or member 'pf' not described in 'pds_client_unregister'
>> drivers/net/ethernet/amd/pds_core/auxbus.c:58: warning: Excess function parameter 'pf_pdev' description in 'pds_client_unregister'


vim +18 drivers/net/ethernet/amd/pds_core/auxbus.c

4569cce43bc61e Shannon Nelson 2023-04-19   8  
10659034c62273 Shannon Nelson 2023-04-19   9  /**
10659034c62273 Shannon Nelson 2023-04-19  10   * pds_client_register - Link the client to the firmware
10659034c62273 Shannon Nelson 2023-04-19  11   * @pf_pdev:	ptr to the PF driver struct
10659034c62273 Shannon Nelson 2023-04-19  12   * @devname:	name that includes service into, e.g. pds_core.vDPA
10659034c62273 Shannon Nelson 2023-04-19  13   *
10659034c62273 Shannon Nelson 2023-04-19  14   * Return: 0 on success, or
10659034c62273 Shannon Nelson 2023-04-19  15   *         negative for error
10659034c62273 Shannon Nelson 2023-04-19  16   */
b021d05e106e14 Brett Creeley  2023-08-07  17  int pds_client_register(struct pdsc *pf, char *devname)
10659034c62273 Shannon Nelson 2023-04-19 @18  {
10659034c62273 Shannon Nelson 2023-04-19  19  	union pds_core_adminq_comp comp = {};
10659034c62273 Shannon Nelson 2023-04-19  20  	union pds_core_adminq_cmd cmd = {};
10659034c62273 Shannon Nelson 2023-04-19  21  	int err;
10659034c62273 Shannon Nelson 2023-04-19  22  	u16 ci;
10659034c62273 Shannon Nelson 2023-04-19  23  
10659034c62273 Shannon Nelson 2023-04-19  24  	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
10659034c62273 Shannon Nelson 2023-04-19  25  	strscpy(cmd.client_reg.devname, devname,
10659034c62273 Shannon Nelson 2023-04-19  26  		sizeof(cmd.client_reg.devname));
10659034c62273 Shannon Nelson 2023-04-19  27  
10659034c62273 Shannon Nelson 2023-04-19  28  	err = pdsc_adminq_post(pf, &cmd, &comp, false);
10659034c62273 Shannon Nelson 2023-04-19  29  	if (err) {
10659034c62273 Shannon Nelson 2023-04-19  30  		dev_info(pf->dev, "register dev_name %s with DSC failed, status %d: %pe\n",
10659034c62273 Shannon Nelson 2023-04-19  31  			 devname, comp.status, ERR_PTR(err));
10659034c62273 Shannon Nelson 2023-04-19  32  		return err;
10659034c62273 Shannon Nelson 2023-04-19  33  	}
10659034c62273 Shannon Nelson 2023-04-19  34  
10659034c62273 Shannon Nelson 2023-04-19  35  	ci = le16_to_cpu(comp.client_reg.client_id);
10659034c62273 Shannon Nelson 2023-04-19  36  	if (!ci) {
10659034c62273 Shannon Nelson 2023-04-19  37  		dev_err(pf->dev, "%s: device returned null client_id\n",
10659034c62273 Shannon Nelson 2023-04-19  38  			__func__);
10659034c62273 Shannon Nelson 2023-04-19  39  		return -EIO;
10659034c62273 Shannon Nelson 2023-04-19  40  	}
10659034c62273 Shannon Nelson 2023-04-19  41  
10659034c62273 Shannon Nelson 2023-04-19  42  	dev_dbg(pf->dev, "%s: device returned client_id %d for %s\n",
10659034c62273 Shannon Nelson 2023-04-19  43  		__func__, ci, devname);
10659034c62273 Shannon Nelson 2023-04-19  44  
10659034c62273 Shannon Nelson 2023-04-19  45  	return ci;
10659034c62273 Shannon Nelson 2023-04-19  46  }
10659034c62273 Shannon Nelson 2023-04-19  47  EXPORT_SYMBOL_GPL(pds_client_register);
10659034c62273 Shannon Nelson 2023-04-19  48  
10659034c62273 Shannon Nelson 2023-04-19  49  /**
10659034c62273 Shannon Nelson 2023-04-19  50   * pds_client_unregister - Unlink the client from the firmware
10659034c62273 Shannon Nelson 2023-04-19  51   * @pf_pdev:	ptr to the PF driver struct
10659034c62273 Shannon Nelson 2023-04-19  52   * @client_id:	id returned from pds_client_register()
10659034c62273 Shannon Nelson 2023-04-19  53   *
10659034c62273 Shannon Nelson 2023-04-19  54   * Return: 0 on success, or
10659034c62273 Shannon Nelson 2023-04-19  55   *         negative for error
10659034c62273 Shannon Nelson 2023-04-19  56   */
b021d05e106e14 Brett Creeley  2023-08-07  57  int pds_client_unregister(struct pdsc *pf, u16 client_id)
10659034c62273 Shannon Nelson 2023-04-19 @58  {
10659034c62273 Shannon Nelson 2023-04-19  59  	union pds_core_adminq_comp comp = {};
10659034c62273 Shannon Nelson 2023-04-19  60  	union pds_core_adminq_cmd cmd = {};
10659034c62273 Shannon Nelson 2023-04-19  61  	int err;
10659034c62273 Shannon Nelson 2023-04-19  62  
10659034c62273 Shannon Nelson 2023-04-19  63  	cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
10659034c62273 Shannon Nelson 2023-04-19  64  	cmd.client_unreg.client_id = cpu_to_le16(client_id);
10659034c62273 Shannon Nelson 2023-04-19  65  
10659034c62273 Shannon Nelson 2023-04-19  66  	err = pdsc_adminq_post(pf, &cmd, &comp, false);
10659034c62273 Shannon Nelson 2023-04-19  67  	if (err)
10659034c62273 Shannon Nelson 2023-04-19  68  		dev_info(pf->dev, "unregister client_id %d failed, status %d: %pe\n",
10659034c62273 Shannon Nelson 2023-04-19  69  			 client_id, comp.status, ERR_PTR(err));
10659034c62273 Shannon Nelson 2023-04-19  70  
10659034c62273 Shannon Nelson 2023-04-19  71  	return err;
10659034c62273 Shannon Nelson 2023-04-19  72  }
10659034c62273 Shannon Nelson 2023-04-19  73  EXPORT_SYMBOL_GPL(pds_client_unregister);
10659034c62273 Shannon Nelson 2023-04-19  74  

:::::: The code at line 18 was first introduced by commit
:::::: 10659034c622738bc1bfab8a76fc576c52d5acce pds_core: add the aux client API

:::::: TO: Shannon Nelson <shannon.nelson@amd.com>
:::::: CC: David S. Miller <davem@davemloft.net>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
