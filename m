Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD0311E8AF
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbfLMQuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:50:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46230 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728065AbfLMQuJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 11:50:09 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDGgrOZ140720
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 11:50:08 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wuhsdxe6k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 11:50:08 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 13 Dec 2019 16:50:06 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 13 Dec 2019 16:50:03 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBDGo26d47579352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 16:50:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57E8A5204F;
        Fri, 13 Dec 2019 16:50:02 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 217D25205F;
        Fri, 13 Dec 2019 16:50:02 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 9/9] s390x: css: ping pong
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
 <1576079170-7244-10-git-send-email-pmorel@linux.ibm.com>
 <20191213105009.482bab48.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 13 Dec 2019 17:50:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191213105009.482bab48.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121316-0016-0000-0000-000002D487B8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121316-0017-0000-0000-00003336B452
Message-Id: <bb6c04a1-501c-16c4-107b-f10ac9d1e41d@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_05:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-13 10:50, Cornelia Huck wrote:
> On Wed, 11 Dec 2019 16:46:10 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> To test a write command with the SSCH instruction we need a QEMU device,
>> with control unit type 0xC0CA. The PONG device is such a device.
>>
>> This type of device responds to PONG_WRITE requests by incrementing an
>> integer, stored as a string at offset 0 of the CCW data.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 46 insertions(+)
>>
>> diff --git a/s390x/css.c b/s390x/css.c
>> index 7b9bdb1..a09cdff 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -26,6 +26,9 @@
>>   
>>   #define CSS_TEST_INT_PARAM	0xcafec0ca
>>   #define PONG_CU_TYPE		0xc0ca
>> +/* Channel Commands for PONG device */
>> +#define PONG_WRITE	0x21 /* Write */
>> +#define PONG_READ	0x22 /* Read buffer */
>>   
>>   struct lowcore *lowcore = (void *)0x0;
>>   
>> @@ -302,6 +305,48 @@ unreg_cb:
>>   	unregister_io_int_func(irq_io);
>>   }
>>   
>> +static void test_ping(void)
>> +{
>> +	int success, result;
>> +	int cnt = 0, max = 4;
>> +
>> +	if (senseid.cu_type != PONG_CU) {
>> +		report_skip("No PONG, no ping-pong");
>> +		return;
>> +	}
>> +
>> +	result = register_io_int_func(irq_io);
>> +	if (result) {
>> +		report(0, "Could not register IRQ handler");
>> +		return;
>> +	}
>> +
>> +	while (cnt++ < max) {
>> +		snprintf(buffer, BUF_SZ, "%08x\n", cnt);
>> +		success = start_subchannel(PONG_WRITE, buffer, 8);
> 
> Magic value? Maybe introduce a #define for the lengths of the
> reads/writes?

OK, and I also do not need a buffer so big.

> 
> [This also got me thinking about your start_subchannel function
> again... do you also want to allow flags like e.g. SLI? It's not
> unusual for commands to return different lengths of data depending on
> what features are available; it might be worthwhile to allow short data
> if you're not sure that e.g. a command returns either the short or the
> long version of a structure.]

I would prefer to keep simple it in this series if you agree.

AFAIU the current QEMU implementation use a fix length and if a short 
read occurs it is an error.
Since we test on PONG, there should be no error.

I agree that for a general test we should change this, but currently the 
goal is just to verify that the remote device is PONG.

If we accept variable length, we need to check the length of what we 
received, and this could need some infrastructure changes that I would 
like to do later.

When the series is accepted I will begin to do more complicated things like:
- checking the exceptions for wrong parameters
   This is the first I will add.
- checking the response difference on flags (SLI, SKP)
- using CC and CD flags for chaining
- TIC, NOP, suspend/resume and PCI

These last one will be fun, we can also trying to play with prefetch 
while at it. :)

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

