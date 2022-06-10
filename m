Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1587C5462AD
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344740AbiFJJnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 05:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243444AbiFJJnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 05:43:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D14223BCB;
        Fri, 10 Jun 2022 02:43:39 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A8T3ZQ031673;
        Fri, 10 Jun 2022 09:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xnu0IeugXXhLb8TMu2gOhNJSSkFKJgPniah1ZXloVu8=;
 b=P6s8SMKCa8JHouHZ7H8XWUNpS8wIw+WETHFZocb/gkcH4JRAhSf8Uj7dFxhUiu/dDIIP
 aDCbke4HK+ulOfZg/GjBe7ZgJbm2x1oGzckhOlmyC7rB+MyUlBI9WTtLZgNa2TwSLWkS
 gRK1LtOHBqxzEV416Sww2hr1nvWLuQeVOhv3yn/Wj3m5FyMuWCsT40o3KoKfm+AYv07O
 oVCIrKQgZGRlIgDMELTVjhhFVNrf5pIhnrYOe3oj0OCD6ungF8hLICDg4v4CGKPIScHE
 5UvppvmW20IQt6JXc427fO3pSPlbaE9tNisFKdazvy366qdAuOdbccW171dhe0GwKMjl DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gm2fu999g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 09:43:38 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25A8TIvE000319;
        Fri, 10 Jun 2022 09:43:38 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gm2fu998u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 09:43:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25A9a6aD009990;
        Fri, 10 Jun 2022 09:43:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3gfy19g1tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 09:43:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25A9hWa614025058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 09:43:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ED7B52050;
        Fri, 10 Jun 2022 09:43:32 +0000 (GMT)
Received: from [9.145.63.156] (unknown [9.145.63.156])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3A3625204E;
        Fri, 10 Jun 2022 09:43:32 +0000 (GMT)
Message-ID: <17c65d73-b791-46f9-8ec7-0fa592e7cb61@linux.ibm.com>
Date:   Fri, 10 Jun 2022 11:43:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com,
        pmorel@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
References: <20220603154037.103733-1-imbrenda@linux.ibm.com>
 <20220603154037.103733-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib: s390x: better smp interrupt
 checks
In-Reply-To: <20220603154037.103733-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wWV1WgZ2V5dn_5Ff3EbzY7pZYpTkt1AV
X-Proofpoint-ORIG-GUID: 7jHsTVIqcjn85v1sYd2gmmGg-x-L0v-N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-10_02,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 mlxscore=0 suspectscore=0
 adultscore=0 priorityscore=1501 spamscore=0 mlxlogscore=952 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100035
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/22 17:40, Claudio Imbrenda wrote:
> Use per-CPU flags and callbacks for Program, Extern, and I/O interrupts
> instead of global variables.
> 
> This allows for more accurate error handling; a CPU waiting for an
> interrupt will not have it "stolen" by a different CPU that was not
> supposed to wait for one, and now two CPUs can wait for interrupts at
> the same time.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h |  7 ++++++-
>   lib/s390x/interrupt.c    | 38 ++++++++++++++++----------------------
>   2 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 72553819..3a0d9c43 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -124,7 +124,12 @@ struct lowcore {
>   	uint8_t		pad_0x0280[0x0308 - 0x0280];	/* 0x0280 */
>   	uint64_t	sw_int_crs[16];			/* 0x0308 */
>   	struct psw	sw_int_psw;			/* 0x0388 */
> -	uint8_t		pad_0x0310[0x11b0 - 0x0398];	/* 0x0398 */
> +	uint32_t	pgm_int_expected;		/* 0x0398 */
> +	uint32_t	ext_int_expected;		/* 0x039c */
> +	void		(*pgm_cleanup_func)(void);	/* 0x03a0 */
> +	void		(*ext_cleanup_func)(void);	/* 0x03a8 */
> +	void		(*io_int_func)(void);		/* 0x03b0 */
> +	uint8_t		pad_0x03b8[0x11b0 - 0x03b8];	/* 0x03b8 */

Before we directly pollute the lowcore I'd much rather have a pointer to 
a struct. We could then either use any area of the lowcore by adding a 
union or we extend the SMP lib per-cpu structs.

I don't want to have to review offset calculations for every change of 
per-cpu data. They are just way too easy to get wrong.


