Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26632D98A6
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 14:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407827AbgLNNUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 08:20:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52126 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgLNNUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 08:20:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEDECCC090781;
        Mon, 14 Dec 2020 13:19:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2Ml3UiX3V2p1Hqv5ZaN0N3rzkyNu6u3gV+YWMdc9Lpo=;
 b=eOdXXZxDUkL/zHS1HVFhb4VtIh28zdaEs8ymp1vVADw94WS6QkhHq7TY/27k02F0Ys5N
 0QZXd98PXTGgpkxJ7Qar6nBdLOOVpwsjbYi9ZuKbHtAlpGOTsLGK2U3kpHrlCK8TYWAP
 IDry30W329LdlSOug+7el8oGFQ0MJbgcYKrRocsSvlEiRdt4JqBA0ZywIJ1bC6mGa++q
 0iX1FKxy4Ei92y//0pzD9HzbV1RzaoBAlpyrBtOOQ0qYdhqP151MU7gbnsm2A/uunYQT
 4VWas+WoXXCOe/TIATplWJ3cdm6mEHJoN/Ur3+N0CJn4cBv9t0ubFvdabKGVUO8FTo7S 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35cn9r53kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 13:19:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEDG4Xb052947;
        Mon, 14 Dec 2020 13:19:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35d7sugsm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 13:19:41 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BEDJesb000786;
        Mon, 14 Dec 2020 13:19:40 GMT
Received: from [10.175.173.239] (/10.175.173.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 05:19:40 -0800
Subject: Re: [PATCH v3 17/17] KVM: x86/xen: Add event channel interrupt vector
 upcall
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, kvm@vger.kernel.org
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-18-dwmw2@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <3917aa37-ed00-9350-1ba5-c3390be6b500@oracle.com>
Date:   Mon, 14 Dec 2020 13:19:34 +0000
MIME-Version: 1.0
In-Reply-To: <20201214083905.2017260-18-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140092
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 8:39 AM, David Woodhouse wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index df44d9e50adc..e627139cf8cd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8896,7 +8896,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			kvm_x86_ops.msr_filter_changed(vcpu);
>  	}
>  
> -	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
> +	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
> +	    kvm_xen_has_interrupt(vcpu)) {
>  		++vcpu->stat.req_event;
>  		kvm_apic_accept_events(vcpu);
>  		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 17cbb4462b7e..4bc9da9fcfb8 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -176,6 +176,45 @@ void kvm_xen_setup_runstate_page(struct kvm_vcpu *v)
>  	kvm_xen_update_runstate(v, RUNSTATE_running, steal_time);
>  }
>  
> +int kvm_xen_has_interrupt(struct kvm_vcpu *v)
> +{
> +	u8 rc = 0;
> +
> +	/*
> +	 * If the global upcall vector (HVMIRQ_callback_vector) is set and
> +	 * the vCPU's evtchn_upcall_pending flag is set, the IRQ is pending.
> +	 */
> +	if (v->arch.xen.vcpu_info_set && v->kvm->arch.xen.upcall_vector) {
> +		struct gfn_to_hva_cache *ghc = &v->arch.xen.vcpu_info_cache;
> +		struct kvm_memslots *slots = kvm_memslots(v->kvm);
> +		unsigned int offset = offsetof(struct vcpu_info, evtchn_upcall_pending);
> +

To have less nesting, wouldn't it be better to invert the logic?

say:

	u8 rc = 0;
	struct gfn_to_hva_cache *ghc
	struct kvm_memslots *slots;
	unsigned int offset;


	if (!v->arch.xen.vcpu_info_set || !v->kvm->arch.xen.upcall_vector)
		return 0;

	BUILD_BUG_ON(...)
	
	ghc = &v->arch.xen.vcpu_info_cache;
	slots = kvm_memslots(v->kvm);
	offset = offsetof(struct vcpu_info, evtchn_upcall_pending);

But I think there's a flaw here. That is handling the case where you don't have a
vcpu_info registered, and only shared info. The vcpu_info is then placed elsewhere, i.e.
another offset out of shared_info -- which is *I think* the case for PVHVM Windows guests.

Perhaps introducing a helper which adds xen_vcpu_info() and returns you the hva (picking
the right cache) similar to the RFC patch. Albeit that was with page pinning, but
borrowing an older version I had with hva_to_gfn_cache incantation would probably look like:


        if (v->arch.xen.vcpu_info_set) {
		ghc = &v->arch.xen.vcpu_info_cache;
        } else {
		ghc = &v->arch.xen.vcpu_info_cache;
                offset += offsetof(struct shared_info, vcpu_info);
                offset += (v - kvm_get_vcpu_by_id(0)) * sizeof(struct vcpu_info);
        }

	if (likely(slots->generation == ghc->generation &&
		   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
		/* Fast path */
		__get_user(rc, (u8 __user *)ghc->hva + offset);
	} else {
		/* Slow path */
		kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
					     sizeof(rc));
	}

 ?

	Joao
