Return-Path: <kvm+bounces-60003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02DEBBD804A
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 09:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C81D3AF2A2
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 07:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC4C30EF67;
	Tue, 14 Oct 2025 07:54:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2731A25F7B9;
	Tue, 14 Oct 2025 07:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760428484; cv=none; b=cAvyaLvvJv0NKOcXk4r/lYrrp/Lbxf5r4u6vjAmSh5VlQaQ71KUuBFF+qSFMKlRUy2DLU7f9IEbsvPnlbkBzVUUS0glbGlxs+/EceBl9uKCwhT53LT0l3r84hiP/nN6LFYn0w2F9u0CjlSsuxwHzaTLJXTCruleUhZ353P/sJEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760428484; c=relaxed/simple;
	bh=IHowtJL9x/C0CNs0hMFB5pFinod+WpZOHGrarKvYLg4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qhPAjsWzO/jAJp3wrvbCh2+Ml/aloUQqgHTcxvPuSo62LIi/YiubIa1l/l4Sx4qBvZMyoLpI99qkJU71t7UacUBzIrCNa81pok8C77HWTLqwbOdDVk4dJne2kk9g4Es/CQ3ateHudvIhrecqjpxo49LeI5btc7EieArwV4nbfe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from Jtjnmail201617.home.langchao.com
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id 202510141554357964;
        Tue, 14 Oct 2025 15:54:35 +0800
Received: from jtjnmailAR01.home.langchao.com (10.100.2.42) by
 Jtjnmail201617.home.langchao.com (10.100.2.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 14 Oct 2025 15:54:33 +0800
Received: from inspur.com (10.100.2.96) by jtjnmailAR01.home.langchao.com
 (10.100.2.42) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Tue, 14 Oct 2025 15:54:33 +0800
Received: from localhost.localdomain.com (unknown [10.94.17.151])
	by app1 (Coremail) with SMTP id YAJkCsDwHnW5Ae5okzMXAA--.475S4;
	Tue, 14 Oct 2025 15:54:33 +0800 (CST)
From: Chu Guangqing <chuguangqing@inspur.com>
To: <menglong.dong@linux.dev>
CC: <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
	<martin.lau@linux.dev>, <eddyz87@gmail.com>, <song@kernel.org>,
	<yonghong.song@linux.dev>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
	<sdf@fomichev.me>, <haoluo@google.com>, <jolsa@kernel.org>,
	<kwankhede@nvidia.com>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Chu Guangqing
	<chuguangqing@inspur.com>
Subject: Re: Re: [PATCH v2 1/1] samples/bpf: Fix spelling typo in samples/bpf
Date: Tue, 14 Oct 2025 15:54:32 +0800
Message-ID: <20251014075432.4616-1-chuguangqing@inspur.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <2240784.irdbgypaU6@7950hx>
References: <2240784.irdbgypaU6@7950hx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: YAJkCsDwHnW5Ae5okzMXAA--.475S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Jr13AF1kuFyUGrWfuw17Wrg_yoWfKFc_CF
	WrX3WIgw1FqF92gF4DKr4akF9Fqan8GF4kKrW7KF9a9a4fZa42grs8Jr9akry3JF1FgFs8
	Cr98ArZ5ur4agjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3xFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_GcCE
	3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
	1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
	cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8Jw
	ACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Wrv_ZF1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvf
	C2KfnxnUUI43ZEXa7sRE7KsUUUUUU==
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/
X-CM-DELIVERINFO: =?B?V25H1ZRRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3DYXJR7Zlh9zE0nt/Iac
	D+KckP+73ep6YA/20aTWJzPEq6pcKtwPV6Py4eQNgt9jBJdEMhMKF+5PXuxwTu4c+i0o9N
	Y8ndwUurIWbkKXW3rQc=
Content-Type: text/plain
tUid: 2025101415543592d11fdd3ff225cd5039d6b024b7b8c3
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Hi Menglong,

>The change log is preferred when you send a new version, which
>can make people know the difference in this version quickly. It
>could follow the SOB like this:
>
>Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
>---
>v2:
>- xxx
>---
There are no other changes in Version 2 except that all (relevant fixes) have been combined into a single patch.

v1:
 - https://lore.kernel.org/all/20251014023450.1023-1-chuguangqing@inspur.com/

>You titled the patch "samples/bpf: Fix spelling typo in samples/bpf",
>but this file is not in the samples/bpf, right? So I think we'd better
>split it out.
In version 1, someone requested "One patch for all typos".
Please refer to this email.
https://lore.kernel.org/all/CAADnVQKMgbDV2poeHYmJg0=GD-F2zDTcjSxcUDZSO3Y5EwD17Q@mail.gmail.com/

>BTW, "Guangqing Chu" will be better, according to the habit :)
I prefer using the current spelling order.

Best regards
Chu Guangqing


