Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB6C2763A9
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 00:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgIWWOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 18:14:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:60899 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgIWWOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 18:14:07 -0400
IronPort-SDR: c3liBWrM2rqCvsng6CHEU/FDF+s31HoPe1zpeIBl374ZzOSfdjs9MdiIjaQIrE8Y0tQvZNj7IK
 lc9ko7XUFu5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158382290"
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="158382290"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 15:14:07 -0700
IronPort-SDR: t2lbPFx3mpDlDBLib5ZflI7Sf5jj87656N7h2EACIRLu1xRytYiaCtCjwFTqkLB/C7eMErVZpZ
 snvTKTwPWpdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="335651271"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga004.fm.intel.com with ESMTP; 23 Sep 2020 15:14:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: [PATCH v3 0/2] KVM: x86/mmu: Zap orphaned kids for nested TDP MMU
Date:   Wed, 23 Sep 2020 15:14:04 -0700
Message-Id: <20200923221406.16297-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refreshed version of Ben's patch to zap orphaned MMU shadow pages so that
they don't turn into zombies.

v3:
  - Rebased to kvm/queue, commit e1ba1a15af73 ("KVM: SVM: Enable INVPCID
    feature on AMD").

Ben Gardon (1):
  KVM: x86/MMU: Recursively zap nested TDP SPs when zapping last/only
    parent

Sean Christopherson (1):
  KVM: x86/mmu: Move flush logic from mmu_page_zap_pte() to
    FNAME(invlpg)

 arch/x86/kvm/mmu/mmu.c         | 38 ++++++++++++++++++++++------------
 arch/x86/kvm/mmu/paging_tmpl.h |  7 +++++--
 2 files changed, 30 insertions(+), 15 deletions(-)

-- 
2.28.0

