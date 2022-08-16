Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489A6595D93
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 15:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbiHPNnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 09:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiHPNnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 09:43:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493E785FAF;
        Tue, 16 Aug 2022 06:43:03 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GCTXOU020589;
        Tue, 16 Aug 2022 13:42:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qSmCgUkiKFSPrl9wRss/YSlSfXGLPxBQcr0ruFYm4TE=;
 b=ER6q5huXcrTsYzUPijasmL27sSuPjshBhmQsYo+U9SmdxAVNlF6RHvB9LMAApVCZWA6R
 HeG/YWUcvIQjOcFlzdWdIosUtnIeqyMBx6fKBSCZ8omvqjeAakE6UpvLjn9WcwzFqQo7
 DcjXximE/aRhvoj1pWXvVKcjtJ/MqEMTReib2FU+XzByQ2MV6cJLnrWRCuIvDPBw31+7
 jyzyMhPIlEBtUy6O+9xjw8AnkSbqRBTpHY3Sy4T6TG3xDlVdI9UKxs1ZUzwDx9q2xlOo
 EttsI4FG3ZbotnX1TgqoEwVmyb0eOHfy1NNTfhtI2VyJC3v+14SQaYkxWPNXTULhHnsG eQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0b9t27rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 13:42:52 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GDM51B005646;
        Tue, 16 Aug 2022 13:42:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hx37jba7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 13:42:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GDh6lP27394522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 13:43:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57D945204E;
        Tue, 16 Aug 2022 13:42:47 +0000 (GMT)
Received: from [9.171.18.167] (unknown [9.171.18.167])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E43315204F;
        Tue, 16 Aug 2022 13:42:46 +0000 (GMT)
Message-ID: <fa1e62d7-30c3-693e-e31a-352dde8c339f@linux.ibm.com>
Date:   Tue, 16 Aug 2022 15:47:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] vfio-pci/zdev: require KVM to be built-in
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220814215154.32112-1-rdunlap@infradead.org>
 <663c7595-1c18-043e-5f12-b0ce880b84bf@linux.ibm.com>
 <5530ed1f-90ec-ce84-2348-80e484fa48cb@infradead.org>
 <47cfc72d-62f6-2bd3-db91-99f91591fc30@linux.ibm.com>
In-Reply-To: <47cfc72d-62f6-2bd3-db91-99f91591fc30@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SbCic7_lFjCT3UETxpFroWyQ5mpcuhQf
X-Proofpoint-GUID: SbCic7_lFjCT3UETxpFroWyQ5mpcuhQf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Randy,

I need to provide the correction patch rapidly.
Without answer I will propose the patch.

Regards,
Pierre

On 8/16/22 09:55, Pierre Morel wrote:
> 
> 
> On 8/16/22 08:04, Randy Dunlap wrote:
>> Hi--
>>
>> On 8/15/22 02:43, Pierre Morel wrote:
>>> Thank you Randy for this good catch.
>>> However forcing KVM to be include statically in the kernel when using 
>>> VFIO_PCI extensions is not a good solution for us I think.
>>>
>>> I suggest we better do something like:
>>>
>>> ----
>>>
>>> diff --git a/arch/s390/include/asm/kvm_host.h 
>>> b/arch/s390/include/asm/kvm_host.h
>>> index 6287a843e8bc..1733339cc4eb 100644
>>> --- a/arch/s390/include/asm/kvm_host.h
>>> +++ b/arch/s390/include/asm/kvm_host.h
>>> @@ -1038,7 +1038,7 @@ static inline void 
>>> kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>>>   #define __KVM_HAVE_ARCH_VM_FREE
>>>   void kvm_arch_free_vm(struct kvm *kvm);
>>>
>>> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
>>> +#if defined(CONFIG_VFIO_PCI_ZDEV_KVM) || 
>>> defined(CONFIG_VFIO_PCI_ZDEV_KVM_MODULE)
>>
>> This all looks good except for the line above.
>> It should be:
>>
>> #if IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)
>>
>> Thanks.
> 
> Yes, better, thanks.
> How do we do? Should I repost it with reported-by you or do you want to 
> post it?
> 
> Pierre
> 
> 
>>
>>
>>>   int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>>>   void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
>>>   #else
>>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>>> index f9d0c908e738..bbc375b028ef 100644
>>> --- a/drivers/vfio/pci/Kconfig
>>> +++ b/drivers/vfio/pci/Kconfig
>>> @@ -45,9 +45,9 @@ config VFIO_PCI_IGD
>>>   endif
>>>
>>>   config VFIO_PCI_ZDEV_KVM
>>> -       bool "VFIO PCI extensions for s390x KVM passthrough"
>>> +       def_tristate y
>>> +       prompt "VFIO PCI extensions for s390x KVM passthrough"
>>>          depends on S390 && KVM
>>> -       default y
>>>          help
>>>            Support s390x-specific extensions to enable support for 
>>> enhancements
>>>            to KVM passthrough capabilities, such as interpretive 
>>> execution of
>>>
>>> ----
>>>
>>> What do you think? It seems to me it solves the problem, what do you 
>>> think?
>>>
>>> Regards,
>>> Pierre
>>
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
