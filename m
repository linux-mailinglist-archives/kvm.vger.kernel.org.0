Return-Path: <kvm+bounces-59985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 36618BD7192
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 04:35:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 48D724F6846
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 02:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CAB830498E;
	Tue, 14 Oct 2025 02:35:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5741DF256;
	Tue, 14 Oct 2025 02:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.61.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760409310; cv=none; b=VQVT5wLP9bx5b6ZyLBI2DCksZ1Y/RY3JYPB7wS4DD+eg0F8JV51mfANUTaT8yeoVnzaadFWPIaqugEaC0iNLsZ1gct3UuUvRBl71kHPij1PNCqy7hcUJA7/7OfE+2V8jEza1RMoJ5EFqMAqZbacG3l0CcjxjOiePeiLERn0jeSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760409310; c=relaxed/simple;
	bh=Dsl+ppQ40/CYjnrB+7jH+7NBjXSN4KEJWKp3vQhFqJM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KdBGzaraj7DZuGjOoz6g8SX2YUCpgF/qGnRyDSYqNGp0pibqGhL4bfQclbVTK0IeprF5ki6PH6a40cg9fC+N+aVevicyOWLetyQv9kPEmtP8escjz9HAUv41/c56r0E2LR+HgASdF8WRLIP3qLS2PIxngD6/1tHykq5g7wCkWhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.61.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from Jtjnmail201615.home.langchao.com
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id 202510141034552059;
        Tue, 14 Oct 2025 10:34:55 +0800
Received: from jtjnmailAR01.home.langchao.com (10.100.2.42) by
 Jtjnmail201615.home.langchao.com (10.100.2.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 14 Oct 2025 10:34:53 +0800
Received: from inspur.com (10.100.2.96) by jtjnmailAR01.home.langchao.com
 (10.100.2.42) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Tue, 14 Oct 2025 10:34:53 +0800
Received: from localhost.localdomain.com (unknown [10.94.17.151])
	by app1 (Coremail) with SMTP id YAJkCsDwEnbMtu1ojngWAA--.532S7;
	Tue, 14 Oct 2025 10:34:53 +0800 (CST)
From: Chu Guangqing <chuguangqing@inspur.com>
To: <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
	<martin.lau@linux.dev>, <eddyz87@gmail.com>, <song@kernel.org>,
	<yonghong.song@linux.dev>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
	<sdf@fomichev.me>, <haoluo@google.com>, <jolsa@kernel.org>,
	<kwankhede@nvidia.com>
CC: <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Chu Guangqing <chuguangqing@inspur.com>
Subject: [PATCH 3/5] samples/bpf: Fix a spelling typo in tracex1.bpf.c
Date: Tue, 14 Oct 2025 10:34:48 +0800
Message-ID: <20251014023450.1023-4-chuguangqing@inspur.com>
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
X-CM-TRANSID: YAJkCsDwEnbMtu1ojngWAA--.532S7
X-Coremail-Antispam: 1UD129KBjvdXoW7JF1kXr1DCF1kZrWDtrWxXrb_yoW3Arc_Ja
	1jyFs5W3yfGF93u3W3Kr48Jryaqas5uw4xGrZaqrWjyFykX3yUGr98Wrn8GF9rWFyq9Fy5
	C3s7WryvvF4SgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbQ8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E
	0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67
	AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48I
	cxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxw
	CY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AKxVW8
	ZVWrXwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRM6wCDUUUU
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/
X-CM-DELIVERINFO: =?B?Mo3z55RRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3DYXJR7Zlh9zE0nt/Iac
	D+KYA+Jq5OWNxdfsSe4BPqWgXYCkjExQ2ACPWY91Y3ubonMZ2Gz+fLeWXyfAFC8MhSS7Ce
	Kqlm1JVsBrK1cRqTR5M=
Content-Type: text/plain
tUid: 20251014103455d2a04ee300db82bfda9dcb30098aeeb4
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

This patch fixes a spelling typo in tracex1.bpf.c

Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
---
 samples/bpf/tracex1.bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/tracex1.bpf.c b/samples/bpf/tracex1.bpf.c
index 0ab39d76ff8f..ceedf0b1d479 100644
--- a/samples/bpf/tracex1.bpf.c
+++ b/samples/bpf/tracex1.bpf.c
@@ -20,7 +20,7 @@ SEC("kprobe.multi/__netif_receive_skb_core*")
 int bpf_prog1(struct pt_regs *ctx)
 {
 	/* attaches to kprobe __netif_receive_skb_core,
-	 * looks for packets on loobpack device and prints them
+	 * looks for packets on loopback device and prints them
 	 * (wildcard is used for avoiding symbol mismatch due to optimization)
 	 */
 	char devname[IFNAMSIZ];
-- 
2.47.3


