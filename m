Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E6B1A59E
	for <lists+kvm@lfdr.de>; Sat, 11 May 2019 01:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfEJXhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 19:37:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfEJXha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 19:37:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4ANTOge182987;
        Fri, 10 May 2019 23:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=0MqO0TD36Y2lDZZN4w/204ChVQjLqocYmEsg4KwryYk=;
 b=WpJXP4rKA8KFW6nFR3ST8GMoiLK4KpK8D/xLnNhKncgL7A6zCTDhY9l9MCTc5cx+Gdl7
 CTwa5L/salUTwKX1ybQJ9hEG5x3Scfg1AVOrZmSgCxXe/r4cQaYEFIAxODL1Q5HkNkZy
 rC9GmPGhwvmQXCNIThgl9o+i1mJMR+g43olYFWbJP7/awI2rI17q+sE5+qiyE3N6EByM
 6Ls8PVcHjO0kL6wj1wrOxIgwetcdDt2Nf5kLThq54GUhU10UmriOhnE+X6/TOkUE8r5t
 1Dfx7L7NOyTXkCP2RVCi/tToMpi3XT9IdZRZxAFWDtTdY/uJSCgMQ0Ya8Dfytn1kvjgM ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2s94b1bwpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 23:37:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4ANbHWe146867;
        Fri, 10 May 2019 23:37:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2sdgdv9r10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 23:37:17 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4ANbHcW024590;
        Fri, 10 May 2019 23:37:17 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 May 2019 16:37:16 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: Set "APIC Software Enable" after APIC
 reset
To:     nadav.amit@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190502140856.4136-1-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <653454de-11d5-4341-940e-7fdfdd8545ae@oracle.com>
Date:   Fri, 10 May 2019 16:37:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190502140856.4136-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9253 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=957
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905100147
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9253 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=986 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905100147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/02/2019 07:08 AM, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
>
> After the APIC is reset, some of its registers might be reset. As the
> SDM says: "When IA32_APIC_BASE[11] is set to 0, prior initialization to
> the APIC may be lost and the APIC may return to the state described in
> Section 10.4.7.1". The SDM also says that after APIC reset "the
> spurious-interrupt vector register is initialized to 000000FFH". This
> means that after the APIC is reset it needs to be software-enabled
> through the SPIV.
>
> This is done one occasion, but there are (at least) two occasions that
> do not software-enable the APIC after reset (__test_apic_id() and main()
> in vmx.c).
>
> Move APIC SPIV reinitialization into reset_apic(). Remove SPIV settings
> which are unnecessary after reset_apic() is modified.
>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   lib/x86/apic.c | 1 +
>   x86/apic.c     | 1 -
>   2 files changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> index 2aeffbd..4e7d43c 100644
> --- a/lib/x86/apic.c
> +++ b/lib/x86/apic.c
> @@ -161,6 +161,7 @@ void reset_apic(void)
>   {
>       disable_apic();
>       wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) | APIC_EN);
> +    apic_write(APIC_SPIV, 0x1ff);
>   }
>   
>   u32 ioapic_read_reg(unsigned reg)
> diff --git a/x86/apic.c b/x86/apic.c
> index 3eff588..7ef4a27 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -148,7 +148,6 @@ static void test_apic_disable(void)
>       verify_disabled_apic_mmio();
>   
>       reset_apic();
> -    apic_write(APIC_SPIV, 0x1ff);
>       report("Local apic enabled in xAPIC mode",
>   	   (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN);
>       report("CPUID.1H:EDX.APIC[bit 9] is set", cpuid(1).d & (1 << 9));

While you are at it, would you mind replacing "0xf0" with APIC_SPIV in 
enable_apic() also ?

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
