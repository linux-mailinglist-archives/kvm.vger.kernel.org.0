Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4334D865F
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 15:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242090AbiCNODe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 10:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242087AbiCNODb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 10:03:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A974667C;
        Mon, 14 Mar 2022 07:02:21 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EDDLp6003358;
        Mon, 14 Mar 2022 14:02:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ju+ZubOx3+Q5DVzuA7TxvltHKbk5ek0nLR0H01W721E=;
 b=Ewp/JX+FYULLOsJBhS5EusWuaj61AE4HRvGQKrbBze+8CNuHbHsVUmfkBQGUz6ifJKhY
 tTTXrymK4fC/dbAtbk7UB+/kgGP/7dJL6MmM0uc+ZTJOG1RGBc4vYM2SD8eMz1C/ynKc
 60Zi7OXspeUzspiWJstzL4MYZ4kMJa4gIyEs7JarvjRTVcABA2bfrR7RbVnOJnLlCUwf
 JwOyjPM6H/rM0vpUkquTfh+7KK3iDSs8LRESddlU1geBcIrHLN2B24NIwWYHIgx1RbCp
 RmmfpK6IM4v4GYm10fXDXNkBZP7WbUhF640HmRFkrZVkORJqCgWppLGy4MOp2nMvFccl HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6d7hp43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 14:02:20 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EDDTu9004146;
        Mon, 14 Mar 2022 14:02:20 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6d7hp38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 14:02:19 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EDrWeY009393;
        Mon, 14 Mar 2022 14:02:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3erjshkqj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 14:02:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EE2Eto52232562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 14:02:14 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DA3711C093;
        Mon, 14 Mar 2022 14:02:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E45E711C07B;
        Mon, 14 Mar 2022 14:02:13 +0000 (GMT)
Received: from [9.171.14.53] (unknown [9.171.14.53])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 14:02:13 +0000 (GMT)
Message-ID: <a708afc8-c8e6-8af3-3514-53be3368131a@linux.ibm.com>
Date:   Mon, 14 Mar 2022 15:02:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 1/1] KVM: s390x: fix SCK locking
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, mimu@linux.ibm.com,
        Heiko Carstens <hca@linux.ibm.com>
References: <20220301143340.111129-1-imbrenda@linux.ibm.com>
 <391eeaf9-3fa6-13eb-c9c9-bc4768b0605b@de.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <391eeaf9-3fa6-13eb-c9c9-bc4768b0605b@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9HTEF9vSneoFhQjvS4r5qJz2TYj2Yf-A
