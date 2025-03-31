Return-Path: <kvm+bounces-42237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B63B0A761E3
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 280C97A378E
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574761E9B2D;
	Mon, 31 Mar 2025 08:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LmuvsR6J"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7591D5178;
	Mon, 31 Mar 2025 08:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409462; cv=none; b=HkD246eHWBdXWAl+dZdXvzP6sRofLJ6ufi0bBomNPdOsbLAsWRF04na0oyqvPnHGmcZ0S/RE2grKXZbCCZngX88ypLPMGyXDheq2d14ivMZFKgZDJPCCCOMZsXFwuL6h9MR7KwvMiJ9GVm1PpEHbBTSJ1ynT3UpRNxU5FXEEXbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409462; c=relaxed/simple;
	bh=vi8GjX+r00xIyasO6KKKsl413uOtTqQMjo6S+m99RGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AifxDEr6AHkHHSn17cVpQ2ZD0S0r7Df29hX4QHV2Y3WORwg2e/fLmROZyRuuTILW5cj6RVQQvR8WHF/ibEYJ+OqRRPi9WkLghl3tozpcriN6+/8PKmK2NhgbW6+idxKG+Vpuwd+8DFJZpJZSrajmHWx1ThwPPrPELj9I4gd+Svs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LmuvsR6J; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52V8Mp063171319
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 31 Mar 2025 01:23:10 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52V8Mp063171319
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743409392;
	bh=VWVlHnRAQ/URpBmLS0sboRyyUviRP0Ft54tlbnwKLbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmuvsR6JU0wFg45aoeU1BmH+vTdjhSivLbBzn3nlmIbxQ1T8sqwq82VC74O3yYItX
	 S9sFYj9ZngvuYrNW7sHGljfyh5Gqzhf6VwZ/aRtGB720vFbJ9EDDOtQ9E0xXh2PU0+
	 7FTWRNpDPjfEZWo0yQCIVXmiHAQ6gMo2/Xgl8on4LA7UNyUv6fE4T91P+HIZpg7iX1
	 KkWnpYwKYYQj9Ur2Oo6+kBlMb0LDXwYZNWNFnRncQNe82SMqi3NRZs9EH5QHNmpSzd
	 3/S95C0un5h+YfWI71+I8tTNlrvTtz2S7X75vWWrxF52F7m0pJIvPFhhq4Yw7MnVfu
	 weMHDHw5OzZNA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v1 06/15] x86/msr: Remove MSR write APIs that take the MSR value in two u32 arguments
Date: Mon, 31 Mar 2025 01:22:42 -0700
Message-ID: <20250331082251.3171276-7-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250331082251.3171276-1-xin@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 121597fc5d41..da4f2f6d127f 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -111,9 +111,6 @@ static __always_inline u64 native_rdmsrl(const u32 msr)
 	return __rdmsr(msr);
 }
 
-#define native_wrmsr(msr, low, high)			\
-	__wrmsr((msr), ((u64)(high) << 32) | (low))
-
 #define native_wrmsrl(msr, val)				\
 	__wrmsr((msr), (val))
 
@@ -253,11 +250,6 @@ do {								\
 	(void)((high) = (u32)(__val >> 32));			\
 } while (0)
 
-static inline void wrmsr(u32 msr, u32 low, u32 high)
-{
-	native_write_msr(msr, (u64)high << 32 | low);
-}
-
 #define rdmsrl(msr, val)			\
 	((val) = native_read_msr((msr)))
 
@@ -266,12 +258,6 @@ static inline void wrmsrl(u32 msr, u64 val)
 	native_write_msr(msr, val);
 }
 
-/* wrmsr with exception handling */
-static inline int wrmsr_safe(u32 msr, u32 low, u32 high)
-{
-	return native_write_msr_safe(msr, (u64)high << 32 | low);
-}
-
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr, low, high)				\
 ({								\
@@ -321,7 +307,7 @@ static __always_inline void wrmsrns(u32 msr, u64 val)
  */
 static inline int wrmsrl_safe(u32 msr, u64 val)
 {
-	return wrmsr_safe(msr, (u32)val,  (u32)(val >> 32));
+	return native_write_msr_safe(msr, val);
 }
 
 struct msr __percpu *msrs_alloc(void);
@@ -380,7 +366,7 @@ static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no,
 }
 static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 {
-	return wrmsr_safe(msr_no, l, h);
+	return wrmsrl_safe(msr_no, (u64)h << 32 | l);
 }
 static inline int rdmsrl_safe_on_cpu(unsigned int cpu, u32 msr_no, u64 *q)
 {
-- 
2.49.0


