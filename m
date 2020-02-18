Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465A41636BE
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgBRXDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:03:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:57150 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgBRXDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:03:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:03:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="239504569"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 18 Feb 2020 15:03:10 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: x86: Minor emulator cleanup
Date:   Tue, 18 Feb 2020 15:03:07 -0800
Message-Id: <20200218230310.29410-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Three small patches to move emulator specific variables from 'struct
kvm_vcpu_arch' to 'struct x86_emulate_ctxt'.

v2:
  - Rebase to kvm/queue, 2c2787938512 ("KVM: selftests: Stop ...")

Sean Christopherson (3):
  KVM: x86: Add EMULTYPE_PF when emulation is triggered by a page fault
  KVM: x86: Move gpa_val and gpa_available into the emulator context
  KVM: x86: Move #PF retry tracking variables into emulation context

 arch/x86/include/asm/kvm_emulate.h |  8 ++++++
 arch/x86/include/asm/kvm_host.h    | 19 ++++++-------
 arch/x86/kvm/mmu/mmu.c             | 10 ++-----
 arch/x86/kvm/x86.c                 | 45 +++++++++++++++++++-----------
 4 files changed, 48 insertions(+), 34 deletions(-)

-- 
2.24.1

