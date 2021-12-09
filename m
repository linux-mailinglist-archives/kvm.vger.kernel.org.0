Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA346E560
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 10:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbhLIJYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 04:24:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232940AbhLIJYG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 04:24:06 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B96wVQK021779;
        Thu, 9 Dec 2021 09:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=htgjlyjnR0tQfnlODHTJY7W3N23M44E+GMF0/KyhUSE=;
 b=CWuW950MZCjkG54jLRsN5sRVSHyW3SanvMGmfXAYkLgqPQeXU372tDIc4faiWdXhr5ZW
 JXZK2aCkkxJGF1cn3JlvIoFBz3Nyp7KSZPR+tJmGa4t2YJs5dbDQ1h9w9Wfpd68O8xZP
 OnojEfeM6ZN1UBlTYqS+Ym0SLfSP2ksmhE7rJaCszjyWsLU1sOchWhRbMlpUkz39Bk79
 aTc+P9DO7TNzrN0uB3yNg7JnxhJqMd65wJNqhWMt0ZVToRTPZV/CJRfaOu0tIfA0NtU0
 8zNjRZi8KrqVjn9wETAAeNBFbpPCLE+7fL/k1H6fIhJFMjjGYUtPrfgy5JyoU9r7/A0w +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cud0n2q7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 09:20:09 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B99BaTn017529;
        Thu, 9 Dec 2021 09:20:09 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cud0n2q6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 09:20:08 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B99BSau011026;
        Thu, 9 Dec 2021 09:20:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyb7cjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 09:20:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B998XDe29098426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 09:08:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 625354C040;
        Thu,  9 Dec 2021 09:16:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98CA34C066;
        Thu,  9 Dec 2021 09:16:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 09:16:17 +0000 (GMT)
Date:   Thu, 9 Dec 2021 10:14:16 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH 5/7] KVM: s390: Replace KVM_REQ_MMU_RELOAD usage with
 arch specific request
Message-ID: <20211209101416.7f81d946@p-imbrenda>
In-Reply-To: <20211209060552.2956723-6-seanjc@google.com>
References: <20211209060552.2956723-1-seanjc@google.com>
        <20211209060552.2956723-6-seanjc@google.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: plf6rlDy0mwNz-4UFJuakyod9zFE2OYG
X-Proofpoint-ORIG-GUID: vlZAIMVWOQCby1wttP3Nq8-CjRatTM1n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Dec 2021 06:05:50 +0000
Sean Christopherson <seanjc@google.com> wrote:

> Add an arch request, KVM_REQ_REFRESH_GUEST_PREFIX, to deal with guest
> prefix changes instead of piggybacking KVM_REQ_MMU_RELOAD.  This will
> allow for the removal of the generic KVM_REQ_MMU_RELOAD, which isn't
> actually used by generic KVM.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/kvm_host.h | 2 ++
>  arch/s390/kvm/kvm-s390.c         | 8 ++++----
>  arch/s390/kvm/kvm-s390.h         | 2 +-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a22c9266ea05..766028d54a3e 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -45,6 +45,8 @@
>  #define KVM_REQ_START_MIGRATION KVM_ARCH_REQ(3)
>  #define KVM_REQ_STOP_MIGRATION  KVM_ARCH_REQ(4)
>  #define KVM_REQ_VSIE_RESTART	KVM_ARCH_REQ(5)
> +#define KVM_REQ_REFRESH_GUEST_PREFIX	\
> +	KVM_ARCH_REQ_FLAGS(6, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  
>  #define SIGP_CTRL_C		0x80
>  #define SIGP_CTRL_SCN_MASK	0x3f
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index dd099d352753..e161df69520c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3394,7 +3394,7 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
>  		if (prefix <= end && start <= prefix + 2*PAGE_SIZE - 1) {
>  			VCPU_EVENT(vcpu, 2, "gmap notifier for %lx-%lx",
>  				   start, end);
> -			kvm_s390_sync_request(KVM_REQ_MMU_RELOAD, vcpu);
> +			kvm_s390_sync_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
>  		}
>  	}
>  }
> @@ -3796,19 +3796,19 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
>  	if (!kvm_request_pending(vcpu))
>  		return 0;
>  	/*
> -	 * We use MMU_RELOAD just to re-arm the ipte notifier for the
> +	 * If the guest prefix changed, re-arm the ipte notifier for the
>  	 * guest prefix page. gmap_mprotect_notify will wait on the ptl lock.
>  	 * This ensures that the ipte instruction for this request has
>  	 * already finished. We might race against a second unmapper that
>  	 * wants to set the blocking bit. Lets just retry the request loop.
>  	 */
> -	if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu)) {
> +	if (kvm_check_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu)) {
>  		int rc;
>  		rc = gmap_mprotect_notify(vcpu->arch.gmap,
>  					  kvm_s390_get_prefix(vcpu),
>  					  PAGE_SIZE * 2, PROT_WRITE);
>  		if (rc) {
> -			kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
> +			kvm_make_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
>  			return rc;
>  		}
>  		goto retry;
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 60f0effcce99..219f92ffd556 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -105,7 +105,7 @@ static inline void kvm_s390_set_prefix(struct kvm_vcpu *vcpu, u32 prefix)
>  		   prefix);
>  	vcpu->arch.sie_block->prefix = prefix >> GUEST_PREFIX_SHIFT;
>  	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> -	kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
> +	kvm_make_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
>  }
>  
>  static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)

