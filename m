Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD5D52A172
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 14:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346079AbiEQM0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 08:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241282AbiEQMZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 08:25:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F36CAE51;
        Tue, 17 May 2022 05:25:51 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBgX2R032681;
        Tue, 17 May 2022 12:25:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=R1tKSxZl9gqfSFrD213WYHRgCG+ZGkINoOHaj/GHjCU=;
 b=epzHAacwmyfsTBr/rJIx+L9el1wHSG173ubvrg2a8JbefsfPrd/mLxuZBCTdXsvbtKxt
 KOFOMtlmzB94WpMlXrhX+P3ZlTCpQ1lInpM7o06s6IJBIF/93BChwtaYTZp8scEzch5Q
 jeTo/XAkaG9LUazZf8Xa+4VxQN0om7YNo25APm5CASBLDBge4V4aGISUh2fxWwEDNpOt
 tzs2drCEKsa4CABw0CivreqjmyPeDiiTOYvzDp67jTb+Pc6qWtUvxu7DmPjSHVt8dcT3
 GeHEgFTU49/x5RYWGKR0c7aHP5FBElrFLbljoEE0Lxk/IMX03yWPSvxSRhtPTEKXAiiM YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4b2h8y38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 12:25:51 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HBi0ND007147;
        Tue, 17 May 2022 12:25:50 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4b2h8y27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 12:25:50 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HCNJ6c015395;
        Tue, 17 May 2022 12:25:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3g2428ubga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 12:25:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HCPiJL47907214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 12:25:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 858D052050;
        Tue, 17 May 2022 12:25:44 +0000 (GMT)
Received: from [9.171.49.46] (unknown [9.171.49.46])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E1DE75204E;
        Tue, 17 May 2022 12:25:43 +0000 (GMT)
Message-ID: <55c5780a-de9c-a4d3-8c77-691242085076@linux.ibm.com>
Date:   Tue, 17 May 2022 14:25:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 1/2] KVM: s390: Don't indicate suppression on dirtying,
 failing memop
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220512131019.2594948-1-scgl@linux.ibm.com>
 <20220512131019.2594948-2-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220512131019.2594948-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: c0mFL0rtz00ZoG-niShLrUldbLBgntha
X-Proofpoint-ORIG-GUID: gYW-wVEJRJZf68u3J8LhJMBkQh3u4aeI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170073
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 12.05.22 um 15:10 schrieb Janis Schoetterl-Glausch:
> If user space uses a memop to emulate an instruction and that
> memop fails, the execution of the instruction ends.
> Instruction execution can end in different ways, one of which is
> suppression, which requires that the instruction execute like a no-op.
> A writing memop that spans multiple pages and fails due to key
> protection may have modified guest memory, as a result, the likely
> correct ending is termination. Therefore, do not indicate a
> suppressing instruction ending in this case.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   Documentation/virt/kvm/api.rst |  6 ++++++
>   arch/s390/kvm/gaccess.c        | 22 ++++++++++++++++++----
>   2 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 4a900cdbc62e..b6aba4f50db7 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3754,12 +3754,18 @@ in case of KVM_S390_MEMOP_F_CHECK_ONLY), the ioctl returns a positive
>   error number indicating the type of exception. This exception is also
>   raised directly at the corresponding VCPU if the flag
>   KVM_S390_MEMOP_F_INJECT_EXCEPTION is set.
> +On protection exceptions, unless specified otherwise, the injected
> +translation-exception identifier (TEID) indicates suppression.
>   
>   If the KVM_S390_MEMOP_F_SKEY_PROTECTION flag is set, storage key
>   protection is also in effect and may cause exceptions if accesses are
>   prohibited given the access key designated by "key"; the valid range is 0..15.
>   KVM_S390_MEMOP_F_SKEY_PROTECTION is available if KVM_CAP_S390_MEM_OP_EXTENSION
>   is > 0.
> +Since the accessed memory may span multiple pages and those pages might have
> +different storage keys, it is possible that a protection exception occurs
> +after memory has been modified. In this case, if the exception is injected,
> +the TEID does not indicate suppression.
>   
>   Absolute read/write:
>   ^^^^^^^^^^^^^^^^^^^^
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index d53a183c2005..227ed0009354 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -491,8 +491,8 @@ enum prot_type {
>   	PROT_TYPE_IEP  = 4,
>   };
>   
> -static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva,
> -		     u8 ar, enum gacc_mode mode, enum prot_type prot)
> +static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> +			    enum gacc_mode mode, enum prot_type prot, bool terminate)
>   {
>   	struct kvm_s390_pgm_info *pgm = &vcpu->arch.pgm;
>   	struct trans_exc_code_bits *tec;
> @@ -520,6 +520,11 @@ static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva,
>   			tec->b61 = 1;
>   			break;
>   		}
> +		if (terminate) {
> +			tec->b56 = 0;
> +			tec->b60 = 0;
> +			tec->b61 = 0;
> +		}
>   		fallthrough;
>   	case PGM_ASCE_TYPE:
>   	case PGM_PAGE_TRANSLATION:
> @@ -552,6 +557,12 @@ static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva,
>   	return code;
>   }
>   
> +static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> +		     enum gacc_mode mode, enum prot_type prot)
> +{
> +	return trans_exc_ending(vcpu, code, gva, ar, mode, prot, false);
> +}
> +
>   static int get_vcpu_asce(struct kvm_vcpu *vcpu, union asce *asce,
>   			 unsigned long ga, u8 ar, enum gacc_mode mode)
>   {
> @@ -1109,8 +1120,11 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>   		data += fragment_len;
>   		ga = kvm_s390_logical_to_effective(vcpu, ga + fragment_len);
>   	}
> -	if (rc > 0)
> -		rc = trans_exc(vcpu, rc, ga, ar, mode, prot);
> +	if (rc > 0) {
> +		bool terminate = (mode == GACC_STORE) && (idx > 0);
> +
> +		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
> +	}
>   out_unlock:
>   	if (need_ipte_lock)
>   		ipte_unlock(vcpu);
