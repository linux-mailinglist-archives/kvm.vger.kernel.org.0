Return-Path: <kvm+bounces-51877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06749AFDFF6
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09699583996
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 06:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7EA326B763;
	Wed,  9 Jul 2025 06:32:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F6AAD24;
	Wed,  9 Jul 2025 06:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752042743; cv=none; b=Bc0sLMWF31J4ADUtAIigEtjPABjhSuhgtReJB83DvvLDa3RGmzyAMZiCibQXFz3kY26pH+Xu4g76qNj/sUdLtiuH77zpm5u0rtjqbTjX4Yuy6SB+HMBAecMYgnRyYxG5Joelwjhilo2pVms942Hi7tOoy6rP+JPUQinAN2MTgNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752042743; c=relaxed/simple;
	bh=q1U+t6Ii5aeoFkvUnZ2zs/IVM7dcMQaRkLjzJEhI8ig=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=n+EzQd0XoJvHrB+62GJ36ouMfLmP8TG66iQ0Lw4ha+E0ZIHzdErtCWFcdA0T7WYlIJQhpgHBzdziFKFhoBb9Dn6kgpumuYy6ENkCK3ChdvqX/dLgqOZBqHYF1jUSWOtWkDhIHr4Z7/LDgd712wAtWjPKmuda2PPSiVGnvf7xxoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bcSgz3b0nz14Lw0;
	Wed,  9 Jul 2025 14:27:27 +0800 (CST)
Received: from kwepemf200001.china.huawei.com (unknown [7.202.181.227])
	by mail.maildlp.com (Postfix) with ESMTPS id 11A6D140276;
	Wed,  9 Jul 2025 14:32:11 +0800 (CST)
Received: from kwepemf200001.china.huawei.com (7.202.181.227) by
 kwepemf200001.china.huawei.com (7.202.181.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 9 Jul 2025 14:32:10 +0800
Received: from kwepemf200001.china.huawei.com ([7.202.181.227]) by
 kwepemf200001.china.huawei.com ([7.202.181.227]) with mapi id 15.02.1544.011;
 Wed, 9 Jul 2025 14:32:10 +0800
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
Subject: [Question Consultation] KVM: x86: No lock protection was applied in
 handle_ept_misconfig of kernel 5.10?
Thread-Topic: [Question Consultation] KVM: x86: No lock protection was applied
 in handle_ept_misconfig of kernel 5.10?
Thread-Index: AdvwmysH5iR6pwV4RYCRGxU31n/Lbw==
Date: Wed, 9 Jul 2025 06:32:10 +0000
Message-ID: <fb4c14aa629a4dddb44d0fa9c4f7b498@huawei.com>
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

Hi all,

I noticed that in handle_ept_misconfig(), kvm_io_bus_write() is called. And=
 within kvm_io_bus_write(), BUS is obtained
through srcu_dereference(). During this process, kvm->slots_lock is not acq=
uired, nor is srcu_read_lock() called for=20
protection. If another process is synchronizing BUS at the same time, synch=
ronize_srcu_expedited() cannot safely reclaim
space(it cannot protect srcu_dereference() outside the critical section?), =
how can we ensure that BUS obtained by
kvm_io_bus_write() is the latest?

Thanks,
Junjie Cai

Reported by: Junjie Cai <caijunjie15@h-partners.com>

