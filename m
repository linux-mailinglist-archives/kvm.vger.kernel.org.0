Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B232D502FE7
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 22:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351729AbiDOUxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 16:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiDOUxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 16:53:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D9643489
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650055835; x=1681591835;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=JnB+vEfgYqR5z3abqQnWL2tWEIjFaKxekZxdeq9lYl4=;
  b=K9BAPbR2+yCgASbQfoYaNMhRlj3mE8n+nXRwsu3Plpqp2tDaRc6EiT37
   rt+yF3Q/2Q3yNS7k0Ex116H4WPTl4OXmlLVDGZGUMalH/jSjU6XCY5296
   XzMgJ5BLNK5gKeVgxccj24ruLKhiMnhu6lwxSGG15Hr2uTZKo8ixgLoIo
   ovB2hD6Tw055sMzfjLmxWjSPLAnsHRnxpbkXnyxE4QeobsClYb0OM2dUB
   ofSjw1J7PHd28VzGyZ3NePXDxtv2EBMpw5YfJQPf4+Hk5pFC2MJP0npt/
   B/yXbQZvhI3LrCjIpsJxvs2M+cWm/kdBQ1Qr3ipF96ESNDTvIu7lYGRX8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="288294598"
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="288294598"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 13:50:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="612931681"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 15 Apr 2022 13:50:33 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nfStk-0002PF-Rn;
        Fri, 15 Apr 2022 20:50:32 +0000
Date:   Sat, 16 Apr 2022 04:50:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:next 27/32] arch/arm64/kvm/psci.c:184:32: error: 'struct
 <anonymous>' has no member named 'flags'
Message-ID: <202204160436.TdR8eFO0-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git next
head:   5d6c7de6446e9ab3fb41d6f7d82770e50998f3de
commit: c24a950ec7d60c4da91dc3f273295c7f438b531e [27/32] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20220416/202204160436.TdR8eFO0-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=c24a950ec7d60c4da91dc3f273295c7f438b531e
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm next
        git checkout c24a950ec7d60c4da91dc3f273295c7f438b531e
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/arm64/kvm/psci.c: In function 'kvm_prepare_system_event':
>> arch/arm64/kvm/psci.c:184:32: error: 'struct <anonymous>' has no member named 'flags'
     184 |         vcpu->run->system_event.flags = flags;
         |                                ^


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

:::::: The code at line 184 was first introduced by commit
:::::: 34739fd95fab3a5efb0422e4f012b685e33598dc KVM: arm64: Indicate SYSTEM_RESET2 in kvm_run::system_event flags field

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Marc Zyngier <maz@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
