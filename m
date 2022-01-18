Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7379C492C50
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347105AbiARR1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:27:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235820AbiARR1b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:27:31 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IExOdS010665;
        Tue, 18 Jan 2022 17:27:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VwqQ1/rlkIce/fGtP3zKeUZ5YvJ6q6hY9zeOhO3d/+s=;
 b=Ix9jdA5ISDlYr/zx9S6LhwJzR5Rscl007nboKYjzNxD6CLwL1hMr9J0UJJyE6mQtAqST
 f49nNo+JQhXdZdssW3YnBBsSuPlSQy510n2FE08TYXS4NyH07qn3Cj08QDB77xm1ofRa
 P7qDYGZjCeBcMc0y9KMkCOWdc051t5ls/hevDmnaZAp57rOVpq7f8TstGJ6ToXg/Yocn
 BJm1ewE15r6oTyjxD9QyyAiCb16Q4YvuxvpZ+BDppY962GNnr6hAvZWGYsu5A7LoFkOS
 y7vZ9uHtQcqOFd/g+1mXfhvhmqMnS6s29MoaEdYMX4J551yCUcXN1wkOg30FK0u/l9R7 Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnwjx0260-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:27:30 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IHKTWc009749;
        Tue, 18 Jan 2022 17:27:30 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnwjx0256-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:27:30 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IHLspZ030762;
        Tue, 18 Jan 2022 17:27:28 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 3dknwapefg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:27:28 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IHRRFB23069066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:27:27 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 896DD6E050;
        Tue, 18 Jan 2022 17:27:27 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 797076E04E;
        Tue, 18 Jan 2022 17:27:25 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 17:27:25 +0000 (GMT)
Message-ID: <e474b7a1-66de-1ede-3bbf-ccd7eff9eb7c@linux.ibm.com>
Date:   Tue, 18 Jan 2022 12:27:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 22/30] KVM: s390: intercept the rpcit instruction
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-23-mjrosato@linux.ibm.com>
 <6eb0b596-c8b7-3529-55af-f3101821c74b@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <6eb0b596-c8b7-3529-55af-f3101821c74b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y9AnhwjnXtmR554DFqrogGb50t8LSAF6
X-Proofpoint-ORIG-GUID: AsYT3d06h1_R6Yca-3G_CT25SQ9MCpaO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_04,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201180103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 6:05 AM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
>> For faster handling of PCI translation refreshes, intercept in KVM
>> and call the associated handler.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/kvm/priv.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 46 insertions(+)
>>
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 417154b314a6..5b65c1830de2 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -29,6 +29,7 @@
>>   #include <asm/ap.h>
>>   #include "gaccess.h"
>>   #include "kvm-s390.h"
>> +#include "pci.h"
>>   #include "trace.h"
>>   static int handle_ri(struct kvm_vcpu *vcpu)
>> @@ -335,6 +336,49 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
>>       return 0;
>>   }
>> +static int handle_rpcit(struct kvm_vcpu *vcpu)
>> +{
>> +    int reg1, reg2;
>> +    u8 status;
>> +    int rc;
>> +
>> +    if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>> +        return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>> +
>> +    /* If the host doesn't support PCI, it must be an emulated device */
>> +    if (!IS_ENABLED(CONFIG_PCI))
>> +        return -EOPNOTSUPP;
> 
> AFAIU this makes also sure that the following code is not compiled in 
> case PCI is not supported.
> 
> I am not very used to compilation options, is it true with all our 
> compilers and options?
> Or do we have to specify a compiler version?
> 
> Another concern is, shouldn't we use IS_ENABLED(CONFIG_VFIO_PCI) ?

Same idea as in the other thread -- What we are trying to protect 
against here is referencing symbols that won't be linked (like 
zpci_refresh_trans, or the aift->mdd a few lines below)

It is indeed true that we should never need to handle the rpcit 
intercept in KVM if CONFIG_VFIO_PCI=n -- but the necessary symbols/code 
are linked at least, so we can just let the SHM logic sort this out. 
When CONFIG_PCI=y|m, arch/s390/kvm/pci.o will be linked and so we can 
compare the function handle against afit->mdd (check to see if the 
device is emulated) and use this to determine whether or not to 
immediately send to userspace -- And if CONFIG_VFIO_PCI=n, a SHM bit 
will always be on and so we'll always go to userspace via this check.

> 
> 
> 
>> +
>> +    kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
>> +
>> +    /* If the device has a SHM bit on, let userspace take care of 
>> this */
>> +    if (((vcpu->run->s.regs.gprs[reg1] >> 32) & aift->mdd) != 0)
>> +        return -EOPNOTSUPP;
>> +
>> +    rc = kvm_s390_pci_refresh_trans(vcpu, vcpu->run->s.regs.gprs[reg1],
>> +                    vcpu->run->s.regs.gprs[reg2],
>> +                    vcpu->run->s.regs.gprs[reg2+1],
>> +                    &status);
>> +
>> +    switch (rc) {
>> +    case 0:
>> +        kvm_s390_set_psw_cc(vcpu, 0);
>> +        break;
>> +    case -EOPNOTSUPP:
>> +        return -EOPNOTSUPP;
>> +    default:
>> +        vcpu->run->s.regs.gprs[reg1] &= 0xffffffff00ffffffUL;
>> +        vcpu->run->s.regs.gprs[reg1] |= (u64) status << 24;
>> +        if (status != 0)
>> +            kvm_s390_set_psw_cc(vcpu, 1);
>> +        else
>> +            kvm_s390_set_psw_cc(vcpu, 3);
>> +        break;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   #define SSKE_NQ 0x8
>>   #define SSKE_MR 0x4
>>   #define SSKE_MC 0x2
>> @@ -1275,6 +1319,8 @@ int kvm_s390_handle_b9(struct kvm_vcpu *vcpu)
>>           return handle_essa(vcpu);
>>       case 0xaf:
>>           return handle_pfmf(vcpu);
>> +    case 0xd3:
>> +        return handle_rpcit(vcpu);
>>       default:
>>           return -EOPNOTSUPP;
>>       }
>>
> 

