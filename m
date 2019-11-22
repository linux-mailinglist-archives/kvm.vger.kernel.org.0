Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF89E107AFB
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfKVW6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:58:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:15520 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfKVW6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:58:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:58:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="382218999"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 22 Nov 2019 14:58:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86: Minor emulator cleanup
Date:   Fri, 22 Nov 2019 14:58:29 -0800
Message-Id: <20191122225832.26684-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Three small patches to move emulator specific variables from 'struct
kvm_vcpu_arch' to 'struct x86_emulate_ctxt'.

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
2.24.0

