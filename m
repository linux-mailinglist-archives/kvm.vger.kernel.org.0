Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958891E7752
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgE2HoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:44:23 -0400
Received: from mga03.intel.com ([134.134.136.65]:51936 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgE2HoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:44:23 -0400
IronPort-SDR: QbrQpwry0wytSmxjbDW4HybwYad/NCebnLhtdBRRaq0Lz+GvWAh3okOCPDxhdiqfiPQdqZGzdG
 wTga6sl3CCQg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 00:44:22 -0700
IronPort-SDR: G8obcFmNPHbFVkBmPQcY6wTi9d68PgeMjhnoNMTkZSkgpOzBGvfQEXibGPK++EiL6eCORSjyBt
 GNZs9mOtj8ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="302754519"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 29 May 2020 00:44:20 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH RESEND] Enable full width counting for KVM: x86/pmu
Date:   Fri, 29 May 2020 15:43:43 +0800
Message-Id: <20200529074347.124619-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

As you said, you will queue the v3 of KVM patch, but it looks like we
are missing that part at the top of the kvm/queue tree.

For your convenience, let me resend v4 so that we can upstream this
feature in the next merged window. Also this patch series includes
patches for qemu and kvm-unit-tests. Please help review.

Previous:
https://lore.kernel.org/kvm/f1c77c79-7ff8-c5f3-e011-9874a4336217@redhat.com/

Like Xu (1):
  KVM: x86/pmu: Support full width counting
  [kvm-unit-tests] x86: pmu: Test full-width counter writes 
  [Qemu-devel] target/i386: define a new MSR based feature
 word - FEAT_PERF_CAPABILITIES

Wei Wang (1):
  KVM: x86/pmu: Tweak kvm_pmu_get_msr to pass 'struct msr_data' in

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/pmu.c              |  4 +-
 arch/x86/kvm/pmu.h              |  4 +-
 arch/x86/kvm/svm/pmu.c          |  7 ++--
 arch/x86/kvm/vmx/capabilities.h | 11 +++++
 arch/x86/kvm/vmx/pmu_intel.c    | 71 +++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c          |  3 ++
 arch/x86/kvm/x86.c              |  6 ++-
 9 files changed, 87 insertions(+), 22 deletions(-)

-- 
2.21.3

