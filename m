Return-Path: <kvm+bounces-66757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 526D3CE59B7
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 01:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B29F13026BDA
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 00:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023272E7650;
	Sun, 28 Dec 2025 23:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="Lq1UcpCR"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.pv.icloud.com (p-west1-cluster3-host5-snip4-10.eps.apple.com [57.103.66.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378A72E7BD2
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 23:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.66.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766966311; cv=none; b=uy4Am7IpMOt1N38XbwP2S5aDMs7zsTKA3Him59wT4ZQYP/8dgZtmaulOEQ8WYyUUwRBHxfi4jtZ26Ik7HbfsL07sIGDDC3BlaU9K1TIEwcjjdDAtixJJUeeS6Bri/rv7DkPlfnAEBlVaMLGTCTaAfAiDEjQN3h+lUWZmj4UmkNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766966311; c=relaxed/simple;
	bh=X0xI4cc9F+qeEBDomMtEKG5Y5J86jU27RsIi0vHZc0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ijm/G1NZ5smHOy0bRgfbN6nyffMO8NTfwT39Q9RQ0jZG3gtC9cwl5yFYPpYRfSZhhCNT4TXVQYugy5uDjhLOs70rip9rYSxhnfk3zwPiE6QWutrj6LvoYUDRFaGUshhv2YGas1QGhZFlt35z0fyowreZfcBiiNhLNfeqEPGKrH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=Lq1UcpCR; arc=none smtp.client-ip=57.103.66.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPS id CD1A318000A7;
	Sun, 28 Dec 2025 23:58:27 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=Z3QC1xsGoWlyM6qiWEninqsw442X+pblDFh3uzygGEs=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=Lq1UcpCRmd0Jgion/YwXZR0H7y1NrXxtJZpUBvBNtbogJowXcsrfms1SEZobT6mvzAntAV99MpRs1zKKrJxxKwRJDtbrhyAfMEaCYQ77bARwcxpIhLiRIZnRNlNW5adkBJ02yEGuOriQZcPfNwyXuuHuzQUEBj7CgpLw/cTSl9lsSrFXBvRIJGdZPoplW24YCPKC2XjJfkYMkPxmL9pzeiBulhmmeZLH4y594a+jkig2qlZc4WSKyc1oHcYjE5C5iE6qNcViR4jg1gY9gTDw6gOy5JkAJLDY8nGFBID8rjzQPY2pb/lQU9cICauiugjxVcM0Ykog9rnhlbPNCr7rHw==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-5 (Postfix) with ESMTPSA id 1901918000B9;
	Sun, 28 Dec 2025 23:58:22 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org,
	mohamed@unpredictable.fr
Cc: Alexander Graf <agraf@csgraf.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	qemu-arm@nongnu.org,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v12 28/28] MAINTAINERS: update the list of maintained files for WHPX
Date: Mon, 29 Dec 2025 00:54:22 +0100
Message-ID: <20251228235422.30383-29-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251228235422.30383-1-mohamed@unpredictable.fr>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Rj7Romy-xmkHQloxAGTARtkhCR6i1xJp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI4MDIyMyBTYWx0ZWRfX3rEriqSZtQEB
 3XRWKGytrB7FAPpBOajuYh4D5mzUNS6ONwVX8f0evPrGRMQj1LvLSEVHzmYZTe9ucPnXqTtnRy4
 caulxXsSvyZiYNZp+YEgSkR885+8KeT4ZbND7R22MTSb2aKl5Ou/KxOA7jlWRNrbn6Tr12Ua3F/
 Tb9ELXPvOarnd4o+Ge8iq5/HG5W3tBjMG08HzQ2k6s+yPHhkbB6Vb0l0CQPcgLqACIXNLdU3Ilc
 SpbTFl8XfCGa9OhE6fkJ+BpZcgf6V1t4NemBH5u5/X+pgTy7ROZJ6UUu+94msGjaioe224rBCRZ
 267QStjQrjGW4T0k1oa
X-Authority-Info: v=2.4 cv=ZJTaWH7b c=1 sm=1 tr=0 ts=6951c424 cx=c_apl:c_pps
 a=azHRBMxVc17uSn+fyuI/eg==:117 a=azHRBMxVc17uSn+fyuI/eg==:17
 a=t-S863UTctjxRPX8:21 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=hdCJvu6vi-O6ykQZt0QA:9
X-Proofpoint-GUID: Rj7Romy-xmkHQloxAGTARtkhCR6i1xJp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_07,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 clxscore=1030 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512280223
X-JNJ: AAAAAAAB0TYzjbInwuLNkWeN2iZyibBPeceX+Ca3t6BsdRotJOWMOnnkbRMPyaL19bBSn6pB6zpT6HXgQ1gH9u7GRXu7nye4+Spz4icVzSK5lxKVYBnRApb+PPbk63VJaWE6xQLLOsfRTqEhzqx0yqcf47fLaMQm1H1yfp/H251uDy17wEUdUtAAHBZi02hpRhl87eYtSPQnjeFdwUy8Sy6IyhMAeaIAdeetO4qe7EP6o09wYufbp27RAEqqJi1vgECdpJUhNzaBBFSCpISOAdFbLE7TalproE+RFnVEtw+yAzRARC23OcOMWzEgfamjznXYtTe7w5htuM2cTl68feguTXC4vhtK+ZvScTBEzpT9kzjbA/6JMYISgRgOXbjQamjKsutlwxYVBiupDznJ4YFGXf/2hwqHEnX0E/PdCeeZtUygwn+jRp10eVo5MQKMoOo4DvEkdclodTGq8a6mHm3DKuUPE1jved/NQwAyh/E8zL0lzUXpEc+W2dvpRNE0x9AmYSHZXX1+gj2dUbMXrrlid6ECnI3N9DxUzCU1rAOOej/Aqi8dLB9MnzAkh8wD194FKac959iTNC5LXQHGhK6vMtTW42N8ulsA5XnPYr5GTmHh+sttRFICTuCvFqfHcZfbXNP7dc4oJ8fF/yKP1TPOEU6TKhR9CpAhcxg4CnDfjWYj4hiOZ/gHeO8CmRue/N8Ew/8L9ffizw7FeGtLW3IbRXi7ZWpgaCO78HcB4gxnFlkCbapQLOUL4Nym6D9IG0DDPsjNsIPCfvkAcNI36jMD+1Pnt3Du0ealGQN+aqGMtr1XetWpCh2NlxvvqMxQIuogyaZdlTWh5ie8EQI77m6LZL4NLlqt6DinHMWQA+38bxdm1fKvdfzBoLUbmIh37NqRSSjODtXG4nFF/MwIILfHbLmgwV88Yv0hMTmicYOFXnaO36s1c/moZaPo/2WFr6dTk7OYgxBf5MGarKlFtP0A

Add arm64-specific files.

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d84f141cc..7ac1efd904 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -552,6 +552,8 @@ M: Mohamed Mediouni <mohamed@unpredictable.fr>
 S: Supported
 F: accel/whpx/
 F: target/i386/whpx/
+F: target/arm/whpx/
+F: hw/intc/arm_gicv3_whpx.c
 F: accel/stubs/whpx-stub.c
 F: include/system/whpx.h
 F: include/system/whpx-accel-ops.h
-- 
2.50.1 (Apple Git-155)


