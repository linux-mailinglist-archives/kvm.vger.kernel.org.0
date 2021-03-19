Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C15341671
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 08:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbhCSHYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 03:24:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:22827 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234249AbhCSHXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 03:23:32 -0400
IronPort-SDR: 7W+h16VupXWxQZrOFZ50AX76HmkgjEBpOFtylr3zV/UdCCWcd5y7ePoernpNz9hFZzeECPSVsr
 j1cGCuEDfckg==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="274910898"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="274910898"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:23:31 -0700
IronPort-SDR: dpGseIrZN9ZeYAIOrZCk61AAdyBIAoMPDUOlEWv8cE4zhT1qdMNgzVmrorRs7KvK92+RxNTqxB
 Sx7TN5viHMdA==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409490"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:23:28 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 10/25] x86/sgx: Add SGX2 ENCLS leaf definitions (EAUG, EMODPR and EMODT)
Date:   Fri, 19 Mar 2021 20:23:05 +1300
Message-Id: <5f0970c251ebcc6d5add132f0d750cc753b7060f.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Define the ENCLS leafs that are available with SGX2, also referred to as
Enclave Dynamic Memory Management (EDMM).  The leafs will be used by KVM
to conditionally expose SGX2 capabilities to guests.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/sgx.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 34f44238d1d1..3b025afec0a7 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -40,6 +40,9 @@ enum sgx_encls_function {
 	EPA	= 0x0A,
 	EWB	= 0x0B,
 	ETRACK	= 0x0C,
+	EAUG	= 0x0D,
+	EMODPR	= 0x0E,
+	EMODT	= 0x0F,
 };
 
 /**
-- 
2.30.2

