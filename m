Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CBE4147F0
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 13:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbhIVLja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 07:39:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37981 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235698AbhIVLj3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 07:39:29 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18MALCmA003078;
        Wed, 22 Sep 2021 07:37:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=knaAkG16wr5LTkbGu0sHjCbE+cpsFummYaA54pxJ+a0=;
 b=O4QKRj+HQrxrZArNMIJRPfp7LpBzWrbjM7yczRTrFWKoRjmyCrzugS+NL3GCXi9otTdZ
 +ZHOmj7KVJ/zqcTvPGNAf+3d7Irry4/rAG5x8qpAZ3eh5BDtExCXuaXlYemMbksPSLg9
 O6qtophzo1QwOnAZjyIz2jTMwLmBHTZEOSH2X/FoBIQq3DelIo/fiGVD/2B5iuIBeb1L
 WCizsd4lPKt/kGDEEJc4f/806yv1gZmE42RQGFoz4NfVz+xKo2iKO/SOWDxOXtTzEr4h
 H0qlMspDB8f2EPbzL4RWrGRg9qplRYB4zN3BNdvfIotdfaqC09TNTqrLwVVyK6UYxhoT Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7wgsrmax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:37:58 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18MBUDxI030458;
        Wed, 22 Sep 2021 07:37:58 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7wgsrmae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:37:58 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18MBWA5M029279;
        Wed, 22 Sep 2021 11:37:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3b7q6pp32p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 11:37:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18MBX6rX51904822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 11:33:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43DF24C044;
        Wed, 22 Sep 2021 11:37:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5C4C4C046;
        Wed, 22 Sep 2021 11:37:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.85.176])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 11:37:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 5/9] lib: s390x: uv: Add UVC_ERR_DEBUG
 switch
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
References: <20210922071811.1913-1-frankja@linux.ibm.com>
 <20210922071811.1913-6-frankja@linux.ibm.com>
 <20210922112359.3907c54c@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <7ae183a5-4d5c-c8de-2b8d-62a149bf98d0@linux.ibm.com>
Date:   Wed, 22 Sep 2021 13:37:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922112359.3907c54c@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zaJZeTR86-_6RA_kj3lEPnvZHZZsHpKj
X-Proofpoint-GUID: TOrK9-UpYdk8tpAkU6UCfu8TjMQANaIb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_04,2021-09-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 clxscore=1015
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/21 11:23 AM, Claudio Imbrenda wrote:
> On Wed, 22 Sep 2021 07:18:07 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Every time something goes wrong in a way we don't expect, we need to
>> add debug prints to some UVC to get the unexpected return code.
>>
>> Let's just put the printing behind a macro so we can enable it if
>> needed via a simple switch.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> but see a nit below
> 
>> ---
>>  lib/s390x/asm/uv.h | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index 2f099553..0e958ad7 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -12,6 +12,9 @@
>>  #ifndef _ASMS390X_UV_H_
>>  #define _ASMS390X_UV_H_
>>  
>> +/* Enables printing of command code and return codes for failed UVCs
>> */ +#define UVC_ERR_DEBUG	0
>> +
>>  #define UVC_RC_EXECUTED		0x0001
>>  #define UVC_RC_INV_CMD		0x0002
>>  #define UVC_RC_INV_STATE	0x0003
>> @@ -194,6 +197,15 @@ static inline int uv_call_once(unsigned long r1,
>> unsigned long r2) : [cc] "=d" (cc)
>>  		: [r1] "a" (r1), [r2] "a" (r2)
>>  		: "memory", "cc");
>> +
>> +#if UVC_ERR_DEBUG
>> +	if (cc)
> 
> it probably looks cleaner like this:
> 
> 	if (UVC_ERR_DEBUG && cc)
> 
> and without the #if; the compiler should be smart enough to remove the
> dead code. In practice it doesn't really matter in the end, so feel free
> to ignore this comment :)

Didn't consider that, I'll fix it up.
Thank you

> 
>> +		printf("UV call error: call %x rc %x rrc %x\n",
>> +		       ((struct uv_cb_header *)r2)->cmd,
>> +		       ((struct uv_cb_header *)r2)->rc,
>> +		       ((struct uv_cb_header *)r2)->rrc);
>> +#endif
>> +
>>  	return cc;
>>  }
>>  
> 

