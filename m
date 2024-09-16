Return-Path: <kvm+bounces-26966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C46F1979E6F
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:26:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E251B21284
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 09:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB5F5132122;
	Mon, 16 Sep 2024 09:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="JMKHr7WJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEEE146586
	for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 09:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726478810; cv=none; b=YGeV8klA/hKpnd1zGFlxNRvDGT4uf05Ijofbbkr8ubiJreuuXgCiMZWuDM2DozEbBrvKwCvUoQZEH1MkyGT6C26TV8SRt/WlIrYMfBORvaEIFlxSnok716AixuOuV6e9HeBPLJPTKpHXfVwo5xGNFrAMw03sSxZ/PQSw95Oxj4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726478810; c=relaxed/simple;
	bh=aQkPuDpvwEae30GhlJo8cTrxC0ZYLwt1xKZE9oUNego=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oiQnKTojdtuJjVoglZzOiraBI+vqzDdhrSSRIgjz68SnfWsU9AKYIn4bO2a1sbuuXe0sOcnU7OPAXQuq+TBH2zL+G4DCEniqlfOZT1u+mbJxyXc9Fg2+j3pCh13ZAptogy2l6dDXa5eVCEL0LsB6DYcUsLCUi0Uf3/DKt2ZA8bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=JMKHr7WJ; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1726478765;
	bh=5C0HaDNv0z40Dq3FSjo9w53WFVCZuvNtTiGz93K91R0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=JMKHr7WJkQEyAPK4IDKU7NWJ4Xjbq3wOTau5hQzP+CDoQfQRwr+DFMzXswqQaVMK0
	 DaQg5ADY6VUCMAzgmFG1S0dNHIcNdWQFvsRVHHeOom5Ls/bUYmiaaJwc3pGWUuv9LB
	 ttHCBNLnhxdAHmndJzm/stsLaH+CCWboe2UMJtnw=
X-QQ-mid: bizesmtpip3t1726478756ti9l687
X-QQ-Originating-IP: /gJoNUlmd+IboF2jL9DFoR2xzAYrz7MGcmEmwBftpMY=
Received: from avenger-OMEN-by-HP-Gaming-Lapto ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 16 Sep 2024 17:25:54 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4414229508549440317
From: WangYuli <wangyuli@uniontech.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	maobibo@loongson.cn,
	guanwentao@uniontech.com,
	zhangdandan@uniontech.com,
	wangyuli@uniontech.com,
	chenhuacai@loongson.cn
Cc: zhaotianrui@loongson.cn,
	kernel@xen0n.name,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.10] LoongArch: KVM: Remove undefined a6 argument comment for kvm_hypercall()
Date: Mon, 16 Sep 2024 17:25:46 +0800
Message-ID: <8EFAA3851253EB9A+20240916092546.429464-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

From: Dandan Zhang <zhangdandan@uniontech.com>

The kvm_hypercall() set for LoongArch is limited to a1-a5. So the
mention of a6 in the comment is undefined that needs to be rectified.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 arch/loongarch/include/asm/kvm_para.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index 4ba2312e5f8c..6d5e9b6c5714 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -28,9 +28,9 @@
  * Hypercall interface for KVM hypervisor
  *
  * a0: function identifier
- * a1-a6: args
+ * a1-a5: args
  * Return value will be placed in a0.
- * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
+ * Up to 5 arguments are passed in a1, a2, a3, a4, a5.
  */
 static __always_inline long kvm_hypercall0(u64 fid)
 {
-- 
2.43.0


