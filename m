Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A89E595655
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 11:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbiHPJaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 05:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbiHPJaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 05:30:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BD29DF88;
        Tue, 16 Aug 2022 00:50:20 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27G7ULfF002836;
        Tue, 16 Aug 2022 07:50:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tX039jGbtcecrO3BmdGc6iS5RY3LYX7/B+TxRQu6bMo=;
 b=dtyYjhkAqIljkwnALwtNIsisqQs3klRPq7qrzUGbDzAeeha+YKZBBoY4nqbfCj7qK3hh
 lJPSJovo5Vw3fChK/zYPvk2QEPa+YY88ssyhLaEZyInBeHpm5EOsbYEhXhgFixEgnD81
 2gtsu0Spuj7Ihhb2QC9a9adnovet+r5A68IL9gD9MjCZlj+HoNtawyok36np3Mtfv/QX
 vgUR+wbSbakf7hQ07Xx18wkV60Lm9APIjL74gMeGYcKtY2H1N139T4ktZos4cp0Iwbcd
 cdotz2PN0f/CQTKTNoIeAWxE4o6FHBCLY01DwC0olUA39KlRWaD2wfC4J0Qqoo6UqxCj bQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j06wa0d8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 07:50:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27G7aNH9004291;
        Tue, 16 Aug 2022 07:50:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3hx3k9avk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 07:50:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27G7oGSl32833830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 07:50:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 429A511C050;
        Tue, 16 Aug 2022 07:49:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCF6C11C04C;
        Tue, 16 Aug 2022 07:49:57 +0000 (GMT)
Received: from [9.171.18.167] (unknown [9.171.18.167])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Aug 2022 07:49:57 +0000 (GMT)
Message-ID: <47cfc72d-62f6-2bd3-db91-99f91591fc30@linux.ibm.com>
Date:   Tue, 16 Aug 2022 09:55:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] vfio-pci/zdev: require KVM to be built-in
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220814215154.32112-1-rdunlap@infradead.org>
 <663c7595-1c18-043e-5f12-b0ce880b84bf@linux.ibm.com>
 <5530ed1f-90ec-ce84-2348-80e484fa48cb@infradead.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5530ed1f-90ec-ce84-2348-80e484fa48cb@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gB5kFG1VzBcJ4zxDYC6kuwC7hs7FARpL
X-Proofpoint-GUID: gB5kFG1VzBcJ4zxDYC6kuwC7hs7FARpL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_06,2022-08-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208160029
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/16/22 08:04, Randy Dunlap wrote:
> Hi--
> 
> On 8/15/22 02:43, Pierre Morel wrote:
>> Thank you Randy for this good catch.
>> However forcing KVM to be include statically in the kernel when using VFIO_PCI extensions is not a good solution for us I think.
>>
>> I suggest we better do something like:
>>
>> ----
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 6287a843e8bc..1733339cc4eb 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -1038,7 +1038,7 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>>   #define __KVM_HAVE_ARCH_VM_FREE
>>   void kvm_arch_free_vm(struct kvm *kvm);
>>
>> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
>> +#if defined(CONFIG_VFIO_PCI_ZDEV_KVM) || defined(CONFIG_VFIO_PCI_ZDEV_KVM_MODULE)
> 
> This all looks good except for the line above.
> It should be:
> 
> #if IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)
> 
> Thanks.

Yes, better, thanks.
How do we do? Should I repost it with reported-by you or do you want to 
post it?

Pierre


> 
> 
>>   int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>>   void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
>>   #else
>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>> index f9d0c908e738..bbc375b028ef 100644
>> --- a/drivers/vfio/pci/Kconfig
>> +++ b/drivers/vfio/pci/Kconfig
>> @@ -45,9 +45,9 @@ config VFIO_PCI_IGD
>>   endif
>>
>>   config VFIO_PCI_ZDEV_KVM
>> -       bool "VFIO PCI extensions for s390x KVM passthrough"
>> +       def_tristate y
>> +       prompt "VFIO PCI extensions for s390x KVM passthrough"
>>          depends on S390 && KVM
>> -       default y
>>          help
>>            Support s390x-specific extensions to enable support for enhancements
>>            to KVM passthrough capabilities, such as interpretive execution of
>>
>> ----
>>
>> What do you think? It seems to me it solves the problem, what do you think?
>>
>> Regards,
>> Pierre
> 
> 

-- 
Pierre Morel
IBM Lab Boeblingen
