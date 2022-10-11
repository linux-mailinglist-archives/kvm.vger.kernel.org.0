Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DB05FB7B0
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 17:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiJKPuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 11:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiJKPuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 11:50:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED99F19C16
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 08:44:58 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BEie8n029148
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=yz6jccx0zz2TBaeTxC2g4gxn7pIPuJmQAG7kuLYsCxg=;
 b=iJcEgQVNq4pKFKAjz7300boS9haTW+51kahmN+Fow2fhQ8pXDQ8JDwAMaBiM8irouj1o
 Iyc7MsNRAgHZ94P6OOnAul0ZtVwvYHQsPeQhaLNf0k4uq4uoFf3SFLFzTnFDjlxK1q1J
 PCuQt64REGOMwRlB/4Od0c9pdH4QztE3ZuDTH6GPlvSrYxE3UrKFR/2OV7XkOglKUn1M
 omNMAFjowb+P5rSYm9W+VTLQFSYFEFLxrsBzYtSbWl8kNh3PDy/GMDAbaCX/STvuHDQk
 RZHfGVspHrnW2a463Mo8LxQjoMqqOsloTtqv+NOqNmanFtCuWCxYyGJrQ0d9V86y+Ida Gw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k59xukn94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:44:44 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BFbC7v025065
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:44:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3k30fj3h02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 15:44:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BFicdC38666726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 15:44:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5D35A4053;
        Tue, 11 Oct 2022 15:44:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56D8EA4040;
        Tue, 11 Oct 2022 15:44:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 15:44:38 +0000 (GMT)
Date:   Tue, 11 Oct 2022 17:41:35 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/2] lib/s390x: move TOD clock related
 functions to library
Message-ID: <20221011174135.1cdcd472@p-imbrenda>
In-Reply-To: <20221011151433.886294-2-nrb@linux.ibm.com>
References: <20221011151433.886294-1-nrb@linux.ibm.com>
        <20221011151433.886294-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Pvxrys0O2ble6YbnGuibyzNyg8kvE-QZ
X-Proofpoint-ORIG-GUID: Pvxrys0O2ble6YbnGuibyzNyg8kvE-QZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210110089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Oct 2022 17:14:32 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> The TOD-clock related functions can be useful for other tests beside the
> sck test, hence move them to the library.
> 
> While at it, add a wrapper for stckf and express get_clock_us() with
> stck() to reduce code duplication.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/asm/time.h | 50 +++++++++++++++++++++++++++++++++++++++++++-
>  s390x/sck.c          | 32 ----------------------------
>  2 files changed, 49 insertions(+), 33 deletions(-)
> 
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index d8d91d68a667..c5e1797fd29e 100644
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
> +		: "cc", "memory"

why do you need "memory" ?

(I know it was in the old code, but probably it should not have)

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

same here

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

