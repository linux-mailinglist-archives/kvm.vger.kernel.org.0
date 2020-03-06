Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4818217BCF5
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 13:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgCFMkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 07:40:36 -0500
Received: from foss.arm.com ([217.140.110.172]:60740 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbgCFMkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 07:40:35 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1356F31B;
        Fri,  6 Mar 2020 04:40:35 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22A6E3F6C4;
        Fri,  6 Mar 2020 04:40:34 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 18/30] hw/vesa: Set the size for BAR 0
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-19-alexandru.elisei@arm.com>
 <20200203122049.05483484@donnerap.cambridge.arm.com>
 <8f66615a-b771-1d6c-f794-182a5fd1d07d@arm.com>
 <20200205170045.4022a566@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f266d3bc-cab4-0c12-976c-1b208e90b3fd@arm.com>
Date:   Fri, 6 Mar 2020 12:40:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200205170045.4022a566@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/5/20 5:00 PM, Andre Przywara wrote:
> On Mon, 3 Feb 2020 12:27:55 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
>> Hi Andre,
>>
>> On 2/3/20 12:20 PM, Andre Przywara wrote:
>>> On Thu, 23 Jan 2020 13:47:53 +0000
>>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>>  
>>>> BAR 0 is an I/O BAR and is registered as an ioport region. Let's set its
>>>> size, so a guest can actually use it.  
>>> Well, the whole I/O bar emulates as RAZ/WI, so I would be curious how the guest would actually use it, but specifying the size is surely a good thing, so:  
>> Yeah, you're right, I was thinking about ARM where ioport are MMIO and you need to
>> map those address. I'll remove the part about the guest being able to actually use
>> it in the next iteration of the series.. Is it OK if I keep your Reviewed-by?
> Sure, as I mentioned the patch itself is fine.
>
> Thanks,
> Andre.
>
>>>    
>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>  
>>> Reviewed-by: Andre Przywara <andre.przywara>

I'm going to go ahead thinking it was a typo and you meant andre.przywara@arm.com
when posting the next iteration of this series. Please let me know if I got it wrong.

Thanks,
Alex
>>>
>>> Cheers,
>>> Andre
>>>  
>>>> ---
>>>>  hw/vesa.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/hw/vesa.c b/hw/vesa.c
>>>> index a665736a76d7..e988c0425946 100644
>>>> --- a/hw/vesa.c
>>>> +++ b/hw/vesa.c
>>>> @@ -70,6 +70,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>>>>  
>>>>  	vesa_base_addr			= (u16)r;
>>>>  	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
>>>> +	vesa_pci_device.bar_size[0]	= PCI_IO_SIZE;
>>>>  	r = device__register(&vesa_device);
>>>>  	if (r < 0)
>>>>  		return ERR_PTR(r);  
