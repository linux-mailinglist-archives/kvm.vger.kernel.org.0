Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08FC5178DA
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 23:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387576AbiEBVOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 17:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387560AbiEBVOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 17:14:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E382193
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 14:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651525876; x=1683061876;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=bz8XdlfC0zb93jdEankXZu3bo9qlArkBpYsL14jquwQ=;
  b=hscWUOlbjNSUIQHSanGFQ3nVek4FOg/7aJAg6R+A32gYF7QLKAWyc0N1
   HW9q7T9W+VtXsXa1reE2mAkU79s9N+mbi10FLKwsgFQc3xzZjj5wE4dY9
   dtBEhmpt6V9a57tt2JHL1XDAKRgko24wp7+Ol8jGviAny++r/kgMhFU4j
   W+kkc8Pdy+oIsG4lj2X7Fsqf34Hp4GWNooQYj873nsiTLiE0oTlVM66X8
   b0y9+72qrFOcbFnOF/ClCA6zklU6UmXxsLReeb1cXGfHrL59/t2pslE5Q
   s7bAMi5r3nY6uvW6M3fq0EYISuYdI6pdNA3/jfgBKo1jWHjbqzPCwdmo1
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="353765055"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="353765055"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 14:11:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="516283619"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 02 May 2022 14:11:13 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nldK4-0009sY-Hf;
        Mon, 02 May 2022 21:11:12 +0000
Date:   Tue, 3 May 2022 05:10:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [kvm:queue 74/77] arch/x86/kvm/vmx/vmx.c:4405:5: warning: no
 previous prototype for 'vmx_get_pid_table_order'
Message-ID: <202205030535.s9SuleZq-lkp@intel.com>
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
config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220503/202205030535.s9SuleZq-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=101c99f6506d7fc293111190d65fedadb711c9ea
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout 101c99f6506d7fc293111190d65fedadb711c9ea
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/vmx/vmx.c:4405:5: warning: no previous prototype for 'vmx_get_pid_table_order' [-Wmissing-prototypes]
    4405 | int vmx_get_pid_table_order(struct kvm *kvm)
         |     ^~~~~~~~~~~~~~~~~~~~~~~


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
