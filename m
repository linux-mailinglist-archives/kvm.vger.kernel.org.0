Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F90B4F8D73
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 08:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbiDHFRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 01:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbiDHFR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 01:17:27 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F2034AD3E;
        Thu,  7 Apr 2022 22:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649394924; x=1680930924;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JIe+tiRk8cjFk9SCjrMUYp45vz2whB3O4GHWertJcgg=;
  b=kV7QwUjlOrOVF1/6QX/dE+NYw5Ltx1cNucgZrBBIMlk4WmbM9JcdSb+f
   RMwl/aoFr9HHLIfDPl/Zno9JBvleXbrGr8ezM/L1/xv+FNw7JO3Z8+3Su
   6Bd4uyiiCZ1Cp22EwGSvlWSl1aVN6m01cblD0M7IQWfpxZzb4sez3T8pq
   KeY3qmhqtMwYSZJwfOjuFhQT0Gh6His1zpBtoMMG664Kp/9fhb8jqeeoe
   ONiZd94IbAm3jphihb2q7ij8cstGiSlLW0/JADdmqUbzol0u4unTTicXs
   D58xcnJjyCTozv35ZzG4XJbyIbNWNy7WjUz/IttblP8ScxYsyV7PtTvKK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="322201176"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="322201176"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 22:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="557646722"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 07 Apr 2022 22:15:21 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncgxs-000651-Qa;
        Fri, 08 Apr 2022 05:15:20 +0000
Date:   Fri, 8 Apr 2022 13:15:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.1] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <202204081314.dqs8Tnxd-lkp@intel.com>
References: <20220407210233.782250-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407210233.782250-1-pgonda@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/master]
[also build test ERROR on v5.18-rc1 next-20220407]
[cannot apply to v4.1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Gonda/KVM-SEV-Add-KVM_EXIT_SHUTDOWN-metadata-for-SEV-ES/20220408-050628
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: riscv-randconfig-c006-20220408 (https://download.01.org/0day-ci/archive/20220408/202204081314.dqs8Tnxd-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c29a51b3a257908aebc01cd7c4655665db317d66)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/3b310e5891d172b59042783c128f6efcf5bf6198
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Peter-Gonda/KVM-SEV-Add-KVM_EXIT_SHUTDOWN-metadata-for-SEV-ES/20220408-050628
        git checkout 3b310e5891d172b59042783c128f6efcf5bf6198
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/riscv/kvm/vcpu_sbi.c:97:20: error: no member named 'flags' in 'struct kvm_run::(unnamed at include/uapi/linux/kvm.h:443:3)'
           run->system_event.flags = flags;
           ~~~~~~~~~~~~~~~~~ ^
   1 error generated.


vim +97 arch/riscv/kvm/vcpu_sbi.c

dea8ee31a03927 Atish Patra 2021-09-27   83  
4b11d86571c447 Anup Patel  2022-01-31   84  void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
4b11d86571c447 Anup Patel  2022-01-31   85  				     struct kvm_run *run,
4b11d86571c447 Anup Patel  2022-01-31   86  				     u32 type, u64 flags)
4b11d86571c447 Anup Patel  2022-01-31   87  {
4b11d86571c447 Anup Patel  2022-01-31   88  	unsigned long i;
4b11d86571c447 Anup Patel  2022-01-31   89  	struct kvm_vcpu *tmp;
4b11d86571c447 Anup Patel  2022-01-31   90  
4b11d86571c447 Anup Patel  2022-01-31   91  	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
4b11d86571c447 Anup Patel  2022-01-31   92  		tmp->arch.power_off = true;
4b11d86571c447 Anup Patel  2022-01-31   93  	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
4b11d86571c447 Anup Patel  2022-01-31   94  
4b11d86571c447 Anup Patel  2022-01-31   95  	memset(&run->system_event, 0, sizeof(run->system_event));
4b11d86571c447 Anup Patel  2022-01-31   96  	run->system_event.type = type;
4b11d86571c447 Anup Patel  2022-01-31  @97  	run->system_event.flags = flags;
4b11d86571c447 Anup Patel  2022-01-31   98  	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
4b11d86571c447 Anup Patel  2022-01-31   99  }
4b11d86571c447 Anup Patel  2022-01-31  100  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
