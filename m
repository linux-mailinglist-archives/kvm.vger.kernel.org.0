Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4253932CC32
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 06:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhCDF4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 00:56:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:45898 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232697AbhCDFz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 00:55:56 -0500
IronPort-SDR: roA9KpM64XqIWxUG6/LIeDZ6BUsde+OHTZTqiWAPbaO5LcNGJS5Z5BsXDLsHXrerx/jGgO3ijd
 zshgJYWJ6Lkg==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="187461323"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="187461323"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 21:55:12 -0800
IronPort-SDR: 7j+YgSbEHJPQSYUh3JIP3ymLBjt2kwzqTMlmOq8+s/g0dJVNDfGz+jsdeSIkfVu4W69RvYGHTd
 zaJ1cM66wGjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="407618061"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 03 Mar 2021 21:55:10 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 0/3] CET fix patches for nested guest
Date:   Thu,  4 Mar 2021 14:07:37 +0800
Message-Id: <20210304060740.11339-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is to fix a few issues found during nested guest
testing on Linux, also including a patch to explictly disable CET
support in nested guest over Hyper-V(s).

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

