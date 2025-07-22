Return-Path: <kvm+bounces-53068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18619B0D0C1
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 06:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C052B1AA7D0F
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 04:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0813528C00B;
	Tue, 22 Jul 2025 04:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="reloDuwb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB1F5223;
	Tue, 22 Jul 2025 04:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156895; cv=none; b=KpfzX2FnYAF+e/rVtZJ0Jb0yf4LM4Dm+tijzqgBZbtpJVnZi7TH6zqj7/Bzpxn+z1W58PjO1Fx7EZTNb6jeaQfGBzZMG1TuujWdT3Vtk9Wl0JAY31NvYbIUiKc4DR9N1vB1zgE2HyxJtJZs/VLPqcU5YT9i85+a5C5RiywD+kII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156895; c=relaxed/simple;
	bh=hd0DO3IvY7D/o1H3RXDIIZ4Xokoc9Zt5xzE9us69fXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ipbBJjIDkuC68cfvBRhT8SJcER1ZeKt7MGApu7LqSqsjD7ebgSYZSfz9Z3drwltPM7mYnyb42njyeU34qcag793yI5rSjFVbCczh7pfjMcEE7fHqHu1nlcnrW/2m5Pg3WQ96MKah/vBY2Vc2Pgsf6rmcjgz2Y80DQUBWgDp0w3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=reloDuwb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DFFC4CEEB;
	Tue, 22 Jul 2025 04:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753156894;
	bh=hd0DO3IvY7D/o1H3RXDIIZ4Xokoc9Zt5xzE9us69fXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=reloDuwbj2E9SGlqgx3RNS2JkQMF8PnexnGVFb3EyMPAGubdZEPBzWjfNMR2JJE7A
	 m5+plSlsZ6v2KtLe1nv0cFa6klRySzyZteUvEg+eUW81dZc8JZDb+ApCHlWe/4N20+
	 H2Cwcq7yDorGXCvfuLuXKfejMcaxZx585LbYr8v8WrLr0tt77eW8ZqTbAyglzRFJ6J
	 F433LzMIsrGKIjxjZPFqCQvUDBuKnCg5nuakM6GUwiDrtCJcc3poZwWeiqndTOjapr
	 GqJLiHmsxN3tilTLBeCkP89xf0FrGZLsGWTHyMW/IlghGaOiv4T0jtLm5mtNPVM9gx
	 HGfciKJSMpQ5Q==
