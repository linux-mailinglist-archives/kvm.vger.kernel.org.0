Return-Path: <kvm+bounces-64095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7C8C7882F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 11:27:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BB1ED366FE6
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 10:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001FF34321C;
	Fri, 21 Nov 2025 10:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0z8pR8Wf"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E629C33B967;
	Fri, 21 Nov 2025 10:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763720484; cv=none; b=uvQV4i0y4JnYMo50pDzfYrYDGLK3jEn57fZ9VOYVMvfS0PCifs9wfDHYaoZDo99MxGEJLwHhBrxKC4KmPh7YXeM/g9RyLTpTZURCmDCIH3CZeLL0AvkmuDqnC9FEOJQ+uPg3vlqq2N2lfUYTI38uD+qNsymYD1aOiah690WyRYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763720484; c=relaxed/simple;
	bh=IXGQCEmd056QTCHBVaE7XkvLClggp4N8EpoSVsmdUn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OiiWJb6YLJFS+f6IrNWvqafQJnkj1KKni60tR+LbVtWqKwSKd6YGFAh1/8HqL1cKECuh0AvrzS7vuV9ao/0CdLKgSFDQ10bNXFt8BpSGBEX0/ERcCIyX6wANQUFKP/plp24mAMvDa2k3xIUULBrTkiDO8lltQd/uT9vmtqpvKtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0z8pR8Wf; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DmfI//jDc+SutvcPkcAsQW6M+QXS7fQhKaN+xJdDWXk=;
	b=0z8pR8WfT775x726EkNdOncOLgPPCb5HrQ0rtwDUHKC76QJ0JTEvF9cfpXwh8NE8NYNECs/yT
	nBCVTI+GJ1cTaSID3fbVSGbjA8tVOPpXV79m7RZbaLRpAzrwQTAzlPArIx22ZI3vu+k+p5dmX8q
	nKwQCXkMUYU0+vzIba4YMYE=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dCWRT05kXz1cyP6;
	Fri, 21 Nov 2025 18:19:33 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 5509A14010D;
	Fri, 21 Nov 2025 18:21:18 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 21 Nov 2025 18:21:17 +0800
Message-ID: <90180222-5399-442c-b7a3-e65b7d0e1378@huawei.com>
Date: Fri, 21 Nov 2025 18:21:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Support the FEAT_HDBSS introduced in Armv9.5
To: Marc Zyngier <maz@kernel.org>, Tian Zheng <zhengtian10@huawei.com>
CC: <oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <corbet@lwn.net>,
	<pbonzini@redhat.com>, <will@kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<suzuki.poulose@arm.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <86zf8fr9r2.wl-maz@kernel.org>
From: z00939249 <zhengtian10@huawei.com>
In-Reply-To: <86zf8fr9r2.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)

On 2025/11/21 17:54, Marc Zyngier wrote:
> On Fri, 21 Nov 2025 09:23:37 +0000,
> Tian Zheng <zhengtian10@huawei.com> wrote:
>>
>> This series of patches add support to the Hardware Dirty state tracking
>> Structure(HDBSS) feature, which is introduced by the ARM architecture
>> in the DDI0601(ID121123) version.
>>
>> The HDBSS feature is an extension to the architecture that enhances
>> tracking translation table descriptors' dirty state, identified as
>> FEAT_HDBSS. The goal of this feature is to reduce the cost of surveying
>> for dirtied granules, with minimal effect on recording when a granule
>> has been dirtied.
>>
>> The purpose of this feature is to make the execution overhead of live
>> migration lower to both the guest and the host, compared to existing
>> approaches (write-protect or search stage 2 tables).
>>
>> After these patches, users(such as qemu) can use the
>> KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl to enable or disable the HDBSS
>> feature before and after the live migration.
>>
>> This feature is similar to Intel's Page Modification Logging (PML),
>> offering hardware-assisted dirty tracking to reduce live migration
>> overhead. With PML support expanding beyond Intel, HDBSS introduces a
>> comparable mechanism for ARM.
> 
> Where is the change log describing what was changed compared to the
> previous version?
> 
> We gave you extensive comments back in March. You never replied to the
> feedback. And you now dump a whole set of patches, 6 months later,
> without the slightest indication of what has changed?
> 
> Why should we make the effort to review this again?

Apologies for the lack of proper changelog and the delayed follow-up on 
the feedback provided in March. This was an oversight on our part during 
the transition of maintainership for the HDBSS patch series. We 
sincerely appreciate the thorough comments you shared earlier and regret 
not responding in a timely manner.

Below is a summary of the changes made from v1 to v2.

v1:
https://lore.kernel.org/kvm/20250311040321.1460-1-yezhenyu2@huawei.com/

v1->v2 changes:
- Removed redundant macro definitions and switched to tool-generated.
- Split HDBSS interface and implementation into separate patches.
- Integrate system_supports_hdbss() into ARM feature initialization.
- Refactored HDBSS data structure to store meaningful values instead
of raw register contents.
- Fixed permission checks when applying DBM bits in page tables to
prevent potential memory corruption.
- Removed unnecessary dsb instructions.
- Drop the debugging printks.
- Merged the two patches "using ioctl to enable/disable the HDBSS
feature" and "support to handle the HDBSSF event" into one.

We apologize again for the delay and the missing changelog, and we 
greatly appreciate your time in reviewing this updated version.


