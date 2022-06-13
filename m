Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDF1549B90
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 20:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245636AbiFMScE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 14:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245653AbiFMSbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 14:31:42 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178671D6864
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 07:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655131800; x=1686667800;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=KtPUKYDbJWerz/NmuDvWPFgzxMHwxXup5EBi0GMyYVU=;
  b=J5wFWCwecn1+M7UJJISqavkGK1wybcX9XcT0mAoa+bGDDKcAz+/toIG3
   4ovL0pGX0xuTbe/g/U0gIRdxAtvzNWzHsTnUaFeuUX5ch75t897lJO9cs
   hTXJaSnGtcS/PD1LQhPXIAmSd9znIN1MjyVxtvWLBBN6VgSHuk+Nbhtmc
   iDA7oUIYfJ4L6vzTFJhyrgkrq3pUfCSrT2M8WMTkBBokj7ypLiYKGzdwV
   gTYkFHIIKmNeUzP8ldl2BWLsZ4ObyEEh9Fdpr64AZNX2uckhGd0SHwSmm
   zKHv3aeSkcQ3+nHMITJ6sow0xDAW6+qcRRbQXuZsDqBNyez1+KGBkElEn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="266997277"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="266997277"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 07:49:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="535129917"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 13 Jun 2022 07:49:49 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o0lO1-000Kst-3h;
        Mon, 13 Jun 2022 14:49:49 +0000
Date:   Mon, 13 Jun 2022 22:49:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:queue 5/184] arch/x86/kvm/svm/avic.c:913:6: warning: shift
 count >= width of type
Message-ID: <202206132237.17DFkdFl-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   8baacf67c76c560fed954ac972b63e6e59a6fba0
commit: 3743c2f0251743b8ae968329708bbbeefff244cf [5/184] KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base
config: i386-buildonly-randconfig-r002-20220613 (https://download.01.org/0day-ci/archive/20220613/202206132237.17DFkdFl-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d378268ead93c85803c270277f0243737b536ae7)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=3743c2f0251743b8ae968329708bbbeefff244cf
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout 3743c2f0251743b8ae968329708bbbeefff244cf
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/ drivers/gpu/drm/amd/display/amdgpu_dm/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/svm/avic.c:913:6: warning: shift count >= width of type [-Wshift-count-overflow]
                             BIT(APICV_INHIBIT_REASON_SEV      |
                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/vdso/bits.h:7:26: note: expanded from macro 'BIT'
   #define BIT(nr)                 (UL(1) << (nr))
                                          ^  ~~~~
   1 warning generated.


vim +913 arch/x86/kvm/svm/avic.c

   902	
   903	bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
   904	{
   905		ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
   906				  BIT(APICV_INHIBIT_REASON_ABSENT) |
   907				  BIT(APICV_INHIBIT_REASON_HYPERV) |
   908				  BIT(APICV_INHIBIT_REASON_NESTED) |
   909				  BIT(APICV_INHIBIT_REASON_IRQWIN) |
   910				  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
   911				  BIT(APICV_INHIBIT_REASON_X2APIC) |
   912				  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 > 913				  BIT(APICV_INHIBIT_REASON_SEV      |
   914				  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
   915				  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED));
   916	
   917		return supported & BIT(reason);
   918	}
   919	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
