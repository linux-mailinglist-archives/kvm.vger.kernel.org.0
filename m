Return-Path: <kvm+bounces-44264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55FE6A9C156
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 10:37:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69EE74C094C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 08:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 227EA23BF8F;
	Fri, 25 Apr 2025 08:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WmynG9wH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309E23370F;
	Fri, 25 Apr 2025 08:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745570140; cv=none; b=sQxseyBt0GeAbxMKe6mnLq9gpYl/LyEzjMdBSDGYEXWHl/7kfZ5u1N4qQDD7Zu3U1lWkoO6OWHPg9l9D4CFL67pnoT6nCDCSu4wU+NsIW3/ImUZAYPvRZ/cK74VWYvprUDNpnJUm5MWQZH46RHDy1pRApBZ2DHal7YGMaQmEORQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745570140; c=relaxed/simple;
	bh=0LtH58idrdHJS0ADA8Ea6eTsKCAoYlGOuXh/2yF2Ueo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHPJUTEKPBd1iZPYDsEkzC6eNl9ItuygH8lI7lzy/IWmy0pUJHTE2qA7kTwdtJyoUoh0/orlyhutaJwc7Vm94SGiM8LTMfE+qXbm527TpRt11KYsM2g246UoCSQwqGSO/TQHEV7iF6sREAC4jQmPqsOUSUXSEqWLyMz46sua9ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WmynG9wH; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53P8Yg5V2390085
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 25 Apr 2025 01:35:02 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53P8Yg5V2390085
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745570103;
	bh=HGw2nFQL5aKA5RzIm7/QSoWKBl/SarOifRVAMhDF5jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmynG9wHeRjV+Q3G3LyDwa0t8H2xdLhYQhh0ra6oIC+UKd/vIlwdgrqzDjKdCDec2
	 PnojmoRouq3yIpIiGFGVI2h14sephA3L4z+tUh7+efsj9OhPET2PQZgkHJyaQryO1J
	 HjXROz4i7dHc2FLIHeagMur/3NIya3J9of0PiuZl2K+1kbxBdagDgSqYF6kqkg7o13
	 4Xt2UVPF8/kCortRdwMgreH8vjS20RTFSJPYmFHCcndr+PULwc5WvqeeXBnSMpd0Jj
	 t76O0a/CmAPYaGzPF5p6HEpyekAJYxcBemmDnxV7IEH/jHg/7MdFfLjWdILBqGNFxn
	 IJwSKbRyX0DGw==
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
        dapeng1.mi@linux.intel.com
Subject: [PATCH v3 07/14] x86/msr: Add the native_rdmsrq() helper
Date: Fri, 25 Apr 2025 01:34:30 -0700
Message-ID: <20250425083442.2390017-8-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250425083442.2390017-1-xin@zytor.com>
References: <20250425083442.2390017-1-xin@zytor.com>
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


