Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE468133C5
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 20:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfECS6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 14:58:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfECS6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 14:58:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43Irpas058362;
        Fri, 3 May 2019 18:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=aaYS0R/F2Led0g6rUsLVrAfDhrzQSu+G6bqQxNWeqtk=;
 b=gXkshG3Fl71QilM5cAMm9vK/ldh/3ME793FkVkkx1dqxnyvENlBYaMTVYu1CmH3jfKEl
 NIEN0XUACJ5jfGPRt3EiiHZ97YziMhvhiGWLqbwFHhaIP/VHb71hEywZQghzh14FkPqp
 Yt+cVcWy3/hBE161+xc/JOR3U9XQT9sGdFNgJ0aevdJysuQPMNcLXL0v0cRVpVZVNMpV
 EhJjw6tOl3rRsEbgS8iBqzP/24SAm+bJFWlSH0j8MCVD2Ocn3rgjjMX5CnnsadQ1+FTL
 CoD8s/5osDaJ5tfZwy+no0ELAG2+sy6QVsSUQhNPw8lOtn7rpjy2/vhER4qjPWamvgcg /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s6xj00n64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 18:57:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43Iv87F024920;
        Fri, 3 May 2019 18:57:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2s6xhhsjq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 18:57:49 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x43IvnvJ018487;
        Fri, 3 May 2019 18:57:49 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 11:57:48 -0700
Subject: Re: [PATCH v2] x86: Some cleanup of delay() and io_delay()
To:     nadav.amit@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190503111307.10716-1-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <cf379aae-07e2-cb51-745c-708f0dc02e05@oracle.com>
Date:   Fri, 3 May 2019 11:57:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190503111307.10716-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030124
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/03/2019 04:13 AM, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
>
> There is no guarantee that a self-IPI would be delivered immediately.
> In eventinj, io_delay() is called after self-IPI is generated but does
> nothing.
>
> In general, there is mess in regard to delay() and io_delay(). There are
> two definitions of delay() and they do not really look on the timestamp
> counter and instead count invocations of "pause" (or even "nop"), which
> might be different on different CPUs/setups, for example due to
> different pause-loop-exiting configurations.
>
> To address these issues change io_delay() to really do a delay, based on
> timestamp counter, and move common functions into delay.[hc].
>
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   lib/x86/delay.c | 9 ++++++---
>   lib/x86/delay.h | 7 +++++++
>   x86/eventinj.c  | 5 +----
>   x86/ioapic.c    | 8 +-------
>   4 files changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/lib/x86/delay.c b/lib/x86/delay.c
> index 595ad24..e7d2717 100644
> --- a/lib/x86/delay.c
> +++ b/lib/x86/delay.c
> @@ -1,8 +1,11 @@
>   #include "delay.h"
> +#include "processor.h"
>   
>   void delay(u64 count)
>   {
> -	while (count--)
> -		asm volatile("pause");
> -}
> +	u64 start = rdtsc();
>   
> +	do {
> +		pause();
> +	} while (rdtsc() - start < count);
> +}
> diff --git a/lib/x86/delay.h b/lib/x86/delay.h
> index a9bf894..a51eb34 100644
> --- a/lib/x86/delay.h
> +++ b/lib/x86/delay.h
> @@ -3,6 +3,13 @@
>   
>   #include "libcflat.h"
>   
> +#define IPI_DELAY 1000000
> +
>   void delay(u64 count);
>   
> +static inline void io_delay(void)
> +{
> +	delay(IPI_DELAY);
> +}
> +
>   #endif
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index d2dfc40..901b9db 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -7,6 +7,7 @@
>   #include "apic-defs.h"
>   #include "vmalloc.h"
>   #include "alloc_page.h"
> +#include "delay.h"
>   
>   #ifdef __x86_64__
>   #  define R "r"
> @@ -16,10 +17,6 @@
>   
>   void do_pf_tss(void);
>   
> -static inline void io_delay(void)
> -{
> -}
> -
>   static void apic_self_ipi(u8 v)
>   {
>   	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED |
> diff --git a/x86/ioapic.c b/x86/ioapic.c
> index 2ac4ac6..c32dabd 100644
> --- a/x86/ioapic.c
> +++ b/x86/ioapic.c
> @@ -4,6 +4,7 @@
>   #include "smp.h"
>   #include "desc.h"
>   #include "isr.h"
> +#include "delay.h"
>   
>   static void toggle_irq_line(unsigned line)
>   {
> @@ -165,13 +166,6 @@ static void test_ioapic_level_tmr(bool expected_tmr_before)
>   	       expected_tmr_before ? "true" : "false");
>   }
>   
> -#define IPI_DELAY 1000000
> -
> -static void delay(int count)
> -{
> -	while(count--) asm("");
> -}
> -
>   static void toggle_irq_line_0x0e(void *data)
>   {
>   	irq_disable();

May be the commit header can be re-worded to something like the 
following in order to summarize your changes in a better way ?


         x86: Incorporate timestamp in delay() and call the latter in 
io_delay()
