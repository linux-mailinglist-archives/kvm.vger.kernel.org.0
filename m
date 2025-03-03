Return-Path: <kvm+bounces-40054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36D6EA4E79C
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAF113BB624
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 16:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B87625334F;
	Tue,  4 Mar 2025 16:20:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from beeline2.cc.itu.edu.tr (beeline2.cc.itu.edu.tr [160.75.25.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028AC27C86C
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 16:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=160.75.25.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741105232; cv=fail; b=YzGAY2+MV11uFV+BFbMt4VtPlZ6OQxCA3wsCYV1p/mo/T3mZU5mI78l1d83wUh7lxf080BIR0/UfNSK7ETq6vFFbL0Clj2GcoUgu45ta4e3ZjwZi/trmbdCn1GR957wEqPx6DaJB9VSai8ry6vECa/xp18q1PSj2JC4RqHUx/9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741105232; c=relaxed/simple;
	bh=L2KhT4S9r3A4YkjPoXVoLwQekzkoAt/JaGzANqABSsY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r7NZpXugC1GY9hFFKZdvkW0dLipPbq7wsDNtQ/kVqK6DSWYd/ubQNLVN17cmLq+DB0XoB3u33ap8yyXOD+YasdB+t/jyj8gbJS6MttBVsrAfdsI9USqeWHYEGcdlfBHm0WJbzR6MnINnTSxvEU5Sh5pFiwDLWFTphaaDa+8eKlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=none smtp.mailfrom=cc.itu.edu.tr; arc=none smtp.client-ip=114.242.206.163; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=fail smtp.client-ip=160.75.25.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cc.itu.edu.tr
Received: from lesvatest1.cc.itu.edu.tr (lesvatest1.cc.itu.edu.tr [10.146.128.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by beeline2.cc.itu.edu.tr (Postfix) with ESMTPS id 1AFC9408B647
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 19:20:28 +0300 (+03)
X-Envelope-From: <root@cc.itu.edu.tr>
Received: from lesva1.cc.itu.edu.tr (unknown [160.75.70.79])
	by lesvatest1.cc.itu.edu.tr (Postfix) with ESMTP id 4Z6gq45xhmzG2pM
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 19:18:56 +0300 (+03)
Received: by le1 (Postfix, from userid 0)
	id 83ED042746; Tue,  4 Mar 2025 19:18:40 +0300 (+03)
X-Envelope-From: <linux-kernel+bounces-541245-bozkiru=itu.edu.tr@vger.kernel.org>
Received: from fgw1.itu.edu.tr (fgw1.itu.edu.tr [160.75.25.103])
	by le2 (Postfix) with ESMTP id C640142378
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 12:11:40 +0300 (+03)
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by fgw1.itu.edu.tr (Postfix) with SMTP id 9F7D23064C0B
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 12:11:40 +0300 (+03)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB5F71890E75
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 09:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3355F1F0E3A;
	Mon,  3 Mar 2025 09:11:27 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A771F03E1;
	Mon,  3 Mar 2025 09:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740993085; cv=none; b=mfvKJpQkMKg6e+6c4C/yORgBGBzbS1mpDPCFFFN+gyJc6JuhwEebOut42xgJGCx3Zh9VTG4whQAL8awHChEkfXxqKBGnODTQBs64sPAjftcqYR+zlv+Oob6i35QLZZvB6TkOt+owDXJsK0E5g9uUTBCRxeusNsbGRM9uZZ2EpJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740993085; c=relaxed/simple;
	bh=3P7asazvVhA6Z+2Oqdc1BRq4108S/dF7oNeQJkxp/Z8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VylxTvPkKLRfaPY73wUDW2kCLHPQ3VvHCZ1tFCilMI6bARpXw/oojR61tOfj9uh4XNWPKKLw2Axl5u06fHuFChRoiGAQila46VDkRQsft6m0yyC/AopCQUi1i8ild3oLylftbh75R9hM7pk1zGIu02aIpti3f+VBxpQ9KC2/Ts0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxeXE2csVn7AiJAA--.37601S3;
	Mon, 03 Mar 2025 17:11:18 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxDcUycsVni4AzAA--.57137S2;
	Mon, 03 Mar 2025 17:11:15 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xianglai Li <lixianglai@loongson.cn>
Subject: [PATCH] LoongArch: KVM: Reload guest CSR registers after S4
Date: Mon,  3 Mar 2025 17:11:14 +0800
Message-Id: <20250303091114.1511496-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CM-TRANSID:qMiowMAxDcUycsVni4AzAA--.57137S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
Content-Transfer-Encoding: quoted-printable
X-ITU-Libra-ESVA-Information: Please contact Istanbul Teknik Universitesi for more information
X-ITU-Libra-ESVA-ID: 4Z6gq45xhmzG2pM
X-ITU-Libra-ESVA: No virus found
X-ITU-Libra-ESVA-From: root@cc.itu.edu.tr
X-ITU-Libra-ESVA-Watermark: 1741709937.36824@P2o4xme0JCTQI1R1rTDsUQ
X-ITU-MailScanner-SpamCheck: not spam

On host HW guest CSR registers are lost after suspend and resume
operation. Since last_vcpu of boot CPU still records latest vCPU pointer
so that guest CSR register skips to reload when boot CPU resumes and
vCPU is scheduled.

Here last_vcpu is cleared so that guest CSR register will reload from
scheduled vCPU context after suspend and resume.

Also there is another small fix for Loongson AVEC support, bit 14 is adde=
d
in CSR ESTAT register. Macro CSR_ESTAT_IS is replaced with hardcoded valu=
e
0x1fff and AVEC interrupt status bit 14 is supported with macro
CSR_ESTAT_IS.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/main.c | 8 ++++++++
 arch/loongarch/kvm/vcpu.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index f6d3242b9234..b177773f38f6 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -284,6 +284,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 int kvm_arch_enable_virtualization_cpu(void)
 {
 	unsigned long env, gcfg =3D 0;
+	struct kvm_context *context;
=20
 	env =3D read_csr_gcfg();
=20
@@ -317,6 +318,13 @@ int kvm_arch_enable_virtualization_cpu(void)
 	kvm_debug("GCFG:%lx GSTAT:%lx GINTC:%lx GTLBC:%lx",
 		  read_csr_gcfg(), read_csr_gstat(), read_csr_gintc(), read_csr_gtlbc(=
));
=20
+	/*
+	 * HW Guest CSR registers are lost after CPU suspend and resume
+	 * Clear last_vcpu so that Guest CSR register forced to reload
+	 * from vCPU SW state
+	 */
+	context =3D this_cpu_ptr(vmcs);
+	context->last_vcpu =3D NULL;
 	return 0;
 }
=20
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 20f941af3e9e..9e1a9b4aa4c6 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -311,7 +311,7 @@ static int kvm_handle_exit(struct kvm_run *run, struc=
t kvm_vcpu *vcpu)
 {
 	int ret =3D RESUME_GUEST;
 	unsigned long estat =3D vcpu->arch.host_estat;
-	u32 intr =3D estat & 0x1fff; /* Ignore NMI */
+	u32 intr =3D estat & CSR_ESTAT_IS;
 	u32 ecode =3D (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
=20
 	vcpu->mode =3D OUTSIDE_GUEST_MODE;

base-commit: 1e15510b71c99c6e49134d756df91069f7d18141
--=20
2.39.3



