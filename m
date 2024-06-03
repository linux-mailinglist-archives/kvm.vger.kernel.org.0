Return-Path: <kvm+bounces-18630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7A88D813E
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F35561F21F26
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778EA84A51;
	Mon,  3 Jun 2024 11:29:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5F91366;
	Mon,  3 Jun 2024 11:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717414185; cv=none; b=GddlMp4G/bFuPLicVhrJNsserGFCOx8q/QHXHMXy+X1er12y8yRV3qLRJDs16QL2hdYBse36orHCXm9ukBJReFHIX4JSfgIW60vru6m3edMOiSpWwYaifrM5upxLfqF3TncY3vlrUqKDuHwHSfiyTMVZUqi+dHCFWzoTB+3oex8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717414185; c=relaxed/simple;
	bh=ya/kztnZc7NQVa9gaYfv3AsNoluZc0B5lAv/N+r9X30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z9L3muAIrV2eFTyKh2dvhooRrWGeIvAGxKI7kI6J2bVGDtd8pl65cO1Pa2qgHgh+rk7jEOjwq/YVWXjFnNZR/FqtnVcjhz28dzCJG6Q/zDP1tg3U3P4DdAzwEYTW6DwuyHCMuh4pvDw0aO3JM38FPGLHdwMFSoyXvaQhwso72us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 010F11BF205;
	Mon,  3 Jun 2024 11:29:29 +0000 (UTC)
Message-ID: <f2016305-e24b-41ea-8c48-cfdeb8ee6b48@ghiti.fr>
Date: Mon, 3 Jun 2024 13:29:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 1/5] RISC-V: Detect and Enable Svadu Extension
 Support
Content-Language: en-US
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Yong-Xuan Wang <yongxuan.wang@sifive.com>,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org, greentime.hu@sifive.com, vincent.chen@sifive.com,
 cleger@rivosinc.com, Jinyu Tang <tjytimi@163.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Anup Patel <anup@brainfault.org>, Conor Dooley <conor.dooley@microchip.com>,
 Mayuresh Chitale <mchitale@ventanamicro.com>,
 Samuel Holland <samuel.holland@sifive.com>, Samuel Ortiz
 <sameo@rivosinc.com>, Evan Green <evan@rivosinc.com>,
 Xiao Wang <xiao.w.wang@intel.com>, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Jisheng Zhang <jszhang@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Charlie Jenkins <charlie@rivosinc.com>, Leonardo Bras <leobras@redhat.com>,
 linux-kernel@vger.kernel.org
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-2-yongxuan.wang@sifive.com>
 <20240527-41b376a2bfedb3b9cf7e9c7b@orel>
 <ec110587-d557-439b-ae50-f3472535ef3a@ghiti.fr>
 <20240530-3e5538b8e4dea932e2d3edc4@orel>
 <3b76c46f-c502-4245-ae58-be3bd3f8a41f@ghiti.fr>
 <20240530-de1fde9735e6648dc34654f3@orel>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240530-de1fde9735e6648dc34654f3@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

On 30/05/2024 11:24, Andrew Jones wrote:
> On Thu, May 30, 2024 at 11:01:20AM GMT, Alexandre Ghiti wrote:
>> Hi Andrew,
>>
>> On 30/05/2024 10:47, Andrew Jones wrote:
>>> On Thu, May 30, 2024 at 10:19:12AM GMT, Alexandre Ghiti wrote:
>>>> Hi Yong-Xuan,
>>>>
>>>> On 27/05/2024 18:25, Andrew Jones wrote:
>>>>> On Fri, May 24, 2024 at 06:33:01PM GMT, Yong-Xuan Wang wrote:
>>>>>> Svadu is a RISC-V extension for hardware updating of PTE A/D bits.
>>>>>>
>>>>>> In this patch we detect Svadu extension support from DTB and enable it
>>>>>> with SBI FWFT extension. Also we add arch_has_hw_pte_young() to enable
>>>>>> optimization in MGLRU and __wp_page_copy_user() if Svadu extension is
>>>>>> available.
>>>> So we talked about this yesterday during the linux-riscv patchwork meeting.
>>>> We came to the conclusion that we should not wait for the SBI FWFT extension
>>>> to enable Svadu but instead, it should be enabled by default by openSBI if
>>>> the extension is present in the device tree. This is because we did not find
>>>> any backward compatibility issues, meaning that enabling Svadu should not
>>>> break any S-mode software.
>>> Unfortunately I joined yesterday's patchwork call late and missed this
>>> discussion. I'm still not sure how we avoid concerns with S-mode software
>>> expecting exceptions by purposely not setting A/D bits, but then not
>>> getting those exceptions.
>>
>> Most other architectures implement hardware A/D updates, so I don't see
>> what's specific in riscv. In addition, if an OS really needs the exceptions,
>> it can always play with the page table permissions to achieve such
>> behaviour.
> Hmm, yeah we're probably pretty safe since sorting this out is just one of
> many things an OS will have to learn to manage when getting ported. Also,
> handling both svade and svadu at boot is trivial since the OS simply needs
> to set the A/D bits when creating the PTEs or have exception handlers
> which do nothing but set the bits ready just in case.
>
>>
>>>> This is what you did in your previous versions of
>>>> this patchset so the changes should be easy. This behaviour must be added to
>>>> the dtbinding description of the Svadu extension.
>>>>
>>>> Another thing that we discussed yesterday. There exist 2 schemes to manage
>>>> the A/D bits updates, Svade and Svadu. If a platform supports both
>>>> extensions and both are present in the device tree, it is M-mode firmware's
>>>> responsibility to provide a "sane" device tree to the S-mode software,
>>>> meaning the device tree can not contain both extensions. And because on such
>>>> platforms, Svadu is more performant than Svade, Svadu should be enabled by
>>>> the M-mode firmware and only Svadu should be present in the device tree.
>>> I'm not sure firmware will be able to choose svadu when it's available.
>>> For example, platforms which want to conform to the upcoming "Server
>>> Platform" specification must also conform to the RVA23 profile, which
>>> mandates Svade and lists Svadu as an optional extension. This implies to
>>> me that S-mode should be boot with both svade and svadu in the DT and with
>>> svade being the active one. Then, S-mode can choose to request switching
>>> to svadu with FWFT.
>>
>> The problem is that FWFT is not there and won't be there for ~1y (according
>> to Anup). So in the meantime, we prevent all uarchs that support Svadu to
>> take advantage of this.
> I think we should have documented behaviors for all four possibilities
>
>   1. Neither svade nor svadu in DT -- current behavior
>   2. Only svade in DT -- current behavior
>   3. Only svadu in DT -- expect hardware A/D updating
>   4. Both svade and svadu in DT -- current behavior, but, if we have FWFT,
>      then use it to switch to svadu. If we don't have FWFT, then, oh well...
>
> Platforms/firmwares that aren't concerned with the profiles can choose (3)
> and Linux is fine. Those that do want to conform to the profile will
> choose (4) but Linux won't get the benefit of svadu until it also gets
> FWFT.


I think this solution pleases everyone so I'd say we should go for it, 
thanks Andrew!

@Yong-Xuan do you think you can prepare another spin with Andrew's 
proposal implemented?

Thanks,

Alex


>
> IOW, I think your proposal is fine except for wanting to document in the
> DT bindings that only svade or svadu may be provided, since I think we'll
> want both to be allowed eventually.
>
> Thanks,
> drew
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

