Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD8548D548
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 11:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbiAMJzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 04:55:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233606AbiAMJzA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 04:55:00 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20D8RZZ4016518;
        Thu, 13 Jan 2022 09:54:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=u+dRTaZgrG1AfxpiR4NTdR2/+JnmOZd2Dajmbxh+mxA=;
 b=J1Ogvg3NGSV0Imb8EPy6YfNrPhPSMWlspZSbI0jWmgQwyiTpaKGMQs5UPDnPoSmdt0Oc
 irTH1I1r5t1XeRfqMFl/p/O8J1C1NsLqtM24dDmO1Kbo6LIZG0gKOOfhdJv0i9T2rBSS
 NM6+gMxaX6DZo+bkin8+TQaQ8T1xZZ4MaehCOtp/QuAkI+anfToO0UZ4B+2e7/cbJV8p
 pTB/7SlzT7USKQt5LqPwckGEuCFGMjClQH+PlSPks47GNqhrbzQU4gA8IkfRBCcu3AEn
 CuzY/7w3YWNILOzgQCwnrZtX0Lvvlg5sxENnotnbb9tzG6zYAo97Igu7CpLlM3Ewbx0i uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djgkbshq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 09:54:59 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20D9NuB9027057;
        Thu, 13 Jan 2022 09:54:58 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djgkbshps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 09:54:58 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20D9qBWS027244;
        Thu, 13 Jan 2022 09:54:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3df28ah1fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 09:54:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20D9srPt38863250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 09:54:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8D914C046;
        Thu, 13 Jan 2022 09:54:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 639C74C050;
        Thu, 13 Jan 2022 09:54:53 +0000 (GMT)
Received: from [9.145.16.55] (unknown [9.145.16.55])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 09:54:53 +0000 (GMT)
Message-ID: <5ed0347a-6b69-2848-2293-1b3edd562ea4@linux.ibm.com>
Date:   Thu, 13 Jan 2022 10:54:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
 <20211203165814.73016-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v6 02/17] KVM: s390: pv: handle secure storage violations
 for protected guests
In-Reply-To: <20211203165814.73016-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o6ZQoXWismspIdfck1Zw5GJNf3hQgIKw
X-Proofpoint-ORIG-GUID: 7j27JHN6h1omgU1QmbBp6sZRtAiPPmkp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_02,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 mlxlogscore=978 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201130055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/21 17:57, Claudio Imbrenda wrote:
> With upcoming patches, protected guests will be able to trigger secure
> storage violations in normal operation.
> 
> This patch adds handling of secure storage violations for protected
> guests.
> 
> Pages that trigger the exception will be made non-secure before
> attempting to use them again for a different secure guest.

I think we should extend this a bit.

With upcoming patches, protected guests will be able to trigger secure 
storage violations in normal operation. This happens if e.g. a protected 
guest is re-booted with lazy destroy enabled and the new guest is also 
protected.

When the new protected guest touches pages that haven't yet been 
destroyed and thus are accounted to the previous protected guest we will 
see the violation exception.

We handle this exception by first trying to destroy the page because we 
expect it to belong to a defunct protected guest where a destroy should 
be possible. If that fails, we will try to do a normal export of the page.


> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/include/asm/uv.h |  1 +
>   arch/s390/kernel/uv.c      | 55 ++++++++++++++++++++++++++++++++++++++
>   arch/s390/mm/fault.c       | 10 +++++++
>   3 files changed, 66 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 72d3e49c2860..cdbd340188ab 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -356,6 +356,7 @@ static inline int is_prot_virt_host(void)
>   }
>   
>   int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
> +int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
>   int uv_destroy_owned_page(unsigned long paddr);
>   int uv_convert_from_secure(unsigned long paddr);
>   int uv_convert_owned_from_secure(unsigned long paddr);
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 386d4e42b8d3..f706456f6261 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -334,6 +334,61 @@ int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
>   }
>   EXPORT_SYMBOL_GPL(gmap_convert_to_secure);
>   
> +/**
> + * gmap_destroy_page - Destroy a guest page.
> + * @gmap the gmap of the guest
> + * @gaddr the guest address to destroy
> + *
> + * An attempt will be made to destroy the given guest page. If the attempt
> + * fails, an attempt is made to export the page. If both attempts fail, an
> + * appropriate error is returned.
> + */
> +int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
> +{
> +	struct vm_area_struct *vma;
> +	unsigned long uaddr;
> +	struct page *page;
> +	int rc;
> +
> +	rc = -EFAULT;
> +	mmap_read_lock(gmap->mm);
> +
> +	uaddr = __gmap_translate(gmap, gaddr);
> +	if (IS_ERR_VALUE(uaddr))
> +		goto out;
> +	vma = vma_lookup(gmap->mm, uaddr);
> +	if (!vma)
> +		goto out;
> +	/*
> +	 * Huge pages should not be able to become secure
> +	 */

Could be one line

> +	if (is_vm_hugetlb_page(vma))
> +		goto out;
> +
> +	rc = 0;
> +	/* we take an extra reference here */

Because?

> +	page = follow_page(vma, uaddr, FOLL_WRITE | FOLL_GET);
> +	if (IS_ERR_OR_NULL(page))
> +		goto out;
> +	rc = uv_destroy_owned_page(page_to_phys(page));
> +	/*
> +	 * Fault handlers can race; it is possible that two CPUs will fault
> +	 * on the same secure page. One CPU can destroy the page, reboot,
> +	 * re-enter secure mode and import it, while the second CPU was
> +	 * stuck at the beginning of the handler. At some point the second
> +	 * CPU will be able to progress, and it will not be able to destroy
> +	 * the page. In that case we do not want to terminate the process,
> +	 * we instead try to export the page.
> +	 */

So when we export we always export a page that's owned by the new guest, 
do I get that right?

> +	if (rc)
> +		rc = uv_convert_owned_from_secure(page_to_phys(page));
> +	put_page(page);
> +out:
> +	mmap_read_unlock(gmap->mm);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(gmap_destroy_page);
> +
>   /*
>    * To be called with the page locked or with an extra reference! This will
>    * prevent gmap_make_secure from touching the page concurrently. Having 2
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index d30f5986fa85..a1928c89bbfa 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -853,6 +853,16 @@ NOKPROBE_SYMBOL(do_non_secure_storage_access);
>   
>   void do_secure_storage_violation(struct pt_regs *regs)
>   {
> +	unsigned long gaddr = regs->int_parm_long & __FAIL_ADDR_MASK;
> +	struct gmap *gmap = (struct gmap *)S390_lowcore.gmap;
> +
> +	/*
> +	 * If the VM has been rebooted, its address space might still contain
> +	 * secure pages from the previous boot.
> +	 * Clear the page so it can be reused.
> +	 */
> +	if (!gmap_destroy_page(gmap, gaddr))
> +		return;
>   	/*
>   	 * Either KVM messed up the secure guest mapping or the same
>   	 * page is mapped into multiple secure guests.
> 

