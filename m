Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C9F5735D3
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 13:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiGMLu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 07:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbiGMLu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 07:50:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD7EE4778;
        Wed, 13 Jul 2022 04:50:58 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DBhoVk013834;
        Wed, 13 Jul 2022 11:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/UkvCuVr9MoZkBSPPZJKsdueVOvbPYo5SPwghB6eRCg=;
 b=BQCq1GdfJEyhZ9wku/7qiWtyr+xOC82sDKv4Whzb4VrCdGSiKXcPkfUN4IoWUunPtp6/
 cUeWBI7L6K51UqiW+vX+3v7GlxA8t96FuPAnH2nO+kixUohiJ2xG+c7aLkMU472z0WRX
 c0w6UOxr7H9g9lMivaSrQ9ZssCdU5cwRa3N3wbc9KcfKL4ckDWPk2raMcJ0muXlNY3R+
 HrtBPG9K6WZdGE1xkgIPyrenV4umGi6DgNOhT0NDogjy7PE4tFmFTSWxIlAKS9LtfP00
 p2HyWgq2GClbo9bkwYvGbi2F4GFvKTyMbQU9rc9IdfORfbtH1zelaDd73713UB46VQAl zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9we4g53y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:50:57 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DBjFA4018326;
        Wed, 13 Jul 2022 11:50:56 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9we4g538-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:50:56 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DBb5WV010214;
        Wed, 13 Jul 2022 11:50:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3h71a8m6nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:50:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DBopQc17629450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 11:50:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6379442041;
        Wed, 13 Jul 2022 11:50:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16B254203F;
        Wed, 13 Jul 2022 11:50:51 +0000 (GMT)
Received: from [9.145.184.105] (unknown [9.145.184.105])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 11:50:51 +0000 (GMT)
Message-ID: <f9435b7b-2d28-a060-8ea7-bbce6b3a30e3@linux.ibm.com>
Date:   Wed, 13 Jul 2022 13:50:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v3 2/3] s390x: skey.c: rework the interrupt
 handler
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com, nrb@linux.ibm.com,
        thuth@redhat.com
References: <20220713104557.168113-1-imbrenda@linux.ibm.com>
 <20220713104557.168113-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220713104557.168113-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4y-O7YPFx8eFtg1udBjbCZAu_XBISWvx
X-Proofpoint-GUID: GopPccvSygoXSJYLZyittnvqjlwB6T0k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 spamscore=0 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/22 12:45, Claudio Imbrenda wrote:
> The skey test currently uses a cleanup function to work around the
> issues that arise when the lowcore is not mapped, since the interrupt
> handler needs to access it.
> 
> Instead of a cleanup function, simply disable DAT for the interrupt
> handler for the tests that remap page 0. This is needed in preparation
> of and upcoming patch that will cause the interrupt handler to read
> from lowcore before calling the cleanup function.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/skey.c | 23 ++++++++---------------
>   1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 445476a0..d2752328 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -250,19 +250,6 @@ static void set_prefix_key_1(uint32_t *prefix_ptr)
>   	);
>   }
>   
> -/*
> - * We remapped page 0, making the lowcore inaccessible, which breaks the normal
> - * handler and breaks skipping the faulting instruction.
> - * Just disable dynamic address translation to make things work.
> - */
> -static void dat_fixup_pgm_int(void)
> -{
> -	uint64_t psw_mask = extract_psw_mask();
> -
> -	psw_mask &= ~PSW_MASK_DAT;
> -	load_psw_mask(psw_mask);
> -}
> -
>   #define PREFIX_AREA_SIZE (PAGE_SIZE * 2)
>   static char lowcore_tmp[PREFIX_AREA_SIZE] __attribute__((aligned(PREFIX_AREA_SIZE)));
>   
> @@ -318,7 +305,13 @@ static void test_set_prefix(void)
>   	report(get_prefix() == old_prefix, "did not set prefix");
>   	report_prefix_pop();
>   
> -	register_pgm_cleanup_func(dat_fixup_pgm_int);
> +	/*
> +	 * Page 0 will be remapped, making the lowcore inaccessible, which
> +	 * breaks the normal handler and breaks skipping the faulting
> +	 * instruction. Disable dynamic address translation for the
> +	 * interrupt handler to make things work.
> +	 */
> +	lowcore.pgm_new_psw.mask &= ~PSW_MASK_DAT;
>   
>   	report_prefix_push("remapped page, fetch protection");
>   	set_prefix(old_prefix);
> @@ -356,7 +349,7 @@ static void test_set_prefix(void)
>   	report_prefix_pop();
>   
>   	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
> -	register_pgm_cleanup_func(NULL);
> +	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT;
>   	report_prefix_pop();
>   	set_storage_key(pagebuf, 0x00, 0);
>   	report_prefix_pop();

