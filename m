Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0BC12DC21
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 23:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfLaW1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 17:27:37 -0500
Received: from mga18.intel.com ([134.134.136.126]:19577 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfLaW1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 17:27:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 14:27:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="231416403"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 31 Dec 2019 14:27:35 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1imPzC-0009fK-Ms; Wed, 01 Jan 2020 06:27:34 +0800
Date:   Wed, 1 Jan 2020 06:26:45 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, sean.j.christopherson@intel.com,
        yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: Re: [PATCH v10 07/10] mmu: spp: Enable Lazy mode SPP protection
Message-ID: <202001010504.RyikzFRu%lkp@intel.com>
References: <20191231065043.2209-8-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231065043.2209-8-weijiang.yang@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yang,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/linux-next]
[also build test WARNING on vhost/linux-next tip/auto-latest linux/master linus/master v5.5-rc4 next-20191219]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Yang-Weijiang/Enable-Sub-Page-Write-Protection-Support/20191231-145254
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   arch/x86/kvm/mmu/spp.c:202:5: sparse: sparse: symbol 'kvm_spp_level_pages' was not declared. Should it be static?
   arch/x86/kvm/mmu/spp.c:419:6: sparse: sparse: symbol 'kvm_spp_flush_rmap' was not declared. Should it be static?
>> arch/x86/kvm/mmu/spp.c:574:6: sparse: sparse: symbol 'is_spp_protected' was not declared. Should it be static?
   arch/x86/kvm/mmu/mmu.c:4827:57: sparse: sparse: cast truncates bits from constant value (ffffff33 becomes 33)
   arch/x86/kvm/mmu/mmu.c:4829:56: sparse: sparse: cast truncates bits from constant value (ffffff0f becomes f)
   arch/x86/kvm/mmu/mmu.c:4831:57: sparse: sparse: cast truncates bits from constant value (ffffff55 becomes 55)

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
