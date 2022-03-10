Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D06D4D3F1B
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 03:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiCJCBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 21:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbiCJCBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 21:01:13 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4B45A584
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 18:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646877614; x=1678413614;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7HhiVYndF2bplJ9+zSptxSqy2aY+4xTZpdctglVbCws=;
  b=g7s8jokXWIT6bKOaHfiBKI8nW+etwqHFvFMkD0tOj5paqjm8sJADPX6I
   Frs2YTpkQKINubH1AV+7V1KgXxZYKLl5Jne/L/qSf18hkMD6cEEYGv72j
   3L3hHKmtK1415nPv05rduJ4IWwW9KjWIsjOAf0tqEwlmfBsJh/TcuDZxz
   SLhTnIOwMCxjlnixR0CaDEQKeeLMCvVGLFmosMYlc9UXiyPrnMmIcHDXI
   u6fYZxXeCkhmBdgTxnnwv5yZBZ/M7CXC2cFGFCPSjMY2+CrWmaAv6MpC2
   DpwHeny8AtowZwLgQHzqm18XsD+zqfOLzcedTbNdfZ1HtSzUhVefD/lFY
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="341567076"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="341567076"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 18:00:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="547848347"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2022 18:00:11 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nS867-0004Ar-8q; Thu, 10 Mar 2022 02:00:11 +0000
Date:   Thu, 10 Mar 2022 09:59:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:queue 182/205] arch/x86/kernel/kvm.c:756:16: warning: no
 previous prototype for '__kvm_vcpu_is_preempted'
Message-ID: <202203100918.w17rtniQ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   8c1db5a775bc8314d78e99263e0d063a01b692c2
commit: 4ab22f38c2046f2c949cb43fc0f7515666a2a2fb [182/205] KVM: x86: Support the vCPU preemption check with nopvspin and realtime hint
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220310/202203100918.w17rtniQ-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=4ab22f38c2046f2c949cb43fc0f7515666a2a2fb
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout 4ab22f38c2046f2c949cb43fc0f7515666a2a2fb
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kernel/kvm.c:756:16: warning: no previous prototype for '__kvm_vcpu_is_preempted' [-Wmissing-prototypes]
     756 | __visible bool __kvm_vcpu_is_preempted(long cpu)
         |                ^~~~~~~~~~~~~~~~~~~~~~~


vim +/__kvm_vcpu_is_preempted +756 arch/x86/kernel/kvm.c

   754	
   755	#ifdef CONFIG_X86_32
 > 756	__visible bool __kvm_vcpu_is_preempted(long cpu)
   757	{
   758		struct kvm_steal_time *src = &per_cpu(steal_time, cpu);
   759	
   760		return !!(src->preempted & KVM_VCPU_PREEMPTED);
   761	}
   762	PV_CALLEE_SAVE_REGS_THUNK(__kvm_vcpu_is_preempted);
   763	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
