Return-Path: <kvm+bounces-50910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B95AEA89B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 23:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54C164E2C11
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 21:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A6325F985;
	Thu, 26 Jun 2025 21:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6II7Rpa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D330125CC72;
	Thu, 26 Jun 2025 21:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750972504; cv=none; b=RCYdqoTRvK2d7EBJ7CEonLQPMZQ7r0BXdmUtEXCCRjNw9Yez0nXU0uY0PFti4XUrJ90sDOnmCW5h9jcpx1xTq5iN4b+3yuVxpwnXTwzWpsPefjA/maBMendhYkWUUw6csvJSvepPqG+EstfIkbVNoYSmaY4VQFtCw4RDzidEh+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750972504; c=relaxed/simple;
	bh=i8F7RXd01Dywi46VTNnRRqKmfFkGAyqmAkKujf2xchs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IRwq12+5tYMzrMTbt+Y07hb3McOK4S8ILXWQIpllZWUrQAcL0kSIRXcRtQMhEavVCfCL9ZBgKhMxa8M2ERpY+laIZ5GA6TQjeOl+cOey5lzQ/F0X6yg2D16C7xkzQK0w+K8pVOVLaLsrXFkb3OlgXHeMKVfOYrh9sAd+sLaqo3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6II7Rpa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0855C4CEEB;
	Thu, 26 Jun 2025 21:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750972503;
	bh=i8F7RXd01Dywi46VTNnRRqKmfFkGAyqmAkKujf2xchs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y6II7RpaOiClQehE8kaAjyaoRjCX+OXC9ykShPztNunmgiMpSEAFLOWaw/OUEMGMU
	 WfUzBsd3nqWtdl+TXz5ZguAT6Ma0iRJwd2WKFxoO46JNo5R25xWgkMyAmBcp68oOD/
	 +MW+q/R2LJpxc3FCXl7I/Lbl1yHzuTP09EmwQ1y+DxXn23VuBZFEdju6CPBbf+WThD
	 +KfZaYM303+jOO+oR80H64o6Lr0VoRw1XWMWeL8EF1xrqOx4cocfuxMyL67T0ZTNji
	 pBoUSuTal57aPiRNSSShVeDGcuCjPHLOxA6PQ8jGUlUFAOA58DQiBiAQ/jVgxvZJRU
	 TqKGV357+KxBg==
Message-ID: <d8c7c973-0285-4891-9b4a-c8e3d4f0d6b7@kernel.org>
Date: Thu, 26 Jun 2025 16:14:59 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/9] PCI: Add helper for checking if a PCI device is a
 display controller
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Lukas Wunner <lukas@wunner.de>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux.dev>,
 "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
 "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
 "open list:SOUND" <linux-sound@vger.kernel.org>,
 Daniel Dadap <ddadap@nvidia.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 Simona Vetter <simona.vetter@ffwll.ch>
References: <20250626204347.GA1638339@bhelgaas>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20250626204347.GA1638339@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/2025 3:43 PM, Bjorn Helgaas wrote:
> On Tue, Jun 24, 2025 at 03:30:34PM -0500, Mario Limonciello wrote:
>> From: Mario Limonciello <mario.limonciello@amd.com>
>>
>> Several places in the kernel do class shifting to match whether a
>> PCI device is display class.  Introduce a helper for those places to
>> use.
>>
>> Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
>> Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Not sure how this should be merged, let me know if you want me to do
> something with it.

Unless there is opposition I think it's best to take it through PCI.

It's a trivial change to most the other drivers.  If there is opposition 
I think there will need to be an immutable tag for the others to merge.

> 
>> ---
>>   include/linux/pci.h | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 05e68f35f3923..e77754e43c629 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -744,6 +744,21 @@ static inline bool pci_is_vga(struct pci_dev *pdev)
>>   	return false;
>>   }
>>   
>> +/**
>> + * pci_is_display - Check if a PCI device is a display controller
>> + * @pdev: Pointer to the PCI device structure
>> + *
>> + * This function determines whether the given PCI device corresponds
>> + * to a display controller. Display controllers are typically used
>> + * for graphical output and are identified based on their class code.
>> + *
>> + * Return: true if the PCI device is a display controller, false otherwise.
>> + */
>> +static inline bool pci_is_display(struct pci_dev *pdev)
>> +{
>> +	return (pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY;
>> +}
>> +
>>   #define for_each_pci_bridge(dev, bus)				\
>>   	list_for_each_entry(dev, &bus->devices, bus_list)	\
>>   		if (!pci_is_bridge(dev)) {} else
>> -- 
>> 2.43.0
>>


