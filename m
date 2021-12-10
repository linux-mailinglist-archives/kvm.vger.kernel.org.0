Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713D24702B5
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 15:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242071AbhLJOZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 09:25:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10782 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232310AbhLJOZf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 09:25:35 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BADvm8x008389;
        Fri, 10 Dec 2021 14:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VVeR8QBvzs2y1tQH21iTGgNnpjv/MTLz/B/Yt0LNyvY=;
 b=b/7lzJ+EZPRr1vCp1Iq81KAgvYU+f6sPLQoJaRy4f6Rq4VT+Zs1esi14gsWmBgRm80Wt
 JDs7+BUOcq9xmSxSZB05GAgfJUb/N00Cr8ihUa+m/CuZ2aFWsTcJUqSFFNSu3cL4gvNk
 e+mgJAWuX//dbz3XcApWJF+0zXKPUvA5GHY58r0DoeC0rVYNQ3f77aYcNmZijq67fHbb
 JdsorSZMPBpYU7YqAdOYsZgFLyCA9nlw9w9h2v1SrbcuBO0vH0Um1nofMSmwlvXJGBIR
 Vt3dp70WJ1hkXBuBTccs49Vuw+qo+LqUCnLv84f4Q21TnX7xCS+YN7AvmG7QuGqzf8vH 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cv886gf6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 14:21:59 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BADwWZc010186;
        Fri, 10 Dec 2021 14:21:59 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cv886gf6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 14:21:59 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BAEG4EC024535;
        Fri, 10 Dec 2021 14:21:58 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 3cqyycg5gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 14:21:58 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BAELvRi35455456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 14:21:57 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23A8B2806D;
        Fri, 10 Dec 2021 14:21:57 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4401128058;
        Fri, 10 Dec 2021 14:21:49 +0000 (GMT)
Received: from [9.211.51.40] (unknown [9.211.51.40])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 10 Dec 2021 14:21:48 +0000 (GMT)
Message-ID: <6127b774-1042-0057-6b5b-29471554149b@linux.ibm.com>
Date:   Fri, 10 Dec 2021 09:21:47 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 19/32] KVM: s390: mechanism to enable guest zPCI
 Interpretation
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
 <20211207205743.150299-20-mjrosato@linux.ibm.com>
 <7df88bde-2b63-4a91-036c-28527f56e22d@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <7df88bde-2b63-4a91-036c-28527f56e22d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rMBuYAGuVOTHq6Pq4s-1AtIQ7GhoM3aJ
X-Proofpoint-ORIG-GUID: sUdoKL0ACDD2ok_bQf5fxtr_eavOwNQ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_04,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 phishscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112100081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/21 8:27 AM, Christian Borntraeger wrote:
> 
> 
> Am 07.12.21 um 21:57 schrieb Matthew Rosato:
>> The guest must have access to certain facilities in order to allow
>> interpretive execution of zPCI instructions and adapter event
>> notifications.  However, there are some cases where a guest might
>> disable interpretation -- provide a mechanism via which we can defer
>> enabling the associated zPCI interpretation facilities until the guest
>> indicates it wishes to use them.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |  4 +++
>>   arch/s390/kvm/kvm-s390.c         | 43 ++++++++++++++++++++++++++++++++
>>   arch/s390/kvm/kvm-s390.h         | 10 ++++++++
>>   3 files changed, 57 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h 
>> b/arch/s390/include/asm/kvm_host.h
>> index 3f147b8d050b..38982c1de413 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -252,7 +252,10 @@ struct kvm_s390_sie_block {
>>   #define ECB2_IEP    0x20
>>   #define ECB2_PFMFI    0x08
>>   #define ECB2_ESCA    0x04
>> +#define ECB2_ZPCI_LSI    0x02
>>       __u8    ecb2;                   /* 0x0062 */
>> +#define ECB3_AISI    0x20
>> +#define ECB3_AISII    0x10
>>   #define ECB3_DEA 0x08
>>   #define ECB3_AES 0x04
>>   #define ECB3_RI  0x01
>> @@ -938,6 +941,7 @@ struct kvm_arch{
>>       int use_cmma;
>>       int use_pfmfi;
>>       int use_skf;
>> +    int use_zpci_interp;
>>       int user_cpu_state_ctrl;
>>       int user_sigp;
>>       int user_stsi;
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index a680f2a02b67..361d742cdf0d 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -1023,6 +1023,47 @@ static int kvm_s390_vm_set_crypto(struct kvm 
>> *kvm, struct kvm_device_attr *attr)
>>       return 0;
>>   }
>> +static void kvm_s390_vcpu_pci_setup(struct kvm_vcpu *vcpu)
>> +{
>> +    /*
>> +     * If the facilities aren't available for PCI interpretation and
>> +     * interrupt forwarding, we shouldn't be here.
>> +     */
> 
> This reads like we want a WARN_ON or BUG_ON, but as we call this 
> uncoditionally this is
> actually a valid check. So instead of "shouldn't be here" say something 
> like "bail out
> if interpretion is not active".  ?

Right, this comment block is plain wrong.  We expect to get here under 
multiple circumstances and its OK for this bit to be off:
- initial vcpu setup (use_zpci_interp is off)
- Right after we set use_zpci_interp=1 (turn on ECB for all vcpu)
- hotplug vcpu setup (use_zpci_interp might be on or off)

Will re-word.

> 
>> +    if (!vcpu->kvm->arch.use_zpci_interp)
>> +        return;
>> +
>> +    vcpu->arch.sie_block->ecb2 |= ECB2_ZPCI_LSI;
>> +    vcpu->arch.sie_block->ecb3 |= ECB3_AISII + ECB3_AISI;
>> +}
>> +
>> +void kvm_s390_vcpu_pci_enable_interp(struct kvm *kvm)
>> +{
>> +    struct kvm_vcpu *vcpu;
>> +    int i;
>> +
>> +    /*
>> +     * If host facilities are available, turn on interpretation for the
>> +     * life of this guest
>> +     */
>> +    if (!test_facility(69) || !test_facility(70) || 
>> !test_facility(71) ||
>> +        !test_facility(72))
>> +        return;
> 
> Wouldnt that also enable interpretion for VSIE? I guess we should check 
> for the
> sclp facilities from patches 1,2,3, and 4 instead.
> 

Good point -- will change.


