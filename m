Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79FE7152965
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 11:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgBEKsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 05:48:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727170AbgBEKsu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 05:48:50 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 015AinLp118882
        for <kvm@vger.kernel.org>; Wed, 5 Feb 2020 05:48:49 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xyhm73k1v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 05:48:49 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 5 Feb 2020 10:48:48 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 10:48:44 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 015AmhIL47644870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 10:48:43 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDC7B4C04E;
        Wed,  5 Feb 2020 10:48:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB0174C044;
        Wed,  5 Feb 2020 10:48:42 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.99.30])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Feb 2020 10:48:42 +0000 (GMT)
Subject: Re: [RFCv2 15/37] KVM: s390: protvirt: Implement interruption
 injection
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-16-borntraeger@de.ibm.com>
 <f6980d81-f1a9-10a0-9783-8835eae2c124@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 5 Feb 2020 11:48:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f6980d81-f1a9-10a0-9783-8835eae2c124@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20020510-0016-0000-0000-000002E3DC29
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020510-0017-0000-0000-00003346BBE1
Message-Id: <2a111d82-c9bf-1714-13fd-3cd726bf7e7a@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_03:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002050086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.02.20 10:51, Thomas Huth wrote:
> On 03/02/2020 14.19, Christian Borntraeger wrote:
>> From: Michael Mueller <mimu@linux.ibm.com>
>>
>> The patch implements interruption injection for the following
>> list of interruption types:
>>
>>   - I/O
>>     __deliver_io (III)
>>
>>   - External
>>     __deliver_cpu_timer (IEI)
>>     __deliver_ckc (IEI)
>>     __deliver_emergency_signal (IEI)
>>     __deliver_external_call (IEI)
>>
>>   - cpu restart
>>     __deliver_restart (IRI)
>>
>> The service interrupt is handled in a followup patch.
>>
>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> [fixes]
>> ---
>>  arch/s390/include/asm/kvm_host.h |  8 +++
>>  arch/s390/kvm/interrupt.c        | 93 ++++++++++++++++++++++----------
>>  2 files changed, 74 insertions(+), 27 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index a45d10d87a8a..989cea7a5591 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -563,6 +563,14 @@ enum irq_types {
>>  #define IRQ_PEND_MCHK_MASK ((1UL << IRQ_PEND_MCHK_REP) | \
>>  			    (1UL << IRQ_PEND_MCHK_EX))
>>  
>> +#define IRQ_PEND_MCHK_REP_MASK (1UL << IRQ_PEND_MCHK_REP)
>> +
>> +#define IRQ_PEND_EXT_II_MASK ((1UL << IRQ_PEND_EXT_CPU_TIMER)  | \
>> +			      (1UL << IRQ_PEND_EXT_CLOCK_COMP) | \
>> +			      (1UL << IRQ_PEND_EXT_EMERGENCY)  | \
>> +			      (1UL << IRQ_PEND_EXT_EXTERNAL)   | \
>> +			      (1UL << IRQ_PEND_EXT_SERVICE))
>> +
>>  struct kvm_s390_interrupt_info {
>>  	struct list_head list;
>>  	u64	type;
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index c06c89d370a7..ecdec6960a60 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -387,6 +387,12 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
>>  		__clear_bit(IRQ_PEND_EXT_SERVICE, &active_mask);
>>  	if (psw_mchk_disabled(vcpu))
>>  		active_mask &= ~IRQ_PEND_MCHK_MASK;
>> +	/* PV guest cpus can have a single interruption injected at a time. */
>> +	if (kvm_s390_pv_is_protected(vcpu->kvm) &&
>> +	    vcpu->arch.sie_block->iictl != IICTL_CODE_NONE)
>> +		active_mask &= ~(IRQ_PEND_EXT_II_MASK |
>> +				 IRQ_PEND_IO_MASK |
>> +				 IRQ_PEND_MCHK_REP_MASK);
> 
> I don't quite understand why there is a difference between
> IRQ_PEND_MCHK_REP and IRQ_PEND_MCHK_EX here? Why not simply use
> IRQ_PEND_MCHK_MASK here? Could you elaborate? (and maybe add a sentence
> to the patch description)

I added that part. 
My idea was that an exigent machine check would be kind of fatal that it can override
the previous interrupt. Now we do not implement the override (kill the previous interrupt)
so I agree, maybe lets use IRQ_PEND_MCHK_MASK

>> @@ -533,7 +547,6 @@ static int __must_check __deliver_pfault_init(struct kvm_vcpu *vcpu)
>>  	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
>>  					 KVM_S390_INT_PFAULT_INIT,
>>  					 0, ext.ext_params2);
>> -

Ack.

