Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6CA137B6B
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2020 05:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgAKEuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 23:50:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:56137 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728328AbgAKEuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 23:50:17 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 20:50:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,419,1571727600"; 
   d="gz'50?scan'50,208,50";a="422322548"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 10 Jan 2020 20:50:13 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iq8iz-000Hpi-5b; Sat, 11 Jan 2020 12:50:13 +0800
Date:   Sat, 11 Jan 2020 12:49:28 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <202001111214.kG4GCrkU%lkp@intel.com>
References: <20200109145729.32898-13-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mukdvohhk2vzuw52"
Content-Disposition: inline
In-Reply-To: <20200109145729.32898-13-peterx@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--mukdvohhk2vzuw52
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Peter,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/linux-next]
[also build test ERROR on next-20200110]
[cannot apply to kvmarm/next vfio/next v5.5-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Peter-Xu/KVM-Dirty-ring-interface/20200110-152053
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
config: s390-alldefconfig (attached as .config)
compiler: s390-linux-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=s390 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/s390/../../virt/kvm/kvm_main.o: In function `mark_page_dirty_in_slot':
>> kvm_main.c:(.text+0x4d6): undefined reference to `kvm_dirty_ring_get'
>> kvm_main.c:(.text+0x4f0): undefined reference to `kvm_dirty_ring_push'
   arch/s390/../../virt/kvm/kvm_main.o: In function `kvm_vcpu_init':
>> kvm_main.c:(.text+0x1fe6): undefined reference to `kvm_dirty_ring_alloc'
>> kvm_main.c:(.text+0x204c): undefined reference to `kvm_dirty_ring_free'
   arch/s390/../../virt/kvm/kvm_main.o: In function `kvm_vcpu_uninit':
   kvm_main.c:(.text+0x20c0): undefined reference to `kvm_dirty_ring_free'
   arch/s390/../../virt/kvm/kvm_main.o: In function `kvm_reset_dirty_gfn':
>> kvm_main.c:(.text+0x6650): undefined reference to `kvm_arch_mmu_enable_log_dirty_pt_masked'
   arch/s390/../../virt/kvm/kvm_main.o: In function `kvm_vm_ioctl':
>> kvm_main.c:(.text+0x6b58): undefined reference to `kvm_dirty_ring_reset'

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--mukdvohhk2vzuw52
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--mukdvohhk2vzuw52--
