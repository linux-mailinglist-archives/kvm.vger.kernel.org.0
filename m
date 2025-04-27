Return-Path: <kvm+bounces-44504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C55A9E1DF
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 11:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72E611A84F1B
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363CF2566C4;
	Sun, 27 Apr 2025 09:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="bC4rbd7N"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C622F24E00D;
	Sun, 27 Apr 2025 09:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745745695; cv=none; b=KpHW05+CngFuwUDsJf/O3HxQrnrw6uLGoQVZt+CpRSiADyGQP2Su6GI4ULUp0hqJFljn/m7ZWJKBycL3F3pu/SeBdfHvic2dla6shWdy3KmCWvqPfBXfj73peuWi6NESm0cOkMa8r/MbZa9Ho8JZqZhwBSiNrLaVOXhwzDc7QVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745745695; c=relaxed/simple;
	bh=EsriCpsKs4C13ZOg7qJoihPgi56Qt4OvRfoo0l4T2W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ds2cyb8W1l+jY9eEcmaOZ+YrydPqTPoYN6aZD58DDHvEmlrNEXyHhL79hxntrd+5wl1Zlqc/uhX5lcZDHXpidVgGlT6Tc8QiNBqx5JA4PJBc4ZiQjwp0ZmeCoi9uf/m/219OZw2kxe1XyArlTU3o1W4xXBGYPtrSO32enhQ5R8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=bC4rbd7N; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53R9KRS51598826
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 27 Apr 2025 02:20:48 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53R9KRS51598826
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745745650;
	bh=Q9XVA2K/egT5rZBfVl63vVsaOIZf5aipFdvtobDcRfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bC4rbd7Npt7uDPmLVAKvBmhK1SCPwNpnLTKiOwjeGhHnyAqix5yVkujXTOYSzhZlP
	 Qa54MsXV4KcT+UO/N0QhG5hy3b0J5d5R5QxcqjyVwoMDHWtMdQn2ttJP8YmQh7VshF
	 3oQAKAsKDIXpB7GJMY3+FP9gLC/a19jdYBy79f05LcgZQVAXCGzyH5Yk77DpdlqGsL
	 nb6GSt5+tZnG8d+dt0dPnh8GenMjTVEwbkSvLAGCB5G2b2WoFkDaOtBhXeHJUKZQX1
	 305LkAPpecGgDlM537MTZw+9m8iydr1ypLK50jyconDOSeu4PmadoQkIcJl4K7DAJ3
	 CbtsF1L9GUAFA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
Subject: [PATCH v4 08/15] x86/msr: Add the native_rdmsrq() helper
Date: Sun, 27 Apr 2025 02:20:20 -0700
Message-ID: <20250427092027.1598740-9-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250427092027.1598740-1-xin@zytor.com>
References: <20250427092027.1598740-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__rdmsr() is the lowest-level primitive MSR read API, implemented in
assembly code and returning an MSR value in a u64 integer, on top of
which a convenience wrapper native_rdmsr() is defined to return an MSR
value in two u32 integers.  For some reason, native_rdmsrq() is not
defined and __rdmsr() is directly used when it needs to return an MSR
value in a u64 integer.

Add the native_rdmsrq() helper, which is simply an alias of __rdmsr(),
to make native_rdmsr() and native_rdmsrq() a pair of MSR read APIs.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---

Change in v2:
* Split into two changes and add the native_rdmsrl() helper in the
  first one with a proper explanation (Ingo).
---
 arch/x86/include/asm/msr.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 82a908125b20..7b9713a49d59 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -107,6 +107,11 @@ do {							\
 	(void)((val2) = (u32)(__val >> 32));		\
 } while (0)
 
+static __always_inline u64 native_rdmsrq(u32 msr)
+{
+	return __rdmsr(msr);
+}
+
 #define native_wrmsr(msr, low, high)			\
 	__wrmsr(msr, low, high)
 
-- 
2.49.0


