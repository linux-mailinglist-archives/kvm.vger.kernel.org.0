Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB1D4AEB24
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 08:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbiBIHfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 02:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbiBIHe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 02:34:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9411CC0613CB;
        Tue,  8 Feb 2022 23:34:59 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2193w1a5022063;
        Wed, 9 Feb 2022 07:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Cb1L+DqHS9HWMzhnhSRYvz5l+d1Nxiaa1BkcVyOVlEc=;
 b=emKRJedHt1zWQ1lrNYkDXCx0FY8WL+vlUUjmEQ0TtUpHQ6CC3W4AQx3bj43CL7b4rm7r
 OPaj2jcY9HpoThhzqvUwrrKqGlbdW+zyscEYfpXBBuWOCOBbMUdf8EcquMofPfN7r6YG
 22JPfN1Fyir0+7YzKry4/FprqKZhihBEoq3lKCEQm3ct9MdM+z0uWUpCkF73Vkr8Him9
 QdGOzAR08aUYWjiSlrsRkyVD30Tq9zpwfn38V5T02mhQzKZKcDQDEPF0ntm8iS0p0kS7
 hvZVnEcwwWDFTW0Twp88XFGAgxh8NhglaCMMY1xbeOR4fyLLGEJnRDCctUpgYjsLhP3w Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e465wcmrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 07:34:57 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2197RBma031994;
        Wed, 9 Feb 2022 07:34:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e465wcmr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 07:34:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2197D4uF013203;
        Wed, 9 Feb 2022 07:34:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gv9c9fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 07:34:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2197Ynhu27984132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 07:34:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EB4E4C046;
        Wed,  9 Feb 2022 07:34:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 826194C05A;
        Wed,  9 Feb 2022 07:34:48 +0000 (GMT)
Received: from [9.171.87.52] (unknown [9.171.87.52])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 07:34:48 +0000 (GMT)
Message-ID: <48d1678f-746c-dab6-5ec3-56397277f752@linux.ibm.com>
Date:   Wed, 9 Feb 2022 08:34:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 05/11] KVM: s390: Add optional storage key checking to
 MEMOP IOCTL
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
 <20220207165930.1608621-6-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220207165930.1608621-6-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ud7NGynxqx2BwVmLnsC9nskIYKB9GfF9
X-Proofpoint-GUID: XYa-efA6jbvwh8heDmEwNHzxKaCqZEj9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 07.02.22 um 17:59 schrieb Janis Schoetterl-Glausch:
> User space needs a mechanism to perform key checked accesses when
> emulating instructions.
> 
> The key can be passed as an additional argument.
> Having an additional argument is flexible, as user space can
> pass the guest PSW's key, in order to make an access the same way the
> CPU would, or pass another key if necessary.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 49 +++++++++++++++++++++++++++++++---------
>   include/uapi/linux/kvm.h |  8 +++++--
>   2 files changed, 44 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index cf347e1a4f17..71e61fb3f0d9 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -32,6 +32,7 @@
>   #include <linux/sched/signal.h>
>   #include <linux/string.h>
>   #include <linux/pgtable.h>
> +#include <linux/bitfield.h>
>   
>   #include <asm/asm-offsets.h>
>   #include <asm/lowcore.h>
> @@ -2359,6 +2360,11 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>   	return r;
>   }
>   
> +static bool access_key_invalid(u8 access_key)
> +{
> +	return access_key > 0xf;
> +}
> +
>   long kvm_arch_vm_ioctl(struct file *filp,
>   		       unsigned int ioctl, unsigned long arg)
>   {
> @@ -4687,34 +4693,54 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>   				  struct kvm_s390_mem_op *mop)
>   {
>   	void __user *uaddr = (void __user *)mop->buf;
> +	u8 access_key = 0, ar = 0;
>   	void *tmpbuf = NULL;
> +	bool check_reserved;
>   	int r = 0;
>   	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
> -				    | KVM_S390_MEMOP_F_CHECK_ONLY;
> +				    | KVM_S390_MEMOP_F_CHECK_ONLY
> +				    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
>   
> -	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
> +	if (mop->flags & ~supported_flags || !mop->size)
>   		return -EINVAL;
> -
>   	if (mop->size > MEM_OP_MAX_SIZE)
>   		return -E2BIG;
> -
>   	if (kvm_s390_pv_cpu_is_protected(vcpu))
>   		return -EINVAL;
> -
>   	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
>   		tmpbuf = vmalloc(mop->size);
>   		if (!tmpbuf)
>   			return -ENOMEM;
>   	}
> +	ar = mop->ar;
> +	mop->ar = 0;

Why this assignment to 0?

> +	if (ar >= NUM_ACRS)
> +		return -EINVAL;
> +	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
> +		access_key = mop->key;
> +		mop->key = 0;

and this? I think we can leave mop unchanged.

In fact, why do we add the ar and access_key variable?
This breaks the check from above (if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size))  into two checks
and it will create a memleak for tmpbuf.

Simply use mop->key and mop->ar below and get rid of the local variables.
The structure has no concurrency and gcc will handle that just as the local variable.

Other than that this looks good.
> +		if (access_key_invalid(access_key))
> +			return -EINVAL;
> +	}
> +	/*
> +	 * Check that reserved/unused == 0, but only for extensions,
> +	 * so we stay backward compatible.
> +	 * This gives us more design flexibility for future extensions, i.e.
> +	 * we can add functionality without adding a flag.
> +	 */
> +	check_reserved = mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION;
> +	if (check_reserved && memchr_inv(&mop->reserved, 0, sizeof(mop->reserved)))
> +		return -EINVAL;
>   
>   	switch (mop->op) {
>   	case KVM_S390_MEMOP_LOGICAL_READ:
>   		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
> -			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
> -					    mop->size, GACC_FETCH, 0);
> +			r = check_gva_range(vcpu, mop->gaddr, ar, mop->size,
> +					    GACC_FETCH, access_key);
>   			break;
>   		}
> -		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
> +		r = read_guest_with_key(vcpu, mop->gaddr, ar, tmpbuf,
> +					mop->size, access_key);
>   		if (r == 0) {
>   			if (copy_to_user(uaddr, tmpbuf, mop->size))
>   				r = -EFAULT;
> @@ -4722,15 +4748,16 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>   		break;
>   	case KVM_S390_MEMOP_LOGICAL_WRITE:
>   		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
> -			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
> -					    mop->size, GACC_STORE, 0);
> +			r = check_gva_range(vcpu, mop->gaddr, ar, mop->size,
> +					    GACC_STORE, access_key);
>   			break;
>   		}
>   		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
>   			r = -EFAULT;
>   			break;
>   		}
> -		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
> +		r = write_guest_with_key(vcpu, mop->gaddr, ar, tmpbuf,
> +					 mop->size, access_key);
>   		break;
>   	}
>   
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b46bcdb0cab1..5771b026fbc0 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -562,9 +562,12 @@ struct kvm_s390_mem_op {
>   	__u32 op;		/* type of operation */
>   	__u64 buf;		/* buffer in userspace */
>   	union {
> -		__u8 ar;	/* the access register number */
> +		struct {
> +			__u8 ar;	/* the access register number */
> +			__u8 key;	/* access key to use for storage key protection */
> +		};
>   		__u32 sida_offset; /* offset into the sida */
> -		__u8 reserved[32]; /* should be set to 0 */
> +		__u8 reserved[32]; /* must be set to 0 */
>   	};
>   };
