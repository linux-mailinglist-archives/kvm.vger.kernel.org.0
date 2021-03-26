Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D7A34A350
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 09:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhCZIlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 04:41:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229463AbhCZIlP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 04:41:15 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12Q8WpC2067941
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 04:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6eG/eya0uoB6SdEcuuuIj8Qn4IcDYs8KvAFLIw667kc=;
 b=ouEiR5EyFvhDYuB0a49UdiVma53NIfc1PDUTtTdJNYn/JnMVyjp7lbSJ4+ByKRXx8pb0
 dwO2Lg67QpDc6OeAPgnRCYmV9Zul7gzjsJLU4N7Zq82Oo08EvQo7qaJmi73YbKGcHZww
 H159fu7g+wAIOSX5p5B0WARGfaC6pgsPAqnuTlyDt1WnrBiOfM272Gt0DK0i5B+aSBIW
 nmCfBf9Oe27N5acA3X94x/4O566sMSnki9QTufdLKExnLkNUuBGrAIrh6LDjo10W1lO7
 jPkd6WMdpykPUBzj4gLBgri+7L6/Jw0Jr0Y6aARE2/DMaa+omXA2GQpRZDJVvFxZGK2Y tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37h8kvd8va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 04:41:15 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12Q8XldC070262
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 04:41:15 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37h8kvd8u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 04:41:15 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12Q8bY54029868;
        Fri, 26 Mar 2021 08:41:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 37h1510f9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 08:41:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12Q8fAgG20840956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 08:41:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E23234C063;
        Fri, 26 Mar 2021 08:41:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FA214C044;
        Fri, 26 Mar 2021 08:41:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.164.239])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Mar 2021 08:41:09 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/8] s390x: css: simplify skipping tests
 on no device
Message-ID: <5c0f996a-65ae-88b8-3374-a926db37e9d5@linux.ibm.com>
Date:   Fri, 26 Mar 2021 09:41:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lm4EYy2KZo7vHYqWDUt2cJos6ikETiLD
X-Proofpoint-GUID: U7ARkWYPtIFU8Rfw8ZwzfoacbGLuAVRw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_02:2021-03-25,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015 adultscore=0
 spamscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/21 10:39 AM, Pierre Morel wrote:
> We will lhave to test if a device is present for every tests

s/lhave/have/

> in the future.
> Let's provide a macro to check if the device is present and
> to skip the tests if it is not.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  s390x/css.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index c340c53..16723f6 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -27,6 +27,13 @@ static int test_device_sid;
>  static struct senseid *senseid;
>  struct ccw1 *ccw;
>  
> +#define NODEV_SKIP(dev) do {						\

s/device/schid/ ?
I have no strong opinions either way so choose what you like best.

Also, since you use report(0, "") so often, maybe you want to introduce
report_fail() into the library in the future? The x86 vmx tests also use
report(0, "") a lot so you're not completely alone.

Could you please move the "do {" one line down so we start with a zero
indent?

> +				if (!(dev)) {				\
> +					report_skip("No device");	\
> +					return;				\
> +				}					\
> +			} while (0)
> +
>  static void test_enumerate(void)
>  {
>  	test_device_sid = css_enumerate();
> @@ -41,10 +48,7 @@ static void test_enable(void)
>  {
>  	int cc;
>  
> -	if (!test_device_sid) {
> -		report_skip("No device");
> -		return;
> -	}
> +	NODEV_SKIP(test_device_sid);
>  
>  	cc = css_enable(test_device_sid, IO_SCH_ISC);
>  
> @@ -62,10 +66,7 @@ static void test_sense(void)
>  	int ret;
>  	int len;
>  
> -	if (!test_device_sid) {
> -		report_skip("No device");
> -		return;
> -	}
> +	NODEV_SKIP(test_device_sid);
>  
>  	ret = css_enable(test_device_sid, IO_SCH_ISC);
>  	if (ret) {
> @@ -218,10 +219,7 @@ static void test_schm_fmt0(void)
>  	struct measurement_block_format0 *mb0;
>  	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
>  
> -	if (!test_device_sid) {
> -		report_skip("No device");
> -		return;
> -	}
> +	NODEV_SKIP(test_device_sid);
>  
>  	/* Allocate zeroed Measurement block */
>  	mb0 = alloc_io_mem(shared_mb_size, 0);
> @@ -289,10 +287,7 @@ static void test_schm_fmt1(void)
>  {
>  	struct measurement_block_format1 *mb1;
>  
> -	if (!test_device_sid) {
> -		report_skip("No device");
> -		return;
> -	}
> +	NODEV_SKIP(test_device_sid);
>  
>  	if (!css_test_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
>  		report_skip("Extended measurement block not available");
> 

