Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4917733B054
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 11:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhCOKtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 06:49:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229951AbhCOKs6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 06:48:58 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12FAYHkW119326
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 06:48:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iRtQGZ6lLC7havVE+NjaGFVVF1XfJLQ0jaI18l0G6oE=;
 b=AqZNzJedCxcKWwp1xPPJDSqhkW0Ht6QAKZdtZ0J/Ti/BiNF6BEXvg5HveRtH+1IT1I/e
 fg7X/nRmMt8NF+6d4RW8pKEgvqAKlMDTqmwuMsV8rqCmc801PQxcR/3tJAPfOYgLc6ol
 Zn8S7bgtIdAZxANH21wNhTgBGYYGQBvL4tMFnlxcdPcFDBKdwmVAX2QNLJK0L3MT65Vr
 nYZ2ShA8MBiJYGrhfx8ANgWyA/WAljYHbZTohaN3bOEEKeO+KRDFkrZxpkfuk9VaWmJi
 fP9vN6IMWNG4Y1nJmr6P5l26NAP5/kW5IxbhpGbrrAG7Cp+asp/r/cTL8icMXFoybs20 wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 379upg5rqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 06:48:57 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12FAYRV3119896
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 06:48:57 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 379upg5rpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 06:48:57 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12FAmrsa006409;
        Mon, 15 Mar 2021 10:48:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 378mnh1s59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 10:48:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12FAmqRh54264154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Mar 2021 10:48:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44987A404D;
        Mon, 15 Mar 2021 10:48:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2A52A4040;
        Mon, 15 Mar 2021 10:48:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.14.133])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Mar 2021 10:48:51 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 2/6] s390x: css: simplifications of the
 tests
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
 <1615545714-13747-3-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <2429a22a-a1f1-a995-0ca8-4f13373abb13@linux.ibm.com>
Date:   Mon, 15 Mar 2021 11:48:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1615545714-13747-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_03:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 impostorscore=0 adultscore=0 spamscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103150072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/12/21 11:41 AM, Pierre Morel wrote:
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

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/css.h     |  1 +
>  lib/s390x/css_lib.c | 41 ++++++++++++++++++++++++++---------------
>  s390x/css.c         | 15 +++++----------
>  3 files changed, 32 insertions(+), 25 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 3dc2f31..b9e4c08 100644
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
> index 3c1acbf..a97d61e 100644
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
> @@ -250,10 +265,6 @@ void css_irq_io(void)
>  		       lowcore_ptr->io_int_param, sid);
>  		goto pop;
>  	}
> -	report_info("subsys_id_word: %08x io_int_param %08x io_int_word %08x",
> -			lowcore_ptr->subsys_id_word,
> -			lowcore_ptr->io_int_param,
> -			lowcore_ptr->io_int_word);
>  	report_prefix_pop();
>  
>  	report_prefix_push("tsch");
> diff --git a/s390x/css.c b/s390x/css.c
> index 12036b3..a477833 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -25,6 +25,7 @@ static unsigned long cu_type = DEFAULT_CU_TYPE;
>  
>  static int test_device_sid;
>  static struct senseid *senseid;
> +struct ccw1 *ccw;
>  
>  static void test_enumerate(void)
>  {
> @@ -58,7 +59,6 @@ static void test_enable(void)
>   */
>  static void test_sense(void)
>  {
> -	struct ccw1 *ccw;
>  	int ret;
>  	int len;
>  
> @@ -74,18 +74,12 @@ static void test_sense(void)
>  		return;
>  	}
>  
> -	ret = register_io_int_func(css_irq_io);
> -	if (ret) {
> -		report(0, "Could not register IRQ handler");
> -		return;
> -	}
> -
>  	lowcore_ptr->io_int_param = 0;
>  
>  	senseid = alloc_io_mem(sizeof(*senseid), 0);
>  	if (!senseid) {
>  		report(0, "Allocation of senseid");
> -		goto error_senseid;
> +		return;
>  	}
>  
>  	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
> @@ -137,12 +131,13 @@ error:
>  	free_io_mem(ccw, sizeof(*ccw));
>  error_ccw:
>  	free_io_mem(senseid, sizeof(*senseid));
> -error_senseid:
> -	unregister_io_int_func(css_irq_io);
>  }
>  
>  static void css_init(void)
>  {
> +	assert(register_io_int_func(css_irq_io) == 0);
> +	lowcore_ptr->io_int_param = 0;
> +
>  	report(get_chsc_scsc(), "Store Channel Characteristics");
>  }
>  
> 

