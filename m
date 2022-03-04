Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1254CD2B0
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbiCDKov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236219AbiCDKoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:44:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614A51AC283;
        Fri,  4 Mar 2022 02:43:57 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224AIkgc030791;
        Fri, 4 Mar 2022 10:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FV0TR5RNGkV+7yDY3nJtq0Dfxl911E50swznrSKkj5E=;
 b=IYsr5pwB7+t+UsctdlmRmDej9QhunCNu1257g/F5LcGSrmZSow5mvMZ2FEcEa1uGOdyY
 jGDyvoXbQNEyalv6KHIFo6TFGOHlrgXEqQSXJFeRLizxqxQ7JrCqM17R3SBHDnAcb/5I
 4kwCiC7LMb9XqMbCtmfzY7Q8ECTVFrhx0U0qTKz6o5Evw3Euq7PsrMap2DDRNvIGMnsL
 KrczOBE0gMF3miK6R6TwnqVbtL/cPF8BO2Ul6QGZWzgPKv15ODYJhqZDiA0QQsWxiLOg
 sAwk33qPqY0Di6WHsy9xKZaPHGDxAajkihfYnRZe0CZ/8qRFjE8PXXiF1O5p6AC6BEdZ 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekgwgrdge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 10:43:56 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224AUOh4012366;
        Fri, 4 Mar 2022 10:43:56 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekgwgrdg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 10:43:56 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 224AhPvA008294;
        Fri, 4 Mar 2022 10:43:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3ek4k4h97s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 10:43:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 224Ahomv38535512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 10:43:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD32B42042;
        Fri,  4 Mar 2022 10:43:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89F1D4203F;
        Fri,  4 Mar 2022 10:43:50 +0000 (GMT)
Received: from [9.145.58.173] (unknown [9.145.58.173])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Mar 2022 10:43:50 +0000 (GMT)
Message-ID: <6f8205e1-7a79-77dc-12b6-30294398d29b@linux.ibm.com>
Date:   Fri, 4 Mar 2022 11:43:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH kvm-unit-tests v1 2/6] s390x: smp: Test SIGP RESTART
 against stopped CPU
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220303210425.1693486-1-farman@linux.ibm.com>
 <20220303210425.1693486-3-farman@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220303210425.1693486-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q3IdIeM9KLlwAvBt5Uilm7LB5MBLhJ17
X-Proofpoint-ORIG-GUID: FzaMb2bvwMCPh4UNihssYdxEknTdwIm4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_02,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/22 22:04, Eric Farman wrote:
> test_restart() makes two smp_cpu_restart() calls against CPU 1.
> It claims to perform both of them against running (operating) CPUs,
> but the first invocation tries to achieve this by calling
> smp_cpu_stop() to CPU 0. This will be rejected by the library.

I played myself there :)

> 
> Let's fix this by making the first restart operate on a stopped CPU,
> to ensure it gets test coverage instead of relying on other callers.
> 
> Fixes: 166da884d ("s390x: smp: Add restart when running test")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>


If you want to you can add a report_pass() after the first wait flag.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/smp.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 068ac74d..2f4af820 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -50,10 +50,6 @@ static void test_start(void)
>   	report_pass("start");
>   }
>   
> -/*
> - * Does only test restart when the target is running.
> - * The other tests do restarts when stopped multiple times already.
> - */
>   static void test_restart(void)
>   {
>   	struct cpu *cpu = smp_cpu_from_idx(1);
> @@ -62,8 +58,8 @@ static void test_restart(void)
>   	lc->restart_new_psw.mask = extract_psw_mask();
>   	lc->restart_new_psw.addr = (unsigned long)test_func;
>   
> -	/* Make sure cpu is running */
> -	smp_cpu_stop(0);
> +	/* Make sure cpu is stopped */
> +	smp_cpu_stop(1);
>   	set_flag(0);
>   	smp_cpu_restart(1);
>   	wait_for_flag();

