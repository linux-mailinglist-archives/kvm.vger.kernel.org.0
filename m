Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B076F509E95
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 13:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388807AbiDULgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 07:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiDULgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 07:36:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B59515825;
        Thu, 21 Apr 2022 04:33:52 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9C6rm025328;
        Thu, 21 Apr 2022 11:33:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wV1+E6Li2fa4MxXxJacFcaY8sFUXDM1W7KPMga6KPI8=;
 b=aFBkHG131LIUJGHE4T2xnNgXx03sLzkmeM9jl1TPUBw5/Vu6N4FWxOwLLH2dGjvpqSXI
 TaGReEPabIJNgNa0xt1Yw+nCe1PjkfdR4Q4hfpKgDoCNzkeu86aOmnkZ93qqjobs+hL5
 equamXYVNK31aGsgrkEOJO/BbPtb+CleSrH98lRFYZB7Qt+UivFwsotlQz3AwLqSPAsz
 W3VAsF6BdGmNdRlLN6RK1eTbVD9EjR52VGtuigWOMZyEYBGX7U1ooE/0wLCiMjgPHhNY
 wxIxNnSiKh6u5z5VW47lR0G3jxrytMwoFy4Mco8F5vCARHsOoz0v04N8pe9t3LdtsrcN Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjf52mr50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:33:51 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23LBUj0b031742;
        Thu, 21 Apr 2022 11:33:51 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjf52mr4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:33:51 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LBDIlw020020;
        Thu, 21 Apr 2022 11:33:49 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u4m4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:33:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LBKtGL52429172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 11:20:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF21442041;
        Thu, 21 Apr 2022 11:33:45 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 712E242042;
        Thu, 21 Apr 2022 11:33:45 +0000 (GMT)
Received: from [9.145.69.75] (unknown [9.145.69.75])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 11:33:45 +0000 (GMT)
Message-ID: <d7b17bf5-d18f-6e27-73ad-7a5753c4e793@linux.ibm.com>
Date:   Thu, 21 Apr 2022 13:33:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v4 4/5] s390x: uv-guest: add share bit test
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220421094527.32261-1-seiden@linux.ibm.com>
 <20220421094527.32261-5-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220421094527.32261-5-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xgEyrejMilHtZw5Y3t38RP7CmnZcUmnu
X-Proofpoint-ORIG-GUID: 93Tilvnqd4OvGqPw613ZjN5rhBt2G-OC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210064
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/22 11:45, Steffen Eiden wrote:
> The UV facility bits shared/unshared must both be set or none.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   s390x/uv-guest.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 728c60aa..77057bd2 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -159,6 +159,14 @@ static void test_invalid(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_share_bits(void)
> +{
> +	bool unshare = uv_query_test_call(BIT_UVC_CMD_REMOVE_SHARED_ACCESS);
> +	bool share = uv_query_test_call(BIT_UVC_CMD_SET_SHARED_ACCESS);
> +

report_prefix_push("query");

> +	report(!(share ^ unshare), "share bits");

"share bits are identical" ?

report_prefix_pop();

> +}
> +
>   int main(void)
>   {
>   	bool has_uvc = test_facility(158);
> @@ -169,6 +177,12 @@ int main(void)
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

