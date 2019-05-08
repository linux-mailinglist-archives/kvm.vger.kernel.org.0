Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A32F17DB8
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfEHQH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 12:07:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727280AbfEHQH7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 12:07:59 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48G3o34045382
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 12:07:58 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sc21195t6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 12:07:57 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 8 May 2019 17:07:55 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 17:07:53 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48G7pRH60686470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 16:07:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B940542045;
        Wed,  8 May 2019 16:07:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CBA542047;
        Wed,  8 May 2019 16:07:51 +0000 (GMT)
Received: from [9.145.42.10] (unknown [9.145.42.10])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 16:07:51 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v8 1/4] s390: ap: kvm: add PQAP interception for AQIC
To:     Tony Krowiak <akrowiak@linux.ibm.com>, borntraeger@de.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, pasic@linux.ibm.com,
        david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, freude@linux.ibm.com, mimu@linux.ibm.com
References: <1556818451-1806-1-git-send-email-pmorel@linux.ibm.com>
 <1556818451-1806-2-git-send-email-pmorel@linux.ibm.com>
 <ab120d0f-2eb4-a95c-503b-edf6de283519@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 8 May 2019 18:07:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ab120d0f-2eb4-a95c-503b-edf6de283519@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050816-4275-0000-0000-00000332B1EC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050816-4276-0000-0000-0000384221BF
Message-Id: <b946b5ee-26d6-08fa-c0de-1d8c841b3a03@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/2019 17:48, Tony Krowiak wrote:
> On 5/2/19 1:34 PM, Pierre Morel wrote:
>> We prepare the interception of the PQAP/AQIC instruction for
>> the case the AQIC facility is enabled in the guest.
>>
>> First of all we do not want to change existing behavior when
>> intercepting AP instructions without the SIE allowing the guest
>> to use AP instructions.
>>
>> In this patch we only handle the AQIC interception allowed by
>> facility 65 which will be enabled when the complete interception
>> infrastructure will be present.
>>
>> We add a callback inside the KVM arch structure for s390 for
>> a VFIO driver to handle a specific response to the PQAP
>> instruction with the AQIC command and only this command.
>>
>> But we want to be able to return a correct answer to the guest
>> even there is no VFIO AP driver in the kernel.
>> Therefor, we inject the correct exceptions from inside KVM for the
>> case the callback is not initialized, which happens when the vfio_ap
>> driver is not loaded.
>>
>> We do consider the responsability of the driver to always initialize
>> the PQAP callback if it defines queues by initializing the CRYCB for
>> a guest.
>> If the callback has been setup we call it.
>> If not we setup an answer considering that no queue is available
>> for the guest when no callback has been setup.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h      |  7 +++
>>   arch/s390/kvm/priv.c                  | 86 
>> +++++++++++++++++++++++++++++++++++
>>   drivers/s390/crypto/vfio_ap_private.h |  2 +
>>   3 files changed, 95 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h 
>> b/arch/s390/include/asm/kvm_host.h
>> index 9fff9ab..af10a11 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -18,6 +18,7 @@
>>   #include <linux/kvm_host.h>
>>   #include <linux/kvm.h>
>>   #include <linux/seqlock.h>
>> +#include <linux/module.h>
>>   #include <asm/debug.h>
>>   #include <asm/cpu.h>
>>   #include <asm/fpu/api.h>
>> @@ -722,8 +723,14 @@ struct kvm_s390_cpu_model {
>>       unsigned short ibc;
>>   };
>> +struct kvm_s390_module_hook {
>> +    int (*hook)(struct kvm_vcpu *vcpu);
>> +    struct module *owner;
>> +};
>> +
>>   struct kvm_s390_crypto {
>>       struct kvm_s390_crypto_cb *crycb;
>> +    struct kvm_s390_module_hook *pqap_hook;
>>       __u32 crycbd;
>>       __u8 aes_kw;
>>       __u8 dea_kw;
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 8679bd7..a9be84f 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -27,6 +27,7 @@
>>   #include <asm/io.h>
>>   #include <asm/ptrace.h>
>>   #include <asm/sclp.h>
>> +#include <asm/ap.h>
>>   #include "gaccess.h"
>>   #include "kvm-s390.h"
>>   #include "trace.h"
>> @@ -592,6 +593,89 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
>>       }
>>   }
>> +/*
>> + * handle_pqap: Handling pqap interception
>> + * @vcpu: the vcpu having issue the pqap instruction
>> + *
>> + * We now support PQAP/AQIC instructions and we need to correctly
>> + * answer the guest even if no dedicated driver's hook is available.
>> + *
>> + * The intercepting code calls a dedicated callback for this instruction
>> + * if a driver did register one in the CRYPTO satellite of the
>> + * SIE block.
>> + *
>> + * If no callback is available, the queues are not available, return 
>> this
>> + * response code to the caller and set CC to 3.
>> + * Else return the response code returned by the callback.
>> + */
>> +static int handle_pqap(struct kvm_vcpu *vcpu)
>> +{
>> +    struct ap_queue_status status = {};
>> +    unsigned long reg0;
>> +    int ret;
>> +    uint8_t fc;
>> +
>> +    /* Verify that the AP instruction are available */
>> +    if (!ap_instructions_available())
>> +        return -EOPNOTSUPP;
>> +    /* Verify that the guest is allowed to use AP instructions */
>> +    if (!(vcpu->arch.sie_block->eca & ECA_APIE))
>> +        return -EOPNOTSUPP;
>> +    /*
>> +     * The only possibly intercepted functions when AP instructions are
>> +     * available for the guest are AQIC and TAPQ with the t bit set
>> +     * since we do not set IC.3 (FIII) we currently will only intercept
>> +     * the AQIC function code.
>> +     */
>> +    reg0 = vcpu->run->s.regs.gprs[0];
>> +    fc = reg0 >> 24;
> 
> Should you also mask off bits 0-32 in case they might not be zeroes?

Yes I will.

> 
> Other than this, r-b
> 

Thanks,

Pierre

-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

