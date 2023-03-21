Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286886C2D0E
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 09:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjCUIvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 04:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCUIup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 04:50:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAD04617D;
        Tue, 21 Mar 2023 01:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679388506; x=1710924506;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4p0m8lcg69YUKsyll1H1PxmSTAHL+XGXfmKtu0jovSo=;
  b=ksI5LnWsTS/i80GMArgDGGuqhT6zPe4im2odD5pDfRzb5hRtSosb5DyL
   IDZYEqeNxM18F5nqcG3fir+w4R6x/qT3NkFaHrHMLdXXIpIneMl8fcZPo
   UNCVTcdn4sKzV1vzfzgAOvx7jJjkj+wOeqigNadAzxVoEimxuWOZ9l21w
   59lWLnuux1/UrBeY5Jun1veReePGXCaV/QFKfYOblG2LTrIQWGa40QiLd
   /s0694ykTCEF+tBKf54MjM3nV/NvF5xpiLxUDQ2bFCN5FFoovevQQCC+l
   vNU/Xq80OS8NCdES8fd1ziQ5C6Jl6XBXwzlAz33yFTQIKgRba24v8ba22
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="337605502"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="337605502"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 01:48:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="770547483"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="770547483"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Mar 2023 01:48:20 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peXfI-000BmE-0y;
        Tue, 21 Mar 2023 08:48:20 +0000
Date:   Tue, 21 Mar 2023 16:48:05 +0800
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
Subject: Re: [PATCH v4 29/29] LoongArch: KVM: Enable kvm config and add the
 makefile
Message-ID: <202303211656.Qs5OrgVh-lkp@intel.com>
References: <20230321035651.598505-30-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321035651.598505-30-zhaotianrui@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianrui,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/queue]
[also build test ERROR on linus/master v6.3-rc3 next-20230321]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230321-120249
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230321035651.598505-30-zhaotianrui%40loongson.cn
patch subject: [PATCH v4 29/29] LoongArch: KVM: Enable kvm config and add the makefile
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20230321/202303211656.Qs5OrgVh-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/620334822242c573db9db17e9727fbe430ba42b9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230321-120249
        git checkout 620334822242c573db9db17e9727fbe430ba42b9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash arch/loongarch/kvm/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303211656.Qs5OrgVh-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:102,
                    from arch/loongarch/kvm/trace.h:169,
                    from arch/loongarch/kvm/vcpu.c:14:
   arch/loongarch/kvm/./trace.h: In function 'trace_raw_output_kvm_exit':
   arch/loongarch/kvm/./trace.h:54:31: warning: left-hand operand of comma expression has no effect [-Wunused-value]
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },       \
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
>> arch/loongarch/kvm/./trace.h:54:48: error: expected ';' before '}' token
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },       \
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
>> arch/loongarch/kvm/./trace.h:54:49: error: expected ')' before ',' token
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },       \
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
>> arch/loongarch/kvm/./trace.h:54:9: warning: initialization of 'long unsigned int' from 'char *' makes integer from pointer without a cast [-Wint-conversion]
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },       \
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
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },       \
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
>> arch/loongarch/kvm/./trace.h:54:9: error: initializer element is not constant
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },       \
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
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },       \
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
>> include/trace/stages/stage3_trace_output.h:77:37: warning: braces around scalar initializer
      77 |                 static const struct trace_print_flags symbols[] =       \
         |                                     ^~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   include/trace/stages/stage3_trace_output.h:77:37: note: (near initialization for 'symbols[0].name')
      77 |                 static const struct trace_print_flags symbols[] =       \
         |                                     ^~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
