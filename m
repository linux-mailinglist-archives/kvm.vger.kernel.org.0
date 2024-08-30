Return-Path: <kvm+bounces-25455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C635096571B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82E1028523B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 05:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CAC15098E;
	Fri, 30 Aug 2024 05:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zj+yVsHg"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD8D139597
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 05:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724996913; cv=none; b=BNarR4EqaXQGUh98tq2lMpxQVq7dAjSQXRnNeDWHvhUdnj43/rfoO0a7CJdVgIgk2fAZOjRiPMTkrIhIt748wuHmP2gsaIg0a+aoZiLLxdmuXjW2T86TyOhl1+TJ+Jf/33EYJRpXrCVJo+DCSymcxFsYbWEZsZoY6U76VE979/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724996913; c=relaxed/simple;
	bh=679NXg6id5PLytBa7BQ9IBt08iayYByB0eAiPWZ3jFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FL4mONxnPHP97qmNyckiv4lVY3ay+n4Hn2lxCvt0Q2gxLCvCItXROSDF1HYpb7MQcNiSh+bpBtDaTIUkXonXSzSPYZ+7Jx/2zULaHFv4+dhZqrja9e10VEpawuKUZDHpcJvW1Q0oDcy+DbI4Zlg7VYQeIU0u1yB1+enu/2g+8NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zj+yVsHg; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <6da89601-35d8-44cf-88e7-db8f36635c66@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724996907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WTa8e3/jM/RbQiQBkkhzGoSerbedvHw29OHSSmTgdcI=;
	b=Zj+yVsHgOjAGYYcP0ikoB4ZHnR4fDKGlD/G+S1K2jEgIeB2mtW0b9dqOQqUtqCmPOVaRUY
	o9MsEc4MN+Bzzs2FHlaS+2vKo/1yI35QZXDKAQ+UlXkEOaXizu4jVNM8syL/ZFGwZVuHk+
	xiVQa7EuWMmKTymTu/StNthvpHgoGS8=
Date: Fri, 30 Aug 2024 13:48:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] Loongarch: KVM: Add KVM hypercalls documentation for
 LoongArch
To: WangYuli <wangyuli@uniontech.com>,
 Dandan Zhang <zhangdandan@uniontech.com>, pbonzini@redhat.com,
 corbet@lwn.net, zhaotianrui@loongson.cn, maobibo@loongson.cn,
 chenhuacai@kernel.org, zenghui.yu@linux.dev
Cc: kernel@xen0n.name, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 guanwentao@uniontech.com, baimingcong@uniontech.com,
 Xianglai Li <lixianglai@loongson.cn>, Mingcong Bai <jeffbai@aosc.io>
References: <4769C036576F8816+20240828045950.3484113-1-zhangdandan@uniontech.com>
 <aa72bc73-b20d-4652-be89-37d01f291725@linux.dev>
 <6B877E46C55A8A27+f98078be-8cde-46d2-9065-3f12e44ac603@uniontech.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: YanTeng Si <si.yanteng@linux.dev>
In-Reply-To: <6B877E46C55A8A27+f98078be-8cde-46d2-9065-3f12e44ac603@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT




在 2024/8/29 11:33, WangYuli 写道:
>
> On 2024/8/29 11:22, YanTeng Si wrote:
>>
>> 在 2024/8/28 12:59, Dandan Zhang 写道:
>>> From: Bibo Mao <maobibo@loongson.cn>
>>>
>>> Add documentation topic for using pv_virt when running as a guest
>>> on KVM hypervisor.
>>>
>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>>> Co-developed-by: Mingcong Bai <jeffbai@aosc.io>
>>> Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
>>> Link: 
>>> https://lore.kernel.org/all/5c338084b1bcccc1d57dce9ddb1e7081@aosc.io/
>>> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
>>> ---
>>>   Documentation/virt/kvm/index.rst              |  1 +
>>>   .../virt/kvm/loongarch/hypercalls.rst         | 89 
>>> +++++++++++++++++++
>>>   Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>>>   MAINTAINERS                                   |  1 +
>>>   4 files changed, 101 insertions(+)
>>>   create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
>>>   create mode 100644 Documentation/virt/kvm/loongarch/index.rst
>> If you don't mind, how about translating these into Chinese? If
>> you decide to do so, you don't need to split the patch again,
>> just complete your translation in this patch and add your
>> Co-developed-by tag.
>
>
> I'm afraid that's not feasible.
>
> The entire KVM subsystem documentation is currently lacking a Chinese 
> translation, not just for LoongArch.
You can add other documents to TODOLIST.
>
>  A better approach would be to merge this English document first.
It's up to you.
>
> In fact, I'm in the process of preparing Chinese translations for the 
> KVM subsystem documentation, and they're on their way.
Nice！ To be honest, I've tried to translate kvm's API documentation more 
than once in the past, but all of them have been halfway because it's 
too long, and I'm guessing that the review process won't be too smooth 
either.


BTW, I've noticed that v2 is still a work in progress, so please reduce 
the frequency of sending emails until the v2 and v3 reviews are over.


Thanks,
Yanteng


