Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE60D492CAF
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347574AbiARRwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:52:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237208AbiARRwn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:52:43 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IFveV7032467;
        Tue, 18 Jan 2022 17:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uCUxBqDyR2tolxbZOcuhtf45ykrVGQr2zUHl3ocZUBs=;
 b=PoUsG/cVkMi3OHsjWeH+YTmatAmH0z7++673Gihjri3jwlt1m9WeFvjmJLNN4ARQsiga
 AQnPs5c/QlqCDUr4pPO+Adxt9a3ZXzh2u80Bsm6T+sYWALYUZqnjfRbanagCHWmTf1PS
 +1GYaU2fYFNKs+6DrM5IYarBxWFhcbliS/E3k5owOaeZ9a+iQFSLGrCvgVO0hXOF9FHR
 jYfsWzTxThCSVSt8BNW7NSrnAxROBINwFEBGcNA9zCSzW8ept6V+SCANa3k9mKISxRqU
 UYxH3fMg0NdKkRaoSyHQ0xHPX/3tYWrXhK3yGtBq5MwEXC74vaYrdmc8Y8888aaV1o0D kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp0ncjgxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:52:42 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IHgQMu021120;
        Tue, 18 Jan 2022 17:52:42 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp0ncjgwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:52:42 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IHlsSi011311;
        Tue, 18 Jan 2022 17:52:39 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9pumc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:52:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IHqaeY46924272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:52:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 780F5AE059;
        Tue, 18 Jan 2022 17:52:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E78BAE053;
        Tue, 18 Jan 2022 17:52:35 +0000 (GMT)
Received: from [9.171.70.230] (unknown [9.171.70.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 17:52:35 +0000 (GMT)
Message-ID: <05a6d673-df46-3d0e-9b20-a935f294e4c3@linux.ibm.com>
Date:   Tue, 18 Jan 2022 18:54:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 22/30] KVM: s390: intercept the rpcit instruction
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
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
 <e474b7a1-66de-1ede-3bbf-ccd7eff9eb7c@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <e474b7a1-66de-1ede-3bbf-ccd7eff9eb7c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U-8gveMCLpJjalyLCe0Limz-BUWVYZJf
X-Proofpoint-GUID: RtatWE7pdKFA9oRW2fGxsgBzdlcLAfNT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/18/22 18:27, Matthew Rosato wrote:
> On 1/18/22 6:05 AM, Pierre Morel wrote:
>>
>>
>> On 1/14/22 21:31, Matthew Rosato wrote:
>>> For faster handling of PCI translation refreshes, intercept in KVM
>>> and call the associated handler.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   arch/s390/kvm/priv.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 46 insertions(+)
>>>
>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>> index 417154b314a6..5b65c1830de2 100644
>>> --- a/arch/s390/kvm/priv.c
>>> +++ b/arch/s390/kvm/priv.c
>>> @@ -29,6 +29,7 @@
>>>   #include <asm/ap.h>
>>>   #include "gaccess.h"
>>>   #include "kvm-s390.h"
>>> +#include "pci.h"
>>>   #include "trace.h"
>>>   static int handle_ri(struct kvm_vcpu *vcpu)
>>> @@ -335,6 +336,49 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
>>>       return 0;
>>>   }
>>> +static int handle_rpcit(struct kvm_vcpu *vcpu)
>>> +{
>>> +    int reg1, reg2;
>>> +    u8 status;
>>> +    int rc;
>>> +
>>> +    if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>> +        return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>> +
>>> +    /* If the host doesn't support PCI, it must be an emulated 
>>> device */
>>> +    if (!IS_ENABLED(CONFIG_PCI))
>>> +        return -EOPNOTSUPP;
>>
>> AFAIU this makes also sure that the following code is not compiled in 
>> case PCI is not supported.
>>
>> I am not very used to compilation options, is it true with all our 
>> compilers and options?
>> Or do we have to specify a compiler version?
>>
>> Another concern is, shouldn't we use IS_ENABLED(CONFIG_VFIO_PCI) ?
> 
> Same idea as in the other thread -- What we are trying to protect 
> against here is referencing symbols that won't be linked (like 
> zpci_refresh_trans, or the aift->mdd a few lines below)
> 
> It is indeed true that we should never need to handle the rpcit 
> intercept in KVM if CONFIG_VFIO_PCI=n -- but the necessary symbols/code 
> are linked at least, so we can just let the SHM logic sort this out. 
> When CONFIG_PCI=y|m, arch/s390/kvm/pci.o will be linked and so we can 
> compare the function handle against afit->mdd (check to see if the 
> device is emulated) and use this to determine whether or not to 
> immediately send to userspace -- And if CONFIG_VFIO_PCI=n, a SHM bit 
> will always be on and so we'll always go to userspace via this check.

So we agree.
But as I I said somewhere else I wonder if CONFIG_VFIO_PCI_ZDEV would 
not even be better here.

> 
>>
>>
>>
>>> +
>>> +    kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
>>> +
>>> +    /* If the device has a SHM bit on, let userspace take care of 
>>> this */
>>> +    if (((vcpu->run->s.regs.gprs[reg1] >> 32) & aift->mdd) != 0)
>>> +        return -EOPNOTSUPP;
>>> +
>>> +    rc = kvm_s390_pci_refresh_trans(vcpu, vcpu->run->s.regs.gprs[reg1],
>>> +                    vcpu->run->s.regs.gprs[reg2],
>>> +                    vcpu->run->s.regs.gprs[reg2+1],
>>> +                    &status);
>>> +
>>> +    switch (rc) {
>>> +    case 0:
>>> +        kvm_s390_set_psw_cc(vcpu, 0);
>>> +        break;
>>> +    case -EOPNOTSUPP:
>>> +        return -EOPNOTSUPP;
>>> +    default:
>>> +        vcpu->run->s.regs.gprs[reg1] &= 0xffffffff00ffffffUL;
>>> +        vcpu->run->s.regs.gprs[reg1] |= (u64) status << 24;
>>> +        if (status != 0)
>>> +            kvm_s390_set_psw_cc(vcpu, 1);
>>> +        else
>>> +            kvm_s390_set_psw_cc(vcpu, 3);
>>> +        break;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>>   #define SSKE_NQ 0x8
>>>   #define SSKE_MR 0x4
>>>   #define SSKE_MC 0x2
>>> @@ -1275,6 +1319,8 @@ int kvm_s390_handle_b9(struct kvm_vcpu *vcpu)
>>>           return handle_essa(vcpu);
>>>       case 0xaf:
>>>           return handle_pfmf(vcpu);
>>> +    case 0xd3:
>>> +        return handle_rpcit(vcpu);
>>>       default:
>>>           return -EOPNOTSUPP;
>>>       }
>>>
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
