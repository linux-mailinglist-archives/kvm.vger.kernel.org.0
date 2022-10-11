Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8804A5FB8EF
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 19:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJKRGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 13:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiJKRGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 13:06:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AF2A7A9C
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 10:06:40 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BGA4Fg016248
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:06:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=LlR14FHaoioktMqIPOaxwxWU0Yccyn8rG2hzDMq4FSM=;
 b=QPMl4ObVf+85dDig/sY729p7y/4op+GdgtFRvduraBW9CGZOAi4e9Cxkb2gNF3Or2LaY
 foYU45G7MsviQ+x1shnLF91PSnguAeB2M6Qg1RRuMFecxVtNLi7YqNmaCQGYQU/bmWGb
 N9rzgLrQ6Hv1LOvP0FPQbHGJ+05Gjlsbl/FylPRckmPi7B8mR0D1ceHM04TzphDmqUPm
 +8ph/QK/ybg/vIAM00se21nLCPML1H7luTR0n9k0yiNeZP2H3XeMZ6XleMOATV6NYFPU
 Ia5JFf21GC/GUJ6/qoKsucil/O+mVp/S25BjhzgFIpZ47GoH8mmVjkl00fKP38U5v4OI NQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k590dgf62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:06:39 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BH62cq007029
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:06:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3k30u8ujxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:06:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BH6YUX60555530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 17:06:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 325354C044;
        Tue, 11 Oct 2022 17:06:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF7444C046;
        Tue, 11 Oct 2022 17:06:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 17:06:33 +0000 (GMT)
Date:   Tue, 11 Oct 2022 19:06:32 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 1/2] lib/s390x: move TOD clock related
 functions to library
Message-ID: <20221011190632.7c1a7c58@p-imbrenda>
In-Reply-To: <20221011170024.972135-2-nrb@linux.ibm.com>
References: <20221011170024.972135-1-nrb@linux.ibm.com>
        <20221011170024.972135-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: euTkdGC2SFzyCMKVQVM460_7zts9He1s
X-Proofpoint-ORIG-GUID: euTkdGC2SFzyCMKVQVM460_7zts9He1s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Oct 2022 19:00:23 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> The TOD-clock related functions can be useful for other tests beside the
> sck test, hence move them to the library.
> 
> While at it, add a wrapper for stckf, express get_clock_us() with
> stck() and remove an unneeded memory clobber.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/time.h | 50 +++++++++++++++++++++++++++++++++++++++++++-
>  s390x/sck.c          | 32 ----------------------------
>  2 files changed, 49 insertions(+), 33 deletions(-)
> 
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index d8d91d68a667..ad689b098eab 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -18,11 +18,59 @@
>  
>  #define CPU_TIMER_SHIFT_US	S390_CLOCK_SHIFT_US
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
> +		: "cc"
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
> +		: "cc"
> +	);
> +
> +	return cc;
> +}
> +
>  static inline uint64_t get_clock_us(void)
>  {
>  	uint64_t clk;
>  
> -	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
> +	stck(&clk);
>  
>  	return clk >> STCK_SHIFT_US;
>  }
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

