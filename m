Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C25D36674F
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 10:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237735AbhDUIyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 04:54:23 -0400
Received: from mga17.intel.com ([192.55.52.151]:11339 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234557AbhDUIyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 04:54:22 -0400
IronPort-SDR: KLuE2zBevnOd0vrZ+lgrpkmWY8L9Nhdeb10vKQJ5ANwkJMOcPjOojexFbfV5xX1bt5RUBVSc0k
 ywEWfLYiGHYA==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="175771760"
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="175771760"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 01:53:50 -0700
IronPort-SDR: 76cRHvhblxfD+AD9NGgZ4CHGe+v4RejOAL8RT1pyJhZAgRExpygrpN1xsyowCRFfXzd1Avh46W
 vxZPZeAgseUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="455253027"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2021 01:53:48 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v6 0/3] CET fix patches for nested guest
Date:   Wed, 21 Apr 2021 17:05:49 +0800
Message-Id: <20210421090552.10403-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is to fix a few issues found during patch review and
testing on Linux, also including a patch to explictly disable CET support
in nested guest over Hyper-V(s).

change in v6:
- Add check for nested vm_entry_controls without VM_ENTRY_LOAD_CET_STATE set
  to snapshot L1's CET states for L2.


Yang Weijiang (3):
  KVM: nVMX: Sync L2 guest CET states between L1/L2
  KVM: nVMX: Set X86_CR4_CET in cr4_fixed1_bits if CET IBT is enabled
  KVM: nVMX: Add CET entry/exit load bits to evmcs unsupported list

 arch/x86/kvm/cpuid.c      |  1 -
 arch/x86/kvm/vmx/evmcs.c  |  4 ++--
 arch/x86/kvm/vmx/evmcs.h  |  6 ++++--
 arch/x86/kvm/vmx/nested.c | 31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    |  1 +
 arch/x86/kvm/vmx/vmx.h    |  3 +++
 6 files changed, 41 insertions(+), 5 deletions(-)

-- 
2.26.2

