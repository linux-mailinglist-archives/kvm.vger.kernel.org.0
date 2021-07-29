Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC643DA2EE
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 14:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhG2MRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 08:17:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231674AbhG2MRW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 08:17:22 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TCBxnb106765;
        Thu, 29 Jul 2021 08:17:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ncr9tdEnR/LWzJPZc04Ak5AtCvgjzA0ROVnP4OHIjhU=;
 b=PehW69u02IxSO+6kRFF7GppvWK32INRHEgVkGCakzcgGml+z74Aell+ARg+6Brw+HbaC
 OkDszTF9wfV8Ws4SN9+dP0TH/iC0XbxDRvH8NQeMwDaOdpJul8veq3l+5BrS9jipZGkj
 sjEVKVAAHonGtQFfA98D0KhjsQmP95WLvjVr+vb3owS0CM3epwxjxWlfh1250wtIP0A5
 sRu9fIWo2PJM6cXOGKdVS617AwBnqAWHvYWzQajuYJeafVkPJtElUHkzeIWtsLFZ6AkA
 2sVIYBrWruc/ov/M5gZDt/oa0hUvFS/EbbkNrkXnUTVNOfBnbFRMzJey1/2K6SyTKLtE YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3mm46aha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 08:17:18 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TCD6l7116314;
        Thu, 29 Jul 2021 08:17:18 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3mm46agc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 08:17:18 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TCDeEx025131;
        Thu, 29 Jul 2021 12:17:15 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3a235khppf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 12:17:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TCHCom12976530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 12:17:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AED611C050;
        Thu, 29 Jul 2021 12:17:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA39311C05B;
        Thu, 29 Jul 2021 12:17:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.155.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 12:17:11 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
 <20210728142631.41860-6-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 05/13] KVM: s390: pv: handle secure storage exceptions
 for normal guests
Message-ID: <103c158c-dba6-7421-af8d-4d771c1cf087@linux.ibm.com>
Date:   Thu, 29 Jul 2021 14:17:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728142631.41860-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sOsykrLJKdgJwp_DX4lCWhCs788WbNuo
X-Proofpoint-ORIG-GUID: PrLcVzi7kY3xJxX7wAKXNY5anxzap1TY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107290078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/21 4:26 PM, Claudio Imbrenda wrote:
> With upcoming patches, normal guests might touch secure pages.
> 
> This patch extends the existing exception handler to convert the pages
> to non secure also when the exception is triggered by a normal guest.
> 
> This can happen for example when a secure guest reboots; the first
> stage of a secure guest is non secure, and in general a secure guest
> can reboot into non-secure mode.
> 
> If the secure memory of the previous boot has not been cleared up
> completely yet, a non-secure guest might touch secure memory, which
> will need to be handled properly.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/mm/fault.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index eb68b4f36927..b89d625ea2ec 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -767,6 +767,7 @@ void do_secure_storage_access(struct pt_regs *regs)
>  	struct vm_area_struct *vma;
>  	struct mm_struct *mm;
>  	struct page *page;
> +	struct gmap *gmap;
>  	int rc;
>  
>  	/*
> @@ -796,6 +797,16 @@ void do_secure_storage_access(struct pt_regs *regs)
>  	}
>  
>  	switch (get_fault_type(regs)) {
> +	case GMAP_FAULT:
> +		gmap = (struct gmap *)S390_lowcore.gmap;
> +		/*
> +		 * Very unlikely, but if it happens, simply try again.
> +		 * The next attempt will trigger a different exception.
> +		 */

If we keep this the way it currently is then the comment needs to go to
the EFAULT check since it makes no sense above the gmap_translate().

> +		addr = __gmap_translate(gmap, addr);

So we had a valid gmap PTE to end up here where the guest touched a
secure page and triggered the exception. But we suddenly can't translate
the gaddr to a vmaddr because the gmap tracking doesn't have an entry
for the address.

My first instinct is to SIGSEGV the process since I can't come up with a
way out of this situation except for the process to map this back in.
The only reason I can think of that it was removed from the mapping is
malicious intent or a bug.

I think this is needs a VM_FAULT_BADMAP and a do_fault_error() call.

> +		if (addr == -EFAULT)
> +			break;
> +		fallthrough;
>  	case USER_FAULT:
>  		mm = current->mm;
>  		mmap_read_lock(mm);
> @@ -824,7 +835,6 @@ void do_secure_storage_access(struct pt_regs *regs)
>  		if (rc)
>  			BUG();
>  		break;
> -	case GMAP_FAULT:
>  	default:
>  		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
>  		WARN_ON_ONCE(1);
> 

