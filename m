Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D088D336FF8
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 11:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhCKK0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 05:26:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232246AbhCKK02 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Mar 2021 05:26:28 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BAF0W3168484
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:26:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=f/gJW1bl1K1BX6U/kliaW/uqs31a9RGn/N4aJ7LIw6Q=;
 b=dnAnnZ9RxiIum5jjr0EHe47YRmJxusF5A4iDG2g3TbzmN/53nCEh8/FLoalAiju3RuO7
 CLLhkzkh8+l7lxAWfRkCO75nW1jPTG5Zt+MDsyrzvzCs8cqHD6nNOPADaJFix3Z38JMd
 WkPxkJfDTGYb85KrZyng38+yUdK+zgTk4vQCySNlKSFqyVEun3a19QnW6AHTx+LTctsz
 m0JJzaTEWeHozWmefV3gV0i10ZGFpHVt6OQfs1/TwInezTsV3u9xdaUwKGsKftWTpK36
 64i7gswgM4sO9vpmwq7nl7goAVeCLLE66ry6HykYakAdSEr4qMipvYcymBSrf0QL1oRp ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 377h9g88qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:26:28 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12BAGRlx178253
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:26:27 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 377h9g88pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 05:26:27 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12BAMAGw006609;
        Thu, 11 Mar 2021 10:26:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 376mb0s94f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 10:26:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12BAQ6F734931002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 10:26:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82D2911C04A;
        Thu, 11 Mar 2021 10:26:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 449B111C04C;
        Thu, 11 Mar 2021 10:26:22 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.87.106])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Mar 2021 10:26:22 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 5/6] s390x: css: testing measurement
 block format 0
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
 <1615294277-7332-6-git-send-email-pmorel@linux.ibm.com>
 <20210309180504.715b7997.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <772e21e8-8d83-9417-59f6-3c0238e06179@linux.ibm.com>
Date:   Thu, 11 Mar 2021 11:26:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210309180504.715b7997.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_04:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 suspectscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/9/21 6:05 PM, Cornelia Huck wrote:
> On Tue,  9 Mar 2021 13:51:16 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We test the update of the measurement block format 0, the
>> measurement block origin is calculated from the mbo argument
>> used by the SCHM instruction and the offset calculated using
>> the measurement block index of the SCHIB.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     | 12 ++++++
>>   lib/s390x/css_lib.c |  4 --
>>   s390x/css.c         | 95 ++++++++++++++++++++++++++++++++++++++++-----
>>   3 files changed, 98 insertions(+), 13 deletions(-)
>>
> 
> (...)
> 
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 95d9a78..8f09383 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -365,10 +365,6 @@ void css_irq_io(void)
>>   		       lowcore_ptr->io_int_param, sid);
>>   		goto pop;
>>   	}
>> -	report_info("subsys_id_word: %08x io_int_param %08x io_int_word %08x",
>> -			lowcore_ptr->subsys_id_word,
>> -			lowcore_ptr->io_int_param,
>> -			lowcore_ptr->io_int_word);
> 
> Hm, why are you removing it? If you are doing some general cleanup, it
> probably belongs into patch 2?


Yes, right.
I remove it because there are too many informations shown when the 
trafic becomes more intense.
this was not intended to be here first, I must have forget to remove it 
after debugging during the css series round.


> 
>>   	report_prefix_pop();
>>   
>>   	report_prefix_push("tsch");
>> diff --git a/s390x/css.c b/s390x/css.c
>> index a763814..b63826e 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -74,18 +74,12 @@ static void test_sense(void)
>>   		return;
>>   	}
>>   
>> -	ret = register_io_int_func(css_irq_io);
>> -	if (ret) {
>> -		report(0, "Could not register IRQ handler");
>> -		return;
>> -	}
>> -
> 
> This (and the cleanup changes) definitely belongs into patch 2.

yes too

> 
>>   	lowcore_ptr->io_int_param = 0;
>>   
>>   	senseid = alloc_io_mem(sizeof(*senseid), 0);
>>   	if (!senseid) {
>>   		report(0, "Allocation of senseid");
>> -		goto error_senseid;
>> +		return;
>>   	}
>>   
>>   	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
>> @@ -137,8 +131,24 @@ error:
>>   	free_io_mem(ccw, sizeof(*ccw));
>>   error_ccw:
>>   	free_io_mem(senseid, sizeof(*senseid));
>> -error_senseid:
>> -	unregister_io_int_func(css_irq_io);
>> +}
>> +
>> +static void sense_id(void)
>> +{
>> +	struct ccw1 *ccw;
>> +
>> +	senseid = alloc_io_mem(sizeof(*senseid), 0);
>> +	assert(senseid);
>> +
>> +	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
>> +	assert(ccw);
> 
> You're allocating senseid and ccw every time... wouldn't it be better
> to allocate them once and pass them in as a parameter? (Not that it
> should matter much, I guess.)

OK, since I rework the patch I can change this too I guess.
Thanks.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
