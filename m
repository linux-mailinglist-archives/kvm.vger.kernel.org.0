Return-Path: <kvm+bounces-27739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5286798B36A
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05DB2283FC7
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F18F1BFDEF;
	Tue,  1 Oct 2024 05:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="HKYM0QUV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865551BBBFC;
	Tue,  1 Oct 2024 05:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758940; cv=none; b=j1ZHHRt0xgFHb7wFsBwTVYt7w+5H1oGi5ALKPCEUWizR8HHjl7sFH3R6aU9OsbbKGJXCyk3eNuQY/MPwa1RZcdFzyeASGyF+/hECmI/xwPjI2Lb/bePIb5ckhFwdMyVND9FwJAyhThLGCgesEgEF88Cajso52qUXIzpoVpkbA28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758940; c=relaxed/simple;
	bh=8NwOtEgXFXbccpyKBCaKNF/+A8akEbIhiKyud8HIOrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRxebXvP6cnVihgALfsdSGJeRtszfTQsJhYS5rioY6JL7xqLC6/JTnGhae7KboQ1cXDanktYqL2jWfTHwEBw1hQWw98p03QFMiyKutfGSpY7uoLMpGtm3k8djiMP23hdGJQK7lBvgkJ/9fJcmfv9B98xTkEHKdlCYQQtn47L6bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=HKYM0QUV; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7j3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:35 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7j3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758896;
	bh=sULUFEzl3r3MZGUBZyiAQe7f5ktOY3K1CWLQ4Ja4sN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKYM0QUV2DyCIgCdDwErfc+MbiGCsL4o0o0sFKYSfZr+Nt/8pIYVdw2OZMm81W4/d
	 AR/vRseg3sBf9FtrTlGviT9AUnjr1IycMu8mWTNFfteP6ue6Csrpd9RWFiQpxyhTh6
	 +PzUlaZv37Jly9EJWgwXwkqbn1fi6j11nbcTj88zG9QLo4zuntXQxoT5lBK9RdksU4
	 TlyukvBkamMdzZNS03P0kLoj6mI7lIhaeMbpmFhlXdDv/5t94IKRNBln8thDS4vNmr
	 mQOTnImZT60ooIGnxwyuIMQ2RAQPBnirBpaUBk7C+ue2N/AkgzY97k1YfMhAmihcRS
	 o+Zjifa1IpVDw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 20/27] KVM: x86: Allow WRMSRNS to be advertised to guests
Date: Mon, 30 Sep 2024 22:01:03 -0700
Message-ID: <20241001050110.3643764-21-xin@zytor.com>
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

Allow WRMSRNS to be advertised to guests.

WRMSRNS behaves exactly like WRMSR with the only difference being
that it is not a serializing instruction by default.  It improves
performance when being used in a hot path, e.g., setting FRED RSP0.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c55d150ece8d..63a78ebf9482 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -700,7 +700,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
 		F(FZRM) | F(FSRS) | F(FSRC) | F(FRED) | F(LKGS) |
-		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
+		F(WRMSRNS) | F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-- 
2.46.2


