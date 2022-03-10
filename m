Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AD44D3EBC
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 02:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbiCJBag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 20:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbiCJBaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 20:30:35 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CA2E61F1
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 17:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646875775; x=1678411775;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=OXbYneJInVZwCybUdFLiYyvUCfRWNANF7grxShhCeP8=;
  b=h9mmfMUxIbambi4RXL1j9JlJ5TH1ZyPZVfQfWp6pGVEQoBtgQPU3PAV+
   JpySUOecGjtfNbccbjQaIoNIMFU9+U3OYpl5y/hQ3ITJutR8WNUO+tqqi
   xkLGPIotCodO3uD1R2LI5mT0gRZVYg3WjYG30bp2lmb6JsASiPvg7tnn4
   gPI6zf0ceJOkIo2ralqeIf8TA+ctGtuNvbM55yNtL/EnPNWR8zTRGY9Yq
   AkYmS8ZimcvUQw3lNKgxhlEYUDX2l/xnXXGdYdDRtT7wzMB0BaTknEGE3
   uQkMw6fAEYuMgaHhoMUFvE2ldYGjQEtjuY7l7IlHee+I52uqq7pC2CXRB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235083075"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="235083075"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 17:29:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="611571847"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 09 Mar 2022 17:29:33 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nS7cS-00048o-J7; Thu, 10 Mar 2022 01:29:32 +0000
Date:   Thu, 10 Mar 2022 09:28:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:queue 182/205] <inline asm>:40:208: error: expected relocatable
 expression
Message-ID: <202203100905.1o88Cp2l-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   8c1db5a775bc8314d78e99263e0d063a01b692c2
commit: 4ab22f38c2046f2c949cb43fc0f7515666a2a2fb [182/205] KVM: x86: Support the vCPU preemption check with nopvspin and realtime hint
config: x86_64-randconfig-a012 (https://download.01.org/0day-ci/archive/20220310/202203100905.1o88Cp2l-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 276ca87382b8f16a65bddac700202924228982f6)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=4ab22f38c2046f2c949cb43fc0f7515666a2a2fb
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout 4ab22f38c2046f2c949cb43fc0f7515666a2a2fb
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> <inline asm>:40:208: error: expected relocatable expression
   .pushsection .text;.global __raw_callee_save___kvm_vcpu_is_preempted;.type __raw_callee_save___kvm_vcpu_is_preempted, @function;__raw_callee_save___kvm_vcpu_is_preempted:movq  __per_cpu_offset(,%rdi,8), %rax;cmpb    $0, KVM_STEAL_TIME_preempted+steal_time(%rax);setne     %al;ret;.size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;.popsection
                                                                                                                                                                                                                   ^
   1 error generated.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
