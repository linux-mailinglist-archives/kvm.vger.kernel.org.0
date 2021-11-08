Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB1A44802B
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 14:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239892AbhKHNWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 08:22:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239888AbhKHNWq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 08:22:46 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8D0W5g012144;
        Mon, 8 Nov 2021 13:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=K9foN8Lvj5O8jm4NUPzsOuC7zoZaxFx6joxD5/38mz0=;
 b=nDZG+wDsmMWAb1T5z+R7YQEfhI8VRjOVHHEeuGsT+a3kuXp1uDXubXWRS8zuWRq+DlNx
 kP14MAwL8J5q9mFla538n4u//TVm0tBkLg3IEH3b7JAmcl0hUlXWawBQPEyWEqUqlif6
 /pGHrb+m7VzYdNXH6OdiiHNnKstb+ajUWhpAnqbgcSmz7fWQDFW1N/oVUxQiEtloYkJd
 3aCqndwTzF+1PpUl61bpVYSOqiKCHtX59MnyP6EXQM700ucQn2jtI4HeJxhfg70E2x+3
 BznNoSxRF2V3sDLjb8+aVxsFZtBGS0YCKog2r27h4TmoaT+jUx0qDYo1r0Xj0aNCxoJZ Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c641sj7hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 13:19:24 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8Bw7UQ005024;
        Mon, 8 Nov 2021 13:19:23 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c641sj7gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 13:19:22 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8DDlcL007476;
        Mon, 8 Nov 2021 13:19:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3c5hb9xbt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 13:19:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8DJGSH53674486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 13:19:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D88242059;
        Mon,  8 Nov 2021 13:19:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A11B42041;
        Mon,  8 Nov 2021 13:19:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.11.147])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 13:19:15 +0000 (GMT)
Date:   Mon, 8 Nov 2021 13:13:48 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 3/5] KVM: s390: Use kvm_get_vcpu() instead of open-coded
 access
Message-ID: <20211108131348.7710f10a@p-imbrenda>
In-Reply-To: <20211105192101.3862492-4-maz@kernel.org>
References: <20211105192101.3862492-1-maz@kernel.org>
        <20211105192101.3862492-4-maz@kernel.org>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2Tpsr6ax-14v0tvGNWvY_Xz22aRe4-xQ
X-Proofpoint-ORIG-GUID: AyI-d3SVtgl34O6n5RGX5d0X8rNJXf0F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_05,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  5 Nov 2021 19:20:59 +0000
Marc Zyngier <maz@kernel.org> wrote:

> As we are about to change the way vcpus are allocated, mandate
> the use of kvm_get_vcpu() instead of open-coding the access.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

makes sense

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 7af53b8788fa..4a0f62b03964 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4572,7 +4572,7 @@ int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
>  	}
>  
>  	for (i = 0; i < online_vcpus; i++) {
> -		if (!is_vcpu_stopped(vcpu->kvm->vcpus[i]))
> +		if (!is_vcpu_stopped(kvm_get_vcpu(vcpu->kvm, i)))
>  			started_vcpus++;
>  	}
>  
> @@ -4634,9 +4634,11 @@ int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
>  	__disable_ibs_on_vcpu(vcpu);
>  
>  	for (i = 0; i < online_vcpus; i++) {
> -		if (!is_vcpu_stopped(vcpu->kvm->vcpus[i])) {
> +		struct kvm_vcpu *tmp = kvm_get_vcpu(vcpu->kvm, i);
> +
> +		if (!is_vcpu_stopped(tmp)) {
>  			started_vcpus++;
> -			started_vcpu = vcpu->kvm->vcpus[i];
> +			started_vcpu = tmp;
>  		}
>  	}
>  

