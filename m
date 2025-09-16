Return-Path: <kvm+bounces-57722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81ED1B5972B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:14:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24DA73B8AD3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 13:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B390315D2F;
	Tue, 16 Sep 2025 13:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kLV5NdZ0"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122E02DAFB5;
	Tue, 16 Sep 2025 13:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758028417; cv=none; b=LLD9Xcx8hcaxYQuaU8QV/x7ImntPLyWn85HrLilklqu649DhIVMlNguUQ6nKDUSHgiYUhQpUMuTcOsupcNzonESpeAqrkGTrWxZKiQihjnCCKYJ10jpC9VUSm16n/eBMBXtbHlkFe0NOT6luc08pTV1lqqGhF6uzlC16STGuVls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758028417; c=relaxed/simple;
	bh=vZhrRlgI4G38jLgK6YuKGOq5l+KBRSro1qPJETLMGXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kWKgX97eMphs7712TbCa2vDsxot5Q0pVSwCVjsmvvIuUzxdmD+67I/FP8Nx/o3Ob1QObrqp5hqUAlHAybJmmh0BoPNKaQ1mUFTk0ppa2SEh5FDdkUXQAdcamM6dlaFop0y1GsniB65piqD6pDzx2wAWai+4TPW1UmkjrwpuFTkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kLV5NdZ0; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758028413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QE/V0yD8O0RXQfOLjhzEAz202V81MMkX2ZDGBf88g1o=;
	b=kLV5NdZ0LkXq+PxIEDHmrF5BB3iUywnN4VIr0AZvil8qhI/UbAwsgpzT3bTH/pjAo7h0Md
	icmDVGaoFYDRJVLRwt21DWdouJLihHwn71gPbfFYNModG/52zYCMK54Kq/WN2LJopxGG2S
	f/7gZ3bhl2IZdIDXZPZA9ej8igh+irQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: Remove unused return variable in kvm_arch_vcpu_ioctl_set_fpu
Date: Tue, 16 Sep 2025 15:12:40 +0200
Message-ID: <20250916131238.2489818-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

kvm_arch_vcpu_ioctl_set_fpu() always returns 0 and the local return
variable 'ret' is not used anymore. Remove it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/s390/kvm/kvm-s390.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bf6fa8b9ca73..f61cb8a5ea77 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4367,8 +4367,6 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	int ret = 0;
-
 	vcpu_load(vcpu);
 
 	vcpu->run->s.regs.fpc = fpu->fpc;
@@ -4379,7 +4377,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 		memcpy(vcpu->run->s.regs.fprs, &fpu->fprs, sizeof(fpu->fprs));
 
 	vcpu_put(vcpu);
-	return ret;
+	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
-- 
2.51.0


