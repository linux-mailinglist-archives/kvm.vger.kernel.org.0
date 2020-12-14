Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4964A2D96BB
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 11:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407518AbgLNK6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 05:58:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49326 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394613AbgLNK6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 05:58:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEArd2t044319;
        Mon, 14 Dec 2020 10:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bGhF6GM8jeHuUF82L25H2l13LBmPUldP5th7yl6Sa4Q=;
 b=EssgQMM9AwKnx1bIWM+9gA3pVUx07dy7GScZOHIwOm94sXOqMfctqUerCeZIMZqoMBwP
 7V7NkqUeidE4bD0CtHeb7SFOsiigOEAwhBJEYHr//TCtzRhz3IIPZh6smHErGfVqLr5G
 OvwsmgIza/xf9bFAsi6aIDsiPmYQZlQFEdupENMphRizWBjQKBIjyoYUYvD+OeBSAnxa
 YDXY/VRsnR/FLbXHhEyPFBOlRWIDncVkBMvztqq7EtSUz6l2PBhhtFQb7QQCmVt2qbAO
 jD+XkYerRur/aawlPL5eL/d/6d0TsP6nLkA3A+8cG/1PnVszSXqO5DJisU/exq/Y8+r3 tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35cntkvhuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 10:57:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEAo2UX034999;
        Mon, 14 Dec 2020 10:55:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35d7sub3s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 10:55:22 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BEAtLrr027249;
        Mon, 14 Dec 2020 10:55:21 GMT
Received: from [10.175.173.239] (/10.175.173.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 02:55:20 -0800
Subject: Re: [PATCH v3 13/17] KVM: x86/xen: register vcpu time info region
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, kvm@vger.kernel.org
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-14-dwmw2@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <26cfa76d-8712-d78d-24f3-5ab8b0fb5024@oracle.com>
Date:   Mon, 14 Dec 2020 10:55:16 +0000
MIME-Version: 1.0
In-Reply-To: <20201214083905.2017260-14-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 8:39 AM, David Woodhouse wrote:
> From: Joao Martins <joao.m.martins@oracle.com>
> 
> Allow the Xen emulated guest the ability to register secondary
> vcpu time information. On Xen guests this is used in order to be
> mapped to userspace and hence allow vdso gettimeofday to work.
> 
> In doing so, move kvm_xen_set_pvclock_page() logic to
> kvm_xen_update_vcpu_time() and have the former a top-level
> function which updates primary vcpu time info (in struct vcpu_info)
> and secondary one.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/x86.c              |  2 ++
>  arch/x86/kvm/xen.c              | 26 ++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h        |  1 +
>  4 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 56c00a9441a3..b7dfcb4de92a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -524,7 +524,9 @@ struct kvm_vcpu_hv {
>  struct kvm_vcpu_xen {
>  	u64 hypercall_rip;
>  	bool vcpu_info_set;
> +	bool vcpu_time_info_set;
>  	struct gfn_to_hva_cache vcpu_info_cache;
> +	struct gfn_to_hva_cache vcpu_time_info_cache;
>  };
>  
>  struct kvm_vcpu_arch {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cbdc05bb53bd..2234fdf49d82 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2729,6 +2729,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	if (vcpu->xen.vcpu_info_set)
>  		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_info_cache,
>  				       offsetof(struct compat_vcpu_info, time));
> +	if (vcpu->xen.vcpu_time_info_set)
> +		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
>  	if (v == kvm_get_vcpu(v->kvm, 0))
>  		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
>  	return 0;
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index d2055b60fdc1..1cca46effec8 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -95,6 +95,21 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
>  		break;
>  
> +	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
> +		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
> +		if (!v)
> +			return -EINVAL;
> +
> +		r = kvm_gfn_to_hva_cache_init(kvm, &v->arch.xen.vcpu_time_info_cache,
> +					      data->u.vcpu_attr.gpa,
> +					      sizeof(struct pvclock_vcpu_time_info));
> +		if (r)
> +			return r;
> +
> +		v->arch.xen.vcpu_time_info_set = true;

Same comment as shared_info: we probably don't need vcpu_time_info_set if we piggyback
on the gfn_to_hva cache setting its @gpa field.

> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
> +		break;
> +
>  	default:
>  		break;
>  	}
> @@ -131,6 +146,17 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		}
>  		break;
>  
> +	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
> +		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
> +		if (!v)
> +			return -EINVAL;
> +
> +		if (v->arch.xen.vcpu_time_info_set) {
> +			data->u.vcpu_attr.gpa = v->arch.xen.vcpu_time_info_cache.gpa;
> +			r = 0;
> +		}
> +		break;
> +
>  	default:
>  		break;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 87d150992f48..f60c5c61761c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1599,6 +1599,7 @@ struct kvm_xen_hvm_attr {
>  #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
>  #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
>  #define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
> +#define KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO	0x3
>  
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
> 
