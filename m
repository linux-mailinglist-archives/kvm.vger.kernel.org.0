Return-Path: <kvm+bounces-51880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D5FAFE092
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 895377B86D0
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 06:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13B726CE04;
	Wed,  9 Jul 2025 06:50:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40BB29B0;
	Wed,  9 Jul 2025 06:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752043829; cv=none; b=ijMI76LCAWjV/Zg0UO3z24L7jGHG0PTeOxO0yvM5lUB6zPnj6N1QNEWOXg+X+t7qJ9RqggSbN88LUhjMrR2+Gv9azEY6PmXtkck5LG1cHbf0iqghQNMaerWe1vncjjQ3l3J7ktjvCf3HKJYE/KwhO+xukxVfSN5bw6AaBEDcsjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752043829; c=relaxed/simple;
	bh=4MHCMXqkaf7S/tE0zRVKzQ5WFpevnAtw1v2rwPlBjVA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rpguwynZQEO+K2TEZvrqccwa1BBGHKgphDVIaJ2YGrk/96tMvMrm8S1qjedp0/PDZGHENytOLR5VJ9NRPE+0ihT2Njz8E1ho0VmtipI04xnmlsuUOL83DvUjHMz04tTwUwTyEV1vGyHYRY9ydd+hpj8yKcj+Q5YJo+W9oCFHUHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bcT980wTkztSlX;
	Wed,  9 Jul 2025 14:49:16 +0800 (CST)
Received: from kwepemf200001.china.huawei.com (unknown [7.202.181.227])
	by mail.maildlp.com (Postfix) with ESMTPS id AA188140203;
	Wed,  9 Jul 2025 14:50:22 +0800 (CST)
Received: from kwepemf200001.china.huawei.com (7.202.181.227) by
 kwepemf200001.china.huawei.com (7.202.181.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 9 Jul 2025 14:50:22 +0800
Received: from kwepemf200001.china.huawei.com ([7.202.181.227]) by
 kwepemf200001.china.huawei.com ([7.202.181.227]) with mapi id 15.02.1544.011;
 Wed, 9 Jul 2025 14:50:22 +0800
From: "zoudongjie (A)" <zoudongjie@huawei.com>
To: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Chenzhendong (alex)" <alex.chen@huawei.com>, luolongmin
	<luolongmin@huawei.com>, "Mujinsheng (DxJanesir)" <mujinsheng@huawei.com>,
	"chenjianfei (D)" <chenjianfei3@huawei.com>, "Fangyi (Eric)"
	<eric.fangyi@huawei.com>, "lishan (E)" <lishan24@huawei.com>, Renxuming
	<renxuming@huawei.com>, suxiaodong <suxiaodong1@huawei.com>, "caijunjie (A)"
	<caijunjie15@h-partners.com>, "zoudongjie (A)" <zoudongjie@huawei.com>
Subject: [v2] KVM: x86: Question on lock protection in handle_ept_misconfig
Thread-Topic: [v2] KVM: x86: Question on lock protection in
 handle_ept_misconfig
Thread-Index: AdvwnWLWK0cIKxYnTaSRFSLUUanbNQ==
Date: Wed, 9 Jul 2025 06:50:22 +0000
Message-ID: <32045ab842954dd5867b55ee965ffcc7@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Resending as plain text to fix formatting issues.
---

Hi all,

I noticed that in handle_ept_misconfig(), kvm_io_bus_write() is called. And=
=20
within kvm_io_bus_write(), BUS is obtained through srcu_dereference(). Duri=
ng=20
this process, kvm->slots_lock is not acquired, nor is srcu_read_lock() call=
ed=20
for protection. If another process is synchronizing BUS at the same time,=20
synchronize_srcu_expedited() cannot safely reclaim space(it cannot protect=
=20
srcu_dereference() outside the critical section?), how can we ensure that B=
US=20
obtained by kvm_io_bus_write() is the latest?

Thanks,
Junjie Cai

Reported by: Junjie Cai <mailto:caijunjie15@h-partners.com>


