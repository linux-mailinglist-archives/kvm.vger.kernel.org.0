Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DC62D98D1
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 14:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439490AbgLNNaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 08:30:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37014 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439357AbgLNNag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 08:30:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEDTmB0111029;
        Mon, 14 Dec 2020 13:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2MzHpnxakq2CoovSBtglQu1YHaBVANM9msXN3tNBkYg=;
 b=YTHL7P7YphNPia7OvQ7vcNVr5KJRfJ4aB3vbtPpswb7Yvl4kZpWNQ7sh5amXMvZY7j2S
 XDaxcOFnDMJsrmnIMyueP3wFcsf6+r95XGm+wXcmB0lkdRqWXcyoShcQYUg3hyZQEueU
 eqJlHUaepv57RNVYwimp/NkLeYyidslbNbsZS3rs3C+qPetuVL11ZDvNRjNIX3h2T5Gr
 +EMiwXehvITaY7o8sA3HpiriGKxg9jNsYiUi5e3OkNk0MPNtzQVjoAVOVrWj059FzAhB
 7Q/vqaBxSuoIdn/UU/qUlyjPkjHgSw3+XKkPCJtISf0KPkSWW7dAD5tRLHkSUbCM7n8/ xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35ckcb59w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 13:29:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEDK34H062022;
        Mon, 14 Dec 2020 13:29:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35d7suh5xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 13:29:47 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BEDTkTv005457;
        Mon, 14 Dec 2020 13:29:46 GMT
Received: from [10.175.173.239] (/10.175.173.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 05:29:45 -0800
Subject: Re: [PATCH v3 12/17] KVM: x86/xen: setup pvclock updates
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, kvm@vger.kernel.org
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-13-dwmw2@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <5cb7cd9b-cdeb-be12-7e86-040b7610b2e7@oracle.com>
Date:   Mon, 14 Dec 2020 13:29:41 +0000
MIME-Version: 1.0
In-Reply-To: <20201214083905.2017260-13-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 8:39 AM, David Woodhouse wrote:
> From: Joao Martins <joao.m.martins@oracle.com>
> 
> Parameterise kvm_setup_pvclock_page() a little bit so that it can be
> invoked for different gfn_to_hva_cache structures, and with different
> offsets. Then we can invoke it for the normal KVM pvclock and also for
> the Xen one in the vcpu_info.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/x86.c | 31 ++++++++++++++++++-------------
>  arch/x86/kvm/xen.c |  4 ++++
>  2 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 64016443159c..cbdc05bb53bd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2582,13 +2582,15 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>  	return ret;
>  }
>  
> -static void kvm_setup_pvclock_page(struct kvm_vcpu *v)
> +static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
> +				   struct gfn_to_hva_cache *cache,
> +				   unsigned int offset)
>  {
>  	struct kvm_vcpu_arch *vcpu = &v->arch;
>  	struct pvclock_vcpu_time_info guest_hv_clock;
>  
> -	if (unlikely(kvm_read_guest_cached(v->kvm, &vcpu->pv_time,
> -		&guest_hv_clock, sizeof(guest_hv_clock))))
> +	if (unlikely(kvm_read_guest_offset_cached(v->kvm, cache,
> +		&guest_hv_clock, offset, sizeof(guest_hv_clock))))
>  		return;
>  
>  	/* This VCPU is paused, but it's legal for a guest to read another
> @@ -2611,9 +2613,9 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v)
>  		++guest_hv_clock.version;  /* first time write, random junk */
>  
>  	vcpu->hv_clock.version = guest_hv_clock.version + 1;
> -	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
> -				&vcpu->hv_clock,
> -				sizeof(vcpu->hv_clock.version));
> +	kvm_write_guest_offset_cached(v->kvm, cache,
> +				      &vcpu->hv_clock, offset,
> +				      sizeof(vcpu->hv_clock.version));
>  
>  	smp_wmb();
>  
> @@ -2627,16 +2629,16 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v)
>  
>  	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
>  
> -	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
> -				&vcpu->hv_clock,
> -				sizeof(vcpu->hv_clock));
> +	kvm_write_guest_offset_cached(v->kvm, cache,
> +				      &vcpu->hv_clock, offset,
> +				      sizeof(vcpu->hv_clock));
>  
>  	smp_wmb();
>  
>  	vcpu->hv_clock.version++;
> -	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
> -				&vcpu->hv_clock,
> -				sizeof(vcpu->hv_clock.version));
> +	kvm_write_guest_offset_cached(v->kvm, cache,
> +				     &vcpu->hv_clock, offset,
> +				     sizeof(vcpu->hv_clock.version));
>  }
>  
>  static int kvm_guest_time_update(struct kvm_vcpu *v)
> @@ -2723,7 +2725,10 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	vcpu->hv_clock.flags = pvclock_flags;
>  
>  	if (vcpu->pv_time_enabled)
> -		kvm_setup_pvclock_page(v);
> +		kvm_setup_pvclock_page(v, &vcpu->pv_time, 0);
> +	if (vcpu->xen.vcpu_info_set)
> +		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_info_cache,
> +				       offsetof(struct compat_vcpu_info, time));

We might be missing the case where only shared_info is registered. Something like:

	if (vcpu->xen.shinfo_set && !vcpu->xen.vcpu_info_set) {
		offset = offsetof(struct compat_vcpu_info, time);
                offset += offsetof(struct shared_info, vcpu_info);
                offset += (v - kvm_get_vcpu_by_id(0)) * sizeof(struct compat_vcpu_info);
		
		kvm_setup_pvclock_page(v, &vcpu->xen.shinfo_cache, offset);
	}

Part of the reason I had a kvm_xen_setup_pvclock_page() was to handle this all these
combinations i.e. 1) shared_info && !vcpu_info 2) vcpu_info and unilaterially updating
secondary time info.

But maybe introducing this xen_vcpu_info() helper to accommodate all this.

>  	if (v == kvm_get_vcpu(v->kvm, 0))
>  		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>  	return 0;
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 4bc72e0b9928..d2055b60fdc1 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -82,6 +82,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		/* No compat necessary here. */
>  		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
>  			     sizeof(struct compat_vcpu_info));
> +		BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
> +			     offsetof(struct compat_vcpu_info, time));
> +
>  		r = kvm_gfn_to_hva_cache_init(kvm, &v->arch.xen.vcpu_info_cache,
>  					      data->u.vcpu_attr.gpa,
>  					      sizeof(struct vcpu_info));
> @@ -89,6 +92,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  			return r;
>  
>  		v->arch.xen.vcpu_info_set = true;
> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
>  		break;
>  
>  	default:
> 
