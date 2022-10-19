Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F776039D0
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 08:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiJSGel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 02:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJSGed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 02:34:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B4A6402
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 23:34:31 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29J6XGc2008595
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 06:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CajxnOu2TTALkL6iV+omnIAZmJvSjAaPYHTP9Q5BxnQ=;
 b=mXXSCf4V2Xm0xYQyTcatLrrVA7vaY6+kR66LaHwlJoIHc1Ky0nS1nJ5zxUPN5SOZGQu8
 AUtd+VpjbLQ+0UX+Cfx2fryOzSeEF6kzAvOABguPcOsNUpqKO0SUbziCu1HqL5MMnjol
 Vo+enSaMHngHt26bHRsyMniyZvWgeqs1OkHa9Q2b0fubEg/vqneefTGJkud2mzkBfJRR
 dIeUg0ZfxZ8sJKx3Q0xoyR47CH7lJKBh4boNCeWFiXM25wfePNq3DCzwNW5sNNYtC9BM
 AHbn4TjfUwQSNZwn0m0V/Kg0cSl1iMh4gV833asrYBs11rc+cFh3u8HVih4AUnUQrVvM vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kac2jr147-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 06:34:30 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29J6XIN4008656
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 06:34:30 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kac2jr13m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 06:34:30 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29J6LdSM023548;
        Wed, 19 Oct 2022 06:34:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3k7m4jd0hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 06:34:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29J6YPdM5767732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 06:34:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36862A4051;
        Wed, 19 Oct 2022 06:34:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DED49A4040;
        Wed, 19 Oct 2022 06:34:24 +0000 (GMT)
Received: from [9.171.23.38] (unknown [9.171.23.38])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 06:34:24 +0000 (GMT)
Message-ID: <07d7a294-8b86-f05e-e05b-0adafea7bfb5@linux.ibm.com>
Date:   Wed, 19 Oct 2022 08:34:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     nrb@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
References: <20221018140951.127093-1-imbrenda@linux.ibm.com>
 <20221018140951.127093-3-imbrenda@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: uv-host: fix allocation of
 UV memory
In-Reply-To: <20221018140951.127093-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uZX5Pyc02VD596dTA-q63595B5qH32HV
X-Proofpoint-ORIG-GUID: 7bV8Zd257h0aqkfFrfZHvx271jbg5Y5-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_02,2022-10-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/22 16:09, Claudio Imbrenda wrote:
> Allocate the donated storage with 1M alignment from the normal pool, to
> force it to be above 2G without wasting a whole 2G block of memory.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks for fixing this :)
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/uv-host.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index a1a6d120..e1fc0213 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -329,7 +329,7 @@ static void test_init(void)
>   	struct psw psw;
>   
>   	/* Donated storage needs to be over 2GB */
> -	mem = (uint64_t)memalign(1UL << 31, uvcb_qui.uv_base_stor_len);
> +	mem = (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base_stor_len, AREA_NORMAL);
>   
>   	uvcb_init.header.len = sizeof(uvcb_init);
>   	uvcb_init.header.cmd = UVC_CMD_INIT_UV;

