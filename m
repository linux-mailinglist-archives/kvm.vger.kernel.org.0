Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B6B119F52
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 00:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfLJXYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 18:24:35 -0500
Received: from mga17.intel.com ([192.55.52.151]:23344 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfLJXYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 18:24:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 15:24:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="210583762"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 10 Dec 2019 15:24:34 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH 0/2] KVM: VMX: PT (RTIT) bug fix and cleanup
Date:   Tue, 10 Dec 2019 15:24:31 -0800
Message-Id: <20191210232433.4071-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a missing non-canonical check on writes to the RTIT address MSRs
and tack on a cleanup patch.

** ALL PATCHES ARE COMPLETELY UNTESTED **

Untested due to lack of hardware.

Sean Christopherson (2):
  KVM: VMX: Add non-canonical check on writes to RTIT address MSRs
  KVM: VMX: Add helper to consolidate up PT/RTIT WRMSR fault logic

 arch/x86/kvm/vmx/vmx.c | 57 ++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 24 deletions(-)

-- 
2.24.0

