Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8389118F20
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 18:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfLJRft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 12:35:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727527AbfLJRft (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 12:35:49 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBAHMdtP176487
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 12:35:48 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wr8kxtn9v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 12:35:47 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 10 Dec 2019 17:35:44 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Dec 2019 17:35:41 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBAHZfTl60620840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 17:35:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F15BDA4051;
        Tue, 10 Dec 2019 17:35:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB24EA4053;
        Tue, 10 Dec 2019 17:35:40 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Dec 2019 17:35:40 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 7/9] s390x: css: msch, enable test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-8-git-send-email-pmorel@linux.ibm.com>
 <20191209175430.5381b328.cohuck@redhat.com>
 <a19d7e91-4048-3eaa-a819-51e95dd922de@linux.ibm.com>
 <20191210100950.466e6211.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Tue, 10 Dec 2019 18:35:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191210100950.466e6211.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19121017-4275-0000-0000-0000038DB1DC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121017-4276-0000-0000-000038A163BE
Message-Id: <bf954926-fd77-9255-497b-44b825016a6f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_05:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-10 10:09, Cornelia Huck wrote:
> On Tue, 10 Dec 2019 10:01:46 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2019-12-09 17:54, Cornelia Huck wrote:
>>> On Fri,  6 Dec 2019 17:26:26 +0100
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>    
>>>> A second step when testing the channel subsystem is to prepare a channel
>>>> for use.
>>>> This includes:
>>>> - Get the current SubCHannel Information Block (SCHIB) using STSCH
>>>> - Update it in memory to set the ENABLE bit
>>>> - Tell the CSS that the SCHIB has been modified using MSCH
>>>> - Get the SCHIB from the CSS again to verify that the subchannel is
>>>>     enabled.
>>>>
>>>> This tests the success of the MSCH instruction by enabling a channel.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    s390x/css.c | 39 +++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 39 insertions(+)
>>>>
>>>> diff --git a/s390x/css.c b/s390x/css.c
>>>> index 3d4a986..4c0031c 100644
>>>> --- a/s390x/css.c
>>>> +++ b/s390x/css.c
>>>> @@ -58,11 +58,50 @@ static void test_enumerate(void)
>>>>    	report("Tested %d devices, %d found", 1, scn, found);
>>>>    }
>>>>    
>>>> +static void test_enable(void)
>>>> +{
>>>> +	struct pmcw *pmcw = &schib.pmcw;
>>>> +	int cc;
>>>> +
>>>> +	if (!test_device_sid) {
>>>> +		report_skip("No device");
>>>> +		return;
>>>> +	}
>>>> +	/* Read the SCIB for this subchannel */
>>>
>>> s/SCIB/SCHIB/
>>
>> yes
>>
>>>    
>>>> +	cc = stsch(test_device_sid, &schib);
>>>> +	if (cc) {
>>>> +		report("stsch cc=%d", 0, cc);
>>>> +		return;
>>>> +	}
>>>> +	/* Update the SCHIB to enable the channel */
>>>> +	pmcw->flags |= PMCW_ENABLE;
>>>> +
>>>> +	/* Tell the CSS we want to modify the subchannel */
>>>> +	cc = msch(test_device_sid, &schib);
>>>> +	if (cc) {
>>>> +		report("msch cc=%d", 0, cc);
>>>
>>> So you expect the subchannel to be idle? Probably true, especially as
>>> QEMU has no reason to post an unsolicited interrupt for a test device.
>>>    
>>>> +		return;
>>>> +	}
>>>> +
>>>> +	/* Read the SCHIB again to verify the enablement */
>>>> +	cc = stsch(test_device_sid, &schib);
>>>> +	if (cc) {
>>>> +		report("stsch cc=%d", 0, cc);
>>>> +		return;
>>>> +	}
>>>> +	if (!(pmcw->flags & PMCW_ENABLE)) {
>>>> +		report("Enable failed. pmcw: %x", 0, pmcw->flags);
>>>
>>> This check is fine when running under KVM. If this test is modified to
>>> run under z/VM in the future, you probably should retry here: I've seen
>>> the enable bit 'stick' only after the second msch() there.
>>
>> Oh. Thanks, may be I can loop with a delay and count.
> 
> FWIW, the Linux kernel code is trying 5 times.
> 
>> If I need to do this may be I need to create dedicated sub-functions to
>> include the sanity tests.
> 
> I'm not sure how worthwhile investing time here is, actually: If you
> don't plan to run under anything but KVM, you won't need it. I'm not
> sure if current versions of z/VM still display the same behaviour (it
> has been some time...); on the other hand, it is compliant with the
> architecture...

OK, I just insert the retry.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

