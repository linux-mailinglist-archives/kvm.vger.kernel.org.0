Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E4E492539
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbiARLvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:51:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230274AbiARLvj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 06:51:39 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IBSUXq030316;
        Tue, 18 Jan 2022 11:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=I9K5XHxLDOsibcZ5rl4plOW1p+JxRz8GMdd1sVVC/r8=;
 b=SPt7cTrBliVh55gduecSqJnx5AjZn8FTfO/5/zE7bPSt94DNx0gLROpbCOipZXw5V+dA
 6XrVNqeUuedlAb7RTTZ6rO3WGhBKxJ7wKjtdcEfasa9dqhKHGP0E1fWRBRTBvmm9gvjN
 rFipqbBge7KQoyShs7414yxhFbv0pcVRHnvN/uORY4f6ovimtSRd0RkhG2uUfzhWTIJ/
 +67GozLERgS0YXcrllu/RNtaUXLZO9wzZRIgpKzI5dVkVxlDiloRg0iwo8zHnPuJE5G4
 RB0pewCmW8CXThGqtO2PGYIFGlh5z5tL1uioQN8+IHhYAJl0vGuoJv1dJ0KDOfrBBhhG Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnt4dkqjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 11:51:38 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IBoSNs007311;
        Tue, 18 Jan 2022 11:51:37 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnt4dkqjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 11:51:37 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IBmqMZ015970;
        Tue, 18 Jan 2022 11:51:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3dknw92f0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 11:51:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IBgA2I33882408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 11:42:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34A7CAE045;
        Tue, 18 Jan 2022 11:51:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE2D8AE04D;
        Tue, 18 Jan 2022 11:51:26 +0000 (GMT)
Received: from [9.171.19.84] (unknown [9.171.19.84])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 11:51:26 +0000 (GMT)
Message-ID: <2bd8dd31-0c08-a03b-33b3-67d7adc78726@linux.ibm.com>
Date:   Tue, 18 Jan 2022 12:51:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 05/10] KVM: s390: Add optional storage key checking
 to MEMOP IOCTL
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-6-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220118095210.1651483-6-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2m9v-qkGO2dcM6m5Gq5rJf8PC8IKuIKa
X-Proofpoint-GUID: nT_KZZE9z1DpFYdkyx0gDhu0rarlProb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_03,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 18.01.22 um 10:52 schrieb Janis Schoetterl-Glausch:
> User space needs a mechanism to perform key checked accesses when
> emulating instructions.
> 
> The key can be passed as an additional argument via the flags field.
> As reserved flags need to be 0, and key 0 matches all storage keys,
> by default no key checking is performed, as before.
> Having an additional argument is flexible, as user space can
> pass the guest PSW's key, in order to make an access the same way the
> CPU would, or pass another key if necessary.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 21 ++++++++++++++-------
>   include/uapi/linux/kvm.h |  1 +
>   2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 38b304e81c57..c4acdb025ff1 100644
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
> @@ -4727,9 +4728,11 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>   {
>   	void __user *uaddr = (void __user *)mop->buf;
>   	void *tmpbuf = NULL;
> +	char access_key = 0;
>   	int r = 0;
>   	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
> -				    | KVM_S390_MEMOP_F_CHECK_ONLY;
> +				    | KVM_S390_MEMOP_F_CHECK_ONLY
> +				    | KVM_S390_MEMOP_F_SKEYS_ACC;

I think it would be better to just have a flag here (single bit) to check the key and
then embed the key value in the payload.

         union {
                 __u8 ar;        /* the access register number */
                 __u32 sida_offset; /* offset into the sida */
                 __u8 reserved[32]; /* should be set to 0 */
         };

There are cases when we need both, AR and key so maybe an unname struct is the easiest.

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..e8fa1f82d472 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -562,7 +562,10 @@ struct kvm_s390_mem_op {
         __u32 op;               /* type of operation */
         __u64 buf;              /* buffer in userspace */
         union {
-               __u8 ar;        /* the access register number */
+               struct {
+                       __u8 ar;        /* the access register number */
+                       __u8 key;       /* effective storage key */
+               };
                 __u32 sida_offset; /* offset into the sida */
                 __u8 reserved[32]; /* should be set to 0 */
         };

(or acc instead of key)


>   
>   	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
>   		return -EINVAL;
> @@ -4746,14 +4749,17 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>   			return -ENOMEM;
>   	}
>   
> +	access_key = FIELD_GET(KVM_S390_MEMOP_F_SKEYS_ACC, mop->flags);
> +
>   	switch (mop->op) {
>   	case KVM_S390_MEMOP_LOGICAL_READ:
>   		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
> -			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
> -					    mop->size, GACC_FETCH, 0);
> +			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
> +					    GACC_FETCH, access_key);
>   			break;
>   		}
> -		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
> +		r = read_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
> +					mop->size, access_key);
>   		if (r == 0) {
>   			if (copy_to_user(uaddr, tmpbuf, mop->size))
>   				r = -EFAULT;
> @@ -4761,15 +4767,16 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>   		break;
>   	case KVM_S390_MEMOP_LOGICAL_WRITE:
>   		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
> -			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
> -					    mop->size, GACC_STORE, 0);
> +			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
> +					    GACC_STORE, access_key);
>   			break;
>   		}
>   		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
>   			r = -EFAULT;
>   			break;
>   		}
> -		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
> +		r = write_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
> +					 mop->size, access_key);
>   		break;
>   	}
>   
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 1daa45268de2..e3f450b2f346 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -575,6 +575,7 @@ struct kvm_s390_mem_op {
>   /* flags for kvm_s390_mem_op->flags */
>   #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
>   #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
> +#define KVM_S390_MEMOP_F_SKEYS_ACC		0x0f00ULL
>   
>   /* for KVM_INTERRUPT */
>   struct kvm_interrupt {
