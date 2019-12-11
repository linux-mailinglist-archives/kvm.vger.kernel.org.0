Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5337111BAD4
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 18:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfLKR6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 12:58:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:29189 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730880AbfLKR6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 12:58:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 09:58:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,302,1571727600"; 
   d="scan'208";a="203645149"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 11 Dec 2019 09:58:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86: X86_FEATURE bit() cleanup
Date:   Wed, 11 Dec 2019 09:58:20 -0800
Message-Id: <20191211175822.1925-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small series to add build-time protections on reverse CPUID lookup (and
other usages of bit()), and to rename the misleading-generic bit() helper
to something that better conveys its purpose.

Sean Christopherson (2):
  KVM: x86: Add build-time assertion on usage of bit()
  KVM: x86: Refactor and rename bit() to feature_bit() macro

 arch/x86/kvm/cpuid.c   |  2 +-
 arch/x86/kvm/cpuid.h   |  4 ++--
 arch/x86/kvm/emulate.c |  8 +++-----
 arch/x86/kvm/svm.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c | 42 +++++++++++++++++++++---------------------
 arch/x86/kvm/x86.h     | 24 ++++++++++++++++++++++--
 6 files changed, 51 insertions(+), 33 deletions(-)

-- 
2.24.0

