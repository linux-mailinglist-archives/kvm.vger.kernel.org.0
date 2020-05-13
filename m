Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF9E1D0AAE
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgEMISs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:18:48 -0400
Received: from foss.arm.com ([217.140.110.172]:40016 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729106AbgEMISs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:18:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 603A81FB;
        Wed, 13 May 2020 01:18:47 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8042D3F305;
        Wed, 13 May 2020 01:18:46 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 32/32] arm/arm64: Add PCI Express 1.1 support
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-33-alexandru.elisei@arm.com>
 <2b963524-3153-fc95-7bf2-b60852ea2f22@arm.com>
 <f1e6746f-6196-a687-f3c5-78a08df31205@arm.com>
 <d1e018e7-f443-2710-a00d-e570652d569a@arm.com>
 <4f8dfda1-4a64-e2fb-4e93-3979e037599d@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <87575228-33b0-96cf-13d6-3499ce107020@arm.com>
Date:   Wed, 13 May 2020 09:17:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <4f8dfda1-4a64-e2fb-4e93-3979e037599d@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/2020 16:44, Alexandru Elisei wrote:

Hi,

> On 5/12/20 3:17 PM, André Przywara wrote:
>> On 06/05/2020 14:51, Alexandru Elisei wrote:
>>
>> Hi,
>>
>>> On 4/6/20 3:06 PM, André Przywara wrote:
>>>> On 26/03/2020 15:24, Alexandru Elisei wrote:
>>>>
>>>>>  
>>>>>  union pci_config_address {
>>>>>  	struct {
>>>>> @@ -58,6 +91,8 @@ union pci_config_address {
>>>>>  	};
>>>>>  	u32 w;
>>>>>  };
>>>>> +#endif
>>>>> +#define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
>>>>>  
>>>>>  struct msix_table {
>>>>>  	struct msi_msg msg;
>>>>> @@ -100,6 +135,33 @@ struct pci_cap_hdr {
>>>>>  	u8	next;
>>>>>  };
>>>>>  
>>>>> +struct pcie_cap {
>>>> I guess this is meant to map to the PCI Express Capability Structure as
>>>> described in the PCIe spec?
>>>> We would need to add the "packed" attribute then. But actually I am not
>>>> a fan of using C language constructs to model specified register
>>>> arrangements, the kernel tries to avoid this as well.
>>> I'm not sure what you are suggesting. Should we rewrite the entire PCI emulation
>>> code in kvmtool then?
>> At least not add more of that problematic code, especially if we don't
> 
> I don't see why how the code is problematic. Did I miss it in a previous comment?

I was referring to that point that modelling hardware defined registers
using a C struct is somewhat dodgy. As the C standard says, in section
6.7.2.1, end of paragraph 15:
"There may be unnamed padding within a structure object, but not at its
beginning."
Yes, GCC and other implementations offer "packed" to somewhat overcome
this, but this is a compiler extension and has other issues, like if you
have non-aligned members and take pointers to it.

I think our case here is more sane, since we always seem to use it on
normal memory (do we?), and are not mapping it to some actual device memory.

So I leave this up to you, but I am still opposed to the idea of adding
code that is not used.

Cheers,
Andre.

>> need it. Maybe there is a better solution for the operations we will
>> need (byte array?), that's hard to say without seeing the code.
>>
>>>> Actually, looking closer: why do we need this in the first place? I
>>>> removed this and struct pm_cap, and it still compiles.
>>>> So can we lose those two structures at all? And move the discussion and
>>>> implementation (for VirtIO 1.0?) to a later series?
>>> I've answered both points in v2 of the series [1].
>>>
>>> [1] https://www.spinics.net/lists/kvm/msg209601.html:
>> From there:
>>>> But more importantly: Do we actually need those definitions? We
>>>> don't seem to use them, do we?
>>>> And the u8 __pad[PCI_DEV_CFG_SIZE] below should provide the extended
>>>> storage space a guest would expect?
>>> Yes, we don't use them for the reasons I explained in the commit
>>> message. I would rather keep them, because they are required by the
>>> PCIE spec.
>> I don't get the point of adding code / data structures that we don't
>> need, especially if it has issues. I understand it's mandatory as per
>> the spec, but just adding a struct here doesn't fix this or makes this
>> better.
> 
> Sure, I can remove the unused structs, especially if they have issues. But I don't
> see what issues they have, would you mind expanding on that?

The best code is the one not written. ;-)

Cheers,
Andre
