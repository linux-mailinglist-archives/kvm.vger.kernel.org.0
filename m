Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B205048CF
	for <lists+kvm@lfdr.de>; Sun, 17 Apr 2022 20:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbiDQSOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Apr 2022 14:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiDQSOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Apr 2022 14:14:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A77BCBA
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 11:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650219126; x=1681755126;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=s3KwwAUlbuQ8fboBcGNqHu7cwsIzA8yI1TXjAXyDRp0=;
  b=Z7fdRL3xrWCRjEDeHHW2cLDC77QZ6IJ68NUN77HuEJZTF/6p1h03uQ5v
   6SVAAF5Dum7TDtIInM3iP7SePJzIc5bqbAW2Slm7c1WqYwtjVS/pkgOTo
   YCdq3vJ69JqqrCzpoBWOmI/cY4Xmbd6xq25ngLLqtlTGmHW73BRBMw76K
   G4Of3fiDFSFaHl20cQ8o6zRY7g/1hcnRCliSw+Rvmuks6TkTXmBqaU4zy
   AlPLZpV0Kk+w4kHf1PLu4QvPiqnJy24qZ9jB+Yz0pHL6isnFiaDB8810l
   kp+kQjBqDxOAiQT9D7HZohSOWkZhvHGILD0UltxmQNhBuLN1x00BD0KKW
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="288486872"
X-IronPort-AV: E=Sophos;i="5.90,267,1643702400"; 
   d="scan'208";a="288486872"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2022 11:11:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,267,1643702400"; 
   d="scan'208";a="726388072"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 17 Apr 2022 11:11:55 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ng9NL-000457-2q;
        Sun, 17 Apr 2022 18:11:55 +0000
Date:   Mon, 18 Apr 2022 02:11:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Isaku Yamahata <isaku.yamahata@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:kvm-tdx-5.17 51/141] arch/x86/kvm/vmx/seamcall.o: warning:
 objtool: kvm_seamcall()+0x3a: missing int3 after ret
Message-ID: <202204180253.4NDA9ZES-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Isaku,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-tdx-5.17
head:   a50e4531e92e36f185ea32843c149c4703451109
commit: 820e729f6c1e56e3baf45122b707a0ddbfafaaae [51/141] KVM: TDX: Add a function for KVM to invoke SEAMCALL
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220418/202204180253.4NDA9ZES-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=820e729f6c1e56e3baf45122b707a0ddbfafaaae
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm kvm-tdx-5.17
        git checkout 820e729f6c1e56e3baf45122b707a0ddbfafaaae
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/vmx/seamcall.o: warning: objtool: kvm_seamcall()+0x3a: missing int3 after ret

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
