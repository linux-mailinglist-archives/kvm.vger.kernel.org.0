Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FEB3F0146
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 12:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhHRKJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 06:09:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10188 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233539AbhHRKI7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 06:08:59 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IA4uDw116913;
        Wed, 18 Aug 2021 06:08:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QBg4YKjBgxoS8cUqlhRCYzFYZVz/JCU0DmHCbhz9S9o=;
 b=LXwI+QnATCZVKVwppTE6mo9asSGpnvSAx0F/D9Ij5AXfHbtl7drbvDaXiTTP0hs7700a
 c+HxvhfoSfQrwx+VqQa1vP8C7U2n3zEJvRIH8Z1+oq/0KKa3CkFWPrjDNAtwZqBHDAVP
 JqCXJJqF+9Sje/kyQ3o16iVrkAA5qQBHH6+wfHYyFaU7+uUb07uMD/9G/oAHE9uotDcn
 MDqoC4GJR3dHA5BQ3aUZ06Xbk2TVAw8VPb9JiFNXPhGexqmCFRHrLwQmeU5JHPSSBNnM
 aeZ1+mv5XzE8m5Y3wD2dghxRVSKdz+I0+TajRvbB6X++dHhU926H8PJr6SLxVKAvkcpH VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agp1nxc9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 06:08:24 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17IA52Oo117411;
        Wed, 18 Aug 2021 06:08:24 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agp1nxc9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 06:08:24 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IA7Ad1000447;
        Wed, 18 Aug 2021 10:08:22 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ae53hxcwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 10:08:22 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IA4p7t53477812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 10:04:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9EE34C05E;
        Wed, 18 Aug 2021 10:08:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BC444C04A;
        Wed, 18 Aug 2021 10:08:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.177])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 10:08:18 +0000 (GMT)
Date:   Wed, 18 Aug 2021 12:08:15 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: s390: gaccess: Refactor access address range
 check
Message-ID: <20210818120815.6e048149@p-imbrenda>
In-Reply-To: <20210816150718.3063877-3-scgl@linux.ibm.com>
References: <20210816150718.3063877-1-scgl@linux.ibm.com>
        <20210816150718.3063877-3-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ffk4o2FR6aiU1o0tQRAl5esKg0JbwDGw
X-Proofpoint-ORIG-GUID: drQLDQnLtpKqS6EF83ZTGxwhGrRhDw3n
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_03:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Aug 2021 17:07:17 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Do not round down the first address to the page boundary, just translate
> it normally, which gives the value we care about in the first place.
> Given this, translating a single address is just the special case of
> translating a range spanning a single page.
> 
> Make the output optional, so the function can be used to just check a
> range.

I like the idea, but see a few nits below

> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  arch/s390/kvm/gaccess.c | 91 ++++++++++++++++++-----------------------
>  1 file changed, 39 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index df83de0843de..e5a19d8b30e2 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -794,35 +794,45 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
>  	return 1;
>  }
>  
> -static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> -			    unsigned long *pages, unsigned long nr_pages,
> -			    const union asce asce, enum gacc_mode mode)
> +/* Stores the gpas for each page in a real/virtual range into @gpas
> + * Modifies the 'struct kvm_s390_pgm_info pgm' member of @vcpu in the same
> + * way read_guest/write_guest do, the meaning of the return value is likewise

this comment is a bit confusing; why telling us to look what a
different function is doing?

either don't mention this at all (since it's more or less the expected
behaviour), or explain in full what's going on

> + * the same.
> + * If @gpas is NULL only the checks are performed.
> + */
> +static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> +			       unsigned long *gpas, unsigned long len,
> +			       const union asce asce, enum gacc_mode mode)
>  {
>  	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> +	unsigned long gpa;
> +	unsigned int seg;
> +	unsigned int offset = offset_in_page(ga);
>  	int lap_enabled, rc = 0;
>  	enum prot_type prot;
>  
>  	lap_enabled = low_address_protection_enabled(vcpu, asce);
> -	while (nr_pages) {
> +	while ((seg = min(PAGE_SIZE - offset, len)) != 0) {

I'm not terribly fond of assignments-as-values; moreover offset is used
only once.

why not something like:

	seg = min(PAGE_SIZE - offset, len);
	while (seg) {

		...

		seg = min(PAGE_SIZE, len);
	}

or maybe even:

	seg = min(PAGE_SIZE - offset, len);
	for (; seg; seg = min(PAGE_SIZE, len)) {

(although the one with the while is perhaps more readable)

>  		ga = kvm_s390_logical_to_effective(vcpu, ga);
>  		if (mode == GACC_STORE && lap_enabled && is_low_address(ga))
>  			return trans_exc(vcpu, PGM_PROTECTION, ga, ar, mode,
>  					 PROT_TYPE_LA);
> -		ga &= PAGE_MASK;
>  		if (psw_bits(*psw).dat) {
> -			rc = guest_translate(vcpu, ga, pages, asce, mode, &prot);
> +			rc = guest_translate(vcpu, ga, &gpa, asce, mode, &prot);
>  			if (rc < 0)
>  				return rc;
>  		} else {
> -			*pages = kvm_s390_real_to_abs(vcpu, ga);
> -			if (kvm_is_error_gpa(vcpu->kvm, *pages))
> +			gpa = kvm_s390_real_to_abs(vcpu, ga);
> +			if (kvm_is_error_gpa(vcpu->kvm, gpa))
>  				rc = PGM_ADDRESSING;
>  		}
>  		if (rc)
>  			return trans_exc(vcpu, rc, ga, ar, mode, prot);
> -		ga += PAGE_SIZE;
> -		pages++;
> -		nr_pages--;
> +		if (gpas)
> +			*gpas++ = gpa;
> +		offset = 0;
> +		ga += seg;
> +		len -= seg;
>  	}
>  	return 0;
>  }
> @@ -845,10 +855,10 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  		 unsigned long len, enum gacc_mode mode)
>  {
>  	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> -	unsigned long nr_pages, gpa, idx;
> +	unsigned long nr_pages, idx;
>  	unsigned int seg;
> -	unsigned long pages_array[2];
> -	unsigned long *pages;
> +	unsigned long gpa_array[2];
> +	unsigned long *gpas;

reverse Christmas tree?

also, since you're touching this: have you checked if a different size
for the array would bring any benefit?
2 seems a little too small, but I have no idea if anything bigger would
bring any advantages.

>  	int need_ipte_lock;
>  	union asce asce;
>  	int rc;
> @@ -860,27 +870,25 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  	if (rc)
>  		return rc;
>  	nr_pages = (((ga & ~PAGE_MASK) + len - 1) >> PAGE_SHIFT) + 1;
> -	pages = pages_array;
> -	if (nr_pages > ARRAY_SIZE(pages_array))
> -		pages = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
> -	if (!pages)
> +	gpas = gpa_array;
> +	if (nr_pages > ARRAY_SIZE(gpa_array))
> +		gpas = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
> +	if (!gpas)
>  		return -ENOMEM;
>  	need_ipte_lock = psw_bits(*psw).dat && !asce.r;
>  	if (need_ipte_lock)
>  		ipte_lock(vcpu);
> -	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
> +	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
>  	for (idx = 0; idx < nr_pages && !rc; idx++) {
> -		gpa = pages[idx] + offset_in_page(ga);
> -		seg = min(PAGE_SIZE - offset_in_page(gpa), len);
> -		rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
> +		seg = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
> +		rc = access_guest_frame(vcpu->kvm, mode, gpas[idx], data, seg);
>  		len -= seg;
> -		ga += seg;
>  		data += seg;
>  	}
>  	if (need_ipte_lock)
>  		ipte_unlock(vcpu);
> -	if (nr_pages > ARRAY_SIZE(pages_array))
> -		vfree(pages);
> +	if (nr_pages > ARRAY_SIZE(gpa_array))
> +		vfree(gpas);
>  	return rc;
>  }
>  
> @@ -914,8 +922,6 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>  int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>  			    unsigned long *gpa, enum gacc_mode mode)
>  {
> -	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> -	enum prot_type prot;
>  	union asce asce;
>  	int rc;
>  
> @@ -923,23 +929,7 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>  	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
>  	if (rc)
>  		return rc;
> -	if (is_low_address(gva) && low_address_protection_enabled(vcpu, asce)) {
> -		if (mode == GACC_STORE)
> -			return trans_exc(vcpu, PGM_PROTECTION, gva, 0,
> -					 mode, PROT_TYPE_LA);
> -	}
> -
> -	if (psw_bits(*psw).dat && !asce.r) {	/* Use DAT? */
> -		rc = guest_translate(vcpu, gva, gpa, asce, mode, &prot);
> -		if (rc > 0)
> -			return trans_exc(vcpu, rc, gva, 0, mode, prot);
> -	} else {
> -		*gpa = kvm_s390_real_to_abs(vcpu, gva);
> -		if (kvm_is_error_gpa(vcpu->kvm, *gpa))
> -			return trans_exc(vcpu, rc, gva, PGM_ADDRESSING, mode, 0);
> -	}
> -
> -	return rc;
> +	return guest_range_to_gpas(vcpu, gva, ar, gpa, 1, asce, mode);
>  }
>  
>  /**
> @@ -948,17 +938,14 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>  int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>  		    unsigned long length, enum gacc_mode mode)
>  {
> -	unsigned long gpa;
> -	unsigned long currlen;
> +	union asce asce;
>  	int rc = 0;
>  
> +	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
> +	if (rc)
> +		return rc;
>  	ipte_lock(vcpu);
> -	while (length > 0 && !rc) {
> -		currlen = min(length, PAGE_SIZE - (gva % PAGE_SIZE));
> -		rc = guest_translate_address(vcpu, gva, ar, &gpa, mode);
> -		gva += currlen;
> -		length -= currlen;
> -	}
> +	rc = guest_range_to_gpas(vcpu, gva, ar, NULL, length, asce, mode);
>  	ipte_unlock(vcpu);
>  
>  	return rc;

