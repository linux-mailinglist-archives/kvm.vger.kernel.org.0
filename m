Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853BD7862DA
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 23:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238539AbjHWV6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 17:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238556AbjHWV5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 17:57:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073F71735;
        Wed, 23 Aug 2023 14:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692827846; x=1724363846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jmOzwFjkvQ1zr3bWRNoXSZIkw0+/fNbuzLpsAQQVuS0=;
  b=Y67ZI3nP1Dz41Wp2JaL0NXuffJwp5VBnkyDrIeI+G61q5hhitjCmTsam
   uA4T3FxCy3l564mJwu/U0EJqrzj8y9pZLZIYUWukSsiGEnEH9mGuPdp1e
   8mrn17KGUmXvY3rQw/PBeItkhpkhqg/Xx7QeX6O5pEvK3G0SLCfHXbQiA
   D1rHLOe5D79QnQw0PlYSYwimfDluiRKUfwxkHtSviLQzWjn7JbQHTf60U
   5n6am0sVcIZvlBWTTj91yJmcktOOGmvAmmKz7sa20/wilLwU/GRLkmUpZ
   Ayu52FLDx6CVYd7S/nU5xkTiKc9u0kU4sS4nS9cWU57xrIAyPE4Rxj7Yk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="373166841"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="373166841"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 14:57:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="686620412"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="686620412"
Received: from lkp-server02.sh.intel.com (HELO daf8bb0a381d) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 23 Aug 2023 14:57:20 -0700
Received: from kbuild by daf8bb0a381d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qYvqp-0001XI-2f;
        Wed, 23 Aug 2023 21:57:19 +0000
Date:   Thu, 24 Aug 2023 05:56:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kyle Meyer <kyle.meyer@hpe.com>, seanjc@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, dmatlack@google.com
Cc:     oe-kbuild-all@lists.linux.dev, russ.anderson@hpe.com,
        dimitri.sivanich@hpe.com, steve.wahl@hpe.com,
        Kyle Meyer <kyle.meyer@hpe.com>
Subject: Re: [PATCH v2] KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS
Message-ID: <202308240540.9fQYjHB2-lkp@intel.com>
References: <20230823193842.2544394-1-kyle.meyer@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823193842.2544394-1-kyle.meyer@hpe.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kyle,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on linus/master v6.5-rc7 next-20230823]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kyle-Meyer/KVM-x86-Add-CONFIG_KVM_MAX_NR_VCPUS/20230824-034224
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230823193842.2544394-1-kyle.meyer%40hpe.com
patch subject: [PATCH v2] KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS
config: i386-tinyconfig (https://download.01.org/0day-ci/archive/20230824/202308240540.9fQYjHB2-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230824/202308240540.9fQYjHB2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308240540.9fQYjHB2-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/vdso/const.h:5,
                    from include/linux/const.h:4,
                    from include/uapi/linux/kernel.h:6,
                    from include/linux/cache.h:5,
                    from include/linux/slab.h:15,
                    from arch/x86/events/intel/core.c:14:
>> arch/x86/include/asm/kvm_host.h:42:23: error: 'CONFIG_KVM_MAX_NR_VCPUS' undeclared here (not in a function)
      42 | #define KVM_MAX_VCPUS CONFIG_KVM_MAX_NR_VCPUS
         |                       ^~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:34:40: note: in definition of macro '__KERNEL_DIV_ROUND_UP'
      34 | #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
         |                                        ^
   arch/x86/include/asm/kvm_host.h:1120:33: note: in expansion of macro 'BITS_TO_LONGS'
    1120 |         unsigned long poll_mask[BITS_TO_LONGS(KVM_MAX_VCPUS)];
         |                                 ^~~~~~~~~~~~~
   arch/x86/include/asm/kvm_host.h:1120:47: note: in expansion of macro 'KVM_MAX_VCPUS'
    1120 |         unsigned long poll_mask[BITS_TO_LONGS(KVM_MAX_VCPUS)];
         |                                               ^~~~~~~~~~~~~


vim +/CONFIG_KVM_MAX_NR_VCPUS +42 arch/x86/include/asm/kvm_host.h

    41	
  > 42	#define KVM_MAX_VCPUS CONFIG_KVM_MAX_NR_VCPUS
    43	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
