Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCAC6A6432
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 01:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjCAAYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 19:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCAAYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 19:24:05 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED72B763;
        Tue, 28 Feb 2023 16:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677630244; x=1709166244;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yoZkfu3SK5uDBzze9pglBHWSzN6bUknAkIvbsUywnaQ=;
  b=U4pmSIr8QxgTf2sIxjMl34Gg5kYO4KwOOet1GzgtyjfOD7xgLknhpR5z
   UeiL5P+BSouSSwVWMMfZ+zK1JORWtKLgGSzH6S4jeL1GuYqgEqKghIn2t
   uQtp+u0n7AfaqQ9Wu8a1oHLNGujlfXyqZVhrHKE3MiWyPlZwh4a3nTOia
   yM7rlziZiSrj1tKyEDbTsqtWUmoL8RzL/PA3Ypia/QiYx8EAgc0DoUgEh
   ebSyIjTmQp2OLiXdfXPKXyk4WjaTzXHRz+ULOfU0QRzqa/Le0rIkOHzrC
   0LN21llO9Ktea/Tvtu7myXu/n4bwyGSqYTr1yxxSc2Gp2KwCLO+iHDmRO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="334320108"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="334320108"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 16:24:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="706774375"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="706774375"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2023 16:23:58 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pXAGD-0005kb-1U;
        Wed, 01 Mar 2023 00:23:57 +0000
Date:   Wed, 1 Mar 2023 08:23:02 +0800
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
        Xi Ruoyao <xry111@xry111.site>
Subject: Re: [PATCH v3 29/29] LoongArch: KVM: Enable kvm config and add the
 makefile
Message-ID: <202303010850.bV3yQ7cW-lkp@intel.com>
References: <20230228070057.3687180-30-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228070057.3687180-30-zhaotianrui@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianrui,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/queue]
[also build test WARNING on linus/master v6.2 next-20230228]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230228-151250
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230228070057.3687180-30-zhaotianrui%40loongson.cn
patch subject: [PATCH v3 29/29] LoongArch: KVM: Enable kvm config and add the makefile
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20230301/202303010850.bV3yQ7cW-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7833c6dd07758557e28d69f9138c83adfbf06aeb
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230228-151250
        git checkout 7833c6dd07758557e28d69f9138c83adfbf06aeb
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash arch/loongarch/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303010850.bV3yQ7cW-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:102,
                    from arch/loongarch/kvm/trace.h:169,
                    from arch/loongarch/kvm/vcpu.c:14:
   arch/loongarch/kvm/./trace.h: In function 'trace_raw_output_kvm_exit_gspr':
>> arch/loongarch/kvm/./trace.h:69:23: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat=]
      69 |             TP_printk("inst word: 0x%08lx",
         |                       ^~~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit_gspr,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:69:13: note: in expansion of macro 'TP_printk'
      69 |             TP_printk("inst word: 0x%08lx",
         |             ^~~~~~~~~
   In file included from include/trace/trace_events.h:237:
   arch/loongarch/kvm/./trace.h:69:41: note: format string is defined here
      69 |             TP_printk("inst word: 0x%08lx",
         |                                     ~~~~^
         |                                         |
         |                                         long unsigned int
         |                                     %08x
   arch/loongarch/kvm/./trace.h: In function 'trace_raw_output_kvm_exit':
   arch/loongarch/kvm/./trace.h:54:31: warning: left-hand operand of comma expression has no effect [-Wunused-value]
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |                               ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:89:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      89 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:54:48: error: expected ';' before '}' token
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |                                                ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:89:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      89 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:54:49: error: expected ')' before ',' token
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |                                                 ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:89:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      89 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:54:9: warning: initialization of 'long unsigned int' from 'char *' makes integer from pointer without a cast [-Wint-conversion]
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:89:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      89 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:54:9: note: (near initialization for 'symbols[0].mask')
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:89:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      89 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:54:9: error: initializer element is not constant
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |         ^


vim +69 arch/loongarch/kvm/./trace.h

2747799ba604af Tianrui Zhao 2023-02-28  51  
2747799ba604af Tianrui Zhao 2023-02-28  52  /* Tracepoints for VM exits */
2747799ba604af Tianrui Zhao 2023-02-28  53  #define kvm_trace_symbol_exit_types					\
2747799ba604af Tianrui Zhao 2023-02-28  54  	({ KVM_TRACE_EXIT_IDLE,		"IDLE" },			\
2747799ba604af Tianrui Zhao 2023-02-28  55  	{ KVM_TRACE_EXIT_CACHE,		"CACHE" },			\
2747799ba604af Tianrui Zhao 2023-02-28  56  	{ KVM_TRACE_EXIT_SIGNAL,	"Signal" })
2747799ba604af Tianrui Zhao 2023-02-28  57  
2747799ba604af Tianrui Zhao 2023-02-28  58  TRACE_EVENT(kvm_exit_gspr,
2747799ba604af Tianrui Zhao 2023-02-28  59  	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int inst_word),
2747799ba604af Tianrui Zhao 2023-02-28  60  	    TP_ARGS(vcpu, inst_word),
2747799ba604af Tianrui Zhao 2023-02-28  61  	    TP_STRUCT__entry(
2747799ba604af Tianrui Zhao 2023-02-28  62  			__field(unsigned int, inst_word)
2747799ba604af Tianrui Zhao 2023-02-28  63  	    ),
2747799ba604af Tianrui Zhao 2023-02-28  64  
2747799ba604af Tianrui Zhao 2023-02-28  65  	    TP_fast_assign(
2747799ba604af Tianrui Zhao 2023-02-28  66  			__entry->inst_word = inst_word;
2747799ba604af Tianrui Zhao 2023-02-28  67  	    ),
2747799ba604af Tianrui Zhao 2023-02-28  68  
2747799ba604af Tianrui Zhao 2023-02-28 @69  	    TP_printk("inst word: 0x%08lx",
2747799ba604af Tianrui Zhao 2023-02-28  70  		      __entry->inst_word)
2747799ba604af Tianrui Zhao 2023-02-28  71  );
2747799ba604af Tianrui Zhao 2023-02-28  72  
2747799ba604af Tianrui Zhao 2023-02-28  73  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
