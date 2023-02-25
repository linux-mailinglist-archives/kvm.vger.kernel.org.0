Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB16A27E3
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 09:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBYI23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 03:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBYI22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 03:28:28 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9E712588
        for <kvm@vger.kernel.org>; Sat, 25 Feb 2023 00:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677313707; x=1708849707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FRfHKyxPi8aLPDm+UDHJtowYTxkRIT0GhYIJdi1JAzM=;
  b=MHXiK3ZVlp1NhFaI3ibDdJpvz0gZePE3hQoZkVELe4uGdfjofOYMU2Vx
   kmXi9YnJmEGT9/Jo4x0xvY6TGUxeNuYo/sD03Ygll4HZlBTyiq8vVLMPH
   /OyK47RvoNZunFJCL8KYFu/XrmZi1q1sVhwwMhzPPg9jI6o6iPIkaYIg1
   4GiFhWbg9MKvJMrXz+ZK/6ZnzlSD1m2LV45+kPC0JUXfVigkEZd2M+qE3
   0RP014vyLnNXcZUQn4iu4/IOaRAfitDwGsQ480PbdUNvzrw5Tr1HBgdn1
   3pfB3wnIvspLIFm0cZZ+58SxayIDk5QhLGa/N0yjZg0xKb0nj/lPyAn1m
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="361157066"
X-IronPort-AV: E=Sophos;i="5.97,327,1669104000"; 
   d="scan'208";a="361157066"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2023 00:28:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="675211348"
X-IronPort-AV: E=Sophos;i="5.97,327,1669104000"; 
   d="scan'208";a="675211348"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 25 Feb 2023 00:28:23 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pVpuo-00033f-2o;
        Sat, 25 Feb 2023 08:28:22 +0000
Date:   Sat, 25 Feb 2023 16:28:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, vineetg@rivosinc.com,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v14 19/19] riscv: Enable Vector code to be built
Message-ID: <202302251633.Tsr3ebfs-lkp@intel.com>
References: <20230224170118.16766-20-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-20-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andy,

I love your patch! Perhaps something to improve:

[auto build test WARNING on next-20230224]

url:    https://github.com/intel-lab-lkp/linux/commits/Andy-Chiu/riscv-Rename-__switch_to_aux-fpu/20230225-011059
patch link:    https://lore.kernel.org/r/20230224170118.16766-20-andy.chiu%40sifive.com
patch subject: [PATCH -next v14 19/19] riscv: Enable Vector code to be built
config: riscv-randconfig-r042-20230223 (https://download.01.org/0day-ci/archive/20230225/202302251633.Tsr3ebfs-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/cd0ad21a9ef9d63f1eef80fd3b09ae6e0d884ce3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Andy-Chiu/riscv-Rename-__switch_to_aux-fpu/20230225-011059
        git checkout cd0ad21a9ef9d63f1eef80fd3b09ae6e0d884ce3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash arch/riscv/kernel/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302251633.Tsr3ebfs-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/riscv/kernel/vector.c:67:5: warning: no previous prototype for 'riscv_v_thread_zalloc' [-Wmissing-prototypes]
      67 | int riscv_v_thread_zalloc(void)
         |     ^~~~~~~~~~~~~~~~~~~~~


vim +/riscv_v_thread_zalloc +67 arch/riscv/kernel/vector.c

b57b7b7279ef75 Andy Chiu 2023-02-24  66  
b57b7b7279ef75 Andy Chiu 2023-02-24 @67  int riscv_v_thread_zalloc(void)
b57b7b7279ef75 Andy Chiu 2023-02-24  68  {
b57b7b7279ef75 Andy Chiu 2023-02-24  69  	void *datap;
b57b7b7279ef75 Andy Chiu 2023-02-24  70  
b57b7b7279ef75 Andy Chiu 2023-02-24  71  	datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
b57b7b7279ef75 Andy Chiu 2023-02-24  72  	if (!datap)
b57b7b7279ef75 Andy Chiu 2023-02-24  73  		return -ENOMEM;
b57b7b7279ef75 Andy Chiu 2023-02-24  74  	current->thread.vstate.datap = datap;
b57b7b7279ef75 Andy Chiu 2023-02-24  75  	memset(&current->thread.vstate, 0, offsetof(struct __riscv_v_ext_state,
b57b7b7279ef75 Andy Chiu 2023-02-24  76  						    datap));
b57b7b7279ef75 Andy Chiu 2023-02-24  77  	return 0;
b57b7b7279ef75 Andy Chiu 2023-02-24  78  }
b57b7b7279ef75 Andy Chiu 2023-02-24  79  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
