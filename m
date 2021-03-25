Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9A5349664
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhCYQFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:05:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12371 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229832AbhCYQFD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 12:05:03 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PG4fwU050630
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:05:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=U4dEvsHbqQp/ZgMcPbn+93N8rUCGcoCLegUtZRaZ1gQ=;
 b=rcADr8Lu0fXb8NtooddnerSgqtxJ7zhSjrSX8BdXq/wUTbwdMxR8tB5q2vVw5jADyauA
 rHqFgDT5wEmaXhaMKMF4iOhXb1LQpqsxHLE+LS0lZu1Rg+3FvigKxbtp4JIRpOCd70p3
 zFzZccSOFPOThiOCaXc6vjpTfzPIPnWWUbvCTGi5AZz8GYEqxHemLlZJQJ7HS1Yd0kC/
 rVGg7on1o4KHghp9UY8IHX4JLE/kn6nUsCPQkxysJeVMjDApnrAXGcrRUIerR5hQOIPZ
 ES+knqaNhAG8QunesgweJHBOfJ2dUu+1Zw8hsERelM8zhhtuMjYO3cgCqkaKLZ6wWFmp pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gka72urb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:05:00 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PG4wX0058992
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:04:58 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gka72tv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:04:57 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PFvgUC021303;
        Thu, 25 Mar 2021 16:03:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 37d9bptwhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:03:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PG38xZ41091416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 16:03:08 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F050242041;
        Thu, 25 Mar 2021 16:03:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 941DB4203F;
        Thu, 25 Mar 2021 16:03:07 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 16:03:07 +0000 (GMT)
Date:   Thu, 25 Mar 2021 16:21:34 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/8] s390x: css: simplify skipping
 tests on no device
Message-ID: <20210325162134.3f2f3f9e@ibm-vm>
In-Reply-To: <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
        <1616665147-32084-4-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_04:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 10:39:02 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We will lhave to test if a device is present for every tests
> in the future.
> Let's provide a macro to check if the device is present and
> to skip the tests if it is not.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
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
> +#define NODEV_SKIP(dev) do {
> 	\
> +				if (!(dev)) {
> 	\
> +					report_skip("No
> device");	\
> +					return;
> 		\
> +				}
> 	\
> +			} while (0)

I wonder if you can add for example which device is not present (might
help with debugging)

in any case:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

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
>  	int shared_mb_size = 2 * sizeof(struct
> measurement_block_format0); 
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
>  	if
> (!css_test_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
> report_skip("Extended measurement block not available");

