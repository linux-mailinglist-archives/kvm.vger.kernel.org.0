Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C813BA558
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhGBWHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:07:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:51166 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhGBWHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951880"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951880"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:19 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814667"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:19 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH v2 01/69] KVM: TDX: introduce config for KVM TDX support
Date:   Fri,  2 Jul 2021 15:04:07 -0700
Message-Id: <2f265006e5cee03a5a48448c51c3632391e58ec7.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add new config KVM_INTEL_TDX for KVM TDX support.  This patch introduce
a config only.  Later patch will implement feature depends on it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f6b93a35ce14..66622901bf7d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -96,6 +96,17 @@ config X86_SGX_KVM
 
 	  If unsure, say N.
 
+config KVM_INTEL_TDX
+	bool "Trusted Domain eXtensions(TDX) Host support"
+	depends on KVM_INTEL && X86_64
+	select FW_LOADER
+
+	help
+	  Extends KVM on Intel processors to support Trusted Domain Extensions.
+	  Intel Trust Domain eXtensions(TDX) is an architecture based on CPU
+	  instructions and TDX module to deploy hardware-isolated virtual
+	  machines(VMs) which is called Trust Domains(TDs).
+
 config KVM_AMD
 	tristate "KVM for AMD processors support"
 	depends on KVM
-- 
2.25.1

