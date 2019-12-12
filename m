Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4F611CEC4
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 14:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbfLLNuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 08:50:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729405AbfLLNuy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 08:50:54 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCDoXBX121641
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 08:50:53 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wuhscjqt0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 08:50:52 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 12 Dec 2019 13:50:50 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Dec 2019 13:50:47 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBCDokch63176904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 13:50:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61A16A405B;
        Thu, 12 Dec 2019 13:50:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D580A4054;
        Thu, 12 Dec 2019 13:50:46 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Dec 2019 13:50:46 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 6/9] s390x: css: stsch, enumeration test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
 <1576079170-7244-7-git-send-email-pmorel@linux.ibm.com>
 <20191212111827.21f64fa3.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 12 Dec 2019 14:50:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191212111827.21f64fa3.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121213-0020-0000-0000-00000397777E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121213-0021-0000-0000-000021EE8096
Message-Id: <38512ecd-737a-e82e-f2f9-4ef2bcb84cdb@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_03:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-12 11:18, Cornelia Huck wrote:
> On Wed, 11 Dec 2019 16:46:07 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> First step for testing the channel subsystem is to enumerate the css and
>> retrieve the css devices.
>>
>> This tests the success of STSCH I/O instruction, we do not test the
>> reaction of the VM for an instruction with wrong parameters.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  1 +
>>   s390x/Makefile      |  2 ++
>>   s390x/css.c         | 88 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |  4 +++
>>   4 files changed, 95 insertions(+)
>>   create mode 100644 s390x/css.c
> 
>> diff --git a/s390x/css.c b/s390x/css.c
>> new file mode 100644
>> index 0000000..dfab35f
>> --- /dev/null
>> +++ b/s390x/css.c
>> @@ -0,0 +1,88 @@
>> +/*
>> + * Channel Subsystem tests
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
>> +#include <alloc_phys.h>
>> +#include <asm/page.h>
>> +#include <string.h>
>> +#include <interrupt.h>
>> +#include <asm/arch_def.h>
>> +#include <asm/time.h>
>> +
>> +#include <css.h>
>> +
>> +#define SID_ONE		0x00010000
>> +
>> +static struct schib schib;
>> +static int test_device_sid;
>> +
>> +static void test_enumerate(void)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int cc;
>> +	int scn;
>> +	int scn_found = 0;
>> +
>> +	for (scn = 0; scn < 0xffff; scn++) {
>> +		cc = stsch(scn|SID_ONE, &schib);
>> +		switch (cc) {
>> +		case 0:		/* 0 means SCHIB stored */
>> +			break;
>> +		case 3:		/* 3 means no more channels */
>> +			goto out;
>> +		default:	/* 1 or 2 should never happened for STSCH */
>> +			report(0, "Unexpected cc=%d on scn 0x%x", cc, scn);
> 
> Spell out "subchannel number"?

Yes I can do this.

> 
>> +			return;
>> +		}
>> +		if (cc)
>> +			break;
> 
> Isn't that redundant?
fully.

> 
>> +		/* We silently only support type 0, a.k.a. I/O channels */
> 
> s/silently/currently/ ?

OK

> 
>> +		if (PMCW_CHANNEL_TYPE(pmcw) != 0)
>> +			continue;
>> +		/* We ignore I/O channels without valid devices */
>> +		if (!(pmcw->flags & PMCW_DNV))
>> +			continue;
>> +		/* We keep track of the first device as our test device */
>> +		if (!test_device_sid)
>> +			test_device_sid = scn|SID_ONE;
>> +		scn_found++;
>> +	}
>> +out:
>> +	if (!scn_found) {
>> +		report(0, "Devices, Tested: %d, no I/O type found", scn);
> 
> It's no I/O _devices_ found, isn't it? There might have been I/O
> subchannels, but none with a valid device...

yes, I will update the stats.

> 
>> +		return;
>> +	}
>> +	report(1, "Devices, tested: %d, I/O type: %d", scn, scn_found);
> 
> As you're testing this anyway: what about tracking _all_ numbers here?
> I.e., advance a counter for I/O subchannels as well, even if !dnv, and
> have an output like >
> "Tested subchannels: 20, I/O subchannels: 18, I/O devices: 10"
> 
> or so?

Yes, will do.


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
> s/Channel Sub-System/Channel Subsystem/ ?

OK, (it was because of "CSS").

> 
>> +	for (i = 0; tests[i].name; i++) {
>> +		report_prefix_push(tests[i].name);
>> +		tests[i].func();
>> +		report_prefix_pop();
>> +	}
>> +	report_prefix_pop();
>> +
>> +	return report_summary();
>> +}
> 
> This basically looks sane to me now.
> 
> Just some additional considerations (we can do that on top, no need to
> do surgery here right now):
> 
> I currently have the (not sure how sensible) idea to add some optional
> testing for vfio-ccw, and this would obviously need some I/O routines as
> well. So, in the long run, it would be good if something like this
> stsch-loop could be factored out to a kind of library function. Just
> some thoughts for now :)
> 

Yes, could be useful.

Thanks,
Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

