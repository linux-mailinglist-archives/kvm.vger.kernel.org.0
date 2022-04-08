Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9234F8EB7
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 08:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbiDHEg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 00:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiDHEgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 00:36:25 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D352EE72A6;
        Thu,  7 Apr 2022 21:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649392462; x=1680928462;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5tej6b9o6dwvek3pEU2iipjiMORsaX8hNr5dSwFtXG4=;
  b=SQZjcsHeyhvWO/UmrGJHi6SromN6k1zz8OiSec1R2DKNoTLsRmGOpGcH
   CwdYb9z0C999ODNw7VzsOf9e7T2rtj50sIuPYfSlVWUmKiGFpi0iGqooc
   2xrNBJFf53ovLIL6mRJPcQYWWaKIzzU5sEMSBDLuTUxuQS6Pdm0wLrrJ3
   HFb7rU6ANA2YY0Kn5QvwCuaKt1ChRiivb+yKCTtZ3RyCw5/2n+Og4608e
   UtSpCPkU4y7Umegik9/EHomkLNPvlTz/jdbTc5uqL/jb9+6BGgKovY3t3
   z6THG6lJbrJS96NCd0LYboBuQTwb//rMetAAbXdnumjGenbgc1eK8M1QG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="347947537"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="347947537"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 21:34:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="506424579"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 07 Apr 2022 21:34:20 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncgKB-00062B-9B;
        Fri, 08 Apr 2022 04:34:19 +0000
Date:   Fri, 8 Apr 2022 12:34:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.1] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <202204081255.SUNyj4S3-lkp@intel.com>
References: <20220407210233.782250-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407210233.782250-1-pgonda@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
config: arm64-randconfig-r035-20220408 (https://download.01.org/0day-ci/archive/20220408/202204081255.SUNyj4S3-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c29a51b3a257908aebc01cd7c4655665db317d66)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/3b310e5891d172b59042783c128f6efcf5bf6198
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Peter-Gonda/KVM-SEV-Add-KVM_EXIT_SHUTDOWN-metadata-for-SEV-ES/20220408-050628
        git checkout 3b310e5891d172b59042783c128f6efcf5bf6198
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/arm64/kvm/psci.c:184:26: error: no member named 'flags' in 'struct kvm_run::(unnamed at include/uapi/linux/kvm.h:443:3)'
           vcpu->run->system_event.flags = flags;
           ~~~~~~~~~~~~~~~~~~~~~~~ ^
   1 error generated.


vim +184 arch/arm64/kvm/psci.c

e6bc13c8a70eab arch/arm/kvm/psci.c   Anup Patel       2014-04-29  163  
34739fd95fab3a arch/arm64/kvm/psci.c Will Deacon      2022-02-21  164  static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
4b1238269ed340 arch/arm/kvm/psci.c   Anup Patel       2014-04-29  165  {
46808a4cb89708 arch/arm64/kvm/psci.c Marc Zyngier     2021-11-16  166  	unsigned long i;
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  167  	struct kvm_vcpu *tmp;
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  168  
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  169  	/*
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  170  	 * The KVM ABI specifies that a system event exit may call KVM_RUN
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  171  	 * again and may perform shutdown/reboot at a later time that when the
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  172  	 * actual request is made.  Since we are implementing PSCI and a
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  173  	 * caller of PSCI reboot and shutdown expects that the system shuts
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  174  	 * down or reboots immediately, let's make sure that VCPUs are not run
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  175  	 * after this call is handled and before the VCPUs have been
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  176  	 * re-initialized.
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  177  	 */
cc9b43f99d5ff4 virt/kvm/arm/psci.c   Andrew Jones     2017-06-04  178  	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
3781528e3045e7 arch/arm/kvm/psci.c   Eric Auger       2015-09-25  179  		tmp->arch.power_off = true;
7b244e2be654d9 virt/kvm/arm/psci.c   Andrew Jones     2017-06-04  180  	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
cf5d318865e25f arch/arm/kvm/psci.c   Christoffer Dall 2014-10-16  181  
4b1238269ed340 arch/arm/kvm/psci.c   Anup Patel       2014-04-29  182  	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
4b1238269ed340 arch/arm/kvm/psci.c   Anup Patel       2014-04-29  183  	vcpu->run->system_event.type = type;
34739fd95fab3a arch/arm64/kvm/psci.c Will Deacon      2022-02-21 @184  	vcpu->run->system_event.flags = flags;
4b1238269ed340 arch/arm/kvm/psci.c   Anup Patel       2014-04-29  185  	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
4b1238269ed340 arch/arm/kvm/psci.c   Anup Patel       2014-04-29  186  }
4b1238269ed340 arch/arm/kvm/psci.c   Anup Patel       2014-04-29  187  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
