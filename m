Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B3368AAA8
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 15:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbjBDOow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 09:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbjBDOov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 09:44:51 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD0B5FCA;
        Sat,  4 Feb 2023 06:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675521890; x=1707057890;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2bnrm71ku0dC13+d0bOUOP0wjReaW31tm2wyIlOVBWw=;
  b=Xuw1qxUAL3zrMFqJGC0Ro/ngd0DtP356PnGVxHY28Frgy3so07hGfTbW
   IT6qHNocDsP5nCZlqE4E9PENKM5kA2wnKyXUV6/rP1PMmH0kE2WPbY2bZ
   VT1soL3G24ckn8o0IXaDFaGPKXfhNdayacx3FgKMiJa8W2I2uqTCJdkPl
   dvZfYUhlLc5Sudyln09YIzIvyDKZLLTdhUt6F7stN+9X3fyP66VZGLp+X
   FiT++HvQSfC1habLhHsSAYnmHeK5Kl5Pxfn5ArTDtfr23znQQts+DHGim
   O4+ddlzL+qw/25e05cX1qBp4AXpWeOcPLR1t+CH45pgg/w7cwFt73p6i9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="309282676"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="309282676"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 06:44:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="666035608"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="666035608"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 04 Feb 2023 06:44:47 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pOJmY-0001Ma-05;
        Sat, 04 Feb 2023 14:44:46 +0000
Date:   Sat, 4 Feb 2023 22:44:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 15/21] KVM: x86/MMU: Remove unneeded exports from
 shadow_mmu.c
Message-ID: <202302042238.bWSFU5Qg-lkp@intel.com>
References: <20230202182809.1929122-16-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202182809.1929122-16-bgardon@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ben,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f]

url:    https://github.com/intel-lab-lkp/linux/commits/Ben-Gardon/KVM-x86-mmu-Rename-slot-rmap-walkers-to-add-clarity-and-clean-up-code/20230203-023259
base:   7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f
patch link:    https://lore.kernel.org/r/20230202182809.1929122-16-bgardon%40google.com
patch subject: [PATCH 15/21] KVM: x86/MMU: Remove unneeded exports from shadow_mmu.c
config: x86_64-randconfig-a002 (https://download.01.org/0day-ci/archive/20230204/202302042238.bWSFU5Qg-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/133035de32b4ef8bb8e3868c78dbdb3b807f04f4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ben-Gardon/KVM-x86-mmu-Rename-slot-rmap-walkers-to-add-clarity-and-clean-up-code/20230203-023259
        git checkout 133035de32b4ef8bb8e3868c78dbdb3b807f04f4
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/mmu/shadow_mmu.c:3208:6: warning: no previous prototype for 'slot_rmap_write_protect' [-Wmissing-prototypes]
    3208 | bool slot_rmap_write_protect(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
         |      ^~~~~~~~~~~~~~~~~~~~~~~


vim +/slot_rmap_write_protect +3208 arch/x86/kvm/mmu/shadow_mmu.c

306e405e1b7fe70 Ben Gardon 2023-02-02  3207  
306e405e1b7fe70 Ben Gardon 2023-02-02 @3208  bool slot_rmap_write_protect(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
306e405e1b7fe70 Ben Gardon 2023-02-02  3209  			     const struct kvm_memory_slot *slot)
306e405e1b7fe70 Ben Gardon 2023-02-02  3210  {
306e405e1b7fe70 Ben Gardon 2023-02-02  3211  	return rmap_write_protect(rmap_head, false);
306e405e1b7fe70 Ben Gardon 2023-02-02  3212  }
306e405e1b7fe70 Ben Gardon 2023-02-02  3213  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
