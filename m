Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB46474A3B
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 19:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbhLNSAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 13:00:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42022 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236796AbhLNSAM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 13:00:12 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEGpDDR018188;
        Tue, 14 Dec 2021 18:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jsH/1xOOD0gzD1wFI81UumRseMslQJmaomyXOmCObkI=;
 b=I3uZo5rmwZgHrPU2M5NPMLZ+78rHy3CA8HPSms+ks+vvCAqzySoNz3TZrCH5jwxhY0hB
 QKH9hq1QxdjktFhqPqh2DiL2YxWtafKBHPvu/M9YjMLYR/cJmcr+55bP2zrfN6qY3t+n
 Xvud2TszDCA3Y1RZwONSdrThugYkYuMH1aIzNsQ9ntKtkB6ddrVfL899gl80iu5nyqO5
 pPkJ4Li/P4XdtjgfLRPo3CGRvHoXmkxokINYNJtZpAFuZmUoe8XbRQcZ3jIPAODMUgZM
 b4UMuKE8l6S1dLBv1JN25EuCqY20gW63qF8cLFeI7epOzHV9FIfCf2tNGPjpXatAICJV yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx9r96buq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 18:00:10 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BEFmsmG028903;
        Tue, 14 Dec 2021 18:00:10 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cx9r96bu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 18:00:10 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BEHcG1F008847;
        Tue, 14 Dec 2021 18:00:09 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 3cvkmb2pn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 18:00:09 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BEI07FU38404496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 18:00:07 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19529AC075;
        Tue, 14 Dec 2021 18:00:07 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3506AAC062;
        Tue, 14 Dec 2021 18:00:02 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 18:00:01 +0000 (GMT)
Message-ID: <976edfd3-5cb6-8bcb-2cdc-2989a5156b8b@linux.ibm.com>
Date:   Tue, 14 Dec 2021 13:00:00 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 24/32] KVM: s390: intercept the rpcit instruction
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
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-25-mjrosato@linux.ibm.com>
 <cd5ac83e-76b5-178b-fd9a-b651ae9dbcca@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <cd5ac83e-76b5-178b-fd9a-b651ae9dbcca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ToT5LafsS57-y7-zLwyhI5NHCuLJCXbY
X-Proofpoint-GUID: _hNPauBT7NOJ2LuazGEnaBqy6Y1k1dbQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_07,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 12:04 PM, Pierre Morel wrote:
> 
> 
> On 12/7/21 21:57, Matthew Rosato wrote:
>> For faster handling of PCI translation refreshes, intercept in KVM
>> and call the associated handler.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/kvm/pci.h  |  4 ++++
>>   arch/s390/kvm/priv.c | 41 +++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 45 insertions(+)
>>
>> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
>> index d252a631b693..3f96eff432aa 100644
>> --- a/arch/s390/kvm/pci.h
>> +++ b/arch/s390/kvm/pci.h
>> @@ -18,6 +18,10 @@
>>   #define KVM_S390_PCI_DTSM_MASK 0x40
>> +#define KVM_S390_RPCIT_STAT_MASK 0xffffffff00ffffffUL
>> +#define KVM_S390_RPCIT_INS_RES (0x10 << 24)
>> +#define KVM_S390_RPCIT_ERR (0x28 << 24)
> 
> I
> 
>> +
>>   struct zpci_gaite {
>>       unsigned int gisa;
>>       u8 gisc;
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 417154b314a6..768ae92ecc59 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -29,6 +29,7 @@
>>   #include <asm/ap.h>
>>   #include "gaccess.h"
>>   #include "kvm-s390.h"
>> +#include "pci.h"
>>   #include "trace.h"
>>   static int handle_ri(struct kvm_vcpu *vcpu)
>> @@ -335,6 +336,44 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
>>       return 0;
>>   }
>> +static int handle_rpcit(struct kvm_vcpu *vcpu)
>> +{
>> +    int reg1, reg2;
>> +    int rc;
>> +
>> +    if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>> +        return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>> +
>> +    kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
>> +
> 
> I would prefer to take care of the interception immediately here
> 
>          fh = vcpu->run->s.regs.gprs[reg1] >> 32;
>          if ((fh & aift.mdd) != 0)
>                  return -EOPNOTSUP
> 
> instead of doing it inside kvm_s390_pci_refresh_trans.
> It would simplify in my opinion.

OK

> 
>> +    rc = kvm_s390_pci_refresh_trans(vcpu, vcpu->run->s.regs.gprs[reg1],
>> +                    vcpu->run->s.regs.gprs[reg2],
>> +                    vcpu->run->s.regs.gprs[reg2+1]);
>> +
> 
> 
>> +    switch (rc) {
>> +    case 0:
>> +        kvm_s390_set_psw_cc(vcpu, 0);
>> +        break;
>> +    case -EOPNOTSUPP:
>> +        return -EOPNOTSUPP;
>> +    case -EINVAL:
>> +        kvm_s390_set_psw_cc(vcpu, 3);
>> +        break;
>> +    case -ENOMEM:
>> +        vcpu->run->s.regs.gprs[reg1] &= KVM_S390_RPCIT_STAT_MASK;
>> +        vcpu->run->s.regs.gprs[reg1] |= KVM_S390_RPCIT_INS_RES;
>> +        kvm_s390_set_psw_cc(vcpu, 1);
>> +        break;
>> +    default:
>> +        vcpu->run->s.regs.gprs[reg1] &= KVM_S390_RPCIT_STAT_MASK;
>> +        vcpu->run->s.regs.gprs[reg1] |= KVM_S390_RPCIT_ERR;
> 
> I think you should use the status reported by the hardware, reporting 
> "Error recovery in progress" what ever the hardware error was does not 
> seem right.
> 

OK, this ties into your other comment about calling __rpcit() directly 
so we have a status to look at -- will look into it

>> +        kvm_s390_set_psw_cc(vcpu, 1);
>> +        break;
>> +    }
> 
> NIT: This switch above could be much more simple if you set CC after the 
> switch.

We are setting 3 different CCs over 4 cases, so there's only 1 
duplication in the switch, so I'm not sure how much simpler?

But anyway this might not be relevant if I change to call __rpcit() 
directly.

> 
>> +
>> +    return 0;
>> +}
>> +
>>   #define SSKE_NQ 0x8
>>   #define SSKE_MR 0x4
>>   #define SSKE_MC 0x2
>> @@ -1275,6 +1314,8 @@ int kvm_s390_handle_b9(struct kvm_vcpu *vcpu)
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
> 
> 
> 
> 

