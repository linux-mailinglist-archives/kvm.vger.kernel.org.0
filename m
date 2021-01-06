Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BE02EB7E4
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 02:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbhAFB5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 20:57:02 -0500
Received: from mga07.intel.com ([134.134.136.100]:27771 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbhAFB5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 20:57:01 -0500
IronPort-SDR: PA3rppWAPxE31i+vjaFm0myfj+Qub0ujfVjzkALcKZp020QIQIaAQvBVrinzsevT2eMzYYeE5t
 Tf9ovaSvmebw==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="241292475"
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="241292475"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:56:21 -0800
IronPort-SDR: ysDxmXO2WnzlgYVgnQ/8G/B1ho+iaJE3snBDx/qPiEJ0BiEEP5EPP/m/Kf9e64DS9suSs9dYbj
 OI4cvzZEfO6g==
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="421993298"
Received: from zhuoxuan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.29.237])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:56:17 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH 08/23] x86/sgx: Add SGX2 ENCLS leaf definitions (EAUG, EMODPR and EMODT)
Date:   Wed,  6 Jan 2021 14:56:02 +1300
Message-Id: <e16e6d136dea272db6873986dd5fd754c54ad8a9.1609890536.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
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
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/sgx_arch.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index 38ef7ce3d3c7..2323ded379d6 100644
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

