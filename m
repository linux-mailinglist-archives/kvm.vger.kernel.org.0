Return-Path: <kvm+bounces-59989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B701BD71B0
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 04:36:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25CE41891D20
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 02:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06F5304BC4;
	Tue, 14 Oct 2025 02:36:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DCA304BC1;
	Tue, 14 Oct 2025 02:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760409380; cv=none; b=N2JIvoqVAYHPQpr1RjMbqMINli16xFfAha3xAZg+wWVd36CHukCyXKEk1UGlUBz0Z4+kylsyy3W1sgEizYPRkmkV3hnrZBS578mxjqxeSVnAqFpSGyUqj2Cd6CZcTF0PQiFLdY2dxQnYpjS4JsABRAHGyfBHK+m0AdXgQArYVoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760409380; c=relaxed/simple;
	bh=KTYWcpDSD9LDHcrOTKXWXnrwHPWqYzkLX4imcf2IfHM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OsDGiuXUrBScuOTIpA5FqVJHbtZU4XLPEGwS+NzqrPf4R7IOZ0cn3qmoiGR5llULcdXNOGbiRQx1aJgct6UKoIv7sUYjPBOt37BI2o76rrQTyrNLHxbG3/OE+8rwsaRpy3iwD6o2g18iynQn+yLPSdMfLwqGMtANZSbKOb0PXr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from Jtjnmail201616.home.langchao.com
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id 202510141034561351;
        Tue, 14 Oct 2025 10:34:56 +0800
Received: from jtjnmailAR02.home.langchao.com (10.100.2.43) by
 Jtjnmail201616.home.langchao.com (10.100.2.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 14 Oct 2025 10:34:54 +0800
Received: from inspur.com (10.100.2.96) by jtjnmailAR02.home.langchao.com
 (10.100.2.43) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Tue, 14 Oct 2025 10:34:54 +0800
Received: from localhost.localdomain.com (unknown [10.94.17.151])
	by app1 (Coremail) with SMTP id YAJkCsDwEnbMtu1ojngWAA--.532S8;
	Tue, 14 Oct 2025 10:34:53 +0800 (CST)
From: Chu Guangqing <chuguangqing@inspur.com>
To: <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
	<martin.lau@linux.dev>, <eddyz87@gmail.com>, <song@kernel.org>,
	<yonghong.song@linux.dev>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
	<sdf@fomichev.me>, <haoluo@google.com>, <jolsa@kernel.org>,
	<kwankhede@nvidia.com>
CC: <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Chu Guangqing <chuguangqing@inspur.com>
Subject: [PATCH 4/5] samples/bpf: Fix a spelling typo in tcp_cong_kern.c
Date: Tue, 14 Oct 2025 10:34:49 +0800
Message-ID: <20251014023450.1023-5-chuguangqing@inspur.com>
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
X-CM-TRANSID: YAJkCsDwEnbMtu1ojngWAA--.532S8
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr4DKr4UGFW3Gw1xKw43trb_yoW3Xrg_Zr
	4rtFWktr98XFyYvF1Ygr47tFySg3y5uFW8Gr4DJryjy3Z5ZFWDXr93ZryDu3s7Wws0ka47
	uwnaqry5Zr1a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbQAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
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
	cVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0x
	vE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
	6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRNdb1DUUUU
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/
X-CM-DELIVERINFO: =?B?+lw6ZJRRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3DYXJR7Zlh9zE0nt/Iac
	D+KZ+xhDL0iWWlVse5jThrzF3YCkjExQ2ACPWY91Y3ubonMZ2Gz+fLeWXyfAFC8MhSS5Y6
	PeMXpIiD44fF4p7fh+g=
Content-Type: text/plain
tUid: 20251014103456d8c47a85b1908007157f9622855fc38b
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

This patch fixes a spelling typo in tcp_cong_kern.c

Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
---
 samples/bpf/tcp_cong_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.47.3


