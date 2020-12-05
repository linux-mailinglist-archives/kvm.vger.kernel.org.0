Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8145D2CFDD0
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 19:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgLESom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Dec 2020 13:44:42 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36224 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgLESof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Dec 2020 13:44:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B5IWmwf069660;
        Sat, 5 Dec 2020 18:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=g5ZCUVS0B4kKX6H/quUkzqXg37mhis30l0KMOMkXMTc=;
 b=Sqr5JiAmGSQlnMF/9DV6FNZio0fdG2T92YdfuSTuQeMDZj2eG5JHaJkN/KvaRojvdmV1
 e1QCbMzSj5gdmBeOLDttftq0iHsUZVZp7HKZ1SauAwihiSe/6BPg3NYqEXWPJR/MZRaJ
 Zn61mt2eSy2DxNiphjg0OLEJSMzoVDETzEfXKGcIBDc9sgGUZHdkcrNNOVAWYj969eWV
 Q84tzs2iu5qok+2499LvnZeZrR1czj5qjp9IX+miTTprOjSmzyfPQxHfQ6XgepPVPeAD
 hm9zns7sVFs5tQTTAiVOZAOjQov9ML8A3XfqwqVDfvJ9zLScQSQrCAlic6XH0cH/txTQ qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 357yqbhd9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 05 Dec 2020 18:43:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B5IUU8v105132;
        Sat, 5 Dec 2020 18:43:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3581hgywr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Dec 2020 18:43:45 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B5Ihh5g007778;
        Sat, 5 Dec 2020 18:43:43 GMT
Received: from [10.175.203.58] (/10.175.203.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 05 Dec 2020 10:43:43 -0800
Subject: Re: [PATCH 07/15] KVM: x86/xen: add definitions of
 compat_shared_info, compat_vcpu_info
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
 <20201204011848.2967588-8-dwmw2@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <84bdce1d-2096-34cf-0a90-6eaf69641705@oracle.com>
Date:   Sat, 5 Dec 2020 18:43:40 +0000
MIME-Version: 1.0
In-Reply-To: <20201204011848.2967588-8-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9826 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 spamscore=0 suspectscore=1 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012050124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9826 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012050124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 1:18 AM, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> There aren't a lot of differences for the things that the kernel needs
> to care about, but there are a few.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/xen.h | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> index afc6dad41fb5..870ac7197a3a 100644
> --- a/arch/x86/kvm/xen.h
> +++ b/arch/x86/kvm/xen.h
> @@ -21,4 +21,43 @@ static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
>  		KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
>  }
>  
> +
> +/* 32-bit compatibility definitions */
> +#include <asm/pvclock-abi.h>
> +#include <asm/xen/interface.h>
> +
> +struct compat_arch_vcpu_info {
> +	unsigned int cr2;
> +	unsigned int pad[5];
> +};
> +
> +struct compat_vcpu_info {
> +        uint8_t evtchn_upcall_pending;
> +        uint8_t evtchn_upcall_mask;
> +        uint32_t evtchn_pending_sel;
> +        struct compat_arch_vcpu_info arch;
> +        struct pvclock_vcpu_time_info time;
> +}; /* 64 bytes (x86) */
> +
> +struct compat_arch_shared_info {
> +	unsigned int max_pfn;
> +	unsigned int pfn_to_mfn_frame_list_list;
> +	unsigned int nmi_reason;
> +	unsigned int p2m_cr3;
> +	unsigned int p2m_vaddr;
> +	unsigned int p2m_generation;
> +	uint32_t wc_sec_hi;
> +};
> +
> +struct compat_shared_info {
> +	struct compat_vcpu_info vcpu_info[MAX_VIRT_CPUS];
> +	uint32_t evtchn_pending[sizeof(compat_ulong_t) * 8];
> +	uint32_t evtchn_mask[sizeof(compat_ulong_t) * 8];
> +	uint32_t wc_version;
> +	uint32_t wc_sec;
> +	uint32_t wc_nsec;
> +	struct compat_arch_shared_info arch;
> +
> +};
> +
>  #endif /* __ARCH_X86_KVM_XEN_H__ */
> 
I would fold this into the next patch.

For it makes sense to keep separate the xen canonical headers update (patch 10).
