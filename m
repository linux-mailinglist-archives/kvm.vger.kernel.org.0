Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FF956B72D
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 12:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbiGHKUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 06:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237238AbiGHKUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 06:20:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A060717A81;
        Fri,  8 Jul 2022 03:19:59 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2688xWGs008172;
        Fri, 8 Jul 2022 10:19:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bW9JBEzsOEDxvb2JZ3DBwyir+3Nbs7sDSYJpTSxvyAQ=;
 b=LQIP1LqptsbkCtp3QmR5oJdtXpAIFJ/5YefTBkeytay/ktDC+nNyYPxychIdyaA2cHBY
 9SdFoAVDX0Eb9XM48dOsXC0e5xWchw6Vs90267mfL1i0APFTIN9ARfxyt2YWnIaG8ZDe
 S3ItXT+kqXU50OE91A5T71T8y/C0XRdBeysjXW3NNyr46xDxLjmxCzsc/xLFtYw5CAdo
 NXcsZjv8SXlMF82PSpxOnhbpYdZWqjocLFOryUPGD9l7qc5k5tEFF8YFRg7Qg/fPKeTs
 JCAVnImw1DU4zuho4vH6evxl0hHvk/15zrCrL7+pBQl/PONFuj3qynem0iUr8ApT2AjB 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6hbya60s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 10:19:59 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 268A3uFh028627;
        Fri, 8 Jul 2022 10:19:58 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6hbya601-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 10:19:58 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 268A6diu001154;
        Fri, 8 Jul 2022 10:19:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3h4v8qjtnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 10:19:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 268AJqcq17236318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jul 2022 10:19:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A88A5204F;
        Fri,  8 Jul 2022 10:19:52 +0000 (GMT)
Received: from [9.145.3.110] (unknown [9.145.3.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DB2E85204E;
        Fri,  8 Jul 2022 10:19:51 +0000 (GMT)
Message-ID: <a92806fd-ea5e-b3ab-5045-746932dedd36@linux.ibm.com>
Date:   Fri, 8 Jul 2022 12:19:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v2 8/8] s390x: uv-host: Fix init storage
 origin and length check
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220706064024.16573-1-frankja@linux.ibm.com>
 <20220706064024.16573-9-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220706064024.16573-9-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eAnnRqXm8Go88j7lVbrXh5sCFtcOhilo
X-Proofpoint-GUID: yTy_CEti0oI99S9Xz5TJTSFQxz8hQmqf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_08,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207080036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/6/22 08:40, Janosch Frank wrote:
> The origin and length are masked with the HPAGE_MASK and PAGE_MASK
> respectively so adding a few bytes doesn't matter at all.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   s390x/uv-host.c | 19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 1ed8ded1..b1412a20 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -516,17 +516,22 @@ static void test_init(void)
>   	       "storage invalid length");
>   	uvcb_init.stor_len += 8;
>   
> -	uvcb_init.stor_origin =  get_max_ram_size() + 8;
> +	/* Storage origin is 1MB aligned, the length is 4KB aligned */
> +	uvcb_init.stor_origin = get_max_ram_size();
>   	rc = uv_call(0, (uint64_t)&uvcb_init);
> -	report(rc == 1 && uvcb_init.header.rc == 0x104,
> +	report(rc == 1 && (uvcb_init.header.rc == 0x104 || uvcb_init.header.rc == 0x105),
>   	       "storage origin invalid");
>   	uvcb_init.stor_origin = mem;
>   
> -	uvcb_init.stor_origin = get_max_ram_size() - 8;
> -	rc = uv_call(0, (uint64_t)&uvcb_init);
> -	report(rc == 1 && uvcb_init.header.rc == 0x105,
> -	       "storage + length invalid");
> -	uvcb_init.stor_origin = mem;
> +	if (uvcb_init.stor_len >= HPAGE_SIZE) {
> +		uvcb_init.stor_origin = get_max_ram_size() - HPAGE_SIZE;
> +		rc = uv_call(0, (uint64_t)&uvcb_init);
> +		report(rc == 1 && uvcb_init.header.rc == 0x105,
> +		       "storage + length invalid");
> +		uvcb_init.stor_origin = mem;
> +	} else {
> +		report_skip("storage + length invalid, stor_len < HPAGE_SIZE");
> +	}
>   
>   	uvcb_init.stor_origin = 1UL << 30;
>   	rc = uv_call(0, (uint64_t)&uvcb_init);
