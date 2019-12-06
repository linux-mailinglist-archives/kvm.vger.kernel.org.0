Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AA71152BE
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 15:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfLFOSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 09:18:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28400 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726244AbfLFOSl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 09:18:41 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB6EIAw6119542
        for <kvm@vger.kernel.org>; Fri, 6 Dec 2019 09:18:40 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wq9mh4ya0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 09:18:39 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 6 Dec 2019 14:18:37 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Dec 2019 14:18:35 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB6EHqAA13631986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Dec 2019 14:17:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BF32A4059;
        Fri,  6 Dec 2019 14:18:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33944A404D;
        Fri,  6 Dec 2019 14:18:33 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.175.63])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Dec 2019 14:18:33 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 9/9] s390x: css: ping pong
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-10-git-send-email-pmorel@linux.ibm.com>
 <20191202160341.5e96fb81.cohuck@redhat.com>
 <0ee2ac68-04a8-c804-a280-04f273489a0a@linux.ibm.com>
Date:   Fri, 6 Dec 2019 15:18:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <0ee2ac68-04a8-c804-a280-04f273489a0a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19120614-0012-0000-0000-000003724811
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120614-0013-0000-0000-000021AE10AC
Message-Id: <43ac889d-1c62-759c-6555-6216d737cdff@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-06_04:2019-12-05,2019-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 bulkscore=0 clxscore=1015 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912060121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-02 19:25, Pierre Morel wrote:
> 
> 
> On 2019-12-02 16:03, Cornelia Huck wrote:
>> On Thu, 28 Nov 2019 13:46:07 +0100
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> To test a write command with the SSCH instruction we need a QEMU device,
>>> with control unit type 0xC0CA. The PONG device is such a device.
>>
>> "We want to test some read/write ccws via the SSCH instruction with a
>> QEMU device with control unit type 0xC0CA." ?
>>
>>>
>>> This type of device respond to PONG_WRITE requests by incrementing an
>>
>> s/respond/responds/
> 
> oiiinnnn..... but yes
> 
>>
>>> integer, stored as a string at offset 0 of the CCW data.
>>>
>>> This is only a success test, no error expected.
>>
>> Nobody expects the Spanish Inquisition^W^W^W an error :)
>>
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   s390x/css.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 45 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/s390x/css.c b/s390x/css.c
>>> index 534864f..0761e70 100644
>>> --- a/s390x/css.c
>>> +++ b/s390x/css.c
>>> @@ -23,6 +23,10 @@
>>>   #define SID_ONE        0x00010000
>>>   #define PSW_PRG_MASK (PSW_MASK_IO | PSW_MASK_EA | PSW_MASK_BA)
>>> +/* Local Channel Commands */
>>
>> /* Channel commands for the PONG device */
>>
>> ?
> 
> better, thanks
> 
>>
>>> +#define PONG_WRITE    0x21 /* Write */
>>> +#define PONG_READ    0x22 /* Read buffer */
>>> +
>>>   struct lowcore *lowcore = (void *)0x0;
>>>   static struct schib schib;
>>> @@ -31,7 +35,8 @@ static struct ccw ccw[NB_CCW];
>>>   #define NB_ORB  100
>>>   static struct orb orb[NB_ORB];
>>>   static struct irb irb;
>>> -static char buffer[0x1000] __attribute__ ((aligned(8)));
>>> +#define BUF_SZ    0x1000
>>> +static char buffer[BUF_SZ] __attribute__ ((aligned(8)));
>>
>> Merge this with the introduction of this variable?
> 
> yes, better too
> 
>>
>>>   static struct senseid senseid;
>>>   static const char *Channel_type[3] = {
>>> @@ -224,6 +229,44 @@ static void test_sense(void)
>>>           report("cu_type: expect c0ca, got %04x", 0, senseid.cu_type);
>>>   }
>>> +static void test_ping(void)
>>> +{
>>> +    int success, result;
>>> +    int cnt = 0, max = 4;
>>> +
>>> +    if (senseid.cu_type != PONG_CU) {
>>> +        report_skip("No PONG, no ping-pong");
>>
>> :D
>>
>>> +        return;
>>> +    }
>>> +
>>> +    enable_io_irq();
>>
>> Hasn't that been enabled already for doing SenseID?
> 
> Yes, but same remark as before, the sub tests here are independant, 
> started from the test[] table.
> If the sense test is commented out, the...

hum, coming back here again, the tests depends one from the other and 
are absolutely not independent as I pretended. so...
You are right I do not need to enable IRQ here.

> 
>>
>>> +
>>> +    while (cnt++ < max) {
>>> +report_info("cnt..: %08x", cnt);
>>
>> Wrong indentation?
> 
> wrong report !
> forgotten from a test.
> 
> Thanks for the review,
> Regards,
> Pierre
> 
> 

-- 
Pierre Morel
IBM Lab Boeblingen

