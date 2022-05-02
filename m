Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66AAA5178AE
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 22:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377771AbiEBVBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 17:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiEBVBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 17:01:38 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749E66454
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 13:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651525088; x=1683061088;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=wbjFnBER4Dc9RytbOMj0elJyEk5o5pxKnlfsjbG8la8=;
  b=C2G21177mPyz4CBced/j0uF2d/0y9lezbPNJee38fWFsFr5EkFLoi272
   pwO6z75mdXrZ35L1GAGC80eH6cIheQELvb5e4KhDNeio9RJQrq2KjQDwy
   rNzT54mfkdljQoRMLVLNf2nPQD05rUHROdXRb2jGQQB1lkU3RQY2VhqlS
   5MvYQ/tKci0h8iJqiVVUhpxZqCh4u47ygXf/EKM9rfkzhgWQQoW+LI8vC
   Wouv5HJH/VrIQtNINIg0Q+UlScLIg8I5n3oK/87iWwoCAJuefxrHdhOOp
   W4Z99crPwEHeSGRMSObcr0fFdnTKytupB17NlER+Tt0veas/gJyv9ZpBB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="267202202"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="267202202"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:58:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="598793152"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 02 May 2022 13:58:05 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nld7N-0009rj-8B;
        Mon, 02 May 2022 20:58:05 +0000
Date:   Tue, 3 May 2022 04:57:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [kvm:queue 74/77] arch/x86/kvm/vmx/vmx.c:4405:5: warning: no
 previous prototype for function 'vmx_get_pid_table_order'
Message-ID: <202205030401.Ka1ygWqv-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   2764011106d0436cb44702cfb0981339d68c3509
commit: 101c99f6506d7fc293111190d65fedadb711c9ea [74/77] KVM: VMX: enable IPI virtualization
config: x86_64-randconfig-a014 (https://download.01.org/0day-ci/archive/20220503/202205030401.Ka1ygWqv-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 09325d36061e42b495d1f4c7e933e260eac260ed)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=101c99f6506d7fc293111190d65fedadb711c9ea
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout 101c99f6506d7fc293111190d65fedadb711c9ea
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/vmx/vmx.c:4405:5: warning: no previous prototype for function 'vmx_get_pid_table_order' [-Wmissing-prototypes]
   int vmx_get_pid_table_order(struct kvm *kvm)
       ^
   arch/x86/kvm/vmx/vmx.c:4405:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int vmx_get_pid_table_order(struct kvm *kvm)
   ^
   static 
   1 warning generated.


vim +/vmx_get_pid_table_order +4405 arch/x86/kvm/vmx/vmx.c

  4404	
> 4405	int vmx_get_pid_table_order(struct kvm *kvm)
  4406	{
  4407		return get_order(kvm->arch.max_vcpu_ids * sizeof(*to_kvm_vmx(kvm)->pid_table));
  4408	}
  4409	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
