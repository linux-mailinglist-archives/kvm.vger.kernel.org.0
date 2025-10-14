Return-Path: <kvm+bounces-59988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DD78BD71A4
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 04:36:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA4C6188DEC0
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 02:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785863043D4;
	Tue, 14 Oct 2025 02:36:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C07426E70B;
	Tue, 14 Oct 2025 02:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760409374; cv=none; b=ZX5RfcyHtIGUG6huazyW0QS7Q8xFbvTXgNhIWgglRoMSoLqNYDoZdkm4wM2tvnEtSq88k0Er+PO6MpXD7wHaBzkJYsNJFMEbl2B9Z0BYkIOwo5cLSNNvAYiOL6p8pbBnRq6L2qlrDqTKcCXUEr4qctk5AKnI4Wq95SyErAWEhR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760409374; c=relaxed/simple;
	bh=UOBLRDWP3KfLWh9KvekABQaGY+mxS8RLhrBRxuq5cqM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SCe52hZCH9jrOCwjjthrNJ5hdf+RwLif2aWWvlGrc8dacBzp3oEpIsie+eFmLC7AkiGaDcLGXe+r3AtvnKm8jlxzrR24to9203lwuQGcsYRL3BKatFJ5O9y0DSjTUtyGEhOnAqwpSo82v7mBQyGoPn6s+p7coDHNq+ZgEpL+Orc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from Jtjnmail201616.home.langchao.com
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id 202510141034531290;
        Tue, 14 Oct 2025 10:34:53 +0800
Received: from jtjnmailAR02.home.langchao.com (10.100.2.43) by
 Jtjnmail201616.home.langchao.com (10.100.2.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 14 Oct 2025 10:34:52 +0800
Received: from inspur.com (10.100.2.96) by jtjnmailAR02.home.langchao.com
 (10.100.2.43) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Tue, 14 Oct 2025 10:34:52 +0800
Received: from localhost.localdomain.com (unknown [10.94.17.151])
	by app1 (Coremail) with SMTP id YAJkCsDwEnbMtu1ojngWAA--.532S4;
	Tue, 14 Oct 2025 10:34:52 +0800 (CST)
From: Chu Guangqing <chuguangqing@inspur.com>
To: <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
	<martin.lau@linux.dev>, <eddyz87@gmail.com>, <song@kernel.org>,
	<yonghong.song@linux.dev>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
	<sdf@fomichev.me>, <haoluo@google.com>, <jolsa@kernel.org>,
	<kwankhede@nvidia.com>
CC: <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Chu Guangqing <chuguangqing@inspur.com>
Subject: [PATCH 0/5] Some spelling error fixes in samples directory
Date: Tue, 14 Oct 2025 10:34:45 +0800
Message-ID: <20251014023450.1023-1-chuguangqing@inspur.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: YAJkCsDwEnbMtu1ojngWAA--.532S4
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY97AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aV
	CY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAq
	x4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6x
	CaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwAC
	I402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AKxV
	W8ZVWrXwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQvtAUUUUU=
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/
X-CM-DELIVERINFO: =?B?Ux3sQJRRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3DYXJR7Zlh9zE0nt/Iac
	D+KbL+mgpZCA5XI2yvXw9hUGLYCkjExQ2ACPWY91Y3ubonMZ2Gz+fLeWXyfAFC8MhSS8+4
	d2r5OB+GZ4nMHdN3nYQ=
Content-Type: text/plain
tUid: 20251014103453247b529822dfc325ba2395e2ca27cfc9
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Fixes for some spelling errors in samples directory

Chu Guangqing (5):
  samples/bpf: Fix a spelling typo in do_hbm_test.sh
  samples: bpf: Fix a spelling typo in hbm.c
  samples/bpf: Fix a spelling typo in tracex1.bpf.c
  samples/bpf: Fix a spelling typo in tcp_cong_kern.c
  vfio-mdev: Fix a spelling typo in mtty.c

 samples/bpf/do_hbm_test.sh  | 2 +-
 samples/bpf/hbm.c           | 4 ++--
 samples/bpf/tcp_cong_kern.c | 2 +-
 samples/bpf/tracex1.bpf.c   | 2 +-
 samples/vfio-mdev/mtty.c    | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.47.3


