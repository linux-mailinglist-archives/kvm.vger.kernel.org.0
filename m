Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294531AC001
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 13:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506594AbgDPLqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 07:46:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:46605 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505063AbgDPKd0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 06:33:26 -0400
IronPort-SDR: qj6fw7nsAkLFIw6CQ46hLHVUHke4cwaqpbARTWcPrgHQ6cS4Qooqki5jwpsd1rcgSuQBFvZ6s/
 MP63fBKVMxBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 03:33:25 -0700
IronPort-SDR: vhzr2qoTpxKTwtiF8Qj7zuovZ5//O+5bjszfwZb2LMA9daDK6L8WDAMBSXR0wCXQTDZbkWfGnP
 LCfwj8KVclYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,390,1580803200"; 
   d="scan'208";a="277947885"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.132])
  by fmsmga004.fm.intel.com with ESMTP; 16 Apr 2020 03:33:24 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH 0/3] kvm: x86: Cleanup and optimazation of switch_db_regs
Date:   Thu, 16 Apr 2020 18:15:06 +0800
Message-Id: <20200416101509.73526-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Through reading debug related codes in kvm/x86, I found the flags of
switch_db_regs is a little confusing (at least for me) and there is
something to improve. So this patchset comes. But it only go througg
compilation.

Xiaoyao Li (3):
  kvm: x86: Rename KVM_DEBUGREG_RELOAD to KVM_DEBUGREG_NEED_RELOAD
  kvm: x86: Use KVM_DEBUGREG_NEED_RELOAD instead of
    KVM_DEBUGREG_BP_ENABLED
  kvm: x86: skip DRn reload if previous VM exit is DR access VM exit

 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/svm/svm.c          |  8 +++++---
 arch/x86/kvm/vmx/vmx.c          |  8 +++++---
 arch/x86/kvm/x86.c              | 12 ++++++------
 4 files changed, 17 insertions(+), 14 deletions(-)

-- 
2.20.1

