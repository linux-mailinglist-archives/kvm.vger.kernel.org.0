Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9589156653B
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 10:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiGEIl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 04:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiGEIl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 04:41:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64165FCB;
        Tue,  5 Jul 2022 01:41:27 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2657Xv55027159;
        Tue, 5 Jul 2022 08:41:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ScPF3ty8FIG/TiFONJ2o3eoH26lJcP9BjgV6wUgk1uI=;
 b=deYbgSSjR5BhPRCvn1IRHpJzxBuPOT7PvORRURwL6bwHcNvSe7Q6QSSXs78eCLjWpbem
 0jjGGDJDOoTD8eoXw4YKriEPnI7L7GKdxr6Pz6XNGknKHNXcNgwPFTonOoV1UasW0rkN
 aXF87dr2B2+q6OePR99W+LsQSLwWc+CjMJRb3k8jlo4Qq+K83kuettKyzF8KBnVw+uOJ
 vU4bwBrrKpOmT/zT4//hMbYfGqrPVkz3SKDxQi8744KmrfxmPaFpl5EB1c6paO2dw5fi
 n4qlDcomFT2hHYgwF/ci/ZobxpEX+MvcLFJ3gsy6oGPgxX04f2+xEmKrjn6VJ2H1LEAt Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4h179e93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 08:41:26 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2658efpn018769;
        Tue, 5 Jul 2022 08:41:26 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4h179e8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 08:41:26 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2658Jtag000515;
        Tue, 5 Jul 2022 08:41:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3h2dn92sf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 08:41:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2658fLKU18874734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 08:41:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12CA5AE053;
        Tue,  5 Jul 2022 08:41:21 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF0FEAE04D;
        Tue,  5 Jul 2022 08:41:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.172])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 08:41:20 +0000 (GMT)
Date:   Tue, 5 Jul 2022 10:20:11 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/4] lib: s390x: add CPU timer
 functions to time.h
Message-ID: <20220705102011.1cf2237e@p-imbrenda>
In-Reply-To: <20220704121328.721841-3-nrb@linux.ibm.com>
References: <20220704121328.721841-1-nrb@linux.ibm.com>
        <20220704121328.721841-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ii8rMrhV98o6yFDaOpIvClOMUQfGDev3
X-Proofpoint-GUID: 7HWLJgwIeKj3jcjwIHfAjC9UCq6_MXz3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_06,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  4 Jul 2022 14:13:26 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upcoming changes will make use of the CPU timer, so add a convenience
> function to set the CPU timer.
> 
> Since shifts for both CPU timer and TOD clock are the same, introduce a
> new define TIMING_S390_SHIFT_US. The respective shifts for CPU timer and
> TOD clock reference it, so the semantic difference between the two
> defines is kept.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/asm/time.h | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 7652a151e87a..9ae364afb8a3 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -11,9 +11,13 @@
>  #ifndef _ASMS390X_TIME_H_
>  #define _ASMS390X_TIME_H_
>  
> -#define STCK_SHIFT_US	(63 - 51)
> +#define TIMING_S390_SHIFT_US	(63 - 51)

I would call it S390_CLOCK_SHIFT_US

> +
> +#define STCK_SHIFT_US	TIMING_S390_SHIFT_US
>  #define STCK_MAX	((1UL << 52) - 1)
>  
> +#define CPU_TIMER_SHIFT_US	TIMING_S390_SHIFT_US
> +
>  static inline uint64_t get_clock_us(void)
>  {
>  	uint64_t clk;
> @@ -45,4 +49,14 @@ static inline void mdelay(unsigned long ms)
>  	udelay(ms * 1000);
>  }
>  
> +static inline void cpu_timer_set(int64_t timeout_ms)

I would call the function cpu_timer_set_ms

so that it's clear what unit goes in, and it makes things easier if in
the future someone needs a _us version

> +{
> +	int64_t timer_value = (timeout_ms * 1000) << CPU_TIMER_SHIFT_US;
> +	asm volatile (
> +		"spt %[timer_value]\n"
> +		:
> +		: [timer_value] "Q" (timer_value)
> +	);
> +}
> +
>  #endif

