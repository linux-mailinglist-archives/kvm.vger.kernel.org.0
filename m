Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A6CE58BE
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 07:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfJZF3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Oct 2019 01:29:01 -0400
Received: from mga07.intel.com ([134.134.136.100]:24207 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfJZF3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Oct 2019 01:29:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 22:28:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,230,1569308400"; 
   d="scan'208";a="202798209"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 25 Oct 2019 22:28:56 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iOEdE-000Aqe-83; Sat, 26 Oct 2019 13:28:56 +0800
Date:   Sat, 26 Oct 2019 13:28:36 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     kbuild-all@lists.01.org, pbonzini@redhat.com, peterz@infradead.org,
        kvm@vger.kernel.org, like.xu@intel.com,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, wei.w.wang@intel.com,
        kan.liang@intel.com
Subject: Re: [PATCH v3 4/6] KVM: x86/vPMU: Introduce a new
 kvm_pmu_ops->msr_idx_to_pmc callback
Message-ID: <201910261319.61sNCjSs%lkp@intel.com>
References: <20191021160651.49508-5-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021160651.49508-5-like.xu@linux.intel.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/linux-next]
[cannot apply to v5.4-rc4 next-20191025]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Like-Xu/KVM-x86-vPMU-Efficiency-optimization-by-reusing-last-created-perf_event/20191024-164128
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> arch/x86/kvm/vmx/pmu_intel.c:165:16: sparse: sparse: symbol 'intel_msr_idx_to_pmc' was not declared. Should it be static?
--
>> arch/x86/kvm/pmu_amd.c:207:16: sparse: sparse: symbol 'amd_msr_idx_to_pmc' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
