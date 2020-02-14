Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6365E15F73F
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 20:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388806AbgBNT7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 14:59:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388320AbgBNT7g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 14:59:36 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EJwLGw116707
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 14:59:36 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4qyuhp4d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 14:59:35 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 14 Feb 2020 19:59:33 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Feb 2020 19:59:30 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EJxSLJ50856004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 19:59:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66902A4051;
        Fri, 14 Feb 2020 19:59:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EFDBA4040;
        Fri, 14 Feb 2020 19:59:27 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.191.169])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 19:59:27 +0000 (GMT)
Subject: Re: [PATCH 06/35] s390/mm: add (non)secure page access exceptions
 handlers
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-7-borntraeger@de.ibm.com>
 <c05f8672-dc29-271a-66d2-73138406cf21@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Fri, 14 Feb 2020 20:59:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c05f8672-dc29-271a-66d2-73138406cf21@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20021419-4275-0000-0000-000003A20D9A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021419-4276-0000-0000-000038B60E1F
Message-Id: <9bbf5e4e-8bdc-b990-f39f-44c6a3f54ba0@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_07:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.02.20 19:05, David Hildenbrand wrote:
> On 07.02.20 12:39, Christian Borntraeger wrote:
>> From: Vasily Gorbik <gor@linux.ibm.com>
>>
>> Add exceptions handlers performing transparent transition of non-secure
>> pages to secure (import) upon guest access and secure pages to
>> non-secure (export) upon hypervisor access.
>>
>> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
>> [frankja@linux.ibm.com: adding checks for failures]
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> [imbrenda@linux.ibm.com:  adding a check for gmap fault]
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/s390/kernel/pgm_check.S |  4 +-
>>  arch/s390/mm/fault.c         | 86 ++++++++++++++++++++++++++++++++++++
>>  2 files changed, 88 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/kernel/pgm_check.S b/arch/s390/kernel/pgm_check.S
>> index 59dee9d3bebf..27ac4f324c70 100644
>> --- a/arch/s390/kernel/pgm_check.S
>> +++ b/arch/s390/kernel/pgm_check.S
>> @@ -78,8 +78,8 @@ PGM_CHECK(do_dat_exception)		/* 39 */
>>  PGM_CHECK(do_dat_exception)		/* 3a */
>>  PGM_CHECK(do_dat_exception)		/* 3b */
>>  PGM_CHECK_DEFAULT			/* 3c */
>> -PGM_CHECK_DEFAULT			/* 3d */
>> -PGM_CHECK_DEFAULT			/* 3e */
>> +PGM_CHECK(do_secure_storage_access)	/* 3d */
>> +PGM_CHECK(do_non_secure_storage_access)	/* 3e */
>>  PGM_CHECK_DEFAULT			/* 3f */
>>  PGM_CHECK_DEFAULT			/* 40 */
>>  PGM_CHECK_DEFAULT			/* 41 */
>> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
>> index 7b0bb475c166..fab4219fa0be 100644
>> --- a/arch/s390/mm/fault.c
>> +++ b/arch/s390/mm/fault.c
>> @@ -38,6 +38,7 @@
>>  #include <asm/irq.h>
>>  #include <asm/mmu_context.h>
>>  #include <asm/facility.h>
>> +#include <asm/uv.h>
>>  #include "../kernel/entry.h"
>>  
>>  #define __FAIL_ADDR_MASK -4096L
>> @@ -816,3 +817,88 @@ static int __init pfault_irq_init(void)
>>  early_initcall(pfault_irq_init);
>>  
>>  #endif /* CONFIG_PFAULT */
>> +
>> +#if IS_ENABLED(CONFIG_KVM)
>> +void do_secure_storage_access(struct pt_regs *regs)
>> +{
>> +	unsigned long addr = regs->int_parm_long & __FAIL_ADDR_MASK;
>> +	struct vm_area_struct *vma;
>> +	struct mm_struct *mm;
>> +	struct page *page;
>> +	int rc;
>> +
>> +	switch (get_fault_type(regs)) {
>> +	case USER_FAULT:
>> +		mm = current->mm;
>> +		down_read(&mm->mmap_sem);
>> +		vma = find_vma(mm, addr);
>> +		if (!vma) {
>> +			up_read(&mm->mmap_sem);
>> +			do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
>> +			break;
>> +		}
>> +		page = follow_page(vma, addr, FOLL_WRITE | FOLL_GET);
>> +		if (IS_ERR_OR_NULL(page)) {
>> +			up_read(&mm->mmap_sem);
>> +			break;
>> +		}
>> +		if (arch_make_page_accessible(page))
>> +			send_sig(SIGSEGV, current, 0);
>> +		put_page(page);
>> +		up_read(&mm->mmap_sem);
>> +		break;
>> +	case KERNEL_FAULT:
>> +		page = phys_to_page(addr);
>> +		if (unlikely(!try_get_page(page)))
>> +			break;
>> +		rc = arch_make_page_accessible(page);
>> +		put_page(page);
>> +		if (rc)
>> +			BUG();
>> +		break;
>> +	case VDSO_FAULT:
>> +		/* fallthrough */
>> +	case GMAP_FAULT:
>> +		/* fallthrough */
> 
> Could we ever get here from the SIE?

GMAP_FAULT is only set if we came from the sie critical section, so unless we have a bug no.

> 
>> +	default:
>> +		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
>> +		WARN_ON_ONCE(1);
>> +	}
>> +}
>> +NOKPROBE_SYMBOL(do_secure_storage_access);
>> +
>> +void do_non_secure_storage_access(struct pt_regs *regs)
>> +{
>> +	unsigned long gaddr = regs->int_parm_long & __FAIL_ADDR_MASK;
>> +	struct gmap *gmap = (struct gmap *)S390_lowcore.gmap;
>> +	struct uv_cb_cts uvcb = {
>> +		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
>> +		.header.len = sizeof(uvcb),
>> +		.guest_handle = gmap->guest_handle,
>> +		.gaddr = gaddr,
>> +	};
>> +	int rc;
>> +
>> +	if (get_fault_type(regs) != GMAP_FAULT) {
>> +		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
>> +		WARN_ON_ONCE(1);
>> +		return;
>> +	}
>> +
>> +	rc = uv_make_secure(gmap, gaddr, &uvcb);
>> +	if (rc == -EINVAL && uvcb.header.rc != 0x104)
>> +		send_sig(SIGSEGV, current, 0);
> 
> 
> Looks good to me, but I don't feel like being ready for an r-b. I'll
> have to let that sink in :)
> 
> Assumed-is-okay-by: David Hildenbrand <david@redhat.com>
> 
> 

