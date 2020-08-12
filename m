Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FA0242F36
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 21:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgHLT2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 15:28:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:34390 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgHLT2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 15:28:00 -0400
IronPort-SDR: zoXD7keQ3URsOwAfjv5Ebb2pKraph742aIu/rKwzfAAijEfiOrTnDhyaXmTO73XrvU6gBHk3P/
 L9k0Grsnqx5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9711"; a="141673016"
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="141673016"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 12:27:59 -0700
IronPort-SDR: /2rCWyevFd4pRorsikkBmd6R7lSJUGswtFRds8dYx9r1HVg3Y5eUzp0wDhDYBrEjwnyXchV502
 h9TMyZTPB0eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="327304449"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga002.fm.intel.com with ESMTP; 12 Aug 2020 12:27:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: [PATCH v2 0/2] KVM: x86/mmu: Zap orphaned kids for nested TDP MMU
Date:   Wed, 12 Aug 2020 12:27:56 -0700
Message-Id: <20200812192758.25587-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As promised, albeit a few days late.

Ben, I kept your performance numbers even though it this version has
non-trivial differences relative to what you tested.  I assume we'll need
a v3 anyways if this doesn't provide the advertised performance benefits.

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

