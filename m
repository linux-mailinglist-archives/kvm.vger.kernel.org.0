Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737E834D022
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 14:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhC2Md0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 08:33:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231221AbhC2MdI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 08:33:08 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TC4VZW140451
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 08:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hKnR6+ZxvPLIDj417vWyfdop2nc/maBe/59KHS7EGZc=;
 b=oXp/w1Z7ZiJXDpghIhks9VmqYJbXZtBvnLQYwajSisiIyglGWSEXwHhWhGbox1AhZv1j
 2mmyhEOdAMu6ZvonE83asBmAMIkx/W/4M1r++rYGvFYCUDX0HxCk4pib9+su9jQL+8VR
 89E5x4LS0bTO6g1h4UjELBNnP/MBlC3WpWq1c4F8f3gvTbHiKsKb1a1M7hgS4w7JuFiE
 hCZABpBBf4VelxFuBV5WEjPtp0Cihpjmo8nKcJ9KWa65DUTLHQ3W4qgaF6EtT3cbKmvO
 BQPiCWN0dFg6OdvmdqFkwvu0d1Hh7TdgROH7lWD0XyjqebF9qos+5x5MxoD0LfgX94D3 lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37jj5yx4ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 08:33:07 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12TC7acf151985
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 08:33:07 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37jj5yx4tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 08:33:07 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TCMZ5q001897;
        Mon, 29 Mar 2021 12:33:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 37hvb88xhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 12:33:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TCX23k54198622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 12:33:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41BDD42041;
        Mon, 29 Mar 2021 12:33:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4FB14203F;
        Mon, 29 Mar 2021 12:33:01 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.64])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 12:33:01 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/8] s390x: lib: css: disabling a
 subchannel
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-2-git-send-email-pmorel@linux.ibm.com>
 <82844be1-dd8f-e205-0966-309bf7c732f6@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <22a648e8-57bd-32d3-586d-08f0a719136c@linux.ibm.com>
Date:   Mon, 29 Mar 2021 14:33:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <82844be1-dd8f-e205-0966-309bf7c732f6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KyhqAxnp_520q4GiVEGTXQY16WFDcxXy
X-Proofpoint-ORIG-GUID: wUAmD3JxX9myV_t_wi1gESxfqGllh49i
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_08:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103250000 definitions=main-2103290095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/29/21 10:00 AM, Thomas Huth wrote:
> On 25/03/2021 10.39, Pierre Morel wrote:
>> Some tests require to disable a subchannel.
>> Let's implement the css_disable() function.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   lib/s390x/css.h     |  1 +
>>   lib/s390x/css_lib.c | 67 +++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 68 insertions(+)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 7e3d261..b0de3a3 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -284,6 +284,7 @@ int css_enumerate(void);
>>   #define IO_SCH_ISC      3
>>   int css_enable(int schid, int isc);
>>   bool css_enabled(int schid);
>> +int css_disable(int schid);
>>   /* Library functions */
>>   int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index efc7057..f5c4f37 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -186,6 +186,73 @@ bool css_enabled(int schid)
>>       }
>>       return true;
>>   }
>> +
>> +/*
>> + * css_disable: disable the subchannel
>> + * @schid: Subchannel Identifier
>> + * Return value:
>> + *   On success: 0
>> + *   On error the CC of the faulty instruction
>> + *      or -1 if the retry count is exceeded.
>> + */
>> +int css_disable(int schid)
>> +{
>> +    struct pmcw *pmcw = &schib.pmcw;
>> +    int retry_count = 0;
>> +    int cc;
>> +
>> +    /* Read the SCHIB for this subchannel */
>> +    cc = stsch(schid, &schib);
>> +    if (cc) {
>> +        report_info("stsch: sch %08x failed with cc=%d", schid, cc);
>> +        return cc;
>> +    }
>> +
>> +    if (!(pmcw->flags & PMCW_ENABLE)) {
>> +        report_info("stsch: sch %08x already disabled", schid);
>> +        return 0;
>> +    }
>> +
>> +retry:
> 
> I have to saythat I really dislike writing loops with gotos if it can be 
> avoided easily. What about:
> 
> for (retry_count = 0; retry_count < MAX_ENABLE_RETRIES; retry_count++) ?
> 
> (and maybe rename that variable to "retries" to keep it short?)

hum, you already said that.
Sorry, I forgot and duplicated css_enable()

done.


...


>> +    /* Read the SCHIB again to verify the enablement */
> 
> "verify the disablement" ?

:) yes

> 
>> +    cc = stsch(schid, &schib);
>> +    if (cc) {
>> +        report_info("stsch: updating sch %08x failed with cc=%d",
>> +                schid, cc);
>> +        return cc;
>> +    }
>> +
>> +    if (!(pmcw->flags & PMCW_ENABLE)) {
>> +        if (retry_count)
>> +            report_info("stsch: sch %08x successfully disabled after 
>> %d retries",
>> +                    schid, retry_count);
>> +        return 0;
>> +    }
>> +
>> +    if (retry_count++ < MAX_ENABLE_RETRIES) {
>> +        /* the hardware was not ready, give it some time */
>> +        mdelay(10);
>> +        goto retry;
>> +    }
>> +
>> +    report_info("msch: modifying sch %08x failed after %d retries. 
>> pmcw flags: %04x",
>> +            schid, retry_count, pmcw->flags);
>> +    return -1;
>> +}
>>   /*
>>    * css_enable: enable the subchannel with the specified ISC
>>    * @schid: Subchannel Identifier
>>
> 
>   Thomas
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
