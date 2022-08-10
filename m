Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C1058EA4A
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 12:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiHJKKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 06:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiHJKKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 06:10:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E50E51A0C
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 03:10:18 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AA8HhA002358
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/7kf125brmJmNMN4UAkm1+531Rt80/lOMajQBIf7qdI=;
 b=jYHK0mBDdTrqaiPs85uLho3zelg4qHra5PI7J6VY4FUPdhnKStGq2SLV8E+g0WTLd4TO
 yBsKQ+3irGuPy2siD7i/k5oWwgTVbXFVXrMvSo/mM+DFNjISgysMeb18CFU/bGZqSXGF
 83CPN4+2fq5yT2pmMpX32AX/VGmH4omFu7asR2SI20N6sO1RWHlhXQit1jEE9+gy4do0
 ZkC0A1vk1k5KEdwcj9A599QldN5il1OXzVAXdJdJe3QdMP1FA3c1n9gcHn25lL0ecEyW
 +q/51r4J4HbNU+ncxeSYaa77DNSlsQ7BVtduaNgJrwAm+lNETSeKBxSJc5Bj+OjsFkvz kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv65w0p6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:17 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27A9HDXa002442
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:17 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv65w0p55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 10:10:17 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27AA8ROL015892;
        Wed, 10 Aug 2022 10:10:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3huww0rpdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 10:10:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27AA7fhj32375252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 10:07:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 919C4A4053;
        Wed, 10 Aug 2022 10:10:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 454FEA404D;
        Wed, 10 Aug 2022 10:10:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.105])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 10:10:11 +0000 (GMT)
Date:   Wed, 10 Aug 2022 11:59:41 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 2/4] lib: s390x: add CPU timer
 functions to time.h
Message-ID: <20220810115941.2a25c1e1@p-imbrenda>
In-Reply-To: <20220722060043.733796-3-nrb@linux.ibm.com>
References: <20220722060043.733796-1-nrb@linux.ibm.com>
        <20220722060043.733796-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VavckzkIUV4w2L_AokGaH0hBrl-1PYPh
X-Proofpoint-GUID: RpHNsX9EcQEEnHnk5D72LmdUW4SgXfpv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1011
 suspectscore=0 priorityscore=1501 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jul 2022 08:00:41 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upcoming changes will make use of the CPU timer, so add a convenience
> function to set the CPU timer.
> 
> Since shifts for both CPU timer and TOD clock are the same, introduce a
> new define S390_CLOCK_SHIFT_US. The respective shifts for CPU timer and
> TOD clock reference it, so the semantic difference between the two
> defines is kept.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/time.h | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 7652a151e87a..d8d91d68a667 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -11,9 +11,13 @@
>  #ifndef _ASMS390X_TIME_H_
>  #define _ASMS390X_TIME_H_
>  
> -#define STCK_SHIFT_US	(63 - 51)
> +#define S390_CLOCK_SHIFT_US	(63 - 51)
> +
> +#define STCK_SHIFT_US	S390_CLOCK_SHIFT_US
>  #define STCK_MAX	((1UL << 52) - 1)
>  
> +#define CPU_TIMER_SHIFT_US	S390_CLOCK_SHIFT_US
> +
>  static inline uint64_t get_clock_us(void)
>  {
>  	uint64_t clk;
> @@ -45,4 +49,15 @@ static inline void mdelay(unsigned long ms)
>  	udelay(ms * 1000);
>  }
>  
> +static inline void cpu_timer_set_ms(int64_t timeout_ms)
> +{
> +	int64_t timer_value = (timeout_ms * 1000) << CPU_TIMER_SHIFT_US;
> +
> +	asm volatile (
> +		"spt %[timer_value]\n"
> +		:
> +		: [timer_value] "Q" (timer_value)
> +	);
> +}
> +
>  #endif

