Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921004749ED
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 18:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbhLNRpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 12:45:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:39347 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhLNRpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 12:45:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639503917; x=1671039917;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F8wZFJ9eIhe2A/T3CaWak765dnWzf/E7CLYtFT1BJy0=;
  b=hojZf01jyzRlStJf6g68ZSScBK7eAXkQDPaVrqR3rJEh7klyXLuch3sR
   Y66nL/AvWI85I4iNrf+qULMV3oeAaJZVnjL0JjG/P3DXJDF/+tn1k8m/z
   cjJSEk7NJ4XweiAXytnmmbkIdZJwF+nX5ESKFPI5dPlG/jfAvrLZDe32g
   NXUMOGJ2ueHm3moX37iZbTBSk3Wr9JPigAUzqvCcdJfIySeLryLFiPru+
   jbFoxuusRXwohEcTGiRcDw2tAJA91qdOgmCl4G9//IGba8mZjFed7ctV1
   7VKWQ55MKMY0Q/+f/H1Ti6vORx5aDDCGTUihKYZr7ab4CfAal9mKNMpkk
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="237772361"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="237772361"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 09:45:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="682147017"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 14 Dec 2021 09:45:15 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mxBrW-0000Zy-JO; Tue, 14 Dec 2021 17:45:14 +0000
Date:   Wed, 15 Dec 2021 01:44:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kbuild-all@lists.01.org, dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Message-ID: <202112150131.MaZ9xOJx-lkp@intel.com>
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
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20211215/202112150131.MaZ9xOJx-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/fd29d23507ef3f06b61d9de1b7ecd1a0d70136f3
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Vipin-Sharma/KVM-Move-VM-s-worker-kthreads-back-to-the-original-cgroups-before-exiting/20211214-130827
        git checkout fd29d23507ef3f06b61d9de1b7ecd1a0d70136f3
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "kthreadd_task" [arch/x86/kvm/kvm.ko] undefined!

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
