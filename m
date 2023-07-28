Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704FB767725
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 22:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjG1UlC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 28 Jul 2023 16:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjG1UlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 16:41:01 -0400
Received: from cmx-mtlrgo001.bell.net (mta-mtl-001.bell.net [209.71.208.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B1AE4F
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 13:40:59 -0700 (PDT)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [74.15.145.5]
X-RG-Env-Sender: leclercnorm@sympatico.ca
X-RG-Rigid: 64C35282000C691F
X-CM-Envelope: MS4xfKCXW02mfGjtP6v78kGp4nPQKSMCQilM3qvyxntT0vDewZnWLvvXZYkQ4pQd8qPCcuRcZ1aqIsr/Vrel01fnLa0wAhkoUzhFmXznBSZpGKJDnFYvPoR3
 UUTA+VZQ5I0CLmOC2VI+L8CjAfMQ3j4hasuVEEknwrXyDj+IDNkN9/HE7wvtpK86+2JZ02+9bh608xWVxS/Q/SoFj5Je04tjkUbVf4hM2xijHREG5gXawiGz
X-CM-Analysis: v=2.4 cv=W7Nb6Tak c=1 sm=1 tr=0 ts=64c427da
 a=vMtcqUOSM9xK0Dyo5NtYyw==:117 a=vMtcqUOSM9xK0Dyo5NtYyw==:17
 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=k_m-kdumAAAA:8 a=T6pNkRvUAAAA:8
 a=7yWcpKF2QZYQEeKRZowA:9 a=QEXdDO2ut3YA:10 a=QAyeqAmZ3dQA:10
 a=2aFmp3DG3lfw9CblUY6y:22 a=hgMNUkviuzi0Hbumswsj:22
Received: from smtpclient.apple (74.15.145.5) by cmx-mtlrgo001.bell.net (5.8.814) (authenticated as leclercnorm@sympatico.ca)
        id 64C35282000C691F; Fri, 28 Jul 2023 16:40:58 -0400
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From:   Normand Leclerc <leclercnorm@sympatico.ca>
Mime-Version: 1.0 (1.0)
Subject: Re: KVM PCI Passthrough IRQ issues
Date:   Fri, 28 Jul 2023 16:40:47 -0400
Message-Id: <A80D8450-19EB-4CA1-A9D6-A87E427B8452@sympatico.ca>
References: <20230728105111.3b0f89ac.alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org
In-Reply-To: <20230728105111.3b0f89ac.alex.williamson@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
X-Mailer: iPad Mail (20F75)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Thanks for the good information.  Tried forcing MSI in windows; didn’t work but the nointxmask worked like a charm.

Not sure why; I didn’t see any shared inrterrupt in lspci….  And moving to another PCIe slot seems to be less and less posible as motherboard manufacturers are replacing them with NVME slots.  You have to spend a lot of money to get a workstation motherboard if you want more than 1 usable PCIe slot; my motherboard has 2 but the second one is for SLI only and won’t work by its own (tried to put the card in, PC won’t boot).

Thanks again for the help!


Best regards,
Norm

Sent from my ENIAC

> On Jul 28, 2023, at 12:50 PM, Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> ﻿On Fri, 28 Jul 2023 06:20:36 -0400
> Normand Leclerc <leclercnorm@sympatico.ca> wrote:
> 
>> Hi,
>> 
>> I have a CameraLink capture card of which I do not have Linux
>> drivers.  I wanted to used it in Windows 11 under KVM.
>> 
>> I have managed to have the card recognized in the OS, installed
>> drivers and the system does see the clock and data valid; great!  But
>> this doesn’t happen without hickups; KVM has to be started twice.
>> The first time KVM starts, the driver tells me that there is not
>> enough ressources for the API.
>> 
>> Even though the card seems to be working well, I cannot capture
>> anything.  The software is not able to fully use the card.
>> 
>> The system is:
>> AMD Ryzen 7950x3d
>> ASROCK Steel Legend x670e
>> Teledyne XTIUM-CL MX4 (capture card)
>> Archlinux system (Linux omega 6.4.6-artix1-1 #1 SMP PREEMPT_DYNAMIC
>> Wed, 26 Jul 2023 13:47:50 +0000 x86_64 GNU/Linux)
>> 
>> lspci after boot for the card:
>> 
>> 01:00.0 Memory controller [0580]: Coreco Inc Device [11ec:f81b]
>>        Flags: fast devsel, IRQ 255, IOMMU group 12
>>        Memory at fb000000 (32-bit, non-prefetchable) [disabled]
>> [size=16M] Capabilities: [80] Power Management version 3
>>        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit+
>>        Capabilities: [c0] Express Endpoint, MSI 00
>>        Capabilities: [100] Advanced Error Reporting
>>        Capabilities: [150] Device Serial Number
>> 00-00-00-00-00-00-00-00 Capabilities: [300] Secondary PCI Express
>> 
>> 
>> After vfio driver assignment:
>> 
>> 01:00.0 Memory controller [0580]: Coreco Inc Device [11ec:f81b]
>>        Flags: fast devsel, IRQ 255, IOMMU group 12
>>        Memory at fb000000 (32-bit, non-prefetchable) [disabled]
>> [size=16M] Capabilities: [80] Power Management version 3
>>        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit+
>>        Capabilities: [c0] Express Endpoint, MSI 00
>>        Capabilities: [100] Advanced Error Reporting
>>        Capabilities: [150] Device Serial Number
>> 00-00-00-00-00-00-00-00 Capabilities: [300] Secondary PCI Express
>>        Kernel driver in use: vfio-pci
>> 
>> Starting KVM first time (second time is the same):
>> 
>> 01:00.0 Memory controller [0580]: Coreco Inc Device [11ec:f81b]
>>        Flags: fast devsel, IRQ 135, IOMMU group 12
>>        Memory at fb000000 (32-bit, non-prefetchable) [disabled]
>> [size=16M] Capabilities: [80] Power Management version 3
>>        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit+
>>        Capabilities: [c0] Express Endpoint, MSI 00
>>        Capabilities: [100] Advanced Error Reporting
>>        Capabilities: [150] Device Serial Number
>> 00-00-00-00-00-00-00-00 Capabilities: [300] Secondary PCI Express
>>        Kernel driver in use: vfio-pci
>> 
>> First time KVM starts, lsirq does not show IRQ 135; second time, it
>> does.
>> 
>> If kernel has not been started with irqpoll, I get the infamous
>> “nobody cared” message and irq135 gets disabled.  Running kernel with
>> irqpoll, lsirq shows a whole bunch on interrupts (probably at each
>> frame the grabber sees).
>> 
>> It is as if the interrupt assigned to the card is not what KVM is
>> using to pass down to the guest Windows machine.  The interrupt does
>> not get to the capture card’s software and it fails.
> 
> The "irqpoll" option the kernel suggests for spurious interrupts really
> doesn't work with device assignment.  It sounds like INTx disable
> and/or status reporting is broken on this device.  The device supports
> MSI, but clearly doesn't seem to be using it.  You can read a bit about
> how vfio interrupts work and how you might make Windows use MSI here:
> 
> http://vfio.blogspot.com/2014/09/vfio-interrupts-and-how-to-coax-windows.html
> 
> Another option is to use the nointxmask=1 option of the vfio-pci module
> which will register the legacy INTx interrupt of the device as
> exclusive.  This removes our dependency on working INTx disable and
> status reporting, but it comes at the cost of sometimes being very
> difficult to configure.  You might need to install the card into a
> different slot or potentially even disable other drivers for devices
> that try to share the interrupt line with this device.  Thanks,
> 
> Alex
> 
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
> 

