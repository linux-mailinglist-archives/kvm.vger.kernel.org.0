Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A67517BBD
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 03:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiECCAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 22:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiECCAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 22:00:47 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E016387B7
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 18:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651543036; x=1683079036;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=NyefZZ9y7G7xrqWCgPttv9WeU8zvIUfo/AfMX+3Wl2k=;
  b=QRp0RhEM5xPLfzxznTxe8m31DBEsrcxsZHFkCAF+0uzn0U66hEruMl1V
   4yN1oZdjFkNpKdH4sfk5f/6ydzRTDTffnvI4MAVjgph+9RHJZlyZGHihl
   BiqVqkSjNIYE13aQRf4PFTy8LcNrMAc1FGi6PDecmy/ILMlCyx6BDsugd
   m7p2yuK4G91vI4swjuQ7GfiSDSPkg2lvnmYzri1ZxTR9+IL3nCbMX9XkR
   PLJbjVa3XcWsAFpxHHIFNDrvSCDIzSy2yFcECjqj0MziM+H8N5C0SYXmi
   Up/l7rIo0aA413GXYRJMH8M1jc/V4DFE17ljXavP2KkAF6EgZMvZkib6Z
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="254836746"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="254836746"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 18:57:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="620156274"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 02 May 2022 18:57:13 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nlhmq-000A3h-Gz;
        Tue, 03 May 2022 01:57:12 +0000
Date:   Tue, 3 May 2022 09:56:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [kvm:queue 74/77] arch/x86/kvm/vmx/vmx.c:4405:5: error: no previous
 prototype for function 'vmx_get_pid_table_order'
Message-ID: <202205030944.BOEY0IuK-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   2764011106d0436cb44702cfb0981339d68c3509
commit: 101c99f6506d7fc293111190d65fedadb711c9ea [74/77] KVM: VMX: enable IPI virtualization
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20220503/202205030944.BOEY0IuK-lkp@intel.com/config)
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
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/x86/kvm/vmx/vmx.c:4405:5: error: no previous prototype for function 'vmx_get_pid_table_order' [-Werror,-Wmissing-prototypes]
   int vmx_get_pid_table_order(struct kvm *kvm)
       ^
   arch/x86/kvm/vmx/vmx.c:4405:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int vmx_get_pid_table_order(struct kvm *kvm)
   ^
   static 
   1 error generated.


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
