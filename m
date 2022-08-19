Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0F3599B19
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348594AbiHSLna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348558AbiHSLn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:43:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763CEBE19;
        Fri, 19 Aug 2022 04:43:23 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JBdgTq004630;
        Fri, 19 Aug 2022 11:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zWRGa3Af7C/Nzs7CTmE0gQcvlbG+601lqNptAJNWYpM=;
 b=NBux9K5DNY7Uo0jiHQaH0hZTF6elMN7REPHh5+a3OD7qmW/IM/d3Zt97iU5KmG7gKM11
 JjKQDgR7K6Td24Hl7oyptGabBQWwH8U+IHGQiBj1+tMzbWxpfvnk+Vho1k4yUeV87PZy
 LOEl7Rj5m09xEbrsyByfh18TO4HgBiarPesZQ29U6MyykenzLfIp7t/xwIdEr6YAXs7y
 1v76dHnx9YO9+EMtpBVQbSP82sJN7vr5L+5StA12lg+gluvCF8ilB4pUROPAjVwrhF+9
 1gB3lVxUx7TlFuzQbxqRn7OK3zToZ1085jTki/ChPCHfqk6WWODtp1mz00jf4CEStPhT tg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j29860v3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 11:43:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27JBKfeB000962;
        Fri, 19 Aug 2022 11:43:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3hx3k9f55d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 11:43:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27JBh1fm22020400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 11:43:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D546A4053;
        Fri, 19 Aug 2022 11:43:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5A7AA4040;
        Fri, 19 Aug 2022 11:42:59 +0000 (GMT)
Received: from [9.171.46.183] (unknown [9.171.46.183])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 11:42:59 +0000 (GMT)
Message-ID: <b22977d5-6df7-13e0-802f-6201e6445d72@linux.ibm.com>
Date:   Fri, 19 Aug 2022 13:42:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>, mjrosato@linux.ibm.com
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, frankja@linux.ibm.com
References: <20220818164652.269336-1-pmorel@linux.ibm.com>
 <2ae0bf9abffe2eb3eb2fb3f84873720d39f73d4d.camel@linux.ibm.com>
 <0d7d055d-f323-acba-cb79-f859b5e182b4@linux.ibm.com>
 <ae19135f580e1f510e99d1567514cc2dfe3571be.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <ae19135f580e1f510e99d1567514cc2dfe3571be.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TpNuB7kEou0-CgaZpNv6WAUZa33Q863R
X-Proofpoint-ORIG-GUID: TpNuB7kEou0-CgaZpNv6WAUZa33Q863R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_06,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208190044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/19/22 12:42, Niklas Schnelle wrote:
> On Fri, 2022-08-19 at 10:44 +0200, Pierre Morel wrote:
>>
>> On 8/19/22 09:14, Niklas Schnelle wrote:
>>> On Thu, 2022-08-18 at 18:46 +0200, Pierre Morel wrote:
>>>> We have a cross dependency between KVM and VFIO when using
>>>> s390 vfio_pci_zdev extensions for PCI passthrough
>>>> To be able to keep both subsystem modular we add a registering
>>>> hook inside the S390 core code.
>>>>
>>>> This fixes a build problem when VFIO is built-in and KVM is built
>>>> as a module.
>>>>
>>>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop inter..")
>>>
>>> Please don't shorten the Fixes tag, the subject line is likely also
>>> checked by some automated tools. It's okay for this line to be over the
>>> column limit and checkpatch.pl --strict also accepts it.
>>>
>>
>> OK
>>
>>>> Cc: <stable@vger.kernel.org>
>>>> ---
>>>>    arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
>>>>    arch/s390/kvm/pci.c              | 10 ++++++----
>>>>    arch/s390/pci/Makefile           |  2 ++
>>>>    arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
>>>>    drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
>>>>    5 files changed, 31 insertions(+), 17 deletions(-)
>>>>    create mode 100644 arch/s390/pci/pci_kvm_hook.c
>>>>
>>>>
>>> ---8<---
>>>>    
>>>>    	kvm_put_kvm(kvm);
>>>>    }
>>>> -EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
>>>>    
>>>>    void kvm_s390_pci_init_list(struct kvm *kvm)
>>>>    {
>>>> @@ -678,6 +678,8 @@ int kvm_s390_pci_init(void)
>>>>    
>>>>    	spin_lock_init(&aift->gait_lock);
>>>>    	mutex_init(&aift->aift_lock);
>>>> +	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
>>>> +	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
>>>>    
>>>>    	return 0;
>>>>    }
>>>> diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
>>>> index bf557a1b789c..c02dbfb415d9 100644
>>>> --- a/arch/s390/pci/Makefile
>>>> +++ b/arch/s390/pci/Makefile
>>>> @@ -7,3 +7,5 @@ obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
>>>>    			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
>>>>    			   pci_bus.o
>>>>    obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
>>>> +
>>>> +obj-y += pci_kvm_hook.o
>>>
>>> I thought we wanted to compile this only for CONFIG_PCI?
>>
>> Ah sorry, that is indeed what I understood with Matt but then I
>> misunderstood your own answer from yesterday.
>> I change to
>> obj-$(CONFIG_PCI) += pci_kvm_hook.o
>>
>>>> diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
>>>> new file mode 100644
>>>> index 000000000000..ff34baf50a3e
>>> ---8<---
>>>
> 
> Ok with the two things above plus the comment by Matt incorporated:
> 
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> 

Just a little correction, it changes nothing if the pci_kvm_hook.c goes 
on same lines as other CONFIG_PCI depending files.
So I put it on the same line.

Thanks

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
