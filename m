Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0737458CF6
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 23:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfF0VX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 17:23:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48850 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0VX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 17:23:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RLABfB067251;
        Thu, 27 Jun 2019 21:23:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=OG/yAtE0V66aA6eHGMhAUNMmdSTdLq6xhWm+8tHMTHo=;
 b=LeKkh7fIpnD9umHcZoOmadI46H4yaaA8jFjGJBc5EPfiH9Oa90aqaPIA7XcFdk0ko5MS
 /YPkh4nn9j6SBDpG6SXdjiBfSwOYPAW5k+XnQsU+VyDrPekAGg+RdV8bDhwpcVNXpHWk
 Q1iN2UHXk6Ybl+SRv/WWbon32//Pp2IdnCLrdrCpkegWn8VR4irMkGwVXkQ5wcOO0OJB
 A4s4FWd15sR+gZDc5SGhlsKVMc4r+hj0lOumJbEVSQSTGNKriGjIjQ0s8YeDa1ida4Az
 kvg2mJsNnciGFwPfe+pEYfhSDU7Z1aO/SJ4Q0/nEHtfm+aPozatavwpPS05sDV4azTlo hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t9c9q2hum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 21:23:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RLMti0139029;
        Thu, 27 Jun 2019 21:23:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t9p6vjh1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 21:23:20 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5RLNJRC029744;
        Thu, 27 Jun 2019 21:23:19 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Jun 2019 14:23:19 -0700
Subject: Re: [kvm-unit-tests PATCH v2] x86: Reset lapic after boot
To:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190627103937.3842-1-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <415e1969-2777-e78a-51dd-be3bd2b5cfda@oracle.com>
Date:   Thu, 27 Jun 2019 14:23:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190627103937.3842-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270245
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270244
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/27/2019 03:39 AM, Nadav Amit wrote:
> Do not assume that the local APIC is in a xAPIC mode after reset.
> Instead reset it first, since it might be in x2APIC mode, from which a
> transition in xAPIC is invalid.

s/transition in/transition to/

>
> To use reset_apic(), change it to use xapic_write(), in order to make safe to use
> while apic_ops might change concurrently by x2apic_enable().

s/x2apic_enable/enable_x2apic/

>
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   lib/x86/apic.c | 2 +-
>   x86/cstart64.S | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> index 1514730..b3e39ae 100644
> --- a/lib/x86/apic.c
> +++ b/lib/x86/apic.c
> @@ -164,7 +164,7 @@ void reset_apic(void)
>   {
>       disable_apic();
>       wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) | APIC_EN);
> -    apic_write(APIC_SPIV, 0x1ff);
> +    xapic_write(APIC_SPIV, 0x1ff);
>   }
>   
>   u32 ioapic_read_reg(unsigned reg)
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 9791282..1889c6b 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -228,6 +228,7 @@ save_id:
>   	retq
>   
>   ap_start64:
> +	call reset_apic
>   	call load_tss
>   	call enable_apic
>   	call save_id
> @@ -240,6 +241,7 @@ ap_start64:
>   	jmp 1b
>   
>   start64:
> +	call reset_apic
>   	call load_tss
>   	call mask_pic_interrupts
>   	call enable_apic

Except the above minor things,

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
