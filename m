Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA84AADC9
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 23:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389711AbfIEVW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 17:22:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:37535 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389217AbfIEVW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 17:22:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 14:22:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="383038923"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 05 Sep 2019 14:22:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86: Refactor MSR related helpers
Date:   Thu,  5 Sep 2019 14:22:53 -0700
Message-Id: <20190905212255.26549-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor x86's MSR accessors to reduce the amount of boilerplate code
required to get/set an MSR, and consolidate the RDMSR/WRMSR emulation
for VMX and SVM since the code is functionally identical.

Sean Christopherson (2):
  KVM: x86: Refactor up kvm_{g,s}et_msr() to simplify callers
  KVM: x86: Add kvm_emulate_{rd,wr}msr() to consolidate VXM/SVM code

 arch/x86/include/asm/kvm_host.h |   6 +-
 arch/x86/kvm/svm.c              |  34 +-------
 arch/x86/kvm/vmx/nested.c       |  22 ++---
 arch/x86/kvm/vmx/vmx.c          |  33 +-------
 arch/x86/kvm/x86.c              | 138 ++++++++++++++++++++------------
 5 files changed, 100 insertions(+), 133 deletions(-)

-- 
2.22.0

