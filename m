Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47901456BA6
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 09:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhKSIbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 03:31:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231570AbhKSIbE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 03:31:04 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ7fcNf001397;
        Fri, 19 Nov 2021 08:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QhjNNA0RsfWIZP1fCo0naovAFOIkUhkM8NLk3pg5pcI=;
 b=om4+hn2JKZ1okQXtL+dzgFlmjszfmcsuYArc5b4zCQvHZLxLJJe/np1iVLtDjJV5fYJb
 IOQHIuGvxs5wL0scnf4G33kvGZs71Mvm6sHft5uF3vu5Ttvx+kcSkVtA7dFgdmKgyaKS
 8DhXrc43x8L58Hoj1NUdlL6FYMHoV3BWjuHDyuySEANBzPqmX3EdQijWsxiyRIQSVWn5
 c8sWQozNC/9Zk3jo5OKUZ4i14uRBgK9DhhQVK15eFtKUn+LiItEP1/MlE3WDONkyRLtr
 h3jKeEk/1r42/RIPPL41OTG4SkkZIIN+xd57V1Wv5u6IuAvo+6WZuZEDUBTnyLmH/hW2 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ce7rn0u50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 08:28:02 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AJ7hCKe004135;
        Fri, 19 Nov 2021 08:28:02 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ce7rn0u4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 08:28:02 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ8IFx3009068;
        Fri, 19 Nov 2021 08:28:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3ca50akxa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 08:27:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJ8RRdS61145424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 08:27:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B72D14C05C;
        Fri, 19 Nov 2021 08:27:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C1194C06D;
        Fri, 19 Nov 2021 08:27:27 +0000 (GMT)
Received: from [9.145.43.13] (unknown [9.145.43.13])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Nov 2021 08:27:27 +0000 (GMT)
Message-ID: <c169ed6d-7712-c8bc-d132-449afe9a753c@linux.ibm.com>
Date:   Fri, 19 Nov 2021 09:27:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 1/3] KVM: s390: gaccess: Refactor gpa and length
 calculation
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211028135556.1793063-1-scgl@linux.ibm.com>
 <20211028135556.1793063-2-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211028135556.1793063-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Dpe5ndZrvlRyItp0NwwBOpdwv-yXCgMa
X-Proofpoint-GUID: HO65vvlpYcnbKTq9BNYgEBDZgCWb9P9R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_07,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/28/21 15:55, Janis Schoetterl-Glausch wrote:
> Improve readability be renaming the length variable and
> not calculating the offset manually.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/kvm/gaccess.c | 32 +++++++++++++++++---------------
>   1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 6af59c59cc1b..0d11cea92603 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -831,7 +831,8 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>   		 unsigned long len, enum gacc_mode mode)
>   {
>   	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> -	unsigned long _len, nr_pages, gpa, idx;
> +	unsigned long nr_pages, gpa, idx;
> +	unsigned int fragment_len;
>   	unsigned long pages_array[2];
>   	unsigned long *pages;
>   	int need_ipte_lock;
> @@ -855,15 +856,15 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>   		ipte_lock(vcpu);
>   	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
>   	for (idx = 0; idx < nr_pages && !rc; idx++) {
> -		gpa = *(pages + idx) + (ga & ~PAGE_MASK);
> -		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
> +		gpa = pages[idx] + offset_in_page(ga);
> +		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
>   		if (mode == GACC_STORE)
> -			rc = kvm_write_guest(vcpu->kvm, gpa, data, _len);
> +			rc = kvm_write_guest(vcpu->kvm, gpa, data, fragment_len);
>   		else
> -			rc = kvm_read_guest(vcpu->kvm, gpa, data, _len);
> -		len -= _len;
> -		ga += _len;
> -		data += _len;
> +			rc = kvm_read_guest(vcpu->kvm, gpa, data, fragment_len);
> +		len -= fragment_len;
> +		ga += fragment_len;
> +		data += fragment_len;
>   	}
>   	if (need_ipte_lock)
>   		ipte_unlock(vcpu);
> @@ -875,19 +876,20 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>   int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>   		      void *data, unsigned long len, enum gacc_mode mode)
>   {
> -	unsigned long _len, gpa;
> +	unsigned int fragment_len;
> +	unsigned long gpa;
>   	int rc = 0;
>   
>   	while (len && !rc) {
>   		gpa = kvm_s390_real_to_abs(vcpu, gra);
> -		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
> +		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
>   		if (mode)
> -			rc = write_guest_abs(vcpu, gpa, data, _len);
> +			rc = write_guest_abs(vcpu, gpa, data, fragment_len);
>   		else
> -			rc = read_guest_abs(vcpu, gpa, data, _len);
> -		len -= _len;
> -		gra += _len;
> -		data += _len;
> +			rc = read_guest_abs(vcpu, gpa, data, fragment_len);
> +		len -= fragment_len;
> +		gra += fragment_len;
> +		data += fragment_len;
>   	}
>   	return rc;
>   }
> 

