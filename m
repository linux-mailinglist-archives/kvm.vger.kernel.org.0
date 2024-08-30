Return-Path: <kvm+bounces-25473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA07D965988
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87595283C07
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 08:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7BA1662E9;
	Fri, 30 Aug 2024 08:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="eyYbWqmp"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5C213665B;
	Fri, 30 Aug 2024 08:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725005301; cv=none; b=Ss58l6WvwqjxB9Tt2rWe6UxKu2mPDf0p5Hop5EX7NLVfi8KEEmhlYnUb+xL9KWZ3LpsuAkK6FV1S9Xzn7WrunQUp4NlBUvK66lax+2y3OMxgbZSYxVRqljQGz3R4nlTAfvWDTkGqDTUJ94PydGT7dGG9ZpiCWNqf6rQ5qWjnFNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725005301; c=relaxed/simple;
	bh=Jy/mYLXULjxw7bWxF1qLAX0cl4bZqglXQz03uA7r4aE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B+Zxil/gEFfFdtQQ2+yGraWf3D58c0OymLPeX+vjH5/Wa+h4zosfBNlsgHVu6TSAeTN5Pjo81VP68mnr3BkmcK7NQxKXzWuifnODvD7Jhy2YhTgu3YAEnAXWYh8/TPqIK83igZ4qW6QrS5UlF/+Sm1GzzklelHhR2Z9fyStfdK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=eyYbWqmp; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1725005287;
	bh=qPQeX9heYTsZA7PiEdNYwSS+6KBwti6b7zQjuWjxDE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=eyYbWqmpzbXpE+UEgrfaqyS3FKfOJWR9/vSNQf/CSg/vf+SUUg0ChmYjkffO+9FrS
	 4a/vtwJkStL/M0WQ1/RgG9Ab37Kca8VLQ4jOKxuOqsWuk4AaWzi1nUxeFWK+1xMI1Y
	 EhB8PW1vCFkXmfPTdiaRmt7Mao8ev3KP+TQmEyxI=
X-QQ-mid: bizesmtpsz14t1725005279tbqo86
X-QQ-Originating-IP: fLqRLMABWHnhxJr0BDqDta1vbYiDrEnnlwy8FrCYQD8=
Received: from [10.20.53.89] ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 30 Aug 2024 16:07:57 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5593259827652918070
Message-ID: <4C6AD88A4E46420F+7823bff3-8421-4746-b34d-5bdbb1bfe247@uniontech.com>
Date: Fri, 30 Aug 2024 16:07:56 +0800
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
 <6B877E46C55A8A27+f98078be-8cde-46d2-9065-3f12e44ac603@uniontech.com>
 <6da89601-35d8-44cf-88e7-db8f36635c66@linux.dev>
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
In-Reply-To: <6da89601-35d8-44cf-88e7-db8f36635c66@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

On 2024/8/30 13:48, YanTeng Si wrote:

>
> BTW, I've noticed that v2 is still a work in progress, so please 
> reduce the frequency of sending emails until the v2 and v3 reviews are 
> over.
>
>
In fact, the issues identified by zenghui.yu in v2 have been rectified 
in v3.

To ensure ongoing optimization,we kindly request that 
huacai,bibo,zenghui,and any other relevant parties provide feedback 
directly on v3.

> Thanks,
> Yanteng
>
>
-- 
WangYuli

