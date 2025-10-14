Return-Path: <kvm+bounces-59986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3C0BD7195
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 04:35:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5B87B3501F4
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 02:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3AEC305059;
	Tue, 14 Oct 2025 02:35:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6761F4E4F;
	Tue, 14 Oct 2025 02:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760409313; cv=none; b=EtoJpjNnMEfE8HFZ7DhWm0jnmFgg2h89+kCthib+42IKFQILiT/2WCcLStAtY0MiDWvuBJ8l4CDFtE6EksIHQfr1HoPmyDg24OWFX4+UNQqCpU5++8C/OXlbRFgRRUEyhIQj2AAJoAHivxADLvldOFPeFX5bSw0F8dM7h3dO6vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760409313; c=relaxed/simple;
	bh=NiqeanATw1cugyYWj5jjTz0PV2cD6FSlUZyPNrszcXQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2qfmuWSOl5P+NNLu8FHFN5QXCoevL4FLlHf7siNFBAlOQH8C00XMXZBYXJNpO/yG6YMcba5vTDhZa3RNij504Jw3rsTZR6GKIkCwYnsp/23QqUFYjAhjADv7ugLsnghs9mk2EvL4AL1pdEn4Rt2bJmjRiu26kNvvFCa3ATuXXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from Jtjnmail201616.home.langchao.com
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id 202510141034541324;
        Tue, 14 Oct 2025 10:34:54 +0800
Received: from jtjnmailAR02.home.langchao.com (10.100.2.43) by
 Jtjnmail201616.home.langchao.com (10.100.2.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 14 Oct 2025 10:34:53 +0800
Received: from inspur.com (10.100.2.96) by jtjnmailAR02.home.langchao.com
 (10.100.2.43) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Tue, 14 Oct 2025 10:34:53 +0800
Received: from localhost.localdomain.com (unknown [10.94.17.151])
	by app1 (Coremail) with SMTP id YAJkCsDwEnbMtu1ojngWAA--.532S6;
	Tue, 14 Oct 2025 10:34:53 +0800 (CST)
From: Chu Guangqing <chuguangqing@inspur.com>
To: <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
	<martin.lau@linux.dev>, <eddyz87@gmail.com>, <song@kernel.org>,
	<yonghong.song@linux.dev>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
	<sdf@fomichev.me>, <haoluo@google.com>, <jolsa@kernel.org>,
	<kwankhede@nvidia.com>
CC: <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Chu Guangqing <chuguangqing@inspur.com>
Subject: [PATCH 2/5] samples: bpf: Fix a spelling typo in hbm.c
Date: Tue, 14 Oct 2025 10:34:47 +0800
Message-ID: <20251014023450.1023-3-chuguangqing@inspur.com>
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
X-CM-TRANSID: YAJkCsDwEnbMtu1ojngWAA--.532S6
X-Coremail-Antispam: 1UD129KBjvdXoW7XFyrXFWUur1DJw1rKFyUWrg_yoWDtFc_u3
	ySgFyvy3yfAryrZFn0kryfKF9Iqayqg3W8ArZIqr4jyFy5Zwn8GFWkCr9xWa4UZFW3uF9x
	GwnaqFy5urW2qjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbQ8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXwA2048vs2IY02
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
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRNiSHDUUUU
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/
X-CM-DELIVERINFO: =?B?t8yztJRRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3DYXJR7Zlh9zE0nt/Iac
	D+KYgFPZXSZUpxqX52WkjH2ZbYCkjExQ2ACPWY91Y3ubonMZ2Gz+fLeWXyfAFC8MhSSxtq
	+cAQZu3qoiZo4NG89ls=
Content-Type: text/plain
tUid: 20251014103455d2a04ee300db82bfda9dcb30098aeeb4
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

This patch fixes a spelling typo in hbm.c

Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
---
 samples/bpf/hbm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
2.47.3


