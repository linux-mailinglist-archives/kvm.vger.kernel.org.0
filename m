Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA96533ABF8
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 08:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhCOHGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 03:06:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:59702 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhCOHGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 03:06:24 -0400
IronPort-SDR: brwbhs3xYhwkJto0d0epINfTKjnl8n+9S6isjfOgp1EiE46N8uqqCvmDJxBGYPVuTZiA8aAERU
 UJaGeqHGRR9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="176640924"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="176640924"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:06:23 -0700
IronPort-SDR: HrLe6NuUVA8LsglYMlLOCgJ8rWa3BO3lB1Mwj7SC4gUtP8p1qr+yCvp3fnIYDhc4qZVL9JOC6B
 DKrbYMkyNIlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="604749519"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2021 00:06:20 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 0/3] CET fix patches for nested guest
Date:   Mon, 15 Mar 2021 15:18:38 +0800
Message-Id: <20210315071841.7045-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is to fix a few issues found during patch review and
testing on Linux, also including a patch to explictly disable CET support
in nested guest over Hyper-V(s).

change in v4:
- Added guest CET cpuid check before sync vmcs02 CET state to vmcs12.
- Opportunistically added similar fix for MPX.

Yang Weijiang (3):
  KVM: nVMX: Sync L2 guest CET states between L1/L2
  KVM: nVMX: Set X86_CR4_CET in cr4_fixed1_bits if CET IBT is enabled
  KVM: nVMX: Add CET entry/exit load bits to evmcs unsupported list

 arch/x86/kvm/cpuid.c      |  1 -
 arch/x86/kvm/vmx/evmcs.c  |  4 ++--
 arch/x86/kvm/vmx/evmcs.h  |  6 ++++--
 arch/x86/kvm/vmx/nested.c | 35 +++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c    |  1 +
 arch/x86/kvm/vmx/vmx.h    |  3 +++
 6 files changed, 43 insertions(+), 7 deletions(-)

-- 
2.26.2

