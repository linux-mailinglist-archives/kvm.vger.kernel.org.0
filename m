Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC4410EF58
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 19:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfLBSeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 13:34:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727747AbfLBSeH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 13:34:07 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB2IW4LG049122
        for <kvm@vger.kernel.org>; Mon, 2 Dec 2019 13:34:05 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wn3pcmkw5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 13:34:05 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 2 Dec 2019 18:34:03 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Dec 2019 18:34:00 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB2IXJ6u48759136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Dec 2019 18:33:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE381A405D;
        Mon,  2 Dec 2019 18:33:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86CDAA4057;
        Mon,  2 Dec 2019 18:33:59 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Dec 2019 18:33:59 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 6/9] s390x: css: stsch, enumeration test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-7-git-send-email-pmorel@linux.ibm.com>
 <20191202152246.4d627b0e.cohuck@redhat.com>
 <aa588c00-79ac-2942-7911-b476abb224db@linux.ibm.com>
 <20191202191541.1ffd987e.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 2 Dec 2019 19:33:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191202191541.1ffd987e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120218-0020-0000-0000-000003929419
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120218-0021-0000-0000-000021E9B115
Message-Id: <bb189d95-ddfc-7031-d0dd-7de3e0dd5a7f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-02_04:2019-11-29,2019-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 adultscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912020158
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-02 19:15, Cornelia Huck wrote:
> On Mon, 2 Dec 2019 18:53:16 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2019-12-02 15:22, Cornelia Huck wrote:
>>> On Thu, 28 Nov 2019 13:46:04 +0100
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>>>> +static int test_device_sid;
>>>> +
>>>> +static void test_enumerate(void)
>>>> +{
>>>> +	struct pmcw *pmcw = &schib.pmcw;
>>>> +	int sid;
>>>> +	int ret, i;
>>>> +	int found = 0;
>>>> +
>>>> +	for (sid = 0; sid < 0xffff; sid++) {
>>>> +		ret = stsch(sid|SID_ONE, &schib);
>>>
>>> This seems a bit odd. You are basically putting the subchannel number
>>> into sid, OR in the one, and then use the resulting value as the sid
>>> (subchannel identifier).
>>>    
>>>> +		if (!ret && (pmcw->flags & PMCW_DNV)) {
>>>> +			report_info("SID %04x Type %s PIM %x", sid,
>>>
>>> That's not a sid, but the subchannel number (see above).
>>>    
>>>> +				     Channel_type[pmcw->st], pmcw->pim);
>>>> +			for (i = 0; i < 8; i++)  {
>>>> +				if ((pmcw->pim << i) & 0x80) {
>>>> +					report_info("CHPID[%d]: %02x", i,
>>>> +						    pmcw->chpid[i]);
>>>> +					break;
>>>> +				}
>>>> +			}
>>>> +			found++;
>>>> +	
>>>> +		}
>>>
>>> Here, you iterate over the 0-0xffff range, even if you got a condition
>>> code 3 (indicating no more subchannels in that set). Is that
>>> intentional?
>>
>> I thought there could be more subchannels.
>> I need then a break in the loop when this happens.
>> I will reread the PoP to see how to find that no more subchannel are in
>> that set.
> 
> The fact that cc 3 for stsch == no more subchannels is unfortunately a
> bit scattered across the PoP :/ Dug it out some time ago, maybe it's
> still in the archives somewhere...

So the the subchannel are always one after the other?

> 
>>
>>>    
>>>> +		if (found && !test_device_sid)
>>>> +			test_device_sid = sid|SID_ONE;
>>>
>>> You set test_device_sid to the last valid subchannel? Why?
>>
>> The last ? I wanted the first one
> 
> It is indeed the first one, -ENOCOFFEE.

Would never happend to me.


> 
>>
>> I wanted something easy but I should have explain.
>>
>> To avoid doing complicated things like doing a sense on each valid
>> subchannel I just take the first one.
>> Should be enough as we do not go to the device in this test.
> 
> Yes; but you plan to reuse that code, don't you?

yes, so I must think about this

> 
>>
>>>    
>>>> +	}
>>>> +	if (!found) {
>>>> +		report("Found %d devices", 0, found);
> 
> Now that I look at this again: If you got here, you always found 0
> devices, so that message is not super helpful :)

yes, found is too much.
A cut and past from the time I was happy to find even one! :)

> 
>>>> +		return;
>>>> +	}
>>>> +	ret = stsch(test_device_sid, &schib);
>>>
>>> Why do you do a stsch() again?
>>
>> right, no need.
>> In an internal version I used to print some informations from the SCHIB.
>> Since in between I overwrote the SHIB, I did it again.
>> But in this version; no need.
> 
> You could copy the schib of the subchannel to be tested to a different
> place, but I'm not sure it's worth it.
> 
>>
>>>    
>>>> +	if (ret) {
>>>> +		report("Err %d on stsch on sid %08x", 0, ret, test_device_sid);
>>>> +		return;
>>>> +	}
>>>> +	report("Tested", 1);
>>>> +	return;
>>>
>>> I don't think you need this return statement.
>>
>> right I have enough work. :)
>>
>>>
>>> Your test only enumerates devices in the first subchannel set. Do you
>>> plan to enhance the test to enable the MSS facility and iterate over
>>> all subchannel sets?
>>
>> Yes, it is something we can do in a following series
> 
> Sure, just asked out of interest :)
> 

Thanks,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

