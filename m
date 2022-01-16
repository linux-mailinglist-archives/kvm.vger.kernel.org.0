Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EA648FF8C
	for <lists+kvm@lfdr.de>; Sun, 16 Jan 2022 23:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbiAPW4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jan 2022 17:56:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:19892 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230464AbiAPW4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jan 2022 17:56:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642373778; x=1673909778;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=NdTs9xHEBzxLMLoNNcGEKmtrF2ZZjSKrBK9WSL4f3iQ=;
  b=SIMkdIe2Hv40GDFY21bqxCBxhLdEwD06g2uZKtTTqvGOIpWKgNLlb7a8
   CCJxEJLUQBtGtWOvmU2xshuhZQWWztEAG8zKbDUHX+aSHZaAGUfXmKB6A
   zmpO2FGVtM8CHr+3S5PaV9lRjD4/4EoEAVN3uh7jrck4ZMW3X60nIjtl9
   apGwJpHh8FLVTkGyKUr7kGTkPojTU+CQGWjBSmi/SWhGvYe/5vbBBmCqh
   MggpGO0thArSa4iIYEKcmbejx51aqpsb3EO9qLHNnlRhCSLtMhOuRGiCu
   n4wTLWVlCuZV10rLkzSmq/VO/74WyD0/wwz6yX95H5gFbYzDhbu0ffq/e
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="244717677"
X-IronPort-AV: E=Sophos;i="5.88,293,1635231600"; 
   d="scan'208";a="244717677"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 14:56:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,293,1635231600"; 
   d="scan'208";a="692875047"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 16 Jan 2022 14:56:16 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n9ERb-000B1Y-M7; Sun, 16 Jan 2022 22:56:15 +0000
Date:   Mon, 17 Jan 2022 06:55:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
Subject: [kvm:kvm-5.17-conflict 1/1] aarch64-linux-ar: arch/arm64/kvm/perf.o:
 No such file or directory
Message-ID: <202201170614.B4E1ugTv-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-5.17-conflict
head:   1ec20febf55e2d1f485d7590038afbf82b53b8e4
commit: 1ec20febf55e2d1f485d7590038afbf82b53b8e4 [1/1] conflict resolution for 5.17 merge window
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20220117/202201170614.B4E1ugTv-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=1ec20febf55e2d1f485d7590038afbf82b53b8e4
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm kvm-5.17-conflict
        git checkout 1ec20febf55e2d1f485d7590038afbf82b53b8e4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> aarch64-linux-ar: arch/arm64/kvm/perf.o: No such file or directory

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
