Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46FF1BB5AD
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 07:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgD1FHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 01:07:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:40809 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgD1FHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 01:07:13 -0400
IronPort-SDR: ++HF/+JelruREmzZlArItImtnG43BWxhrY8ajHATjcah4QF19lykZuZiU1dztw9ERG3AUaDg+a
 7pPTWioLByew==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 22:07:12 -0700
IronPort-SDR: AbVx6fGxIgJSjLwTyMz+/XIJjPQLCi/R/POa0FwclT56I9g1i8cQZu6nmy/RN/nDFDLz3p6//Y
 zYbVdB406mtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,326,1583222400"; 
   d="scan'208";a="246391815"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 27 Apr 2020 22:07:09 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jTISa-000GjN-Sy; Tue, 28 Apr 2020 13:07:08 +0800
Date:   Tue, 28 Apr 2020 13:06:26 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH v10 09/11] KVM: x86/pmu: Release guest LBR event via vPMU
 lazy release mechanism
Message-ID: <202004281230.jQ78RK3f%lkp@intel.com>
References: <20200423081412.164863-10-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423081412.164863-10-like.xu@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on tip/perf/core]
[also build test WARNING on vhost/linux-next v5.7-rc3 next-20200424]
[cannot apply to kvm/linux-next]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Like-Xu/Guest-Last-Branch-Recording-Enabling/20200426-123735
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git 87cfeb1920f84f465a738d4c6589033eefa20b45
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   arch/x86/kvm/pmu.c:190:18: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/x86/kvm/pmu.c:190:18: sparse:    struct kvm_pmu_event_filter [noderef] <asn:4> *
   arch/x86/kvm/pmu.c:190:18: sparse:    struct kvm_pmu_event_filter *
   arch/x86/kvm/pmu.c:251:18: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/x86/kvm/pmu.c:251:18: sparse:    struct kvm_pmu_event_filter [noderef] <asn:4> *
   arch/x86/kvm/pmu.c:251:18: sparse:    struct kvm_pmu_event_filter *
>> arch/x86/kvm/pmu.c:455:6: sparse: sparse: symbol 'kvm_pmu_lbr_cleanup' was not declared. Should it be static?
   arch/x86/kvm/pmu.c:524:18: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/x86/kvm/pmu.c:524:18: sparse:    struct kvm_pmu_event_filter [noderef] <asn:4> *
   arch/x86/kvm/pmu.c:524:18: sparse:    struct kvm_pmu_event_filter *
   arch/x86/kvm/pmu.c:524:18: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/x86/kvm/pmu.c:524:18: sparse:    struct kvm_pmu_event_filter [noderef] <asn:4> *
   arch/x86/kvm/pmu.c:524:18: sparse:    struct kvm_pmu_event_filter *

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
