Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817824F6756
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 19:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238898AbiDFR2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 13:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238969AbiDFR1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 13:27:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367124B518B;
        Wed,  6 Apr 2022 08:27:16 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236Epe9O018258;
        Wed, 6 Apr 2022 15:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Gf5umlriGI/RaQjNorBWbCVl4P3wKYF3K7VotD3bb3g=;
 b=m1GZLS2AsT4HTTYnCJSWy7z1dnJhGyBaBDKpJp+XwM5v/XUgw9EqOezDhGYFmd9PJJZ3
 tD/xAOwfOokQg9eOS/fBFr4A4Q/kLU11BPzjXyKawrX4TbRIGJRnWIKFIE1LneaYh8yG
 p6T0uY+/jOL02tVeTozFOUAcLuO61vS5sVNGHZyxUn62xZsSnIqe8uQSymQSqcPf9h3r
 UVOPcADtWrOVbOct13uuqAvOjfr2rndX0Mx6gkgSq6YQSRhdrl2Y4C+iLZmd1cVVhNic
 8MSDZknhqeCaghICrgF3dQeZxby5Jl+3qqZGsYJj14wky1V7Qi+XeHqNHUTblWntjrVe rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f98h2y773-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Apr 2022 15:27:15 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 236DQrYS029299;
        Wed, 6 Apr 2022 15:27:14 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f98h2y76f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Apr 2022 15:27:14 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 236FHGn9026957;
        Wed, 6 Apr 2022 15:27:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e49029y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Apr 2022 15:27:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 236FErei46662088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Apr 2022 15:14:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94EF4A405B;
        Wed,  6 Apr 2022 15:27:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33A42A4054;
        Wed,  6 Apr 2022 15:27:09 +0000 (GMT)
Received: from [9.145.26.85] (unknown [9.145.26.85])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Apr 2022 15:27:09 +0000 (GMT)
Message-ID: <3168d4f4-0a7c-e19f-c1b2-2b00e6e1ba0a@linux.ibm.com>
Date:   Wed, 6 Apr 2022 17:27:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
References: <20220405075225.15903-1-frankja@linux.ibm.com>
 <20220405075225.15903-6-frankja@linux.ibm.com>
 <bf27586e-4eb2-4392-1293-328c743eb8ec@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 5/8] s390x: pv-diags: Cleanup includes
In-Reply-To: <bf27586e-4eb2-4392-1293-328c743eb8ec@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5j7KJEZHjTRo886x8lJxYocos8Qi3xEw
X-Proofpoint-GUID: lXQk_yqi6cua17W6arGSZDcsSAaeOigY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_08,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204060073
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/22 08:50, Thomas Huth wrote:
> On 05/04/2022 09.52, Janosch Frank wrote:
>> This file has way too much includes. Time to remove some.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/pv-diags.c | 17 ++---------------
>>    1 file changed, 2 insertions(+), 15 deletions(-)
>>
>> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
>> index 6899b859..9ced68c7 100644
>> --- a/s390x/pv-diags.c
>> +++ b/s390x/pv-diags.c
>> @@ -8,23 +8,10 @@
>>     *  Janosch Frank <frankja@linux.ibm.com>
>>     */
>>    #include <libcflat.h>
>> -#include <asm/asm-offsets.h>
>> -#include <asm-generic/barrier.h>
>> -#include <asm/interrupt.h>
>> -#include <asm/pgtable.h>
>> -#include <mmu.h>
>> -#include <asm/page.h>
>> -#include <asm/facility.h>
>> -#include <asm/mem.h>
>> -#include <asm/sigp.h>
>> -#include <smp.h>
>> -#include <alloc_page.h>
>> -#include <vmalloc.h>
>> -#include <sclp.h>
>>    #include <snippet.h>
>>    #include <sie.h>
>> -#include <uv.h>
>> -#include <asm/uv.h>
>> +#include <sclp.h>
>> +#include <asm/facility.h>
> 
> Wow, how did we end up with that huge list? Copy-n-paste from other files?
> 

Yes, and lots of work to get it working in the first place which pulled 
in headers which weren't removed later once they were unused.

That's one of the reasons why I suggested the templates to you :-)

> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks
