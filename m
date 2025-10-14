Return-Path: <kvm+bounces-59978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C58CBD6F77
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A46B640ABD9
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A740430147C;
	Tue, 14 Oct 2025 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="XMvtRdwa"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F247C2FF66F;
	Tue, 14 Oct 2025 01:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404277; cv=none; b=OeLR+SmgjaVVHaCkTjYgDllWGPursMJdyhHyzjagWJaGcrPT3EyZdc9462b6pldb2fLQiZimYrobG5G3Y493/XpnzlkODjHomfpgpDNFwTUh/U8Aty4lxCk2w2bEXXjX+bWUNr4AzOvZYw9Exc54b6g3jE0VCs9r7pwdkJpdZ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404277; c=relaxed/simple;
	bh=PCK07hZjZe/djyfCR93LEEj+EseF0gt0pumT0MN7FO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1aLdiq+O8tDZU8YP3E7VSgGB8fvr/E1K3ZxtWEEzjhO3zcTblZKm2IoICdKlq9+qbkIwQCpOkTs0cp9y61oKkYq6FpxRT0TA5uHnzakFdHH8vFhkZ0FCAHfVRTeD7IxiLRfoS5kv8G3hLcYDRyweqme+VUN/nPJlwFidZ+nU8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=XMvtRdwa; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E19p1b1568441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 13 Oct 2025 18:10:08 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E19p1b1568441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760404208;
	bh=UPeE8tl0kefM8+QolEcGU5SRTnwPLc6mn0cnq24BAgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMvtRdwa24F+Lqawt1KyWygWHA61AO1zsLGeLVw7VKSv8I92Qb4s4K4lgqkguyNl2
	 7YZuLxIlAN36kUqKYr2zGNmVKm37euHWoD2JxU/E9YleM0Z/ovQUlEUOZ/Zcyhpr5f
	 JxASPObXDqvlC4oKNW3r7g1Kmy5gpZ7Iv/G4Wpa9tAUT8btLO4+pyrBAVb7PWvb0wQ
	 su2IZgH9r8WtD/6ai1XtSEGb/OgskpqUYMdmrErECmu6WDFtRt2tqymiPXzFnEJpET
	 rGH4RedmSI+DwbfrQqOm1Otc1gNGqLvKe2/U/9ZhS1YFfks4oON1DLmrC/ciX7PSUK
	 sJBX/rRC8E0UA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v8 14/21] KVM: x86: Mark CR4.FRED as not reserved
Date: Mon, 13 Oct 2025 18:09:43 -0700
Message-ID: <20251014010950.1568389-15-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014010950.1568389-1-xin@zytor.com>
References: <20251014010950.1568389-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

The CR4.FRED bit, i.e., CR4[32], is no longer a reserved bit when
guest cpu cap has FRED, i.e.,
  1) All of FRED KVM support is in place.
  2) Guest enumerates FRED.

Otherwise it is still a reserved bit.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.

Change in v4:
* Rebase on top of "guest_cpu_cap".

Change in v3:
* Don't allow CR4.FRED=1 before all of FRED KVM support is in place
  (Sean Christopherson).
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/x86.h              | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5fff22d837aa..558f260a1afd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -142,7 +142,7 @@
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
-			  | X86_CR4_LAM_SUP | X86_CR4_CET))
+			  | X86_CR4_LAM_SUP | X86_CR4_CET | X86_CR4_FRED))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4f5d12d7136e..e9c6f304b02e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -687,6 +687,8 @@ static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
 	    !__cpu_has(__c, X86_FEATURE_IBT))           \
 		__reserved_bits |= X86_CR4_CET;         \
+	if (!__cpu_has(__c, X86_FEATURE_FRED))          \
+		__reserved_bits |= X86_CR4_FRED;        \
 	__reserved_bits;                                \
 })
 
-- 
2.51.0


