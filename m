Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794DC519A12
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 10:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346464AbiEDInU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 04:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240868AbiEDInT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 04:43:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BDA1EC5E;
        Wed,  4 May 2022 01:39:44 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2448CsXo021597;
        Wed, 4 May 2022 08:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Sboxsj7b0Y9pf2hhFun4+bcScI6c4lzVGEz5GwA+o/0=;
 b=Y0vYd4DCwjqgXqz0XwRwAFZ4RRN0loAsI2Hf/jWKmDdidsbfpQr1YfviZNzwwhisKBcO
 y6ZKz0JTw1To7UuqG2XrWd8ffTHhzdHaK3S3nCGhAE1Y8MbqlgXKDgA+vehqzA6qnvgC
 aTm3Id7DHjKA3LamIDdsMFBRwOtyCljghN1NAGuCDdpdUgzlpag6JxE1hG0dnt9pp9tS
 XG7HwCFluxHy9vvSeLu6FqZHXQkfo2DNdTxKCn2NjRxtM3/apDCbjMSlmcK8JjTu3Khh
 rMRo7X4YILsNrybkoJf4UYHJIlDqTZtDiEmlFtPJCgGZS6xYeK9Z5/tGFlXwC4EBpTZf KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3funsf0dma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 08:39:44 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2448ObMb002019;
        Wed, 4 May 2022 08:39:43 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3funsf0dkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 08:39:43 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2448cRYe000610;
        Wed, 4 May 2022 08:39:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3frvr8waxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 08:39:41 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2448dcXO18350526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 May 2022 08:39:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BEB3A4054;
        Wed,  4 May 2022 08:39:38 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9207A405B;
        Wed,  4 May 2022 08:39:37 +0000 (GMT)
Received: from [9.152.224.247] (unknown [9.152.224.247])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 May 2022 08:39:37 +0000 (GMT)
Message-ID: <9b6bc442-67b1-45da-1bd4-82b53cc58f82@linux.ibm.com>
Date:   Wed, 4 May 2022 10:39:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v5 5/6] s390x: uv-guest: add share bit test
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220502093925.4118-1-seiden@linux.ibm.com>
 <20220502093925.4118-6-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220502093925.4118-6-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZCEAkghQZ8Cj0pwk1OrWyzHVkWQOI2ny
X-Proofpoint-GUID: 20Pxw_nKgmJM3-goaWdHo-TP7rLniFbf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_02,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 phishscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 adultscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040057
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/22 11:39, Steffen Eiden wrote:
> The UV facility bits shared/unshared must both be set or none.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

>   s390x/uv-guest.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index fd2cfef1..152ad807 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -157,6 +157,16 @@ static void test_invalid(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_share_bits(void)
> +{
> +	bool unshare = uv_query_test_call(BIT_UVC_CMD_REMOVE_SHARED_ACCESS);
> +	bool share = uv_query_test_call(BIT_UVC_CMD_SET_SHARED_ACCESS);
> +
> +	report_prefix_push("query");
> +	report(!(share ^ unshare), "share bits are identical");
> +	report_prefix_pop();
> +}
> +
>   int main(void)
>   {
>   	bool has_uvc = test_facility(158);
> @@ -167,6 +177,12 @@ int main(void)
>   		goto done;
>   	}
>   
> +	/*
> +	 * Needs to be done before the guest-fence,
> +	 * as the fence tests if both shared bits are present
> +	 */
> +	test_share_bits();
> +
>   	if (!uv_os_is_guest()) {
>   		report_skip("Not a protected guest");
>   		goto done;

