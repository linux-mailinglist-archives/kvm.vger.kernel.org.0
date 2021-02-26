Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F49326088
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 10:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhBZJwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 04:52:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230446AbhBZJvB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 04:51:01 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11Q9WxZP162987
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 04:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5t27a+6o//nI3H2Z4aN4OUjKi2Yk/b9VXDPYzhaK4MA=;
 b=ttR4ARquenCXC/vusCsvA5N7tdyHOUJlJrDAkx5FVXk92XT13NBSCTHrf3gdgJC+vHw9
 d2aabqWyEIdKxKPRMvxTM6qDSATmtnU7tkhR+yBMk303CxUvfIB7BYQueVajOlxlUofK
 nYqJl3HTKKq2Q5AcvYjgUJ4FanwY+1lJ3Zxd/kxw1TY2wTe4df6Si18o5gUzOgGHbPWt
 BrvQ37Xe7uyTnryO/zwak61S7eCMIKKdHv6G3wxwqqvam+Ly55+hFGd0rH89nM0JMVtK
 widW2BRplPEUHxfbgNCwtLK9xgdcODId7v5VqSSJNyQwV/ZX8reqzQGt13VPEutJkVr8 xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36xtfyf0ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 04:50:20 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11Q9XAgG164293
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 04:50:20 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36xtfyf0xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 04:50:20 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11Q9mXu3016122;
        Fri, 26 Feb 2021 09:50:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 36tt28d5aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 09:50:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11Q9oFal35520890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 09:50:15 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85E4911C04C;
        Fri, 26 Feb 2021 09:50:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26B7711C052;
        Fri, 26 Feb 2021 09:50:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.91.176])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Feb 2021 09:50:15 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
 <1613669204-6464-2-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/5] s390x: css: Store CSS
 Characteristics
