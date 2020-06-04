Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040761EE378
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 13:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgFDLfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 07:35:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59754 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726175AbgFDLfh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 07:35:37 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 054BXc5i139293;
        Thu, 4 Jun 2020 07:35:36 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31c542dju5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 07:35:36 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 054BXlbE139767;
        Thu, 4 Jun 2020 07:35:35 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31c542djrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 07:35:35 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 054BVmet005254;
        Thu, 4 Jun 2020 11:35:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 31bf47c10k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 11:35:30 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 054BZSqJ56033284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 11:35:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61C0F52050;
        Thu,  4 Jun 2020 11:35:28 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.167.22])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 17DB05204E;
        Thu,  4 Jun 2020 11:35:28 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 08/12] s390x: css: stsch, enumeration
 test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-9-git-send-email-pmorel@linux.ibm.com>
 <20200527105501.53681762.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <d3890f6a-1c0e-b4cc-f958-6f33bdf75666@linux.ibm.com>
Date:   Thu, 4 Jun 2020 13:35:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527105501.53681762.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_07:2020-06-02,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006040076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-05-27 10:55, Cornelia Huck wrote:
> On Mon, 18 May 2020 18:07:27 +0200
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
>>   s390x/Makefile      |  1 +
>>   s390x/css.c         | 89 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |  4 ++
>>   3 files changed, 94 insertions(+)
>>   create mode 100644 s390x/css.c
> 
> (...)
> 
>> +static void test_enumerate(void)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int cc;
>> +	int scn;
>> +	int scn_found = 0;
>> +	int dev_found = 0;
>> +
>> +	for (scn = 0; scn < 0xffff; scn++) {
>> +		cc = stsch(scn|SID_ONE, &schib);
>> +		switch (cc) {
>> +		case 0:		/* 0 means SCHIB stored */
>> +			break;
>> +		case 3:		/* 3 means no more channels */
>> +			goto out;
>> +		default:	/* 1 or 2 should never happened for STSCH */
>> +			report(0, "Unexpected cc=%d on subchannel number 0x%x",
>> +			       cc, scn);
>> +			return;
>> +		}
>> +
>> +		/* We currently only support type 0, a.k.a. I/O channels */
>> +		if (PMCW_CHANNEL_TYPE(pmcw) != 0)
>> +			continue;
>> +
>> +		/* We ignore I/O channels without valid devices */
>> +		scn_found++;
>> +		if (!(pmcw->flags & PMCW_DNV))
>> +			continue;
>> +
>> +		/* We keep track of the first device as our test device */
>> +		if (!test_device_sid)
>> +			test_device_sid = scn | SID_ONE;
>> +
>> +		dev_found++;
>> +	}
>> +
>> +out:
>> +	report(dev_found,
>> +	       "Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d",
>> +	       scn, scn_found, dev_found);
> 
> Just wondering: with the current invocation, you expect to find exactly
> one subchannel with a valid device, right?
...snip...

>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 07013b2..a436ec0 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -83,3 +83,7 @@ extra_params = -m 1G
>>   [sclp-3g]
>>   file = sclp.elf
>>   extra_params = -m 3G
>> +
>> +[css]
>> +file = css.elf
>> +extra_params =-device ccw-pong
> 
> Hm... you could test enumeration even with a QEMU that does not include
> support for the pong device, right? Would it be worthwhile to split out
> a set of css tests that use e.g. a virtio-net-ccw device, and have a
> css-pong set of tests that require the pong device?
> 

Yes, you are right, using a virtio-net-ccw will allow to keep this test 
without waiting for the PONG device to exist.

@Thomas, what do you think? I will still have to figure something out 
for PONG tests but here, it should be OK with virtio-net-ccw.

Thanks a lot for the solution, :)

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
