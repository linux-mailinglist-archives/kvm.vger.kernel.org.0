Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10F8F18D594
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 18:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgCTRSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 13:18:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:27716 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgCTRSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 13:18:53 -0400
IronPort-SDR: h8AV/6FI2EEoHL9RglLWgBtAbT/CsoOWhWocIMy00S/A7vCdLO47wPLE+eauroEVneQB80BBmU
 GwxkwLJpzCKQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 10:18:52 -0700
IronPort-SDR: 0cz85uFwoQtLLVv7DCcCeNiE5EgXeu5SUeyZK1XhF4/047s7fdBY9zcyPOUOvtE0HMNoksIQW9
 c7qhA4E3mdDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="239283183"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2020 10:18:50 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jFLIH-0003RB-CC; Sat, 21 Mar 2020 01:18:49 +0800
Date:   Sat, 21 Mar 2020 01:18:14 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v10 8/8] KVM: X86: Set CET feature bits for CPUID
 enumeration
Message-ID: <202003210154.29vmxMsO%lkp@intel.com>
References: <20200320034342.26610-9-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320034342.26610-9-weijiang.yang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yang,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/linux-next]
[also build test WARNING on next-20200320]
[cannot apply to vhost/linux-next tip/auto-latest linux/master linus/master v5.6-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Yang-Weijiang/Introduce-support-for-guest-CET-feature/20200320-155517
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-181-g83789bbc-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   arch/x86/kvm/x86.c:98:46: sparse: sparse: undefined identifier 'X86_CR4_CET'
>> arch/x86/kvm/x86.c:98:46: sparse: sparse: cast from unknown type
   arch/x86/kvm/x86.c:809:60: sparse: sparse: undefined identifier 'X86_CR4_CET'
   arch/x86/kvm/x86.c:940:29: sparse: sparse: undefined identifier 'X86_CR4_CET'
   arch/x86/kvm/x86.c:940:29: sparse: sparse: cast from unknown type
   arch/x86/kvm/x86.c:956:19: sparse: sparse: undefined identifier 'X86_CR4_CET'
   arch/x86/kvm/x86.c:956:19: sparse: sparse: cast from unknown type
   arch/x86/kvm/x86.c:1233:23: sparse: sparse: undefined identifier 'MSR_IA32_U_CET'
   arch/x86/kvm/x86.c:1233:39: sparse: sparse: undefined identifier 'MSR_IA32_S_CET'
   arch/x86/kvm/x86.c:1234:9: sparse: sparse: undefined identifier 'MSR_IA32_PL0_SSP'
   arch/x86/kvm/x86.c:1234:27: sparse: sparse: undefined identifier 'MSR_IA32_PL1_SSP'
   arch/x86/kvm/x86.c:1234:45: sparse: sparse: undefined identifier 'MSR_IA32_PL2_SSP'
   arch/x86/kvm/x86.c:1235:9: sparse: sparse: undefined identifier 'MSR_IA32_PL3_SSP'
   arch/x86/kvm/x86.c:1235:27: sparse: sparse: undefined identifier 'MSR_IA32_INT_SSP_TAB'
   arch/x86/kvm/x86.c:1512:14: sparse: sparse: undefined identifier 'MSR_IA32_PL0_SSP'
   arch/x86/kvm/x86.c:1512:35: sparse: sparse: undefined identifier 'MSR_IA32_PL3_SSP'
   arch/x86/kvm/x86.c:1513:14: sparse: sparse: undefined identifier 'MSR_IA32_U_CET'
   arch/x86/kvm/x86.c:1514:14: sparse: sparse: undefined identifier 'MSR_IA32_S_CET'
   arch/x86/kvm/x86.c:1515:14: sparse: sparse: undefined identifier 'MSR_IA32_INT_SSP_TAB'
   arch/x86/kvm/x86.c:1512:14: sparse: sparse: incompatible types for 'case' statement
   arch/x86/kvm/x86.c:1512:35: sparse: sparse: incompatible types for 'case' statement
   arch/x86/kvm/x86.c:1513:14: sparse: sparse: incompatible types for 'case' statement
   arch/x86/kvm/x86.c:1514:14: sparse: sparse: incompatible types for 'case' statement
   arch/x86/kvm/x86.c:1515:14: sparse: sparse: incompatible types for 'case' statement
   arch/x86/kvm/x86.c:2646:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const [noderef] <asn:1> * @@    got  const [noderef] <asn:1> * @@
   arch/x86/kvm/x86.c:2646:38: sparse:    expected void const [noderef] <asn:1> *
   arch/x86/kvm/x86.c:2646:38: sparse:    got unsigned char [usertype] *
   arch/x86/kvm/x86.c:3267:25: sparse: sparse: undefined identifier 'MSR_IA32_U_CET'
   arch/x86/kvm/x86.c:7549:15: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/x86/kvm/x86.c:7549:15: sparse:    struct kvm_apic_map [noderef] <asn:4> *
   arch/x86/kvm/x86.c:7549:15: sparse:    struct kvm_apic_map *
   arch/x86/kvm/x86.c:9678:44: sparse: sparse: undefined identifier 'XFEATURE_MASK_CET_USER'
   arch/x86/kvm/x86.c:9678:44: sparse: sparse: undefined identifier 'XFEATURE_MASK_CET_KERNEL'
   arch/x86/kvm/x86.c:9912:16: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/x86/kvm/x86.c:9912:16: sparse:    struct kvm_apic_map [noderef] <asn:4> *
   arch/x86/kvm/x86.c:9912:16: sparse:    struct kvm_apic_map *
   arch/x86/kvm/x86.c:9913:15: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/x86/kvm/x86.c:9913:15: sparse:    struct kvm_pmu_event_filter [noderef] <asn:4> *
   arch/x86/kvm/x86.c:9913:15: sparse:    struct kvm_pmu_event_filter *
   arch/x86/kvm/x86.c:1512:14: sparse: sparse: Expected constant expression in case statement
   arch/x86/kvm/x86.c:1512:35: sparse: sparse: Expected constant expression in case statement
   arch/x86/kvm/x86.c:1513:14: sparse: sparse: Expected constant expression in case statement
   arch/x86/kvm/x86.c:1514:14: sparse: sparse: Expected constant expression in case statement
   arch/x86/kvm/x86.c:1515:14: sparse: sparse: Expected constant expression in case statement
--
   arch/x86/kvm/emulate.c:5495:21: sparse: sparse: arithmetics on pointers to functions
   arch/x86/kvm/emulate.c:4206:17: sparse: sparse: undefined identifier 'X86_CR4_CET'
>> arch/x86/kvm/emulate.c:4206:17: sparse: sparse: cast from unknown type

vim +98 arch/x86/kvm/x86.c

313a3dc75da206 drivers/kvm/x86.c  Carsten Otte        2007-10-11  97  
b11306b53b2540 arch/x86/kvm/x86.c Sean Christopherson 2019-12-10 @98  static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
b11306b53b2540 arch/x86/kvm/x86.c Sean Christopherson 2019-12-10  99  

:::::: The code at line 98 was first introduced by commit
:::::: b11306b53b2540c6ba068c4deddb6a17d9f8d95b KVM: x86: Don't let userspace set host-reserved cr4 bits

:::::: TO: Sean Christopherson <sean.j.christopherson@intel.com>
:::::: CC: Paolo Bonzini <pbonzini@redhat.com>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