Message-ID: <6577ebb9-5f61-e70a-cf72-4f428b9db4f4@linux.ibm.com>
Date:   Fri, 26 Feb 2021 10:50:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1613669204-6464-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-26_02:2021-02-24,2021-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/21 6:26 PM, Pierre Morel wrote:
> CSS characteristics exposes the features of the Channel SubSystem.
> Let's use Store Channel Subsystem Characteristics to retrieve
> the features of the CSS.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/css.h     |  67 +++++++++++++++++++++++++++
>  lib/s390x/css_lib.c | 110 +++++++++++++++++++++++++++++++++++++++++++-
>  s390x/css.c         |  12 +++++
>  3 files changed, 188 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 3e57445..49daecd 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -288,4 +288,71 @@ int css_residual_count(unsigned int schid);
>  void enable_io_isc(uint8_t isc);
>  int wait_and_check_io_completion(int schid);
>  
> +/*
> + * CHSC definitions
> + */
> +struct chsc_header {
> +	u16 len;
> +	u16 code;

uint*_t types please

> +};
> +
> +/* Store Channel Subsystem Characteristics */
> +struct chsc_scsc {
> +	struct chsc_header req;
> +	u16 req_fmt;
> +	u8 cssid;
> +	u8 res_03;
> +	u32 res_04[2];
> +	struct chsc_header res;
> +	u32 res_fmt;
> +	u64 general_char[255];
> +	u64 chsc_char[254];
> +};
> +
> +extern struct chsc_scsc *chsc_scsc;
> +#define CHSC_SCSC	0x0010
> +#define CHSC_SCSC_LEN	0x0010
> +
> +int get_chsc_scsc(void);
> +
> +#define CSS_GENERAL_FEAT_BITLEN	(255 * 64)
> +#define CSS_CHSC_FEAT_BITLEN	(254 * 64)
> +
> +#define CHSC_SCSC	0x0010
> +#define CHSC_SCSC_LEN	0x0010
> +
> +#define CHSC_ERROR	0x0000
> +#define CHSC_RSP_OK	0x0001
> +#define CHSC_RSP_INVAL	0x0002
> +#define CHSC_RSP_REQERR	0x0003
> +#define CHSC_RSP_ENOCMD	0x0004
> +#define CHSC_RSP_NODATA	0x0005
> +#define CHSC_RSP_SUP31B	0x0006
> +#define CHSC_RSP_EFRMT	0x0007
> +#define CHSC_RSP_ECSSID	0x0008
> +#define CHSC_RSP_ERFRMT	0x0009
> +#define CHSC_RSP_ESSID	0x000A
> +#define CHSC_RSP_EBUSY	0x000B
> +#define CHSC_RSP_MAX	0x000B
> +
> +static inline int _chsc(void *p)
> +{
> +	int cc;
> +
> +	asm volatile(" .insn   rre,0xb25f0000,%2,0\n"
> +		     " ipm     %0\n"
> +		     " srl     %0,28\n"
> +		     : "=d" (cc), "=m" (p)
> +		     : "d" (p), "m" (p)
> +		     : "cc");
> +
> +	return cc;
> +}
> +
> +int chsc(void *p, uint16_t code, uint16_t len);
> +
> +#include <bitops.h>
> +#define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
> +#define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
> +
>  #endif
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 3c24480..64560a2 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -15,11 +15,119 @@
>  #include <asm/arch_def.h>
>  #include <asm/time.h>
>  #include <asm/arch_def.h>
> -
> +#include <alloc_page.h>
>  #include <malloc_io.h>
>  #include <css.h>
>  
>  static struct schib schib;
> +struct chsc_scsc *chsc_scsc;
> +
> +static const char * const chsc_rsp_description[] = {
> +	"CHSC unknown error",
> +	"Command executed",
> +	"Invalid command",
> +	"Request-block error",
> +	"Command not installed",
> +	"Data not available",
> +	"Absolute address of channel-subsystem communication block exceeds 2G - 1.",
> +	"Invalid command format",
> +	"Invalid channel-subsystem identification (CSSID)",
> +	"The command-request block specified an invalid format for the command response block.",
> +	"Invalid subchannel-set identification (SSID)",
> +	"A busy condition precludes execution.",
> +};
> +
> +static int check_response(void *p)
> +{
> +	struct chsc_header *h = p;
> +
> +	if (h->code == CHSC_RSP_OK) {
> +		report(1, "CHSC command completed.");

I'm not a big fan of using integer constants for boolean type arguments.

> +		return 0;
> +	}
> +	if (h->code > CHSC_RSP_MAX)
> +		h->code = 0;
> +	report(0, "Response code %04x: %s", h->code, chsc_rsp_description[h->code]);
> +	return -1;
> +}
> +
> +int chsc(void *p, uint16_t code, uint16_t len)
> +{
> +	struct chsc_header *h = p;
> +	int cc;
> +
> +	report_prefix_push("Channel Subsystem Call");
> +	h->code = code;
> +	h->len = len;
> +	cc = _chsc(p);
> +	switch (cc) {
> +	case 3:
> +		report(0, "Subchannel invalid or not enabled.");
> +		break;
> +	case 2:
> +		report(0, "CHSC subchannel busy.");
> +		break;
> +	case 1:
> +		report(0, "Subchannel invalid or not enabled.");
> +		break;

I don't think that this is how we want to handle error reporting in lib
files.

Please don't use report for library error reporting if it's not needed.

Most of the times you should return an error code or simply
abort()/assert() if for instance a library init function fails and you
can assume that most of the test code is dependent on that librarie's
initialization. Sometimes report_abort() is also ok.

Test code should not be part of the library if possible!


> +	case 0:
> +		cc = check_response(p + len);
> +		break;
> +	}
> +
> +	report_prefix_pop();
> +	return cc;
> +}
> +
> +int get_chsc_scsc(void)
> +{
> +	int i, n;
> +	int ret = 0;
> +	char buffer[510];
> +	char *p;
> +
> +	report_prefix_push("Channel Subsystem Call");
> +
> +	if (chsc_scsc) {
> +		report_info("chsc_scsc already initialized");
> +		goto end;
> +	}
> +
> +	chsc_scsc = alloc_page();
> +	report_info("scsc_scsc at: %016lx", (u64)chsc_scsc);
> +	if (!chsc_scsc) {
> +		ret = -1;
> +		report(0, "could not allocate chsc_scsc page!");
> +		goto end;
> +	}
> +
> +	report_info("scsc format %x\n", chsc_scsc->req_fmt);
> +	ret = chsc(chsc_scsc, CHSC_SCSC, CHSC_SCSC_LEN);
> +	if (ret) {
> +		report(0, "chsc: CC %d", ret);
> +		goto end;
> +	}
> +
> +	for (i = 0, p = buffer; i < CSS_GENERAL_FEAT_BITLEN; i++) {
> +		if (css_general_feature(i)) {
> +			n = snprintf(p, sizeof(buffer) - ret, "%d,", i);
> +			p += n;
> +		}
> +	}
> +	report_info("General features: %s", buffer);
> +
> +	for (i = 0, p = buffer, ret = 0; i < CSS_CHSC_FEAT_BITLEN; i++) {
> +		if (css_chsc_feature(i)) {
> +			n = snprintf(p, sizeof(buffer) - ret, "%d,", i);
> +			p += n;
> +		}
> +	}
> +	report_info("CHSC features: %s", buffer);
> +
> +end:
> +	report_prefix_pop();
> +	return ret;
> +}
>  
>  /*
>   * css_enumerate:
> diff --git a/s390x/css.c b/s390x/css.c
> index 1a61a5c..18dbf01 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -14,6 +14,7 @@
>  #include <string.h>
>  #include <interrupt.h>
>  #include <asm/arch_def.h>
> +#include <alloc_page.h>
>  
>  #include <malloc_io.h>
>  #include <css.h>
> @@ -140,10 +141,21 @@ error_senseid:
>  	unregister_io_int_func(css_irq_io);
>  }
>  
> +static void css_init(void)
> +{
> +	int ret;
> +
> +	ret = get_chsc_scsc();
> +	if (!ret)
> +		report(1, " ");
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
>  } tests[] = {
> +	/* The css_init test is needed to initialize the CSS Characteristics */
> +	{ "initialize CSS (chsc)", css_init },

Is css_init() really a test or does it only setup state for further tests?

>  	{ "enumerate (stsch)", test_enumerate },
>  	{ "enable (msch)", test_enable },
>  	{ "sense (ssch/tsch)", test_sense },
> 

