Return-Path: <kvm+bounces-60055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FA09BDC180
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 04:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C40F74F6B9B
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 02:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1331230BBA5;
	Wed, 15 Oct 2025 02:00:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D803328751D;
	Wed, 15 Oct 2025 02:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.61.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760493658; cv=none; b=Hp5ry/7AcpS0teq6CsvYHVOEOCqgBvEl81ld/nqHnbJAXBGwQSMeYh2GO4K4KKVVvUEI3PdRiJhukQxXr2tsSu1/2TxxrJ0GBVRS/X9HAm3p73h1ETMHw6lsubNU4OpBu6Tbr3PBfXqshyoC6wmWpMdPJcBnz3BpmiJiXkGzLx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760493658; c=relaxed/simple;
	bh=8HlwfC1P14GCBNd9+4iSjgeCTAKOtiW08tjD+3oWpcA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kYUHfMix9KYVQinuLRkNEzdjl3oxDV2D3ogCBEIrFi2q3nq22TiFgQ3RKDpwS98lxfZfxThzfFlRnnwd6Q+WyhQ7uQKmh9wNm+1ClA1YVyAEGXB4hIvdSZE5IzZY1quxax8cv4nhk3CoIXa0WNZogdi3ZJig8n1/AzgPEo7nnX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.61.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from Jtjnmail201613.home.langchao.com
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id 202510151000413749;
        Wed, 15 Oct 2025 10:00:41 +0800
Received: from jtjnmailAR01.home.langchao.com (10.100.2.42) by
 Jtjnmail201613.home.langchao.com (10.100.2.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 15 Oct 2025 10:00:41 +0800
Received: from inspur.com (10.100.2.108) by jtjnmailAR01.home.langchao.com
 (10.100.2.42) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Wed, 15 Oct 2025 10:00:41 +0800
Received: from localhost.localdomain.com (unknown [10.94.16.205])
	by app4 (Coremail) with SMTP id bAJkCsDwRLVIAO9oJb4JAA--.1703S5;
	Wed, 15 Oct 2025 10:00:41 +0800 (CST)
From: Chu Guangqing <chuguangqing@inspur.com>
To: <kwankhede@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Chu Guangqing
	<chuguangqing@inspur.com>
Subject: [PATCH v3 1/1] vfio/mtty: Fix spelling typo in samples/vfio-mdev
Date: Wed, 15 Oct 2025 09:59:54 +0800
Message-ID: <20251015015954.2363-2-chuguangqing@inspur.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20251015015954.2363-1-chuguangqing@inspur.com>
References: <20251015015954.2363-1-chuguangqing@inspur.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: bAJkCsDwRLVIAO9oJb4JAA--.1703S5
X-Coremail-Antispam: 1UD129KBjvdXoWruw18Ar1rXryDXw1rWw17Wrg_yoW3JFX_Kw
	40vr4kZ34DJFs2qr9rArWFgwsrt3WrW3Z7KFZIgFy0yF4rAa98urnFqFyDGryUuFW2k3W5
	Ars8Gry2v3W0kjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb-8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGwA2048vs2IY02
	0Ec7CjxVAFwI0_Jrv_JF4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E
	0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67
	AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48I
	cxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCFx2IqxV
	CFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r10
	6r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxV
	WUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UYxBIdaVFxhVjvjDU0xZFpf9x0JUC-eOUUUUU=
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/
X-CM-DELIVERINFO: =?B?YoIoAJRRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3DYXJR7Zlh9zE0nt/Iac
	D+KZx0v0U7XsJAfJ83JoMh0xXhmP1DiyZeOIe5ZDWagPqcMm4TJJGdl0nV0olMO4yl5xxS
	wNVnDUZlPiLKO1VAl18=
Content-Type: text/plain
tUid: 202510151000419e40d9317aa52ceeb02458e9441451d7
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

mtty.c
The comment incorrectly used "atleast" instead of "at least".

Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
---
 samples/vfio-mdev/mtty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 59eefe2fed10..6cb3e5974990 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -624,7 +624,7 @@ static void handle_bar_read(unsigned int index, struct mdev_state *mdev_state,
 		u8 lsr = 0;
 
 		mutex_lock(&mdev_state->rxtx_lock);
-		/* atleast one char in FIFO */
+		/* at least one char in FIFO */
 		if (mdev_state->s[index].rxtx.head !=
 				 mdev_state->s[index].rxtx.tail)
 			lsr |= UART_LSR_DR;
-- 
2.43.7


