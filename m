Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28D8328138
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 15:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbhCAOqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 09:46:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236552AbhCAOqT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 09:46:19 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121EYGiA036246
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 09:45:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5EkdF5lGpFgxa8R9EymiKl9wyA7rOBTXocfCO8KNO8E=;
 b=FA8s3gN94dVkdBbl5OH5rdBlw+bFGdo/esunok1CMexBjMcCsdCiwysrcKP7CvdjcIOJ
 ANlvn8rK/smxvP2l2Q6WiCeAbtk9GSwdMhBW6syhuYcaINy8bqFrSoEEmzKxuj/hA0VZ
 KDNKTKtiP6t/l6CY/889CmqOubjwJb1NTSHG6x3FVlPJThGebCVex43kSdK1RlAse083
 sQcRpvLHkUvxDc5nn8iSYPjaetFcFoXqlJ0lWJ0vU5vvX1m7v82QwsMSKVyidhZun1cF
 4yS+Wny0rF/0UsmLswVX+eQjjR54uLKtIIiiqedUjtAoltZEYK3BQ32gaqbinZW1c1pN 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37103q4u36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 09:45:36 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121EZZTh043825
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 09:45:36 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37103q4u2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 09:45:36 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121EcHfE009418;
        Mon, 1 Mar 2021 14:45:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 36ydq811c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 14:45:34 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121EjVdx35979604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 14:45:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 720085204E;
        Mon,  1 Mar 2021 14:45:31 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.190.79])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2052B52050;
        Mon,  1 Mar 2021 14:45:31 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 1/6] s390x: css: Store CSS
 Characteristics
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-2-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <2c94918a-11af-1ac0-9e8b-11439f078727@linux.ibm.com>
Date:   Mon, 1 Mar 2021 15:45:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614599225-17734-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_08:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/21 12:47 PM, Pierre Morel wrote:
> CSS characteristics exposes the features of the Channel SubSystem.
> Let's use Store Channel Subsystem Characteristics to retrieve
> the features of the CSS.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

Small nits below

> ---
>  lib/s390x/css.h     | 67 ++++++++++++++++++++++++++++++++
>  lib/s390x/css_lib.c | 93 ++++++++++++++++++++++++++++++++++++++++++++-
>  s390x/css.c         |  8 ++++
>  3 files changed, 167 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 3e57445..4210472 100644
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
> +	uint16_t len;
> +	uint16_t code;
> +};
> +
> +/* Store Channel Subsystem Characteristics */
> +struct chsc_scsc {
> +	struct chsc_header req;
> +	uint16_t req_fmt;
> +	uint8_t cssid;
> +	uint8_t res_03;
> +	uint32_t res_04[2];

I find the naming a bit weird and it could be one uint8_t field.

> +	struct chsc_header res;
> +	uint32_t res_fmt;
> +	uint64_t general_char[255];
> +	uint64_t chsc_char[254];
> +};
> +
> +extern struct chsc_scsc *chsc_scsc;
> +#define CHSC_SCSC	0x0010
> +#define CHSC_SCSC_LEN	0x0010
> +
> +bool get_chsc_scsc(void);
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
> +bool chsc(void *p, uint16_t code, uint16_t len);
> +
> +#include <bitops.h>
> +#define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
> +#define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
> +
>  #endif
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 3c24480..f46e871 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -15,11 +15,102 @@
>  #include <asm/arch_def.h>
>  #include <asm/time.h>
>  #include <asm/arch_def.h>
> -
> +#include <alloc_page.h>

Did you intend to remove the newline here?

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
> +static bool check_response(void *p)
> +{
> +	struct chsc_header *h = p;
> +
> +	if (h->code == CHSC_RSP_OK)
> +		return true;
> +
> +	if (h->code > CHSC_RSP_MAX)
> +		h->code = 0;
> +
> +	report_abort("Response code %04x: %s", h->code,
> +		      chsc_rsp_description[h->code]);
> +	return false;
> +}
> +
> +bool chsc(void *p, uint16_t code, uint16_t len)
> +{
> +	struct chsc_header *h = p;
> +
> +	h->code = code;
> +	h->len = len;
> +
> +	switch (_chsc(p)) {
> +	case 3:
> +		report_abort("Subchannel invalid or not enabled.");
> +		break;
> +	case 2:
> +		report_abort("CHSC subchannel busy.");
> +		break;
> +	case 1:
> +		report_abort("Subchannel invalid or not enabled.");
> +		break;
> +	case 0:
> +		return check_response(p + len);
> +	}
> +	return false;
> +}
> +
> +bool get_chsc_scsc(void)
> +{
> +	int i, n;
> +	char buffer[510];
> +	char *p;
> +
> +	if (chsc_scsc) /* chsc_scsc already initialized */
> +		return true;
> +
> +	chsc_scsc = alloc_page();
> +	if (!chsc_scsc) {
> +		report_abort("could not allocate chsc_scsc page!");
> +		return false;
> +	}
> +
> +	if (!chsc(chsc_scsc, CHSC_SCSC, CHSC_SCSC_LEN))
> +		return false;
> +
> +	for (i = 0, p = buffer; i < CSS_GENERAL_FEAT_BITLEN; i++) {
> +		if (css_general_feature(i)) {
> +			n = snprintf(p, sizeof(buffer), "%d,", i);
> +			p += n;
> +		}
> +	}
> +	report_info("General features: %s", buffer);
> +
> +	for (i = 0, p = buffer; i < CSS_CHSC_FEAT_BITLEN; i++) {
> +		if (css_chsc_feature(i)) {
> +			n = snprintf(p, sizeof(buffer), "%d,", i);
> +			p += n;
> +		}
> +	}
> +	report_info("CHSC features: %s", buffer);
> +
> +	return true;
> +}
>  
>  /*
>   * css_enumerate:
> diff --git a/s390x/css.c b/s390x/css.c
> index 1a61a5c..09703c1 100644
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
> @@ -140,10 +141,17 @@ error_senseid:
>  	unregister_io_int_func(css_irq_io);
>  }
>  
> +static void css_init(void)
> +{
> +	report(!!get_chsc_scsc(), "Store Channel Characteristics");

get_chsc_scsc() returns a bool, so you shouldn't need the !! here, no?

> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
>  } tests[] = {
> +	/* The css_init test is needed to initialize the CSS Characteristics */
> +	{ "initialize CSS (chsc)", css_init },
>  	{ "enumerate (stsch)", test_enumerate },
>  	{ "enable (msch)", test_enable },
>  	{ "sense (ssch/tsch)", test_sense },
> 

