Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740BB2D9722
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 12:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgLNLLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 06:11:34 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56276 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388111AbgLNLLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 06:11:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEArnNN083416;
        Mon, 14 Dec 2020 11:10:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Y/mJ3FNPz9e57nV8qA4BcyQM14MPiofacAJdjDOGSaM=;
 b=v7Empe0ORMmS7+gwCM5CJC10f6d9J38jHhv188g7dND2ehr8+THEntdjMyM3yVFY9OBr
 rhVfAv+cRwyO1xRzp8ZANH4zTQP+04APvNJ618ylYPhDOPX4OhraUNgR6I9Sb/eYqznC
 w84xxnYl5XaMND0tSOmyZE8Db5stwtOs+bYx9bXbHNpYoxQqtWiKYRqsCDaOqXf1FN4h
 6h4Nk6qAOVg2jkEPq1bn9JDUIoKOlVdI9F5xXrp3Vit9QneoTFnZ9SaO4Ptx+Rc9szUL
 PphfdKDsjdh9KiHx6H37M+9axrmzKit2zI5WToH1ud4PoKmGfiVuY95+gEhGJBlKcU7B Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcb4s7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 11:10:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEAp3pV026645;
        Mon, 14 Dec 2020 11:10:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35e6jp8s3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 11:10:19 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEBAHUA025132;
        Mon, 14 Dec 2020 11:10:18 GMT
Received: from [10.175.173.239] (/10.175.173.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 03:10:17 -0800
Subject: Re: [PATCH v3 14/17] KVM: x86/xen: register runstate info
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, kvm@vger.kernel.org
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-15-dwmw2@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <f7a2c70f-188d-b1b2-5d93-398746ea989e@oracle.com>
Date:   Mon, 14 Dec 2020 11:10:13 +0000
MIME-Version: 1.0
In-Reply-To: <20201214083905.2017260-15-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/14/20 8:39 AM, David Woodhouse wrote:

[...]

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b7dfcb4de92a..4b345a8945ea 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -523,10 +523,15 @@ struct kvm_vcpu_hv {
>  /* Xen HVM per vcpu emulation context */
>  struct kvm_vcpu_xen {
>  	u64 hypercall_rip;
> +	u32 current_runstate;
>  	bool vcpu_info_set;
>  	bool vcpu_time_info_set;
> +	bool runstate_set;
>  	struct gfn_to_hva_cache vcpu_info_cache;
>  	struct gfn_to_hva_cache vcpu_time_info_cache;
> +	struct gfn_to_hva_cache runstate_cache;
> +	u64 last_steal;
> +	u64 last_state_ns;
>  };
>  
>  struct kvm_vcpu_arch {

[...]

> @@ -78,7 +198,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
>  		if (!v)
>  			return -EINVAL;
> -
>  		/* No compat necessary here. */
>  		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
>  			     sizeof(struct compat_vcpu_info));
> @@ -110,6 +229,22 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
>  		break;
>  
> +	case KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE:
> +		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
> +		if (!v)
> +			return -EINVAL;
> +
> +		r = kvm_gfn_to_hva_cache_init(kvm, &v->arch.xen.runstate_cache,
> +					      data->u.vcpu_attr.gpa,
> +					      sizeof(struct vcpu_runstate_info));
> +		if (r)
> +			return r;
> +
> +		v->arch.xen.runstate_set = true;

Same as shared_info comment.

But maybe {shared_info,vcpu_info,runstate}_set could be instead turned into helpers
if it helps the cosmetics.

> +		v->arch.xen.current_runstate = RUNSTATE_blocked;
> +		v->arch.xen.last_state_ns = ktime_get_ns();
> +		break;
> +
>  	default:
>  		break;
>  	}
> @@ -157,6 +292,17 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		}
>  		break;
>  
> +	case KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE:
> +		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
> +		if (!v)
> +			return -EINVAL;
> +
> +		if (v->arch.xen.runstate_set) {
> +			data->u.vcpu_attr.gpa = v->arch.xen.runstate_cache.gpa;
> +			r = 0;
> +		}
> +		break;
> +
>  	default:
>  		break;
>  	}
> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> index 120b7450252a..407e717476d6 100644
> --- a/arch/x86/kvm/xen.h
> +++ b/arch/x86/kvm/xen.h
> @@ -9,6 +9,8 @@
>  #ifndef __ARCH_X86_KVM_XEN_H__
>  #define __ARCH_X86_KVM_XEN_H__
>  
> +void kvm_xen_setup_runstate_page(struct kvm_vcpu *vcpu);
> +void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu);
>  int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
>  int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
>  int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
> @@ -54,7 +56,12 @@ struct compat_shared_info {
>  	uint32_t evtchn_mask[32];
>  	struct pvclock_wall_clock wc;
>  	struct compat_arch_shared_info arch;
> -
>  };
>  

This change belos in the seventh patch I believe.
