Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C284478F5B
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbhLQPTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:19:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61278 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231348AbhLQPTK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 10:19:10 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHEHhPh016380;
        Fri, 17 Dec 2021 15:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LmhtobFpfbhe6CnXrUzcqxfVYLSg15S+JL4hsbqQs/0=;
 b=fQ/wdDLvnNkPLkxwIoVG3AMlS/2i0c8cHbv96OovQi4tqkuqYsD5x+urzsMmig70opA+
 ctuGDrPmAFBcXOht4dVfKtVnz9SM3FrtKFZfo0x1IMeI6lby6Rjl4U9eccWMbbAAhkuC
 wQwwKpKIiQePyo9e/DEObW3+QoGIinuzL+cPSQ7U0PgwS5CaL0oep0/zL38lfq3qhBZN
 BhsGoMptYU9VkbtwaC3kReizf8TYPO+TDWMpx/6UN/9gTLL0xJL/I94RRAkSgA3GDzfM
 q0mMWAaYvUH5vv8eRsLJGAAmW8n8+WDQrd98rR5iwOTW/OE6wFFwWXcgchfwr9YiYBi1 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d0v689b90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 15:19:09 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHFAsEY029605;
        Fri, 17 Dec 2021 15:19:09 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d0v689b8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 15:19:09 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHFDSKr002926;
        Fri, 17 Dec 2021 15:19:08 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 3cy772bcxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 15:19:08 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHFJ7Ja14549482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 15:19:07 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB51F12405C;
        Fri, 17 Dec 2021 15:19:06 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D928B124069;
        Fri, 17 Dec 2021 15:19:02 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 15:19:02 +0000 (GMT)
Message-ID: <edd0dcee-12db-bc31-203a-bc1c94a072a5@linux.ibm.com>
Date:   Fri, 17 Dec 2021 10:19:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 16/32] KVM: s390: expose the guest zPCI interpretation
 facility
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-17-mjrosato@linux.ibm.com>
 <23ee6e80-b857-11ab-1d80-c8b1f4ff6f04@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <23ee6e80-b857-11ab-1d80-c8b1f4ff6f04@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1Qt-TK5IIhz3iqrFs_Hock8DMrn_5rHx
X-Proofpoint-GUID: xrYnc8mY-vB6ZjuDRqwRaDG3FxoMAjoh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112170088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 10:05 AM, Christian Borntraeger wrote:
> 
> 
> Am 07.12.21 um 21:57 schrieb Matthew Rosato:
>> This facility will be used to enable interpretive execution of zPCI
>> instructions.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/kvm/kvm-s390.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index c8fe9b7c2395..09991d05c871 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2751,6 +2751,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned 
>> long type)
>>           set_kvm_facility(kvm->arch.model.fac_mask, 147);
>>           set_kvm_facility(kvm->arch.model.fac_list, 147);
>>       }
>> +    if (sclp.has_zpci_interp && test_facility(69)) {
>> +        set_kvm_facility(kvm->arch.model.fac_mask, 69);
>> +        set_kvm_facility(kvm->arch.model.fac_list, 69);
>> +    }
> 
> 
> Do we need the setting of these stfle bits somewhere? I think QEMU sets 
> them as well for the guest. > We only need this when the kernel probes for this (test_kvm_facility)
> But then the question is, shouldnt
> we then simply check for sclp bits in those places?
> See also patch 19. We need to build it in a way that allows VSIE support 
> later on.
> 

Right, so this currently sets the facility bits but we don't set the 
associated guest SCLP bits.  I guess since we are not enabling for VSIE 
now it would make sense to not set either.

So then just to confirm we are on the same page:  I will drop these 
patches 16-18 and leave the kvm facilities unset until we wish to enable 
VSIE.  And then also make sure we are checking sclp bits (e.g. patch 
19).  OK?

>>       if (css_general_characteristics.aiv && test_facility(65))
>>           set_kvm_facility(kvm->arch.model.fac_mask, 65);
>>

