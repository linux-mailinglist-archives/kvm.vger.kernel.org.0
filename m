Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885E559FD19
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 16:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbiHXOWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 10:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbiHXOWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 10:22:20 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483F622BCC
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 07:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661350939; x=1692886939;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L3X04e2cHtS9lSBq9xAoEisrpqNf957ajU4Fhv193ZU=;
  b=Zel/uGZnPKXtNT05ejLZO9pqnC29TCjXx9cZTJhQMmsNg4j/bZOD9+yb
   ijb/0m1Ikb9xn1GiLIuPUcl8E0AA11Ps8kx1dRMTdBC3N8RXmwk8tXZZH
   hfeXKo3gxCLsRfvXr24KvwXl9xutiMGKI81XxmgdkaY6T2u/4mlZO+2FA
   VYb+81RZ0/HfNdiroRqeOmSv1gycfUltyQbOY/WfZy1BVfR0zHdSlQuzi
   ZpaMTR9QaiRseMgwYCH4BnAvf4nd1+C0oLS4s8Ek+qR4CJmE/0a26yLxw
   oFWHPv5fwBe4mvmWTHLI8zQCcaXpai3uelwUzHpu15FW3ZgXGZEIJHV75
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="280952485"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="280952485"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 07:22:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="699089796"
Received: from lkp-server02.sh.intel.com (HELO 34e741d32628) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Aug 2022 07:22:15 -0700
Received: from kbuild by 34e741d32628 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQrGo-0000bx-2f;
        Wed, 24 Aug 2022 14:22:14 +0000
Date:   Wed, 24 Aug 2022 22:21:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 2/9] KVM: x86/mmu: Drop kvm->arch.tdp_mmu_enabled
Message-ID: <202208242248.quWrDOnO-lkp@intel.com>
References: <20220815230110.2266741-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815230110.2266741-3-dmatlack@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 93472b79715378a2386598d6632c654a2223267b]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Matlack/KVM-x86-mmu-Always-enable-the-TDP-MMU-when-TDP-is-enabled/20220816-135710
base:   93472b79715378a2386598d6632c654a2223267b
config: i386-debian-10.3-kselftests (https://download.01.org/0day-ci/archive/20220824/202208242248.quWrDOnO-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/05144150ed5b370369565be6b75d7504e64f3ba7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review David-Matlack/KVM-x86-mmu-Always-enable-the-TDP-MMU-when-TDP-is-enabled/20220816-135710
        git checkout 05144150ed5b370369565be6b75d7504e64f3ba7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "kvm_tdp_mmu_test_age_gfn" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: modpost: "kvm_tdp_mmu_zap_all" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: modpost: "kvm_tdp_mmu_clear_dirty_pt_masked" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: modpost: "kvm_tdp_mmu_age_gfn_range" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: modpost: "kvm_tdp_mmu_zap_leafs" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: modpost: "kvm_tdp_mmu_unmap_gfn_range" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: modpost: "kvm_tdp_mmu_invalidate_all_roots" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: modpost: "kvm_tdp_mmu_get_vcpu_root_hpa" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: modpost: "kvm_tdp_mmu_set_spte_gfn" [arch/x86/kvm/kvm.ko] undefined!
ERROR: modpost: "kvm_tdp_mmu_wrprot_slot" [arch/x86/kvm/kvm.ko] undefined!
WARNING: modpost: suppressed 5 unresolved symbol warnings because there were too many)

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
