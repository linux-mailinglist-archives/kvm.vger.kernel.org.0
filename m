Return-Path: <kvm+bounces-54662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA943B263C9
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 13:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B20C175C16
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 11:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F51A2F39C4;
	Thu, 14 Aug 2025 11:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Hlm4Wi1T"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57272E7F25;
	Thu, 14 Aug 2025 11:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755169513; cv=none; b=igRBJWcVNbjiZLVtqU7y4YIj6IM4Ynagk2r72ujlrVc7gz6ZXuO05P4BQ2l2Cd86qT0s93iKOPNhKvxN4dWiKRK/82wFY/dFwiswoprN57CncKiaT+aNMxB805JEO8nu7pjqD1HEqIzKU90TjienBl5NTU6DsIKYYQjdz48btUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755169513; c=relaxed/simple;
	bh=GSWcwEbNvmvsPY+8tKlt/oMe4kUzsodicDKaoFAdrrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q1RK3wKXsTm4jo95+WCrWujVVuEePMxVVa6xCWapcXcOuzkvncYC8lsZg8GT/ruULWzKfnnRHueLrM9wFh3VGTjqiYh36xB67tbdEFbqSriztztTrwNnLvHLELSRHovvJI6xkGXtmaZJvhW4sJN7Ne35ZAq9VJ3+Yhuda76VQLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Hlm4Wi1T; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1755169476;
	bh=aFTcQ24VHBGhl7fxjJCrNseNtZvnYiuVulfETZ2Yz0s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Hlm4Wi1TdpKpbIsxdXc3FMOkXhwg0sUgDtvQznsw4KJxREOOfgo2VPCvEswnGxCnf
	 WrrvX5XLVeVwmmuDy7AtaFyh/vp39ZCTXRo9Q2S4wej0RELs6Xt/kOM/zMsa7EMx/u
	 8ei0CFqrygzieOI93J1M1b5Wb8VYzls1Jo1N1kt4=
X-QQ-mid: zesmtpip3t1755169449tc5358744
X-QQ-Originating-IP: XgWlJ2Jtuu7U1q7qZPBfqfAwbMmzZIuBeepPBsvAt7o=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 14 Aug 2025 19:04:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10535000667885771257
EX-QQ-RecipientCnt: 9
From: Morduan Zang <zhangdandan@uniontech.com>
To: ankita@nvidia.com,
	jgg@ziepe.ca,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com
Cc: wangyuli@uniontech.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Morduan Zang <zhangdandan@uniontech.com>
Subject: [PATCH] vfio/nvgrace-gpu: fix grammatical error
Date: Thu, 14 Aug 2025 19:03:58 +0800
Message-ID: <54E1ED6C5A2682C8+20250814110358.285412-1-zhangdandan@uniontech.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: Ocu70LrMHRlZS66ZhRzFUHrxCCDSWPiIotiDkYCdjZA9g0/VckZ3SUiO
	qEkxdrjfZAjHWq8XadpLP8P6O+etzTnMQl9BMalCvpaK8qg3h+f7ruZEoalc4A+ksAuLuk4
	O0KpOZVXBxOFy1Sfj3id07ioa0v3BJ7iXO5Tsvt7N3dDVA1U5+aS2ICf7UCNZnQq1k67xwN
	PJyuO7JF3It07g4RNzOb4MhImFSPhzcBTdQW6sObUVSqvMZocjWOQ4+5f+8RtaS/HMQQ/SW
	T/0BctcRVo1doiQI75/Vl/rwt67frAIsO2465mvwEDTmaeFbit0iE0YrvzZAj71iVbOKxMO
	saHnnRmOBs4oMT2OgRReiojEjXPCngGUc7KeJsKW8Em6LEksdPCZQbRn8rmDeygHKPYQqoN
	PJmPPmYBfmyYVtAxf6vmvXvhYjcmG5gK7w1EWuCC2WnH4H3DssmLLe6Bse2c6ukC03JZTRe
	uC1XE6rtbEivpXZCnboAXo5JSzgCUy09jZ2HoVDllr/rUhYguXox/pQbCbiLIQB5V6CoK9A
	Fi6YKVrVIUH9lrZa/d0XgwkOtcfO07iimqLahfcg/OFqxCxSV+PAltsaTx3+XHkQeEMIUEO
	c3W+SSwoFUdoEkRsyCN9tcva9POJ996vt31zwjIdKhtf/ExD7pO3lhdFK/g6l+OoB8IFehA
	rm5xwta8HFFqgzVCN/HdDrMPR3GEZpw2JBHo5d65U5tvwYy+4nj92fdIspZzrqKLT/INwHI
	inuGLg9MuWpMSARvE9OnEwXFFoZEsPqqq0YM5QRBfBZr9SO/6ibKDNasS4Kn9WrJ6vP1PSr
	+k1m3PysKWBweSXiDsclZ+dYvo7ZzxidPqQb+wAUap1mJFKT9yiUdDH8QdaezWGfHJPIovr
	P209YWrXeudQohaEPZeab4kSWgIrvrJwNMwAvy1rNNIUEKUt6D15m1vVw2W68hvCp0SIsHB
	b/bv/ydmNAeP+paRyIQSOa4s25vF1npNicn+mu7m7Kglym7l+RRlueNeCJzl/z758A7v3Qq
	hCdjmCRxQjKCmi1CDK
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

The word "as" in the comment should be replaced with "is",
and there is an extra space in the comment.

Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index d95761dcdd58..0adaa6150252 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -260,7 +260,7 @@ nvgrace_gpu_ioctl_get_region_info(struct vfio_device *core_vdev,
 	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 	/*
 	 * The region memory size may not be power-of-2 aligned.
-	 * Given that the memory  as a BAR and may not be
+	 * Given that the memory is a BAR and may not be
 	 * aligned, roundup to the next power-of-2.
 	 */
 	info.size = memregion->bar_size;
-- 
2.50.1


