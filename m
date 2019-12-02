Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A79910EEC8
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 18:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfLBRxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 12:53:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726673AbfLBRxX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 12:53:23 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB2HlMDV036413
        for <kvm@vger.kernel.org>; Mon, 2 Dec 2019 12:53:22 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wm6c0p477-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 12:53:21 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 2 Dec 2019 17:53:20 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Dec 2019 17:53:17 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB2HqaSj41681270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Dec 2019 17:52:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3700A4055;
        Mon,  2 Dec 2019 17:53:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B353A4053;
        Mon,  2 Dec 2019 17:53:16 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Dec 2019 17:53:16 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 6/9] s390x: css: stsch, enumeration test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-7-git-send-email-pmorel@linux.ibm.com>
 <20191202152246.4d627b0e.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 2 Dec 2019 18:53:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191202152246.4d627b0e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120217-0012-0000-0000-0000036FD49B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120217-0013-0000-0000-000021AB8DA2
Message-Id: <aa588c00-79ac-2942-7911-b476abb224db@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-02_04:2019-11-29,2019-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912020151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-02 15:22, Cornelia Huck wrote:
> On Thu, 28 Nov 2019 13:46:04 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> First step by testing the channel subsystem is to enumerate the css and
> 
> s/by/for/

ok

> 
>> retrieve the css devices.
>>
>> This test the success of STSCH I/O instruction.
> 
> s/test/tests/

yes

> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/Makefile      |  4 ++-
>>   s390x/css.c         | 86 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |  4 +++
>>   3 files changed, 93 insertions(+), 1 deletion(-)
>>   create mode 100644 s390x/css.c
>>
> 
> (...)
> 
>> diff --git a/s390x/css.c b/s390x/css.c
>> new file mode 100644
>> index 0000000..8186f55
>> --- /dev/null
>> +++ b/s390x/css.c
>> @@ -0,0 +1,86 @@
>> +/*
>> + * Channel Sub-System tests
> 
> s/Sub-System/Subsystem/

yes too

> 
>> + *
>> + * Copyright (c) 2019 IBM Corp
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2.
>> + */
>> +
>> +#include <libcflat.h>
>> +
>> +#include <css.h>
>> +
>> +#define SID_ONE		0x00010000
>> +
>> +static struct schib schib;
>> +
>> +static const char *Channel_type[3] = {
>> +	"I/O", "CHSC", "MSG"
> 
> No EADM? :)

I forgot EADM, I will add it!

> 
> I don't think we plan to emulate anything beyond I/O in QEMU, though.

Even, yes, no plan to use it for now.

> 
>> +};
>> +
>> +static int test_device_sid;
>> +
>> +static void test_enumerate(void)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int sid;
>> +	int ret, i;
>> +	int found = 0;
>> +
>> +	for (sid = 0; sid < 0xffff; sid++) {
>> +		ret = stsch(sid|SID_ONE, &schib);
> 
> This seems a bit odd. You are basically putting the subchannel number
> into sid, OR in the one, and then use the resulting value as the sid
> (subchannel identifier).
> 
>> +		if (!ret && (pmcw->flags & PMCW_DNV)) {
>> +			report_info("SID %04x Type %s PIM %x", sid,
> 
> That's not a sid, but the subchannel number (see above).
> 
>> +				     Channel_type[pmcw->st], pmcw->pim);
>> +			for (i = 0; i < 8; i++)  {
>> +				if ((pmcw->pim << i) & 0x80) {
>> +					report_info("CHPID[%d]: %02x", i,
>> +						    pmcw->chpid[i]);
>> +					break;
>> +				}
>> +			}
>> +			found++;
>> +	
>> +		}
> 
> Here, you iterate over the 0-0xffff range, even if you got a condition
> code 3 (indicating no more subchannels in that set). Is that
> intentional?

I thought there could be more subchannels.
I need then a break in the loop when this happens.
I will reread the PoP to see how to find that no more subchannel are in 
that set.

> 
>> +		if (found && !test_device_sid)
>> +			test_device_sid = sid|SID_ONE;
> 
> You set test_device_sid to the last valid subchannel? Why?

The last ? I wanted the first one

I wanted something easy but I should have explain.

To avoid doing complicated things like doing a sense on each valid 
subchannel I just take the first one.
Should be enough as we do not go to the device in this test.

> 
>> +	}
>> +	if (!found) {
>> +		report("Found %d devices", 0, found);
>> +		return;
>> +	}
>> +	ret = stsch(test_device_sid, &schib);
> 
> Why do you do a stsch() again?

right, no need.
In an internal version I used to print some informations from the SCHIB.
Since in between I overwrote the SHIB, I did it again.
But in this version; no need.

> 
>> +	if (ret) {
>> +		report("Err %d on stsch on sid %08x", 0, ret, test_device_sid);
>> +		return;
>> +	}
>> +	report("Tested", 1);
>> +	return;
> 
> I don't think you need this return statement.

right I have enough work. :)

> 
> Your test only enumerates devices in the first subchannel set. Do you
> plan to enhance the test to enable the MSS facility and iterate over
> all subchannel sets?

Yes, it is something we can do in a following series

> 
>> +}
>> +
>> +static struct {
>> +	const char *name;
>> +	void (*func)(void);
>> +} tests[] = {
>> +	{ "enumerate (stsch)", test_enumerate },
>> +	{ NULL, NULL }
>> +};
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	int i;
>> +
>> +	report_prefix_push("Channel Sub-System");
> 
> s/Sub-System/Subsystem/

yes, again.


Thanks for the review.
Regards,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

