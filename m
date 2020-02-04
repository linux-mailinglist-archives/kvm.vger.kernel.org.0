Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575881520EE
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 20:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgBDTSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 14:18:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbgBDTSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 14:18:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014JI3jc058510;
        Tue, 4 Feb 2020 19:18:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=BarShku7lgfUR+oQEeWNHko4bNdH+Rp5Yxd95kqootg=;
 b=ovEPuy9nlguDsWGwlgctdRjCobwqY0BQ7NUzxSaUlRXDykiWyD8kk/AHg9uRPnx0OB4N
 Iwx71OPJE0UOHtwPf7LnsmQ30TbqJN17NUJC17P/rSbIr+OIsPzvcI0shbZ/kPNHVszX
 o4tCZXjoME7kX0nNClIGsxmh0rpVjujH0DMMqk/O3fdjYnjF9bLQZ5FJYBf89kxuJhTN
 +SN8XgGU2EMIAUVJfUfLhsA+1dLWkGwd73v6FesA4t8lJnrUkG6fP+Gh+I7gbDs4q1Db
 E27ZRghWLryyYuhAhRbTccwfq3gzY8iQo8lES1wgE59eINq/XLUxPSlqZbT3vD8gfnoH oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xwyg9n4qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 19:18:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014JEwEa090589;
        Tue, 4 Feb 2020 19:18:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xxw0xpafg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 19:18:02 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 014JI0Jl003098;
        Tue, 4 Feb 2020 19:18:01 GMT
Received: from localhost.localdomain (/10.159.243.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 11:18:00 -0800
Subject: Re: [kvm-unit-tests PATCH] x86: Fix the name for the SMEP CPUID bit
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200204175034.18201-1-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <e3678c96-1e46-550c-616a-08fd541b7f3d@oracle.com>
Date:   Tue, 4 Feb 2020 11:17:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200204175034.18201-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002040129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002040129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/4/20 9:50 AM, Sean Christopherson wrote:
> Fix the X86_FEATURE_* name for SMEP, which is incorrectly named
> X86_FEATURE_INVPCID_SINGLE and is a wee bit confusing when looking at
> the SMEP unit tests.
>
> Note, there is no INVPCID_SINGLE CPUID bit, the bogus name likely came
> from the Linux kernel, which has a synthetic feature flag for
> INVPCID_SINGLE in word 7, bit 7 (CPUID 0x7.EBX is stored in word 9).
>
> Fixes: 6ddcc29 ("kvm-unit-test: x86: Implement a generic wrapper for cpuid/cpuid_indexed functions")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   lib/x86/processor.h | 2 +-
>   x86/access.c        | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 7057180..03fdf64 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -138,7 +138,7 @@ static inline u8 cpuid_maxphyaddr(void)
>   #define	X86_FEATURE_XMM2		(CPUID(0x1, 0, EDX, 26))
>   #define	X86_FEATURE_TSC_ADJUST		(CPUID(0x7, 0, EBX, 1))
>   #define	X86_FEATURE_HLE			(CPUID(0x7, 0, EBX, 4))
> -#define	X86_FEATURE_INVPCID_SINGLE	(CPUID(0x7, 0, EBX, 7))
> +#define	X86_FEATURE_SMEP	        (CPUID(0x7, 0, EBX, 7))
>   #define	X86_FEATURE_INVPCID		(CPUID(0x7, 0, EBX, 10))
>   #define	X86_FEATURE_RTM			(CPUID(0x7, 0, EBX, 11))
>   #define	X86_FEATURE_SMAP		(CPUID(0x7, 0, EBX, 20))
> diff --git a/x86/access.c b/x86/access.c
> index 5233713..7303fc3 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -860,7 +860,7 @@ static int check_smep_andnot_wp(ac_pool_t *pool)
>   	ac_test_t at1;
>   	int err_prepare_andnot_wp, err_smep_andnot_wp;
>   
> -	if (!this_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
> +	if (!this_cpu_has(X86_FEATURE_SMEP)) {
>   	    return 1;
>   	}
>   
> @@ -955,7 +955,7 @@ static int ac_test_run(void)
>   	}
>       }
>   
> -    if (!this_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
> +    if (!this_cpu_has(X86_FEATURE_SMEP)) {
>   	tests++;
>   	if (set_cr4_smep(1) == GP_VECTOR) {
>               successes++;
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
