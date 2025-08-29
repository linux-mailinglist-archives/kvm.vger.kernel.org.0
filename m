Return-Path: <kvm+bounces-56251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B19BDB3B37A
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 08:32:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 671863B0433
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 06:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC1324887E;
	Fri, 29 Aug 2025 06:32:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2021A7253;
	Fri, 29 Aug 2025 06:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756449154; cv=none; b=llAybyS2tCVwQO3nIBhOAYr+1OI7p4bcet58WPnN9ponZ0T2Z2foJRwAebYDQvFTDmG3s+Lkr6CasM6z2qKoJri+6eS4HChCdwWIWclMaJ4N5u1/vfa4gxYbsjuoezgt6JpimyGnN7XQX/puqewE9l332oT1/MrYzGFAJC3/vlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756449154; c=relaxed/simple;
	bh=Kst+61R8WKCK7sqJxMvcA3ZByeIORdO40H2gwXSWcj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rCWUzO0rQTfjPa1aoxuCU+z6j3akDN/H0NVcG9FoNcNV317NtKJzUxC5VwHWyLZWxFmwruz8qe9nUEhLJftGVk47uFawS5KEO+sJhWG5AlAUems1Um9EPmYFo0d4OU46bT/GPVhPvJa079QD/JApUnsKnZLu64o7ZHxO8R47B8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ec985f6284a111f0b29709d653e92f7d-20250829
X-CID-CACHE: Type:Local,Time:202508291416+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:1f5bf724-5a91-4266-ac8e-9c158e033928,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:363845aa8f825743d29eadcc6fd84d5d,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: ec985f6284a111f0b29709d653e92f7d-20250829
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1683829947; Fri, 29 Aug 2025 14:32:24 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id CE313E008FA5;
	Fri, 29 Aug 2025 14:32:23 +0800 (CST)
X-ns-mid: postfix-68B14976-48111815
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 0777CE008FA4;
	Fri, 29 Aug 2025 14:32:16 +0800 (CST)
Message-ID: <5601fe46-6574-4a9b-8fd5-cab4af8dd390@kylinos.cn>
Date: Fri, 29 Aug 2025 14:32:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/18] cpufreq: brcmstb-avs-cpufreq: Use
 __free(put_cpufreq_policy) for policy reference
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J . wysocki" <rafael@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Markus Mayer
 <mmayer@broadcom.com>, Florian Fainelli <florian.fainelli@broadcom.com>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Krzysztof Kozlowski
 <krzk@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Thierry Reding <thierry.reding@gmail.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 MyungJoo Ham <myungjoo.ham@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Chanwoo Choi <cw00.choi@samsung.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Daniel Lezcano <daniel.lezcano@kernel.org>,
 Sascha Hauer <s.hauer@pengutronix.de>, Shawn Guo <shawnguo@kernel.org>,
 Eduardo Valentin <edubezval@gmail.com>, Keerthy <j-keerthy@ti.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 zhenglifeng <zhenglifeng1@huawei.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Lukasz Luba <lukasz.luba@arm.com>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Beata Michalska <beata.michalska@arm.com>, Fabio Estevam
 <festevam@gmail.com>, Pavel Machek <pavel@kernel.org>,
 Sumit Gupta <sumitg@nvidia.com>,
 Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Yicong Yang <yangyicong@hisilicon.com>,
 linux-pm@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 linux-acpi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-tegra@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, imx@lists.linux.dev,
 linux-omap@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250827023202.10310-1-zhangzihuan@kylinos.cn>
 <20250827023202.10310-5-zhangzihuan@kylinos.cn>
 <20250829055944.ragfnh62q2cuew3e@vireshk-i7>
 <4bd55a08-62bb-46c4-bfb6-a3375ce37e79@kylinos.cn>
 <20250829062624.jalqqsigs7hanf7i@vireshk-i7>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <20250829062624.jalqqsigs7hanf7i@vireshk-i7>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


=E5=9C=A8 2025/8/29 14:26, Viresh Kumar =E5=86=99=E9=81=93:
> On 29-08-25, 14:16, Zihuan Zhang wrote:
>> Thanks for applying the patch!
>>
>> I=E2=80=99ve been thinking further =E2=80=94 instead of using __free d=
irectly, maybe we
>> could introduce a small macro wrapper around it to make the release sc=
ope
>> more controllable and consistent.
>>
>> Link:
>> https://lore.kernel.org/all/6174bcc8-30f5-479b-bac6-f42eb1232b4d@kylin=
os.cn/
>>
>> Do you think this would be a better approach, or should we just stick =
with
>> the current use of __free?
> Lets keep it simple for now and use __free directly. And keep this
> similar with other parts of the kernel.


Got it. Thanks!


