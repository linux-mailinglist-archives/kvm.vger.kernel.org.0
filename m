Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9199456BF0
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 09:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhKSI70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 03:59:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28378 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230027AbhKSI70 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 03:59:26 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ8Gnv5021462;
        Fri, 19 Nov 2021 08:56:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=E6zLd/0++p3FtBdKLHrSQYmTlWpzxPTErCe1PgZmg1s=;
 b=Tq0xF89ZyIOIK9FaKl8JEQuZJ1Ir781V8wl9gM/pL2y5WAp2qJXP5L/Md9r82GwW1AHQ
 HPpQeAcKl1b96S4pUv/+Yjc8Sjs5Vd4a2ilmPXmAHiFsEQwINBskGb2W4ajhAC0XIkiE
 fKpt0VlICc1+4YAtnr6YIfbUpsw9t8lPs9Fhrfrw2391ZK2Z7Cp32M3FeHfyDSs2YADu
 MXd7fimKDYqEBDJbDUzqBhTNeVmq0OHWdpqRoNIA4hVRGmHUAQQ/T5IC1QWCzdQxZkzU
 L0lRgm0/hhEsppT493mJ7pF2qmYJwgBzhqI7zmSKEYCzSRH2iS82z8B2ET3Cve7NhsuB YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ce89b8ma7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 08:56:24 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AJ8bAhw027183;
        Fri, 19 Nov 2021 08:56:23 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ce89b8m9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 08:56:23 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ8rj3f020981;
        Fri, 19 Nov 2021 08:56:22 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ca50av8ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 08:56:21 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJ8nGkr64880912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 08:49:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CC694C044;
        Fri, 19 Nov 2021 08:56:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F4F94C040;
        Fri, 19 Nov 2021 08:56:17 +0000 (GMT)
Received: from [9.145.43.13] (unknown [9.145.43.13])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Nov 2021 08:56:17 +0000 (GMT)
Message-ID: <c0f5143c-24cd-e40b-f797-23d67a22c2c6@linux.ibm.com>
Date:   Fri, 19 Nov 2021 09:56:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: s390: gaccess: Refactor access address range
 check
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
 <20211028135556.1793063-3-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211028135556.1793063-3-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8-tdaPBXHIocxAtqQpSW67osMPRTYsL7
