Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2977E4FE4DB
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 17:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbiDLPjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 11:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244365AbiDLPjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 11:39:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002D557B38;
        Tue, 12 Apr 2022 08:36:53 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CEn2MT013876;
        Tue, 12 Apr 2022 15:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+yaQ39sL+wYbez+6L5ksCMlpVuoK54NxPkKsgnRKo5U=;
 b=MQnBdqaPrFaOIiASSH4EHlQ6A/R4KLS+xNLqZv9n3oD7yE1/n+E3hXqOFA/8def4aTyO
 QjNMmXHFkdP6iSrkUmM/MqZ8n41G2w/52ylAi7gI+Xlbp0z/v15GmjpDblz3lgf3zrT5
 p2699sesYu24SKEUn8Nh7lGz/mHd7FyCRpKUzEFJ7ent3nHtJK1Tg836j3ZKJPneaizv
 4VpyhsAdU7j5dJgubCE79f8kon506hbOgW/IKuI3+PWWt16H8/I8EovSz7GVYkJqLpic
 qzoEbCpcy356lMMJx+BJ0asVrIQYsh0+PurRbG+YxyxD80eM0AdGcA1wHcEAMORaXG7k dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd9nb4bh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:36:52 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23CEn5Km014220;
        Tue, 12 Apr 2022 15:36:50 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd9nb4bg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:36:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23CFHsGd025363;
        Tue, 12 Apr 2022 15:36:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fb1s8w58j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 15:36:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23CFat8o47186420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 15:36:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A88E11C04C;
        Tue, 12 Apr 2022 15:36:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C636811C050;
        Tue, 12 Apr 2022 15:36:45 +0000 (GMT)
Received: from [9.145.83.15] (unknown [9.145.83.15])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 15:36:45 +0000 (GMT)
Message-ID: <dbdcbdd5-dad4-d4f1-d0ab-587c3cacafc8@linux.ibm.com>
Date:   Tue, 12 Apr 2022 17:36:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: epsw: fix
 report_pop_prefix() when running under non-QEMU
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220412092941.20742-1-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220412092941.20742-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qIEKgwlwHTHtoCpwhzE8Q5k_IqCuEtSs
X-Proofpoint-GUID: wYNtVEObKDuamaM7xF7oqWGOY6Qiu_Jv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0
 adultscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120074
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/12/22 11:29, Nico Boehr wrote:
> When we don't run in QEMU, we didn't push a prefix, hence pop won't work. Fix
> this by pushing the prefix before the QEMU check.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/epsw.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/epsw.c b/s390x/epsw.c
> index 5b73f4b3db6c..d8090d95a486 100644
> --- a/s390x/epsw.c
> +++ b/s390x/epsw.c
> @@ -97,13 +97,13 @@ static void test_epsw(void)
>   
>   int main(int argc, char **argv)
>   {
> +	report_prefix_push("epsw");
> +
>   	if (!host_is_kvm() && !host_is_tcg()) {
>   		report_skip("Not running under QEMU");
>   		goto done;
>   	}
>   
> -	report_prefix_push("epsw");
> -
>   	test_epsw();
>   
>   done:

