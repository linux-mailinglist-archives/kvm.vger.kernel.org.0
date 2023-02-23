Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51F46A05A5
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 11:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjBWKJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 05:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbjBWKJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 05:09:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD9D43920;
        Thu, 23 Feb 2023 02:09:09 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31N9Bu4h014010;
        Thu, 23 Feb 2023 10:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1oue4UQw1nbTfZHLoeSws6kgBfsVnabSpCEFDaR0Hhk=;
 b=CDmxwHz9mEEZBBH7JaU43wOqDqweY2JD2evj0jiuMEvA7rd6mRWH0Qkeu8T0Ku7Djeep
 Jn2tR40pXJdHecQV+RV1MfVFUGuaZbhNP5LlTd9GdyT3wtx3OcxDYYSUWmi9H+eAJsQH
 lu3Z6LUmyh3HR3eUArSElfSU895lz+VILWoCy7GtLMF2y2UqDU2obWELVuWN7g3/z+zg
 ZYbtpFPYUolGADf4avqvJ+olgbh8zQT/w4mHbXAjXGmRpvsKRQ8djsQ5eSfEBp/6XVFW
 gmf3yKnETYL9TYPNdnDvSLi8LuVNaVl3XEYwki4hdMrXAeih4oLPG35TC+erbRFiQoFM fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nx59y9779-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 10:09:08 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31N9SmmA032392;
        Thu, 23 Feb 2023 10:09:08 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nx59y976m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 10:09:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31N78Qg9016665;
        Thu, 23 Feb 2023 10:09:06 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6ehk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 10:09:06 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31NA92Ym23659212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 10:09:02 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71B1D2004B;
        Thu, 23 Feb 2023 10:09:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EA262005A;
        Thu, 23 Feb 2023 10:09:02 +0000 (GMT)
Received: from [9.179.2.177] (unknown [9.179.2.177])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Feb 2023 10:09:01 +0000 (GMT)
Message-ID: <78be2778-9cc8-e635-4eee-0b833e515110@linux.ibm.com>
Date:   Thu, 23 Feb 2023 11:09:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v2 1/3] s390x/spec_ex: Use PSW macro
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20230221174822.1378667-1-nsg@linux.ibm.com>
 <20230221174822.1378667-2-nsg@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230221174822.1378667-2-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8R1lvgdpwG7mp0VhKEfTanIsZld79_um
X-Proofpoint-GUID: LwtUh5vs7_BGr1nNzI2rve3xtp14IWnt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_06,2023-02-23_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302230086
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/23 18:48, Nina Schoetterl-Glausch wrote:
> Replace explicit psw definition by PSW macro.
> No functional change intended.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>   s390x/spec_ex.c | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> index 42ecaed3..2adc5996 100644
> --- a/s390x/spec_ex.c
> +++ b/s390x/spec_ex.c
> @@ -105,10 +105,7 @@ static int check_invalid_psw(void)
>   /* For normal PSWs bit 12 has to be 0 to be a valid PSW*/
>   static int psw_bit_12_is_1(void)
>   {
> -	struct psw invalid = {
> -		.mask = BIT(63 - 12),
> -		.addr = 0x00000000deadbeee
> -	};
> +	struct psw invalid = PSW(BIT(63 - 12), 0x00000000deadbeee);

I think we've passed the point where we can use a constant for the short 
psw. But we can convert that at a later time, I'll add it to the TODO 
list, so:

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
