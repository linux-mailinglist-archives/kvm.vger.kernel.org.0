Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20AAC1527F4
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 10:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgBEJDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 04:03:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbgBEJDK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 04:03:10 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0158wvvF138631
        for <kvm@vger.kernel.org>; Wed, 5 Feb 2020 04:03:09 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhn3xyjr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 04:03:09 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 5 Feb 2020 09:03:06 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 5 Feb 2020 09:03:04 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0159322E45351320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 09:03:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 589E94C062;
        Wed,  5 Feb 2020 09:03:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 134F64C050;
        Wed,  5 Feb 2020 09:03:02 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.61])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Feb 2020 09:03:02 +0000 (GMT)
Subject: Re: [RFCv2 11/37] KVM: s390/mm: Make pages accessible before
 destroying the guest
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-12-borntraeger@de.ibm.com>
 <7b73da46-ad64-3ab5-cd59-5a302bbbdc5f@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 5 Feb 2020 10:03:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7b73da46-ad64-3ab5-cd59-5a302bbbdc5f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020509-0020-0000-0000-000003A7243A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020509-0021-0000-0000-000021FEEDBF
Message-Id: <6b3d7f0a-8cf8-8b2a-370a-ddbc6628941c@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_02:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 mlxlogscore=796 impostorscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002050072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.02.20 21:52, Thomas Huth wrote:
> On 03/02/2020 14.19, Christian Borntraeger wrote:
>> Before we destroy the secure configuration, we better make all
>> pages accessible again. This also happens during reboot, where we reboot
>> into a non-secure guest that then can go again into a secure mode. As
>> this "new" secure guest will have a new ID we cannot reuse the old page
>> state.
>>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/s390/include/asm/pgtable.h |  1 +
>>  arch/s390/kvm/pv.c              |  2 ++
>>  arch/s390/mm/gmap.c             | 35 +++++++++++++++++++++++++++++++++
>>  3 files changed, 38 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
>> index 65b6bb47af0a..6e167dcc35f1 100644
>> --- a/arch/s390/include/asm/pgtable.h
>> +++ b/arch/s390/include/asm/pgtable.h
>> @@ -1669,6 +1669,7 @@ extern int vmem_remove_mapping(unsigned long start, unsigned long size);
>>  extern int s390_enable_sie(void);
>>  extern int s390_enable_skey(void);
>>  extern void s390_reset_cmma(struct mm_struct *mm);
>> +extern void s390_reset_acc(struct mm_struct *mm);
>>  
>>  /* s390 has a private copy of get unmapped area to deal with cache synonyms */
>>  #define HAVE_ARCH_UNMAPPED_AREA
>> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
>> index a867b9e9c069..24d802072ac7 100644
>> --- a/arch/s390/kvm/pv.c
>> +++ b/arch/s390/kvm/pv.c
>> @@ -66,6 +66,8 @@ int kvm_s390_pv_destroy_vm(struct kvm *kvm)
>>  	int rc;
>>  	u32 ret;
>>  
>> +	/* make all pages accessible before destroying the guest */
>> +	s390_reset_acc(kvm->mm);
>>  	rc = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
>>  			   UVC_CMD_DESTROY_SEC_CONF, &ret);
>>  	WRITE_ONCE(kvm->arch.gmap->se_handle, 0);
>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>> index bf365a09f900..0b00e8d5fa39 100644
>> --- a/arch/s390/mm/gmap.c
>> +++ b/arch/s390/mm/gmap.c
>> @@ -2648,3 +2648,38 @@ void s390_reset_cmma(struct mm_struct *mm)
>>  	up_write(&mm->mmap_sem);
>>  }
>>  EXPORT_SYMBOL_GPL(s390_reset_cmma);
>> +
>> +/*
>> + * make inaccessible pages accessible again
>> + */
>> +static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
>> +			    unsigned long next, struct mm_walk *walk)
>> +{
>> +	pte_t pte = READ_ONCE(*ptep);
>> +
>> +	if (pte_present(pte))
>> +		uv_convert_from_secure(pte_val(pte) & PAGE_MASK);
> 
> Is it ok to ignore the return value from uv_convert_from_secure() ?
> Problems might go unnoticed ... maybe use at least a WARN_ONCE ?

Hmm, it is certainly one of these "should not happen" cases.
So yes, I will add a WARN_ON_ONCE.



> 
>> +	return 0;
>> +}
>> +
>> +static const struct mm_walk_ops reset_acc_walk_ops = {
>> +	.pte_entry		= __s390_reset_acc,
>> +};
>> +
>> +#include <linux/sched/mm.h>
>> +void s390_reset_acc(struct mm_struct *mm)
>> +{
>> +	/*
>> +	 * we might be called during
>> +	 * reset:                            we walk the pages and clear
>> +	 * close of all kvm file descriptor: we walk the pages and clear
>> +	 * exit of process on fd closure:    vma already gone, do nothing
>> +	 */
>> +	if (!mmget_not_zero(mm))
>> +		return;
>> +	down_read(&mm->mmap_sem);
>> +	walk_page_range(mm, 0, TASK_SIZE, &reset_acc_walk_ops, NULL);
>> +	up_read(&mm->mmap_sem);
>> +	mmput(mm);
>> +}
>> +EXPORT_SYMBOL_GPL(s390_reset_acc);
>>
> 
> Anyway,
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

thanks.

