Return-Path: <kvm+bounces-20272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33C00912630
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D76DB24B8D
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBB215A87E;
	Fri, 21 Jun 2024 12:42:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD041553A4;
	Fri, 21 Jun 2024 12:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973747; cv=none; b=B+zar1U1vn/b9ZlcHKejF+GE05cgclJhuKamKi6X+pAIKZuKvwthfbBZt86JYy4zSAAmaPxqwPdXXD/Gm6tAN4Zss4dciX3aOVsnMVxDSvtDpWnrUlwkrH/tNAz0X7ZiUsu/WiMJj21iWHNDP+tAsB0n6BdOZ69u4yAujK2YYh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973747; c=relaxed/simple;
	bh=6/p6dMkjIn36S0TuDtGAxuaz168mw3t7ZpVlE8DqQPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T4UNiuCx2KeG0mreTkm2BdU/IG5TuCttWg9LntC8enUrc4YTdWUF4haQcSd2l+tZp0FUo8z/JDd1WPeL/xAnuauDzoZ3uUdqdjenuez5p10s8T2JXGR9imrzARb7ze92Dt0AtiyDmcGUEdrRaBvMyRGp92zfcZFX+mlbGrxaKgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 6AC90FF804;
	Fri, 21 Jun 2024 12:42:16 +0000 (UTC)
Message-ID: <edcd3957-0720-4ab4-bdda-58752304a53a@ghiti.fr>
Date: Fri, 21 Jun 2024 14:42:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Content-Language: en-US
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Anup Patel <apatel@ventanamicro.com>, Conor Dooley <conor@kernel.org>,
 Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org, ajones@ventanamicro.com, greentime.hu@sifive.com,
 vincent.chen@sifive.com, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 devicetree@vger.kernel.org
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com>
 <20240605-atrium-neuron-c2512b34d3da@spud>
 <CAK9=C2XH7-RdVpojX8GNW-WFTyChW=sTOWs8_kHgsjiFYwzg+g@mail.gmail.com>
 <40a7d568-3855-48fb-a73c-339e1790f12f@ghiti.fr>
 <20240621-viewless-mural-f5992a247992@wendy>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240621-viewless-mural-f5992a247992@wendy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr


On 21/06/2024 12:17, Conor Dooley wrote:
> On Fri, Jun 21, 2024 at 10:37:21AM +0200, Alexandre Ghiti wrote:
>> On 20/06/2024 08:25, Anup Patel wrote:
>>> On Wed, Jun 5, 2024 at 10:25 PM Conor Dooley <conor@kernel.org> wrote:
>>>> On Wed, Jun 05, 2024 at 08:15:08PM +0800, Yong-Xuan Wang wrote:
>>>>> Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
>>>>> property.
>>>>>
>>>>> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
>>>>> ---
>>>>>    .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++++++
>>>>>    1 file changed, 30 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
>>>>> index 468c646247aa..1e30988826b9 100644
>>>>> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
>>>>> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
>>>>> @@ -153,6 +153,36 @@ properties:
>>>>>                ratified at commit 3f9ed34 ("Add ability to manually trigger
>>>>>                workflow. (#2)") of riscv-time-compare.
>>>>>
>>>>> +        - const: svade
>>>>> +          description: |
>>>>> +            The standard Svade supervisor-level extension for raising page-fault
>>>>> +            exceptions when PTE A/D bits need be set as ratified in the 20240213
>>>>> +            version of the privileged ISA specification.
>>>>> +
>>>>> +            Both Svade and Svadu extensions control the hardware behavior when
>>>>> +            the PTE A/D bits need to be set. The default behavior for the four
>>>>> +            possible combinations of these extensions in the device tree are:
>>>>> +            1. Neither svade nor svadu in DT: default to svade.
>>>> I think this needs to be expanded on, as to why nothing means svade.
>>> Actually if both Svade and Svadu are not present in DT then
>>> it is left to the platform and OpenSBI does nothing.
>>>
>>>>> +            2. Only svade in DT: use svade.
>>>> That's a statement of the obvious, right?
>>>>
>>>>> +            3. Only svadu in DT: use svadu.
>>>> This is not relevant for Svade.
>>>>
>>>>> +            4. Both svade and svadu in DT: default to svade (Linux can switch to
>>>>> +               svadu once the SBI FWFT extension is available).
>>>> "The privilege level to which this devicetree has been provided can switch to
>>>> Svadu if the SBI FWFT extension is available".
>>>>
>>>>> +        - const: svadu
>>>>> +          description: |
>>>>> +            The standard Svadu supervisor-level extension for hardware updating
>>>>> +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull request
>>>>> +            #25 from ved-rivos/ratified") of riscv-svadu.
>>>>> +
>>>>> +            Both Svade and Svadu extensions control the hardware behavior when
>>>>> +            the PTE A/D bits need to be set. The default behavior for the four
>>>>> +            possible combinations of these extensions in the device tree are:
>>>> @Anup/Drew/Alex, are we missing some wording in here about it only being
>>>> valid to have Svadu in isolation if the provider of the devicetree has
>>>> actually turned on Svadu? The binding says "the default behaviour", but
>>>> it is not the "default" behaviour, the behaviour is a must AFAICT. If
>>>> you set Svadu in isolation, you /must/ have turned it on. If you set
>>>> Svadu and Svade, you must have Svadu turned off?
>>> Yes, the wording should be more of requirement style using
>>> must or may.
>>>
>>> How about this ?
>>> 1) Both Svade and Svadu not present in DT => Supervisor may
>>>       assume Svade to be present and enabled or it can discover
>>>       based on mvendorid, marchid, and mimpid.
>>> 2) Only Svade present in DT => Supervisor must assume Svade
>>>       to be always enabled. (Obvious)
>>> 3) Only Svadu present in DT => Supervisor must assume Svadu
>>>       to be always enabled. (Obvious)
>>
>> I agree with all of that, but the problem is how can we guarantee that
>> openSBI actually enabled svadu?
> Conflation of an SBI implementation and OpenSBI aside, if the devicetree
> property is defined to mean that "the supervisor must assume svadu to be
> always enabled", then either it is, or the firmware's description of the
> hardware is broken and it's not the supervisor's problem any more. It's
> not the kernel's job to validate that the devicetree matches the
> hardware.
>
>> This is not the case for now.
> What "is not the case for now"? My understanding was that, at the
> moment, nothing happens with Svadu in OpenSBI. In turn, this means that
> there should be no devicetrees containing Svadu (per this binding's
> description) and therefore no problem?


What prevents a dtb to be passed with svadu to an old version of opensbi 
which does not support the enablement of svadu? The svadu extension will 
end up being present in the kernel but not enabled right?

Sorry if I'm completely off here, it really feels like I missed something :)


>
> Thanks,
> Conor.

