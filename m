Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8A71808CF
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 21:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgCJUJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 16:09:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:16157 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbgCJUJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 16:09:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 13:09:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,538,1574150400"; 
   d="scan'208";a="443292786"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 10 Mar 2020 13:09:30 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jBlBy-0002dY-7a; Wed, 11 Mar 2020 04:09:30 +0800
Date:   Wed, 11 Mar 2020 04:08:29 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kbuild-all@lists.01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH 3/6] KVM: nVMX: properly handle errors in
 nested_vmx_handle_enlightened_vmptrld()
Message-ID: <202003110349.xe2VS7PJ%lkp@intel.com>
References: <20200309155216.204752-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309155216.204752-4-vkuznets@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

I love your patch! Perhaps something to improve:

[auto build test WARNING on next-20200306]
[also build test WARNING on v5.6-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Vitaly-Kuznetsov/KVM-nVMX-propperly-handle-enlightened-vmptrld-failure-conditions/20200310-033952
base:    b86a6a241b7c60ca7a6ca4fb3c0d2aedbbf2c1b6
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-174-g094d5a94-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> arch/x86/kvm/vmx/nested.c:1913:29: sparse: sparse: symbol 'nested_vmx_handle_enlightened_vmptrld' was not declared. Should it be static?
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100790 becomes 790)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a000a becomes a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80688 becomes 688)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80608 becomes 608)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80108 becomes 108)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80388 becomes 388)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (20482 becomes 482)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80b88 becomes b88)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80188 becomes 188)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80208 becomes 208)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80288 becomes 288)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a000a becomes a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100010 becomes 10)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100710 becomes 710)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100090 becomes 90)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (20402 becomes 402)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100790 becomes 790)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100490 becomes 490)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100310 becomes 310)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100590 becomes 590)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100610 becomes 610)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100690 becomes 690)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120912 becomes 912)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100590 becomes 590)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (20002 becomes 2)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (20082 becomes 82)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (20102 becomes 102)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (20182 becomes 182)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (20202 becomes 202)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (20282 becomes 282)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (20302 becomes 302)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (20382 becomes 382)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120012 becomes 12)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120092 becomes 92)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120112 becomes 112)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120192 becomes 192)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120212 becomes 212)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120292 becomes 292)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120312 becomes 312)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120392 becomes 392)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120412 becomes 412)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120492 becomes 492)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120592 becomes 592)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120612 becomes 612)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120512 becomes 512)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120692 becomes 692)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120712 becomes 712)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120792 becomes 792)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120812 becomes 812)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120892 becomes 892)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a019a becomes 19a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a021a becomes 21a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a029a becomes 29a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a031a becomes 31a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a039a becomes 39a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a041a becomes 41a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a049a becomes 49a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a051a becomes 51a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a059a becomes 59a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a061a becomes 61a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (120a92 becomes a92)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a089a becomes 89a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a091a becomes 91a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a099a becomes 99a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a028a becomes 28a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a030a becomes 30a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a038a becomes 38a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a040a becomes 40a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a048a becomes 48a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80b08 becomes b08)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100190 becomes 190)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100210 becomes 210)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80708 becomes 708)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80788 becomes 788)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80808 becomes 808)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80888 becomes 888)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100390 becomes 390)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100410 becomes 410)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100510 becomes 510)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a008a becomes 8a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a008a becomes 8a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a048a becomes 48a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (180018 becomes 18)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a010a becomes 10a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a010a becomes 10a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80408 becomes 408)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (80c88 becomes c88)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (180118 becomes 118)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (180198 becomes 198)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a009a becomes 9a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a028a becomes 28a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a030a becomes 30a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a038a becomes 38a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (a040a becomes 40a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100410 becomes 410)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (100510 becomes 510)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1a081a becomes 81a)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: cast truncates bits from constant value (1b009b becomes 9b)
   arch/x86/kvm/vmx/evmcs.h:81:30: sparse: sparse: too many warnings

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
