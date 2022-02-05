Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CF54AA75E
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 08:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376677AbiBEHoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 02:44:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:14490 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232203AbiBEHoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Feb 2022 02:44:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644047059; x=1675583059;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O5k63NoEK7eQEOe5nVTsQKgM+XYmsqyennE1QHDOWrM=;
  b=Yu6cDD9VY+377lE1vNALewWyw9JdNARrnitnZyQgHW+yN8V5Jetyw5Cn
   4TOAFwa9dgi5iJXgZ8DffyvaYgKpfW4GmQHAab3x+7eOvs0U8xryUazIN
   IMQhv+oSNYEX1bfIZ1b0usHL+meV2IhcpUbSCTF8AEX/yQE8nMYn3u7bU
   iPJ6UmwNsG8xDHmOsrSDiqB0kb+KIud3uzuOQ9iLZ6tcnl3B5nBRVVLRh
   wdS7K4h7aEt9OoEiU7dchObbopcsV/izWFe4Ygq88MqXYvSzLkJFkNV52
   +Ut88Np2ejqwIdsJ5y+Xn/SW+/vEfSJRpL1qTvo1ZeZcVnYzulShY2DMb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="228466105"
X-IronPort-AV: E=Sophos;i="5.88,345,1635231600"; 
   d="scan'208";a="228466105"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 23:44:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,345,1635231600"; 
   d="scan'208";a="584352666"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 04 Feb 2022 23:44:17 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nGFk1-000YlQ-6S; Sat, 05 Feb 2022 07:44:17 +0000
Date:   Sat, 5 Feb 2022 15:43:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 3/7] KVM: nVMX: Roll all entry/exit ctl updates into a
 single helper
Message-ID: <202202051529.y26BVBiF-lkp@intel.com>
References: <20220204204705.3538240-4-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204204705.3538240-4-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.17-rc2 next-20220204]
[cannot apply to kvm/queue mst-vhost/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Oliver-Upton/VMX-nVMX-VMX-control-MSR-fixes/20220205-044901
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 86286e486cbdd68f01d330409307f6a6efcd4298
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20220205/202202051529.y26BVBiF-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/3053b58337c5bb48b67fce9fb0616887b7180370
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Oliver-Upton/VMX-nVMX-VMX-control-MSR-fixes/20220205-044901
        git checkout 3053b58337c5bb48b67fce9fb0616887b7180370
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "kvm_pmu_is_valid_msr" [arch/x86/kvm/kvm-intel.ko] undefined!

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
