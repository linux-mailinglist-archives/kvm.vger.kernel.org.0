Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120E7605952
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 10:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiJTIIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 04:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiJTIH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 04:07:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826571757B1
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 01:07:57 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K7nr2g022918
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:07:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ocvmhZA68tFlIJ8wrSQjZntC1szPs5Y85vXyuGTBuY8=;
 b=C1OWBmcLgcSf0kU152mY8CJmWyV1I1CNx9mV6LxYXEYJumYP5SWpQYAjBQ8ZQ5oeewLy
 8qg9W/BmLdDwXRYqVsTxErwXyw82m8s4GDDO9r98qC3f7z2ibp540g1cgzIThQ50SwcQ
 Rqmjo42vBtTmxi3rKbuHK8QSqdALyBlDlqAwS1hzNaizbV+ErzN1bqjCuoXFSvuMbeEN
 VetU2RmGyhY/BycY7CYGhxmL25qjZk8jzA6AESuIAItJ7heMuVYU8yePF2yUFgYX9Bcm
 Y8igl4FsWuSe3C/1df7sBERqLNt+qUC5Sd8Y7rIFzptANvpVzGKocKmjJJjdD+guIE3K UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb29q0nmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:07:56 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K7oaR1025942
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:07:55 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb29q0nk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 08:07:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K85FIe000762;
        Thu, 20 Oct 2022 08:07:54 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg98hqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 08:07:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K87pSe2490938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 08:07:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BCA9AE045;
        Thu, 20 Oct 2022 08:07:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C957CAE053;
        Thu, 20 Oct 2022 08:07:50 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 08:07:50 +0000 (GMT)
Message-ID: <a6bd8a00-b6b7-1e0f-1989-c5b59d3182fd@linux.ibm.com>
Date:   Thu, 20 Oct 2022 10:07:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: uv-host: fix allocation of
 UV memory
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
References: <20221018140951.127093-1-imbrenda@linux.ibm.com>
 <20221018140951.127093-3-imbrenda@linux.ibm.com>
Content-Language: en-US
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20221018140951.127093-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TRCB3yUyOaSbxdDuJZYtL_Tm1U0rZ_TP
X-Proofpoint-GUID: VhEVKqagN0eF_-9m0afeGYbjH_ie6VTH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200047
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
LGTM
Reviewed-by; Steffen Eiden <seiden@linux.ibm.com>

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
