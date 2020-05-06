Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF491C7E40
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 01:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgEFX6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 19:58:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:27430 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbgEFX6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 19:58:52 -0400
IronPort-SDR: GhQ3/yPORJAfzUsvuUi0R4xbH4/167TrP0iWAtknrvykMlAQqCQ14DG+I4aR94LTQakEg/WAOf
 ghBqplo0rmbA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 16:58:51 -0700
IronPort-SDR: r3TEfEBlGCQDnppSb0/B3ZOpwYIpUseXQsClVHbOqACJtHmEpNtf+cELG+aLZ8rdm9Hm3rYnpm
 Q4VUnL8pFlAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,361,1583222400"; 
   d="scan'208";a="435086063"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 06 May 2020 16:58:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: nVMX: Skip IPBP on nested VMCS switch
Date:   Wed,  6 May 2020 16:58:48 -0700
Message-Id: <20200506235850.22600-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Or as Jim would say, "Really skip IPBP on nested VMCS switch" :-D

Patch 1 is the delta between kvm/queue and v3 of the original patch[*],
i.e. I just cherry-picked v3 and fixed the conflicts.

Patch 2 applies the "no IPBP" logic to copy_vmcs02_to_vmcs12_rare().

Feel free to sqaush both of these to commit 7407a52f23732 ("KVM: nVMX:
Skip IBPB when switching between vmcs01 and vmcs02") if you so desire.

[*] https://lkml.kernel.org/r/20200505044644.16563-1-sean.j.christopherson@intel.com

Sean Christopherson (2):
  KVM: nVMX: Refactor IBPB handling on VMCS switch to genericize code
  KVM: nVMX: Skip IPBP when switching between vmcs01 and vmcs02, redux

 arch/x86/kvm/vmx/nested.c | 13 +++----------
 arch/x86/kvm/vmx/vmx.c    | 19 ++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h    |  4 ++--
 3 files changed, 19 insertions(+), 17 deletions(-)

-- 
2.26.0

