Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02303042A9
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 16:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391263AbhAZPcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 10:32:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:12748 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391221AbhAZJcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 04:32:07 -0500
IronPort-SDR: NUot/P0oVL9jqwHd3d66FhK77Kib2xpp/FT1PeHHgqfvW/7CUvDCubZZXAjqLTipdbBtl8bpRG
 RpHth6Oc8nmg==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="179954913"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="179954913"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:31:32 -0800
IronPort-SDR: c4yoz8Q0Aqx/T5DP6klEnFdOKRTNU8qC0+o5PWwXfLnQQtF0sOGEhhn5Dyn6e6MZvWn8ydPY5G
 ySwtb4tpBOdw==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="577747705"
Received: from ravivisw-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.124.51])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:31:28 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 11/27] x86/sgx: Add SGX2 ENCLS leaf definitions (EAUG, EMODPR and EMODT)
Date:   Tue, 26 Jan 2021 22:31:03 +1300
Message-Id: <707c6261d43de89fceb2d22317799067b922ea79.1611634586.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611634586.git.kai.huang@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
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
 arch/x86/include/asm/sgx_arch.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index 3dbe7aacf552..756c8dacc52a 100644
--- a/arch/x86/include/asm/sgx_arch.h
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -35,6 +35,9 @@ enum sgx_encls_function {
 	EPA	= 0x0A,
 	EWB	= 0x0B,
 	ETRACK	= 0x0C,
+	EAUG	= 0x0D,
+	EMODPR	= 0x0E,
+	EMODT	= 0x0F,
 };
 
 /**
-- 
2.29.2

