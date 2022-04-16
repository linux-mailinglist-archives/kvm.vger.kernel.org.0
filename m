Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815AC50371D
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 16:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiDPOcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Apr 2022 10:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiDPOcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Apr 2022 10:32:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE00649687
        for <kvm@vger.kernel.org>; Sat, 16 Apr 2022 07:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650119409; x=1681655409;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=EoxWsiSNM7CfXuklX4sfQ5ORt5fo7/UjbHwIoLiiUD0=;
  b=fpG/ZB4USmxR7SQMdKnqbABl80niySY2rtAYqjErXseU1dbZ/PUSG1Zj
   dVCEI6E6EzQ91Nat7IZlEiDR1fPMz5JgJa3qTWMFDiUqQfnQhDLCTKI7H
   3pfUm2rwsnNtz+a4iOQi8zk/noh1VrHND8GJNBbn0sC9b8LfwBI7tf+qn
   RoBL1zWZGsoUx7P61/KDdq2RSv2jkedlAHUyTL6Y6JM46GYQkyePqw2wJ
   H/YuszLp+/IsoM9w0VyZaAfEM2rUJ04sIFfEgqtnMULVIf+AIYKxzjEYN
   jjn+qfdFByuvUCQkjW8lOr+PEl2I0JzoyQUgjTxJj2bnQ5Y3o4pVjIhtq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="263471754"
X-IronPort-AV: E=Sophos;i="5.90,264,1643702400"; 
   d="scan'208";a="263471754"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2022 07:30:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,264,1643702400"; 
   d="scan'208";a="857352331"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 16 Apr 2022 07:30:07 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nfjR8-0003DJ-OI;
        Sat, 16 Apr 2022 14:30:06 +0000
Date:   Sat, 16 Apr 2022 22:29:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:next 27/32] arch/riscv/kvm/vcpu_sbi.c:97:26: error: 'struct
 <anonymous>' has no member named 'flags'
Message-ID: <202204162240.GL0cSY68-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git next
head:   5d6c7de6446e9ab3fb41d6f7d82770e50998f3de
commit: c24a950ec7d60c4da91dc3f273295c7f438b531e [27/32] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
config: riscv-allmodconfig (https://download.01.org/0day-ci/archive/20220416/202204162240.GL0cSY68-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=c24a950ec7d60c4da91dc3f273295c7f438b531e
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm next
        git checkout c24a950ec7d60c4da91dc3f273295c7f438b531e
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/riscv/kvm/vcpu_sbi.c: In function 'kvm_riscv_vcpu_sbi_system_reset':
>> arch/riscv/kvm/vcpu_sbi.c:97:26: error: 'struct <anonymous>' has no member named 'flags'
      97 |         run->system_event.flags = flags;
         |                          ^


vim +97 arch/riscv/kvm/vcpu_sbi.c

dea8ee31a039277 Atish Patra 2021-09-27   83  
4b11d86571c4473 Anup Patel  2022-01-31   84  void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
4b11d86571c4473 Anup Patel  2022-01-31   85  				     struct kvm_run *run,
4b11d86571c4473 Anup Patel  2022-01-31   86  				     u32 type, u64 flags)
4b11d86571c4473 Anup Patel  2022-01-31   87  {
4b11d86571c4473 Anup Patel  2022-01-31   88  	unsigned long i;
4b11d86571c4473 Anup Patel  2022-01-31   89  	struct kvm_vcpu *tmp;
4b11d86571c4473 Anup Patel  2022-01-31   90  
4b11d86571c4473 Anup Patel  2022-01-31   91  	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
4b11d86571c4473 Anup Patel  2022-01-31   92  		tmp->arch.power_off = true;
4b11d86571c4473 Anup Patel  2022-01-31   93  	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
4b11d86571c4473 Anup Patel  2022-01-31   94  
4b11d86571c4473 Anup Patel  2022-01-31   95  	memset(&run->system_event, 0, sizeof(run->system_event));
4b11d86571c4473 Anup Patel  2022-01-31   96  	run->system_event.type = type;
4b11d86571c4473 Anup Patel  2022-01-31  @97  	run->system_event.flags = flags;
4b11d86571c4473 Anup Patel  2022-01-31   98  	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
4b11d86571c4473 Anup Patel  2022-01-31   99  }
4b11d86571c4473 Anup Patel  2022-01-31  100  

:::::: The code at line 97 was first introduced by commit
:::::: 4b11d86571c44738f5ef12fcfac2ee36f998cf23 RISC-V: KVM: Add common kvm_riscv_vcpu_sbi_system_reset() function

:::::: TO: Anup Patel <apatel@ventanamicro.com>
:::::: CC: Anup Patel <anup@brainfault.org>

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
