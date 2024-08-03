Return-Path: <kvm+bounces-23168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6655946980
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 13:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0AAC281F8E
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 11:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D429B14D44D;
	Sat,  3 Aug 2024 11:34:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43614501F;
	Sat,  3 Aug 2024 11:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722684881; cv=none; b=s0leH7mriGieLmUpSgMCTmmi3TMfFpVB5zFGNdQm5G5GqqCU2AimlzGTrzzAmF9TVH3IWDGaKyvsNhz5XmvTQuY8VVPfgVCqXMUHB/7Z5MmTgKdG9eRrRzuzy4PY4iMqD1IJWZ+BUxL6qN1B5W9SFcuQpRBnNJAIq7dWuoGQu1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722684881; c=relaxed/simple;
	bh=0FoAorGZGVqg9KZcv1+q79HZnlaZYaj7yZDqT0LzV7w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jp+gaFewun2eLq4gvq6f9jBU5O46u9VmOfFKHPYx8xRhsxpDlFIjmGv3fz2zJpRezW/e3TRj2OQxO4OL32lSQZQm+fardXoHpASfIFkSvmcIfCIHfncPxIxb5NOxkNGbMk0jmS1mhUnoLuUsz9PsMGwMU6ZRhgJ/ipHcHs7F44Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WbgYy24wQznbls;
	Sat,  3 Aug 2024 19:33:26 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 5C0311800D0;
	Sat,  3 Aug 2024 19:34:30 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 3 Aug
 2024 19:34:29 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <vkuznets@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>
Subject: [PATCH -next] KVM: x86: hyper-v: Remove unused inline function kvm_hv_free_pa_page()
Date: Sat, 3 Aug 2024 19:32:33 +0800
Message-ID: <20240803113233.128185-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf500002.china.huawei.com (7.185.36.57)

There is no caller in tree since introduction in commit b4f69df0f65e ("KVM:
x86: Make Hyper-V emulation optional")

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 arch/x86/kvm/hyperv.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 923e64903da9..913bfc96959c 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -286,7 +286,6 @@ static inline int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	return HV_STATUS_ACCESS_DENIED;
 }
 static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu) {}
-static inline void kvm_hv_free_pa_page(struct kvm *kvm) {}
 static inline bool kvm_hv_synic_has_vector(struct kvm_vcpu *vcpu, int vector)
 {
 	return false;
-- 
2.34.1


