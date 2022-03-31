Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F4C4EDCBC
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 17:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbiCaP0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 11:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238229AbiCaP0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 11:26:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5611BBF4D;
        Thu, 31 Mar 2022 08:24:33 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VFKSca027182;
        Thu, 31 Mar 2022 15:24:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VmegGJMxnxdekIkx+TpYi7vCIOW0KjPHiOTcknUYv6M=;
 b=AaEPXlIwl8gFXFyjbaA9QJvLt+2L3jC00m0JDoKAGfOxMKNv8ORDj6jDq0nFYtTCNTFq
 BYOKuM1lKpS4KEpFxCAYetpp2WQLRGfmgWqNfsrAHF/X9xX7l9y97IE6S19LcU6j6NH3
 dEN3Uwn1EUmrwLrTgjdZIk55eGIWkc4AYun8eUCvP8a5q0NUInyjjEtRGCG+8bI9INXd
 fPUMsnlUGVvd2J1gXRdT9tLgSkt4+YC+irlOvOW7Zde5uwFF6mSrzDYNRJJ0lHplput3
 x6+Pp2k5NAKBPVHC8BXB10yUQYXoCBpO2sux/mSGKSjxMoCaxIyLxBE61zf3Fi1CiLe9 ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f54epp6ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:24:32 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VF93S3024125;
        Thu, 31 Mar 2022 15:24:32 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f54epp6f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:24:32 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VFDbUk002688;
        Thu, 31 Mar 2022 15:24:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3f3rs3p2qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:24:30 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VFORRZ44958032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 15:24:27 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1E0E11C04A;
        Thu, 31 Mar 2022 15:24:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86FEF11C04C;
        Thu, 31 Mar 2022 15:24:26 +0000 (GMT)
Received: from [9.145.159.108] (unknown [9.145.159.108])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 15:24:26 +0000 (GMT)
Message-ID: <3026196e-7a6f-307b-cf83-cd362ef804f1@linux.ibm.com>
Date:   Thu, 31 Mar 2022 17:24:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v1 4/4] lib: s390x: stidp wrapper and move
 get_machine_id
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com,
        borntraeger@de.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        nrb@linux.ibm.com, thuth@redhat.com, david@redhat.com
References: <20220330144339.261419-1-imbrenda@linux.ibm.com>
 <20220330144339.261419-5-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220330144339.261419-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f5sFbVgendPWGBGYm7ZLquYrwRD-zx9k
X-Proofpoint-ORIG-GUID: 2pEnBbq4f9rPxIZh1kZ3iJGzmwBr2Uin
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/22 16:43, Claudio Imbrenda wrote:
> Refactor get_machine_id in arch_def.h into a simple wrapper around
> stidp, add back get_machine_id in hardware.h using the stidp wrapper.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   lib/s390x/asm/arch_def.h | 4 +---
>   lib/s390x/hardware.h     | 5 +++++
>   2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 8d860ccf..bab3c374 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -219,13 +219,11 @@ static inline unsigned short stap(void)
>   	return cpu_address;
>   }
>   
> -static inline uint16_t get_machine_id(void)
> +static inline uint64_t stidp(void)
>   {
>   	uint64_t cpuid;
>   
>   	asm volatile("stidp %0" : "=Q" (cpuid));
> -	cpuid = cpuid >> 16;
> -	cpuid &= 0xffff;
>   
>   	return cpuid;
>   }
> diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
> index fb6565ad..8783ae9c 100644
> --- a/lib/s390x/hardware.h
> +++ b/lib/s390x/hardware.h
> @@ -43,6 +43,11 @@ enum s390_host {
>   
>   enum s390_host detect_host(void);
>   
> +static inline uint16_t get_machine_id(void)
> +{
> +	return stidp() >> 16;
> +}
> +
>   static inline bool host_is_tcg(void)
>   {
>   	return detect_host() == HOST_IS_TCG;

