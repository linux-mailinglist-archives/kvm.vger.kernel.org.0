Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72075997B7
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 10:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347678AbiHSIob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 04:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347626AbiHSIo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 04:44:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21007B7EEC;
        Fri, 19 Aug 2022 01:44:25 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J8Gu3L022264;
        Fri, 19 Aug 2022 08:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+v9nT8ZKH5nQZXkGNwDvqukouuQUqGry8Hdy6T8DPAY=;
 b=kB/tv/IzObAQjKJ5pJkzJHnejJaIoaO9+UqvSRi1IDf/wQ/9k2ye6IjbDqFPTbYvwEh2
 N4HgycFDsUSWUT1eMrMi/8YIly4nO87AYmSEX5/h5eIitLo5s70RuprbvumxKzcoGVdK
 KCNkIrgRYZevIBSD/QLzGZoUHDmmpUZovLT04kY6EIoe/G5uLv9VZcES4NJnADVCI+js
 +C4sWTLIs+CNY1l/HmPtwfqB64n9laRDA7tKT3Wux0vLUtchsiRl22oiJvcL2hv90dDF
 tTJKvIDifu3u1pYZVuDfkaR3ykLX6PfZUU/QMtkxpqV99FKBAY2eKfhUpvnKwxxVyg5Z Gg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j26vd8m93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 08:44:17 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27J8KwLh024220;
        Fri, 19 Aug 2022 08:44:15 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3hx3k957kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 08:44:15 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27J8iVWo25297284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 08:44:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D68B7AE045;
        Fri, 19 Aug 2022 08:44:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7073AE053;
        Fri, 19 Aug 2022 08:44:10 +0000 (GMT)
Received: from [9.171.49.238] (unknown [9.171.49.238])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 08:44:10 +0000 (GMT)
Message-ID: <0d7d055d-f323-acba-cb79-f859b5e182b4@linux.ibm.com>
Date:   Fri, 19 Aug 2022 10:44:10 +0200
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
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <2ae0bf9abffe2eb3eb2fb3f84873720d39f73d4d.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aPDdiq_Kpt3i5btmzuGdKT24gvc8NZin
X-Proofpoint-GUID: aPDdiq_Kpt3i5btmzuGdKT24gvc8NZin
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208190033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/19/22 09:14, Niklas Schnelle wrote:
> On Thu, 2022-08-18 at 18:46 +0200, Pierre Morel wrote:
>> We have a cross dependency between KVM and VFIO when using
>> s390 vfio_pci_zdev extensions for PCI passthrough
>> To be able to keep both subsystem modular we add a registering
>> hook inside the S390 core code.
>>
>> This fixes a build problem when VFIO is built-in and KVM is built
>> as a module.
>>
>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop inter..")
> 
> Please don't shorten the Fixes tag, the subject line is likely also
> checked by some automated tools. It's okay for this line to be over the
> column limit and checkpatch.pl --strict also accepts it.
> 

OK

>> Cc: <stable@vger.kernel.org>
>> ---
>>   arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
>>   arch/s390/kvm/pci.c              | 10 ++++++----
>>   arch/s390/pci/Makefile           |  2 ++
>>   arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
>>   drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
>>   5 files changed, 31 insertions(+), 17 deletions(-)
>>   create mode 100644 arch/s390/pci/pci_kvm_hook.c
>>
>>
> ---8<---
>>   
>>   	kvm_put_kvm(kvm);
>>   }
>> -EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
>>   
>>   void kvm_s390_pci_init_list(struct kvm *kvm)
>>   {
>> @@ -678,6 +678,8 @@ int kvm_s390_pci_init(void)
>>   
>>   	spin_lock_init(&aift->gait_lock);
>>   	mutex_init(&aift->aift_lock);
>> +	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
>> +	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
>>   
>>   	return 0;
>>   }
>> diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
>> index bf557a1b789c..c02dbfb415d9 100644
>> --- a/arch/s390/pci/Makefile
>> +++ b/arch/s390/pci/Makefile
>> @@ -7,3 +7,5 @@ obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
>>   			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
>>   			   pci_bus.o
>>   obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
>> +
>> +obj-y += pci_kvm_hook.o
> 
> I thought we wanted to compile this only for CONFIG_PCI?

Ah sorry, that is indeed what I understood with Matt but then I 
misunderstood your own answer from yesterday.
I change to
obj-$(CONFIG_PCI) += pci_kvm_hook.o

> 
>> diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
>> new file mode 100644
>> index 000000000000..ff34baf50a3e
> ---8<---
> 

-- 
Pierre Morel
IBM Lab Boeblingen
