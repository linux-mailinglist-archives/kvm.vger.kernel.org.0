Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6FB1533DF
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgBEP3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:29:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36376 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726416AbgBEP3K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 10:29:10 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 015FKQ5U143206
        for <kvm@vger.kernel.org>; Wed, 5 Feb 2020 10:29:10 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhmn3c1c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 10:29:10 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Wed, 5 Feb 2020 15:29:07 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 15:29:06 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 015FT4tX43647460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 15:29:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D364611C04A;
        Wed,  5 Feb 2020 15:29:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69F2611C04C;
        Wed,  5 Feb 2020 15:29:04 +0000 (GMT)
Received: from [9.152.99.235] (unknown [9.152.99.235])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Feb 2020 15:29:04 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [RFCv2 15/37] KVM: s390: protvirt: Implement interruption
 injection
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-16-borntraeger@de.ibm.com>
 <20200205123133.34ac71a2.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Wed, 5 Feb 2020 16:30:15 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200205123133.34ac71a2.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20020515-0020-0000-0000-000003A74232
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020515-0021-0000-0000-000021FF0D53
Message-Id: <d516c777-6fad-f11d-0952-a93fc294a12e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_04:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002050121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.02.20 12:31, Cornelia Huck wrote:
> On Mon,  3 Feb 2020 08:19:35 -0500
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
>> From: Michael Mueller <mimu@linux.ibm.com>
>>
>> The patch implements interruption injection for the following
>> list of interruption types:
>>
>>    - I/O
>>      __deliver_io (III)
>>
>>    - External
>>      __deliver_cpu_timer (IEI)
>>      __deliver_ckc (IEI)
>>      __deliver_emergency_signal (IEI)
>>      __deliver_external_call (IEI)
>>
>>    - cpu restart
>>      __deliver_restart (IRI)
> 
> Hm... what do 'III', 'IEI', and 'IRI' stand for?
> 
>>
>> The service interrupt is handled in a followup patch.
>>
>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> [fixes]
>> ---
>>   arch/s390/include/asm/kvm_host.h |  8 +++
>>   arch/s390/kvm/interrupt.c        | 93 ++++++++++++++++++++++----------
>>   2 files changed, 74 insertions(+), 27 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index a45d10d87a8a..989cea7a5591 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -563,6 +563,14 @@ enum irq_types {
>>   #define IRQ_PEND_MCHK_MASK ((1UL << IRQ_PEND_MCHK_REP) | \
>>   			    (1UL << IRQ_PEND_MCHK_EX))
>>   
>> +#define IRQ_PEND_MCHK_REP_MASK (1UL << IRQ_PEND_MCHK_REP)
>> +
>> +#define IRQ_PEND_EXT_II_MASK ((1UL << IRQ_PEND_EXT_CPU_TIMER)  | \
> 
> What does 'II' stand for? Interrupt Injection?
> 
>> +			      (1UL << IRQ_PEND_EXT_CLOCK_COMP) | \
>> +			      (1UL << IRQ_PEND_EXT_EMERGENCY)  | \
>> +			      (1UL << IRQ_PEND_EXT_EXTERNAL)   | \
>> +			      (1UL << IRQ_PEND_EXT_SERVICE))
>> +
>>   struct kvm_s390_interrupt_info {
>>   	struct list_head list;
>>   	u64	type;
> 
> (...)
> 
>> @@ -1834,7 +1872,8 @@ static void __floating_irq_kick(struct kvm *kvm, u64 type)
>>   		break;
>>   	case KVM_S390_INT_IO_MIN...KVM_S390_INT_IO_MAX:
>>   		if (!(type & KVM_S390_INT_IO_AI_MASK &&
>> -		      kvm->arch.gisa_int.origin))
>> +		      kvm->arch.gisa_int.origin) ||
>> +		      kvm_s390_pv_handle_cpu(dst_vcpu))
>>   			kvm_s390_set_cpuflags(dst_vcpu, CPUSTAT_IO_INT);
>>   		break;
>>   	default:
> 
> Looking at this... can you also talk about protected virt vs. exitless
> interrupts?
> 

Adapter interruptions are placed into the GISA but currently
not proceessed in SIE context when running in PV context.
Thus they get delivered by KVM explicitly by means of the
io interruption injection code.

...
00 01580915540:999281 4 - 04 00000000eb351b8a  inject: I/O (AI/gisa) isc 3
00 01580915540:999287 4 - 02 000000008345868d 
00[0706c00180000000-00000000f4d2c544]: deliver: I/O (AI/gisa) isc 3
00 01580915542:999283 4 - 04 00000000eb351b8a  inject: I/O (AI/gisa) isc 3
00 01580915542:999288 4 - 02 000000008345868d 
00[0706c00180000000-00000000f4d2c544]: deliver: I/O (AI/gisa) isc 3
00 01580915543:996622 4 - 04 00000000eb351b8a  inject: I/O (AI/gisa) isc 3
00 01580915543:996629 4 - 02 000000008345868d 
00[0706c00180000000-00000000f4d2c544]: deliver: I/O (AI/gisa) isc 3
00 01580915544:039280 4 - 04 00000000eb351b8a  inject: I/O (AI/gisa) isc 3
00 01580915544:039290 4 - 02 000000008345868d 
00[0706c00180000000-00000000f4d2c544]: deliver: I/O (AI/gisa) isc 3
00 01580915544:039313 4 - 04 00000000eb351b8a  inject: I/O (AI/gisa) isc 3
00 01580915544:039319 4 - 02 000000008345868d 
00[0706c00180000000-00000000f4d2c544]: deliver: I/O (AI/gisa) isc 3
...


Michael

