Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B37C4B5E8B
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbiBOAAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:00:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiBOAAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:00:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743A641984;
        Mon, 14 Feb 2022 16:00:26 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EN10KB007645;
        Tue, 15 Feb 2022 00:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=C9lgz9nUygy/WNSTFeeSPkV509FapWhd0eHU3azbyjQ=;
 b=V6jz00dlAfuHvlIEDEDdZ47RlqbFWWqYXihuemO13+2W7TEhkZ0I3+EeovzPhCwu9eog
 +pi3UdbixsAHlawfet+t6L/F0dz9xLWvm7qUGVVHb66YGaOSkavJbdAfIm9qYWVNuxmh
 H0frEzi1AjBYfLYqDl0zVpq9D7OWeuaLsr0/Qul8IOusWtlcMyxmPIYr/xYLnloLM3Jj
 5fwFA7q9iGDmskbnaTyMX5CUFrIYlFRfLkk0tl5dLGkswaoxlmQQmu+hCzqosxwvbaPz
 YX6Nb1uUPtkbAAHct0ppFXk9l0PPM3s+k7mmLw6My0dey5I3TVyOY7t3FdKVkHX/AiYq bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7dej3p5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:00:26 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21ENSUJm025655;
        Tue, 15 Feb 2022 00:00:25 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7dej3p4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:00:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21ENwAlr005177;
        Tue, 15 Feb 2022 00:00:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645jhxjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:00:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F00I5834537732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:00:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 529DFA4059;
        Tue, 15 Feb 2022 00:00:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6342A404D;
        Tue, 15 Feb 2022 00:00:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:00:17 +0000 (GMT)
Date:   Mon, 14 Feb 2022 18:58:49 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v4 06/10] KVM: s390: Add vm IOCTL for key checked guest
 absolute memory access
Message-ID: <20220214185849.04331079@p-imbrenda>
In-Reply-To: <20220211182215.2730017-7-scgl@linux.ibm.com>
References: <20220211182215.2730017-1-scgl@linux.ibm.com>
        <20220211182215.2730017-7-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AJzA_gdQpFX90Dp5U0j_pYyepd_AzmFC
