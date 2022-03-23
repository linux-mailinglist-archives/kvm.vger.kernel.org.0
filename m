Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4AD4E4DF7
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242564AbiCWISW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242599AbiCWIRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:17:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10506D386;
        Wed, 23 Mar 2022 01:16:24 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22N7CQqZ019046;
        Wed, 23 Mar 2022 08:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=M2gui0GqixXSk8+YwCAzajxYHKxlnsaMOQRdzAQQu5o=;
 b=FQosSHUh5uw0AeAN+IwQpQwM1EMOVCP+TuvL3Vs/jcKjXyXvYyb24Jmedyw7FARHKnCh
 P3TJsI6aghJjrVuYB518zkeX9d8EnIbdV7uS2bq+cKK/jI5CH3eOdV3ysMwd6ZxgFN+7
 gJCtkTeL/7JRDxPMl+ZUcxIB/DKxthE1xiuD20IpidrE/0R9Doq4y4n54kD5xrwKKzK/
 VuvOcKGihQM92v2ciVOedVQu+jtGULAGeDWTvc56lyeKMsaHW3AHXPqipM4gTab+pOxz
 cmQjddsl6hilb03ncT+EzHmm/pXbz2SYtdBUDPxyhunWJTJ54AJTFtwg3bzm88Z7XA4U Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyxxss2s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:16:24 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22N7fTao019306;
        Wed, 23 Mar 2022 08:16:24 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyxxss2r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:16:23 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22N8D7eX032537;
        Wed, 23 Mar 2022 08:16:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3ew6t8pwf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:16:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22N8GIxX36700628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 08:16:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5859711C054;
        Wed, 23 Mar 2022 08:16:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14B2B11C04C;
        Wed, 23 Mar 2022 08:16:18 +0000 (GMT)
Received: from [9.145.94.199] (unknown [9.145.94.199])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 08:16:18 +0000 (GMT)
Message-ID: <569159d8-217c-69ea-5978-628ceb4fa013@linux.ibm.com>
Date:   Wed, 23 Mar 2022 09:16:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v3 4/5] s390x: uv-guest: add share bit test
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220222145456.9956-1-seiden@linux.ibm.com>
 <20220222145456.9956-5-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220222145456.9956-5-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Xnipp9d3TExcTStPDPV3cLMwQo3Xim0-
X-Proofpoint-GUID: wGd01mftz8O-yx8wIZ0FYQfN1btmcK81
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_08,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/22 15:54, Steffen Eiden wrote:
> The UV facility bits shared/unshared must both be set or none.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

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
> +	report(!(share ^ unshare), "share bits");
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

