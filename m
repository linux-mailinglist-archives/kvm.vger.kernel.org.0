Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5328A10FA16
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 09:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfLCIqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 03:46:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14128 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725845AbfLCIqA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Dec 2019 03:46:00 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB38dneq045089
        for <kvm@vger.kernel.org>; Tue, 3 Dec 2019 03:45:59 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wm6c1bbsx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 03:45:57 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 3 Dec 2019 08:43:59 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 3 Dec 2019 08:43:57 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB38huAe53280796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Dec 2019 08:43:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FE4742041;
        Tue,  3 Dec 2019 08:43:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 248E04203F;
        Tue,  3 Dec 2019 08:43:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.46])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Dec 2019 08:43:56 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 6/9] s390x: css: stsch, enumeration test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-7-git-send-email-pmorel@linux.ibm.com>
 <20191202152246.4d627b0e.cohuck@redhat.com>
 <aa588c00-79ac-2942-7911-b476abb224db@linux.ibm.com>
 <20191202191541.1ffd987e.cohuck@redhat.com>
 <bb189d95-ddfc-7031-d0dd-7de3e0dd5a7f@linux.ibm.com>
 <20191202204922.508d389f.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Tue, 3 Dec 2019 09:43:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191202204922.508d389f.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120308-0028-0000-0000-000003C3F07D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120308-0029-0000-0000-0000248708C8
Message-Id: <6bc09e13-69f9-78de-9ee1-94f65798f747@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-03_01:2019-11-29,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912030072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-02 20:49, Cornelia Huck wrote:
> On Mon, 2 Dec 2019 19:33:59 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2019-12-02 19:15, Cornelia Huck wrote:
>>> On Mon, 2 Dec 2019 18:53:16 +0100
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>    
>>>> On 2019-12-02 15:22, Cornelia Huck wrote:
>>>>> On Thu, 28 Nov 2019 13:46:04 +0100
>>>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>    
>>>>>> +static int test_device_sid;
>>>>>> +
>>>>>> +static void test_enumerate(void)
>>>>>> +{
>>>>>> +	struct pmcw *pmcw = &schib.pmcw;
>>>>>> +	int sid;
>>>>>> +	int ret, i;
>>>>>> +	int found = 0;
>>>>>> +
>>>>>> +	for (sid = 0; sid < 0xffff; sid++) {
>>>>>> +		ret = stsch(sid|SID_ONE, &schib);
>>>>>
>>>>> This seems a bit odd. You are basically putting the subchannel number
>>>>> into sid, OR in the one, and then use the resulting value as the sid
>>>>> (subchannel identifier).
>>>>>       
>>>>>> +		if (!ret && (pmcw->flags & PMCW_DNV)) {
>>>>>> +			report_info("SID %04x Type %s PIM %x", sid,
>>>>>
>>>>> That's not a sid, but the subchannel number (see above).
>>>>>       
>>>>>> +				     Channel_type[pmcw->st], pmcw->pim);
>>>>>> +			for (i = 0; i < 8; i++)  {
>>>>>> +				if ((pmcw->pim << i) & 0x80) {
>>>>>> +					report_info("CHPID[%d]: %02x", i,
>>>>>> +						    pmcw->chpid[i]);
>>>>>> +					break;
>>>>>> +				}
>>>>>> +			}
>>>>>> +			found++;
>>>>>> +	
>>>>>> +		}
>>>>>
>>>>> Here, you iterate over the 0-0xffff range, even if you got a condition
>>>>> code 3 (indicating no more subchannels in that set). Is that
>>>>> intentional?
>>>>
>>>> I thought there could be more subchannels.
>>>> I need then a break in the loop when this happens.
>>>> I will reread the PoP to see how to find that no more subchannel are in
>>>> that set.
>>>
>>> The fact that cc 3 for stsch == no more subchannels is unfortunately a
>>> bit scattered across the PoP :/ Dug it out some time ago, maybe it's
>>> still in the archives somewhere...
>>
>> So the the subchannel are always one after the other?
> 
> While QEMU (and z/VM) usually do that, they can really be scattered
> around. For the in-between I/O subchannels that don't lead to a device,
> you'll still get cc 0, it's just the dnv bit that is 0. The cc 3
> basically just tells you that you can stop looking.
> 

Thanks for the explanation, I will change the code accordingly.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

