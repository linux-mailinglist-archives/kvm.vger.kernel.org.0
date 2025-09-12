Return-Path: <kvm+bounces-57369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54585B54560
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 10:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF89AAA1652
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 08:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E018D2D9EEF;
	Fri, 12 Sep 2025 08:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kDlamB2D"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEF62D837B
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 08:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757665686; cv=none; b=A1UXP7CUE1n8AR5qUvY9L2sUjFWJsmfuTScyo665gn008bhNWOlMYpufkmZT1yZs3Vd3q5MEhy1QtUc7yPN2bMYpjIzlGtm3uLfufRnfEzdDvx3kXd2n/q1qMY9fFea8jRRkw8X+BvW7gZfan8i8tbCoQkTBgIfQ1GlJzRDOt7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757665686; c=relaxed/simple;
	bh=XPv2E+QqHbQDLO4EmTCQZMManpkJEAmxYKBnXLGB/Q8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=DKd6gjzrTaGG44Yvfpi+jstFVTEpO7bOFmAY6QV90Nr9U840499QwXdZIx6DwLvFxZ1FhpL+cs55B6MFHMEFHp+flv9USztRPJExRpcCgLfcpSnu6x5Ek3FTMzj93b2CDKJTuZdAc0DfmtoMSRbeIqo0WR5Am36DOcP7gzYC/TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kDlamB2D; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757665671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iAQrbCqZZ4sOxWZdD0ZcXvxkxM3DekbLizKEk5JXiYI=;
	b=kDlamB2DmhQj2fTmsOmZiyKAroCsKWkXguZcNfTcNVtkG1bOz8NDZcVCf2adk4w6V4LPeR
	j6LjxuUCyJT2gCgG2RXhbV3aBg0/oeSKoo3tl0EB4Srxpgh3mVIWnr/kM8bC2uZsWeHNUj
	gjF97lNGZ34GseD0JoxAiDitli856yE=
From: Itaru Kitayama <itaru.kitayama@linux.dev>
Date: Fri, 12 Sep 2025 17:27:40 +0900
Subject: [PATCH] PMCR_EL0.N is RAZ/WI. At least a build failes in Ubuntu
 22.04 LTS. Remove the set function.
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250912-selftest-fix3-v1-1-256710a5ae5b@linux.dev>
X-B4-Tracking: v=1; b=H4sIAHvZw2gC/x2M0QpAQBAAf+XaZ1usdMevyIPYY0vo9pKSf7d5n
 KmZB5STsELnHkh8icqxG1SFg2kd94VRZmOgkpqyrQiVt5hZM0a5ayQfKTTs2zkQWHMmNv//+uF
 9P1b0CzVfAAAA
X-Change-ID: 20250912-selftest-fix3-27f285e79d82
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
---
Seen a build failure with old Ubuntu 22.04 LTS, while the latest release
has no build issue, a write to the bit fields is RAZ/WI, remove the
function.
---
 tools/testing/selftests/kvm/arm64/vpmu_counter_access.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index f16b3b27e32ed7ca57481f27d689d47783aa0345..56214a4430be90b3e1d840f2719b22dd44f0b49b 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -45,11 +45,6 @@ static uint64_t get_pmcr_n(uint64_t pmcr)
 	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
 }
 
-static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
-{
-	u64p_replace_bits((__u64 *) pmcr, pmcr_n, ARMV8_PMU_PMCR_N);
-}
-
 static uint64_t get_counters_mask(uint64_t n)
 {
 	uint64_t mask = BIT(ARMV8_PMU_CYCLE_IDX);
@@ -490,7 +485,6 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
 	 * Setting a larger value of PMCR.N should not modify the field, and
 	 * return a success.
 	 */
-	set_pmcr_n(&pmcr, pmcr_n);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
 	pmcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
 

---
base-commit: aae5a9834b388860844b294c70c8770dd26e528c
change-id: 20250912-selftest-fix3-27f285e79d82

Best regards,
-- 
Itaru Kitayama <itaru.kitayama@linux.dev>


