Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FDD15F1FF
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 19:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391626AbgBNSF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 13:05:28 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24552 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391613AbgBNSF0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 13:05:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581703525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=rUebluGvxWOJGeiBzNgaSQxX4d6as30a+TdaEoqZTN8=;
        b=bjWIQOFQJtzTnIRyVGi+hYsJHy6MXiMtj3T8n/ZQcdgFEq7L5dhvnkB/DgevpaY1U46eC+
        judoVsPCYMOvxdMBcdxEc0qNR6zVr+7ZrtHHYKGcUD+Z8/1aXcGkoOuByhbhkHFaeHbukO
        9fSTNN1pO4FE943/U53hdM8lDJwanLY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-KzCU7JD1PpGMPrkIduZr3Q-1; Fri, 14 Feb 2020 13:05:15 -0500
X-MC-Unique: KzCU7JD1PpGMPrkIduZr3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF535800D50;
        Fri, 14 Feb 2020 18:05:12 +0000 (UTC)
Received: from [10.36.118.137] (unknown [10.36.118.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FF161001B2C;
        Fri, 14 Feb 2020 18:05:09 +0000 (UTC)
Subject: Re: [PATCH 06/35] s390/mm: add (non)secure page access exceptions
 handlers
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
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
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <c05f8672-dc29-271a-66d2-73138406cf21@redhat.com>
Date:   Fri, 14 Feb 2020 19:05:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-7-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.02.20 12:39, Christian Borntraeger wrote:
> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Add exceptions handlers performing transparent transition of non-secure
> pages to secure (import) upon guest access and secure pages to
> non-secure (export) upon hypervisor access.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> [frankja@linux.ibm.com: adding checks for failures]
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [imbrenda@linux.ibm.com:  adding a check for gmap fault]
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kernel/pgm_check.S |  4 +-
>  arch/s390/mm/fault.c         | 86 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 88 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kernel/pgm_check.S b/arch/s390/kernel/pgm_check.S
> index 59dee9d3bebf..27ac4f324c70 100644
> --- a/arch/s390/kernel/pgm_check.S
> +++ b/arch/s390/kernel/pgm_check.S
> @@ -78,8 +78,8 @@ PGM_CHECK(do_dat_exception)		/* 39 */
>  PGM_CHECK(do_dat_exception)		/* 3a */
>  PGM_CHECK(do_dat_exception)		/* 3b */
>  PGM_CHECK_DEFAULT			/* 3c */
> -PGM_CHECK_DEFAULT			/* 3d */
> -PGM_CHECK_DEFAULT			/* 3e */
> +PGM_CHECK(do_secure_storage_access)	/* 3d */
> +PGM_CHECK(do_non_secure_storage_access)	/* 3e */
>  PGM_CHECK_DEFAULT			/* 3f */
>  PGM_CHECK_DEFAULT			/* 40 */
>  PGM_CHECK_DEFAULT			/* 41 */
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 7b0bb475c166..fab4219fa0be 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -38,6 +38,7 @@
>  #include <asm/irq.h>
>  #include <asm/mmu_context.h>
>  #include <asm/facility.h>
> +#include <asm/uv.h>
>  #include "../kernel/entry.h"
>  
>  #define __FAIL_ADDR_MASK -4096L
> @@ -816,3 +817,88 @@ static int __init pfault_irq_init(void)
>  early_initcall(pfault_irq_init);
>  
>  #endif /* CONFIG_PFAULT */
> +
> +#if IS_ENABLED(CONFIG_KVM)
> +void do_secure_storage_access(struct pt_regs *regs)
> +{
> +	unsigned long addr = regs->int_parm_long & __FAIL_ADDR_MASK;
> +	struct vm_area_struct *vma;
> +	struct mm_struct *mm;
> +	struct page *page;
> +	int rc;
> +
> +	switch (get_fault_type(regs)) {
> +	case USER_FAULT:
> +		mm = current->mm;
> +		down_read(&mm->mmap_sem);
> +		vma = find_vma(mm, addr);
> +		if (!vma) {
> +			up_read(&mm->mmap_sem);
> +			do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
> +			break;
> +		}
> +		page = follow_page(vma, addr, FOLL_WRITE | FOLL_GET);
> +		if (IS_ERR_OR_NULL(page)) {
> +			up_read(&mm->mmap_sem);
> +			break;
> +		}
> +		if (arch_make_page_accessible(page))
> +			send_sig(SIGSEGV, current, 0);
> +		put_page(page);
> +		up_read(&mm->mmap_sem);
> +		break;
> +	case KERNEL_FAULT:
> +		page = phys_to_page(addr);
> +		if (unlikely(!try_get_page(page)))
> +			break;
> +		rc = arch_make_page_accessible(page);
> +		put_page(page);
> +		if (rc)
> +			BUG();
> +		break;
> +	case VDSO_FAULT:
> +		/* fallthrough */
> +	case GMAP_FAULT:
> +		/* fallthrough */

Could we ever get here from the SIE?

> +	default:
> +		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +NOKPROBE_SYMBOL(do_secure_storage_access);
> +
> +void do_non_secure_storage_access(struct pt_regs *regs)
> +{
> +	unsigned long gaddr = regs->int_parm_long & __FAIL_ADDR_MASK;
> +	struct gmap *gmap = (struct gmap *)S390_lowcore.gmap;
> +	struct uv_cb_cts uvcb = {
> +		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
> +		.header.len = sizeof(uvcb),
> +		.guest_handle = gmap->guest_handle,
> +		.gaddr = gaddr,
> +	};
> +	int rc;
> +
> +	if (get_fault_type(regs) != GMAP_FAULT) {
> +		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
> +		WARN_ON_ONCE(1);
> +		return;
> +	}
> +
> +	rc = uv_make_secure(gmap, gaddr, &uvcb);
> +	if (rc == -EINVAL && uvcb.header.rc != 0x104)
> +		send_sig(SIGSEGV, current, 0);


Looks good to me, but I don't feel like being ready for an r-b. I'll
have to let that sink in :)

Assumed-is-okay-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

