Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B09C31512C
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 18:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfEFQZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 12:25:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44192 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725883AbfEFQZJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 12:25:09 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46GLcc2016181
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 12:25:08 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2saq79knsa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 12:25:08 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Mon, 6 May 2019 17:25:07 +0100
Received: from b03cxnp08028.gho.boulder.ibm.com (9.17.130.20)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 17:25:05 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46GP3PY4587934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 16:25:03 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FAFAC6057;
        Mon,  6 May 2019 16:25:03 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91763C605D;
        Mon,  6 May 2019 16:25:02 +0000 (GMT)
Received: from [9.85.230.129] (unknown [9.85.230.129])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 16:25:02 +0000 (GMT)
Subject: Re: [PATCH 7/7] s390/cio: Remove vfio-ccw checks of command codes
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-8-farman@linux.ibm.com>
 <20190506173707.40216e76.cohuck@redhat.com>
 <65313674-09be-88c0-4b5e-c99527f26532@linux.ibm.com>
 <20190506181850.4b1b8300.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Mon, 6 May 2019 12:25:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506181850.4b1b8300.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050616-8235-0000-0000-00000E901AE0
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011060; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01199472; UDB=6.00629278; IPR=6.00980348;
 MB=3.00026757; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-06 16:25:06
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050616-8236-0000-0000-00004572BA1A
Message-Id: <d6f28324-846f-54b6-84f0-c97e474361c1@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/19 12:18 PM, Cornelia Huck wrote:
> On Mon, 6 May 2019 11:46:59 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 5/6/19 11:37 AM, Cornelia Huck wrote:
>>> On Fri,  3 May 2019 15:49:12 +0200
>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>    
>>>> If the CCW being processed is a No-Operation, then by definition no
>>>> data is being transferred.  Let's fold those checks into the normal
>>>> CCW processors, rather than skipping out early.
>>>>
>>>> Likewise, if the CCW being processed is a "test" (an invented
>>>> definition to simply mean it ends in a zero),
>>>
>>> The "Common I/O Device Commands" document actually defines this :)
>>
>> Blech, okay so I didn't look early enough in that document.  Section 1.5
>> it is.  :)
>>
>>>    
>>>> let's permit that to go
>>>> through to the hardware.  There's nothing inherently unique about
>>>> those command codes versus one that ends in an eight [1], or any other
>>>> otherwise valid command codes that are undefined for the device type
>>>> in question.
>>>
>>> But I agree that everything possible should be sent to the hardware.
>>>    
>>>>
>>>> [1] POPS states that a x08 is a TIC CCW, and that having any high-order
>>>> bits enabled is invalid for format-1 CCWs.  For format-0 CCWs, the
>>>> high-order bits are ignored.
>>>>
>>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>>> ---
>>>>    drivers/s390/cio/vfio_ccw_cp.c | 11 +++++------
>>>>    1 file changed, 5 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
>>>> index 36d76b821209..c0a52025bf06 100644
>>>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>>>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>>>> @@ -289,8 +289,6 @@ static long copy_ccw_from_iova(struct channel_program *cp,
>>>>    #define ccw_is_read_backward(_ccw) (((_ccw)->cmd_code & 0x0F) == 0x0C)
>>>>    #define ccw_is_sense(_ccw) (((_ccw)->cmd_code & 0x0F) == CCW_CMD_BASIC_SENSE)
>>>>    
>>>> -#define ccw_is_test(_ccw) (((_ccw)->cmd_code & 0x0F) == 0)
>>>> -
>>>>    #define ccw_is_noop(_ccw) ((_ccw)->cmd_code == CCW_CMD_NOOP)
>>>>    
>>>>    #define ccw_is_tic(_ccw) ((_ccw)->cmd_code == CCW_CMD_TIC)
>>>> @@ -314,6 +312,10 @@ static inline int ccw_does_data_transfer(struct ccw1 *ccw)
>>>>    	if (ccw->count == 0)
>>>>    		return 0;
>>>>    
>>>> +	/* If the command is a NOP, then no data will be transferred */
>>>> +	if (ccw_is_noop(ccw))
>>>> +		return 0;
>>>> +
>>>
>>> Don't you need to return 0 here for any test command as well?
>>>
>>> (If I read the doc correctly, we'll just get a unit check in any case,
>>> as there are no parallel I/O interfaces on modern s390 boxes. Even if
>>> we had a parallel I/O interface, we'd just collect the status, and not
>>> get any data transfer. FWIW, the QEMU ccw interpreter for emulated
>>> devices rejects test ccws with a channel program check, which looks
>>> wrong; should be a command reject instead.)
>>
>> I will go back and look.  I thought when I sent a test command with an
>> address that wasn't translated I got an unhappy result, which is why I
>> ripped this check out.
> 
> Ugh, I just looked at the current PoP and that specifies ccws[1] of test
> type as 'invalid' (generating a channel program check). So, the current
> PoP and the (old) I/O device commands seem to disagree :/ Do you know
> if there's any update to the latter? I think I'll just leave QEMU as it
> is, as that at least agrees with the current PoP...

Double ugh.  I am not aware, but I'll poke around on our side.  Probably 
better to focus on PoP, unless it specifically points to ye olde document.

> 
>>
>> I was trying to use test CCWs as a safety valve for Halil's Status
>> Modifier concern, so maybe I had something else wrong on that pile.
>> (The careful observer would note that that code was not included here.  :)
> 
> :)
> 
>>
>>>    
>>>>    	/* If the skip flag is off, then data will be transferred */
>>>>    	if (!ccw_is_skip(ccw))
>>>>    		return 1;
>>>> @@ -398,7 +400,7 @@ static void ccwchain_cda_free(struct ccwchain *chain, int idx)
>>>>    {
>>>>    	struct ccw1 *ccw = chain->ch_ccw + idx;
>>>>    
>>>> -	if (ccw_is_test(ccw) || ccw_is_noop(ccw) || ccw_is_tic(ccw))
>>>> +	if (ccw_is_tic(ccw))
>>>>    		return;
>>>>    
>>>>    	kfree((void *)(u64)ccw->cda);
>>>> @@ -723,9 +725,6 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
>>>>    {
>>>>    	struct ccw1 *ccw = chain->ch_ccw + idx;
>>>>    
>>>> -	if (ccw_is_test(ccw) || ccw_is_noop(ccw))
>>>> -		return 0;
>>>> -
>>>>    	if (ccw_is_tic(ccw))
>>>>    		return ccwchain_fetch_tic(chain, idx, cp);
>>>>      
>>>    
> 
> [1] tcws are a bit different; but we don't support them anyway.
> 

Yeah...  I'd like to get the code cleaned up to a point where if we want 
to support TCWs, we could just up front say "if command go here, if 
transport go there."  Not that that'll be anytime soon, but it would 
prevent us from having to dis-entangle everything at that future point.

