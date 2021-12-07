Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135B746B704
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhLGJar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:30:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231250AbhLGJaq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 04:30:46 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B79IiPS005096;
        Tue, 7 Dec 2021 09:27:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V2Q5oxnMQx3uk57DHKUmBUi4N+cjLpm4PKacLQprv7E=;
 b=m5a2xMNzPnkPA9cFbRNqlJwrJijUmohjK3UaC254UVKiC0J49iswFD5uPnJZr6IagPF/
 fJjm96+n12U92pt9dNG4fiRPZN8i7HxabeakBgIzGQA6PRSGoazP6HI0xeF7HKN7hANx
 1REIhayQuVnki/n81240PW2UnOp7ghb+qgBvC+8NlzPma4+YM3v0O/pqrvuSXQuvTkIZ
 fl3PfpTINY0/k9jV2jVyTkjBjdsGdvSUSSQBdjoabH6GWdX8TW7NUxnIJvsZPWbCdX68
 za7Dp/OfsJTkMjRSTo3rozqqmPKhd9BB5da2O0pMdroD1Rd0quj+eAGThTtbedq63mVw qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ct4vag4c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:27:16 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B79JXNT006268;
        Tue, 7 Dec 2021 09:27:15 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ct4vag4b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:27:15 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B797xpa010660;
        Tue, 7 Dec 2021 09:27:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3cqyy9bmb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 09:27:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B79R9ac29688084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 09:27:09 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D3D2A4064;
        Tue,  7 Dec 2021 09:27:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1F32A405B;
        Tue,  7 Dec 2021 09:27:08 +0000 (GMT)
Received: from [9.145.93.53] (unknown [9.145.93.53])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 09:27:08 +0000 (GMT)
Message-ID: <c6896c31-b9db-e241-5f47-fc96fd53a2cb@linux.ibm.com>
Date:   Tue, 7 Dec 2021 10:27:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v3 0/3] KVM: s390: Some gaccess cleanup
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
References: <20211126164549.7046-1-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211126164549.7046-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kt7cm8b2ih5EJj38F1nOtP_toeUlZ0Xs
X-Proofpoint-GUID: URCbZb5jyrKevbnIeM_0QHCAx0oIilHF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/26/21 17:45, Janis Schoetterl-Glausch wrote:
> Cleanup s390 guest access code a bit, getting rid of some code
> duplication and improving readability.
> 
> v2 -> v3
> 	minor changes only
> 		typo fixes
> 		whitespace
> 		line reordering
> 		picked up Reviewed-by's
> 
> v1 -> v2
> 	separate patch for renamed variable
> 		fragment_len instead of seg
> 	expand comment of guest_range_to_gpas
> 	fix nits

Thanks, picked

> 
> Janis Schoetterl-Glausch (3):
>    KVM: s390: gaccess: Refactor gpa and length calculation
>    KVM: s390: gaccess: Refactor access address range check
>    KVM: s390: gaccess: Cleanup access to guest pages
> 
>   arch/s390/kvm/gaccess.c | 158 +++++++++++++++++++++++-----------------
>   1 file changed, 92 insertions(+), 66 deletions(-)
> 
> Range-diff against v2:
> 1:  60d050210198 ! 1:  e5d7d2d7a4da KVM: s390: gaccess: Refactor gpa and length calculation
>      @@ Metadata
>        ## Commit message ##
>           KVM: s390: gaccess: Refactor gpa and length calculation
>       
>      -    Improve readability be renaming the length variable and
>      +    Improve readability by renaming the length variable and
>           not calculating the offset manually.
>       
>           Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>      +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>       
>        ## arch/s390/kvm/gaccess.c ##
>       @@ arch/s390/kvm/gaccess.c: int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>      @@ arch/s390/kvm/gaccess.c: int access_guest(struct kvm_vcpu *vcpu, unsigned long g
>        	psw_t *psw = &vcpu->arch.sie_block->gpsw;
>       -	unsigned long _len, nr_pages, gpa, idx;
>       +	unsigned long nr_pages, gpa, idx;
>      -+	unsigned int fragment_len;
>        	unsigned long pages_array[2];
>      ++	unsigned int fragment_len;
>        	unsigned long *pages;
>        	int need_ipte_lock;
>      + 	union asce asce;
>       @@ arch/s390/kvm/gaccess.c: int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>        		ipte_lock(vcpu);
>        	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
> 2:  7080846c8c07 ! 2:  91cadb42cbbc KVM: s390: gaccess: Refactor access address range check
>      @@ Commit message
>           range.
>       
>           Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>      +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>       
>        ## arch/s390/kvm/gaccess.c ##
>       @@ arch/s390/kvm/gaccess.c: static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
>      @@ arch/s390/kvm/gaccess.c: static int low_address_protection_enabled(struct kvm_vc
>       + * a correct exception into the guest.
>       + * The resulting gpas are stored into @gpas, unless it is NULL.
>       + *
>      -+ * Note: All gpas except the first one start at the beginning of a page.
>      ++ * Note: All fragments except the first one start at the beginning of a page.
>       + *       When deriving the boundaries of a fragment from a gpa, all but the last
>       + *       fragment end at the end of the page.
>       + *
>      @@ arch/s390/kvm/gaccess.c: int access_guest(struct kvm_vcpu *vcpu, unsigned long g
>        {
>        	psw_t *psw = &vcpu->arch.sie_block->gpsw;
>       -	unsigned long nr_pages, gpa, idx;
>      +-	unsigned long pages_array[2];
>       +	unsigned long nr_pages, idx;
>      ++	unsigned long gpa_array[2];
>        	unsigned int fragment_len;
>      --	unsigned long pages_array[2];
>       -	unsigned long *pages;
>      -+	unsigned long gpa_array[2];
>       +	unsigned long *gpas;
>        	int need_ipte_lock;
>        	union asce asce;
> 3:  c991cbdbfbd5 ! 3:  f5000a22efcd KVM: s390: gaccess: Cleanup access to guest frames
>      @@ Metadata
>       Author: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>       
>        ## Commit message ##
>      -    KVM: s390: gaccess: Cleanup access to guest frames
>      +    KVM: s390: gaccess: Cleanup access to guest pages
>       
>           Introduce a helper function for guest frame access.
>       
>           Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>      +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>       
>        ## arch/s390/kvm/gaccess.c ##
>       @@ arch/s390/kvm/gaccess.c: static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>      @@ arch/s390/kvm/gaccess.c: static int guest_range_to_gpas(struct kvm_vcpu *vcpu, u
>        }
>        
>       +static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
>      -+			      void *data, unsigned int len)
>      ++			     void *data, unsigned int len)
>       +{
>       +	const unsigned int offset = offset_in_page(gpa);
>       +	const gfn_t gfn = gpa_to_gfn(gpa);
> 
> base-commit: d25f27432f80a800a3592db128254c8140bd71bf
> 

