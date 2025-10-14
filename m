Return-Path: <kvm+bounces-59993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 120F1BD7882
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 08:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 39B5B4E5E66
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 06:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA3E30C631;
	Tue, 14 Oct 2025 06:09:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E14721ABD0;
	Tue, 14 Oct 2025 06:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760422141; cv=none; b=isiKQ+dzN2y9kCXjmrjyg+05pPul8mBQVzJ3p4ZEE/TVqsz1I1kA46stU7Ayz247VXxK/E5oYoQYJXjoCuiSYgZaM27ZH2/fPEWeFwf2b9CpIZL6pSbbR5LCpWkLg6xfGDNSeJEhqnydpzuYpQr1Ye5Dg+g2ID+gxMbqSfuIbYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760422141; c=relaxed/simple;
	bh=8MAfBChkzlsQKc7cXfRZuprMVR1rdt6h+eePGWaejB0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1qzyLxLYEztJwsJ/VxXT16NPEQlByYBuHPIFe6PCYmv2Yy0eahc8u7EvsMzG0eyM2vb701+dun4bJf7tQXLe/VMPplB4dfn+DgtN2hh0A1tqz4VVwtxXK8mpTo0apjr2Ih/cgELiqzpba4YIAWXLM+/TY8UAoFPiPMyPgdG8HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from Jtjnmail201617.home.langchao.com
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id 202510141408523858;
        Tue, 14 Oct 2025 14:08:52 +0800
Received: from jtjnmailAR02.home.langchao.com (10.100.2.43) by
 Jtjnmail201617.home.langchao.com (10.100.2.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 14 Oct 2025 14:08:52 +0800
Received: from inspur.com (10.100.2.96) by jtjnmailAR02.home.langchao.com
 (10.100.2.43) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Tue, 14 Oct 2025 14:08:52 +0800
Received: from localhost.localdomain.com (unknown [10.94.17.151])
	by app1 (Coremail) with SMTP id YAJkCsDwHnXz6O1oTdkWAA--.474S5;
	Tue, 14 Oct 2025 14:08:52 +0800 (CST)
From: Chu Guangqing <chuguangqing@inspur.com>
To: <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
	<martin.lau@linux.dev>, <eddyz87@gmail.com>, <song@kernel.org>,
	<yonghong.song@linux.dev>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
	<sdf@fomichev.me>, <haoluo@google.com>, <jolsa@kernel.org>,
	<kwankhede@nvidia.com>
CC: <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Chu Guangqing <chuguangqing@inspur.com>
Subject: [PATCH v2 1/1] samples/bpf: Fix spelling typo in samples/bpf
Date: Tue, 14 Oct 2025 14:08:49 +0800
Message-ID: <20251014060849.3074-2-chuguangqing@inspur.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20251014060849.3074-1-chuguangqing@inspur.com>
References: <20251014060849.3074-1-chuguangqing@inspur.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: YAJkCsDwHnXz6O1oTdkWAA--.474S5
X-Coremail-Antispam: 1UD129KBjvJXoWxCr4rGF17Wr1UZF4fCw4fAFb_yoWrJFWDpF
	4kWa4xKFnYvr17WF9rZF48Ww1avwn3WrW7Gr4Fvry5J3ZIgF95JFW5try5trs8JFW3Aa9I
	qF4qg345Wa4rW37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHvb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY
	1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4
	xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCa
	FVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI4
	02YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCF
	54CYxVCY1x0262kKe7AKxVW8ZVWrXwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wryl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjTRwL
	0rUUUUU
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/
X-CM-DELIVERINFO: =?B?XIdzPZRRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3DYXJR7Zlh9zE0nt/Iac
	D+KdD34qlwgDMhQUTbe3jVCvDTH8BjlZN8Xb40qGeYEZWaGDDKkVxAZIy3q7TL3FM6J9Iw
	tMf1kD17Bf48WbbH5tA=
Content-Type: text/plain
tUid: 202510141408527be03802e14eed88f509fc0e8fe5cc88
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

do_hbm_test.sh:
The comment incorrectly used "upcomming" instead of "upcoming".

hbm.c
The comment incorrectly used "Managment" instead of "Management".
The comment incorrectly used "Currrently" instead of "Currently".

tcp_cong_kern.c
The comment incorrectly used "deteremined" instead of "determined".

tracex1.bpf.c
The comment incorrectly used "loobpack" instead of "loopback".

mtty.c
The comment incorrectly used "atleast" instead of "at least".

Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
---
 samples/bpf/do_hbm_test.sh  | 2 +-
 samples/bpf/hbm.c           | 4 ++--
 samples/bpf/tcp_cong_kern.c | 2 +-
 samples/bpf/tracex1.bpf.c   | 2 +-
 samples/vfio-mdev/mtty.c    | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/do_hbm_test.sh b/samples/bpf/do_hbm_test.sh
index 38e4599350db..7f4f722787d5 100755
--- a/samples/bpf/do_hbm_test.sh
+++ b/samples/bpf/do_hbm_test.sh
@@ -112,7 +112,7 @@ function start_hbm () {
 processArgs () {
   for i in $args ; do
     case $i in
-    # Support for upcomming ingress rate limiting
+    # Support for upcoming ingress rate limiting
     #in)         # support for upcoming ingress rate limiting
     #  dir="-i"
     #  dir_name="in"
diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index bf66277115e2..fc88d4dbdf48 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -5,7 +5,7 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  *
- * Example program for Host Bandwidth Managment
+ * Example program for Host Bandwidth Management
  *
  * This program loads a cgroup skb BPF program to enforce cgroup output
  * (egress) or input (ingress) bandwidth limits.
@@ -24,7 +24,7 @@
  *		beyond the rate limit specified while there is available
  *		bandwidth. Current implementation assumes there is only
  *		NIC (eth0), but can be extended to support multiple NICs.
- *		Currrently only supported for egress.
+ *		Currently only supported for egress.
  *    -h	Print this info
  *    prog	BPF program file name. Name defaults to hbm_out_kern.o
  */
diff --git a/samples/bpf/tcp_cong_kern.c b/samples/bpf/tcp_cong_kern.c
index 2311fc9dde85..339415eac477 100644
--- a/samples/bpf/tcp_cong_kern.c
+++ b/samples/bpf/tcp_cong_kern.c
@@ -5,7 +5,7 @@
  * License as published by the Free Software Foundation.
  *
  * BPF program to set congestion control to dctcp when both hosts are
- * in the same datacenter (as deteremined by IPv6 prefix).
+ * in the same datacenter (as determined by IPv6 prefix).
  *
  * Use "bpftool cgroup attach $cg sock_ops $prog" to load this BPF program.
  */
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


