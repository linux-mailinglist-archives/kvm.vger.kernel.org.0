Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE68504D89
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 10:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbiDRIIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 04:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbiDRIH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 04:07:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215A3DFC3
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 01:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650269120; x=1681805120;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=l+ZIgFdQsXBKeJf59UTUHee9+HfC6bwKCRbjy0ketfM=;
  b=kFDV8+Wo1rRmC6/aAWCk5kmZjTPCo56Sy82wCXblMoWrnPyCDBo/y5P5
   +Vuews7lPJ+/32RH7ffLlUXbuQrpz5xBdw26y6zdwPCC7pLcxYnqsDvS2
   blF60P78aEoYWM50iLXDgODfQrcyH1SolZ2wG3od7rE6CAw7gKQIqqQXU
   cOP2w8clzVUX5G05H4buP2yJPJ5ajs0FxACWR8tVA9/0dw6LXTP3WWsLK
   mTZhVrbjqO2dtOMCMFiVhcP0m6ZU0rS9yo+tQhewBNAugCv9yJxDJVAlm
   xQuIWRgy7DAzL9UD5SrIpCUVZFHWevK8CRI2hTsz45VFuoLUbpOEFyCvN
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="263650579"
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="263650579"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 01:05:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="726559022"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 18 Apr 2022 01:05:17 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ngMNp-0004Sp-5J;
        Mon, 18 Apr 2022 08:05:17 +0000
Date:   Mon, 18 Apr 2022 16:05:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Isaku Yamahata <isaku.yamahata@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:kvm-tdx-5.17 100/141] arch/x86/kvm/vmx/vmenter.o: warning:
 objtool: __tdx_vcpu_run()+0xdc: missing int3 after ret
Message-ID: <202204181614.gF9HYsmD-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Isaku,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-tdx-5.17
head:   a50e4531e92e36f185ea32843c149c4703451109
commit: 48690d2ec7328b9a1f128cbc6c6d6655a76ca2cf [100/141] KVM: TDX: Add helper assembly function to TDX vcpu
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220418/202204181614.gF9HYsmD-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=48690d2ec7328b9a1f128cbc6c6d6655a76ca2cf
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm kvm-tdx-5.17
        git checkout 48690d2ec7328b9a1f128cbc6c6d6655a76ca2cf
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/vmx/vmenter.o: warning: objtool: __tdx_vcpu_run()+0xdc: missing int3 after ret

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
