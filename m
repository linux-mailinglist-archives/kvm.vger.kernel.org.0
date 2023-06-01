Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA39719C27
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 14:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjFAMaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 08:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjFAMaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 08:30:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B30011F;
        Thu,  1 Jun 2023 05:30:16 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351CEDm4003063;
        Thu, 1 Jun 2023 12:30:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N6CZ0TO3WKbtU6m2A/RgVRgEYdSMJr4UlFJ5MMo0MLE=;
 b=Eh9DmmrJC2tP+bxs7b2m4LJIqnBce5Zie231gj8t3lPopXkQyUOkHWdBZAB34mvjg3ay
 phcK+RMUFiobAyiXrJGmANtUORkuIjJLB+E8j0DoVZ8ToZi+xYmbyZX25LR/RyBFPQ7I
 iFoy5+3/s1JJvfiHjBJ0crz+iZrGllWS1b99mqdcKZ7q6LJg2PELQ3/sgwYqlgPfSl0f
 GRbnvFdW72gOhevdg3l863rn0g5TfIHin6gbkh2NSrFxsY9zFtRDZsoE3Gu3v+7VCh+z
 TQ+DQ1P1KxMd9JjO8axYKtmtoBveJmXwOXnCulUJSR8MLwQE7GbFt2JVNdBx2hWha/UV RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxu5g8euu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:30:14 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351CEvrv004589;
        Thu, 1 Jun 2023 12:30:14 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxu5g8etb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:30:14 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3514Pml6020346;
        Thu, 1 Jun 2023 12:30:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qu94e2h4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:30:12 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351CU86D18678512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 12:30:08 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD8EA2004E;
        Thu,  1 Jun 2023 12:30:08 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E23B20040;
        Thu,  1 Jun 2023 12:30:08 +0000 (GMT)
Received: from [9.171.12.131] (unknown [9.171.12.131])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  1 Jun 2023 12:30:08 +0000 (GMT)
Message-ID: <65a1e826-5aea-701e-cd9f-defe1d12b0a2@linux.ibm.com>
Date:   Thu, 1 Jun 2023 14:30:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v4 2/2] s390x: sclp: Implement
 SCLP_RC_INSUFFICIENT_SCCB_LENGTH
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, cohuck@redhat.com
References: <20230530125243.18883-1-pmorel@linux.ibm.com>
 <20230530125243.18883-3-pmorel@linux.ibm.com>
 <20230530173544.378a63c6@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20230530173544.378a63c6@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: COFGXs4-QqrCblxLRW7Ceb6fp6jMEq8W
X-Proofpoint-ORIG-GUID: pYuGBeMPn49wFrhxWuHtpvnhceLSvD58
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010107
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/30/23 17:35, Claudio Imbrenda wrote:
> On Tue, 30 May 2023 14:52:43 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
>
>> If SCLP_CMDW_READ_SCP_INFO fails due to a short buffer, retry
>> with a greater buffer.
> the idea is good, but I wonder if the code can be simplified (see below)
>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/sclp.c | 58 +++++++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 50 insertions(+), 8 deletions(-)
>>
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index 34a31da..9d51ca4 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -17,13 +17,14 @@
>>   #include "sclp.h"
>>   #include <alloc_phys.h>
>>   #include <alloc_page.h>
>> +#include <asm/facility.h>
>>   
>>   extern unsigned long stacktop;
>>   
>>   static uint64_t storage_increment_size;
>>   static uint64_t max_ram_size;
>>   static uint64_t ram_size;
>> -char _read_info[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
>> +char _read_info[2 * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
> this is ok ^
>
> [skip everything else]
>
>>   void sclp_read_info(void)
>>   {
>> -	sclp_read_scp_info((void *)_read_info, SCCB_SIZE);
> 	sclp_read_scp_info((void *)_read_info,
> 		test_facility(140) ? sizeof(_read_info) : SCCB_SIZE;
>
>> +	sclp_read_scp_info((void *)_read_info);
>>   	read_info = (ReadInfo *)_read_info;
>>   }
>>   

You are right, no need to begin with a short buffer if we can go with a 
big one at first try.

I take it

thx



