Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F86D5F6486
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 12:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiJFKu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 06:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiJFKuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 06:50:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBAD75481
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 03:50:23 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296AaosD035719
        for <kvm@vger.kernel.org>; Thu, 6 Oct 2022 10:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=soy9vjC9eqvzdyJJumUQz3M+11VQhr87rppGrA6qQbA=;
 b=EArB+7l+9sf7h2w9lV4xR0Xo62ldF4Rjj18qi6c1ZM1vk4UIIuStfA03Kc84dDBKAqCM
 fTVd3bVEXsMxutU31d97FIra2VpUgf/uMTT6XTz33mKYrCgUPbKy8vSfy0FPzvN8XCc/
 0iX5V7dGR3OsfLKb/sBdP0md8jQSCvRaNQD9FHcCvrBJAJTw/LS/aYIRMd5FXfk+ZbhX
 i3MXOx4cCFjG5O1zzasRvFfUxdFGG8fgRSMAkkNAIPWAsjwxjuathvEwwjmskyVyLgAc
 SQniXVd8qlITehWL4ghx/5TON2hAof1vzd7Tifkbas6s9KnsMqHXIb7kO1hwAgXoUQLQ vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1v1yawyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 10:50:23 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29693IDj037403
        for <kvm@vger.kernel.org>; Thu, 6 Oct 2022 10:50:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1v1yawx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 10:50:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 296AaFtF011927;
        Thu, 6 Oct 2022 10:50:20 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3jxctj6x2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 10:50:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 296AoHbs66060556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Oct 2022 10:50:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AA21AE051;
        Thu,  6 Oct 2022 10:50:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41DA3AE045;
        Thu,  6 Oct 2022 10:50:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Oct 2022 10:50:17 +0000 (GMT)
Date:   Thu, 6 Oct 2022 12:50:14 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib/s390x: move TOD clock related
 functions to library
Message-ID: <20221006125014.0df15a8b@p-imbrenda>
In-Reply-To: <20220826084944.19466-2-nrb@linux.ibm.com>
References: <20220826084944.19466-1-nrb@linux.ibm.com>
        <20220826084944.19466-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NxiSpLOb2T_oHcxuybBfMia6sjiKm-0B
X-Proofpoint-ORIG-GUID: qG4iv3LzziScfo2sKl7gmay4XoZKOiII
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 impostorscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210060063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Aug 2022 10:49:43 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> The TOD-clock related functions can be useful for other tests beside the
> sck test, hence move them to the library.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/asm/time.h | 48 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/sck.c          | 32 -----------------------------
>  2 files changed, 48 insertions(+), 32 deletions(-)
> 
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 7652a151e87a..81b57e2b4894 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -28,6 +28,54 @@ static inline uint64_t get_clock_ms(void)
>  	return get_clock_us() / 1000;
>  }
>  
> +static inline int sck(uint64_t *time)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"	sck %[time]\n"
> +		"	ipm %[cc]\n"
> +		"	srl %[cc],28\n"
> +		: [cc] "=d"(cc)
> +		: [time] "Q"(*time)
> +		: "cc"
> +	);
> +
> +	return cc;
> +}
> +
> +static inline int stck(uint64_t *time)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"	stck %[time]\n"
> +		"	ipm %[cc]\n"
> +		"	srl %[cc],28\n"
> +		: [cc] "=d" (cc), [time] "=Q" (*time)
> +		:
> +		: "cc", "memory"
> +	);
> +
> +	return cc;
> +}
> +
> +static inline int stckf(uint64_t *time)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"	stckf %[time]\n"
> +		"	ipm %[cc]\n"
> +		"	srl %[cc],28\n"
> +		: [cc] "=d" (cc), [time] "=Q" (*time)
> +		:
> +		: "cc", "memory"
> +	);
> +
> +	return cc;
> +}

please put these functions before all the other inline functions, and
then fix get_clock_us to use the wrapper instead of the (broken) inline
asm

> +
>  static inline void udelay(unsigned long us)
>  {
>  	unsigned long startclk = get_clock_us();
> diff --git a/s390x/sck.c b/s390x/sck.c
> index 88d52b74a586..dff496187602 100644
> --- a/s390x/sck.c
> +++ b/s390x/sck.c
> @@ -12,38 +12,6 @@
>  #include <asm/interrupt.h>
>  #include <asm/time.h>
>  
> -static inline int sck(uint64_t *time)
> -{
> -	int cc;
> -
> -	asm volatile(
> -		"	sck %[time]\n"
> -		"	ipm %[cc]\n"
> -		"	srl %[cc],28\n"
> -		: [cc] "=d"(cc)
> -		: [time] "Q"(*time)
> -		: "cc"
> -	);
> -
> -	return cc;
> -}
> -
> -static inline int stck(uint64_t *time)
> -{
> -	int cc;
> -
> -	asm volatile(
> -		"	stck %[time]\n"
> -		"	ipm %[cc]\n"
> -		"	srl %[cc],28\n"
> -		: [cc] "=d" (cc), [time] "=Q" (*time)
> -		:
> -		: "cc", "memory"
> -	);
> -
> -	return cc;
> -}
> -
>  static void test_priv(void)
>  {
>  	uint64_t time_to_set_privileged = 0xfacef00dcafe0000,

