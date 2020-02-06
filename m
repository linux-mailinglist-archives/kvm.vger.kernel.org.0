Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B85F154094
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 09:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgBFInh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 03:43:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11606 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727881AbgBFInh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 03:43:37 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0168hVNJ048571
        for <kvm@vger.kernel.org>; Thu, 6 Feb 2020 03:43:36 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhnsbj29-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 03:43:34 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 6 Feb 2020 08:43:25 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 08:43:23 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0168hLLw57344236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 08:43:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C1A7A4066;
        Thu,  6 Feb 2020 08:43:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A7C8A4062;
        Thu,  6 Feb 2020 08:43:21 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.61])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Feb 2020 08:43:21 +0000 (GMT)
Subject: Re: [RFCv2 21/37] KVM: S390: protvirt: Introduce instruction data
 area bounce buffer
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-22-borntraeger@de.ibm.com>
 <b947d722-845c-fa91-dfac-edc5d34a1a1c@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Thu, 6 Feb 2020 09:43:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b947d722-845c-fa91-dfac-edc5d34a1a1c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020608-4275-0000-0000-0000039E7451
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020608-4276-0000-0000-000038B2A0EB
Message-Id: <f92106be-b74e-9684-fed0-f1ca20990d99@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_06:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=895 bulkscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002060068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.02.20 12:43, David Hildenbrand wrote:
>>  #ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
>> +static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
>> +				   struct kvm_s390_mem_op *mop)
>> +{
>> +	int r = 0;
>> +	void __user *uaddr = (void __user *)mop->buf;
> 
> Reverse christmas tree :)

ack.
> 
>> +
>> +	if (mop->flags || !mop->size)
>> +		return -EINVAL;
>> +
>> +	if (mop->size > sida_size(vcpu->arch.sie_block))
>> +		return -E2BIG;
> 
> Should be caught by the check below as well (or is this an implicit
> overflow check? - see below).
> 
>> +
>> +	if (mop->size + mop->offset > sida_size(vcpu->arch.sie_block))
>> +		return -E2BIG;
>> +
> 
> Do we have to care about overflows? (at least the offset is 32-bit,
> didn't check the size :))

size and offset are both unsigned. So offset 0xfffffff0 + size 0x100 would not
be covered by both checks. 

Hmm, should we add this as well?

@@ -4538,6 +4538,9 @@ static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
        if (mop->size > sida_size(vcpu->arch.sie_block))
                return -E2BIG;
 
+       if (mop->offset > sida_size(vcpu->arch.sie_block))
+               return -E2BIG;
+
        if (mop->size + mop->offset > sida_size(vcpu->arch.sie_block))
                return -E2BIG;
 


> 
> 
>> +	switch (mop->op) {
>> +	case KVM_S390_MEMOP_SIDA_READ:
>> +		r = 0;
>> +		if (copy_to_user(uaddr, (void *)sida_origin(vcpu->arch.sie_block) +
>> +				 mop->offset, mop->size))
>> +			r = -EFAULT;
>> +
>> +		break;
>> +	case KVM_S390_MEMOP_SIDA_WRITE:
>> +		r = 0;
>> +		if (copy_from_user((void *)vcpu->arch.sie_block->sidad +
>> +				   mop->offset, uaddr, mop->size))
>> +			r = -EFAULT;
>> +		break;
>> +	}
>> +	return r;
>> +}
>> +
>>  static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
>>  				   struct kvm_pv_cmd *cmd)
>>  {
>> @@ -4708,6 +4743,20 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>  		r = kvm_s390_handle_pv_vcpu(vcpu, &args);
>>  		break;
>>  	}
>> +	case KVM_S390_SIDA_OP: {
>> +		struct kvm_s390_mem_op mem_op;
>> +
>> +		if (!kvm_s390_pv_is_protected(vcpu->kvm)) {
>> +			r = -EINVAL;
>> +			break;
>> +		}
> 
> Could we race against a VM_DESTROY? Should we protect somehow?

As far as I can tell SIDA_OP and the VCPU_DESTROY are both per cpu ioctls
and thus protected by the vcpu->mutex. (please double check).

> [...]
> 
>> -/* for KVM_S390_MEM_OP */
>> +/* for KVM_S390_MEM_OP and KVM_S390_SIDA_OP */
>>  struct kvm_s390_mem_op {
>>  	/* in */
>>  	__u64 gaddr;		/* the guest address */
>> @@ -475,11 +475,17 @@ struct kvm_s390_mem_op {
>>  	__u32 op;		/* type of operation */
>>  	__u64 buf;		/* buffer in userspace */
>>  	__u8 ar;		/* the access register number */
>> -	__u8 reserved[31];	/* should be set to 0 */
>> +	__u8 reserved21[3];	/* should be set to 0 */
>> +	__u32 offset;		/* offset into the sida */
> 
> maybe "side_offset"? or define a union, overlying the ar (because that
> obviously doesn't apply to this memop). So eventually different layout
> for different memop.

Will use sida_offset for now, but I have to look into Thomas proposal.

