Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC4EF24F1E
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 14:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfEUMqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 08:46:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727686AbfEUMqR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 May 2019 08:46:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4LCgJeR044749
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 08:46:16 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2smhdc8qu7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 08:46:15 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 21 May 2019 13:46:13 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 May 2019 13:46:08 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4LCk70438469882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 12:46:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F052AA4055;
        Tue, 21 May 2019 12:46:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66FBEA405B;
        Tue, 21 May 2019 12:46:06 +0000 (GMT)
Received: from [9.152.222.56] (unknown [9.152.222.56])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 May 2019 12:46:06 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v2 4/4] vfio: vfio_iommu_type1: implement
 VFIO_IOMMU_INFO_CAPABILITIES
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.vnet.ibm.com, borntraeger@de.ibm.com,
        walling@linux.ibm.com, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        robin.murphy@arm.com
References: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
 <1558109810-18683-5-git-send-email-pmorel@linux.ibm.com>
 <20190517104143.240082b5@x1.home>
 <92b6ad4e-9a49-636b-9225-acca0bec4bb7@linux.ibm.com>
 <ed193353-56f0-14b5-f1fb-1835d0a6c603@linux.ibm.com>
 <20190520162737.7560ad7c.cohuck@redhat.com>
 <23f6a739-be4f-7eda-2227-2994fdc2325a@linux.ibm.com>
 <20190520122352.73082e52@x1.home>
 <9dc0a8de-b850-df21-e3b7-21b7c2a373a3@linux.ibm.com>
 <20190521131120.0b2afb37.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Tue, 21 May 2019 14:46:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190521131120.0b2afb37.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19052112-0016-0000-0000-0000027DF974
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052112-0017-0000-0000-000032DAE368
Message-Id: <6216c287-c741-0600-d5b7-cbdaf2214661@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-21_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=914 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905210080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/2019 13:11, Cornelia Huck wrote:
> On Tue, 21 May 2019 11:14:38 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> 1) A short description, of zPCI functions and groups
>>
>> IN Z, PCI cards, leave behind an adapter between subchannels and PCI.
>> We access PCI cards through 2 ways:
>> - dedicated PCI instructions (pci_load/pci_store/pci/store_block)
>> - DMA
> 
> Quick question: What about the new pci instructions? Anything that
> needs to be considered there?

No and yes.

No because they should be used when pci_{load,stor,store_block} are 
interpreted AFAIU.
And currently we only use interception.

Yes, because, the CLP part, use to setup the translations IIUC, (do not 
ask me for details now), will need to be re-issued by the kernel after 
some modifications and this will also need a way from QEMU S390 PCI down 
to the ZPCI driver.
Way that I try to setup with this patch.

So answer is not now but we should keep in mind that we will 
definitively need a way down to the zpci low level in the host.

> 
>> We receive events through
>> - Adapter interrupts
> 
> Note for the non-s390 folks: These are (I/O) interrupts that are not
> tied to a specific device. MSI-X is mapped to this.
> 
>> - CHSC events
> 
> Another note for the non-s390 folks: This is a notification mechanism
> that is using machine check interrupts; more information is retrieved
> via a special instruction (chsc).
> 

thanks, it is yes better to explain better :)

>>
>> The adapter propose an IOMMU to protect the DMA
>> and the interrupt handling goes through a MSIX like interface handled by
>> the adapter.
>>
>> The architecture specific PCI do the interface between the standard PCI
>> level and the zPCI function (PCI + DMA/IOMMU/Interrupt)
>>
>> To handle the communication through the "zPCI way" the CLP interface
>> provides instructions to retrieve informations from the adapters.
>>
>> There are different group of functions having same functionalities.
>>
>> clp_list give us a list from zPCI functions
>> clp_query_pci_function returns informations specific to a function
>> clp_query_group returns information on a function group
>>
>>
>> 2) Why do we need it in the guest
>>
>> We need to provide the guest with information on the adapters and zPCI
>> functions returned by the clp_query instruction so that the guest's
>> driver gets the right information on how the way to the zPCI function
>> has been built in the host.
>>
>>
>> When a guest issues the CLP instructions we intercept the clp command in
>> QEMU and we need to feed the response with the right values for the guest.
>> The "right" values are not the raw CLP response values:
>>
>> - some identifier must be virtualized, like UID and FID,
>>
>> - some values must match what the host received from the CLP response,
>> like the size of the transmited blocks, the DMA Address Space Mask,
>> number of interrupt, MSIA
>>
>> - some other must match what the host handled with the adapter and
>> function, the start and end of DMA,
>>
>> - some what the host IOMMU driver supports (frame size),
>>
>>
>>
>> 3) We have three different way to get This information:
>>
>> The PCI Linux interface is a standard PCI interface and some Z specific
>> information is available in sysfs.
>> Not all the information needed to be returned inside the CLP response is
>> available.
>> So we can not use the sysfs interface to get all the information.
>>
>> There is a CLP ioctl interface but this interface is not secure in that
>> it returns the information for all adapters in the system.
>>
>> The VFIO interface offers the advantage to point to a single PCI
>> function, so more secure than the clp ioctl interface.
>> Coupled with the s390_iommu we get access to the zPCI CLP instruction
>> and to the values handled by the zPCI driver.
>>
>>
>> 4) Until now we used to fill the CLP response to the guest inside QEMU
>> with fixed values corresponding to the only PCI card we supported.
>> To support new cards we need to get the right values from the kernel out.
> 
> IIRC, the current code fills in values that make sense for one specific
> type of card only, right?

yes, right

> We also use the same values for emulated
> cards (virtio); I assume that they are not completely weird for that
> case...
> 

No they are not.

For emulated cards, all is done inside QEMU, we do not need kernel 
access, the emulated cards get a specific emulation function and group 
assigned with pre-defined values.

I sent a QEMU patch related to this.
Even the kernel interface will change with the changes in the kernel 
patch, the emulation should continue in this way.

Regards,
Pierre










-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

