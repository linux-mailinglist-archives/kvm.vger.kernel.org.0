Return-Path: <kvm+bounces-50909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D02BEAEA896
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 23:12:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9AD787AB641
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 21:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21EE025E477;
	Thu, 26 Jun 2025 21:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NdEtFuxl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E7E1D7984;
	Thu, 26 Jun 2025 21:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750972345; cv=none; b=N06qdniNT2jKBIra+4M2PPthSkVJ0cRYYqAHkT4ADSRuyoOHXTG++7iD+fkPEKCp4Ty1Rfs3L5DxWljKNmmCHon7dSpA67eFTPdiIY1d9k9kUiAiZdCzBtbZ87GqZqMFDe0X7gWhlQZhQLSDf73IkSPPD2jRDNOYNW7CPT0XqRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750972345; c=relaxed/simple;
	bh=1HGJ3l6ikdw5NCSll50pAw9X5BjsMp1eQTlXjZQSkac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=utohfPTG4d3AhTs/LEVwcbjvkRCxgTYqqos8tVE2Y6iw7jBczDKwam9opmlFt5c6NdfkVX6jfPIcnoAot7WWR/rnFW/unEG85ykl2tlSLUv2o7BBFb1UuRYQInAaDcz/sF+hd2MdURT9dQK5QH6AMpwDtJM9JMhzs185mscmWFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NdEtFuxl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432F4C4CEEB;
	Thu, 26 Jun 2025 21:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750972344;
	bh=1HGJ3l6ikdw5NCSll50pAw9X5BjsMp1eQTlXjZQSkac=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NdEtFuxltw0oevgdXEQ5cl0fDHM2QHdYqsqqW3HNosUK/GcSDLIPpUaM5kKYBHCV5
	 b7tRWS/EqxZHvlaO6XqF5zSrPTtNLxEIWaJh+oAyZNgT8or6xhUmXL2Omj456tIZ1u
	 71RnxnZ22zI0pGFx8RfNJWfrVuB60YkTbsiIxVXaJcj8U1QgUkql01/UNMQJtlH+vk
	 8A5sKrunL/G9C0wPJJ8FZxO4MKWXS9tQ2VG3UgHcglHz6MN+WHFIs8yGB9a076ccY4
	 79wJ9jH8bHDWhhzFflge/EV30PGMgQPDHu2TQlVLKMU8xTUQG1ZAaGB8NN8/jn6pus
	 ynlk/bA0OHrMA==
Message-ID: <58625a35-4a3e-4c91-939d-9f0d6635f8c0@kernel.org>
Date: Thu, 26 Jun 2025 16:12:21 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] PCI: Add a new 'boot_display' attribute
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
 Mario Limonciello <mario.limonciello@amd.com>
References: <20250626204508.GA1639269@bhelgaas>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20250626204508.GA1639269@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/2025 3:45 PM, Bjorn Helgaas wrote:
> On Tue, Jun 24, 2025 at 03:30:42PM -0500, Mario Limonciello wrote:
>> From: Mario Limonciello <mario.limonciello@amd.com>
>>
>> On systems with multiple GPUs there can be uncertainty which GPU is the
>> primary one used to drive the display at bootup. In order to disambiguate
>> this add a new sysfs attribute 'boot_display' that uses the output of
>> video_is_primary_device() to populate whether a PCI device was used for
>> driving the display.
>>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Question below.
> 
>> ---
>> v4:
>>   * new patch
>> ---
>>   Documentation/ABI/testing/sysfs-bus-pci |  9 +++++++++
>>   drivers/pci/pci-sysfs.c                 | 14 ++++++++++++++
>>   2 files changed, 23 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>> index 69f952fffec72..897cfc1b0de0f 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>> @@ -612,3 +612,12 @@ Description:
>>   
>>   		  # ls doe_features
>>   		  0001:01        0001:02        doe_discovery
>> +
>> +What:		/sys/bus/pci/devices/.../boot_display
>> +Date:		October 2025
>> +Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
>> +Description:
>> +		This file indicates whether the device was used as a boot
>> +		display. If the device was used as the boot display, the file
>> +		will contain "1". If the device is a display device but wasn't
>> +		used as a boot display, the file will contain "0".
> 
> Is there a reason to expose this file if it wasn't a boot display
> device?  Maybe it doesn't need to exist at all unless it contains "1"?

I was mostly thinking that it's a handy way for userspace to know 
whether the kernel even supports this feature.  If userspace sees that 
file on any GPU as it walks a list then it knows it can use that for a hint.

But if you would rather it only shows up for the boot display yes it's 
possible to do I think.  It's just more complexity to the visibility 
lookup to also call video_is_primary_device().

LMK which way you want to go and I'll respin the series with your tags 
and the robot fix.

> 
>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>> index 268c69daa4d57..5bbf79b1b953d 100644
>> --- a/drivers/pci/pci-sysfs.c
>> +++ b/drivers/pci/pci-sysfs.c
>> @@ -30,6 +30,7 @@
>>   #include <linux/msi.h>
>>   #include <linux/of.h>
>>   #include <linux/aperture.h>
>> +#include <asm/video.h>
>>   #include "pci.h"
>>   
>>   #ifndef ARCH_PCI_DEV_GROUPS
>> @@ -679,6 +680,13 @@ const struct attribute_group *pcibus_groups[] = {
>>   	NULL,
>>   };
>>   
>> +static ssize_t boot_display_show(struct device *dev, struct device_attribute *attr,
>> +				 char *buf)
>> +{
>> +	return sysfs_emit(buf, "%u\n", video_is_primary_device(dev));
>> +}
>> +static DEVICE_ATTR_RO(boot_display);
>> +
>>   static ssize_t boot_vga_show(struct device *dev, struct device_attribute *attr,
>>   			     char *buf)
>>   {
>> @@ -1698,6 +1706,7 @@ late_initcall(pci_sysfs_init);
>>   
>>   static struct attribute *pci_dev_dev_attrs[] = {
>>   	&dev_attr_boot_vga.attr,
>> +	&dev_attr_boot_display.attr,
>>   	NULL,
>>   };
>>   
>> @@ -1710,6 +1719,11 @@ static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
>>   	if (a == &dev_attr_boot_vga.attr && pci_is_vga(pdev))
>>   		return a->mode;
>>   
>> +#ifdef CONFIG_VIDEO
>> +	if (a == &dev_attr_boot_display.attr && pci_is_display(pdev))
>> +		return a->mode;
>> +#endif
>> +
>>   	return 0;
>>   }
>>   
>> -- 
>> 2.43.0
>>