>> include/trace/stages/stage3_trace_output.h:78:43: warning: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                           ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   include/trace/stages/stage3_trace_output.h:78:43: note: (near initialization for 'symbols[0].name')
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                           ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   include/linux/stddef.h:8:14: warning: excess elements in scalar initializer
       8 | #define NULL ((void *)0)
         |              ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   include/trace/stages/stage3_trace_output.h:78:47: note: in expansion of macro 'NULL'
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                               ^~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'symbols[0].name')
       8 | #define NULL ((void *)0)
         |              ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   include/trace/stages/stage3_trace_output.h:78:47: note: in expansion of macro 'NULL'
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                               ^~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
>> include/trace/stages/stage3_trace_output.h:78:25: warning: missing braces around initializer [-Wmissing-braces]
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   arch/loongarch/kvm/./trace.h:87:13: note: in expansion of macro 'TP_printk'
      87 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:88:23: note: in expansion of macro '__print_symbolic'
      88 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h: In function 'trace_raw_output_kvm_aux':
   arch/loongarch/kvm/./trace.h:118:33: warning: left-hand operand of comma expression has no effect [-Wunused-value]
     118 |         ({ KVM_TRACE_AUX_RESTORE,       "restore" },    \
         |                                 ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:145:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     145 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:118:51: error: expected ';' before '}' token
     118 |         ({ KVM_TRACE_AUX_RESTORE,       "restore" },    \
         |                                                   ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:145:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     145 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:118:52: error: expected ')' before ',' token
     118 |         ({ KVM_TRACE_AUX_RESTORE,       "restore" },    \
         |                                                    ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:145:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     145 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:118:9: warning: initialization of 'long unsigned int' from 'char *' makes integer from pointer without a cast [-Wint-conversion]
     118 |         ({ KVM_TRACE_AUX_RESTORE,       "restore" },    \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:145:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     145 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:118:9: note: (near initialization for 'symbols[0].mask')
     118 |         ({ KVM_TRACE_AUX_RESTORE,       "restore" },    \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:145:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     145 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:118:9: error: initializer element is not constant
     118 |         ({ KVM_TRACE_AUX_RESTORE,       "restore" },    \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:145:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     145 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:118:9: note: (near initialization for 'symbols[0].mask')
     118 |         ({ KVM_TRACE_AUX_RESTORE,       "restore" },    \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:145:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     145 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
>> include/trace/stages/stage3_trace_output.h:77:37: warning: braces around scalar initializer
      77 |                 static const struct trace_print_flags symbols[] =       \
         |                                     ^~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   include/trace/stages/stage3_trace_output.h:77:37: note: (near initialization for 'symbols[0].name')
      77 |                 static const struct trace_print_flags symbols[] =       \
         |                                     ^~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
>> include/trace/stages/stage3_trace_output.h:78:43: warning: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                           ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   include/trace/stages/stage3_trace_output.h:78:43: note: (near initialization for 'symbols[0].name')
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                           ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   include/linux/stddef.h:8:14: warning: excess elements in scalar initializer
       8 | #define NULL ((void *)0)
         |              ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   include/trace/stages/stage3_trace_output.h:78:47: note: in expansion of macro 'NULL'
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                               ^~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'symbols[0].name')
       8 | #define NULL ((void *)0)
         |              ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   include/trace/stages/stage3_trace_output.h:78:47: note: in expansion of macro 'NULL'
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                               ^~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
>> include/trace/stages/stage3_trace_output.h:78:25: warning: missing braces around initializer [-Wmissing-braces]
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:127:1: note: in expansion of macro 'TRACE_EVENT'
     127 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:143:13: note: in expansion of macro 'TP_printk'
     143 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:144:23: note: in expansion of macro '__print_symbolic'
     144 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~


vim +54 arch/loongarch/kvm/./trace.h

d3a97e0928587c5 Tianrui Zhao 2023-03-21  51  
d3a97e0928587c5 Tianrui Zhao 2023-03-21  52  /* Tracepoints for VM exits */
d3a97e0928587c5 Tianrui Zhao 2023-03-21  53  #define kvm_trace_symbol_exit_types			\
d3a97e0928587c5 Tianrui Zhao 2023-03-21 @54  	({ KVM_TRACE_EXIT_IDLE,		"IDLE" },	\
d3a97e0928587c5 Tianrui Zhao 2023-03-21  55  	{ KVM_TRACE_EXIT_CACHE,		"CACHE" },	\
d3a97e0928587c5 Tianrui Zhao 2023-03-21  56  	{ KVM_TRACE_EXIT_SIGNAL,	"Signal" })
d3a97e0928587c5 Tianrui Zhao 2023-03-21  57  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
