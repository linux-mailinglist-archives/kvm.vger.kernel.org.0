Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088093F5CD7
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbhHXLJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:09:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:3702 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236678AbhHXLJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:09:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204423817"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="204423817"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 04:08:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="493501615"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 24 Aug 2021 04:08:19 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] KVM: VMX: PT (processor trace) optimizations and fixes
Date:   Tue, 24 Aug 2021 19:07:38 +0800
Message-Id: <20210824110743.531127-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 and 2 are optimizations and cleanup.

Patch 3 - 5 are fixes for PT handling.

Xiaoyao Li (5):
  KVM: VMX: Restore host's MSR_IA32_RTIT_CTL when it's not zero
  KVM: VMX: Use cached vmx->pt_desc.addr_range
  KVM: VMX: RTIT_CTL_BRANCH_EN has no dependency on other CPUID bit
  KVM: VMX: Disallow PT MSRs accessing if PT is not exposed to guest
  KVM: VMX: Check Intel PT related CPUID leaves

 arch/x86/kvm/cpuid.c   | 25 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c | 34 +++++++++++++++++++++-------------
 2 files changed, 46 insertions(+), 13 deletions(-)

-- 
2.27.0

