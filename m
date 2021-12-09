Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6391D46E718
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 11:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbhLIK4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 05:56:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231745AbhLIK4n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 05:56:43 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B99wY6B004429;
        Thu, 9 Dec 2021 10:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lZ/f/RWB0n7XRFqPDZK1uJikVkO/dU07QZ94OoDGgXA=;
 b=T9vi5KbEI0bPIg9CyexJ2YYMzcUBZoCsUmd1qVDcUZI08/xeLJ8kJFcFLrD32zMeOUsJ
 0iyQED4chL50AfCWePdZlRw2G0+V0O89Z1npo2KvVwchVYb/d0HE1E2+sgKs0zX0rlCg
 /ILsJYq6hQs3OMCmmlMo0g5cjOCbTJrXouHKsB/lyNEQN2JpryS1cu1AEPc1vk7rYDlr
 bhyuEpAXpFP+pF3Ws/B6v3OD4BcxS735gPltOwVq+wcImfYX+WDd/uIV9gsGnw9u9KjH
 o4RunTdoRAACN8eV6or4QklHGKn38YqWAhwoevAGl6NQca1osk8QcZpfX75cGIdkCIZV CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cufn10yxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 10:52:38 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B99wo9O004691;
        Thu, 9 Dec 2021 10:52:37 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cufn10ywr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 10:52:37 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9AlR5f003038;
        Thu, 9 Dec 2021 10:52:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyb87vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 10:52:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9AqVQ417629682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 10:52:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F41BA4059;
        Thu,  9 Dec 2021 10:52:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFD2BA404D;
        Thu,  9 Dec 2021 10:52:30 +0000 (GMT)
Received: from [9.145.80.242] (unknown [9.145.80.242])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 10:52:30 +0000 (GMT)
Message-ID: <24c84413-4965-9105-fc02-2f72ab053b2a@linux.ibm.com>
Date:   Thu, 9 Dec 2021 11:52:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 5/7] KVM: s390: Replace KVM_REQ_MMU_RELOAD usage with arch
 specific request
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <20211209060552.2956723-1-seanjc@google.com>
 <20211209060552.2956723-6-seanjc@google.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211209060552.2956723-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jMDmWYMEscH1G0f_BpWt_od3JtjCUm4s
X-Proofpoint-GUID: KIL-mJAE3PHe4Zk8fN_axStTrgem2Ibf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1011
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 07:05, Sean Christopherson wrote:
> Add an arch request, KVM_REQ_REFRESH_GUEST_PREFIX, to deal with guest
> prefix changes instead of piggybacking KVM_REQ_MMU_RELOAD.  This will
> allow for the removal of the generic KVM_REQ_MMU_RELOAD, which isn't
> actually used by generic KVM.

Yes, that does sound nicer.

> 
> No functional change intended.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/s390/include/asm/kvm_host.h | 2 ++
>   arch/s390/kvm/kvm-s390.c         | 8 ++++----
>   arch/s390/kvm/kvm-s390.h         | 2 +-
>   3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a22c9266ea05..766028d54a3e 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -45,6 +45,8 @@
>   #define KVM_REQ_START_MIGRATION KVM_ARCH_REQ(3)
>   #define KVM_REQ_STOP_MIGRATION  KVM_ARCH_REQ(4)
>   #define KVM_REQ_VSIE_RESTART	KVM_ARCH_REQ(5)
> +#define KVM_REQ_REFRESH_GUEST_PREFIX	\
> +	KVM_ARCH_REQ_FLAGS(6, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   
>   #define SIGP_CTRL_C		0x80
>   #define SIGP_CTRL_SCN_MASK	0x3f
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index dd099d352753..e161df69520c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3394,7 +3394,7 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
>   		if (prefix <= end && start <= prefix + 2*PAGE_SIZE - 1) {
>   			VCPU_EVENT(vcpu, 2, "gmap notifier for %lx-%lx",
>   				   start, end);
> -			kvm_s390_sync_request(KVM_REQ_MMU_RELOAD, vcpu);
> +			kvm_s390_sync_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
>   		}
>   	}
>   }
> @@ -3796,19 +3796,19 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
>   	if (!kvm_request_pending(vcpu))
>   		return 0;
>   	/*
> -	 * We use MMU_RELOAD just to re-arm the ipte notifier for the
> +	 * If the guest prefix changed, re-arm the ipte notifier for the
>   	 * guest prefix page. gmap_mprotect_notify will wait on the ptl lock.
>   	 * This ensures that the ipte instruction for this request has
>   	 * already finished. We might race against a second unmapper that
>   	 * wants to set the blocking bit. Lets just retry the request loop.
>   	 */
> -	if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu)) {
> +	if (kvm_check_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu)) {
>   		int rc;
>   		rc = gmap_mprotect_notify(vcpu->arch.gmap,
>   					  kvm_s390_get_prefix(vcpu),
>   					  PAGE_SIZE * 2, PROT_WRITE);
>   		if (rc) {
> -			kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
> +			kvm_make_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
>   			return rc;
>   		}
>   		goto retry;
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 60f0effcce99..219f92ffd556 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -105,7 +105,7 @@ static inline void kvm_s390_set_prefix(struct kvm_vcpu *vcpu, u32 prefix)
>   		   prefix);
>   	vcpu->arch.sie_block->prefix = prefix >> GUEST_PREFIX_SHIFT;
>   	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> -	kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
> +	kvm_make_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
>   }
>   
>   static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)
> 

