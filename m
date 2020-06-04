Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C0E1EE4BD
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 14:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgFDMqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 08:46:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725926AbgFDMqL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 08:46:11 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 054CWdHO130116;
        Thu, 4 Jun 2020 08:46:10 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31eq3p1g1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 08:46:10 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 054CWjcn130592;
        Thu, 4 Jun 2020 08:46:10 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31eq3p1g0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 08:46:10 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 054CZ60x014617;
        Thu, 4 Jun 2020 12:46:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 31end6gfcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 12:46:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 054Cio3d31326488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 12:44:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA0B7A4055;
        Thu,  4 Jun 2020 12:46:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C54DA404D;
        Thu,  4 Jun 2020 12:46:05 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.167.22])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Jun 2020 12:46:05 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 09/12] s390x: css: msch, enable test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-10-git-send-email-pmorel@linux.ibm.com>
 <20200527114239.65fa9473.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <65501204-f6f3-7800-e382-63ccad77ca38@linux.ibm.com>
Date:   Thu, 4 Jun 2020 14:46:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527114239.65fa9473.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_07:2020-06-02,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 cotscore=-2147483648 mlxlogscore=999 mlxscore=0 bulkscore=0 spamscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006040087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-27 11:42, Cornelia Huck wrote:
> On Mon, 18 May 2020 18:07:28 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> A second step when testing the channel subsystem is to prepare a channel
>> for use.
>> This includes:
>> - Get the current subchannel Information Block (SCHIB) using STSCH
>> - Update it in memory to set the ENABLE bit
>> - Tell the CSS that the SCHIB has been modified using MSCH
>> - Get the SCHIB from the CSS again to verify that the subchannel is
>>    enabled.
>> - If the subchannel is not enabled retry a predefined retries count.
>>
>> This tests the MSCH instruction to enable a channel succesfuly.
>> This is NOT a routine to really enable the channel, no retry is done,
>> in case of error, a report is made.
> 
> Hm... so you retry if the subchannel is not enabled after cc 0, but you
> don't retry if the cc indicates busy/status pending? Makes sense, as we
> don't expect the subchannel to be busy, but a more precise note in the
> patch description would be good :)

OK, I add something like
"
- If the command succeed but subchannel is not enabled retry a
   predefined retries count.
- If the command fails, report the failure and do not retry, even
   if cc indicates a busy/status as we do not expect this.
"

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 67 insertions(+)
>>
>> diff --git a/s390x/css.c b/s390x/css.c
>> index d7989d8..1b60a47 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -16,6 +16,7 @@
>>   #include <string.h>
>>   #include <interrupt.h>
>>   #include <asm/arch_def.h>
>> +#include <asm/time.h>
>>   
>>   #include <css.h>
>>   
>> @@ -65,11 +66,77 @@ out:
>>   	       scn, scn_found, dev_found);
>>   }
>>   
>> +#define MAX_ENABLE_RETRIES	5
>> +static void test_enable(void)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int retry_count = 0;
>> +	int cc;
>> +
>> +	if (!test_device_sid) {
>> +		report_skip("No device");
>> +		return;
>> +	}
>> +
>> +	/* Read the SCHIB for this subchannel */
>> +	cc = stsch(test_device_sid, &schib);
>> +	if (cc) {
>> +		report(0, "stsch cc=%d", cc);
>> +		return;
>> +	}
>> +
>> +	if (pmcw->flags & PMCW_ENABLE) {
>> +		report(1, "stsch: sch %08x already enabled", test_device_sid);
>> +		return;
>> +	}
>> +
>> +retry:
>> +	/* Update the SCHIB to enable the channel */
>> +	pmcw->flags |= PMCW_ENABLE;
>> +
>> +	/* Tell the CSS we want to modify the subchannel */
>> +	cc = msch(test_device_sid, &schib);
>> +	if (cc) {
>> +		/*
>> +		 * If the subchannel is status pending or
>> +		 * if a function is in progress,
>> +		 * we consider both cases as errors.
> 
> Could also be cc 3, but that would be even more weird. Just logging the
> cc seems fine, though.
> 
>> +		 */
>> +		report(0, "msch cc=%d", cc);
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Read the SCHIB again to verify the enablement
>> +	 */
>> +	cc = stsch(test_device_sid, &schib);
>> +	if (cc) {
>> +		report(0, "stsch cc=%d", cc);
>> +		return;
>> +	}
>> +
>> +	if (pmcw->flags & PMCW_ENABLE) {
>> +		report(1, "msch: sch %08x enabled after %d retries",
>> +		       test_device_sid, retry_count);
>> +		return;
>> +	}
>> +
>> +	if (retry_count++ < MAX_ENABLE_RETRIES) {
>> +		mdelay(10); /* the hardware was not ready, let it some time */
> 
> s/let/give/
> 
>> +		goto retry;
>> +	}
>> +
>> +	report(0,
>> +	       "msch: enabling sch %08x failed after %d retries. pmcw: %x",
>> +	       test_device_sid, retry_count, pmcw->flags);
>> +}
>> +
>>   static struct {
>>   	const char *name;
>>   	void (*func)(void);
>>   } tests[] = {
>>   	{ "enumerate (stsch)", test_enumerate },
>> +	{ "enable (msch)", test_enable },
>>   	{ NULL, NULL }
>>   };
>>   
> 
> Otherwise,
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks a lot.
I make the corrections.

regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
