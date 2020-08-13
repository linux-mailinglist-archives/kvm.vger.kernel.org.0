Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365A7243ACA
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 15:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHMN3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 09:29:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbgHMN3D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 09:29:03 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DD3HWE185766;
        Thu, 13 Aug 2020 09:28:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EjBWs1XLXJ3XQrKu6R6+m8xBwYJxjpkGFS0zt7Y9MQk=;
 b=cuHLptR3OwTZ/jcxf1v7/aa/uRrD1tF926Rklm7GH6fXQ5ZvejHEtb90xZrUkOosl+s+
 SYj6HcKYK5y8PQ9s4Hcihjvs+ZLfYMxBJVyyHzTfjaBhZCDN27ThBBUzMr4GroV30y0t
 A0cDrT9EKfo07as8ZyAQhzy68WXHeB7fypC7dbhFmLDuFo/VCGXwSpBAah+4IJ6r1qpU
 Py9Jq4TOYIHIxDmx+mA+t6rdSGc0qcF76t263TBrRHd/uwhFpnRx/5I2JCodPWrhyHJK
 RjRiN0NXifKy/QiAOn5xqnjR644usyPgAZKHCu9Vy8a87oj63ltB8ACvxM4cPwv/jCP2 bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32vqcprv2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 09:28:58 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DD3SNk186940;
        Thu, 13 Aug 2020 09:28:58 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32vqcprv18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 09:28:57 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DDR2TP032580;
        Thu, 13 Aug 2020 13:28:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 32skp83eg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 13:28:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DDSqdE64750054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 13:28:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 937FB4C04A;
        Thu, 13 Aug 2020 13:28:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E369B4C046;
        Thu, 13 Aug 2020 13:28:51 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.93.1])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Aug 2020 13:28:51 +0000 (GMT)
Subject: Re: [PATCH v2] PCI: Introduce flag for detached virtual functions
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, pmorel@linux.ibm.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-s390@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
References: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com>
 <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com>
 <CAOSf1CFjaVoeTyk=cLmWhBB6YQrHQkcD8Aj=ZYrB4kYc-rqLiw@mail.gmail.com>
 <2a862199-16c8-2141-d27f-79761c1b1b25@linux.ibm.com>
 <CAOSf1CE6UyL9P31S=rAG=VZKs-JL4Kbq3VMZNhyojHbkPHSw0Q@mail.gmail.com>
 <dc79c8a9-1bbc-380f-741f-bca270a34483@linux.ibm.com>
 <17be8c41-8989-f1da-a843-30f0761f42de@linux.ibm.com>
 <6ffa5f39-3607-88c7-81f9-dc97d12d09df@linux.ibm.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <f862f188-1f4d-d83d-452e-7fbda55426c7@linux.ibm.com>
Date:   Thu, 13 Aug 2020 15:28:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6ffa5f39-3607-88c7-81f9-dc97d12d09df@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_10:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/13/20 3:11 PM, Matthew Rosato wrote:
> On 8/13/20 8:34 AM, Niklas Schnelle wrote:
>>
>>
>> On 8/13/20 12:40 PM, Niklas Schnelle wrote:
>>>
>>>
>>> On 8/13/20 11:59 AM, Oliver O'Halloran wrote:
>>>> On Thu, Aug 13, 2020 at 7:00 PM Niklas Schnelle <schnelle@linux.ibm.com> wrote:
>>>>>
>>>>>
>>>>> On 8/13/20 3:55 AM, Oliver O'Halloran wrote:
>>>>>> On Thu, Aug 13, 2020 at 5:21 AM Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>>>>> *snip*
>>>>>>> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
>>>>>>> index 3902c9f..04ac76d 100644
>>>>>>> --- a/arch/s390/pci/pci.c
>>>>>>> +++ b/arch/s390/pci/pci.c
>>>>>>> @@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
>>>>>>>   {
>>>>>>>          struct zpci_dev *zdev = to_zpci(pdev);
>>>>>>>
>>>>>>> +       /*
>>>>>>> +        * If we have a VF on a non-multifunction bus, it must be a VF that is
>>>>>>> +        * detached from its parent PF.  We rely on firmware emulation to
>>>>>>> +        * provide underlying PF details.
>>>>>>> +        */
>>>>>>> +       if (zdev->vfn && !zdev->zbus->multifunction)
>>>>>>> +               pdev->detached_vf = 1;
>>>>>>
>>>>>> The enable hook seems like it's a bit too late for this sort of
>>>>>> screwing around with the pci_dev. Anything in the setup path that
>>>>>> looks at ->detached_vf would see it cleared while anything that looks
>>>>>> after the device is enabled will see it set. Can this go into
>>>>>> pcibios_add_device() or a fixup instead?
>>>>>>
>>>>>
>>>>> This particular check could go into pcibios_add_device() yes.
>>>>> We're also currently working on a slight rework of how
>>>>> we establish the VF to parent PF linking including the sysfs
>>>>> part of that. The latter sadly can only go after the sysfs
>>>>> for the virtfn has been created and that only happens
>>>>> after all fixups. We would like to do both together because
>>>>> the latter sets pdev->is_virtfn which I think is closely related.
>>>>>
>>>>> I was thinking of starting another discussion
>>>>> about adding a hook that is executed just after the sysfs entries
>>>>> for the PCI device are created but haven't yet.
>>>>
>>>> if all you need is sysfs then pcibios_bus_add_device() or a bus
>>>> notifier should work
>>>
>>> So this might go a bit off track but the problem is that
>>> on s390 a VF can be disabled and reenabled with disable_slot()/enable_slot().
>>> In this case pcibios_bus_add_device() is not called again but
>>> the PF/VF link needs to be reestablished.
>>
>> Scratch that I must have made some stupid mistake last time I tried
>> this, with your suggestion I tried again and it works perfectly
>> moving the setup into pcibios_bus_add_device().
>> Thank you, this is actually much nicer!
>>
> 
> OK, and I can likewise relocate the setting of detached_vf to pcibios_bus_add_device().
> 
Yes and I would suggest we add it in arch/s390/pci_bus.c just
after the the setup_virtfn stuff, then that can stay static
and the fix minimal.
I'll send a new version of my patches internally later, still
running it on the different configurations.
