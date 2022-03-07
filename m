Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72FA4D0300
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 16:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243815AbiCGPfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 10:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241144AbiCGPfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 10:35:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C275C373;
        Mon,  7 Mar 2022 07:34:43 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227E4f57015222;
        Mon, 7 Mar 2022 15:34:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=s+0avoJIzULOPCG3lYkqugOagxGw2rl/SlAcv3Acxxc=;
 b=Z8YtPEQmPXfPNWRw9KWf5IK7JzVnoO7tW/d22SmaIdruPQ5jD24CF9LprEHEj6JRDOLm
 AzTv1tgHw+GbsniDXMLQgP1DAlO+PAwfirO+fh1zsWE0xeVW3m7d8xE6kujZ3fFEGosJ
 m7LyVIMDdTtFmx60Q7U2AkHbLRkcQ2hySKFQTODFVS5Icu1nQAINBxb8HPTOWnRSJnNB
 dA1Xi4DyeV/LvpfGgbeqH2W8koKEU4m0mnoXXA/0wGcZsWHi6SmVt4KQvQbOA2+OcmN1
 o+2gA8PwAMDYhVcB6QmBljC2u06O1aKT0FBP/ciVCbgGrFiasAg+dnK9FxgkirYgxRRR kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ene0ph0sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:42 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227EvCQm028835;
        Mon, 7 Mar 2022 15:34:42 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ene0ph0sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:42 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227FIamN007286;
        Mon, 7 Mar 2022 15:34:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3eky4hw2xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227FYb3S54198576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 15:34:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0FE8A405C;
        Mon,  7 Mar 2022 15:34:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45C7CA4054;
        Mon,  7 Mar 2022 15:34:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.106])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 15:34:37 +0000 (GMT)
Date:   Mon, 7 Mar 2022 16:31:53 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests v1 5/6] s390x: smp: Create and use a
 non-waiting CPU restart
Message-ID: <20220307163153.76e64175@p-imbrenda>
In-Reply-To: <20220303210425.1693486-6-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
        <20220303210425.1693486-6-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OAc2TF37blX8qz7wSrOb6L1PXbi1aeOr
X-Proofpoint-GUID: FR7DzWnnA2_K0QGI4mXEEskyx0YF8jp6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_05,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203070090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Mar 2022 22:04:24 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> The kvm-unit-tests infrastructure for a CPU restart waits for the
> SIGP RESTART to complete. In order to test the restart itself,
> create a variation that does not wait, and test the state of the
> CPU directly.
> 
> While here, add some better report prefixes/messages, to clarify
> which condition is being examined (similar to test_stop_store_status()).
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  lib/s390x/smp.c | 22 ++++++++++++++++++++++
>  lib/s390x/smp.h |  1 +
>  s390x/smp.c     | 18 +++++++++++++++---
>  3 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 84e536e8..85b046a5 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -192,6 +192,28 @@ int smp_cpu_restart(uint16_t idx)
>  	return rc;
>  }
>  
> +/*
> + * Functionally equivalent to smp_cpu_restart(), but without the
> + * elements that wait/serialize matters here in the test.
> + * Used to see if KVM itself is serialized correctly.
> + */
> +int smp_cpu_restart_nowait(uint16_t idx)
> +{
> +	spin_lock(&lock);
> +
> +	/* Don't suppress a CC2 with sigp_retry() */
> +	if (smp_sigp(idx, SIGP_RESTART, 0, NULL)) {
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
>  int smp_cpu_start(uint16_t idx, struct psw psw)
>  {
>  	int rc;
> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> index bae03dfd..24a0e2e0 100644
> --- a/lib/s390x/smp.h
> +++ b/lib/s390x/smp.h
> @@ -42,6 +42,7 @@ uint16_t smp_cpu_addr(uint16_t idx);
>  bool smp_cpu_stopped(uint16_t idx);
>  bool smp_sense_running_status(uint16_t idx);
>  int smp_cpu_restart(uint16_t idx);
> +int smp_cpu_restart_nowait(uint16_t idx);
>  int smp_cpu_start(uint16_t idx, struct psw psw);
>  int smp_cpu_stop(uint16_t idx);
>  int smp_cpu_stop_nowait(uint16_t idx);
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 11c2c673..03160b80 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -55,23 +55,35 @@ static void test_restart(void)
>  	struct cpu *cpu = smp_cpu_from_idx(1);
>  	struct lowcore *lc = cpu->lowcore;
>  
> +	report_prefix_push("restart");
> +	report_prefix_push("stopped");
> +
>  	lc->restart_new_psw.mask = extract_psw_mask();
>  	lc->restart_new_psw.addr = (unsigned long)test_func;
>  
>  	/* Make sure cpu is stopped */
>  	smp_cpu_stop(1);
>  	set_flag(0);
> -	smp_cpu_restart(1);
> +	smp_cpu_restart_nowait(1);
> +	report(!smp_cpu_stopped(1), "cpu started");

can this check ^ race?
we are using the flag to check if the CPU actually restarts, right?

>  	wait_for_flag();
> +	report_pass("test flag");
> +
> +	report_prefix_pop();
> +	report_prefix_push("running");
>  
>  	/*
>  	 * Wait until cpu 1 has set the flag because it executed the
>  	 * restart function.
>  	 */
>  	set_flag(0);
> -	smp_cpu_restart(1);
> +	smp_cpu_restart_nowait(1);
> +	report(!smp_cpu_stopped(1), "cpu started");

same here

>  	wait_for_flag();
> -	report_pass("restart while running");
> +	report_pass("test flag");
> +
> +	report_prefix_pop();
> +	report_prefix_pop();
>  }
>  
>  static void test_stop(void)

