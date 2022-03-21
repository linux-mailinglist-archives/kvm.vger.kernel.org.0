Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B434E2182
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 08:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345006AbiCUHp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 03:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344992AbiCUHp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 03:45:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CA343398;
        Mon, 21 Mar 2022 00:44:02 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L6fm2Z012413;
        Mon, 21 Mar 2022 07:44:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V5bm0JNVJs0ckvi/rt9pA8J84CPffrZEwfkMCgr1BSk=;
 b=Md5dgVwCbCvPjxQIhJ781Szu+aAExug149rgCUdvIhX8TNiu8WFxh8Q+ssjhG5k4cTce
 mS2Ef08dR+5T5UEip5yAZApJMin0UPJcvJO9dlVapiX/WaaL1qhDLVr5ySjP74FsztS8
 ycXE9hWfg1Q0rrUUoTQ3P7Qf+nLrtCJ+diJnw8iBqo4qx6RnYvtJ1SJfbuZ3FFGGYtNG
 78/mdEPXZuastyCb4nFUNUyF2hdQumxrnLI5v9onwhB2nyHCyX5q/b2xk7n4LuB5VvLs
 +SvBhKplrepP/IDWC8d1dGWC2ozJr+6Dfa4kF1sLjMKRvWbS4yugli/JkaB8TwXImef3 Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exmaq1gj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 07:44:01 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22L7ePcp016332;
        Mon, 21 Mar 2022 07:44:01 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exmaq1ghn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 07:44:01 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22L7h0Ob007020;
        Mon, 21 Mar 2022 07:43:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3ew6t9aueu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 07:43:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22L7WHWS30278098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 07:32:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E4DF11C04A;
        Mon, 21 Mar 2022 07:43:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5899211C054;
        Mon, 21 Mar 2022 07:43:55 +0000 (GMT)
Received: from [9.145.46.50] (unknown [9.145.46.50])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 07:43:55 +0000 (GMT)
Message-ID: <13970909-52c2-bb3d-3cfd-0c97100edb04@linux.ibm.com>
Date:   Mon, 21 Mar 2022 08:43:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH kvm-unit-tests v2 5/6] s390x: smp: Create and use a
 non-waiting CPU restart
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220311173822.1234617-1-farman@linux.ibm.com>
 <20220311173822.1234617-6-farman@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220311173822.1234617-6-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -GntR27Xi8LvyyGLZRL_qlxel9dubeX2
X-Proofpoint-GUID: XupxjxxLT4rqZ5J6ty1nVZb0D_7SVdu9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_02,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210049
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/11/22 18:38, Eric Farman wrote:
> The kvm-unit-tests infrastructure for a CPU restart waits for the
> SIGP RESTART to complete. In order to test the restart itself,
> create a variation that does not wait, and test the state of the
> CPU directly.
> 
> While here, add some better report prefixes/messages, to clarify
> which condition is being examined (similar to test_stop_store_status()).
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   lib/s390x/smp.c | 24 ++++++++++++++++++++++++
>   lib/s390x/smp.h |  1 +
>   s390x/smp.c     | 21 ++++++++++++++++++---
>   3 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index b69c0e09..5be29d36 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -194,6 +194,30 @@ int smp_cpu_restart(uint16_t idx)
>   	return rc;
>   }
>   
> +/*
> + * Functionally equivalent to smp_cpu_restart(), but without the
> + * elements that wait/serialize matters here in the test.
> + * Used to see if KVM itself is serialized correctly.
> + */
> +int smp_cpu_restart_nowait(uint16_t idx)
> +{
> +	check_idx(idx);
> +
> +	spin_lock(&lock);
> +
> +	/* Don't suppress a CC2 with sigp_retry() */
> +	if (sigp(cpus[idx].addr, SIGP_RESTART, 0, NULL)) {
> +		spin_unlock(&lock);
> +		return -1;
> +	}
> +
> +	cpus[idx].active = true;
> +
> +	spin_unlock(&lock);
> +
> +	return 0;
> +}
> +
>   int smp_cpu_start(uint16_t idx, struct psw psw)
>   {
>   	int rc;
> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> index bae03dfd..24a0e2e0 100644
> --- a/lib/s390x/smp.h
> +++ b/lib/s390x/smp.h
> @@ -42,6 +42,7 @@ uint16_t smp_cpu_addr(uint16_t idx);
>   bool smp_cpu_stopped(uint16_t idx);
>   bool smp_sense_running_status(uint16_t idx);
>   int smp_cpu_restart(uint16_t idx);
> +int smp_cpu_restart_nowait(uint16_t idx);
>   int smp_cpu_start(uint16_t idx, struct psw psw);
>   int smp_cpu_stop(uint16_t idx);
>   int smp_cpu_stop_nowait(uint16_t idx);
> diff --git a/s390x/smp.c b/s390x/smp.c
> index f70a9c54..913da155 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -54,6 +54,10 @@ static void test_restart(void)
>   {
>   	struct cpu *cpu = smp_cpu_from_idx(1);
>   	struct lowcore *lc = cpu->lowcore;
> +	int rc;
> +
> +	report_prefix_push("restart");
> +	report_prefix_push("stopped");
>   
>   	lc->restart_new_psw.mask = extract_psw_mask();
>   	lc->restart_new_psw.addr = (unsigned long)test_func;
> @@ -61,17 +65,28 @@ static void test_restart(void)
>   	/* Make sure cpu is stopped */
>   	smp_cpu_stop(1);
>   	set_flag(0);
> -	smp_cpu_restart(1);
> +	rc = smp_cpu_restart_nowait(1);
> +	report(!rc, "return code");
> +	report(!smp_cpu_stopped(1), "cpu started");
>   	wait_for_flag();
> +	report_pass("test flag");
> +
> +	report_prefix_pop();
> +	report_prefix_push("running");
>   
>   	/*
>   	 * Wait until cpu 1 has set the flag because it executed the
>   	 * restart function.
>   	 */
>   	set_flag(0);
> -	smp_cpu_restart(1);
> +	rc = smp_cpu_restart_nowait(1);
> +	report(!rc, "return code");
> +	report(!smp_cpu_stopped(1), "cpu started");
>   	wait_for_flag();
> -	report_pass("restart while running");
> +	report_pass("test flag");
> +
> +	report_prefix_pop();
> +	report_prefix_pop();
>   }
>   
>   static void test_stop(void)

