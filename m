Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15DD4746BC
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 16:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhLNPqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 10:46:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:29913 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235154AbhLNPqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 10:46:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639496773; x=1671032773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D1ie7p/wJUPFDq45hFFlAgkDToTHWRbYRCMmw5W3DLQ=;
  b=Np2YYRb0WtnDK5eWeonoFFqkHLeNFlv5msgLl+Wj4snQfdAgCJXwm81n
   tjxCLrl0hbujBL4QOPcj9/TFZwycMvygSCqi+TZKg7JvnNsfEWZLxgakA
   KOois0YSKT/eYd1EE0MSGmBVzROqf5sh8pk+8TfhWZzquobWIJHbjxsRz
   fFSCWPh1Beg4sGnnwO5IwTE67sXHa1H3bNDA016LBUknIjP3iiT8CgWZt
   LdlfYIxqzwjxpVWZ1VpODKDXYCAaEU49+EnI7MUUplRtHUHFkUV8Sb8sW
   TC/DUpV3o1mVbWYAQeDz6iWF28Uos/WgbXRxGX/JzDL/NRxI132vi/waz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="263144950"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="263144950"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 07:46:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="682101390"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 14 Dec 2021 07:46:11 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mxA0I-0000Sr-W3; Tue, 14 Dec 2021 15:46:10 +0000
Date:   Tue, 14 Dec 2021 23:46:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kbuild-all@lists.01.org, dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Message-ID: <202112142328.a9ebDmd7-lkp@intel.com>
References: <20211214050708.4040200-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214050708.4040200-1-vipinsh@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vipin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on d8f6ef45a623d650f9b97e11553adb4978f6aa70]

url:    https://github.com/0day-ci/linux/commits/Vipin-Sharma/KVM-Move-VM-s-worker-kthreads-back-to-the-original-cgroups-before-exiting/20211214-130827
base:   d8f6ef45a623d650f9b97e11553adb4978f6aa70
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20211214/202112142328.a9ebDmd7-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/fd29d23507ef3f06b61d9de1b7ecd1a0d70136f3
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Vipin-Sharma/KVM-Move-VM-s-worker-kthreads-back-to-the-original-cgroups-before-exiting/20211214-130827
        git checkout fd29d23507ef3f06b61d9de1b7ecd1a0d70136f3
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "kthreadd_task" [arch/riscv/kvm/kvm.ko] undefined!

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
