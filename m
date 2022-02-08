Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C829E4AD676
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 12:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiBHLZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 06:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiBHJts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 04:49:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8685AC03FEC0;
        Tue,  8 Feb 2022 01:49:47 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2188t2TA015903;
        Tue, 8 Feb 2022 09:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cGqfdZdFG3v555YcIcqixPUI/qiCGICPivDNypU4S84=;
 b=bZI/bnRRjlAtbjs/TvsnLrJQFHzuP52rt4wZNJya+AqQvUHpnu1JNCUQDx9MksypuOoq
 XS/Ei5pizwF+KoSUwLkK6qboiSgq/46hWxzguBuWfot+3H115dRl/Nm6xCOn/qEXdU2w
 53HpwrS4nLAIgrg/rf4dVEHcDYZVVzjhBzY5KsLeYb0hGGgj+DU+kYCBitx1bjrfMkn0
 vvjFy57KVI17xDV77i0KiZ1aYOAsWWAa0gw+Hz7RTo5aQAAb8B55rVN/qKTljWLrnwym
 N0Dnf6jYhKif9oTqfB72TD1OOh3rR66o285NxjrT9DG+oFv5QXdbSD+B29AVhsNkDQ// lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3e1thn9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 09:49:46 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2188d7a0010584;
        Tue, 8 Feb 2022 09:49:46 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3e1thn90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 09:49:46 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2189j2a9019761;
        Tue, 8 Feb 2022 09:49:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3e1ggj38df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 09:49:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2189neh246399924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 09:49:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B979A42041;
        Tue,  8 Feb 2022 09:49:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B44642049;
        Tue,  8 Feb 2022 09:49:40 +0000 (GMT)
Received: from [9.145.150.231] (unknown [9.145.150.231])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 09:49:39 +0000 (GMT)
Message-ID: <547db2d5-c7ec-5ea5-4c47-d05f8e8205de@linux.ibm.com>
Date:   Tue, 8 Feb 2022 10:49:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 11/11] KVM: s390: Update api documentation for memop
 ioctl
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
 <20220207165930.1608621-12-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220207165930.1608621-12-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LbFei_4M4IDDOh2l2PqbYMWKTP1_I00W
X-Proofpoint-ORIG-GUID: -xubOHISQIi-dq3nBlrUlhh5rd7NFz7r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_02,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=831 lowpriorityscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/22 17:59, Janis Schoetterl-Glausch wrote:
> Document all currently existing operations, flags and explain under
> which circumstances they are available. Document the recently
> introduced absolute operations and the storage key protection flag,
> as well as the existing SIDA operations.

We're missing the reference to KVM_CAP_S390_PROTECTED which also 
indicates the SIDA ops.

Apart from that this looks good so feel free to send an updated version 
of this patch in reply to this mail. No need for a full set of patches 
as most of the other patches are already reviewed.

> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   Documentation/virt/kvm/api.rst | 112 ++++++++++++++++++++++++++-------
>   1 file changed, 90 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a4267104db50..7b28657fe9de 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3683,15 +3683,17 @@ The fields in each entry are defined as follows:
>   4.89 KVM_S390_MEM_OP
>   --------------------
>   
> -:Capability: KVM_CAP_S390_MEM_OP
> +:Capability: KVM_CAP_S390_MEM_OP, KVM_CAP_S390_MEM_OP_EXTENSION
>   :Architectures: s390
> -:Type: vcpu ioctl
> +:Type: vm ioctl, vcpu ioctl
>   :Parameters: struct kvm_s390_mem_op (in)
>   :Returns: = 0 on success,
>             < 0 on generic error (e.g. -EFAULT or -ENOMEM),
>             > 0 if an exception occurred while walking the page tables
>   
> -Read or write data from/to the logical (virtual) memory of a VCPU.
> +Read or write data from/to the VM's memory.
> +The KVM_CAP_S390_MEM_OP_EXTENSION capability specifies what functionality is
> +supported.
>   
>   Parameters are specified via the following structure::
>   
> @@ -3701,33 +3703,99 @@ Parameters are specified via the following structure::
>   	__u32 size;		/* amount of bytes */
>   	__u32 op;		/* type of operation */
>   	__u64 buf;		/* buffer in userspace */
> -	__u8 ar;		/* the access register number */
> -	__u8 reserved[31];	/* should be set to 0 */
> +	union {
> +		struct {
> +			__u8 ar;	/* the access register number */
> +			__u8 key;	/* access key to use for storage key protection */
> +		};
> +		__u32 sida_offset; /* offset into the sida */
> +		__u8 reserved[32]; /* must be set to 0 */
> +	};
>     };
>   
> -The type of operation is specified in the "op" field. It is either
> -KVM_S390_MEMOP_LOGICAL_READ for reading from logical memory space or
> -KVM_S390_MEMOP_LOGICAL_WRITE for writing to logical memory space. The
> -KVM_S390_MEMOP_F_CHECK_ONLY flag can be set in the "flags" field to check
> -whether the corresponding memory access would create an access exception
> -(without touching the data in the memory at the destination). In case an
> -access exception occurred while walking the MMU tables of the guest, the
> -ioctl returns a positive error number to indicate the type of exception.
> -This exception is also raised directly at the corresponding VCPU if the
> -flag KVM_S390_MEMOP_F_INJECT_EXCEPTION is set in the "flags" field.
> -
>   The start address of the memory region has to be specified in the "gaddr"
>   field, and the length of the region in the "size" field (which must not
>   be 0). The maximum value for "size" can be obtained by checking the
>   KVM_CAP_S390_MEM_OP capability. "buf" is the buffer supplied by the
>   userspace application where the read data should be written to for
> -KVM_S390_MEMOP_LOGICAL_READ, or where the data that should be written is
> -stored for a KVM_S390_MEMOP_LOGICAL_WRITE. When KVM_S390_MEMOP_F_CHECK_ONLY
> -is specified, "buf" is unused and can be NULL. "ar" designates the access
> -register number to be used; the valid range is 0..15.
> +a read access, or where the data that should be written is stored for
> +a write access.  The "reserved" field is meant for future extensions.
> +Reserved and unused bytes must be set to 0. If any of the following are used,
> +this is enforced and -EINVAL will be returned:
> +``KVM_S390_MEMOP_ABSOLUTE_READ/WRITE``, ``KVM_S390_MEMOP_F_SKEY_PROTECTION``.
> +
> +The type of operation is specified in the "op" field. Flags modifying
> +their behavior can be set in the "flags" field. Undefined flag bits must
> +be set to 0.
> +
> +Possible operations are:
> +  * ``KVM_S390_MEMOP_LOGICAL_READ``
> +  * ``KVM_S390_MEMOP_LOGICAL_WRITE``
> +  * ``KVM_S390_MEMOP_ABSOLUTE_READ``
> +  * ``KVM_S390_MEMOP_ABSOLUTE_WRITE``
> +  * ``KVM_S390_MEMOP_SIDA_READ``
> +  * ``KVM_S390_MEMOP_SIDA_WRITE``
> +
> +Logical read/write:
> +^^^^^^^^^^^^^^^^^^^
> +
> +Access logical memory, i.e. translate the given guest address to an absolute
> +address given the state of the VCPU and use the absolute address as target of
> +the access. "ar" designates the access register number to be used; the valid
> +range is 0..15.
> +Logical accesses are permitted for the VCPU ioctl only.
> +Logical accesses are permitted for non secure guests only.
> +
> +Supported flags:
> +  * ``KVM_S390_MEMOP_F_CHECK_ONLY``
> +  * ``KVM_S390_MEMOP_F_INJECT_EXCEPTION``
> +  * ``KVM_S390_MEMOP_F_SKEY_PROTECTION``
> +
> +The KVM_S390_MEMOP_F_CHECK_ONLY flag can be set to check whether the
> +corresponding memory access would cause an access exception, without touching
> +the data in memory at the destination.
> +In this case, "buf" is unused and can be NULL.
> +
> +In case an access exception occurred during the access (or would occur
> +in case of KVM_S390_MEMOP_F_CHECK_ONLY), the ioctl returns a positive
> +error number indicating the type of exception. This exception is also
> +raised directly at the corresponding VCPU if the flag
> +KVM_S390_MEMOP_F_INJECT_EXCEPTION is set.
> +
> +If the KVM_S390_MEMOP_F_SKEY_PROTECTION flag is set, storage key
> +protection is also in effect and may cause exceptions if accesses are
> +prohibited given the access key passed in "key".
> +KVM_S390_MEMOP_F_SKEY_PROTECTION is available if KVM_CAP_S390_MEM_OP_EXTENSION
> +is > 0.
> +
> +Absolute read/write:
> +^^^^^^^^^^^^^^^^^^^^
> +
> +Access absolute memory. This operation is intended to be used with the
> +KVM_S390_MEMOP_F_SKEY_PROTECTION flag, to allow accessing memory and performing
> +the checks required for storage key protection as one operation (as opposed to
> +user space getting the storage keys, performing the checks, and accessing
> +memory thereafter, which could lead to a delay between check and access).
> +Absolute accesses are permitted for the VM ioctl if KVM_CAP_S390_MEM_OP_EXTENSION
> +is > 0.
> +Currently absolute accesses are not permitted for VCPU ioctls.
> +Absolute accesses are permitted for non secure guests only.
> +
> +Supported flags:
> +  * ``KVM_S390_MEMOP_F_CHECK_ONLY``
> +  * ``KVM_S390_MEMOP_F_SKEY_PROTECTION``
> +
> +The semantics of the flags are as for logical accesses.
> +
> +SIDA read/write:
> +^^^^^^^^^^^^^^^^
> +
> +Access the secure instruction data area which contains memory operands necessary
> +for instruction emulation for secure guests.
> +SIDA accesses are permitted for the VCPU ioctl only.
> +SIDA accesses are permitted for secure guests only.
>   
> -The "reserved" field is meant for future extensions. It is not used by
> -KVM with the currently defined set of flags.
> +No flags are supported.
>   
>   4.90 KVM_S390_GET_SKEYS
>   -----------------------