Message-ID: <577c103b-f68f-4748-a7ba-3e88fc71f8d7@kernel.org>
Date: Mon, 21 Jul 2025 23:01:31 -0500
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
References: <20250722015934.GA2763711@bhelgaas>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20250722015934.GA2763711@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/21/25 8:59 PM, Bjorn Helgaas wrote:
> On Mon, Jul 21, 2025 at 07:28:07PM -0500, Mario Limonciello wrote:
>> On 7/21/25 6:00 PM, Bjorn Helgaas wrote:
>>> On Fri, Jul 18, 2025 at 12:44:11PM -0500, Mario Limonciello wrote:
>>>> On 7/18/2025 12:36 PM, Bjorn Helgaas wrote:
>>>>> On Fri, Jul 18, 2025 at 12:29:05PM -0500, Mario Limonciello wrote:
>>>>>> On 7/18/2025 12:25 PM, Bjorn Helgaas wrote:
>>>>>>> On Thu, Jul 17, 2025 at 12:38:12PM -0500, Mario Limonciello wrote:
>>>>>>>> From: Mario Limonciello <mario.limonciello@amd.com>
>>>>>>>>
>>>>>>>> On systems with multiple GPUs there can be uncertainty which GPU is the
>>>>>>>> primary one used to drive the display at bootup. In some desktop
>>>>>>>> environments this can lead to increased power consumption because
>>>>>>>> secondary GPUs may be used for rendering and never go to a low power
>>>>>>>> state. In order to disambiguate this add a new sysfs attribute
>>>>>>>> 'boot_display' that uses the output of video_is_primary_device() to
>>>>>>>> populate whether a PCI device was used for driving the display.
>>>>>>>
>>>>>>>> +What:		/sys/bus/pci/devices/.../boot_display
>>>>>>>> +Date:		October 2025
>>>>>>>> +Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
>>>>>>>> +Description:
>>>>>>>> +		This file indicates that displays connected to the device were
>>>>>>>> +		used to display the boot sequence.  If a display connected to
>>>>>>>> +		the device was used to display the boot sequence the file will
>>>>>>>> +		be present and contain "1".
>>>>>>>
>>>>>>>>      int __must_check pci_create_sysfs_dev_files(struct pci_dev *pdev)
>>>>>>>>      {
>>>>>>>> +	int retval;
>>>>>>>> +
>>>>>>>>      	if (!sysfs_initialized)
>>>>>>>>      		return -EACCES;
>>>>>>>> +	retval = pci_create_boot_display_file(pdev);
>>>>>>>
>>>>>>> In addition to Mani's question about whether /sys/bus/pci/ is
>>>>>>> the right place for this (which is a very good question), it's
>>>>>>> also been pointed out to me that we've been trying to get rid
>>>>>>> of pci_create_sysfs_dev_files() for years.
>>>>>>>
>>>>>>> If it's possible to make this a static attribute that would be
>>>>>>> much, much cleaner.
>>>>>>
>>>>>> Right - I tried to do this, but the problem is at the time the
>>>>>> PCI device is created the information needed to make the
>>>>>> judgement isn't ready.  The options end up being:
>>>>>> * a sysfs file for every display device with 0/1
>>>>>> * a sysfs file that is not accurate until later in the boot
>>>>>
>>>>> What's missing?  The specifics might be helpful if someone has
>>>>> another crack at getting rid of pci_create_sysfs_dev_files() in
>>>>> the future.
>>>>
>>>> The underlying SCREEN_INFO code tries to walk through all the PCI
>>>> devices in a loop, but at the time all the devices are walked the
>>>> memory regions associated with the device weren't populated.
>>>
>>> Which loop are you referring to that walks through all the PCI
>>> devices?  I see this:
>>>
>>>     efifb_set_system
>>>       for_each_pci_dev(dev)
>>>
>>> but that only looks at VGA devices and IIUC you also want to look at
>>> non-VGA GPUs.
> 
> [I assume the loop is the "while (pdev =
> pci_get_base_class(PCI_BASE_CLASS_DISPLAY))" in
> __screen_info_pci_dev(), which indeed walks through all known PCI
> devices]
> 
>>> I don't see a loop in *this* series, where the screen_info path looks
>>> like this:
>>>
>>>     pci_create_boot_display_file
>>>       video_is_primary_device
>>>         screen_info_pci_dev      # added by "fbcon: Use screen info to find primary device"
>>>           screen_info_resources
>>>           __screen_info_pci_dev
>>>
>>> and we're basically matching the screen_info base/address with BAR
>>> values.
>>>
>>> The usual problem is that BARs may not have been assigned by the
>>> time pci_device_add() -> device_add() creates the static
>>> attributes.
>>>
>>> So we call pci_assign_unassigned_root_bus_resources() to assign
>>> all the BARs.  Then we call pci_create_sysfs_dev_files(), where
>>> pci_create_resource_files() creates a "resource%d" file for each
>>> BAR.
>>>
>>> But since we're trying to find the GPU that was used by BIOS, I
>>> assume its BARs were programmed by BIOS and we shouldn't have to
>>> wait until after pci_assign_unassigned_root_bus_resources().
>>
>> Yes it was screen_info_pci_dev() and __screen_info_pci_dev().  The
>> resources weren't ready on the first call into
>> __screen_info_pci_dev().
>>
>> That's why the attribute needed to be created later.
> 
> I don't understand this.  IIUC, screen_info contains addresses
> programmed by BIOS.  If we want to use that to match with a PCI
> device, we have to compare with the BAR contents *before* Linux does
> any assignments of its own.
> 
> So the only thing this should depend on is the BAR value at BIOS ->
> Linux handoff, which we know at the time of device_add(), and we
> should be able to do something like this:
> 
>    bool pci_video_is_primary_device(struct pci_dev *pdev)
>    {
>      struct screen_info *si = &screen_info;
>      struct resource res[SCREEN_INFO_MAX_RESOURCES];
>      ssize_t i, numres;
> 
>      numres = screen_info_resources(si, res, ARRAY_SIZE(res));
>      ...
> 
>      for (i = 0; i < numres; ++i) {
>        if (pci_find_resource(pdev, &res[i]))
>          return true;
>      }
> 
>      return false;
>    }
> 
>    static umode_t pci_dev_boot_display_is_visible(...)
>    {
>      struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
> 
>      if (pci_video_is_primary_device(pdev))
>        return a->mode;
> 
>      return 0;
>    }
> 
> We should be able to check each BAR of each device in this path, with
> no loop through the devices at all:
> 
>    pci_device_add
>      device_add
>        device_add_attrs
>          device_add_groups
>            ...
>              create_files
>                grp->is_visible()
>                  pci_dev_boot_display_is_visible
> 
> Bjorn

You're spot on, I did a test and this works.  I'll clean it up and put 
it on the list and we can decide between this way and moving to drm.


