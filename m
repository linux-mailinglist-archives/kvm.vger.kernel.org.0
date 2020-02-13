Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E6815CAC2
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 19:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgBMSzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 13:55:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37572 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727761AbgBMSzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 13:55:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01DIqbxH014791;
        Thu, 13 Feb 2020 18:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xxN1ToWl43jQv4Pb6pKw4TpxAtDjjezu7dXEUGdd9F4=;
 b=EFZ1M3LZ4fWyLWpmMcGqXG+b9pCa4PfOEc/PgvFeywSF+E2mxW1uUHUVakOp4OS+vRqC
 7/9GrUjD5u7IRLs+rzBz7l72TNelNDjqgNcV/Js1CZknAQtgRpU64JLc6L73RKmwtT9u
 G295K2MYoLfnPV/GxDxATByMR/cTVlOppqYLQ62tskfjx70B96DVit7XK8YY+AoFz33Z
 mACXsCeORMOFt15FWyMvXrhFEG/aNeDEboMLhb3Y2TDBDjFk6T3HljXRs+Eu/hir+Dv7
 U1swXxF7zLvsEEAVJjtQmpqgCeKsTJ1OWTTKlFZ3Suk0mIRQGOQmC12YU6z9rMiIxRzb wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y2k88mhvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 18:53:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01DIpqZm043233;
        Thu, 13 Feb 2020 18:53:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2y4k80de1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 18:53:42 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01DIrZ8S010833;
        Thu, 13 Feb 2020 18:53:35 GMT
Received: from localhost.localdomain (/10.159.243.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Feb 2020 10:53:35 -0800
Subject: Re: [PATCH] KVM: x86: eliminate some unreachable code
To:     linmiaohe <linmiaohe@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1581562405-30321-1-git-send-email-linmiaohe@huawei.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <ac51e889-624a-b108-d03c-4dc3e91c9a69@oracle.com>
Date:   Thu, 13 Feb 2020 10:53:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1581562405-30321-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9530 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9530 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130132
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/12/20 6:53 PM, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> These code are unreachable, remove them.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 1 -
>   arch/x86/kvm/x86.c     | 3 ---
>   2 files changed, 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bb5c33440af8..b6d4eafe01cf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4505,7 +4505,6 @@ static bool rmode_exception(struct kvm_vcpu *vcpu, int vec)
>   	case GP_VECTOR:
>   	case MF_VECTOR:
>   		return true;
> -	break;
>   	}
>   	return false;
>   }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fbabb2f06273..a597009aefd7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3081,7 +3081,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		break;
>   	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
>   		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
> -		break;
>   	case MSR_IA32_TSCDEADLINE:
>   		msr_info->data = kvm_get_lapic_tscdeadline_msr(vcpu);
>   		break;
> @@ -3164,7 +3163,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		return kvm_hv_get_msr_common(vcpu,
>   					     msr_info->index, &msr_info->data,
>   					     msr_info->host_initiated);
> -		break;
>   	case MSR_IA32_BBL_CR_CTL3:
>   		/* This legacy MSR exists but isn't fully documented in current
>   		 * silicon.  It is however accessed by winxp in very narrow
> @@ -8471,7 +8469,6 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>   		break;
>   	default:
>   		return -EINTR;
> -		break;
>   	}
>   	return 1;
>   }
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
