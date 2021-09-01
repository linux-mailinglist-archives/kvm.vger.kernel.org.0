Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EF63FDE16
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 16:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244176AbhIAOz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 10:55:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:47470 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229748AbhIAOz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 10:55:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="282485663"
X-IronPort-AV: E=Sophos;i="5.84,369,1620716400"; 
   d="scan'208";a="282485663"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 07:54:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,369,1620716400"; 
   d="scan'208";a="688378796"
Received: from lkp-server01.sh.intel.com (HELO 4fbc2b3ce5aa) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 01 Sep 2021 07:54:17 -0700
Received: from kbuild by 4fbc2b3ce5aa with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mLRd2-0007yl-UG; Wed, 01 Sep 2021 14:54:16 +0000
Date:   Wed, 1 Sep 2021 22:53:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Peter Gonda <pgonda@google.com>
Subject: Re: [PATCH 3/3 V6] selftest: KVM: Add intra host migration
Message-ID: <202109012248.6L4914Oi-lkp@intel.com>
References: <20210830205717.3530483-4-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830205717.3530483-4-pgonda@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on vhost/linux-next]
[also build test WARNING on v5.14 next-20210901]
[cannot apply to kvm/queue]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Peter-Gonda/KVM-SEV-Add-support-for-SEV-intra-host-migration/20210831-055739
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


includecheck warnings: (new ones prefixed by >>)
>> tools/testing/selftests/kvm/x86_64/sev_vm_tests.c: kvm_util.h is included more than once.

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
