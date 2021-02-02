Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F38930C546
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 17:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhBBQSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:18:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236137AbhBBQQL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 11:16:11 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 112GDOtl137758;
        Tue, 2 Feb 2021 11:15:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Yto4Q4S51dPnvwNvL9+elMmy/TSPqDq0etEpfyp42IE=;
 b=pElyvGYWhcKwN6QnBtuwzQgpZBU6bPpEJ6HOBD4943o6TTmrU0t586A3XHGWpHwnNSZz
 xObpMpUF1lWk59+xmmOXemXk8AzDP82tFQfUSskvkMLXhQO0RWBSsVkYQM1xvhdMaJa8
 mwB8Vh8jajIo1Ms/9lHRicBbDkQQcmy3FsDPUgDwqClS7hm5o19upKeZOa81ICCcgsZb
 CIQ/AOHRrRfYNLIvNWRm5jrYl52ofEnkKspVb946H4SxyRpssVFgaVeuMtlXiwxI0/AR
 LflQp+2EautK8zW5w5MgrBiR4T0Oo5aA4qrtWu6oViiGhDsHmlrc5f+gPQXbETbcddmi yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fa2m02ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 11:15:28 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 112GE3pV139587;
        Tue, 2 Feb 2021 11:15:28 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36fa2m02ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 11:15:28 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 112Fah3q004976;
        Tue, 2 Feb 2021 16:15:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 36cy38k1tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 16:15:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 112GFNI225493778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Feb 2021 16:15:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C7CDA4054;
        Tue,  2 Feb 2021 16:15:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08C84A4066;
        Tue,  2 Feb 2021 16:15:23 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.19.13])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Feb 2021 16:15:22 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 3/5] s390x: css: implementing Set
 CHannel Monitor
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-4-git-send-email-pmorel@linux.ibm.com>
 <20210202124818.6084bb36.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <e28ee611-faad-bb2d-ede2-3efcb7b56c53@linux.ibm.com>
Date:   Tue, 2 Feb 2021 17:15:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202124818.6084bb36.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_07:2021-02-02,2021-02-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/2/21 12:48 PM, Cornelia Huck wrote:
> On Fri, 29 Jan 2021 15:34:27 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We implement the call of the Set CHannel Monitor instruction,
>> starting the monitoring of the all Channel Sub System, and
> 
> "initializing channel subsystem monitoring" ?

Yes, better I take this.

> 
>> the initialization of the monitoring on a Sub Channel.
> 
> "enabling monitoring for a subchannel" ?
> 
>>
>> An initial test reports the presence of the extended measurement
>> block feature.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     | 17 +++++++++-
>>   lib/s390x/css_lib.c | 77 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/css.c         |  7 +++++
>>   3 files changed, 100 insertions(+), 1 deletion(-)
>>
> 
> (...)
> 
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index f300969..9e0f568 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -205,6 +205,83 @@ retry:
>>   	return -1;
>>   }
>>   
>> +/*
>> + * css_enable_mb: enable the subchannel Mesurement Block
>> + * @schid: Subchannel Identifier
>> + * @mb   : 64bit address of the measurement block
>> + * @format1: set if format 1 is to be used
>> + * @mbi : the measurement block offset
>> + * @flags : PMCW_MBUE to enable measurement block update
>> + *	    PMCW_DCTME to enable device connect time
>> + * Return value:
>> + *   On success: 0
>> + *   On error the CC of the faulty instruction
>> + *      or -1 if the retry count is exceeded.
>> + */
>> +int css_enable_mb(int schid, uint64_t mb, int format1, uint16_t mbi,
>> +		  uint16_t flags)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int retry_count = 0;
>> +	int cc;
>> +
>> +	/* Read the SCHIB for this subchannel */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
>> +		return cc;
>> +	}
>> +
>> +retry:
>> +	/* Update the SCHIB to enable the measurement block */
>> +	pmcw->flags |= flags;
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
> 
> Setting some invalid flags for measurements in the schib could lead to
> an operand exception. Do we want to rely on the caller always getting
> it right, or should we add handling for those invalid flags? (Might
> also make a nice test case.)

Yes it does.
I add new test cases to test if we get the right error.


Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
