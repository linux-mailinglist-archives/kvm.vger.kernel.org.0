Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981A5254E1A
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 21:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgH0TVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 15:21:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5492 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726246AbgH0TVh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 15:21:37 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07RJKfpm127449;
        Thu, 27 Aug 2020 15:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Tcv5sEbkN2LXYKr544lkY45x9dSz+ueJ2YJOKerxwnk=;
 b=E31E2Y5i5C0V4Ahiii2I89+WNthivJNvFRbhnUUlhw9f/cZ6i0MgAYPoZtWEAUfdPBzF
 K6DbscpVJq+I232iUMbhm4RlDuab/8uI3O+yi58BCZN1qEr1XzxCfZktHtxcDPaPAZsS
 H7DMcetr/4kVu81dniDmYzKyifO+x8U5QUdWpFjbLR2NPGwRTgDpVlGV39K764xk4hl+
 CenVY3RRUuR8rvWYY0ov5d2UK/ZUX0qWVUG9AuCN/biQepWS5ZHgUdL4YM/7aIAk0GGO
 ZXMk3dWW3z84qVKz2bG2K4fK1oj4zi63T47Eq5uA6Belb8EALA2dGO9A3LYlmeFrrQBU 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 336j5bh3s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 15:21:29 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07RJKuoj127919;
        Thu, 27 Aug 2020 15:21:29 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 336j5bh3ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 15:21:28 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07RJH8Rm007181;
        Thu, 27 Aug 2020 19:21:27 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 332uttyh82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 19:21:27 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07RJLMD366388438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 19:21:22 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A70B0BE054;
        Thu, 27 Aug 2020 19:21:25 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98123BE051;
        Thu, 27 Aug 2020 19:21:24 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.118.21])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 19:21:24 +0000 (GMT)
Subject: Re: [PATCH v3] PCI: Introduce flag for detached virtual functions
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     alex.williamson@redhat.com, bhelgaas@google.com,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20200827183138.GA1929779@bjorn-Precision-5520>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <69a78288-9d19-7ffd-4690-28140688fa3f@linux.ibm.com>
Date:   Thu, 27 Aug 2020 15:21:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827183138.GA1929779@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_10:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 clxscore=1011 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/27/20 2:31 PM, Bjorn Helgaas wrote:
> Re the subject line, this patch does a lot more than just "introduce a
> flag"; AFAICT it actually enables important VFIO functionality, e.g.,
> something like:
> 
>    vfio/pci: Enable MMIO access for s390 detached VFs
> 

Fair -- maybe s/Enable/Restore/ as this functionality had been working 
until the mem bit enforcement was added to vfio via abafbc551fdd.

> On Thu, Aug 13, 2020 at 11:40:43AM -0400, Matthew Rosato wrote:
>> s390x has the notion of providing VFs to the kernel in a manner
>> where the associated PF is inaccessible other than via firmware.
>> These are not treated as typical VFs and access to them is emulated
>> by underlying firmware which can still access the PF.  After
>> the referened commit however these detached VFs were no longer able
>> to work with vfio-pci as the firmware does not provide emulation of
>> the PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
>> these detached VFs so that vfio-pci can allow memory access to
>> them again.
> 
> Out of curiosity, in what sense is the PF inaccessible?  Is it
> *impossible* for Linux to access the PF, or is it just not enumerated
> by clp_list_pci() so Linux doesn't know about it?

So, it is not enumerated via clp_list_pci because it is not assigned to 
the host partition -- So while it is physically available to the machine 
and the firmware can see it, the machine is divided up into multiple 
logical partitions -- The partition where we are running the host kernel 
in this scenario has no access to the PF.  Basically, think bare metal 
hypervisor and only the VF was passed through to the kernel guest.

> VFs do not implement PCI_COMMAND, so I guess "firmware does not
> provide emulation of PCI_COMMAND_MEMORY" means something like "we
> can't access the PF so we can't enable/disable PCI_COMMAND_MEMORY"?
> 

So, the root issue is that vfio-pci added enforcement of the bit via 
abafbc551fdd -- Then subsequently waived the requirement for VFs via 
bugfix ebfa440ce38b since as you say it can't be on for VFs per the PCIe 
spec -- Problem is, vfio can't tell these devices are VFs because 
is_virtfn=0 for these devices.

Fundamentally, I am trying to find a proper way to tell vfio it's OK to 
waive the requirement for these devices too.

> s/referened/referenced/
> 
>> Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/pci/pci_bus.c            | 13 +++++++++++++
>>   drivers/vfio/pci/vfio_pci_config.c |  8 ++++----
>>   include/linux/pci.h                |  4 ++++
>>   3 files changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
>> index 642a993..1b33076 100644
>> --- a/arch/s390/pci/pci_bus.c
>> +++ b/arch/s390/pci/pci_bus.c
>> @@ -184,6 +184,19 @@ static inline int zpci_bus_setup_virtfn(struct zpci_bus *zbus,
>>   }
>>   #endif
>>   
>> +void pcibios_bus_add_device(struct pci_dev *pdev)
>> +{
>> +	struct zpci_dev *zdev = to_zpci(pdev);
>> +
>> +	/*
>> +	 * If we have a VF on a non-multifunction bus, it must be a VF that is
>> +	 * detached from its parent PF.  We rely on firmware emulation to
>> +	 * provide underlying PF details.
> 
> What exactly does "multifunction bus" mean?  I'm familiar with
> multi-function *devices*, but not multi-function buses.
> 

So, this flag is effectively stating whether proper SR-IOV support is 
available for devices on the bus.  This is an interesting point though, 
I don't think this will catch all instances of this scenario (vs a 
more-direct check for a device that has a vfn but no linked PF).  I need 
to look at this again, thanks.

>> +	 */
>> +	if (zdev->vfn && !zdev->zbus->multifunction)
>> +		pdev->detached_vf = 1;
>> +}
>> +
>>   static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
>>   {
>>   	struct pci_bus *bus;
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>> index d98843f..98f93d1 100644
>> --- a/drivers/vfio/pci/vfio_pci_config.c
>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>> @@ -406,7 +406,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
>>   	 * PF SR-IOV capability, there's therefore no need to trigger
>>   	 * faults based on the virtual value.
>>   	 */
>> -	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
>> +	return dev_is_vf(&pdev->dev) || (cmd & PCI_COMMAND_MEMORY);
> 
> I'm not super keen on the idea of having two subtly different ways of
> identifying VFs.  I think that will be confusing.  This seems to be
> the critical line, so whatever we do here, it will be out of the
> ordinary and probably deserves a little comment.
> 

Another notion that Alex floated was the idea of tagging these devices 
that don't implement the PCI_COMMAND_MEMORY bit via a dev_flags bit 
rather than changing the way we identify VFs.  It's grown on me and I've 
tried it out as an alternative.  Does this sort of approach sound better?

> If Linux doesn't see the PF, does pci_physfn(VF) return NULL, i.e., is
> VF->physfn NULL?
> 

pci_physfn(VF) == VF because is_virtfn=0 for these devices.


