Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C076A50462E
	for <lists+kvm@lfdr.de>; Sun, 17 Apr 2022 05:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiDQDDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Apr 2022 23:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiDQDDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Apr 2022 23:03:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166C120F46
        for <kvm@vger.kernel.org>; Sat, 16 Apr 2022 20:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650164456; x=1681700456;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ZxVN+RROQ6sgFy8urtza50B4zMtGHN/D9rH5OZEHdVQ=;
  b=BYvGJk1DHG3/TN/RDeMLWpq4Tov9MEk/e1Jjehe8FD/LrEkWi/kV3Mg8
   lrTvFX7/DdXUO89qo0yYsJMSSpZc4iuXoKbFXQTbQX1H+q/pdDENNhzaX
   VVfdDQxfd+LEpw8GONpLdfDbIDzmlr1PCh/FwpivltnVVYb7A/r3TV21C
   22pe3o3Ep0n296UUKrbFjgiI+cIosgHeHSinOjgtNW7MHxAu+ZY6Ff4Rz
   7LMsAeHDTtm2Ky04AJEjWIvea5xb3UVYWH2ESG8VAwnOIK64GrSAc3bn8
   BhnjevCwbCO4wNDhw5lh/L7dAZkkKFRAVUFSE6+NgQ6UD6hCg3YaZUfhQ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="262816686"
X-IronPort-AV: E=Sophos;i="5.90,266,1643702400"; 
   d="scan'208";a="262816686"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2022 20:00:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,266,1643702400"; 
   d="scan'208";a="592036773"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 16 Apr 2022 20:00:25 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nfv9E-0003fF-Iw;
        Sun, 17 Apr 2022 03:00:24 +0000
Date:   Sun, 17 Apr 2022 11:00:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:kvm-tdx-5.17 7/141] arch/x86/virt/vmx/tdx/seamcall.o: warning:
 objtool: __seamcall()+0x46: missing int3 after ret
Message-ID: <202204171016.7VJvUbvD-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kai,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-tdx-5.17
head:   a50e4531e92e36f185ea32843c149c4703451109
commit: 55f1546c5d9dc79ece2167f7f745ad7e036e8cfd [7/141] x86/virt/tdx: Implement the SEAMCALL base function
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220417/202204171016.7VJvUbvD-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=55f1546c5d9dc79ece2167f7f745ad7e036e8cfd
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm kvm-tdx-5.17
        git checkout 55f1546c5d9dc79ece2167f7f745ad7e036e8cfd
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/virt/vmx/tdx/seamcall.o: warning: objtool: __seamcall()+0x46: missing int3 after ret

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
