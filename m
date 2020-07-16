Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F3D221B05
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgGPDoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:44:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:54949 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgGPDoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:44:11 -0400
IronPort-SDR: rrdjT8Kh/Aqb5wHcOYeYfj7aCSZMGB9dkkEbUef91a+mI/Z3NDDexkuude93/mlMxsGTibSQKt
 xYAUoy7eHsLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="150699761"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="150699761"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:44:10 -0700
IronPort-SDR: cAuAFNKXBGmV5pOIWhocUCC1JqwEtI7ncH5HpTHwW4pvIncSzWWBL6s3nlNM4eeLeXygHnUdZ2
 PuMonLEU/veQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="282314257"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 15 Jul 2020 20:44:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: VMX: Clean up RTIT MAXPHYADDR usage
Date:   Wed, 15 Jul 2020 20:44:05 -0700
Message-Id: <20200716034408.6342-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop using cpuid_query_maxphyaddr() for a random RTIT MSR check and
unexport said function to discourage future use.

Sean Christopherson (3):
  KVM: VMX: Use precomputed MAXPHYADDR for RTIT base MSR check
  KVM: VMX: Replace MSR_IA32_RTIT_OUTPUT_BASE_MASK with helper function
  KVM: x86: Unexport cpuid_query_maxphyaddr()

 arch/x86/kvm/cpuid.c   |  1 -
 arch/x86/kvm/vmx/vmx.c | 11 +++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.26.0

