Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C497F4EE983
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 10:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbiDAIL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 04:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiDAIL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 04:11:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D39E4DF4E;
        Fri,  1 Apr 2022 01:09:37 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2315hclp016161;
        Fri, 1 Apr 2022 08:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wqxjiXbqHlGhwh49sbBy18A0WmxSRhtuzYbnJic3B4M=;
 b=QdbcvTOVE1w5ZMF60pq1oCmyebGBfk1b27xZAr7xdJsPOQ9Hkv+vUTYYejygXNQ3Ap+v
 z6646k3ikreGC4lHZZTdPAaKzmKl+L1QX2ZVGhZ7NtCplzNrkjkuvciIDjkK7Yd7qXXc
 /yKd51Nizpuciy+IwHHiJ5g62Aey8lF5uRmLI4l+tFJc/srv8vi166/HWdzAzhQiLoyg
 hdi38GRVbo6daJeDoK0G1IYTtpMR1k9HyqoYR+VsT5wWrzU9DdWZNe4mJ6AAhBx7vPrZ
 z6XQuYwO3mNM49Zuet3yUmZxkUerNec/csgIw4sD8en5C32krtOw6JDmNWHzQyiI/DU2 Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f50afax19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 08:09:37 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2317vkIu001042;
        Fri, 1 Apr 2022 08:09:36 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f50afax09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 08:09:36 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23188oG6003101;
        Fri, 1 Apr 2022 08:09:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3f1tf92keq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 08:09:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23189VRg38666614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 08:09:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E37514205C;
        Fri,  1 Apr 2022 08:09:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 815FD4204D;
        Fri,  1 Apr 2022 08:09:30 +0000 (GMT)
Received: from [9.145.70.97] (unknown [9.145.70.97])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 08:09:30 +0000 (GMT)
Message-ID: <890bd089-8c38-17b5-b5d5-1cf79f9c41d1@linux.ibm.com>
Date:   Fri, 1 Apr 2022 10:09:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v2 2/5] s390x: skey: remove check for old
 z/VM version
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com,
        borntraeger@de.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        nrb@linux.ibm.com, thuth@redhat.com, david@redhat.com
References: <20220331160419.333157-1-imbrenda@linux.ibm.com>
 <20220331160419.333157-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220331160419.333157-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jDI_bHcWfxthrgs65v214KFl5sx7AYTd
X-Proofpoint-GUID: jesBVLaKwGCH123gUGTQsg49Z4lXiQNf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_02,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/31/22 18:04, Claudio Imbrenda wrote:
> Remove the check for z/VM 6.x, since it is not needed anymore.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks for taking care of this.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/skey.c | 37 ++++---------------------------------
>   1 file changed, 4 insertions(+), 33 deletions(-)
> 
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 58a55436..edad53e9 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -65,33 +65,9 @@ static void test_set(void)
>   	       "set key test");
>   }
>   
> -/* Returns true if we are running under z/VM 6.x */
> -static bool check_for_zvm6(void)
> -{
> -	int dcbt;	/* Descriptor block count */
> -	int nr;
> -	static const unsigned char zvm6[] = {
> -		/* This is "z/VM    6" in EBCDIC */
> -		0xa9, 0x61, 0xe5, 0xd4, 0x40, 0x40, 0x40, 0x40, 0xf6
> -	};
> -
> -	if (stsi(pagebuf, 3, 2, 2))
> -		return false;
> -
> -	dcbt = pagebuf[31] & 0xf;
> -
> -	for (nr = 0; nr < dcbt; nr++) {
> -		if (!memcmp(&pagebuf[32 + nr * 64 + 24], zvm6, sizeof(zvm6)))
> -			return true;
> -	}
> -
> -	return false;
> -}
> -
>   static void test_priv(void)
>   {
>   	union skey skey;
> -	bool is_zvm6 = check_for_zvm6();
>   
>   	memset(pagebuf, 0, PAGE_SIZE * 2);
>   	report_prefix_push("privileged");
> @@ -106,15 +82,10 @@ static void test_priv(void)
>   	report(skey.str.acc != 3, "skey did not change on exception");
>   
>   	report_prefix_push("iske");
> -	if (is_zvm6) {
> -		/* There is a known bug with z/VM 6, so skip the test there */
> -		report_skip("not working on z/VM 6");
> -	} else {
> -		expect_pgm_int();
> -		enter_pstate();
> -		get_storage_key(pagebuf);
> -		check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> -	}
> +	expect_pgm_int();
> +	enter_pstate();
> +	get_storage_key(pagebuf);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>   	report_prefix_pop();
>   
>   	report_prefix_pop();

