Return-Path: <kvm+bounces-52918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C5DB0A985
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 19:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC51B3AA8B6
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA372E716C;
	Fri, 18 Jul 2025 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyH3+WVK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3DC1C7017;
	Fri, 18 Jul 2025 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752859749; cv=none; b=YeIdsBaEhiaOacNGUNhPPFOHpYoROS6P2OIvUMIEyhMN/ksKVR0U38SsvV48d+/7cAbmzE8IXKjOR8D3/boikMdOeuV3y/OBIB0ceQqZvS3zgQC74F8Z5bWtpADeVz3RVRfLVcFb/rbUGUqAapkV13d05flWo4qoW5zuZ7rK2Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752859749; c=relaxed/simple;
	bh=wf2avfRaqrJbyST3UyYxQ4ZifExp4p/EYoTF5IOX4og=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ltZ1BG8RG+/rHym1Pi7M288iiBY4FOV0sQ7GNjKLJdVTvvuBWB/eMvg0DlcBdx2GR17leRkhh48PT3/5lgsqiqrUSTEldjIIiPEvrNisXvBfPOX1hv3AtNg+mC6dTEL8ZRANc6qZ30j+BR3M+fqcy77MK0GUZft+kz9T5svVaGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyH3+WVK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22618C4CEEB;
	Fri, 18 Jul 2025 17:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752859748;
	bh=wf2avfRaqrJbyST3UyYxQ4ZifExp4p/EYoTF5IOX4og=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oyH3+WVK+94ytu5NuypH0ZbrxnNvx7RPO9oCOGa6WbgJuE1xZPcQ2STcJW2KoiAp/
	 qKhB/KbYJwrjekI6pYGFvptl61nwKOoMR/V8Yh0Vn3l3iTcw0krdE2jhfGQ0aTuWfw
	 9JCKRJeBR65tpSt55AdSDeWOfxbaMjBtnOYGFVFrFdZCFYL6netTPMTj5+uAc0hLS5
	 biDg7wo9Wbz3vNKA2CvzBSALJPdmAKZ7jwoJ5lTats7na+696mdexLBPWcfnfAu6L/
	 IyTptfws8krwmPdyOeMlDzXzvdVhXvdaIcm7LX5L6sVW2YhhF+ugNSkkmcDJSMJme0
	 MfINcWjsQaDeg==
Message-ID: <ee2907ba-bcda-4e60-a764-078c59b463a8@kernel.org>
Date: Fri, 18 Jul 2025 12:29:05 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 9/9] PCI: Add a new 'boot_display' attribute
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: David Airlie <airlied@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Simona Vetter <simona@ffwll.ch>, Lukas Wunner <lukas@wunner.de>,
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
 Mario Limonciello <mario.limonciello@amd.com>
References: <20250718172545.GA2703510@bhelgaas>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20250718172545.GA2703510@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 12:25 PM, Bjorn Helgaas wrote:
> On Thu, Jul 17, 2025 at 12:38:12PM -0500, Mario Limonciello wrote:
>> From: Mario Limonciello <mario.limonciello@amd.com>
>>
>> On systems with multiple GPUs there can be uncertainty which GPU is the
>> primary one used to drive the display at bootup. In some desktop
>> environments this can lead to increased power consumption because
>> secondary GPUs may be used for rendering and never go to a low power
>> state. In order to disambiguate this add a new sysfs attribute
>> 'boot_display' that uses the output of video_is_primary_device() to
>> populate whether a PCI device was used for driving the display.
> 
>> +What:		/sys/bus/pci/devices/.../boot_display
>> +Date:		October 2025
>> +Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
>> +Description:
>> +		This file indicates that displays connected to the device were
>> +		used to display the boot sequence.  If a display connected to
>> +		the device was used to display the boot sequence the file will
>> +		be present and contain "1".
> 
>>   int __must_check pci_create_sysfs_dev_files(struct pci_dev *pdev)
>>   {
>> +	int retval;
>> +
>>   	if (!sysfs_initialized)
>>   		return -EACCES;
>>   
>> +	retval = pci_create_boot_display_file(pdev);
> 
> In addition to Mani's question about whether /sys/bus/pci/ is the
> right place for this (which is a very good question), it's also been
> pointed out to me that we've been trying to get rid of
> pci_create_sysfs_dev_files() for years.
> 
> If it's possible to make this a static attribute that would be much,
> much cleaner.

Right - I tried to do this, but the problem is at the time the PCI 
device is created the information needed to make the judgement isn't 
ready.  The options end up being:
* a sysfs file for every display device with 0/1
* a sysfs file that is not accurate until later in the boot

So IMO it /needs/ to come later.

> 
>> +	if (retval)
>> +		return retval;
>> +
>>   	return pci_create_resource_files(pdev);
>>   }
>>   
>> @@ -1671,6 +1716,7 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
>>   	if (!sysfs_initialized)
>>   		return;
>>   
>> +	pci_remove_boot_display_file(pdev);
>>   	pci_remove_resource_files(pdev);
>>   }
>>   
>> -- 
>> 2.43.0
>>


