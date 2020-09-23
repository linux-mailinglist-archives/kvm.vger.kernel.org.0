Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AFF275D93
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgIWQgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:36:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:7062 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIWQgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 12:36:31 -0400
IronPort-SDR: L8DtY5LCNaOPNeUnKpsF0dBrJNloeWGZisLM80oHK3UriqIeRZFLNZVClMpCBVqJ41mX41/Tv0
 7Jip7UOipKjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="140962211"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="140962211"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:36:30 -0700
IronPort-SDR: kIzfA+tB1ndtmTmCzFbm3LjYtRwl5niqcSqxJ8ZH/n/LdAc/i3dDBSmue/9GW4gQIacswOI26w
 EMWcaBOIIUAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="454981819"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga004.jf.intel.com with ESMTP; 23 Sep 2020 09:36:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: VMX: Clean up RTIT MAXPHYADDR usage
Date:   Wed, 23 Sep 2020 09:36:26 -0700
Message-Id: <20200923163629.20168-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop using cpuid_query_maxphyaddr() for a random RTIT MSR check and
unexport said function to discourage future use.

v2:
  - Rebased to kvm/queue, commit e1ba1a15af73 ("KVM: SVM: Enable INVPCID
    feature on AMD").

Sean Christopherson (3):
  KVM: VMX: Use precomputed MAXPHYADDR for RTIT base MSR check
  KVM: VMX: Replace MSR_IA32_RTIT_OUTPUT_BASE_MASK with helper function
  KVM: x86: Unexport cpuid_query_maxphyaddr()

 arch/x86/kvm/cpuid.c   |  1 -
 arch/x86/kvm/vmx/vmx.c | 11 +++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.28.0

