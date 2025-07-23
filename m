Return-Path: <kvm+bounces-53283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28887B0F9A1
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:54:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6569E17847D
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A76224882;
	Wed, 23 Jul 2025 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LKmUdSBg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FC51EE03B;
	Wed, 23 Jul 2025 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293257; cv=none; b=aRJzz6XdghH1oHoSVlJJX1yA1jFYDy/mcg5el+S/qReHW+xVS9tAMDbXj9UNk5O4IQ35Z5pH80OQPtaq0jrrmQVnl90i4Rzt6vlNS0xtjkwzP/TouJ1WvK+rCFYDbbBE1Vof5UsktsOH7CkY3LjJtdTD9xkXbnBaUSKi0igASm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293257; c=relaxed/simple;
	bh=aWYOhMVY+0LqjUojDgZy7kPOvnM+/mxfdv2uRv5JdiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMMLBFOTGoeQ5oQ5QfumqhRaEfwgEn9RnKX0KU+oRcUGq+pzBTUp+owgxqW+46dJK/rgLtdaU2yA/9NYYD7oh8WFme5gDDgmeB1lek6Yrh0bQ2OGJakpPhG7vEOAhMVEl6o7lqCUwMWC4jZmqZ7XTijLyqOcuigN1kDpknDrMyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LKmUdSBg; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrfxt1284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:53:50 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrfxt1284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293230;
	bh=/EBeMK7ZSqzkS+JM5rRpzF6dDvDDWpq+RlSEiWex4Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKmUdSBgHid/JUsdhkXnKlxY9oQLaj9h3hn7cRe9NzmCk1H2vroNbzA5vW16MofiT
	 0qzcLpnWXrPlQNGcUrlaP8+fBl6TdOfd/CiOtYvxIxAFs5DQxu2GwHd4cRXb0aupGR
	 24xYiQwHufIXK+gJU8Ue8DqFUk+OSOPOE7iWuM2amhrokutC3aeHFd0ksOPyZN+FDt
	 GuLkmNG5G6lqRJPHO5uJtM5X/3Yw4WURdJTLFuQLecuFURtZWjWCknRI5aPHONvAHd
	 FNOpc3yBPlgmKjCS5/dA4oGmQ2SPNIPoDOIcCmTBePrIFZT1Lk8ZXJwHz2W02Zgpzc
	 BFsGWBKGDFttg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 05/23] KVM: VMX: Fix an indentation
Date: Wed, 23 Jul 2025 10:53:23 -0700
Message-ID: <20250723175341.1284463-6-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix an indentation by replacing 8 spaces with a tab.

While at it, add empty lines before and after for better readability.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c893ea2db9de..6e9799a80d25 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8555,7 +8555,9 @@ __init int vmx_hardware_setup(void)
 	 */
 	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
 		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
-       kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
+
+	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
+
 	return r;
 }
 
-- 
2.50.1


