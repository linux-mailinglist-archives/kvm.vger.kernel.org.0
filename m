Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACC848D553
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 11:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiAMJ6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 04:58:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232227AbiAMJ6d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 04:58:33 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20D8RWwu016435;
        Thu, 13 Jan 2022 09:58:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HroGLz4L3Ce9NznLa34GjeGtvQ8mcsS1Pe1cTzfRl6s=;
 b=RXrNNQ/88UPKjzrpcqxu1KD8CwaqQfC7fTFblHfX6P+rXe2BQl+9gs9IZPh9dBPiQKz+
 6lXdyNMWDSwW8QAAqpLAxkp5LCXrSRf8U5Op6c9pIhLk6hC8Fu6ZAYYRHm8igfkQh7j5
 zZZEv62YkAFtSmPjW5TXzkmWarMtmEbNMdoYK3DPeiY8hAlZgc+Y2aK77y9uDnKSBjuk
 +q8I/HAq121rrqbL9rBPVzp+E0fiMAYzUhl5fKetJF7A73XWkIwIH+y4hR1gjg9oCQ2H
 AIEXCVN43BuKNn0rb8AlRIHTNE8xL6+VH/y8HgKcmm+w+GE97UTk8LJSONzgrcKnRmGS dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djgkbsm4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 09:58:32 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20D9rjK8000349;
        Thu, 13 Jan 2022 09:58:32 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djgkbsm40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 09:58:32 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20D9pv5I003137;
        Thu, 13 Jan 2022 09:58:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhjm81x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 09:58:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20D9wRJw47645014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 09:58:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11A874C052;
        Thu, 13 Jan 2022 09:58:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FC224C050;
        Thu, 13 Jan 2022 09:58:26 +0000 (GMT)
Received: from [9.145.16.55] (unknown [9.145.16.55])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 09:58:26 +0000 (GMT)
Message-ID: <2e1beb50-21cb-8ff9-5e00-97344ab10ac6@linux.ibm.com>
Date:   Thu, 13 Jan 2022 10:58:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v6 03/17] KVM: s390: pv: handle secure storage exceptions
 for normal guests
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
 <20211203165814.73016-4-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211203165814.73016-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pQXkB5J-1w9RKbpB8_9I52d1OqOzeTdE
X-Proofpoint-ORIG-GUID: 4NafHGGgV3o0dI_qCSweEtLxKAYzX943
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_02,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 mlxlogscore=815 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201130055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/21 17:58, Claudio Imbrenda wrote:
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
> completely yet (which will be allowed to happen in an upcoming patch),
> a non-secure guest might touch secure memory, which will need to be
> handled properly.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/mm/fault.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index a1928c89bbfa..a644e593eef9 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -770,6 +770,7 @@ void do_secure_storage_access(struct pt_regs *regs)
>   	struct vm_area_struct *vma;
>   	struct mm_struct *mm;
>   	struct page *page;
> +	struct gmap *gmap;
>   	int rc;
>   
>   	/*
> @@ -799,6 +800,14 @@ void do_secure_storage_access(struct pt_regs *regs)
>   	}
>   
>   	switch (get_fault_type(regs)) {
> +	case GMAP_FAULT:
> +		gmap = (struct gmap *)S390_lowcore.gmap;
> +		addr = __gmap_translate(gmap, addr);

__gmap_translate() needs the mmap_read_lock(mm), no?

> +		if (IS_ERR_VALUE(addr)) {
> +			do_fault_error(regs, VM_ACCESS_FLAGS, VM_FAULT_BADMAP);
> +			break;
> +		}
> +		fallthrough;
>   	case USER_FAULT:
>   		mm = current->mm;
>   		mmap_read_lock(mm);
> @@ -827,7 +836,6 @@ void do_secure_storage_access(struct pt_regs *regs)
>   		if (rc)
>   			BUG();
>   		break;
> -	case GMAP_FAULT:
>   	default:
>   		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
>   		WARN_ON_ONCE(1);
> 

