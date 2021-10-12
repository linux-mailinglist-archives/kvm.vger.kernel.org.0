Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DCD429F9A
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhJLISo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:18:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234501AbhJLISo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 04:18:44 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C6bklo013750;
        Tue, 12 Oct 2021 04:16:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sCHeE5N0DNCQKcwXOPP+AL0+kwJtk8g7J0h6YarbhZ8=;
 b=hl11BKmd5EBo7M0pYCWzMF4GxrN9mRHDdfUz63oO/BvGfEcqE1RzKJTjjGW0yLz34O9Z
 wWWs/fB0NUyod0vN3tQXuXgx/wCYB6P90TBL2cTgqyrh2RnviM7yAx0Upde2+hrGW+fr
 ndmLWEEj/yJ++IvU33HCFPSgwDkLUyvHToM3CtLEtutYcvbZAukb3tkHimkWXkJu0/QH
 MAuP9TBty0DGAfnxpNFFKMToc9HAVBKGIpB3znVCsX1MPD13Xu/S9FlxUGY6CiUNe8aS
 Dyws+Ja7ckSVNmnWyiYRd+KNZfdwVPZVHjF/+WOP+8BpjfaLGx6moEfyDxlsg8ptb7b2 yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bmvh9k7g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 04:16:42 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19C6p6Jg002284;
        Tue, 12 Oct 2021 04:16:41 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bmvh9k7fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 04:16:41 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19C8BSsS007817;
        Tue, 12 Oct 2021 08:16:39 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3bk2bjchqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 08:16:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19C8Aq6r44827110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 08:10:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A454111C054;
        Tue, 12 Oct 2021 08:16:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23E0211C064;
        Tue, 12 Oct 2021 08:16:27 +0000 (GMT)
Received: from [9.145.20.44] (unknown [9.145.20.44])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 08:16:27 +0000 (GMT)
Message-ID: <f442a49f-dbc4-5c38-ffa1-6b17742592c3@linux.ibm.com>
Date:   Tue, 12 Oct 2021 10:16:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 08/14] KVM: s390: pv: handle secure storage exceptions
 for normal guests
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-9-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20210920132502.36111-9-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nK4buYSFW41FI9f_Wi3VZVwR9hqyKAxC
X-Proofpoint-GUID: z2KkevzjgqzfsB2GU9ql2vGq9UJRv-Ve
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_01,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 bulkscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=864 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/21 15:24, Claudio Imbrenda wrote:
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
>   arch/s390/mm/fault.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index eb68b4f36927..74784581f42d 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -767,6 +767,7 @@ void do_secure_storage_access(struct pt_regs *regs)
>   	struct vm_area_struct *vma;
>   	struct mm_struct *mm;
>   	struct page *page;
> +	struct gmap *gmap;
>   	int rc;
>   
>   	/*
> @@ -796,6 +797,14 @@ void do_secure_storage_access(struct pt_regs *regs)
>   	}
>   
>   	switch (get_fault_type(regs)) {
> +	case GMAP_FAULT:
> +		gmap = (struct gmap *)S390_lowcore.gmap;
> +		addr = __gmap_translate(gmap, addr);
> +		if (IS_ERR_VALUE(addr)) {
> +			do_fault_error(regs, VM_ACCESS_FLAGS, VM_FAULT_BADMAP);
> +			break;
> +		}
> +		fallthrough;

This would trigger an export and not a destroy, right?

>   	case USER_FAULT:
>   		mm = current->mm;
>   		mmap_read_lock(mm);
> @@ -824,7 +833,6 @@ void do_secure_storage_access(struct pt_regs *regs)
>   		if (rc)
>   			BUG();
>   		break;
> -	case GMAP_FAULT:
>   	default:
>   		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
>   		WARN_ON_ONCE(1);
> 

