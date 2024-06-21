Return-Path: <kvm+bounces-20217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0AB911EED
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A8201C2143F
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 08:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826FE16D4FE;
	Fri, 21 Jun 2024 08:37:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5F116D31E;
	Fri, 21 Jun 2024 08:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718959052; cv=none; b=CFMZhq1WOUjLcXlPgDdAl3lEh1FW676LqVoJe1dmOCXbS+F4wPKmUAVRIt56BmucbbkSlj+Yieo97oVdSdMXjRNQ7UDDWsMcdzevnArN1HWt8ACvJcZibAJeD0ClOMRMDLLlHwTRx+uISFAJb5KTLpZwtrhO8WVAXyAZEeJmpTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718959052; c=relaxed/simple;
	bh=vQbkzYO5D64OlUwNV48NR4emSRgPe77OGdkJraE8QTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EBhclMOU1IuPDfqdlEtfyRI+ZDdeBbPfBFTpHDdIKmA0uuSAA7SxKeEH30TV1z8pzem9HX7p8rnnnFlEOxNru/mdIt6KMcPq3JODUTC2W/ceHE2KwEcRmQFgvaNQi5VHbmckgSefe1acdePZt64nfThBOS48nRHXBFAHQAbjIUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id B540B240011;
	Fri, 21 Jun 2024 08:37:25 +0000 (UTC)
Message-ID: <40a7d568-3855-48fb-a73c-339e1790f12f@ghiti.fr>
Date: Fri, 21 Jun 2024 10:37:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Content-Language: en-US
To: Anup Patel <apatel@ventanamicro.com>, Conor Dooley <conor@kernel.org>
Cc: Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org,
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
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <CAK9=C2XH7-RdVpojX8GNW-WFTyChW=sTOWs8_kHgsjiFYwzg+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr

On 20/06/2024 08:25, Anup Patel wrote:
> On Wed, Jun 5, 2024 at 10:25 PM Conor Dooley <conor@kernel.org> wrote:
>> On Wed, Jun 05, 2024 at 08:15:08PM +0800, Yong-Xuan Wang wrote:
>>> Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
>>> property.
>>>
>>> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
>>> ---
>>>   .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++++++
>>>   1 file changed, 30 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
>>> index 468c646247aa..1e30988826b9 100644
>>> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
>>> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
>>> @@ -153,6 +153,36 @@ properties:
>>>               ratified at commit 3f9ed34 ("Add ability to manually trigger
>>>               workflow. (#2)") of riscv-time-compare.
>>>
>>> +        - const: svade
>>> +          description: |
>>> +            The standard Svade supervisor-level extension for raising page-fault
>>> +            exceptions when PTE A/D bits need be set as ratified in the 20240213
>>> +            version of the privileged ISA specification.
>>> +
>>> +            Both Svade and Svadu extensions control the hardware behavior when
>>> +            the PTE A/D bits need to be set. The default behavior for the four
>>> +            possible combinations of these extensions in the device tree are:
>>> +            1. Neither svade nor svadu in DT: default to svade.
>> I think this needs to be expanded on, as to why nothing means svade.
> Actually if both Svade and Svadu are not present in DT then
> it is left to the platform and OpenSBI does nothing.
>
>>> +            2. Only svade in DT: use svade.
>> That's a statement of the obvious, right?
>>
>>> +            3. Only svadu in DT: use svadu.
>> This is not relevant for Svade.
>>
>>> +            4. Both svade and svadu in DT: default to svade (Linux can switch to
>>> +               svadu once the SBI FWFT extension is available).
>> "The privilege level to which this devicetree has been provided can switch to
>> Svadu if the SBI FWFT extension is available".
>>
>>> +        - const: svadu
>>> +          description: |
>>> +            The standard Svadu supervisor-level extension for hardware updating
>>> +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull request
>>> +            #25 from ved-rivos/ratified") of riscv-svadu.
>>> +
>>> +            Both Svade and Svadu extensions control the hardware behavior when
>>> +            the PTE A/D bits need to be set. The default behavior for the four
>>> +            possible combinations of these extensions in the device tree are:
>> @Anup/Drew/Alex, are we missing some wording in here about it only being
>> valid to have Svadu in isolation if the provider of the devicetree has
>> actually turned on Svadu? The binding says "the default behaviour", but
>> it is not the "default" behaviour, the behaviour is a must AFAICT. If
>> you set Svadu in isolation, you /must/ have turned it on. If you set
>> Svadu and Svade, you must have Svadu turned off?
> Yes, the wording should be more of requirement style using
> must or may.
>
> How about this ?
> 1) Both Svade and Svadu not present in DT => Supervisor may
>      assume Svade to be present and enabled or it can discover
>      based on mvendorid, marchid, and mimpid.
> 2) Only Svade present in DT => Supervisor must assume Svade
>      to be always enabled. (Obvious)
> 3) Only Svadu present in DT => Supervisor must assume Svadu
>      to be always enabled. (Obvious)


I agree with all of that, but the problem is how can we guarantee that 
openSBI actually enabled svadu? This is not the case for now.


> 4) Both Svade and Svadu present in DT => Supervisor must
>      assume Svadu turned-off at boot time. To use Svadu, supervisor
>      must explicitly enable it using the SBI FWFT extension.
>
> IMO, the #2 and #3 are definitely obvious but still worth mentioning.
>
>>> +            1. Neither svade nor svadu in DT: default to svade.
>>> +            2. Only svade in DT: use svade.
>> These two are not relevant to Svadu, I'd leave them out.
>>
>>> +            3. Only svadu in DT: use svadu.
>> Again, statement of the obvious?
>>
>>> +            4. Both svade and svadu in DT: default to svade (Linux can switch to
>>> +               svadu once the SBI FWFT extension is available).
>> Same here as in the Svade entry.
>>
>> Thanks,
>> Conor.
>>
> Regards,
> Anup
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

