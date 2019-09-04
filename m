Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935B3A7CFA
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 09:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725267AbfIDHqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 03:46:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726033AbfIDHqp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Sep 2019 03:46:45 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x847am2l005927
        for <kvm@vger.kernel.org>; Wed, 4 Sep 2019 03:46:43 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ut8qkrxp2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 03:46:43 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 4 Sep 2019 08:46:41 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 4 Sep 2019 08:46:37 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x847kaJR61735120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Sep 2019 07:46:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82D154C059;
        Wed,  4 Sep 2019 07:46:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36B954C062;
        Wed,  4 Sep 2019 07:46:36 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.122])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Sep 2019 07:46:36 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Disallow invalid bits in kvm_valid_regs and
 kvm_dirty_regs
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190904071308.25683-1-thuth@redhat.com>
 <3b1666ee-0b7f-a775-3622-5ca7f938aeb0@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Wed, 4 Sep 2019 09:46:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3b1666ee-0b7f-a775-3622-5ca7f938aeb0@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19090407-0016-0000-0000-000002A67BAE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090407-0017-0000-0000-00003306E793
Message-Id: <0d09984f-7fb5-4af6-b90c-e9dc726e1a0a@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-04_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=725 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909040079
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.09.19 09:33, Janosch Frank wrote:
> On 9/4/19 9:13 AM, Thomas Huth wrote:
>> If unknown bits are set in kvm_valid_regs or kvm_dirty_regs, this
>> clearly indicates that something went wrong in the KVM userspace
>> application. The x86 variant of KVM already contains a check for
>> bad bits (and the corresponding kselftest checks this), so let's
>> do the same on s390x now, too.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
> 
> I think it would make sense to split the kvm changes from the test.

Yes, this would allow to backport the non-kselftest part if necessary.

With that 
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
>> ---
>>  arch/s390/include/uapi/asm/kvm.h              |  6 ++++
>>  arch/s390/kvm/kvm-s390.c                      |  4 +++
>>  .../selftests/kvm/s390x/sync_regs_test.c      | 30 +++++++++++++++++++
>>  3 files changed, 40 insertions(+)
>>
>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>> index 47104e5b47fd..436ec7636927 100644
>> --- a/arch/s390/include/uapi/asm/kvm.h
>> +++ b/arch/s390/include/uapi/asm/kvm.h
>> @@ -231,6 +231,12 @@ struct kvm_guest_debug_arch {
>>  #define KVM_SYNC_GSCB   (1UL << 9)
>>  #define KVM_SYNC_BPBC   (1UL << 10)
>>  #define KVM_SYNC_ETOKEN (1UL << 11)
>> +
>> +#define KVM_SYNC_S390_VALID_FIELDS \
>> +	(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
>> +	 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | \
>> +	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
>> +
>>  /* length and alignment of the sdnx as a power of two */
>>  #define SDNXC 8
>>  #define SDNXL (1UL << SDNXC)
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 49d7722229ae..a7d7dedfe527 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -3998,6 +3998,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>  	if (kvm_run->immediate_exit)
>>  		return -EINTR;
>>  
>> +	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_S390_VALID_FIELDS ||
>> +	    kvm_run->kvm_dirty_regs & ~KVM_SYNC_S390_VALID_FIELDS)
>> +		return -EINVAL;
>> +
>>  	vcpu_load(vcpu);
>>  
>>  	if (guestdbg_exit_pending(vcpu)) {
>> diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
>> index bbc93094519b..d5290b4ad636 100644
>> --- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
>> +++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
>> @@ -85,6 +85,36 @@ int main(int argc, char *argv[])
>>  
>>  	run = vcpu_state(vm, VCPU_ID);
>>  
>> +	/* Request reading invalid register set from VCPU. */
>> +	run->kvm_valid_regs = INVALID_SYNC_FIELD;
>> +	rv = _vcpu_run(vm, VCPU_ID);
>> +	TEST_ASSERT(rv < 0 && errno == EINVAL,
>> +		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
>> +		    rv);
>> +	vcpu_state(vm, VCPU_ID)->kvm_valid_regs = 0;
>> +
>> +	run->kvm_valid_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
>> +	rv = _vcpu_run(vm, VCPU_ID);
>> +	TEST_ASSERT(rv < 0 && errno == EINVAL,
>> +		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
>> +		    rv);
>> +	vcpu_state(vm, VCPU_ID)->kvm_valid_regs = 0;
>> +
>> +	/* Request setting invalid register set into VCPU. */
>> +	run->kvm_dirty_regs = INVALID_SYNC_FIELD;
>> +	rv = _vcpu_run(vm, VCPU_ID);
>> +	TEST_ASSERT(rv < 0 && errno == EINVAL,
>> +		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
>> +		    rv);
>> +	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs = 0;
>> +
>> +	run->kvm_dirty_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
>> +	rv = _vcpu_run(vm, VCPU_ID);
>> +	TEST_ASSERT(rv < 0 && errno == EINVAL,
>> +		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
>> +		    rv);
>> +	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs = 0;
>> +
>>  	/* Request and verify all valid register sets. */
>>  	run->kvm_valid_regs = TEST_SYNC_FIELDS;
>>  	rv = _vcpu_run(vm, VCPU_ID);
>>
> 
> 

