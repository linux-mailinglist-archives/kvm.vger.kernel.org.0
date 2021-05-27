Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4D839253C
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 05:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhE0DLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 23:11:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:30989 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232725AbhE0DLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 23:11:31 -0400
IronPort-SDR: cGMMyJVGIT8aKnvQcbxYVSoCrD4l+YySGBi/PHOKHajtJl9kgwrYBLy7UKByBh5wKqEoxF24iO
 1LoCTs6+2KIA==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="190012571"
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="190012571"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 20:09:57 -0700
IronPort-SDR: K4E8Aidec6aRDQPngzIsQrkDj9rjiYqd0aRLYHYjBD2Zt+jn7/vKYDGhisfS+zCRVxiuKTDyHc
 CV69Fev6gqBQ==
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="477298112"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.11])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 20:09:56 -0700
Date:   Thu, 27 May 2021 11:08:41 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:master 128/130] Warning: Kernel ABI header at
 'tools/arch/x86/include/uapi/asm/kvm.h' differs from latest version at
 'arch/x86/include/uapi/asm/kvm.h':  408> #define
 KVM_X86_QUIRK_TSC_HOST_ACCESS      (1 << 5)
Message-ID: <20210527030841.GX2687475@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
head:   f7d7a93c553f6242b1732b64edc8120c7a061b78
commit: 37a3ce1ca196ed06edcef4fe20bd19a05af7d56c [128/130] KVM: x86: introduce KVM_X86_QUIRK_TSC_HOST_ACCESS
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
cd tools/perf && ./check-headers.sh

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


perfheadercheck warnings: (new ones prefixed by >>)
>> Warning: Kernel ABI header at 'tools/arch/x86/include/uapi/asm/kvm.h' differs from latest version at 'arch/x86/include/uapi/asm/kvm.h':  408> #define KVM_X86_QUIRK_TSC_HOST_ACCESS      (1 << 5)
   Warning: Kernel ABI header at 'tools/arch/x86/include/uapi/asm/kvm.h' differs from latest version at 'arch/x86/include/uapi/asm/kvm.h':  440> 
   Warning: Kernel ABI header at 'tools/arch/x86/include/uapi/asm/kvm.h' differs from latest version at 'arch/x86/include/uapi/asm/kvm.h':  441> 	__u16 pad;

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
