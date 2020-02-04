Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE52151A25
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 12:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgBDL4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 06:56:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgBDL4T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 06:56:19 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 014BsC8o068695
        for <kvm@vger.kernel.org>; Tue, 4 Feb 2020 06:56:18 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxmkmnnbx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 06:56:17 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 4 Feb 2020 11:56:15 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Feb 2020 11:56:12 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 014BuBZt55574554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Feb 2020 11:56:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 437274C050;
        Tue,  4 Feb 2020 11:56:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02F674C040;
        Tue,  4 Feb 2020 11:56:11 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.61])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Feb 2020 11:56:10 +0000 (GMT)
Subject: Re: [RFCv2 05/37] s390/mm: provide memory management functions for
 protected KVM guests
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-6-borntraeger@de.ibm.com>
 <20200204115738.3336787a.cohuck@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Tue, 4 Feb 2020 12:56:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200204115738.3336787a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020411-0008-0000-0000-0000034F96EE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020411-0009-0000-0000-00004A7023B3
Message-Id: <e2d208d0-e34c-c3d6-0c1b-57ee9a0c8458@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-04_02:2020-02-04,2020-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1911200001 definitions=main-2002040083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.02.20 11:57, Cornelia Huck wrote:

>>  
>>  /* Generic bits for GMAP notification on DAT table entry changes. */
>> @@ -61,6 +62,7 @@ struct gmap {
>>  	spinlock_t shadow_lock;
>>  	struct gmap *parent;
>>  	unsigned long orig_asce;
>> +	unsigned long se_handle;
> 
> This is a deviation from the "protected virtualization" naming scheme
> used in the previous patches, but I understand that the naming of this
> whole feature is still in flux :) (Would still be nice to have it
> consistent, though.)
> 
> However, I think I'd prefer something named based on protected
> virtualization: the se_* stuff here just tends to make me think of
> SELinux...

I will just use guest_handle as this guests assigned to and from such:

arch/s390/include/asm/gmap.h:   unsigned long se_handle;
arch/s390/include/asm/uv.h:             .guest_handle = gmap->se_handle,
arch/s390/kvm/pv.c:     WRITE_ONCE(kvm->arch.gmap->se_handle, 0);
arch/s390/kvm/pv.c:     kvm->arch.gmap->se_handle = uvcb.guest_handle;
arch/s390/mm/fault.c:           .guest_handle = gmap->se_handle,


> 
>>  	int edat_level;
>>  	bool removed;
>>  	bool initialized;
>> diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
>> index bcfb6371086f..984026cb3608 100644
>> --- a/arch/s390/include/asm/mmu.h
>> +++ b/arch/s390/include/asm/mmu.h
>> @@ -16,6 +16,8 @@ typedef struct {
>>  	unsigned long asce;
>>  	unsigned long asce_limit;
>>  	unsigned long vdso_base;
>> +	/* The mmu context belongs to a secure guest. */
>> +	atomic_t is_se;
> 
> Here as well.

I will use is "is_protected"
> 
>>  	/*
>>  	 * The following bitfields need a down_write on the mm
>>  	 * semaphore when they are written to. As they are only
> 
> (...)
> 
>> @@ -520,6 +521,15 @@ static inline int mm_has_pgste(struct mm_struct *mm)
>>  	return 0;
>>  }
>>  
>> +static inline int mm_is_se(struct mm_struct *mm)
>> +{
>> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
>> +	if (unlikely(atomic_read(&mm->context.is_se)))
>> +		return 1;
>> +#endif
>> +	return 0;
>> +}
> 
> I'm wondering how big of an overhead we actually have because we need
> to check the flag here if the feature is enabled. We have an extra
> check in a few functions anyway, even if protected virt is not
> configured in. Given that distributions would likely want to enable the
> feature in their kernels, I'm currently tending towards dropping the
> extra config option.

Makes sense. I will wait a bit more but if you do not disagree I will remove 
the extra host config and bind things to CONFIG_KVM or CONFIG_PGSTE depending
on context

> 
>> +
>>  static inline int mm_alloc_pgste(struct mm_struct *mm)
>>  {
>>  #ifdef CONFIG_PGSTE
> 
> (...)
> 
>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>> index f7778493e829..136c60a8e3ca 100644
>> --- a/arch/s390/kernel/uv.c
>> +++ b/arch/s390/kernel/uv.c
>> @@ -9,6 +9,8 @@
>>  #include <linux/sizes.h>
>>  #include <linux/bitmap.h>
>>  #include <linux/memblock.h>
>> +#include <linux/pagemap.h>
>> +#include <linux/swap.h>
>>  #include <asm/facility.h>
>>  #include <asm/sections.h>
>>  #include <asm/uv.h>
>> @@ -98,4 +100,172 @@ void adjust_to_uv_max(unsigned long *vmax)
>>  	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
>>  		*vmax = uv_info.max_sec_stor_addr;
>>  }
>> +
>> +static int __uv_pin_shared(unsigned long paddr)
>> +{
>> +	struct uv_cb_cfs uvcb = {
>> +		.header.cmd	= UVC_CMD_PIN_PAGE_SHARED,
>> +		.header.len	= sizeof(uvcb),
>> +		.paddr		= paddr,
>> +	};
>> +
>> +	if (uv_call(0, (u64)&uvcb))
>> +		return -EINVAL;
>> +	return 0;
> 
> I guess this call won't set an error rc in the control block, if it
> does not set a condition code != 0?

Right. RC is only set for CC!=0

