Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF42D35957F
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 08:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhDIGcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 02:32:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:32002 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233251AbhDIGcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 02:32:14 -0400
IronPort-SDR: K9hmgSiJG3UCMeuVNaj38IMUFkf0fP5zVObG2vLppQ4yMgaUNbTWt8LuuAxXAZmuGu38Uq7Jr3
 2f/KbIgkAmHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="173178630"
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="173178630"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 23:31:26 -0700
IronPort-SDR: fAkrdpAmdwbB1Sx8zIqGUC1wNNQz+1eg6lMSCb+qUp9KJDGD3opmVjFV9QPEfv5S4JjLk+QNEU
 bTIBTGdOUy+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="380538699"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by orsmga003.jf.intel.com with ESMTP; 08 Apr 2021 23:31:24 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 0/3] CET fix patches for nested guest
Date:   Fri,  9 Apr 2021 14:43:42 +0800
Message-Id: <20210409064345.31497-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is to fix a few issues found during patch review and
testing on Linux, also including a patch to explictly disable CET support
in nested guest over Hyper-V(s).

change in v5:
- Changed condition to snapshot CET state to vmcs01 per Sean's feedback.
- Remove mixed fix code for MPX.


Yang Weijiang (3):
  KVM: nVMX: Sync L2 guest CET states between L1/L2
  KVM: nVMX: Set X86_CR4_CET in cr4_fixed1_bits if CET IBT is enabled
  KVM: nVMX: Add CET entry/exit load bits to evmcs unsupported list

 arch/x86/kvm/cpuid.c      |  1 -
 arch/x86/kvm/vmx/evmcs.c  |  4 ++--
 arch/x86/kvm/vmx/evmcs.h  |  6 ++++--
 arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    |  1 +
 arch/x86/kvm/vmx/vmx.h    |  3 +++
 6 files changed, 40 insertions(+), 5 deletions(-)

-- 
2.26.2