X-Proofpoint-ORIG-GUID: uJ7_Wvc77_6vGat2bRmSMd1L2vuIg7_u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_08,2022-03-14_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203140089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 14:33, Christian Borntraeger wrote:
> Am 01.03.22 um 15:33 schrieb Claudio Imbrenda:
>> When handling the SCK instruction, the kvm lock is taken, even though
>> the vcpu lock is already being held. The normal locking order is kvm
>> lock first and then vcpu lock. This is can (and in some circumstances
>> does) lead to deadlocks.
>>
>> The function kvm_s390_set_tod_clock is called both by the SCK handler
>> and by some IOCTLs to set the clock. The IOCTLs will not hold the vcpu
>> lock, so they can safely take the kvm lock. The SCK handler holds the
>> vcpu lock, but will also somehow need to acquire the kvm lock without
>> relinquishing the vcpu lock.
>>
>> The solution is to factor out the code to set the clock, and provide
>> two wrappers. One is called like the original function and does the
>> locking, the other is called kvm_s390_try_set_tod_clock and uses
>> trylock to try to acquire the kvm lock. This new wrapper is then used
>> in the SCK handler. If locking fails, -EAGAIN is returned, which is
>> eventually propagated to userspace, thus also freeing the vcpu lock and
>> allowing for forward progress.
>>
>> This is not the most efficient or elegant way to solve this issue, but
>> the SCK instruction is deprecated and its performance is not critical.
>>
>> The goal of this patch is just to provide a simple but correct way to
>> fix the bug.
>>
>> Fixes: 6a3f95a6b04c ("KVM: s390: Intercept SCK instruction")
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>   arch/s390/kvm/kvm-s390.c | 19 ++++++++++++++++---
>>   arch/s390/kvm/kvm-s390.h |  4 ++--
>>   arch/s390/kvm/priv.c     | 14 +++++++++++++-
>>   3 files changed, 31 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 2296b1ff1e02..4e3db4004bfd 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -3869,14 +3869,12 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
>>       return 0;
>>   }
>>   -void kvm_s390_set_tod_clock(struct kvm *kvm,
>> -                const struct kvm_s390_vm_tod_clock *gtod)
>> +static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
>>   {
>>       struct kvm_vcpu *vcpu;
>>       union tod_clock clk;
>>       unsigned long i;
>>   -    mutex_lock(&kvm->lock);
>>       preempt_disable();
>>         store_tod_clock_ext(&clk);
>> @@ -3897,7 +3895,22 @@ void kvm_s390_set_tod_clock(struct kvm *kvm,
>>         kvm_s390_vcpu_unblock_all(kvm);
>>       preempt_enable();
>> +}
>> +
>> +void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
>> +{
>> +    mutex_lock(&kvm->lock);
>> +    __kvm_s390_set_tod_clock(kvm, gtod);
>> +    mutex_unlock(&kvm->lock);
>> +}
>> +
>> +int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
>> +{
>> +    if (!mutex_trylock(&kvm->lock))
>> +        return 0;
>> +    __kvm_s390_set_tod_clock(kvm, gtod);
>>       mutex_unlock(&kvm->lock);
>> +    return 1;
>>   }
>>     /**
>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>> index 098831e815e6..f2c910763d7f 100644
>> --- a/arch/s390/kvm/kvm-s390.h
>> +++ b/arch/s390/kvm/kvm-s390.h
>> @@ -349,8 +349,8 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
>>   int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
>>     /* implemented in kvm-s390.c */
>> -void kvm_s390_set_tod_clock(struct kvm *kvm,
>> -                const struct kvm_s390_vm_tod_clock *gtod);
>> +void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
>> +int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
>>   long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
>>   int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
>>   int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 417154b314a6..7f3e7990ef82 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -102,7 +102,19 @@ static int handle_set_clock(struct kvm_vcpu *vcpu)
>>           return kvm_s390_inject_prog_cond(vcpu, rc);
>>         VCPU_EVENT(vcpu, 3, "SCK: setting guest TOD to 0x%llx", gtod.tod);
>> -    kvm_s390_set_tod_clock(vcpu->kvm, &gtod);
>> +    /*
>> +     * To set the TOD clock we need to take the kvm lock, but we are
>> +     * already holding the vcpu lock, and the usual lock order is the
>> +     * opposite. Therefore we use trylock instead of lock, and if the
>> +     * kvm lock cannot be taken, we retry the instruction and return
>> +     * -EAGAIN to userspace, thus freeing the vcpu lock.
>> +     * The SCK instruction is considered legacy and at this point it's
>> +     * not worth the effort to find a nicer solution.
>> +     */
> 
> To comply more with usual comment style (no we, us) and to give more context
> on the legacy I will slightly modify the comment before sending out.
> 
>     /*
>      * To set the TOD clock the kvm lock must be taken, but the vcpu
>      * lock is already held in handle_set_clock. The usual lock order
>      * is the opposite.
>      * As SCK is deprecated and should not be used in several cases

I think you'd want commas around that clause, i.e.
	* As SCK is deprecated and should not be used in several cases,
	* for example when the multiple-opoch or the TOD-clock-steering
	* facility is installed (see Principles of Operation),
	* a slow path can be used.

>      * like the existence of the multiple epoch facility or TOD clock>      * steering (see Principles of Operation) a slow path can be used.
>      * If the lock can not be taken via try_lock, the instruction will
>      * be retried via -EAGAIN at a later point in time.
>          */
> 
> Ok with everybody?
> 
> 
> 
>> +    if (!kvm_s390_try_set_tod_clock(vcpu->kvm, &gtod)) {
>> +        kvm_s390_retry_instr(vcpu);
>> +        return -EAGAIN;
>> +    }
>>         kvm_s390_set_psw_cc(vcpu, 0);
>>       return 0;

