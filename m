Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F16B58F833
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 09:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbiHKHR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 03:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiHKHRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 03:17:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00902760C4
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 00:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660202245; x=1691738245;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3KYvpST+bKbnrxkz5t5MctHL3D3UTy9lSqp411H2Tmk=;
  b=hoTHbxTvPf/vNlz1nZvKijsPNSmbtbLiPYL581suHHKXlSR2ZhhtLkNr
   8+hnvsOE7EH9q4zS8vYynOpNm/cu7cVU9vC7xI6J06T3wmfGxnV+j4VWH
   SWAOZtFOR+CQG4bYCa3VzAsKOXbsHEkHRaoxYDQydlQFeSRSA/cdUalM9
   Y5mqNZLp6TRstrJfjQ6Bq3Qh4hHUs3Migp0G807MzviI/Ix4V/HChJko7
   +RpI6OuSrFgzo/aYse1kDkgUH9PfQoXVzokpUkPPhTGt7FibzeN3M05he
   ro8YGRZ/yJYcQ6o5CuVmXo6/uKOqtIAIFl7XS8dJChpk6fNYVYbPpRj/R
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="274335637"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="274335637"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 00:16:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="556029924"
Received: from lkp-server02.sh.intel.com (HELO d10ab0927833) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 11 Aug 2022 00:16:55 -0700
Received: from kbuild by d10ab0927833 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oM2R4-00005F-1n;
        Thu, 11 Aug 2022 07:16:54 +0000
Date:   Thu, 11 Aug 2022 15:16:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     kbuild-all@lists.01.org, Peter Collingbourne <pcc@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v3 3/7] mm: Add PG_arch_3 page flag
Message-ID: <202208111500.62e0Bl2l-lkp@intel.com>
References: <20220810193033.1090251-4-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-4-pcc@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on arm64/for-next/core]
[also build test WARNING on linus/master next-20220811]
[cannot apply to kvmarm/next arm/for-next soc/for-next xilinx-xlnx/master v5.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Collingbourne/KVM-arm64-permit-MAP_SHARED-mappings-with-MTE-enabled/20220811-033310
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20220811/202208111500.62e0Bl2l-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1a400517d8428df0ec9f86f8d303b2227ee9702f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Peter-Collingbourne/KVM-arm64-permit-MAP_SHARED-mappings-with-MTE-enabled/20220811-033310
        git checkout 1a400517d8428df0ec9f86f8d303b2227ee9702f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> mm/memory.c:92:2: warning: #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid. [-Wcpp]
      92 | #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
         |  ^~~~~~~


vim +92 mm/memory.c

42b7772812d15b Jan Beulich    2008-07-23  90  
af27d9403f5b80 Arnd Bergmann  2018-02-16  91  #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
90572890d20252 Peter Zijlstra 2013-10-07 @92  #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
75980e97daccfc Peter Zijlstra 2013-02-22  93  #endif
75980e97daccfc Peter Zijlstra 2013-02-22  94  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
