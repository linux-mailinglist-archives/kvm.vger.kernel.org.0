Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7B371182D
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 22:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjEYUdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 16:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235016AbjEYUdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 16:33:33 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39073195;
        Thu, 25 May 2023 13:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685046809; x=1716582809;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=tfJkIOm9zuXhqmaaDhAkkMUG0+2BRG1q94R+sptnmuc=;
  b=BO9YZ85F486oH2WHJ6fH9MTRZFofWvVWkgHLpqEZ2JFnDfioT1G/F5x1
   O0QcnAtqftcit9o6AM9MsISdGZj76Eetp62MeyjFaWfuFvx6mSTI+CkPn
   R6iQBicTTccxMQWc/z/X3rIHB6NXkPXfHXsQIxqyhYJnxQ5Uh909VTYiy
   ZkaYFHXegWQ9NhGe+uR7XmVJMkqNcJs3ziZFqgJW23dqoelVcD6E40bVK
   s8vX3HPzzE/7THrNUprJ0c/NoBXee4fcEuhGKAlBJ/bkCbomVnaV0yK8I
   mPB1xhT+XtRpLYyUOSm+FcYxmr7wCT+vAEvmdfLlog5gf5mH+6KkChOES
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="440373482"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="440373482"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 13:33:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="655353264"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="655353264"
Received: from patelni-mobl1.amr.corp.intel.com (HELO [10.78.16.220]) ([10.78.16.220])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 13:33:28 -0700
Message-ID: <c49ed344-f521-b4b9-8a7a-a70600002358@linux.intel.com>
Date:   Thu, 25 May 2023 13:33:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: FW: [Bug 217472] New: ACPI _OSC features have different values in
 Host OS and Guest OS
Content-Language: en-US
From:   "Patel, Nirmal" <nirmal.patel@linux.intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org
References: <bug-217472-41252@https.bugzilla.kernel.org/>
 <ZGz2FQpHPKYgcc0+@bhelgaas>
 <20230523120626.5b76d289.alex.williamson@redhat.com>
 <BYAPR11MB3031739869CB639695896CEF98469@BYAPR11MB3031.namprd11.prod.outlook.com>
 <1f7f84a4-0df4-a413-ba30-cc2257980abd@linux.intel.com>
In-Reply-To: <1f7f84a4-0df4-a413-ba30-cc2257980abd@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/2023 1:19 PM, Patel, Nirmal wrote:

>> On Tue, 23 May 2023 12:21:25 -0500
>> Bjorn Helgaas <helgaas@kernel.org> wrote:
>>
>>> Hi Nirmal, thanks for the report!
>>>
>>> On Mon, May 22, 2023 at 04:32:03PM +0000, bugzilla-daemon@kernel.org wrote:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=217472
>>>> ...  
>>>> Created attachment 304301  
>>>>   --> 
>>>> https://bugzilla.kernel.org/attachment.cgi?id=304301&action=edit
>>>> Rhel9.1_Guest_dmesg
>>>>
>>>> Issue:
>>>> NVMe Drives are still present after performing hotplug in guest OS. 
>>>> We have tested with different combination of OSes, drives and Hypervisor. The issue is
>>>> present across all the OSes.   
>>> Maybe attach the specific commands to reproduce the problem in one of 
>>> these scenarios to the bugzilla?  I'm a virtualization noob, so I 
>>> can't visualize all the usual pieces.
>>>
>>>> The following patch was added to honor ACPI _OSC values set by BIOS 
>>>> and the patch helped to bring the issue out in VM/ Guest OS.
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git/comm
>>>> it/drivers/pci/controller/vmd.c?id=04b12ef163d10e348db664900ae7f611b
>>>> 83c7a0e
>>>>
>>>>
>>>> I also compared the values of the parameters in the patch in Host and Guest OS.
>>>> The parameters with different values in Host and Guest OS are:
>>>>
>>>> native_pcie_hotplug
>>>> native_shpc_hotplug
>>>> native_aer
>>>> native_ltr
>>>>
>>>> i.e.
>>>> value of native_pcie_hotplug in Host OS is 1.
>>>> value of native_pcie_hotplug in Guest OS is 0.
>>>>
>>>> I am not sure why "native_pcie_hotplug" is changed to 0 in guest.
>>>> Isn't it OSC_ managed parameter? If that is the case, it should have 
>>>> same value in Host and Guest OS.
>>> From your dmesg:
>>>  
>>>   DMI: Red Hat KVM/RHEL, BIOS 1.16.0-4.el9 04/01/2014
>>>   _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI EDR HPX-Type3]
>>>   _OSC: platform does not support [PCIeHotplug LTR DPC]
>>>   _OSC: OS now controls [SHPCHotplug PME AER PCIeCapability]
>>>   acpiphp: Slot [0] registered
>>>   virtio_blk virtio3: [vda] 62914560 512-byte logical blocks (32.2 
>>> GB/30.0 GiB)
>>>
>>> So the DMI ("KVM/RHEL ...") is the BIOS seen by the guest.  Doesn't 
>>> mean anything to me, but the KVM folks would know about it.  In any 
>>> event, the guest BIOS is different from the host BIOS, so I'm not 
>>> surprised that _OSC is different.
>> Right, the premise of the issue that guest and host should have the same OSC features is flawed.  The guest is a virtual machine that can present an entirely different feature set from the host.  A software hotplug on the guest can occur without any bearing to the slot status on the host.
>>
>>> That guest BIOS _OSC declined to grant control of PCIe native hotplug 
>>> to the guest OS, so the guest will use acpiphp (not pciehp, which 
>>> would be used if native_pcie_hotplug were set).
>>>
>>> The dmesg doesn't mention the nvme driver.  Are you using something 
>>> like virtio_blk with qemu pointed at an NVMe drive?  And you 
>>> hot-remove the NVMe device, but the guest OS thinks it's still 
>>> present?
>>>
>>> Since the guest is using acpiphp, I would think a hot-remove of a host 
>>> NVMe device should be noticed by qemu and turned into an ACPI 
>>> notification that the guest OS would consume.  But I don't know how 
>>> those connections work.
>> If vfio-pci is involved, a cooperative hot-unplug will attempt to unbind the host driver, which triggers a device request through vfio, which is ultimately seen as a hotplug eject operation by the guest.
>> Surprise hotplugs of assigned devices are not supported.  There's not enough info in the bz to speculate how this VM is wired or what actions are taken.  Thanks,
>>
>> Alex

Thanks Bjorn and Alex for quick response.
I agree with the analysis about guest BIOS not giving control of PCIe native hotplug to guest OS.

Adding some background about the patch f611b83c7a0e PCI: vmd: Honor ACPI _OSC on PCIe features.
The above patch was added to suppress AER messages when samsung drives were connected with VMD enabled. I believe AER was enabled in BIOS i.e. pre-OS VMD driver not by VMD linux driver. So the AER flooding would be seen even non-linux environment.

So with guest BIOS providing different values than the Host BIOS and adding this patch in VMD linux driver leaves direct assign functionality broken across all the hypervisors and guest OS combinations. As a result hotplug will not work which is a major issue.

Before this patch, VMD used pciehp.

What should be the ideal case here?

I am open to a better suggestion, but I can think of two options.

Option 1: Revert the patch f611b83c7a0e and suggest the AER fix to be added to the BIOS or Pre-OS vmd driver.

Option 2: VMD to enumerate all the devices and set native_pcie_hotplug for all the hotplug capable devices.

Thanks

