Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20C3174286
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 23:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgB1Wwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 17:52:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:64083 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgB1Wwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 17:52:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 14:52:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="439387483"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 28 Feb 2020 14:52:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86/mmu: Fast CR3 switch improvements
Date:   Fri, 28 Feb 2020 14:52:38 -0800
Message-Id: <20200228225240.8646-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two improvements for fast CR3 switch, implemented with nested VMX in mind,
but they should be helpful in general.

Sean Christopherson (2):
  KVM: x86/mmu: Ignore guest CR3 on fast root switch for direct MMU
  KVM: x86/mmu: Reuse the current root if possible for fast switch

 arch/x86/kvm/mmu/mmu.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

-- 
2.24.1

