Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EF820A8F6
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 01:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgFYX37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 19:29:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50098 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgFYX36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 19:29:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSFpX151925;
        Thu, 25 Jun 2020 23:28:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MtvHQ1oWwCnAE+d4I01sSltOsJ2kBojfAWJiKmXtGWU=;
 b=lZM7ME9c+cp2GjgJYiLbo3YgYARJYrd0Mt8s/iKPeDAS0ebEQHJ6n5kgjwXmc+09FjQG
 mZxdvtOzUJka9r4FOYZK9TvmhiRyP3M48GXs4nGi6cHVwWB/EPcFHns03OLGq/h+glWK
 RrgnRzBqYp7A1vZ0iSBWByZFvDhtea/h7qi/dZa9sDr/FtywnXKr2T4r4FuJUFwDZIxO
 MqVZWd3JGOLt9y0YBb1nt90erCw4XWvWYyG4hjCBWkqd2u1EYc8ZkkD8ihdtBKsZmINV
 G6qL8cTmyMaqOOPJnDfcYVmchYKZogwI5UDJf+PF2i2Hkc1YkmJccTmvuX8eAZkfgWyj lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31uusu3a8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 23:28:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIGK110914;
        Thu, 25 Jun 2020 23:28:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31uur9r2xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 23:28:36 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05PNSVnv016460;
        Thu, 25 Jun 2020 23:28:31 GMT
Received: from localhost.localdomain (/10.159.236.36)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:28:30 +0000
Subject: Re: [PATCH 4/4] KVM: SVM: Rename svm_nested_virtualize_tpr() to
 nested_svm_virtualize_tpr()
To:     Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
References: <20200625080325.28439-1-joro@8bytes.org>
 <20200625080325.28439-5-joro@8bytes.org>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <3d8aa359-a43c-a080-5d62-3bf1300e1ee1@oracle.com>
Date:   Thu, 25 Jun 2020 16:28:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200625080325.28439-5-joro@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/25/20 1:03 AM, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
>
> Match the naming with other nested svm functions.
>
> No functional changes.
>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>   arch/x86/kvm/svm/svm.c | 6 +++---
>   arch/x86/kvm/svm/svm.h | 2 +-
>   2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e0b0321d95d4..b0d551bcf2a0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3040,7 +3040,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> -	if (svm_nested_virtualize_tpr(vcpu))
> +	if (nested_svm_virtualize_tpr(vcpu))
>   		return;
>   
>   	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
> @@ -3234,7 +3234,7 @@ static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> -	if (svm_nested_virtualize_tpr(vcpu))
> +	if (nested_svm_virtualize_tpr(vcpu))
>   		return;
>   
>   	if (!is_cr_intercept(svm, INTERCEPT_CR8_WRITE)) {
> @@ -3248,7 +3248,7 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	u64 cr8;
>   
> -	if (svm_nested_virtualize_tpr(vcpu) ||
> +	if (nested_svm_virtualize_tpr(vcpu) ||
>   	    kvm_vcpu_apicv_active(vcpu))
>   		return;
>   
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 003e89008331..8907efda0b0a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -365,7 +365,7 @@ void svm_set_gif(struct vcpu_svm *svm, bool value);
>   #define NESTED_EXIT_DONE	1	/* Exit caused nested vmexit  */
>   #define NESTED_EXIT_CONTINUE	2	/* Further checks needed      */
>   
> -static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
> +static inline bool nested_svm_virtualize_tpr(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
Should the name be changed to svm_nested_virtualized_tpr ?  Because 
svm_nested_virtualize_tpr implies that the action of the function is to 
virtualize the TPR.
