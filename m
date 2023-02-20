Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF65469C948
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 12:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjBTLJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 06:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjBTLJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 06:09:28 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC68CC17;
        Mon, 20 Feb 2023 03:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676891359; x=1708427359;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wqpW4f7kuHzOWu1Si17/JH06bpaL/okRZA45T2z28Eo=;
  b=JPC9CqjeAdy3OreDzpaTItORbEbMn1lt8MJYly7PHXilJP7AcTVokKMA
   ADPwS5Z4m3zIs7+98Km1ocB9Gz00cClmt7DIkerCJHof5q/GOiF2uma5z
   jPDieYpUOVlj/1Q2li7uZzGqLaYJ2ExD9RJReda7y7XgcLPpUO31uosbl
   KOtAhOXYZEAyfVui1SCZ+qnQ/xFda1CMhetUXT3iw8nAr7LVp0gjFkDI5
   Bq/R/24VfmVkJseprp/AjmeRPlsl8M7+jawl9AhWr7bFEko7Va4lLVqVE
   x4s6ESziPnowuZDWO03DvvwAvgt3kMj3iF0GP3KI7RM3e8uYgq4FdRozs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="397061060"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="397061060"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 03:09:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="740011369"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="740011369"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 20 Feb 2023 03:09:14 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pU42j-000Drt-1e;
        Mon, 20 Feb 2023 11:09:13 +0000
Date:   Mon, 20 Feb 2023 19:09:11 +0800
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
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
Subject: Re: [PATCH v2 29/29] LoongArch: KVM: Enable kvm config and add the
 makefile
