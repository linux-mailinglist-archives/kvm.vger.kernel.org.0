Return-Path: <kvm+bounces-59987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52412BD71A1
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 04:36:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3411E421FE7
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 02:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA2043054D1;
	Tue, 14 Oct 2025 02:35:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EC430506A;
	Tue, 14 Oct 2025 02:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.61.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760409316; cv=none; b=TwdXiNVtb0r6eWcuO7x0/AleoawAwrlb0TlOrKaTxnEb3hYvHMNmOc9Rge0weNtQKKJQLs6vwAWsXA3CiHhRNPwyAlOYcxov1Y7QeoCp/1zUN+NIN/+MoHxHxAjhvdvqRPrUzqeMnfwDDG9oBTCzxsbN3GVDvlJ8sUwHit0i0dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760409316; c=relaxed/simple;
	bh=jxtgSP2an8+vzF7bbvxXvIhDHf2SilUuBSKTbgnMaFI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PV4kzIypphN6VUphG8LEeTj49myri349ULVsa4iLgCEBDJtZmzaYSOKVR/NTH/9H8BRxHylrtySgulLi7z+cUToZz2e91G43R94Qkx1xKubRPJNg5lwKoAyVfRQk0bnALHbcvBxr3GKtpD6ZYMfKBHBYNXR2LB7fDbiNy15xe4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.61.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from Jtjnmail201615.home.langchao.com
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id 202510141034562096;
        Tue, 14 Oct 2025 10:34:56 +0800
Received: from jtjnmailAR01.home.langchao.com (10.100.2.42) by
 Jtjnmail201615.home.langchao.com (10.100.2.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 14 Oct 2025 10:34:54 +0800
Received: from inspur.com (10.100.2.96) by jtjnmailAR01.home.langchao.com
 (10.100.2.42) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Tue, 14 Oct 2025 10:34:54 +0800
Received: from localhost.localdomain.com (unknown [10.94.17.151])
	by app1 (Coremail) with SMTP id YAJkCsDwEnbMtu1ojngWAA--.532S9;
	Tue, 14 Oct 2025 10:34:54 +0800 (CST)
From: Chu Guangqing <chuguangqing@inspur.com>
To: <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
	<martin.lau@linux.dev>, <eddyz87@gmail.com>, <song@kernel.org>,
	<yonghong.song@linux.dev>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
	<sdf@fomichev.me>, <haoluo@google.com>, <jolsa@kernel.org>,
	<kwankhede@nvidia.com>
CC: <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Chu Guangqing <chuguangqing@inspur.com>
Subject: [PATCH 5/5] vfio-mdev: Fix a spelling typo in mtty.c
Date: Tue, 14 Oct 2025 10:34:50 +0800
Message-ID: <20251014023450.1023-6-chuguangqing@inspur.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20251014023450.1023-1-chuguangqing@inspur.com>
References: <20251014023450.1023-1-chuguangqing@inspur.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: YAJkCsDwEnbMtu1ojngWAA--.532S9
X-Coremail-Antispam: 1UD129KBjvdXoW7GryxJr1xZF17Kw48CrW8Crg_yoWxtrX_Gw
	40va1kZ34DJr40qr9rArW8Kwsrt3Z5W3Z7GrZIgF1jyF4rAa98CrnFqFyDGryUuFy2k3W5
	Ars8Wry2vF1jkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbHxFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3w
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AK
	xVW8ZVWrXwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I
	0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAI
	cVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42
	IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280
	aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/
X-CM-DELIVERINFO: =?B?A5GlGJRRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3DYXJR7Zlh9zE0nt/Iac
	D+KfTPijyFNFl/yRi4FR+PfFXYCkjExQ2ACPWY91Y3ubonMZ2Gz+fLeWXyfAFC8MhSSy1p
	y0AlLiU5aUkr8qT9/NM=
Content-Type: text/plain
tUid: 20251014103456d8c47a85b1908007157f9622855fc38b
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

This patch fixes a spelling typo in mtty.c

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
2.47.3


