Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A2425C7D3
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 19:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgICRKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 13:10:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40140 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726327AbgICRKP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 13:10:15 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083H1lKL138973;
        Thu, 3 Sep 2020 13:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=++7FG1vvQy4IQVZV74Hxz4Q2iO5xLzsWU+5iC8BgQ/I=;
 b=ccrlz93xGaSI0r82viEIaGk3v5n6gPRGSSws8DK5mKCbN3V6GWDFi0Pveb/7oJ5MVmK1
 DYdiiJb4Jw2aNjPTbO++Q2vJvVPFC8y+bwOmIrNj1GK0gFCsygmU7R6pNlL1m30SQFl9
 4M9qmKS1SUWXDWx2Olloa1mrt1dIewZL2OGloV8R0p0a5pfXVypXuNxtkst/Rvkd9rp7
 9jBUCAzEEWm95czZOk1F5/3NYDpsh1+aXMB+by4Bi8KBt5l2AyKAt0Ewc/V4QZnGNh8G
 qQUuYKHXgTjI9o0xU6uof75NiwsFMH5xTmL4EmfU8epqz4BRmXjqg8Hk6hCqu5XRYI9p rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33b3dx2h2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 13:10:08 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 083H2bnW145734;
        Thu, 3 Sep 2020 13:10:07 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33b3dx2h1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 13:10:07 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 083H7VBO017133;
        Thu, 3 Sep 2020 17:10:05 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 337ena19uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 17:10:05 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 083HA1wp26739064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Sep 2020 17:10:01 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8499E13604F;
        Thu,  3 Sep 2020 17:10:04 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6ED36136065;
        Thu,  3 Sep 2020 17:10:03 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.10.164])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  3 Sep 2020 17:10:03 +0000 (GMT)
Subject: Re: [PATCH v4 1/3] PCI/IOV: Mark VFs as not implementing MSE bit
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     alex.williamson@redhat.com, bhelgaas@google.com,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, cohuck@redhat.com, kevin.tian@intel.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20200903164117.GA312152@bjorn-Precision-5520>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <38f95349-237e-34e2-66ef-e626cd4aec25@linux.ibm.com>
Date:   Thu, 3 Sep 2020 13:10:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200903164117.GA312152@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_10:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 suspectscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/20 12:41 PM, Bjorn Helgaas wrote:
> On Wed, Sep 02, 2020 at 03:46:34PM -0400, Matthew Rosato wrote:
>> Per the PCIe spec, VFs cannot implement the MSE bit
>> AKA PCI_COMMAND_MEMORY, and it must be hard-wired to 0.
>> Use a dev_flags bit to signify this requirement.
> 
> This approach seems sensible to me, but
> 
>    - This is confusing because while the spec does not use "MSE" to
>      refer to the Command Register "Memory Space Enable" bit
>      (PCI_COMMAND_MEMORY), it *does* use "MSE" in the context of the
>      "VF MSE" bit, which is in the PF SR-IOV Capability.  But of
>      course, you're not talking about that here.  Maybe something like
>      this?
> 
>        For VFs, the Memory Space Enable bit in the Command Register is
>        hard-wired to 0.
> 
>        Add a dev_flags bit to signify devices where the Command
>        Register Memory Space Enable bit does not control the device's
>        response to MMIO accesses.

Will do.  I'll change the usage of the MSE acronym in the other patches 
as well.

> 
>    - "PCI_DEV_FLAGS_FORCE_COMMAND_MEM" says something about how you
>      plan to *use* this, but I'd rather use a term that describes the
>      hardware, e.g., "PCI_DEV_FLAGS_NO_COMMAND_MEMORY".

Sure, I will change.

> 
>    - How do we decide whether to use dev_flags vs a bitfield like
>      dev->is_virtfn?  The latter seems simpler unless there's a reason
>      to use dev_flags.  If there's a reason, maybe we could add a
>      comment at pci_dev_flags for future reference.
> 

Something like:

/*
  * Device does not implement PCI_COMMAND_MEMORY - this is true for any
  * device marked is_virtfn, but is also true for any VF passed-through
  * a lower-level hypervisor where emulation of the Memory Space Enable
  * bit was not provided.
  */
PCI_DEV_FLAGS_NO_COMMAND_MEMORY = (__force pci_dev_flags_t) (1 << 12),

?

>    - Wrap the commit log to fill a 75-char line.  It's arbitrary, but
>      that's what I use for consistency.

Sure, will do.  I'll roll up a new version once I have feedback from 
Alex on the vfio changes.

> 
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   drivers/pci/iov.c   | 1 +
>>   include/linux/pci.h | 2 ++
>>   2 files changed, 3 insertions(+)
>>
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index b37e08c..2bec77c 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -180,6 +180,7 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
>>   	virtfn->device = iov->vf_device;
>>   	virtfn->is_virtfn = 1;
>>   	virtfn->physfn = pci_dev_get(dev);
>> +	virtfn->dev_flags |= PCI_DEV_FLAGS_FORCE_COMMAND_MEM;
>>   
>>   	if (id == 0)
>>   		pci_read_vf_config_common(virtfn);
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 8355306..9316cce 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -227,6 +227,8 @@ enum pci_dev_flags {
>>   	PCI_DEV_FLAGS_NO_FLR_RESET = (__force pci_dev_flags_t) (1 << 10),
>>   	/* Don't use Relaxed Ordering for TLPs directed at this device */
>>   	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
>> +	/* Device does not implement PCI_COMMAND_MEMORY (e.g. a VF) */
>> +	PCI_DEV_FLAGS_FORCE_COMMAND_MEM = (__force pci_dev_flags_t) (1 << 12),
>>   };
>>   
>>   enum pci_irq_reroute_variant {
>> -- 
>> 1.8.3.1
>>

