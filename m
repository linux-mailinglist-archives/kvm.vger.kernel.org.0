Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F432D6170
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732991AbgLJQP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:15:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727634AbgLJQPN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 11:15:13 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAG51EW148111;
        Thu, 10 Dec 2020 11:14:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=waTk1xAmEjkw3jppOUz7fkm+LfZEfmN5cJn3bG6OpZg=;
 b=M2xKdSflawadlklOW9FAq8illFEvUC0f886JWXQxhcvGZCEaznPtR7KSL65muKkIPL65
 E3Px8Oj6RLt6M+oi79V9mZVVEDTZH9VmHyjtH7UwZujOMyOtYZJnd0bo1RQ1B1Hc1Twy
 LK5Xa6gnvyBMMKYB49eDKPvYtB8T1zkb3Ku4cEWxCoV7Qi4G1yqawUNIPWRrRvgPv0x0
 mYsFzY/w5UvTyK4DADbp75+r6C3ITZqWlpfJ0jBJyb25hVDSf5go0x7u1lPr7MhLr4lZ
 HNuqpfGUS9gsgQ49mdxHEHcBHN5Ck6mnGc7Kol/zuDHYqJ568bCDQ178Y2q86IaWlwyV ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bnduby39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 11:14:31 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAG5U4A149833;
        Thu, 10 Dec 2020 11:14:31 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bnduby1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 11:14:31 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAGA3Es018181;
        Thu, 10 Dec 2020 16:14:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 35958q26bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 16:14:28 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAGEPm57602682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 16:14:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9381842054;
        Thu, 10 Dec 2020 16:14:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E89A42042;
        Thu, 10 Dec 2020 16:14:25 +0000 (GMT)
Received: from [9.171.6.187] (unknown [9.171.6.187])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Dec 2020 16:14:25 +0000 (GMT)
Subject: Re: [RFC 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     alex.williamson@redhat.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
 <20201210133306.70d1a556.cohuck@redhat.com>
 <ce9d4ef2-2629-59b7-99ed-4c8212cb004f@linux.ibm.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <7bce88b2-8c7d-c0f4-89a0-b1e8f511ad0b@linux.ibm.com>
Date:   Thu, 10 Dec 2020 17:14:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <ce9d4ef2-2629-59b7-99ed-4c8212cb004f@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_06:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1011 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012100099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/10/20 4:51 PM, Matthew Rosato wrote:
> On 12/10/20 7:33 AM, Cornelia Huck wrote:
>> On Wed,  9 Dec 2020 15:27:46 -0500
>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>
>>> Today, ISM devices are completely disallowed for vfio-pci passthrough as
>>> QEMU will reject the device due to an (inappropriate) MSI-X check.
>>> However, in an effort to enable ISM device passthrough, I realized that the
>>> manner in which ISM performs block write operations is highly incompatible
>>> with the way that QEMU s390 PCI instruction interception and
>>> vfio_pci_bar_rw break up I/O operations into 8B and 4B operations -- ISM
>>> devices have particular requirements in regards to the alignment, size and
>>> order of writes performed.  Furthermore, they require that legacy/non-MIO
>>> s390 PCI instructions are used, which is also not guaranteed when the I/O
>>> is passed through the typical userspace channels.
>>
>> The part about the non-MIO instructions confuses me. How can MIO
>> instructions be generated with the current code, and why does changing
> 
> So to be clear, they are not being generated at all in the guest as the necessary facility is reported as unavailable.
> 
> Let's talk about Linux in LPAR / the host kernel:  When hardware that supports MIO instructions is available, all userspace I/O traffic is going to be routed through the MIO variants of the s390 PCI instructions.  This is working well for other device types, but does not work for ISM which does not support these variants.  However, the ISM driver also does not invoke the userspace I/O routines for the kernel, it invokes the s390 PCI layer directly, which in turn ensures the proper PCI instructions are used -- This approach falls apart when the guest ISM driver invokes those routines in the guest -- we (qemu) pass those non-MIO instructions from the guest as memory operations through vfio-pci, traversing through the vfio I/O layer in the guest (vfio_pci_bar_rw and friends), where we then arrive in the host s390 PCI layer -- where the MIO variant is used because the facility is available.

Slight clarification since I think the word "userspace" is a bit overloaded as
KVM folks often use it to talk about the guest even when that calls through vfio.
Application userspace (i.e. things like DPDK) can use PCI MIO Load/Stores
directly on mmap()ed/ioremap()ed memory these don't go through the Kernel at
all.
QEMU while also in userspace on the other hand goes through the vfio_bar_rw()
region which uses the common code _Kernel_ ioread()/iowrite() API. This Kernel
ioread()/iowrite() API uses PCI MIO Load/Stores by default on machines that
support them (z15 currently).  The ISM driver, knowing that its device does not
support MIO, goes around this API and directly calls zpci_store()/zpci_load().


> 
> Per conversations with Niklas (on CC), it's not trivial to decide by the time we reach the s390 PCI I/O layer to switch gears and use the non-MIO instruction set.

Yes, we have some ideas about dynamically switching to legacy PCI stores in
ioread()/iowrite() for devices that are set up for it but since that only gets
an ioremap()ed address, a value and a size it would evolve such nasty things as
looking at this virtual address to determine if it includes a ZPCI_ADDR()
cookie that we use to get to the function handle needed for the legacy PCI
Load/Stores, while MIO PCI Load/Stores directly work on virtual addresses.

Now purely for the Kernel API we think this could work since that always
allocates between VMALLOC_START and VMALLOC_END and we control where we put the
ZPCI_ADDR() cookie but I'm very hesitant to add something like that.

As for application userspace (DPDK) we do have a syscall
(arch/s390/pci/pci_mmio.c) API that had a similar problem but we could make use
of the fact that our Architecture is pretty nifty with address spaces and just
execute the MIO PCI Load/Store in the syscall _as if_ by the calling userspace
application.


> 
>> the write pattern help?
> 
... snip ...
