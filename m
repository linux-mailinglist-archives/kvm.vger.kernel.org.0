Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E774418D349
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 16:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgCTPsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 11:48:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:58103 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgCTPsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 11:48:35 -0400
IronPort-SDR: UdFXWonmYTSKUWPCM15tMfqt71IV5ryomFt/WCF9/tuELBEKHbeOAQdCOPXEIjMbw8oZmyC417
 xYRzuqT2bHrA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 08:48:35 -0700
IronPort-SDR: IM65Mmj0Ap/p+aqvrO7YfQfcDwKOrQI3s/YrbUmx31ZpgRjdkYmjIImq+/Z/44oLOotIL/MFaM
 P8wJX8VR45nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="446689727"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 20 Mar 2020 08:48:32 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jFJsu-00058x-5m; Fri, 20 Mar 2020 23:48:32 +0800
Date:   Fri, 20 Mar 2020 23:48:17 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v10 6/8] KVM: X86: Add userspace access interface for CET
 MSRs
Message-ID: <202003202309.SvJfslTC%lkp@intel.com>
References: <20200320034342.26610-7-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320034342.26610-7-weijiang.yang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yang,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/linux-next]
[also build test WARNING on next-20200319]
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

   arch/x86/kvm/x86.c:809:60: sparse: sparse: undefined identifier 'X86_CR4_CET'
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
>> arch/x86/kvm/x86.c:1512:14: sparse: sparse: incompatible types for 'case' statement
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

vim +/case +1512 arch/x86/kvm/x86.c

  1475	
  1476	/*
  1477	 * Write @data into the MSR specified by @index.  Select MSR specific fault
  1478	 * checks are bypassed if @host_initiated is %true.
  1479	 * Returns 0 on success, non-0 otherwise.
  1480	 * Assumes vcpu_load() was already called.
  1481	 */
  1482	static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
  1483				 bool host_initiated)
  1484	{
  1485		struct msr_data msr;
  1486	
  1487		switch (index) {
  1488		case MSR_FS_BASE:
  1489		case MSR_GS_BASE:
  1490		case MSR_KERNEL_GS_BASE:
  1491		case MSR_CSTAR:
  1492		case MSR_LSTAR:
  1493			if (is_noncanonical_address(data, vcpu))
  1494				return 1;
  1495			break;
  1496		case MSR_IA32_SYSENTER_EIP:
  1497		case MSR_IA32_SYSENTER_ESP:
  1498			/*
  1499			 * IA32_SYSENTER_ESP and IA32_SYSENTER_EIP cause #GP if
  1500			 * non-canonical address is written on Intel but not on
  1501			 * AMD (which ignores the top 32-bits, because it does
  1502			 * not implement 64-bit SYSENTER).
  1503			 *
  1504			 * 64-bit code should hence be able to write a non-canonical
  1505			 * value on AMD.  Making the address canonical ensures that
  1506			 * vmentry does not fail on Intel after writing a non-canonical
  1507			 * value, and that something deterministic happens if the guest
  1508			 * invokes 64-bit SYSENTER.
  1509			 */
  1510			data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
  1511			break;
> 1512		case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
  1513		case MSR_IA32_U_CET:
  1514		case MSR_IA32_S_CET:
  1515		case MSR_IA32_INT_SSP_TAB:
  1516			if (is_noncanonical_address(data, vcpu))
  1517				return 1;
  1518		}
  1519	
  1520		msr.data = data;
  1521		msr.index = index;
  1522		msr.host_initiated = host_initiated;
  1523	
  1524		return kvm_x86_ops->set_msr(vcpu, &msr);
  1525	}
  1526	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
