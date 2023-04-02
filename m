Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70F56D3510
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 02:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjDBA1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 20:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDBA1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 20:27:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8DC25560
        for <kvm@vger.kernel.org>; Sat,  1 Apr 2023 17:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680395267; x=1711931267;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OCox6QVeMf6eKXYGZU5Pl/SsjUXrp7OFa4I0paCyj0k=;
  b=YQ6sdXyEtC1s6ld8EfnXEYynaOSKVaQxQT/uMTwqzw1Zr9twUv3jkIUL
   HHx0g4d1LavHNMeP/WYCjDIcKPStusPBTJVKzMTcpilbcFo+FYJl6ugAO
   AlurixI4X+sJWg6zkxdHCu8XCzqGcPfhFu14S1zpZgsE/wzviWYdJUZXo
   0FhxVnMY0iAL/NIn8Sj/qg9DGkVr8fDR2wtshsWk2Ev+XSPdN/xB2ATX8
   Bxxv12LEYxGOkj4Zf0iW31nSHeauURfcN8nG4PKaLVwOdoJdWNY/Nl2ru
   CM0/+MrDR9MPQO4pGQauPzFF7yb7KkBYU0WGlxNSVLy+itHCdTSc3CPBC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="369489391"
X-IronPort-AV: E=Sophos;i="5.98,311,1673942400"; 
   d="scan'208";a="369489391"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 17:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="718129711"
X-IronPort-AV: E=Sophos;i="5.98,311,1673942400"; 
   d="scan'208";a="718129711"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 01 Apr 2023 17:27:45 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pilZQ-000N8T-0f;
        Sun, 02 Apr 2023 00:27:44 +0000
Date:   Sun, 2 Apr 2023 08:27:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@ozlabs.org
Cc:     oe-kbuild-all@lists.linux.dev, Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH v2 1/2] KVM: PPC: Permit SRR1 flags in more injected
 interrupt types
Message-ID: <202304020827.3LEZ86WB-lkp@intel.com>
References: <20230330103224.3589928-2-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330103224.3589928-2-npiggin@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nicholas,

I love your patch! Yet something to improve:

[auto build test ERROR on powerpc/topic/ppc-kvm]
[also build test ERROR on linus/master v6.3-rc4 next-20230331]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nicholas-Piggin/KVM-PPC-Permit-SRR1-flags-in-more-injected-interrupt-types/20230330-183420
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
patch link:    https://lore.kernel.org/r/20230330103224.3589928-2-npiggin%40gmail.com
patch subject: [PATCH v2 1/2] KVM: PPC: Permit SRR1 flags in more injected interrupt types
config: powerpc-randconfig-c033-20230402 (https://download.01.org/0day-ci/archive/20230402/202304020827.3LEZ86WB-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/31c610025a69f60bfa70c098471861456b2e4012
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Nicholas-Piggin/KVM-PPC-Permit-SRR1-flags-in-more-injected-interrupt-types/20230330-183420
        git checkout 31c610025a69f60bfa70c098471861456b2e4012
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash arch/powerpc/kvm/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304020827.3LEZ86WB-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/powerpc/kvm/booke.c:1011:5: error: no previous prototype for 'kvmppc_handle_exit' [-Werror=missing-prototypes]
    1011 | int kvmppc_handle_exit(struct kvm_vcpu *vcpu, unsigned int exit_nr)
         |     ^~~~~~~~~~~~~~~~~~
   arch/powerpc/kvm/booke.c: In function 'kvmppc_handle_exit':
>> arch/powerpc/kvm/booke.c:1244:17: error: too many arguments to function 'kvmppc_core_queue_alignment'
    1244 |                 kvmppc_core_queue_alignment(vcpu, 0, vcpu->arch.fault_dear,
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/kvm/booke.c:306:13: note: declared here
     306 | static void kvmppc_core_queue_alignment(struct kvm_vcpu *vcpu, ulong dear_flags,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: all warnings being treated as errors


vim +/kvmppc_core_queue_alignment +1244 arch/powerpc/kvm/booke.c

  1229	
  1230		case BOOKE_INTERRUPT_DATA_STORAGE:
  1231			kvmppc_core_queue_data_storage(vcpu, 0, vcpu->arch.fault_dear,
  1232			                               vcpu->arch.fault_esr);
  1233			kvmppc_account_exit(vcpu, DSI_EXITS);
  1234			r = RESUME_GUEST;
  1235			break;
  1236	
  1237		case BOOKE_INTERRUPT_INST_STORAGE:
  1238			kvmppc_core_queue_inst_storage(vcpu, vcpu->arch.fault_esr);
  1239			kvmppc_account_exit(vcpu, ISI_EXITS);
  1240			r = RESUME_GUEST;
  1241			break;
  1242	
  1243		case BOOKE_INTERRUPT_ALIGNMENT:
> 1244			kvmppc_core_queue_alignment(vcpu, 0, vcpu->arch.fault_dear,
  1245			                            vcpu->arch.fault_esr);
  1246			r = RESUME_GUEST;
  1247			break;
  1248	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
