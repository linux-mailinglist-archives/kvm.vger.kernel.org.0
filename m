Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDF21B2061
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 09:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgDUHxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 03:53:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:22871 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgDUHxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 03:53:30 -0400
IronPort-SDR: V87Zx9FlJOhzDrcpyCdZ/XRcktCvUykjxKvNZD+D3xfof+M85kVcSULd+yAiveu/5CD1IEdvAD
 jtFu/mqkkhSA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 00:53:29 -0700
IronPort-SDR: Vj82jaY9B1ev7KooQq1BLw9M55NkWk53ByTlltJPDwJZeqauwGQmYffo17X2xEd3cNMxXcu4+0
 8CFCpRWpiQyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,409,1580803200"; 
   d="scan'208";a="245611198"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 21 Apr 2020 00:53:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v3 0/2] KVM: VMX: Unionize vcpu_vmx.exit_reason
Date:   Tue, 21 Apr 2020 00:53:26 -0700
Message-Id: <20200421075328.14458-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor fixup patch for a mishandled conflict between the vmcs.INTR_INFO
caching series and the union series, plus the actual unionization patch
rebased onto kvm/queue, commit 604e8bba0dc5 ("KVM: Remove redundant ...").

Sean Christopherson (2):
  KVM: nVMX: Drop a redundant call to vmx_get_intr_info()
  KVM: VMX: Convert vcpu_vmx.exit_reason to a union

 arch/x86/kvm/vmx/nested.c | 39 ++++++++++++++---------
 arch/x86/kvm/vmx/vmx.c    | 65 ++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.h    | 25 ++++++++++++++-
 3 files changed, 83 insertions(+), 46 deletions(-)

-- 
2.26.0

