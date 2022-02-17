Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2424BAD16
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 00:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiBQXNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 18:13:09 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiBQXNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 18:13:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA7113294D
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 15:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645139565; x=1676675565;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4drnSv8QYVuvNNyAm9hEzkUtF2mEcKzJVJkuUi0eOEk=;
  b=FiJylxbILseIaGfJYPkdMyjx9qUPmJ6m97gE1xvhs1d/ChlzaCxn+V+Y
   hLMSM0fyjC6Y2mGk5R5mAQYfxyQ3Nattw7YH6bALFmfll1VQuvwD3Kr+V
   gNWqwjQnqNlUJ0/SjDVlPKsvShjwHQ0IPAzjySVZKotBwGck1fxMMPSlC
   v4FD0fRJPqvIw2dazvGZTKIxPHxkYCD+PZM5rBBX674+4Df3nV8ZDuYgd
   BnYR9+UYrFf2V5II/uPMXOaykcrsxC4F2XVa8MqNPkJAtUZSOGFus7rus
   nJLOEB0Uhpe6K7/kEa8RnoGNH788hVvnEFiaqjuk+H+V0z58xG5PmhU8D
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="314263824"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="314263824"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 15:12:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="503749843"
Received: from lkp-server01.sh.intel.com (HELO 6f05bf9e3301) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 17 Feb 2022 15:12:06 -0800
Received: from kbuild by 6f05bf9e3301 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nKpwT-0000is-Om; Thu, 17 Feb 2022 23:12:05 +0000
Date:   Fri, 18 Feb 2022 07:12:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Leonardo Bras <leobras@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:master 22/22] arch/x86/kvm/x86.c:992:19: error: unused function
 'kvm_guest_supported_xfd'
Message-ID: <202202180700.dnGoHs4Z-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
head:   988896bb61827345c6d074dd5f2af1b7b008193f
commit: 988896bb61827345c6d074dd5f2af1b7b008193f [22/22] x86/kvm/fpu: Remove kvm_vcpu_arch.guest_supported_xcr0
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20220218/202202180700.dnGoHs4Z-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=988896bb61827345c6d074dd5f2af1b7b008193f
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm master
        git checkout 988896bb61827345c6d074dd5f2af1b7b008193f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/x86/kvm/x86.c:992:19: error: unused function 'kvm_guest_supported_xfd' [-Werror,-Wunused-function]
   static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
                     ^
   arch/x86/kvm/x86.c:2364:19: error: unused function 'gtod_is_based_on_tsc' [-Werror,-Wunused-function]
   static inline int gtod_is_based_on_tsc(int mode)
                     ^
   2 errors generated.


vim +/kvm_guest_supported_xfd +992 arch/x86/kvm/x86.c

   991	
 > 992	static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
   993	{
   994		return kvm_guest_supported_xcr0(vcpu) & XFEATURE_MASK_USER_DYNAMIC;
   995	}
   996	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
