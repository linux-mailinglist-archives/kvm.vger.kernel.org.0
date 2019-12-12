Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB17C11CF0D
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 15:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbfLLOBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 09:01:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28359 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729529AbfLLOBN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 09:01:13 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCDoVmK036743
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 09:01:12 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wu4t7859b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 09:01:12 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 12 Dec 2019 14:01:10 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Dec 2019 14:01:08 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBCE18Bk1704386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 14:01:08 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 065A9A405B;
        Thu, 12 Dec 2019 14:01:08 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE294A4068;
        Thu, 12 Dec 2019 14:01:07 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Dec 2019 14:01:07 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 7/9] s390x: css: msch, enable test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
 <1576079170-7244-8-git-send-email-pmorel@linux.ibm.com>
 <20191212130111.0f75fe7f.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 12 Dec 2019 15:01:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191212130111.0f75fe7f.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121214-4275-0000-0000-0000038E463F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121214-4276-0000-0000-000038A1FFFB
Message-Id: <83d45c31-30c3-36e1-1d68-51b88448f4af@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_03:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-12 13:01, Cornelia Huck wrote:
> On Wed, 11 Dec 2019 16:46:08 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> A second step when testing the channel subsystem is to prepare a channel
>> for use.
>> This includes:
>> - Get the current SubCHannel Information Block (SCHIB) using STSCH
>> - Update it in memory to set the ENABLE bit
>> - Tell the CSS that the SCHIB has been modified using MSCH
>> - Get the SCHIB from the CSS again to verify that the subchannel is
>>    enabled.
>>
>> This tests the success of the MSCH instruction by enabling a channel.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 65 insertions(+)
>>
>> diff --git a/s390x/css.c b/s390x/css.c
>> index dfab35f..b8824ad 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -19,12 +19,24 @@
>>   #include <asm/time.h>
>>   
>>   #include <css.h>
>> +#include <asm/time.h>
>>   
>>   #define SID_ONE		0x00010000
>>   
>>   static struct schib schib;
>>   static int test_device_sid;
>>   
>> +static inline void delay(unsigned long ms)
>> +{
>> +	unsigned long startclk;
>> +
>> +	startclk = get_clock_ms();
>> +	for (;;) {
>> +		if (get_clock_ms() - startclk > ms)
>> +			break;
>> +	}
>> +} >
> Would this function be useful for other callers as well? I.e., should
> it go into a common header?

Yes, I wanted to put it in the new time.h with the get_clock_ms()  but 
did not since I already got the RB.
I also did not want to add a patch to the series, but since you ask, I 
can put it in a separate patch to keep the RB and to add it in the time.h

> 
>> +
>>   static void test_enumerate(void)
>>   {
>>   	struct pmcw *pmcw = &schib.pmcw;
>> @@ -64,11 +76,64 @@ out:
>>   	report(1, "Devices, tested: %d, I/O type: %d", scn, scn_found);
>>   }
>>   
>> +static void test_enable(void)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +		int count = 0;
> 
> Odd indentation.

indeed!

> 
>> +	int cc;
>> +
>> +	if (!test_device_sid) {
>> +		report_skip("No device");
>> +		return;
>> +	}
>> +	/* Read the SCHIB for this subchannel */
>> +	cc = stsch(test_device_sid, &schib);
>> +	if (cc) {
>> +		report(0, "stsch cc=%d", cc);
>> +		return;
>> +	}
>> +
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
>> +		 */
>> +		report(0, "msch cc=%d", cc);
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Read the SCHIB again to verify the enablement
>> +	 * insert a little delay and try 5 times.
>> +	 */
>> +	do {
>> +		cc = stsch(test_device_sid, &schib);
>> +		if (cc) {
>> +			report(0, "stsch cc=%d", cc);
>> +			return;
>> +		}
>> +		delay(10);
> 
> That's just a short delay to avoid a busy loop, right? msch should be
> immediate,

Thought you told to me that it may not be immediate in zVM did I 
misunderstand?

> and you probably should not delay on success?

yes, it is not optimized, I can test PMCW_ENABLE in the loop this way we 
can see if, in the zVM case we need to do retries or not.


> 
>> +	} while (!(pmcw->flags & PMCW_ENABLE) && count++ < 5);
> 
> How is this supposed to work? Doesn't the stsch overwrite the control
> block again, so you need to re-set the enable bit before you retry?

I do not think so, there is no msch() in the loop.
Do I miss something?

Thanks for the review,
Regards,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

