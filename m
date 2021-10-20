Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302804344C8
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 07:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhJTFp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 01:45:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64614 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhJTFpz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 01:45:55 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K5frXk025946;
        Wed, 20 Oct 2021 01:43:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=LsmsjDz8ufn/9dtpdWXP879joKhLVvJtXc6M9Epow7w=;
 b=Lcc8QWU17/WnOXYwVcImfOngQ9DNbV9duAbcCggSnxroib6jvhYvxyV7hvKpUO2cI7uR
 qyf1xSTrvZqa8fHA403aii0yz12eDhe//bT3CG7ZSbeRqrJ+Y6clkOLDUxgkxfusfeFb
 cINxAWXzzvTr/VOleVcevy5lB5qtJ2N3lffwKVMaNmU5vhLHnzuUk2DOIQDXeCh5g0ot
 9e3louN7wQgdctUOB13aE1HAKqVOix9ZQR73m7WB50OYG0ert6Mdblhen+Pbl4N11tl7
 E6AHKpge3W++i6yn0S6rV2MYXLgU33mYqj3C61GGJPD5UMCvd33a4HHanyzn+Ghde3NK Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btca9s1jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 01:43:42 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19K5JpRR020935;
        Wed, 20 Oct 2021 01:43:41 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btca9s1ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 01:43:41 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19K5hS21020457;
        Wed, 20 Oct 2021 05:43:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3bqpcbpfcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 05:43:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19K5biKB38273458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 05:37:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 153D852051;
        Wed, 20 Oct 2021 05:43:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.68])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 303F652057;
        Wed, 20 Oct 2021 05:43:34 +0000 (GMT)
Date:   Wed, 20 Oct 2021 07:39:35 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: s390: preserve deliverable_mask in
 __airqs_kick_single_vcpu
Message-ID: <20211020073935.1419c1e3@p-imbrenda>
In-Reply-To: <20211019175401.3757927-3-pasic@linux.ibm.com>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
        <20211019175401.3757927-3-pasic@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d3VYEYL9EK82y__Gzo8oF7HzvskZvDIm
X-Proofpoint-ORIG-GUID: 9kNDa0CtaSUD1l-PrdSgZYnaty6lAFWL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200028
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Oct 2021 19:54:00 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> Changing the deliverable mask in __airqs_kick_single_vcpu() is a bug. If
> one idle vcpu can't take the interrupts we want to deliver, we should
> look for another vcpu that can, instead of saying that we don't want
> to deliver these interrupts by clearing the bits from the
> deliverable_mask.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/interrupt.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 10722455fd02..2245f4b8d362 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3053,13 +3053,14 @@ static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
>  	int vcpu_idx, online_vcpus = atomic_read(&kvm->online_vcpus);
>  	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
>  	struct kvm_vcpu *vcpu;
> +	u8 vcpu_isc_mask;
>  
>  	for_each_set_bit(vcpu_idx, kvm->arch.idle_mask, online_vcpus) {
>  		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
>  		if (psw_ioint_disabled(vcpu))
>  			continue;
> -		deliverable_mask &= (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
> -		if (deliverable_mask) {
> +		vcpu_isc_mask = (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
> +		if (deliverable_mask & vcpu_isc_mask) {
>  			/* lately kicked but not yet running */
>  			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
>  				return;

