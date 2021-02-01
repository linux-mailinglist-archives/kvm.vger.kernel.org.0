Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFFA30A4D3
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 11:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhBAKCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 05:02:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58300 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232363AbhBAKCM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 05:02:12 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 1119sEWD050439;
        Mon, 1 Feb 2021 05:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5yjA4LuoUrcC+Q/QLbU8bIsrbC1kv66t59QU5hI8v+w=;
 b=ILw+JowFXGOXF/A3V6z+SVqIOhLsVDHL3awSppTpH36KBO4dGYSVrHddmdeELXr5Ql9V
 9Je6I8nJMvki/yp1LtB2zL/XVc1bC8g6Wv5imetc8gXtI8k9VqF/L3KAEHLjxseJ3z+9
 QBicrQZZpBrpfMiZ8x3h+IqI45gyYlcQ3DLLGA6M1QC1SOM1ek9PUlyVLf13qPIJiL4Z
 a0bdy9rEDvPd3zl/zgG1dJXvv4QMZs1/QvWsvWv4/FWM/QiuUsN6/Jqoq+kps8j0Epnr
 xSnPahqEywQYv3WiJQamMQR0cWj/SZSw4D6HwffnQosgktsu/iVsg6HQdvZWmjVRRIYk mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36efe0053e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 05:01:29 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1119usLC058080;
        Mon, 1 Feb 2021 05:01:29 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36efe0052b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 05:01:29 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1119gPdS016509;
        Mon, 1 Feb 2021 10:01:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 36cy38hq8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 10:01:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111A1Opr43450778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 10:01:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 641024C058;
        Mon,  1 Feb 2021 10:01:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED6F94C04E;
        Mon,  1 Feb 2021 10:01:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.68.23])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Feb 2021 10:01:23 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-2-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/5] s390x: css: Store CSS
 Characteristics
Message-ID: <04f837d1-b389-9c51-a876-233c70c86999@linux.ibm.com>
Date:   Mon, 1 Feb 2021 11:01:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611930869-25745-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_03:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/29/21 3:34 PM, Pierre Morel wrote:
> CSS characteristics exposes the features of the Channel SubSystem.
> Let's use Store Channel Subsystem Characteristics to retrieve
> the features of the CSS.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     | 57 +++++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/css_lib.c | 50 ++++++++++++++++++++++++++++++++++++++-
>  s390x/css.c         | 12 ++++++++++
>  3 files changed, 118 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 3e57445..bc0530d 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -288,4 +288,61 @@ int css_residual_count(unsigned int schid);
>  void enable_io_isc(uint8_t isc);
>  int wait_and_check_io_completion(int schid);
>  
> +/*
> + * CHSC definitions
> + */
> +struct chsc_header {
> +	u16 len;
> +	u16 code;
> +};
> +
> +/* Store Channel Subsystem Characteristics */
> +struct chsc_scsc {
> +	struct chsc_header req;
> +	u32 reserved1;
> +	u32 reserved2;
> +	u32 reserved3;

Array?

> +	struct chsc_header res;
> +	u32 format;
> +	u64 general_char[255];
> +	u64 chsc_char[254];
> +};
> +extern struct chsc_scsc *chsc_scsc;
> +
> +#define CSS_GENERAL_FEAT_BITLEN	(255 * 64)
> +#define CSS_CHSC_FEAT_BITLEN	(254 * 64)
> +
> +int get_chsc_scsc(void);
> +
> +static inline int _chsc(void *p)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"	.insn   rre,0xb25f0000,%2,0\n"
> +		"	ipm     %0\n"
> +		"	srl     %0,28\n"
> +		: "=d" (cc), "=m" (p)
> +		: "d" (p), "m" (p)
> +		: "cc");
> +
> +	return cc;
> +}
> +
> +#define CHSC_SCSC	0x0010
> +#define CHSC_SCSC_LEN	0x0010
> +
> +static inline int chsc(void *p, uint16_t code, uint16_t len)
> +{
> +	struct chsc_header *h = p;
> +
> +	h->code = code;
> +	h->len = len;
> +	return _chsc(p);
> +}
> +
> +#include <bitops.h>
> +#define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
> +#define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
> +
>  #endif
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 3c24480..fe05021 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -15,11 +15,59 @@
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
> +	chsc_scsc = alloc_pages(0);

alloc_page() ?

> +	report_info("scsc_scsc at: %016lx", (u64)chsc_scsc);
> +	if (!chsc_scsc) {
> +		ret = -1;
> +		report(0, "could not allocate chsc_scsc page!");
> +		goto end;
> +	}
> +
> +	ret = chsc(chsc_scsc, CHSC_SCSC, CHSC_SCSC_LEN);
> +	if (ret) {
> +		report(0, "chsc: CC %d", ret);
> +		goto end;
> +	}
> +
> +	for (i = 0, p = buffer; i < CSS_GENERAL_FEAT_BITLEN; i++)
> +		if (css_general_feature(i)) {
> +			n = snprintf(p, sizeof(buffer) - ret, "%d,", i);
> +			p += n;
> +		}
> +	report_info("General features: %s", buffer);
> +
> +	for (i = 0, p = buffer, ret = 0; i < CSS_CHSC_FEAT_BITLEN; i++)
> +		if (css_chsc_feature(i)) {
> +			n = snprintf(p, sizeof(buffer) - ret, "%d,", i);
> +			p += n;
> +		}
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
>  	{ "enumerate (stsch)", test_enumerate },
>  	{ "enable (msch)", test_enable },
>  	{ "sense (ssch/tsch)", test_sense },
> 