X-Proofpoint-ORIG-GUID: BoQHlBf5upU-p0V2JQNie3gKw808TzxQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_08,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/28/21 15:55, Janis Schoetterl-Glausch wrote:
> Do not round down the first address to the page boundary, just translate
> it normally, which gives the value we care about in the first place.
> Given this, translating a single address is just the special case of
> translating a range spanning a single page.
> 
> Make the output optional, so the function can be used to just check a
> range.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/kvm/gaccess.c | 122 +++++++++++++++++++++++-----------------
>   1 file changed, 69 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 0d11cea92603..7725dd7566ed 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -794,35 +794,74 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
>   	return 1;
>   }
>   
> -static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> -			    unsigned long *pages, unsigned long nr_pages,
> -			    const union asce asce, enum gacc_mode mode)
> +/**
> + * guest_range_to_gpas() - Calculate guest physical addresses of page fragments
> + * covering a logical range

I'd add an empty line here.
Apart from that this is a very nice cleanup.

> + * @vcpu: virtual cpu
> + * @ga: guest address, start of range
> + * @ar: access register
> + * @gpas: output argument, may be NULL
> + * @len: length of range in bytes
> + * @asce: address-space-control element to use for translation
> + * @mode: access mode
> + *
> + * Translate a logical range to a series of guest absolute addresses,
> + * such that the concatenation of page fragments starting at each gpa make up
> + * the whole range.
> + * The translation is performed as if done by the cpu for the given @asce, @ar,
> + * @mode and state of the @vcpu.
> + * If the translation causes an exception, its program interruption code is
> + * returned and the &struct kvm_s390_pgm_info pgm member of @vcpu is modified
> + * such that a subsequent call to kvm_s390_inject_prog_vcpu() will inject
> + * a correct exception into the guest.
> + * The resulting gpas are stored into @gpas, unless it is NULL.
> + *
> + * Note: All gpas except the first one start at the beginning of a page.
> + *       When deriving the boundaries of a fragment from a gpa, all but the last
> + *       fragment end at the end of the page.
> + *
> + * Return:
> + * * 0		- success
> + * * <0		- translation could not be performed, for example if  guest
> + *		  memory could not be accessed
> + * * >0		- an access exception occurred. In this case the returned value
> + *		  is the program interruption code and the contents of pgm may
> + *		  be used to inject an exception into the guest.
> + */
> +static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> +			       unsigned long *gpas, unsigned long len,
> +			       const union asce asce, enum gacc_mode mode)
>   {
>   	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> +	unsigned int offset = offset_in_page(ga);
> +	unsigned int fragment_len;
>   	int lap_enabled, rc = 0;
>   	enum prot_type prot;
> +	unsigned long gpa;
>   
>   	lap_enabled = low_address_protection_enabled(vcpu, asce);
> -	while (nr_pages) {
> +	while (min(PAGE_SIZE - offset, len) > 0) {
> +		fragment_len = min(PAGE_SIZE - offset, len);
>   		ga = kvm_s390_logical_to_effective(vcpu, ga);
>   		if (mode == GACC_STORE && lap_enabled && is_low_address(ga))
>   			return trans_exc(vcpu, PGM_PROTECTION, ga, ar, mode,
>   					 PROT_TYPE_LA);
> -		ga &= PAGE_MASK;
>   		if (psw_bits(*psw).dat) {
> -			rc = guest_translate(vcpu, ga, pages, asce, mode, &prot);
> +			rc = guest_translate(vcpu, ga, &gpa, asce, mode, &prot);
>   			if (rc < 0)
>   				return rc;
>   		} else {
> -			*pages = kvm_s390_real_to_abs(vcpu, ga);
> -			if (kvm_is_error_gpa(vcpu->kvm, *pages))
> +			gpa = kvm_s390_real_to_abs(vcpu, ga);
> +			if (kvm_is_error_gpa(vcpu->kvm, gpa))
>   				rc = PGM_ADDRESSING;
>   		}
>   		if (rc)
>   			return trans_exc(vcpu, rc, ga, ar, mode, prot);
> -		ga += PAGE_SIZE;
> -		pages++;
> -		nr_pages--;
> +		if (gpas)
> +			*gpas++ = gpa;
> +		offset = 0;
> +		ga += fragment_len;
> +		len -= fragment_len;
>   	}
>   	return 0;
>   }
> @@ -831,10 +870,10 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>   		 unsigned long len, enum gacc_mode mode)
>   {
>   	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> -	unsigned long nr_pages, gpa, idx;
> +	unsigned long nr_pages, idx;
>   	unsigned int fragment_len;
> -	unsigned long pages_array[2];
> -	unsigned long *pages;
> +	unsigned long gpa_array[2];
> +	unsigned long *gpas;
>   	int need_ipte_lock;
>   	union asce asce;
>   	int rc;
> @@ -846,30 +885,28 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>   	if (rc)
>   		return rc;
>   	nr_pages = (((ga & ~PAGE_MASK) + len - 1) >> PAGE_SHIFT) + 1;
> -	pages = pages_array;
> -	if (nr_pages > ARRAY_SIZE(pages_array))
> -		pages = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
> -	if (!pages)
> +	gpas = gpa_array;
> +	if (nr_pages > ARRAY_SIZE(gpa_array))
> +		gpas = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
> +	if (!gpas)
>   		return -ENOMEM;
>   	need_ipte_lock = psw_bits(*psw).dat && !asce.r;
>   	if (need_ipte_lock)
>   		ipte_lock(vcpu);
> -	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
> +	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
>   	for (idx = 0; idx < nr_pages && !rc; idx++) {
> -		gpa = pages[idx] + offset_in_page(ga);
> -		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
> +		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
>   		if (mode == GACC_STORE)
> -			rc = kvm_write_guest(vcpu->kvm, gpa, data, fragment_len);
> +			rc = kvm_write_guest(vcpu->kvm, gpas[idx], data, fragment_len);
>   		else
> -			rc = kvm_read_guest(vcpu->kvm, gpa, data, fragment_len);
> +			rc = kvm_read_guest(vcpu->kvm, gpas[idx], data, fragment_len);
>   		len -= fragment_len;
> -		ga += fragment_len;
>   		data += fragment_len;
>   	}
>   	if (need_ipte_lock)
>   		ipte_unlock(vcpu);
> -	if (nr_pages > ARRAY_SIZE(pages_array))
> -		vfree(pages);
> +	if (nr_pages > ARRAY_SIZE(gpa_array))
> +		vfree(gpas);
>   	return rc;
>   }
>   
> @@ -911,8 +948,6 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>   int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>   			    unsigned long *gpa, enum gacc_mode mode)
>   {
> -	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> -	enum prot_type prot;
>   	union asce asce;
>   	int rc;
>   
> @@ -920,23 +955,7 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>   	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
>   	if (rc)
>   		return rc;
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
>   }
>   
>   /**
> @@ -950,17 +969,14 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>   int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>   		    unsigned long length, enum gacc_mode mode)
>   {
> -	unsigned long gpa;
> -	unsigned long currlen;
> +	union asce asce;
>   	int rc = 0;
>   
> +	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
> +	if (rc)
> +		return rc;
>   	ipte_lock(vcpu);
> -	while (length > 0 && !rc) {
> -		currlen = min(length, PAGE_SIZE - (gva % PAGE_SIZE));
> -		rc = guest_translate_address(vcpu, gva, ar, &gpa, mode);
> -		gva += currlen;
> -		length -= currlen;
> -	}
> +	rc = guest_range_to_gpas(vcpu, gva, ar, NULL, length, asce, mode);
>   	ipte_unlock(vcpu);
>   
>   	return rc;
> 

