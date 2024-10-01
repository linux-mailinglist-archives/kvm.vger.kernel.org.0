Return-Path: <kvm+bounces-27721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB2898B348
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2420B283FCA
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C791BD031;
	Tue,  1 Oct 2024 05:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="W7Ui37rY"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898A4194C6F;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758938; cv=none; b=Zp4ER3tUfj1ZBNJvYgK56AFx65O72pWgWHzXLEeva8SYL0Mtk4KBJ7vu6K51vMyGSb5ZinB/2bcAFtO1yQ0NC2hDEsLokbp8me3qwPx5xLwrYkjj0Wv9hIKcpKiC70hUG7FN82tpeB02hINMagMQ5E20yX5X7ZwhmWp1Z9ZmigE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758938; c=relaxed/simple;
	bh=YIIbLf4qdG7AU+f5qBzxFWcJMGnrhQrGSC4hpt3H4E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5JeLYAHwXJiFKDCbEFdAAXEpV/asPaOIFnJXNcTXnfTGUf4MOBypAPWRrjm+R91BLCBwuIVFm3zKZb0wE1mAUuxqN98mK+kQe2gP9GpFB/thBpk1AVWIHt8v6AB6/x9KirKgrjO1Rjd+dhjKIqcYl9jTWZcgCFR/G94cu/cCHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=W7Ui37rY; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7U3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:20 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7U3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758881;
	bh=wUrzrWGpTqCY4Lj4JpPdteFqkI+gH/O0UwIUfMWFr9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7Ui37rYLUI+8sRBFZ4gyb6YVm0DShi4xBJoWopYLmg82DLitPnqZ4HTJVVR760m0
	 ZsNXq/zi5JujBJGzA6SYKNHfbc3H90IsOX8EOMMAheWdMvW4xh/OknM3qcNnpe/ihv
	 AEz/sSUUywZuRPFcod3ivCWk0z0EXwX+KJRj7MqkMAxKtPeX4ltzIhBZakAo1Qa8Fw
	 oOp7wElAcvva6meIUAQnfybONAmd9pwj0JfPf3cZBBaeDpmd1hZZ2OfCutsev3ALmH
	 XaFpjz2Mq1XVCD928SluF4InwrHrfFh+WstkGkwnqxaJmXNzSWMgTL0jhEILBRTuf6
	 0sfwPLHvEymqw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 05/27] KVM: VMX: Disable FRED if FRED consistency checks fail
Date: Mon, 30 Sep 2024 22:00:48 -0700
Message-ID: <20241001050110.3643764-6-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Do not virtualize FRED if FRED consistency checks fail.

Either on broken hardware, or when run KVM on top of another hypervisor
before the underlying hypervisor implements nested FRED correctly.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index e8f3ad0f79ee..2962a3bb9747 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -400,6 +400,13 @@ static inline bool vmx_pebs_supported(void)
 	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
 }
 
+static inline bool cpu_has_vmx_fred(void)
+{
+	/* No need to check FRED VM exit controls. */
+	return boot_cpu_has(X86_FEATURE_FRED) &&
+		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_FRED);
+}
+
 static inline bool cpu_has_notify_vmexit(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index efd2ad397ad2..9b4c30db911f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8001,6 +8001,9 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
 	}
 
+	if (!cpu_has_vmx_fred())
+		kvm_cpu_cap_clear(X86_FEATURE_FRED);
+
 	if (!enable_pmu)
 		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
 	kvm_caps.supported_perf_cap = vmx_get_perf_capabilities();
-- 
2.46.2


