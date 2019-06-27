Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E0A578D8
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 03:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfF0BIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 21:08:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfF0BIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 21:08:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5R14xS7188474;
        Thu, 27 Jun 2019 01:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=CeLLz03ZgSO0Ksp8Dbp0fH75miUBXWgEiH4GER/2PKk=;
 b=s+4vT1E84GpYWG0GkoB/55zu2xUxEowReYbOcwXxfe3BaE1tF/XwZrAkdRhRqIdGqtoq
 lBd1ChhrI/A9OLLV4CPDmMUDCVYKnTjrGy37NDygYHHsUbmbcvThwrQB6Ym4XhmTu+QS
 E0E6eckHl/0yTWjbvK4WgHRrjh0LrjWzi2X6kACgCrEizXZC3OJTehCztaezOhF57XQw
 NHyQsoO0RnVyQZAMxW13BQ6npvcLVySO52Z2NlZmK8zBhJIXtbr7uxbZ/rW+7tG75Qq1
 oERT0vtj79nkhic0YahYhQB+AXuy0mQ/BI8jAV/tEkhgqcvQTv7xofjFPiJm/r1bsz4x yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t9brtdcgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 01:07:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5R17dH0052674;
        Thu, 27 Jun 2019 01:07:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2t9acd00x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 01:07:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5R17ZaM028475;
        Thu, 27 Jun 2019 01:07:35 GMT
Received: from localhost.localdomain (/10.159.235.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 18:07:35 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: Memory barrier before setting ICR
To:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190625125836.9149-1-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <e7ff39ef-5d09-6aa0-a3ac-e23707355e99@oracle.com>
Date:   Wed, 26 Jun 2019 18:07:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190625125836.9149-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=895
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=963 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270010
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/25/19 5:58 AM, Nadav Amit wrote:
> The wrmsr that is used in x2apic ICR programming does not behave as a
> memory barrier. There is a hidden assumption that it is. Add an explicit
> memory barrier for this reason.
>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   lib/x86/apic.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> index bc2706e..1514730 100644
> --- a/lib/x86/apic.c
> +++ b/lib/x86/apic.c
> @@ -2,6 +2,7 @@
>   #include "apic.h"
>   #include "msr.h"
>   #include "processor.h"
> +#include "asm/barrier.h"
>   
>   void *g_apic = (void *)0xfee00000;
>   void *g_ioapic = (void *)0xfec00000;
> @@ -71,6 +72,7 @@ static void x2apic_write(unsigned reg, u32 val)
>   
>   static void x2apic_icr_write(u32 val, u32 dest)
>   {
> +    mb();
>       asm volatile ("wrmsr" : : "a"(val), "d"(dest),
>                     "c"(APIC_BASE_MSR + APIC_ICR/16));
>   }


Regarding non-serializing forms, the SDM mentions,

         "X2APIC MSRs (MSR indices 802H to 83FH)"


(APIC_BASE_MSR + APIC_ICR/16) is a different value. So I am wondering 
why we need a barrier here.

