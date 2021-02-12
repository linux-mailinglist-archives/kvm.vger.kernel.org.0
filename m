Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23A131A21B
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 16:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhBLPwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 10:52:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229679AbhBLPwk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 10:52:40 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11CFhCiW061427;
        Fri, 12 Feb 2021 10:52:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j/kVtAPHb3T5JKv7+2Y3L3jZwgYGfBxB+pjQ0XolVA4=;
 b=qsAUc/BYfuLYWrihWFux8Wg+YF1QpmF6GhyL/Lbmk/1PkrGBMtpxZFS632HubaAZGFFC
 y2hmvZ5OqeflGl7LaRaZKLeVM/wANtdi3mKkpbau37QzvN9S3D8G3lbARYX/b48vDHlL
 Ul1eNliCx7mo8pO0DKq9SngyajoZkIcYBZaI+j+0RMR/Tcn4vLJny8Vh7yIEqSYkSkSb
 jP0Upxs5+VZp44+xB55cqpKoR3JpycZAqMsBcPPHBhfuy5fEyHsnkjOmWFpfuXFat14R
 NdaKhPEWPO6pRI84kxAaC5lSgfSYbOx3cr8xNlnqoO80uoqvKghYbhqjx2Iy/KEzyvcO 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nvjgg8jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 10:51:59 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11CFhSxH062862;
        Fri, 12 Feb 2021 10:51:59 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nvjgg8h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 10:51:59 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11CFbLns012953;
        Fri, 12 Feb 2021 15:51:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wp35b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 15:51:56 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11CFphYj15532510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 15:51:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA3FD42041;
        Fri, 12 Feb 2021 15:51:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83DD14204B;
        Fri, 12 Feb 2021 15:51:53 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 15:51:53 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/5] s390x: css: implementing Set
 CHannel Monitor
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
 <1612963214-30397-4-git-send-email-pmorel@linux.ibm.com>
 <20210212115307.627abe8a.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <1b3b3b05-6961-d217-b398-d7a41ef4910a@linux.ibm.com>
Date:   Fri, 12 Feb 2021 16:51:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210212115307.627abe8a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_05:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102120121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/12/21 11:53 AM, Cornelia Huck wrote:
> On Wed, 10 Feb 2021 14:20:12 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We implement the call of the Set CHannel Monitor instruction,
>> starting the monitoring of the all Channel Sub System, and
>> initializing channel subsystem monitoring.
>>
>> An initial test reports the presence of the extended measurement
>> block feature.
>>
>> Several tests on SCHM verify the error reporting of the hypervisor.
> 
> Combine these two into one sentence?
> 
> "Initial tests report the presence of the extended measurement block
> feature, and verify the error reporting of the hypervisor for SCHM."
> 
> Also, you add the infrastructure for enabling measurements at the
> subchannel -- either mention this in the patch description or move it
> to a separate patch or the first user?

yes, I change for one of these solutions, thanks.

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     | 19 +++++++++++-
>>   lib/s390x/css_lib.c | 74 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/css.c         | 36 ++++++++++++++++++++++
>>   3 files changed, 128 insertions(+), 1 deletion(-)
>>
> 
> (...)
> 
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 5426a6b..355881d 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -267,6 +267,80 @@ retry:
>>   	return -1;
>>   }
>>   
>> +static bool schib_update(int schid, uint64_t mb, uint16_t mbi, uint16_t flags,
>> +		  bool format1)
> 
> Maybe schib_update_mb()?

yes, it is dedicated.

> 
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int cc;
>> +
>> +	/* Read the SCHIB for this subchannel */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
>> +		return false;
>> +	}
>> +
>> +	/* Update the SCHIB to enable the measurement block */
>> +	pmcw->flags |= flags;
> 
> Do we also want to be able to disable it again?

Yes, I can add the disabling of the measurement on a channel.
In the test I disable it for the system but we may need this later.


> 
>> +
>> +	if (format1)
>> +		pmcw->flags2 |= PMCW_MBF1;
>> +	else
>> +		pmcw->flags2 &= ~PMCW_MBF1;
>> +
>> +	pmcw->mbi = mbi;
>> +	schib.mbo = mb;
>> +
>> +	/* Tell the CSS we want to modify the subchannel */
>> +	cc = msch(schid, &schib);
>> +	if (cc) {
>> +		/*
>> +		 * If the subchannel is status pending or
>> +		 * if a function is in progress,
>> +		 * we consider both cases as errors.
>> +		 */
>> +		report_info("msch: sch %08x failed with cc=%d", schid, cc);
>> +		return false;
>> +	}
>> +
>> +	/*
>> +	 * Read the SCHIB again to verify the measurement block origin
>> +	 */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch: updating sch %08x failed with cc=%d",
>> +			    schid, cc);
>> +		return false;
>> +	}
> 
> Hm, you only do the stsch, but do not check the result (that is done by
> the caller) -- remove the misleading comment or replace it with "Read
> the SCHIB again"?

right, "Read the SCHIB again"

> 
>> +
>> +	return true;
>> +}
>> +
> 
> (...)
> 
> Otherwise, LGTM.
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
