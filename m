Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7721542A1
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 12:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgBFLHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 06:07:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727478AbgBFLHY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 06:07:24 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 016B702k101908
        for <kvm@vger.kernel.org>; Thu, 6 Feb 2020 06:07:23 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xyhm8f1hc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 06:07:22 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 6 Feb 2020 11:07:21 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 11:07:17 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 016B7Gr656099062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 11:07:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0404A4203F;
        Thu,  6 Feb 2020 11:07:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADB4142049;
        Thu,  6 Feb 2020 11:07:15 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.61])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Feb 2020 11:07:15 +0000 (GMT)
Subject: Re: [RFCv2.1] KVM: S390: protvirt: Introduce instruction data area
 bounce buffer
To:     Thomas Huth <thuth@redhat.com>, david@redhat.com
Cc:     Ulrich.Weigand@de.ibm.com, aarcange@redhat.com, cohuck@redhat.com,
        frankja@linux.ibm.com, frankja@linux.vnet.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org
References: <4508d11e-455e-1496-f4a3-5a9c994a9126@redhat.com>
 <20200206093907.5784-1-borntraeger@de.ibm.com>
 <6a6bda5f-a432-e0b1-6f74-3f916d7ec9a0@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Thu, 6 Feb 2020 12:07:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6a6bda5f-a432-e0b1-6f74-3f916d7ec9a0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020611-0008-0000-0000-0000035044AA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020611-0009-0000-0000-00004A70D834
Message-Id: <bb6effbe-e5d9-1136-67ac-0bcdebb92fe0@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-06_01:2020-02-06,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002060083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06.02.20 11:32, Thomas Huth wrote:
> On 06/02/2020 10.39, Christian Borntraeger wrote:
>> From: Janosch Frank <frankja@linux.ibm.com>
>>
>> Now that we can't access guest memory anymore, we have a dedicated
>> sattelite block that's a bounce buffer for instruction data.
> 
> s/sattelite/satellite/
> 
>> We re-use the memop interface to copy the instruction data to / from
>> userspace. This lets us re-use a lot of QEMU code which used that
>> interface to make logical guest memory accesses which are not possible
>> anymore in protected mode anyway.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h | 11 ++++++-
>>  arch/s390/kvm/kvm-s390.c         | 49 ++++++++++++++++++++++++++++++++
>>  arch/s390/kvm/pv.c               |  9 ++++++
>>  include/uapi/linux/kvm.h         | 10 +++++--
>>  4 files changed, 76 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 9d7b248dcadc..2fe8d3c81951 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -127,6 +127,12 @@ struct mcck_volatile_info {
>>  #define CR14_INITIAL_MASK (CR14_UNUSED_32 | CR14_UNUSED_33 | \
>>  			   CR14_EXTERNAL_DAMAGE_SUBMASK)
>>  
>> +#define SIDAD_SIZE_MASK		0xff
>> +#define sida_origin(sie_block) \
>> +	(sie_block->sidad & PAGE_MASK)
>> +#define sida_size(sie_block) \
>> +	(((sie_block->sidad & SIDAD_SIZE_MASK) + 1) * PAGE_SIZE)
>> +
>>  #define CPUSTAT_STOPPED    0x80000000
>>  #define CPUSTAT_WAIT       0x10000000
>>  #define CPUSTAT_ECALL_PEND 0x08000000
>> @@ -315,7 +321,10 @@ struct kvm_s390_sie_block {
>>  #define CRYCB_FORMAT2 0x00000003
>>  	__u32	crycbd;			/* 0x00fc */
>>  	__u64	gcr[16];		/* 0x0100 */
>> -	__u64	gbea;			/* 0x0180 */
>> +	union {
>> +		__u64	gbea;			/* 0x0180 */
> 
> Maybe adjust the spaces before the comment.
> 
>> +		__u64	sidad;
[...]


ack

>> +	switch (mop->op) {
>> +	case KVM_S390_MEMOP_SIDA_READ:
>> +		r = 0;
> 
> r is alread pre-initialized with 0 where it is declared, so you could
> remove the above line.

ack

> 
>> +		if (copy_to_user(uaddr, (void *)(sida_origin(vcpu->arch.sie_block) +
>> +				 mop->sida_offset), mop->size))
>> +			r = -EFAULT;
>> +
>> +		break;
>> +	case KVM_S390_MEMOP_SIDA_WRITE:
>> +		r = 0;
> 
> dito.
> 

ack
[...]

>>  };
>>  
>> -/* for KVM_S390_MEM_OP */
>> +/* for KVM_S390_MEM_OP and KVM_S390_SIDA_OP */
> 
> Remove this change now, please.

ack

> 
>>  struct kvm_s390_mem_op {
>>  	/* in */
>>  	__u64 gaddr;		/* the guest address */
>> @@ -475,11 +475,17 @@ struct kvm_s390_mem_op {
>>  	__u32 op;		/* type of operation */
>>  	__u64 buf;		/* buffer in userspace */
>>  	__u8 ar;		/* the access register number */
>> -	__u8 reserved[31];	/* should be set to 0 */
>> +	__u8 reserved21[3];	/* should be set to 0 */
>> +	__u32 sida_offset;	/* offset into the sida */
>> +	__u8 reserved28[24];	/* should be set to 0 */
>>  };
>> +
>> +
>>  /* types for kvm_s390_mem_op->op */
>>  #define KVM_S390_MEMOP_LOGICAL_READ	0
>>  #define KVM_S390_MEMOP_LOGICAL_WRITE	1
>> +#define KVM_S390_MEMOP_SIDA_READ	2
>> +#define KVM_S390_MEMOP_SIDA_WRITE	3
>>  /* flags for kvm_s390_mem_op->flags */
>>  #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
>>  #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
> 
> With the nits fixed:
> Reviewed-by: Thomas Huth <thuth@redhat.com>

thanks

