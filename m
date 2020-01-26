Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE6B14997F
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2020 08:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgAZHQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jan 2020 02:16:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50740 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgAZHQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jan 2020 02:16:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00Q7CuM5079638;
        Sun, 26 Jan 2020 07:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=inoBrWCVL73MVCmEAR1Tf3fI1s+fcj3Ln2fJ4cwMoGA=;
 b=h4tOEH+xf0x5JJG4WFJA4+VlzcqwWdJJYQiaozesSDZvYeBLI/EtBo4ygcwLRwpbJs/H
 vRK24c9eZt5iNxuRoNJ69lrPQyaQAicFBhuIv8RU+1r4qZnok894/xt5OBCC6OSM5HG0
 xXgwK2G2Wrg6YjYP0Xa/MvJa3QXe6zjwxDJiBC6NYzQ3IpVtlGbHA+YdFp6AhMhhHbvu
 GuATH4HB36XZtk396nD9R6Z2Gj85erSuqq8VSfV3nzQWUi+cccyXZ5PcqKcLKvqlTQsX
 B9G0rSNLFpLJcZHPpYw6xrWm7ZqqC53PM66U4ggGXhEik5vAIZQ43Kkb5IEu5IJgJ0mQ ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xrdmq2ydq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 07:16:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00Q7EAnf141775;
        Sun, 26 Jan 2020 07:16:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xrytmkawp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 07:16:25 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00Q7GOkD003689;
        Sun, 26 Jan 2020 07:16:24 GMT
Received: from localhost.localdomain (/10.159.134.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jan 2020 23:16:24 -0800
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Print more (accurate) info if
 RDTSC diff test fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Aaron Lewis <aaronlewis@google.com>
References: <20200124234608.10754-1-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <705151e0-6a8b-1e15-934d-dd96f419dcd8@oracle.com>
Date:   Sat, 25 Jan 2020 23:16:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200124234608.10754-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9511 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9511 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260063
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/24/20 3:46 PM, Sean Christopherson wrote:
> Snapshot the delta of the last run and display it in the report if the
> test fails.  Abort the run loop as soon as the threshold is reached so
> that the displayed delta is guaranteed to a failed delta.  Displaying
> the delta helps triage failures, e.g. is my system completely broken or
> did I get unlucky, and aborting the loop early saves 99900 runs when
> the system is indeed broken.
>
> Cc: Nadav Amit <nadav.amit@gmail.com>
> Cc: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   x86/vmx_tests.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index b31c360..4049dec 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -9204,6 +9204,7 @@ static unsigned long long rdtsc_vmexit_diff_test_iteration(void)
>   
>   static void rdtsc_vmexit_diff_test(void)
>   {
> +	unsigned long long delta;
>   	int fail = 0;
>   	int i;
>   
> @@ -9226,17 +9227,17 @@ static void rdtsc_vmexit_diff_test(void)
>   	vmcs_write(EXI_MSR_ST_CNT, 1);
>   	vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
>   
> -	for (i = 0; i < RDTSC_DIFF_ITERS; i++) {
> -		if (rdtsc_vmexit_diff_test_iteration() >=
> -		    HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
> +	for (i = 0; i < RDTSC_DIFF_ITERS && fail < RDTSC_DIFF_FAILS; i++) {
> +		delta = rdtsc_vmexit_diff_test_iteration();
> +		if (delta >= HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
>   			fail++;
>   	}
>   
>   	enter_guest();
>   
>   	report(fail < RDTSC_DIFF_FAILS,
> -	       "RDTSC to VM-exit delta too high in %d of %d iterations",
> -	       fail, RDTSC_DIFF_ITERS);
> +	       "RDTSC to VM-exit delta too high in %d of %d iterations, last = %llu",
> +	       fail, i, delta);
>   }
>   
>   static int invalid_msr_init(struct vmcs *vmcs)
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
