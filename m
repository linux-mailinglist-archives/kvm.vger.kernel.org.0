Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957B73281A7
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbhCAPBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 10:01:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236758AbhCAPBc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 10:01:32 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121EXuoI042690
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 10:00:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FLwHNqd2huNFXEEov7M9AsY356c5R1RAXm/zBwdxQQA=;
 b=cNWBS7T1KQPybCEr4X3v4oAgcsQbnKBh8HjU6USoSPg4KgtiduvwDNVHfAB3oh33nIBD
 V+tUOnihlGvtE6XAQhldFQEsbWIvk18jOc0orGtSxRE1ILI3L9vw0BIxYeL66WQEApFA
 JKPtH+HuaZRdUW324HAHZXrzPlD+KHkoEwaB5INomxBe/W0tN9fuIEhFAi6u12HqFGha
 EvULBWV62URTZ+4YHFohKGClmoN288tt4UD8kZj4DMQFstvyJv2QBfGjj/TykBYQNOlA
 8w/LNbIQPa/Wc5XUT0NGQxlRAyU8bj62sirdSroOwwMBb5Jm3FKiq+4Ti0Ww75uedLsy LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3710ffmwj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 10:00:50 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121EZZao053552
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 10:00:49 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3710ffmwg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 10:00:49 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121ExUDv031391;
        Mon, 1 Mar 2021 15:00:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 371162g125-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 15:00:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121F0iwV65601860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 15:00:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF9E15205A;
        Mon,  1 Mar 2021 15:00:43 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.190.79])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 97B0D52050;
        Mon,  1 Mar 2021 15:00:43 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-3-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 2/6] s390x: css: simplifications of the
 tests
Message-ID: <70bbccca-6372-ee9a-37ae-913f5cc6a700@linux.ibm.com>
Date:   Mon, 1 Mar 2021 16:00:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614599225-17734-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_08:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103010123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/21 12:47 PM, Pierre Morel wrote:
> In order to ease the writing of tests based on:
> - interrupt
> - enabling a subchannel
> - using multiple I/O on a channel without disabling it
> 
> We do the following simplifications:
> - the I/O interrupt handler is registered on CSS initialization
> - We do not enable again a subchannel in senseid if it is already
>   enabled
> - we add a css_enabled() function to test if a subchannel is enabled
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/css.h     |  1 +
>  lib/s390x/css_lib.c | 37 ++++++++++++++++++++++++++-----------
>  s390x/css.c         | 44 ++++++++++++++++++++++++--------------------
>  3 files changed, 51 insertions(+), 31 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 4210472..fbfa034 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -278,6 +278,7 @@ int css_enumerate(void);
>  
>  #define IO_SCH_ISC      3
>  int css_enable(int schid, int isc);
> +bool css_enabled(int schid);
>  
>  /* Library functions */
>  int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index f46e871..41134dc 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -161,6 +161,31 @@ out:
>  	return schid;
>  }
>  
> +/*
> + * css_enabled: report if the subchannel is enabled
> + * @schid: Subchannel Identifier
> + * Return value:
> + *   true if the subchannel is enabled
> + *   false otherwise
> + */
> +bool css_enabled(int schid)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int cc;
> +
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: updating sch %08x failed with cc=%d",
> +			    schid, cc);
> +		return false;
> +	}
> +
> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> +		report_info("stsch: sch %08x not enabled", schid);
> +		return false;
> +	}
> +	return true;
> +}
>  /*
>   * css_enable: enable the subchannel with the specified ISC
>   * @schid: Subchannel Identifier
> @@ -210,18 +235,8 @@ retry:
>  	/*
>  	 * Read the SCHIB again to verify the enablement
>  	 */
> -	cc = stsch(schid, &schib);
> -	if (cc) {
> -		report_info("stsch: updating sch %08x failed with cc=%d",
> -			    schid, cc);
> -		return cc;
> -	}
> -
> -	if ((pmcw->flags & flags) == flags) {
> -		report_info("stsch: sch %08x successfully modified after %d retries",
> -			    schid, retry_count);
> +	if (css_enabled(schid))
>  		return 0;
> -	}
>  
>  	if (retry_count++ < MAX_ENABLE_RETRIES) {
>  		mdelay(10); /* the hardware was not ready, give it some time */
> diff --git a/s390x/css.c b/s390x/css.c
> index 09703c1..c9e4903 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -56,36 +56,27 @@ static void test_enable(void)
>   * - We need the test device as the first recognized
>   *   device by the enumeration.
>   */
> -static void test_sense(void)
> +static bool do_test_sense(void)
>  {
>  	struct ccw1 *ccw;
> +	bool success = false;

That is a very counter-intuitive name, something like "retval" might be
better.
You're free to use the normal int returns but unfortunately you can't
use the E* error constants like ENOMEM.

>  	int ret;
>  	int len;
>  
>  	if (!test_device_sid) {
>  		report_skip("No device");
> -		return;
> +		return success;
>  	}
>  
> -	ret = css_enable(test_device_sid, IO_SCH_ISC);
> -	if (ret) {
> -		report(0, "Could not enable the subchannel: %08x",
> -		       test_device_sid);
> -		return;
> +	if (!css_enabled(test_device_sid)) {
> +		report(0, "enabling subchannel %08x", test_device_sid);
> +		return success;
>  	}
>  
> -	ret = register_io_int_func(css_irq_io);
> -	if (ret) {
> -		report(0, "Could not register IRQ handler");
> -		return;
> -	}
> -
> -	lowcore_ptr->io_int_param = 0;
> -
>  	senseid = alloc_io_mem(sizeof(*senseid), 0);
>  	if (!senseid) {
>  		report(0, "Allocation of senseid");
> -		goto error_senseid;
> +		return success;
>  	}
>  
>  	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
> @@ -129,21 +120,34 @@ static void test_sense(void)
>  	report_info("reserved 0x%02x cu_type 0x%04x cu_model 0x%02x dev_type 0x%04x dev_model 0x%02x",
>  		    senseid->reserved, senseid->cu_type, senseid->cu_model,
>  		    senseid->dev_type, senseid->dev_model);
> +	report_info("cu_type expected 0x%04x got 0x%04x", (uint16_t)cu_type,
> +		    senseid->cu_type);
>  
> -	report(senseid->cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
> -	       (uint16_t)cu_type, senseid->cu_type);
> +	success = senseid->cu_type == cu_type;
>  
>  error:
>  	free_io_mem(ccw, sizeof(*ccw));
>  error_ccw:
>  	free_io_mem(senseid, sizeof(*senseid));
> -error_senseid:
> -	unregister_io_int_func(css_irq_io);
> +	return success;
> +}
> +
> +static void test_sense(void)
> +{
> +	report(do_test_sense(), "Got CU type expected");
>  }
>  
>  static void css_init(void)
>  {
>  	report(!!get_chsc_scsc(), "Store Channel Characteristics");
> +
> +	if (register_io_int_func(css_irq_io)) {
> +		report(0, "Could not register IRQ handler");
> +		return;

assert() please

> +	}
> +	lowcore_ptr->io_int_param = 0> +
> +	report(1, "CSS initialized");
>  }
>  
>  static struct {
> 

