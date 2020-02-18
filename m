Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1645163762
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgBRXkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:40:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:39205 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgBRXkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:40:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:40:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="436033027"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 18 Feb 2020 15:40:17 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86: kvm_init_msr_list() cleanup
Date:   Tue, 18 Feb 2020 15:40:09 -0800
Message-Id: <20200218234012.7110-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Three cleanup patches in kvm_init_msr_list() and related code.

Note, these were previously posted as the first three patches of larger
series[*] that mutated into an entirely different beast, which is how they
have been reviewed by Vitaly despite being v1.

[*] https://patchwork.kernel.org/cover/11357065/

Sean Christopherson (3):
  KVM: x86: Remove superfluous brackets from case statement
  KVM: x86: Take an unsigned 32-bit int for has_emulated_msr()'s index
  KVM: x86: Snapshot MSR index in a local variable when processing lists

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              | 26 +++++++++++++++-----------
 4 files changed, 18 insertions(+), 14 deletions(-)

-- 
2.24.1