X-Proofpoint-ORIG-GUID: toTycKR9roIP9nv0G3g-D8HnUz0prpH0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202140134
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Feb 2022 19:22:11 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Channel I/O honors storage keys and is performed on absolute memory.
> For I/O emulation user space therefore needs to be able to do key
> checked accesses.
> The vm IOCTL supports read/write accesses, as well as checking
> if an access would succeed.
> Unlike relying on KVM_S390_GET_SKEYS for key checking would,
> the vm IOCTL performs the check in lockstep with the read or write,
> by, ultimately, mapping the access to move instructions that
> support key protection checking with a supplied key.
> Fetch and storage protection override are not applicable to absolute
> accesses and so are not applied as they are when using the vcpu memop.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/gaccess.c  | 72 +++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/gaccess.h  |  6 +++
>  arch/s390/kvm/kvm-s390.c | 81 ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h |  2 +
>  4 files changed, 161 insertions(+)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 37838f637707..d53a183c2005 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -795,6 +795,35 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
>  	return 1;
>  }
>  
> +static int vm_check_access_key(struct kvm *kvm, u8 access_key,
> +			       enum gacc_mode mode, gpa_t gpa)
> +{
> +	u8 storage_key, access_control;
> +	bool fetch_protected;
> +	unsigned long hva;
> +	int r;
> +
> +	if (access_key == 0)
> +		return 0;
> +
> +	hva = gfn_to_hva(kvm, gpa_to_gfn(gpa));
> +	if (kvm_is_error_hva(hva))
> +		return PGM_ADDRESSING;
> +
> +	mmap_read_lock(current->mm);
> +	r = get_guest_storage_key(current->mm, hva, &storage_key);
> +	mmap_read_unlock(current->mm);
> +	if (r)
> +		return r;
> +	access_control = FIELD_GET(_PAGE_ACC_BITS, storage_key);
> +	if (access_control == access_key)
> +		return 0;
> +	fetch_protected = storage_key & _PAGE_FP_BIT;
> +	if ((mode == GACC_FETCH || mode == GACC_IFETCH) && !fetch_protected)
> +		return 0;
> +	return PGM_PROTECTION;
> +}
> +
>  static bool fetch_prot_override_applicable(struct kvm_vcpu *vcpu, enum gacc_mode mode,
>  					   union asce asce)
>  {
> @@ -994,6 +1023,26 @@ access_guest_page_with_key(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
>  	return 0;
>  }
>  
> +int access_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, void *data,
> +			      unsigned long len, enum gacc_mode mode, u8 access_key)
> +{
> +	int offset = offset_in_page(gpa);
> +	int fragment_len;
> +	int rc;
> +
> +	while (min(PAGE_SIZE - offset, len) > 0) {
> +		fragment_len = min(PAGE_SIZE - offset, len);
> +		rc = access_guest_page_with_key(kvm, mode, gpa, data, fragment_len, access_key);
> +		if (rc)
> +			return rc;
> +		offset = 0;
> +		len -= fragment_len;
> +		data += fragment_len;
> +		gpa += fragment_len;
> +	}
> +	return 0;
> +}
> +
>  int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  			  void *data, unsigned long len, enum gacc_mode mode,
>  			  u8 access_key)
> @@ -1144,6 +1193,29 @@ int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>  	return rc;
>  }
>  
> +/**
> + * check_gpa_range - test a range of guest physical addresses for accessibility
> + * @kvm: virtual machine instance
> + * @gpa: guest physical address
> + * @length: length of test range
> + * @mode: access mode to test, relevant for storage keys
> + * @access_key: access key to mach the storage keys with
> + */
> +int check_gpa_range(struct kvm *kvm, unsigned long gpa, unsigned long length,
> +		    enum gacc_mode mode, u8 access_key)
> +{
> +	unsigned int fragment_len;
> +	int rc = 0;
> +
> +	while (length && !rc) {
> +		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), length);
> +		rc = vm_check_access_key(kvm, access_key, mode, gpa);
> +		length -= fragment_len;
> +		gpa += fragment_len;
> +	}
> +	return rc;
> +}
> +
>  /**
>   * kvm_s390_check_low_addr_prot_real - check for low-address protection
>   * @vcpu: virtual cpu
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index c5f2e7311b17..1124ff282012 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -193,6 +193,12 @@ int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u
>  int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>  		    unsigned long length, enum gacc_mode mode, u8 access_key);
>  
> +int check_gpa_range(struct kvm *kvm, unsigned long gpa, unsigned long length,
> +		    enum gacc_mode mode, u8 access_key);
> +
> +int access_guest_abs_with_key(struct kvm *kvm, gpa_t gpa, void *data,
> +			      unsigned long len, enum gacc_mode mode, u8 access_key);
> +
>  int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  			  void *data, unsigned long len, enum gacc_mode mode,
>  			  u8 access_key);
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index c31b40abfa23..36bc73b5f5de 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2364,6 +2364,78 @@ static bool access_key_invalid(u8 access_key)
>  	return access_key > 0xf;
>  }
>  
> +static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
> +{
> +	void __user *uaddr = (void __user *)mop->buf;
> +	u64 supported_flags;
> +	void *tmpbuf = NULL;
> +	int r, srcu_idx;
> +
> +	supported_flags = KVM_S390_MEMOP_F_SKEY_PROTECTION
> +			  | KVM_S390_MEMOP_F_CHECK_ONLY;
> +	if (mop->flags & ~supported_flags)
> +		return -EINVAL;
> +	if (mop->size > MEM_OP_MAX_SIZE)
> +		return -E2BIG;
> +	if (kvm_s390_pv_is_protected(kvm))
> +		return -EINVAL;
> +	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
> +		if (access_key_invalid(mop->key))
> +			return -EINVAL;
> +	} else {
> +		mop->key = 0;
> +	}
> +	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
> +		tmpbuf = vmalloc(mop->size);
> +		if (!tmpbuf)
> +			return -ENOMEM;
> +	}
> +
> +	srcu_idx = srcu_read_lock(&kvm->srcu);
> +
> +	if (kvm_is_error_gpa(kvm, mop->gaddr)) {
> +		r = PGM_ADDRESSING;
> +		goto out_unlock;
> +	}
> +
> +	switch (mop->op) {
> +	case KVM_S390_MEMOP_ABSOLUTE_READ: {
> +		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
> +			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_FETCH, mop->key);
> +		} else {
> +			r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
> +						      mop->size, GACC_FETCH, mop->key);
> +			if (r == 0) {
> +				if (copy_to_user(uaddr, tmpbuf, mop->size))
> +					r = -EFAULT;
> +			}
> +		}
> +		break;
> +	}
> +	case KVM_S390_MEMOP_ABSOLUTE_WRITE: {
> +		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
> +			r = check_gpa_range(kvm, mop->gaddr, mop->size, GACC_STORE, mop->key);
> +		} else {
> +			if (copy_from_user(tmpbuf, uaddr, mop->size)) {
> +				r = -EFAULT;
> +				break;
> +			}
> +			r = access_guest_abs_with_key(kvm, mop->gaddr, tmpbuf,
> +						      mop->size, GACC_STORE, mop->key);
> +		}
> +		break;
> +	}
> +	default:
> +		r = -EINVAL;
> +	}
> +
> +out_unlock:
> +	srcu_read_unlock(&kvm->srcu, srcu_idx);
> +
> +	vfree(tmpbuf);
> +	return r;
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> @@ -2488,6 +2560,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		}
>  		break;
>  	}
> +	case KVM_S390_MEM_OP: {
> +		struct kvm_s390_mem_op mem_op;
> +
> +		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) == 0)
> +			r = kvm_s390_vm_mem_op(kvm, &mem_op);
> +		else
> +			r = -EFAULT;
> +		break;
> +	}
>  	default:
>  		r = -ENOTTY;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4566f429db2c..4bc7623def87 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -575,6 +575,8 @@ struct kvm_s390_mem_op {
>  #define KVM_S390_MEMOP_LOGICAL_WRITE	1
>  #define KVM_S390_MEMOP_SIDA_READ	2
>  #define KVM_S390_MEMOP_SIDA_WRITE	3
> +#define KVM_S390_MEMOP_ABSOLUTE_READ	4
> +#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
>  /* flags for kvm_s390_mem_op->flags */
>  #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
>  #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)

