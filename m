Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D6C4AA41B
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 00:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377982AbiBDXQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 18:16:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:6598 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377934AbiBDXP7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 18:15:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644016559; x=1675552559;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=whh3+8Y67mX9ZEYVBzS8F9B0b3KAE3rv1zuodYAlJBM=;
  b=KfGHXwUTAYPI13Ferp936uUNwZUf/PCaCZHMMjqLkasBNcJhgJQ2CKmR
   PYvMgP/9eoIBQ9zzQul/yEaRg88G6fwZfuBWs3Mppp5vaCxdQr3U2PaOH
   x7SWTeAWcbE1l82erVe3UAoscFKWNdzliR5rA+ZR8kMJiHdjs0lJOc3Us
   0qhTg9UaI5DqhIiTkSfpyPumbxxjy82QWHYodIzq1iOwY62M/hnxWb4j1
   V+yxaNLuX32DDd/r1ARpNG/XVErtbVuB+jOpAd92z1x7PfrUh0Idq4YUX
   hGv6P4otaAWVTA3m42GSYkhR6wmwPvhrPaiSW7XuFffyrJ6AzutiQy6om
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="311759899"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="311759899"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 15:15:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="631845328"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 04 Feb 2022 15:15:56 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nG7o3-000YI0-S1; Fri, 04 Feb 2022 23:15:55 +0000
Date:   Sat, 5 Feb 2022 07:14:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH 04/11] KVM: SVM: Use common kvm_apic_write_nodecode() for
 AVIC write traps
Message-ID: <202202050720.YPm113nN-lkp@intel.com>
References: <20220204214205.3306634-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204214205.3306634-5-seanjc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

I love your patch! Yet something to improve:

[auto build test ERROR on 17179d0068b20413de2355f84c75a93740257e20]

url:    https://github.com/0day-ci/linux/commits/Sean-Christopherson/KVM-x86-Prep-work-for-VMX-IPI-virtualization/20220205-054418
base:   17179d0068b20413de2355f84c75a93740257e20
config: x86_64-allmodconfig (https://download.01.org/0day-ci/archive/20220205/202202050720.YPm113nN-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/528172fca9c0e8fac06680430bf69a55e4559974
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sean-Christopherson/KVM-x86-Prep-work-for-VMX-IPI-virtualization/20220205-054418
        git checkout 528172fca9c0e8fac06680430bf69a55e4559974
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/x86/kvm/svm/avic.c: In function 'avic_unaccel_trap_write':
>> arch/x86/kvm/svm/avic.c:486:35: error: 'svm' undeclared (first use in this function); did you mean 'sem'?
     486 |   if (avic_handle_apic_id_update(&svm->vcpu))
         |                                   ^~~
         |                                   sem
   arch/x86/kvm/svm/avic.c:486:35: note: each undeclared identifier is reported only once for each function it appears in


vim +486 arch/x86/kvm/svm/avic.c

ef0f64960d012cb Joerg Roedel        2020-03-31  478  
528172fca9c0e8f Sean Christopherson 2022-02-04  479  static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
ef0f64960d012cb Joerg Roedel        2020-03-31  480  {
528172fca9c0e8f Sean Christopherson 2022-02-04  481  	u32 offset = to_svm(vcpu)->vmcb->control.exit_info_1 &
ef0f64960d012cb Joerg Roedel        2020-03-31  482  				AVIC_UNACCEL_ACCESS_OFFSET_MASK;
ef0f64960d012cb Joerg Roedel        2020-03-31  483  
ef0f64960d012cb Joerg Roedel        2020-03-31  484  	switch (offset) {
ef0f64960d012cb Joerg Roedel        2020-03-31  485  	case APIC_ID:
ef0f64960d012cb Joerg Roedel        2020-03-31 @486  		if (avic_handle_apic_id_update(&svm->vcpu))
ef0f64960d012cb Joerg Roedel        2020-03-31  487  			return 0;
ef0f64960d012cb Joerg Roedel        2020-03-31  488  		break;
ef0f64960d012cb Joerg Roedel        2020-03-31  489  	case APIC_LDR:
528172fca9c0e8f Sean Christopherson 2022-02-04  490  		if (avic_handle_ldr_update(vcpu))
ef0f64960d012cb Joerg Roedel        2020-03-31  491  			return 0;
ef0f64960d012cb Joerg Roedel        2020-03-31  492  		break;
ef0f64960d012cb Joerg Roedel        2020-03-31  493  	case APIC_DFR:
528172fca9c0e8f Sean Christopherson 2022-02-04  494  		avic_handle_dfr_update(vcpu);
ef0f64960d012cb Joerg Roedel        2020-03-31  495  		break;
ef0f64960d012cb Joerg Roedel        2020-03-31  496  	default:
ef0f64960d012cb Joerg Roedel        2020-03-31  497  		break;
ef0f64960d012cb Joerg Roedel        2020-03-31  498  	}
ef0f64960d012cb Joerg Roedel        2020-03-31  499  
528172fca9c0e8f Sean Christopherson 2022-02-04  500  	kvm_apic_write_nodecode(vcpu, offset);
ef0f64960d012cb Joerg Roedel        2020-03-31  501  	return 1;
ef0f64960d012cb Joerg Roedel        2020-03-31  502  }
ef0f64960d012cb Joerg Roedel        2020-03-31  503  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
