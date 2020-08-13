Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20F02438BE
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 12:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHMKkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 06:40:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38876 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726053AbgHMKkf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 06:40:35 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DAWUc8140539;
        Thu, 13 Aug 2020 06:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9Y6zJ5iz4XY9CB5ki6Ae2+U6glmm4dUOE9fxaYR++uk=;
 b=Gu3mxTb1OQA01VEUmu2HyY7vCRaCmlHqWduPbXvyhJQ25zsv84rxYndW17z787yPHYGS
 B3BZs2pVWTkbMP1Hb1RkWSroCN62yvVAS7SB+QxMvfANkdL3UO13m/fXtZFl1n88xb1q
 ra0BCog/nLP4kQDkH7I+XlNkCi2039bZJ5s85o8TDV83ZpQO0G+vMgZrq+lOZYpOjOo7
 8ciyQJY40SD4OP0JFzs23NL8G4hLEO457o2eu1EvjLKB/6+VVVDftGrIH1Sz23c7lchH
 oBOr91EqbFL0ZA1Ogm5Vx1ROYNHF/lEuE7lI4KOHb8t0UFpBpBiCfm5NGdJNO4/eXl1O 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32v7uuwwhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 06:40:26 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DAWiJd141601;
        Thu, 13 Aug 2020 06:40:26 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32v7uuwwgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 06:40:25 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DAeO8N014636;
        Thu, 13 Aug 2020 10:40:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 32skp7uc13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 10:40:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DAeLWd22086032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 10:40:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14B004C050;
        Thu, 13 Aug 2020 10:40:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65DD84C040;
        Thu, 13 Aug 2020 10:40:20 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.93.1])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Aug 2020 10:40:20 +0000 (GMT)
Subject: Re: [PATCH v2] PCI: Introduce flag for detached virtual functions
To:     "Oliver O'Halloran" <oohall@gmail.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <dc79c8a9-1bbc-380f-741f-bca270a34483@linux.ibm.com>
Date:   Thu, 13 Aug 2020 12:40:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOSf1CE6UyL9P31S=rAG=VZKs-JL4Kbq3VMZNhyojHbkPHSw0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_06:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/13/20 11:59 AM, Oliver O'Halloran wrote:
> On Thu, Aug 13, 2020 at 7:00 PM Niklas Schnelle <schnelle@linux.ibm.com> wrote:
>>
>>
>> On 8/13/20 3:55 AM, Oliver O'Halloran wrote:
>>> On Thu, Aug 13, 2020 at 5:21 AM Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>> *snip*
>>>> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
>>>> index 3902c9f..04ac76d 100644
>>>> --- a/arch/s390/pci/pci.c
>>>> +++ b/arch/s390/pci/pci.c
>>>> @@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
>>>>  {
>>>>         struct zpci_dev *zdev = to_zpci(pdev);
>>>>
>>>> +       /*
>>>> +        * If we have a VF on a non-multifunction bus, it must be a VF that is
>>>> +        * detached from its parent PF.  We rely on firmware emulation to
>>>> +        * provide underlying PF details.
>>>> +        */
>>>> +       if (zdev->vfn && !zdev->zbus->multifunction)
>>>> +               pdev->detached_vf = 1;
>>>
>>> The enable hook seems like it's a bit too late for this sort of
>>> screwing around with the pci_dev. Anything in the setup path that
>>> looks at ->detached_vf would see it cleared while anything that looks
>>> after the device is enabled will see it set. Can this go into
>>> pcibios_add_device() or a fixup instead?
>>>
>>
>> This particular check could go into pcibios_add_device() yes.
>> We're also currently working on a slight rework of how
>> we establish the VF to parent PF linking including the sysfs
>> part of that. The latter sadly can only go after the sysfs
>> for the virtfn has been created and that only happens
>> after all fixups. We would like to do both together because
>> the latter sets pdev->is_virtfn which I think is closely related.
>>
>> I was thinking of starting another discussion
>> about adding a hook that is executed just after the sysfs entries
>> for the PCI device are created but haven't yet.
> 
> if all you need is sysfs then pcibios_bus_add_device() or a bus
> notifier should work

So this might go a bit off track but the problem is that
on s390 a VF can be disabled and reenabled with disable_slot()/enable_slot().
In this case pcibios_bus_add_device() is not called again but
the PF/VF link needs to be reestablished.

> 
>> That said pcibios_enable_device() is called before drivers
>> like vfio-pci are enabled
> 
> Hmm, is that an s390 thing? I was under the impression that drivers
> handled enabling the device rather than assuming the platform did it
> for them. Granted it's usually one of the first things a driver does,
> but there's still scope for surprising behaviour.

No you're absolutely right I formulated this wrong, pcibios_enable_device()
is called by the drivers but before they can really use the device.

But yes I'm not super happy with this either and I
agree for this patch series we should move the check to pcibios_add_device()
and thinking about it more I think I'll really have to find a better
place for our linking as well, pcibios_enable_device() does work
nicely in practice buy it indeed poses room for surprising behavior.

> 
... snip ...
