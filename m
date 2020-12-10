Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC17F2D6079
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 16:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392077AbgLJPwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 10:52:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392086AbgLJPwM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 10:52:12 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAFdaPh187884;
        Thu, 10 Dec 2020 10:51:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=K/WpxoBa8xs0Lok5th2XjQwTI5iF2ZMY9d4QPzepwGk=;
 b=rTy4YaSmvEMJJ9MwGEn0Dc7L+RtD0nQAEaLBHEt5W424h3ROgfOAQYFcdseVhCU3j/rt
 dL91m3zV6L6/t1OtWMxPsu+B5+8FSl2mXnlVM64Qiwv0z9/x81u/nJ/z6yV9PTw46y8Y
 OG/EZtRfWJczSip2YktSrcp6QFMShP6wFcVLXSSROCEdkCeFFV9NbG+UCa0zDD9lKmb0
 Zaeiah3XFtaXza55a/1hs4dbeo2zFd9v70iJzhwHWrc8afJDTDcmLSsfXGDeQGfs5KP4
 znoIh7TFwV5lU7OJa4sMD50WttZKww/u4e4AcwYrcQmLDFi6LYc5QM/iMjgOC5LzFpid +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bpgsrbxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 10:51:30 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAFeYQK190341;
        Thu, 10 Dec 2020 10:51:29 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bpgsrbxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 10:51:29 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAFgahI026671;
        Thu, 10 Dec 2020 15:51:29 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 3581u9ttgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 15:51:28 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAFpPw617629486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 15:51:25 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 833226E052;
        Thu, 10 Dec 2020 15:51:25 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18BEF6E04C;
        Thu, 10 Dec 2020 15:51:23 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.37.122])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 10 Dec 2020 15:51:23 +0000 (GMT)
Subject: Re: [RFC 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
 <20201210133306.70d1a556.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <ce9d4ef2-2629-59b7-99ed-4c8212cb004f@linux.ibm.com>
Date:   Thu, 10 Dec 2020 10:51:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201210133306.70d1a556.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_06:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1015 adultscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012100095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/20 7:33 AM, Cornelia Huck wrote:
> On Wed,  9 Dec 2020 15:27:46 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> Today, ISM devices are completely disallowed for vfio-pci passthrough as
>> QEMU will reject the device due to an (inappropriate) MSI-X check.
>> However, in an effort to enable ISM device passthrough, I realized that the
>> manner in which ISM performs block write operations is highly incompatible
>> with the way that QEMU s390 PCI instruction interception and
>> vfio_pci_bar_rw break up I/O operations into 8B and 4B operations -- ISM
>> devices have particular requirements in regards to the alignment, size and
>> order of writes performed.  Furthermore, they require that legacy/non-MIO
>> s390 PCI instructions are used, which is also not guaranteed when the I/O
>> is passed through the typical userspace channels.
> 
> The part about the non-MIO instructions confuses me. How can MIO
> instructions be generated with the current code, and why does changing

So to be clear, they are not being generated at all in the guest as the 
necessary facility is reported as unavailable.

Let's talk about Linux in LPAR / the host kernel:  When hardware that 
supports MIO instructions is available, all userspace I/O traffic is 
going to be routed through the MIO variants of the s390 PCI 
instructions.  This is working well for other device types, but does not 
work for ISM which does not support these variants.  However, the ISM 
driver also does not invoke the userspace I/O routines for the kernel, 
it invokes the s390 PCI layer directly, which in turn ensures the proper 
PCI instructions are used -- This approach falls apart when the guest 
ISM driver invokes those routines in the guest -- we (qemu) pass those 
non-MIO instructions from the guest as memory operations through 
vfio-pci, traversing through the vfio I/O layer in the guest 
(vfio_pci_bar_rw and friends), where we then arrive in the host s390 PCI 
layer -- where the MIO variant is used because the facility is available.

Per conversations with Niklas (on CC), it's not trivial to decide by the 
time we reach the s390 PCI I/O layer to switch gears and use the non-MIO 
instruction set.

> the write pattern help?

The write pattern is a separate issue from non-MIO instruction 
requirements...  Certain address spaces require specific instructions to 
be used (so, no substituting PCISTG for PCISTB - that happens too by 
default for any writes coming into the host s390 PCI layer that are 
<=8B, and they all are when the PCISTB is broken up into 8B memory 
operations that travel through vfio_pci_bar_rw, which further breaks 
those up into 4B operations).  There's also a requirement for some 
writes that the data, if broken up, be written in a certain order in 
order to properly trigger events. :(  The ability to pass the entire 
PCISTB payload vs breaking it into 8B chunks is also significantly faster.

> 
>>
>> As a result, this patchset proposes a new VFIO region to allow a guest to
>> pass certain PCI instruction intercepts directly to the s390 host kernel
>> PCI layer for exeuction, pinning the guest buffer in memory briefly in
>> order to execute the requested PCI instruction.
>>
>> Matthew Rosato (4):
>>    s390/pci: track alignment/length strictness for zpci_dev
>>    vfio-pci/zdev: Pass the relaxed alignment flag
>>    s390/pci: Get hardware-reported max store block length
>>    vfio-pci/zdev: Introduce the zPCI I/O vfio region
>>
>>   arch/s390/include/asm/pci.h         |   4 +-
>>   arch/s390/include/asm/pci_clp.h     |   7 +-
>>   arch/s390/pci/pci_clp.c             |   2 +
>>   drivers/vfio/pci/vfio_pci.c         |   8 ++
>>   drivers/vfio/pci/vfio_pci_private.h |   6 ++
>>   drivers/vfio/pci/vfio_pci_zdev.c    | 160 ++++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/vfio.h           |   4 +
>>   include/uapi/linux/vfio_zdev.h      |  33 ++++++++
>>   8 files changed, 221 insertions(+), 3 deletions(-)
>>
> 

