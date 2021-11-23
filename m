Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1501145A2CE
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 13:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236683AbhKWMls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 07:41:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63762 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231623AbhKWMls (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 07:41:48 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANCHc15012772;
        Tue, 23 Nov 2021 12:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2AHWlIogODfx82bBchyBFuGtOrTwPP/5/lL3ZJEkkTM=;
 b=a1OgiByMoGcUhA0vIluenbyA+C6mmyyFoH4v92nWHa3EJHAymDNMi0LWPELARiGnXBVJ
 PMth6PV5qPnwDEV9IsdU3VQHXQ7cp5qd026zmtjhw3y2gSDpQdd1jdcLCLk0GE+TtAxn
 46Bf1T4OPGs5TGNutW1g5khHm44qt5d/pNmJ9hxIGwGgy6VnX5+AeQ5DWRr4bLPWTXzV
 Pye1xlvJ7OHCvLyWdJwL4RffUSXieZIEdXekYG9o/N8BoQyum4AvtXiJzWb14JlOdWYr
 wShDUcGypWhIWb6Sj9JOnfVd3V6pmfSv594Pi1oHy1oO+8uqf1aFqyQ/hqhL7Y78Vb7t TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgxx1j522-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 12:38:39 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANCcc6H027570;
        Tue, 23 Nov 2021 12:38:39 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgxx1j50f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 12:38:38 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANCcGEL026129;
        Tue, 23 Nov 2021 12:38:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3cern9pq9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 12:38:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANCcTSq2425386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 12:38:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F13E5A405B;
        Tue, 23 Nov 2021 12:38:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5839DA4060;
        Tue, 23 Nov 2021 12:38:28 +0000 (GMT)
Received: from [9.145.183.32] (unknown [9.145.183.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 12:38:28 +0000 (GMT)
Message-ID: <8d642b43-c037-12c0-8d0f-bb5452d9b6ed@linux.ibm.com>
Date:   Tue, 23 Nov 2021 13:38:27 +0100
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
X-Proofpoint-ORIG-GUID: t0V4p2HPANNoayPb5xE_gUAgyLKJObcz
X-Proofpoint-GUID: oj-ODNCG15Xh39I9C9m1UBLio_FQylna
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 phishscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/28/21 15:55, Janis Schoetterl-Glausch wrote:
> Improve readability be renaming the length variable and

s/be/by/

> not calculating the offset manually.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
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

