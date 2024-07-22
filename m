Return-Path: <kvm+bounces-22040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA813938D82
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 12:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E88F1F21A62
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 10:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EC416B3B4;
	Mon, 22 Jul 2024 10:30:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C890149DF4;
	Mon, 22 Jul 2024 10:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721644200; cv=none; b=uvHQYtLajGEED4syPyMaZmKSvEanPaatOwudqUmy2q8krSEGqjagrVKGEA8oZEOh8yj6FQVd/PFMT9vxS/hdMlOpE9Vr03Nd0ahK8dj59Qo5Kh+j8qWtpZWPgX907DhgkgDc8lHfh8woPkfCbEBo+tf4k/PGGDrHFr65TQGC1qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721644200; c=relaxed/simple;
	bh=1FRGGeU+wym2xELmubxiqoYTkV0hARifRn2Z6nZoCfU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GUGhY1KN1SResAO76ixKob2YBQero6T03U41tTMACCngoT60xh7yUIsufF2qNh9WCwKv6B3B6nHssDp2a4Oq3LnCSUVQwi8smyddi+fLfHu4iN1FTr84cS01U0W+pW2DmMYLraPXWC6zZxlOy1Eye67i/qC3jzhLxYisvvX8xwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
X-QQ-mid: bizesmtpsz1t1721643990twg6sco
X-QQ-Originating-IP: ZQWrQ315tVoU0wN0faBAvkhf0b2ujopfRfQI60mXTkc=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Ò», 22 7ÔÂ 2024 18:26:28 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6738067066252403474
From: WangYuli <wangyuli@uniontech.com>
To: zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	chenhuacai@kernel.org,
	kernel@xen0n.name
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	chao.p.peng@linux.intel.com,
	WangYuli <wangyuli@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH] KVM: Loongarch: remove unnecessary definition of KVM_PRIVATE_MEM_SLOTS
Date: Mon, 22 Jul 2024 18:26:24 +0800
Message-ID: <09A6BAA84F3EF573+20240722102624.293359-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.43.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

"KVM_PRIVATE_MEM_SLOTS" is renamed as "KVM_INTERNAL_MEM_SLOTS".

KVM_PRIVATE_MEM_SLOTS defaults to zero, so it is not necessary to
define it in Loongarch's asm/kvm_host.h.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=bdd1c37a315bc50ab14066c4852bc8dcf070451e
Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=b075450868dbc0950f0942617f222eeb989cad10
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 arch/loongarch/include/asm/kvm_host.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index fe38f98eeff8..ce3d36a890aa 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -26,8 +26,6 @@
 
 #define KVM_MAX_VCPUS			256
 #define KVM_MAX_CPUCFG_REGS		21
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS		0
 
 #define KVM_HALT_POLL_NS_DEFAULT	500000
 #define KVM_REQ_TLB_FLUSH_GPA		KVM_ARCH_REQ(0)
-- 
2.43.4


