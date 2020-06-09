Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA41F3599
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 09:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgFIH4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 03:56:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgFIH4J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 03:56:09 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0597awpc095675;
        Tue, 9 Jun 2020 03:56:09 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g41en8br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 03:56:08 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0597qU55146989;
        Tue, 9 Jun 2020 03:56:08 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31g41en8ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 03:56:08 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0597tVbp029175;
        Tue, 9 Jun 2020 07:56:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 31g2s7wg94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 07:56:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0597u31q23593094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jun 2020 07:56:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5E664C052;
        Tue,  9 Jun 2020 07:56:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8802F4C046;
        Tue,  9 Jun 2020 07:56:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.16.61])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jun 2020 07:56:03 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v8 11/12] s390x: css: msch, enable test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-12-git-send-email-pmorel@linux.ibm.com>
 <f888f043-6177-5bcc-f84f-437015457cf3@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <142b419e-3136-750d-17c4-db17724aa5ee@linux.ibm.com>
Date:   Tue, 9 Jun 2020 09:56:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <f888f043-6177-5bcc-f84f-437015457cf3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-09_02:2020-06-08,2020-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 suspectscore=0 cotscore=-2147483648 priorityscore=1501
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006090056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-09 09:47, Thomas Huth wrote:
> On 08/06/2020 10.13, Pierre Morel wrote:
>> A second step when testing the channel subsystem is to prepare a channel
>> for use.
>> This includes:
>> - Get the current subchannel Information Block (SCHIB) using STSCH
>> - Update it in memory to set the ENABLE bit
>> - Tell the CSS that the SCHIB has been modified using MSCH
>> - Get the SCHIB from the CSS again to verify that the subchannel is
>>    enabled.
>> - If the command succeeds but subchannel is not enabled retry a
>>    predefined retries count.
>> - If the command fails, report the failure and do not retry, even
>>    if cc indicates a busy/status pending as we do not expect this.
>>
>> This tests the MSCH instruction to enable a channel succesfuly.
>> This some retries are done and in case of error, and if the retries
>> count is exceeded, a report is made.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css_lib.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/css.c         | 18 ++++++++++++++
>>   2 files changed, 78 insertions(+)
>>
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index dc5a512..831a116 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -15,6 +15,7 @@
>>   #include <string.h>
>>   #include <interrupt.h>
>>   #include <asm/arch_def.h>
>> +#include <asm/time.h>
>>   
>>   #include <css.h>
>>   
>> @@ -68,3 +69,62 @@ out:
>>   		    scn, scn_found, dev_found);
>>   	return schid;
>>   }
>> +
>> +int css_enable(int schid)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int retry_count = 0;
>> +	int cc;
>> +
>> +	/* Read the SCHIB for this subchannel */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch failed with cc=%d", cc);
>> +		return cc;
>> +	}
>> +
>> +	if (pmcw->flags & PMCW_ENABLE) {
>> +		report_info("stsch: sch %08x already enabled", schid);
>> +		return 0;
>> +	}
>> +
>> +retry:
>> +	/* Update the SCHIB to enable the channel */
>> +	pmcw->flags |= PMCW_ENABLE;
>> +
>> +	/* Tell the CSS we want to modify the subchannel */
>> +	cc = msch(schid, &schib);
>> +	if (cc) {
>> +		/*
>> +		 * If the subchannel is status pending or
>> +		 * if a function is in progress,
>> +		 * we consider both cases as errors.
>> +		 */
>> +		report_info("msch failed with cc=%d", cc);
>> +		return cc;
>> +	}
>> +
>> +	/*
>> +	 * Read the SCHIB again to verify the enablement
>> +	 */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {
>> +		report_info("stsch failed with cc=%d", cc);
>> +		return cc;
>> +	}
>> +
>> +	if (pmcw->flags & PMCW_ENABLE) {
>> +		report_info("Subchannel %08x enabled after %d retries",
>> +			    schid, retry_count);
>> +		return 0;
>> +	}
>> +
>> +	if (retry_count++ < MAX_ENABLE_RETRIES) {
>> +		mdelay(10); /* the hardware was not ready, give it some time */
>> +		goto retry;
>> +	}
>> +
>> +	report_info("msch: enabling sch %08x failed after %d retries. pmcw flags: %x",
>> +		    schid, retry_count, pmcw->flags);
>> +	return -1;
>> +}
>> diff --git a/s390x/css.c b/s390x/css.c
>> index f0e8f47..6f58d4a 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -40,11 +40,29 @@ static void test_enumerate(void)
>>   	}
>>   }
>>   
>> +static void test_enable(void)
>> +{
>> +	int cc;
>> +
>> +	if (!test_device_sid) {
>> +		report_skip("No device");
>> +		return;
>> +	}
>> +
>> +	cc = css_enable(test_device_sid);
>> +
>> +	if (cc)
>> +		report(0, "Failed to enable subchannel %08x", test_device_sid);
>> +	else
>> +		report(1, "Subchannel %08x enabled", test_device_sid);
> 
> Could you please write this as:
> 
> 	report(cc == 1, "Enable subchannel %08x", test_device_sid);
> 
> ... checking for a right value is the whole point of the first parameter
> of report() :-)
> 
>   Thanks,
>    Thomas
> 

OK, thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
