Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D1C6E07C4
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 09:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjDMHdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 03:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDMHc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 03:32:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941678A64;
        Thu, 13 Apr 2023 00:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681371171; x=1712907171;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j9RjopZ1zWdwidiAtobep0zbvNZuMsow/F+RhAfslE4=;
  b=d3Yd+Egt1C4TZg+lVFPGxo9SO49p+4Xn5SS5nGbwhAMrDRZtpCpnTYf8
   RGq0SY89KjgINJS1E0N+U46jrEpvUEknrFdL/KOIvRFrh+y9mutkxjfz7
   6n4Iz2gkDHDHzKn3W3rWerbSwW4NcrAioLc2d6Y/LAyDWLY7Pc7/OdQ5z
   D1V23Uc/qX1H5lOdHvPY00rQ84qUhICrXoni/oRRTvwGZqqVpS9BvoLdL
   QyOs7+xv7CLf/NM4agLMzT8WLDR4WL4zFYJRovO3ueoXPNcX2fg2+KK9Y
   kyvGRh0HU4pFRMWZFEfNRQVGFagSOTEPiJXdariHVRX0PsXFOzFXqKTOJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="345904184"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="345904184"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 00:32:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="682850359"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="682850359"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 13 Apr 2023 00:32:41 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pmrRg-000YUX-0B;
        Thu, 13 Apr 2023 07:32:40 +0000
Date:   Thu, 13 Apr 2023 15:32:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: Re: [PATCH v6 29/30] LoongArch: KVM: Enable kvm config and add the
 makefile
Message-ID: <202304131526.iXfLaVZc-lkp@intel.com>
References: <20230412083023.1693910-30-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412083023.1693910-30-zhaotianrui@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianrui,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on linus/master v6.3-rc6 next-20230412]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230412-163935
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230412083023.1693910-30-zhaotianrui%40loongson.cn
patch subject: [PATCH v6 29/30] LoongArch: KVM: Enable kvm config and add the makefile
config: loongarch-randconfig-c033-20230413 (https://download.01.org/0day-ci/archive/20230413/202304131526.iXfLaVZc-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/19c2472bf2612603ce4671e06fb185516a99e040
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230412-163935
        git checkout 19c2472bf2612603ce4671e06fb185516a99e040
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash arch/loongarch/kvm/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from arch/loongarch/include/asm/cpu-info.h:11,
                    from arch/loongarch/include/asm/processor.h:13,
                    from arch/loongarch/include/asm/thread_info.h:15,
                    from include/linux/thread_info.h:60,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/loongarch/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:78,
                    from include/linux/percpu.h:6,
                    from include/linux/context_tracking_state.h:5,
                    from include/linux/hardirq.h:5,
                    from include/linux/kvm_host.h:7,
                    from arch/loongarch/kvm/vcpu.c:6:
   In function 'gcsr_read',
       inlined from 'kvm_save_hw_gcsr' at arch/loongarch/include/asm/kvm_csr.h:24:19:
>> arch/loongarch/include/asm/loongarch.h:244:9: warning: 'asm' operand 1 probably does not match constraints
     244 |         asm volatile (
         |         ^~~
>> arch/loongarch/include/asm/loongarch.h:244:9: error: impossible constraint in 'asm'
   In function 'gcsr_write',
       inlined from 'kvm_restore_hw_gcsr' at arch/loongarch/include/asm/kvm_csr.h:29:2:
   arch/loongarch/include/asm/loongarch.h:261:9: warning: 'asm' operand 1 probably does not match constraints
     261 |         asm volatile (
         |         ^~~


vim +/asm +244 arch/loongarch/include/asm/loongarch.h

f2ac457a61389b Huacai Chen  2022-05-31  238  
2c87b678639d25 Tianrui Zhao 2023-04-12  239  /* GCSR */
2c87b678639d25 Tianrui Zhao 2023-04-12  240  static inline u64 gcsr_read(u32 reg)
2c87b678639d25 Tianrui Zhao 2023-04-12  241  {
2c87b678639d25 Tianrui Zhao 2023-04-12  242  	u64 val = 0;
2c87b678639d25 Tianrui Zhao 2023-04-12  243  	/* Instructions will be available in binutils later */
2c87b678639d25 Tianrui Zhao 2023-04-12 @244  	asm volatile (
2c87b678639d25 Tianrui Zhao 2023-04-12  245  		"parse_r __reg, %[val]\n\t"
2c87b678639d25 Tianrui Zhao 2023-04-12  246  		/*
2c87b678639d25 Tianrui Zhao 2023-04-12  247  		 * read val from guest csr register %[reg]
2c87b678639d25 Tianrui Zhao 2023-04-12  248  		 * gcsrrd %[val], %[reg]
2c87b678639d25 Tianrui Zhao 2023-04-12  249  		 */
2c87b678639d25 Tianrui Zhao 2023-04-12  250  		".word 0x5 << 24 | %[reg] << 10 | 0 << 5 | __reg\n\t"
2c87b678639d25 Tianrui Zhao 2023-04-12  251  		: [val] "+r" (val)
2c87b678639d25 Tianrui Zhao 2023-04-12  252  		: [reg] "i" (reg)
2c87b678639d25 Tianrui Zhao 2023-04-12  253  		: "memory");
2c87b678639d25 Tianrui Zhao 2023-04-12  254  
2c87b678639d25 Tianrui Zhao 2023-04-12  255  	return val;
2c87b678639d25 Tianrui Zhao 2023-04-12  256  }
2c87b678639d25 Tianrui Zhao 2023-04-12  257  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
