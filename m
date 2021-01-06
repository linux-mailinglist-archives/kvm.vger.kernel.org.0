Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D238A2EB7EC
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 02:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbhAFB6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 20:58:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:44422 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbhAFB6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 20:58:08 -0500
IronPort-SDR: +qPKt6qdOyhVNWKlJ9mM53CH6uwz9KMNvpukHTMtRzEzpYy22a1fdIDCj0BsxjQQOy3WCeDYIb
 Dq3+wFoLTx7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="195755747"
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="195755747"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:57:27 -0800
IronPort-SDR: dr8ICIPYjYEB4Q5tVyvRdlyE6lGKAPOvzJtnlV+4U5PYeml9GaTYej1WwnfzOFSeyj1OPJ6ccQ
 jjGfOLnlGj9w==
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="421993496"
Received: from zhuoxuan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.29.237])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:57:17 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        mattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH 16/23] KVM: x86: Add SGX feature leaf to reverse CPUID lookup
Date:   Wed,  6 Jan 2021 14:56:46 +1300
Message-Id: <a5b8baa09488894d63a8ed0f8df08cd5a3bfb984.1609890536.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add SGX's sub-features leaf to the reverse CPUID lookup table in
preparation for adding SGX virtualization.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/cpuid.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index f7a6e8f83783..88b7f5db55b9 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -63,6 +63,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_12_EAX]        = {      0x12, 0, CPUID_EAX},
 };
 
 /*
-- 
2.29.2

