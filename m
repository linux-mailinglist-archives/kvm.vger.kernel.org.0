Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FC04E4EB5
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiCWIxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbiCWIxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:53:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C8C72E07;
        Wed, 23 Mar 2022 01:52:24 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22N7frsT021487;
        Wed, 23 Mar 2022 08:52:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Scu3z/PeAZ96aNmKdNJtMI7W4oMjSWz8CacLn9QyKg4=;
 b=efN7EAMChPdw30OzP9QigZhgeLerviMU4Iapop4dlMJxZ6x2J98wePS2pyGx4hIZBKJx
 xJ/pq9my9Pt6VP2veENBUAGeAtY0RKagPQcrohpwJQFFAHcfIFdSONpCg/ZIr3nSXdma
 2aY29Yi1m0KcQkyjkHAdvZq1IR8Z+GortQL8o9UcHK/mLneeuyUs1sODoGvt1Nyz5XaY
 B4bQcgitSqXw9dJ6f/q5p9JiPl7/ljW3qbemHYsgc/j6MUIIMIwVNRVSmqAYjRECtYMy
 45bv4eVRGRk++HB1nKb8asP8TQXHoArcOmGlrJYhKjhX1frFFdDBBt/0hP57E+DAMK97 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eyyct971c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:52:23 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22N8nxWM029224;
        Wed, 23 Mar 2022 08:52:22 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eyyct970t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:52:22 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22N8lWn5000771;
        Wed, 23 Mar 2022 08:52:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3ew6t96xnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:52:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22N8qHZN49480044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 08:52:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B557A11C054;
        Wed, 23 Mar 2022 08:52:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EB9911C050;
        Wed, 23 Mar 2022 08:52:17 +0000 (GMT)
Received: from [9.171.51.164] (unknown [9.171.51.164])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 08:52:17 +0000 (GMT)
Message-ID: <95c28949-8732-8812-c255-79467dafb5c8@linux.ibm.com>
Date:   Wed, 23 Mar 2022 09:52:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] KVM: s390: Fix lockdep issue in vm memop
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220322153204.2637400-1-scgl@linux.ibm.com>
 <44618f05-9aee-5aa5-b036-dd838285b26f@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <44618f05-9aee-5aa5-b036-dd838285b26f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8xTjBKRm31b552-J35ldxmE7PDwc5q5Q
X-Proofpoint-ORIG-GUID: 1I7evJ_plTLTtZFh2YWC_Ye8fnhbccdC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_08,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/23/22 08:58, Janosch Frank wrote:
> On 3/22/22 16:32, Janis Schoetterl-Glausch wrote:
>> Issuing a memop on a protected vm does not make sense,
> 
> Issuing a vm memop on a protected vm...
> 
> The cpu memop still makes sense, no?

The vcpu memop does hold the vcpu->lock, so no lockdep issue.
If you issue a vcpu memop while enabling protected virtualization,
the memop might find that the vcpu is not protected, while other vcpus
might already be, but I don't think there's a way to create secure memory
concurrent with the memop.
> 
>> neither is the memory readable/writable, nor does it make sense to check
>> storage keys. This is why the ioctl will return -EINVAL when it detects
>> the vm to be protected. However, in order to ensure that the vm cannot
>> become protected during the memop, the kvm->lock would need to be taken
>> for the duration of the ioctl. This is also required because
>> kvm_s390_pv_is_protected asserts that the lock must be held.
>> Instead, don't try to prevent this. If user space enables secure
>> execution concurrently with a memop it must accecpt the possibility of
>> the memop failing.
>> Still check if the vm is currently protected, but without locking and
>> consider it a heuristic.
>>
>> Fixes: ef11c9463ae0 ("KVM: s390: Add vm IOCTL for key checked guest absolute memory access")
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 
> Makes sense to me.
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
>> ---
>>   arch/s390/kvm/kvm-s390.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index ca96f84db2cc..53adbe86a68f 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -2385,7 +2385,16 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
>>           return -EINVAL;
>>       if (mop->size > MEM_OP_MAX_SIZE)
>>           return -E2BIG;
>> -    if (kvm_s390_pv_is_protected(kvm))
>> +    /*
>> +     * This is technically a heuristic only, if the kvm->lock is not
>> +     * taken, it is not guaranteed that the vm is/remains non-protected.
>> +     * This is ok from a kernel perspective, wrongdoing is detected
>> +     * on the access, -EFAULT is returned and the vm may crash the
>> +     * next time it accesses the memory in question.
>> +     * There is no sane usecase to do switching and a memop on two
>> +     * different CPUs at the same time.
>> +     */
>> +    if (kvm_s390_pv_get_handle(kvm))
>>           return -EINVAL;
>>       if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
>>           if (access_key_invalid(mop->key))
>>
>> base-commit: c9b8fecddb5bb4b67e351bbaeaa648a6f7456912
> 