Message-ID: <202302201849.mzOz4b5p-lkp@intel.com>
References: <20230220065735.1282809-30-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220065735.1282809-30-zhaotianrui@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianrui,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.2]
[cannot apply to kvm/queue kvm/linux-next next-20230220]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230220-151305
patch link:    https://lore.kernel.org/r/20230220065735.1282809-30-zhaotianrui%40loongson.cn
patch subject: [PATCH v2 29/29] LoongArch: KVM: Enable kvm config and add the makefile
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20230220/202302201849.mzOz4b5p-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/55ee4e26440ad32966cf3ee796b8a519c77ac66b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230220-151305
        git checkout 55ee4e26440ad32966cf3ee796b8a519c77ac66b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash arch/loongarch/kvm/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302201849.mzOz4b5p-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:102,
                    from arch/loongarch/kvm/trace.h:137,
                    from arch/loongarch/kvm/vcpu.c:14:
   arch/loongarch/kvm/./trace.h: In function 'trace_raw_output_kvm_exit':
   arch/loongarch/kvm/./trace.h:54:31: warning: left-hand operand of comma expression has no effect [-Wunused-value]
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |                               ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:73:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      73 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/kvm/./trace.h:54:48: error: expected ';' before '}' token
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |                                                ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:73:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      73 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/kvm/./trace.h:54:49: error: expected ')' before ',' token
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |                                                 ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:73:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      73 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/kvm/./trace.h:54:9: warning: initialization of 'long unsigned int' from 'char *' makes integer from pointer without a cast [-Wint-conversion]
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:73:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      73 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:54:9: note: (near initialization for 'symbols[0].mask')
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:73:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      73 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/loongarch/kvm/./trace.h:54:9: error: initializer element is not constant
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:73:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      73 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:54:9: note: (near initialization for 'symbols[0].mask')
      54 |         ({ KVM_TRACE_EXIT_IDLE,         "IDLE" },                       \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:73:40: note: in expansion of macro 'kvm_trace_symbol_exit_types'
      73 |                                        kvm_trace_symbol_exit_types),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> include/trace/stages/stage3_trace_output.h:77:37: warning: braces around scalar initializer
      77 |                 static const struct trace_print_flags symbols[] =       \
         |                                     ^~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
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
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
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
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
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
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
>> include/linux/stddef.h:8:14: warning: excess elements in scalar initializer
       8 | #define NULL ((void *)0)
         |              ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   include/trace/stages/stage3_trace_output.h:78:47: note: in expansion of macro 'NULL'
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                               ^~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
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
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   include/trace/stages/stage3_trace_output.h:78:47: note: in expansion of macro 'NULL'
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                               ^~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
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
   arch/loongarch/kvm/./trace.h:58:1: note: in expansion of macro 'TRACE_EVENT'
      58 | TRACE_EVENT(kvm_exit,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:71:13: note: in expansion of macro 'TP_printk'
      71 |             TP_printk("[%s]PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:72:23: note: in expansion of macro '__print_symbolic'
      72 |                       __print_symbolic(__entry->reason,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h: In function 'trace_raw_output_kvm_aux':
   arch/loongarch/kvm/./trace.h:86:33: warning: left-hand operand of comma expression has no effect [-Wunused-value]
      86 |         ({ KVM_TRACE_AUX_RESTORE, "restore" },          \
         |                                 ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:113:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     113 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:86:45: error: expected ';' before '}' token
      86 |         ({ KVM_TRACE_AUX_RESTORE, "restore" },          \
         |                                             ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:113:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     113 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:86:46: error: expected ')' before ',' token
      86 |         ({ KVM_TRACE_AUX_RESTORE, "restore" },          \
         |                                              ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:113:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     113 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:86:9: warning: initialization of 'long unsigned int' from 'char *' makes integer from pointer without a cast [-Wint-conversion]
      86 |         ({ KVM_TRACE_AUX_RESTORE, "restore" },          \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:113:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     113 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:86:9: note: (near initialization for 'symbols[0].mask')
      86 |         ({ KVM_TRACE_AUX_RESTORE, "restore" },          \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:113:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     113 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:86:9: error: initializer element is not constant
      86 |         ({ KVM_TRACE_AUX_RESTORE, "restore" },          \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:113:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     113 |                                        kvm_trace_symbol_aux_op),
         |                                        ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:86:9: note: (near initialization for 'symbols[0].mask')
      86 |         ({ KVM_TRACE_AUX_RESTORE, "restore" },          \
         |         ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:113:40: note: in expansion of macro 'kvm_trace_symbol_aux_op'
     113 |                                        kvm_trace_symbol_aux_op),
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
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
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
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
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
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
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
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
>> include/linux/stddef.h:8:14: warning: excess elements in scalar initializer
       8 | #define NULL ((void *)0)
         |              ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   include/trace/stages/stage3_trace_output.h:78:47: note: in expansion of macro 'NULL'
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                               ^~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
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
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   include/trace/stages/stage3_trace_output.h:78:47: note: in expansion of macro 'NULL'
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                               ^~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
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
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:112:23: note: in expansion of macro '__print_symbolic'
     112 |                       __print_symbolic(__entry->op,
         |                       ^~~~~~~~~~~~~~~~
>> include/trace/stages/stage3_trace_output.h:78:39: error: expected expression before ',' token
      78 |                         { symbol_array, { -1, NULL }};                  \
         |                                       ^
   include/trace/trace_events.h:203:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     203 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   arch/loongarch/kvm/./trace.h:95:1: note: in expansion of macro 'TRACE_EVENT'
      95 | TRACE_EVENT(kvm_aux,
         | ^~~~~~~~~~~
   arch/loongarch/kvm/./trace.h:111:13: note: in expansion of macro 'TP_printk'
     111 |             TP_printk("%s %s PC: 0x%08lx",
         |             ^~~~~~~~~
   arch/loongarch/kvm/./trace.h:114:23: note: in expansion of macro '__print_symbolic'
     114 |                       __print_symbolic(__entry->state,
         |                       ^~~~~~~~~~~~~~~~
   arch/loongarch/kvm/vcpu.c: In function 'kvm_own_fpu':
   arch/loongarch/kvm/vcpu.c:595:23: warning: variable 'sr' set but not used [-Wunused-but-set-variable]
     595 |         unsigned long sr;
         |                       ^~
   arch/loongarch/kvm/vcpu.c: At top level:
   arch/loongarch/kvm/vcpu.c:636:5: warning: no previous prototype for 'kvm_vcpu_ioctl_interrupt' [-Wmissing-prototypes]
     636 | int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/huge_mm.h:8,
                    from include/linux/mm.h:746,
                    from include/linux/kvm_host.h:16,
                    from arch/loongarch/kvm/vcpu.c:6:
   arch/loongarch/kvm/vcpu.c:126:25: warning: 'vcpu_pid_fops' defined but not used [-Wunused-const-variable=]
     126 | DEFINE_SIMPLE_ATTRIBUTE(vcpu_pid_fops, vcpu_pid_get, NULL, "%llu\n");
         |                         ^~~~~~~~~~~~~
   include/linux/fs.h:3496:37: note: in definition of macro 'DEFINE_SIMPLE_ATTRIBUTE_XSIGNED'
    3496 | static const struct file_operations __fops = {                          \
         |                                     ^~~~~~
   arch/loongarch/kvm/vcpu.c:126:1: note: in expansion of macro 'DEFINE_SIMPLE_ATTRIBUTE'
     126 | DEFINE_SIMPLE_ATTRIBUTE(vcpu_pid_fops, vcpu_pid_get, NULL, "%llu\n");
         | ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/vcpu.c:116:25: warning: 'lvcpu_stat_fops' defined but not used [-Wunused-const-variable=]
     116 | DEFINE_SIMPLE_ATTRIBUTE(lvcpu_stat_fops, lvcpu_stat_get, NULL, "%llu\n");
         |                         ^~~~~~~~~~~~~~~
   include/linux/fs.h:3496:37: note: in definition of macro 'DEFINE_SIMPLE_ATTRIBUTE_XSIGNED'
    3496 | static const struct file_operations __fops = {                          \
         |                                     ^~~~~~
   arch/loongarch/kvm/vcpu.c:116:1: note: in expansion of macro 'DEFINE_SIMPLE_ATTRIBUTE'
     116 | DEFINE_SIMPLE_ATTRIBUTE(lvcpu_stat_fops, lvcpu_stat_get, NULL, "%llu\n");
         | ^~~~~~~~~~~~~~~~~~~~~~~
..


vim +54 arch/loongarch/kvm/./trace.h

d73e24865c7b73 Tianrui Zhao 2023-02-20  51  
d73e24865c7b73 Tianrui Zhao 2023-02-20  52  /* Tracepoints for VM exits */
d73e24865c7b73 Tianrui Zhao 2023-02-20  53  #define kvm_trace_symbol_exit_types					\
d73e24865c7b73 Tianrui Zhao 2023-02-20 @54  	({ KVM_TRACE_EXIT_IDLE,		"IDLE" },			\
d73e24865c7b73 Tianrui Zhao 2023-02-20  55  	{ KVM_TRACE_EXIT_CACHE,		"CACHE" },			\
d73e24865c7b73 Tianrui Zhao 2023-02-20  56  	{ KVM_TRACE_EXIT_SIGNAL,	"Signal" })
d73e24865c7b73 Tianrui Zhao 2023-02-20  57  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
