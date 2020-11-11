Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5482E2AE8F1
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 07:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgKKGb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 01:31:27 -0500
Received: from mga17.intel.com ([192.55.52.151]:43536 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgKKGb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 01:31:26 -0500
IronPort-SDR: UYNH1Sofp/fadFCUhHXR3Az/xoiNxZj6JYiMe35rf/vX08CWEHMOIJ0r1yfob2NwWJShw/4DGT
 WhCa+xnv6OMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="149951492"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="149951492"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 22:31:25 -0800
IronPort-SDR: R095N3SAab1vQKKPDMgSJRzioTZQanof05ufeePtVKJRu1W+vHAiNc6IN+nYtbs5J2L5ZcJcUq
 Vnx6t3emNE0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="323167572"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.156])
  by orsmga003.jf.intel.com with ESMTP; 10 Nov 2020 22:31:23 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 0/3] Get supported_xss ready for XSS dependent
Date:   Wed, 11 Nov 2020 14:41:48 +0800
Message-Id: <20201111064151.1090-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although supported_xss was added long time ago, yet it doesn't get ready for
XSS dependent new features usage, e.g., when guest update XSS MSRs, it's
necessary to update guest CPUID to reflect the correct info. So post this
patchset to get things ready, or at least as a hint to maintainers that
there're still a few things left before support feature bits in XSS.

Also added a few helpers to facilitate new features development. This part
of code originates from CET KVM patchset, with more and more new features
dependent on this part, post this patchset ahead of them.

Sean Christopherson (2):
  KVM: x86: Add helpers for {set|clear} bits in supported_xss
  KVM: x86: Load guest fpu state when accessing MSRs managed by XSAVES

Yang Weijiang (1):
  KVM: x86: Refresh CPUID when guest modifies MSR_IA32_XSS

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 21 ++++++++++++--
 arch/x86/kvm/vmx/vmx.c          | 22 +++++++++++++++
 arch/x86/kvm/x86.c              | 50 +++++++++++++++++++++++++++++++--
 4 files changed, 88 insertions(+), 6 deletions(-)

-- 
2.17.2

