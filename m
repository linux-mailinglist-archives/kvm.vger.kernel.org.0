Return-Path: <kvm+bounces-56845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C998EB44587
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9664D586165
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853A1136988;
	Thu,  4 Sep 2025 18:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfJPEm89"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9792367D5
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757010970; cv=none; b=iz5Wy7WMC/ivzoAyqhH0gFAagxxnEl5N6uRfwlN1fa58jnKhmPD2N3KyJwQcs3hkbYIlm/5q0ZyTk9+T9b0KdNoIuLv2BmdcOgY3jPK7u+3dOl66x/MWpd3SBJhEKhIObTSt7r0KYOpIPXxqg85cqhXaF08N2ELT05at/OFAWLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757010970; c=relaxed/simple;
	bh=11446e89j8O3rIbhJn3eks1GWSPFHMDj36o+PFuuH7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bl9u57VNR4zd650LM6oWj8YoHZphYynIKVHyMTB8OrNn5JZP7WJyrFbDeqhciT2XETkrTaJ7e0Ik6tIs743VcVqq79vB1L6kE4EVbDAtLXfCuoKQgoJ19R3vzce7xGUW78zxAzZkP4HEcB4rzjJl81rGACLXRE5gHZk16HiBkKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfJPEm89; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B16C4CEF0;
	Thu,  4 Sep 2025 18:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757010970;
	bh=11446e89j8O3rIbhJn3eks1GWSPFHMDj36o+PFuuH7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfJPEm89M90THiFsA+RwMbzYNX/L2SrRv+Rfki6uHaMAlTTMgXr8uABobS3VMMLlJ
	 SBkuTQQz6by6myMTunWv09iebPlrMzdDItY+4S4eWnLPxvvYiMEbsVtnOqopKkFyw3
	 txAVgtXKkYcew2fDhel1mRhsaTJGSpLaIttCcK0aFiV5oSjtvQS1GYwdCzP5AZPiy4
	 jissCsY3Zz6+J6e7jqVTw708xbnVlFXxmjJXqTNSjlOFXAPZe6p19bIgdu/9XbmVTW
	 V0NVevlGEFGIRXUwmyi/UDNX1DsJOdJVxBLKm4I1AMyOi8AvCtcwdUFCTEXP6SDnmI
	 iBGwpHyAOndNg==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>,
	<kvm@vger.kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [RESEND v4 4/7] KVM: SVM: Expand AVIC_PHYSICAL_MAX_INDEX_MASK to be a 12-bit field
Date: Fri,  5 Sep 2025 00:03:04 +0530
Message-ID: <a24ae953cea716bf9c56c136f7ca4bf5e97b1080.1757009416.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1757009416.git.naveen@kernel.org>
References: <cover.1757009416.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the latest APM describing AVIC support for 4k vCPUs, VMCB
AVIC_PHYSICAL_MAX_INDEX (Offset 0xF8) and EXITINFO2.Index are both
updated from 9-bit wide to 12-bit wide fields unconditionally (i.e.,
regardless of AVIC support for 4k vCPUs). Expand
AVIC_PHYSICAL_MAX_INDEX_MASK accordingly.

While AVIC_PHYSICAL_MAX_INDEX_MASK is updated to a 12-bit field, KVM
will limit the max vCPU/APIC ID based on the maximum supported on a
specific processor and enforce that limit during vCPU creation. I.e.,
we don't need to rely on the mask to ensure that the max APIC ID being
programmed in the VMCB is in range. The additional bits (11:9) were
previously marked reserved and were never set/read by older processors.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/include/asm/svm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 17f6c3fedeee..d227e710c6b4 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -279,7 +279,7 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_IPI_VECTOR,
 };
 
-#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(11, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID table is 0xfe (254), as
-- 
2.50.1


