Return-Path: <kvm+bounces-25317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C391D9638D2
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 05:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F01BB22BA4
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 03:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1474C3D0;
	Thu, 29 Aug 2024 03:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="fOt6inxP"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597643D6A;
	Thu, 29 Aug 2024 03:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724902400; cv=none; b=QJSeJRbLYRGhs2REY4M4utYs1zecBNmGS9p1JSmgPZD81CkHk9U209GhB4McIK5M7spX6ALTragdqwmb/rx3OIo3EiLzuzUa2Uo/Qg0HP8Vu6ymX3f3JBLGyGLHxPhttLUmuqN0MdsAm5bkveQmpnLK65/0i0yiUnik4ZbMTEKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724902400; c=relaxed/simple;
	bh=w1r+O8sWrSRbzGeYgOT8fFHmRB8r3kFv3utfoSt/qD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ShdIyzj2Did74jWHsWhCHdBq2AJvgQ5SZ4vVBLrJiMSlaTA1NEmhgb+EozseRI9Rz0ST+WpuF6cWy5Azm9CjGft3/Qcn+39vBHJHEUD9seGOOx7c2nyhu6Sx2+G14pCDPveONaJ0O49e0HzVKQiF+vvVYnkH2gQS0zHAfHcCFAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=fOt6inxP; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1724902390;
	bh=AOI+sFgYc+egpuvujXNsnccuz70B/MbEqwhv0oIczUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=fOt6inxPxG4laRCW8cKOYA9WFcUzF0O8tIMTzXY0fkdmYr2dXygIEOBgpq7rLNhdi
	 uxgPGLQvgC0fRFbMVSPnrHsGawJkObbOHlhq5UOTWq/+mGKN4HVk0Bk7Ui/34laA6m
	 av6633jtfD2KmFJxqIAKwE+BJS+Uzbb/QBrao+m8=
X-QQ-mid: bizesmtp91t1724902383toe2irx7
X-QQ-Originating-IP: yiPdOobyPlWH/gtxewj0fNtc0cO7zzAP7U7r9lqh90U=
Received: from [10.20.53.89] ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 29 Aug 2024 11:33:00 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3163777189370156999
Message-ID: <6B877E46C55A8A27+f98078be-8cde-46d2-9065-3f12e44ac603@uniontech.com>
Date: Thu, 29 Aug 2024 11:33:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] Loongarch: KVM: Add KVM hypercalls documentation for
 LoongArch
To: YanTeng Si <si.yanteng@linux.dev>,
 Dandan Zhang <zhangdandan@uniontech.com>, pbonzini@redhat.com,
 corbet@lwn.net, zhaotianrui@loongson.cn, maobibo@loongson.cn,
 chenhuacai@kernel.org, zenghui.yu@linux.dev
Cc: kernel@xen0n.name, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 guanwentao@uniontech.com, baimingcong@uniontech.com,
 Xianglai Li <lixianglai@loongson.cn>, Mingcong Bai <jeffbai@aosc.io>
References: <4769C036576F8816+20240828045950.3484113-1-zhangdandan@uniontech.com>
 <aa72bc73-b20d-4652-be89-37d01f291725@linux.dev>
From: WangYuli <wangyuli@uniontech.com>
Autocrypt: addr=wangyuli@uniontech.com; keydata=
 xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSKP+nX39DN
 IVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAxFiEEa1GMzYeuKPkg
 qDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMBAAAKCRDF2h8wRvQL7g0UAQCH
 3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfPbwD/SrncJwwPAL4GiLPEC4XssV6FPUAY
 0rA68eNNI9cJLArOOARmgSyJEgorBgEEAZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7
 VTL0dvPDofBTjFYDAQgHwngEGBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIb
 DAAKCRDF2h8wRvQL7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkU
 o9ERi7qS/hbUdUgtitI89efbY0TVetgDsyeQiwU=
In-Reply-To: <aa72bc73-b20d-4652-be89-37d01f291725@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1


On 2024/8/29 11:22, YanTeng Si wrote:
>
> 在 2024/8/28 12:59, Dandan Zhang 写道:
>> From: Bibo Mao <maobibo@loongson.cn>
>>
>> Add documentation topic for using pv_virt when running as a guest
>> on KVM hypervisor.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>> Co-developed-by: Mingcong Bai <jeffbai@aosc.io>
>> Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
>> Link: 
>> https://lore.kernel.org/all/5c338084b1bcccc1d57dce9ddb1e7081@aosc.io/
>> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
>> ---
>>   Documentation/virt/kvm/index.rst              |  1 +
>>   .../virt/kvm/loongarch/hypercalls.rst         | 89 +++++++++++++++++++
>>   Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>>   MAINTAINERS                                   |  1 +
>>   4 files changed, 101 insertions(+)
>>   create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
>>   create mode 100644 Documentation/virt/kvm/loongarch/index.rst
> If you don't mind, how about translating these into Chinese? If
> you decide to do so, you don't need to split the patch again,
> just complete your translation in this patch and add your
> Co-developed-by tag.


I'm afraid that's not feasible.

The entire KVM subsystem documentation is currently lacking a Chinese 
translation, not just for LoongArch.

  A better approach would be to merge this English document first.

In fact, I'm in the process of preparing Chinese translations for the 
KVM subsystem documentation, and they're on their way.

>
> Thanks,
> Yanteng
>
Thanks,
-- 
WangYuli


