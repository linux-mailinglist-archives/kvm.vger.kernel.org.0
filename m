Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1D02D96A0
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 11:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbgLNKtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 05:49:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42360 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbgLNKs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 05:48:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEAhaWw183051;
        Mon, 14 Dec 2020 10:48:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Wr2+ticZrAJf9tsd3MC308a7wyL+Tdo/OQA0JbeeqTI=;
 b=A3mXkLaZ3EdPkvgOSqGSyaf1OEjO8BS+kHCLMQc/M7djeHEvmc+cVhTIVOvHcgcJYhnv
 XybMrYdk+fmhw+ZfKBbqWFKBteji/ZSVg5RFhPqut42MN9/UZ8T5NbmL1qhdplpsbzFV
 SZzAtBTvSmr7pHlgIuALE2Ex+lDIHyKcQNebBkrnthtY7vquqM+QRFXjq1tyCQUKJMRW
 PvgQHi7oh8l+4i45s9v3C8e3+ZxH3137Lamf/f0sGdWqUmXv9iOD58i853/PPe3lCIMV
 rtt2ZErEr0ZOznWRNY0BV5mFtXvW8fYqaDobo4rK2b9a0F4HCJva8Q+E+YejCiFkTZ7B KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35cntkvgqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 10:48:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEAk4OB025454;
        Mon, 14 Dec 2020 10:48:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35d7suav43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 10:48:10 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEAm8pm030926;
        Mon, 14 Dec 2020 10:48:08 GMT
Received: from [10.175.173.239] (/10.175.173.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 02:48:08 -0800
Subject: Re: [PATCH v3 11/17] KVM: x86/xen: register vcpu info
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, kvm@vger.kernel.org
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-12-dwmw2@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <f73421bd-aedc-8f62-2ce9-f6e43be2a75f@oracle.com>
Date:   Mon, 14 Dec 2020 10:48:04 +0000
MIME-Version: 1.0
In-Reply-To: <20201214083905.2017260-12-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 8:38 AM, David Woodhouse wrote:
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index e5117a611737..4bc72e0b9928 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -58,6 +58,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
>  
>  int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  {
> +	struct kvm_vcpu *v;
>  	int r = -ENOENT;
>  
>  	switch (data->type) {
> @@ -73,6 +74,23 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
>  		break;
>  
> +	case KVM_XEN_ATTR_TYPE_VCPU_INFO:
> +		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
> +		if (!v)
> +			return -EINVAL;
> +
> +		/* No compat necessary here. */
> +		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
> +			     sizeof(struct compat_vcpu_info));
> +		r = kvm_gfn_to_hva_cache_init(kvm, &v->arch.xen.vcpu_info_cache,
> +					      data->u.vcpu_attr.gpa,
> +					      sizeof(struct vcpu_info));
> +		if (r)
> +			return r;
> +
> +		v->arch.xen.vcpu_info_set = true;

Same comment as the shared_info page.

> +		break;
> +
>  	default:
>  		break;
>  	}
> @@ -83,6 +101,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  {
>  	int r = -ENOENT;
> +	struct kvm_vcpu *v;
>  
>  	switch (data->type) {
>  	case KVM_XEN_ATTR_TYPE_LONG_MODE:
> @@ -97,6 +116,17 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		}
>  		break;
>  
> +	case KVM_XEN_ATTR_TYPE_VCPU_INFO:
> +		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
> +		if (!v)
> +			return -EINVAL;
> +
> +		if (v->arch.xen.vcpu_info_set) {
> +			data->u.vcpu_attr.gpa = v->arch.xen.vcpu_info_cache.gpa;
> +			r = 0;
> +		}
> +		break;
> +
>  	default:
>  		break;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index caa9faf3c5ad..87d150992f48 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1588,12 +1588,17 @@ struct kvm_xen_hvm_attr {
>  		struct {
>  			__u64 gfn;
>  		} shared_info;
> +		struct {
> +			__u32 vcpu_id;
> +			__u64 gpa;
> +		} vcpu_attr;
>  		__u64 pad[4];
>  	} u;
>  };
>  
>  #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
>  #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
> +#define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
>  
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
> 
