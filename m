Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25386FD269
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 00:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbjEIWO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 18:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbjEIWO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 18:14:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79633A88
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 15:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683670496; x=1715206496;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xYiT93Red9JyRGuopqOl0RsTbSzpZeUBRmS4gCYdMuo=;
  b=LMnhqCjmzj/w+QdtjTqjt8EM63pMYcpKdv/PuSc7dl29Rwd0OzG7zZ+q
   z6l9jqqsp47i0Gt4vklKDLYrejcyNrUczgeyVdG7Kl4KmLgcQPOSPceaw
   UpMQTM5VDeEtLLhgqVvvXXo6LJ5SKt2l1cN58PN7tSlyiqL3XlTCuB7Wz
   9Lmsx1v35/iO59XlvqADeZvNs0V0AIS34fw9WB5e+4xIB3LdObvDCBEeH
   VVthT31JGEt8XX2pFuNx/7QWBDCm7nqnm/olr5P0ZNwBQSClaZ7F9XsaF
   wsRVqAitzIJwD9f/PWIDp4f8VSZfquz0AXoTOGQrhLWiTR81+wACaImmd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="413347044"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="413347044"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 15:14:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="1028968131"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="1028968131"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 09 May 2023 15:14:53 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pwVbg-0002Yo-2K;
        Tue, 09 May 2023 22:14:52 +0000
Date:   Wed, 10 May 2023 06:14:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, vineetg@rivosinc.com,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v19 23/24] riscv: Enable Vector code to be built
Message-ID: <202305100615.JXidADRN-lkp@intel.com>
References: <20230509103033.11285-24-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509103033.11285-24-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andy,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20230509]

url:    https://github.com/intel-lab-lkp/linux/commits/Andy-Chiu/riscv-Rename-__switch_to_aux-fpu/20230509-183621
base:   next-20230509
patch link:    https://lore.kernel.org/r/20230509103033.11285-24-andy.chiu%40sifive.com
patch subject: [PATCH -next v19 23/24] riscv: Enable Vector code to be built
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20230510/202305100615.JXidADRN-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/cacd7c504c93b48a44b87516cfdbe417dca4d007
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Andy-Chiu/riscv-Rename-__switch_to_aux-fpu/20230509-183621
        git checkout cacd7c504c93b48a44b87516cfdbe417dca4d007
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305100615.JXidADRN-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "riscv_v_user_allowed" [arch/riscv/kvm/kvm.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
