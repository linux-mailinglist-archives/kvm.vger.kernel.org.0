Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A5813335
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfECRi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:38:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38156 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbfECRi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:38:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43HYGqx190388;
        Fri, 3 May 2019 17:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=BPK+mmNadEMzrxKAsc0F67yELFWfIMgBesMwTZMObRM=;
 b=JncBPmGfiFIedxxuD92giSFULgQ7yX29EgQj4/G3ri3bgpwz1FgwN4aaA9SnSgYypIx6
 iXrkEkBrlxLNalzKwh4/9DqcWV561JT3BOWdhaUZct0ioqnRwszd6EuKAGmbyXNI2YJI
 F2lOur4dCOqLqSx4WRHhaLagkHoCkn206KOjijQLvGpDt2wdrfFs6o7hg1Kp+S97lkum
 +b3/D8c826Rs2Q0EeKKBeZnbF64RNDwyNrXBRaTPafFWJmFsFdF7wjDaz34ndiRUhfqn
 OETMQEdzDSiMI1Mdi9CILoJ7eoADPxlCCddvyi0RNGIDwvCaifPj0SgP0qWHd7Ir0Yiq PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2s6xj0094r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 17:38:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43HaqCn104449;
        Fri, 3 May 2019 17:38:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2s6xhhgbsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 17:38:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x43HccWi021136;
        Fri, 3 May 2019 17:38:38 GMT
Received: from [10.159.140.243] (/10.159.140.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 10:38:38 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: eventinj: Do a real io_delay()
To:     nadav.amit@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190502184913.10138-1-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <57fcfc11-ec47-8f54-a6d2-e40a706e3a71@oracle.com>
Date:   Fri, 3 May 2019 10:38:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190502184913.10138-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030114
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/2/19 11:49 AM, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
>
> There is no guarantee that a self-IPI would be delivered immediately.
> io_delay() is called after self-IPI is generated but does nothing.
> Instead, change io_delay() to wait for 10000 cycles, which should be
> enough on any system whatsoever.
>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   x86/eventinj.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index 8064eb9..250537b 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -18,6 +18,11 @@ void do_pf_tss(void);
>   
>   static inline void io_delay(void)
>   {
> +	u64 start = rdtsc();
> +
> +	do {
> +		pause();
> +	} while (rdtsc() - start < 10000);
>   }
>   
>   static void apic_self_ipi(u8 v)

Perhaps call delay() (in delay.c)  inside of io_delay() OR perhaps 
replace all instances of io_delay() with delay() ?


