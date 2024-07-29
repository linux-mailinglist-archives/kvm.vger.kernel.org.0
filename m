Return-Path: <kvm+bounces-22479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9F9193EC02
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 05:50:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71AF81F213E3
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 03:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B128B81ACB;
	Mon, 29 Jul 2024 03:50:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B0C978276;
	Mon, 29 Jul 2024 03:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722225005; cv=none; b=Ur3FYFcHu9ZtefpPsEI4TQOxAUDQssH4UR8XSK5bdrlk+wK8q5O6Sf4INJKCF092PU5BxLRn7rzJeXeDhyafJsVTrztf9gjiNdTsQeBWSY+OKZWqthDzYJIetXdxYH6LL90APMl+gDIE1R8XsrsF51C9bYS+YLBh0vvFJt9XLkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722225005; c=relaxed/simple;
	bh=d9ugLOY3YSPTwydIDtkHiCrwApM0k3T2ez6oBbM0aDk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=oGJ60s2V6kps665vy8NMhyOmMCvfSdrS2u6ezpk529cTmSXcTPdkN1gp0VvHsuLQHDQUi4FHLXlE+Jl61gAse6ryk78nRPUYnYKBCS2ILt524tSixNy/MTs+w9vKmdYymjYmU69MeTkbmq7YtltMjD5QUOCZr2b5oIX284FOy7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxruthEadma18DAA--.11862S3;
	Mon, 29 Jul 2024 11:49:53 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxf8deEadmNiIEAA--.20240S3;
	Mon, 29 Jul 2024 11:49:53 +0800 (CST)
Subject: Re: [PATCH] KVM: Loongarch: Remove undefined a6 argument comment for
 kvm_hypercall
To: WangYuli <wangyuli@uniontech.com>, Huacai Chen <chenhuacai@kernel.org>
Cc: Dandan Zhang <zhangdandan@uniontech.com>, zhaotianrui@loongson.cn,
 kernel@xen0n.name, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Wentao Guan <guanwentao@uniontech.com>,
 baimingcong@uniontech.com
References: <6D5128458C9E19E4+20240725134820.55817-1-zhangdandan@uniontech.com>
 <c40854ac-38ef-4781-6c6b-4f74e24f265c@loongson.cn>
 <CAAhV-H5R_kamf=YJ62hb+iFr7Y+cvCaBBrY1rdk_wEEq4+6D_w@mail.gmail.com>
 <a9245b66-be6e-7211-49dd-a9a2d23ec2cf@loongson.cn>
 <CAAhV-H7Op_W0B7d4uQQVU_BEkpyQmwf9TCxQA9bYx3=JrQZ8pg@mail.gmail.com>
 <9bad6e47-dac5-82d2-1828-57df3ec840f8@loongson.cn>
 <DB945E243D91EB2F+df447e7b-ddd6-459d-9951-d92fcfceb92c@uniontech.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <a984a8a7-135a-934f-f3f0-e77d6ae59e52@loongson.cn>
Date: Mon, 29 Jul 2024 11:49:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <DB945E243D91EB2F+df447e7b-ddd6-459d-9951-d92fcfceb92c@uniontech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxf8deEadmNiIEAA--.20240S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7ZF45Wry3Jw4DGw13Xr4UWrX_yoW8Gw4fpa
	yUt3W3CFnaqr4kA3W3Aw1UZr1rGr4fWanFqwn5Jr1UCrs8GFn3t3yxtwn0yFykW3yFqFyY
	vF40q345XFy5ZFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E
	14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnI
	WIevJa73UjIFyTuYvjxU7_MaUUUUU



On 2024/7/29 上午11:03, WangYuli wrote:
> Hi Bibo and Huacai,
> 
> 
> Ah... tell me you two aren't arguing, right?
> 
> 
> Both of you are working towards the same goal—making the upstream
> 
> code for the Loongarch architecture as clean and elegant as possible.
> 
> If it's just a disagreement about how to handle this small patch,
> 
> there's no need to make things complicated.
> 
> 
> As a partner of yours and a community developer passionate about
> 
> Loongson CPU, I'd much rather see you two working together
> 
> harmoniously than complaining about each other's work. I have full
> 
> confidence in Bibo's judgment on the direction of KVM for Loongarch,
> 
> and I also believe that Huacai, as the Loongarch maintainer, has always
> 
> been fulfilling his responsibilities.
> 
> 
> You are both excellent Linux developers. That's all.
> 
> 
> To be specific about the controversy caused by this particular commit,
> 
> I think the root cause is that the KVM documentation for Loongarch
> 
> hasn't been upstreamed. In my opinion, the documentation seems
> 
> ready to be upstreamed. If you're all busy with more important work,
> 
> I can take the time to submit them and provide a Chinese translation.
> 
> 
> If this is feasible, it would be better to merge this commit after that.
Yuli,

The argument is normal in the work and life :)

You are right, KVM document is important and any contribution is welcome.

Regards
Bibo Mao
> 
> 
> Best wishes,
> 
> 
> -- 
> 
> WangYuli
> 
> 


