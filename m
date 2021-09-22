Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65148414549
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhIVJhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:37:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234482AbhIVJh2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 05:37:28 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M8VNdN016374;
        Wed, 22 Sep 2021 05:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=C/3gshnIgbM0+pDZJMoOP2L3EVQSi0uCc9vTz4QhkoE=;
 b=HJ92TxH0TAGU5hOnEqt+e51ExtNw3Ep/NRmYyYy0cThAnfW1h5NkDE6K8iVqCkDE18kh
 5CZsWvs4mrBp/dRdMQlB9W3lMFMZkL50KNA+gTkQO0yG61FkXrmcx7zq+l0DNdcPMugN
 SVxi3caMsbfXyL1uLCrhta1o2QfaDT+itTg8LIS4EqqBJhW2e2XwTfOA20FSp3aQQOze
 M3ZL4cw3KEpkfLqhDD9jJG6I5R3gn/8BppvGqIoTPzTf5Rpa4TuUPgt+bal0Zcn/VMS3
 Ix6jYda/n0QqWohDWxfNyCCkDkJEdqszcxDDLP35KZp4E4iOHe4GndBasNqLw0spX3Yl LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b811u9bey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:58 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M9LjYh014154;
        Wed, 22 Sep 2021 05:35:58 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b811u9beh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:57 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M9W1hL008723;
        Wed, 22 Sep 2021 09:35:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3b7q6rmkv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:35:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M9ZqUw41419016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 09:35:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2995AE058;
        Wed, 22 Sep 2021 09:35:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A237FAE055;
        Wed, 22 Sep 2021 09:35:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.24])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 09:35:51 +0000 (GMT)
Date:   Wed, 22 Sep 2021 11:18:54 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/9] s390x: uv-host: Fence a destroy cpu
 test on z15
Message-ID: <20210922111854.767c29c7@p-imbrenda>
In-Reply-To: <20210922071811.1913-4-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
        <20210922071811.1913-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _7TLKksq79HS88kfy6s7dtQvhp3JeoEf
X-Proofpoint-GUID: tFnbr8QA6qkGmDmYlmWN8LFMuCesIeGD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_03,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 07:18:05 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Firmware will not give us the expected return code on z15 so let's
> fence it for the z15 machine generation.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 14 ++++++++++++++
>  s390x/uv-host.c          | 11 +++++++----
>  2 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index aa80d840..c8d2722a 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -219,6 +219,20 @@ static inline unsigned short stap(void)
>  	return cpu_address;
>  }
>  
> +#define MACHINE_Z15A	0x8561
> +#define MACHINE_Z15B	0x8562
> +
> +static inline uint16_t get_machine_id(void)
> +{
> +	uint64_t cpuid;
> +
> +	asm volatile("stidp %0" : "=Q" (cpuid));
> +	cpuid = cpuid >> 16;
> +	cpuid &= 0xffff;
> +
> +	return cpuid;
> +}
> +
>  static inline int tprot(unsigned long addr)
>  {
>  	int cc;
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 66a11160..5e351120 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -111,6 +111,7 @@ static void test_config_destroy(void)
>  static void test_cpu_destroy(void)
>  {
>  	int rc;
> +	uint16_t machineid = get_machine_id();
>  	struct uv_cb_nodata uvcb = {
>  		.header.len = sizeof(uvcb),
>  		.header.cmd = UVC_CMD_DESTROY_SEC_CPU,
> @@ -125,10 +126,12 @@ static void test_cpu_destroy(void)
>  	       "hdr invalid length");
>  	uvcb.header.len += 8;
>  
> -	uvcb.handle += 1;
> -	rc = uv_call(0, (uint64_t)&uvcb);
> -	report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
> -	uvcb.handle -= 1;
> +	if (machineid != MACHINE_Z15A && machineid != MACHINE_Z15B) {
> +		uvcb.handle += 1;
> +		rc = uv_call(0, (uint64_t)&uvcb);
> +		report(rc == 1 && uvcb.header.rc == UVC_RC_INV_CHANDLE, "invalid handle");
> +		uvcb.handle -= 1;
> +	}
>  
>  	rc = uv_call(0, (uint64_t)&uvcb);
>  	report(rc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "success");

