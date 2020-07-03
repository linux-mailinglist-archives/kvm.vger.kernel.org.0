Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF59021328B
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 06:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgGCEEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 00:04:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:9178 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgGCEEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 00:04:24 -0400
IronPort-SDR: T0PMF1y7rpgIPB8g5nCfQQhdUGvPovYA8IFm4OjJcqbZISUENd8Zf2lypln2etoSyTDAJgUjs9
 HaOXllDbLKmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="208604063"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="208604063"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 21:04:23 -0700
IronPort-SDR: fnx8n/5dfBVrfbLT24PWc42gDpm6Xk9Uw46kztNqKbJ6gFnmskAg2zxmCEqSASO0pUJAv/fmSi
 Wbsn0b/sJxpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="387520208"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 02 Jul 2020 21:04:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: VMX: CR0/CR4 guest/host masks cleanup
Date:   Thu,  2 Jul 2020 21:04:20 -0700
Message-Id: <20200703040422.31536-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a bug where CR4.TSD isn't correctly marked as being possibly owned by
the guest in the common x86 macro, then clean up the mess that made the
bug possible by throwing away VMX's mix of duplicate code and open coded
tweaks.  The lack of a define for the guest-owned CR0 bit has bugged me
for a long time, but adding another define always seemed ridiculous.

Sean Christopherson (2):
  KVM: x86: Mark CR4.TSD as being possibly owned by the guest
  KVM: VMX: Use KVM_POSSIBLE_CR*_GUEST_BITS to initialize guest/host
    masks

 arch/x86/kvm/kvm_cache_regs.h |  2 +-
 arch/x86/kvm/vmx/nested.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c        | 13 +++++--------
 3 files changed, 8 insertions(+), 11 deletions(-)

-- 
2.26.0

