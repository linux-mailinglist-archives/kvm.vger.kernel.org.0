Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF021550D
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 22:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfEFUrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 16:47:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54918 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726160AbfEFUrp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 16:47:45 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46KlKEv056378
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 16:47:44 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sauwu8rm8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 16:47:44 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Mon, 6 May 2019 21:47:43 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e32.co.us.ibm.com (192.168.1.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 21:47:42 +0100
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46KleMJ56819760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 20:47:40 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EF27BE054;
        Mon,  6 May 2019 20:47:40 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9DB5BE04F;
        Mon,  6 May 2019 20:47:39 +0000 (GMT)
Received: from [9.85.216.218] (unknown [9.85.216.218])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 20:47:39 +0000 (GMT)
Subject: Re: [PATCH 7/7] s390/cio: Remove vfio-ccw checks of command codes
From:   Eric Farman <farman@linux.ibm.com>
To:     pmorel@linux.ibm.com, Cornelia Huck <cohuck@redhat.com>,
        Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-8-farman@linux.ibm.com>
 <8625f759-0a2d-09af-c8b5-5b312d854ba1@linux.ibm.com>
 <7c897993-d146-bf8e-48ad-11a914a04716@linux.ibm.com>
Date:   Mon, 6 May 2019 16:47:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7c897993-d146-bf8e-48ad-11a914a04716@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050620-0004-0000-0000-0000150AD0DD
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011061; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01199559; UDB=6.00629331; IPR=6.00980436;
 MB=3.00026760; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-06 20:47:43
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050620-0005-0000-0000-00008B8DD532
Message-Id: <bba6c0a8-2346-cd99-b8ad-f316daac010b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/19 11:39 AM, Eric Farman wrote:
> 
> 
> On 5/6/19 8:56 AM, Pierre Morel wrote:
>> On 03/05/2019 15:49, Eric Farman wrote:
>>> If the CCW being processed is a No-Operation, then by definition no
>>> data is being transferred.  Let's fold those checks into the normal
>>> CCW processors, rather than skipping out early.
>>>
>>> Likewise, if the CCW being processed is a "test" (an invented
>>> definition to simply mean it ends in a zero), let's permit that to go
>>> through to the hardware.  There's nothing inherently unique about
>>> those command codes versus one that ends in an eight [1], or any other
>>> otherwise valid command codes that are undefined for the device type
>>> in question.
>>>
>>> [1] POPS states that a x08 is a TIC CCW, and that having any high-order
>>> bits enabled is invalid for format-1 CCWs.  For format-0 CCWs, the
>>> high-order bits are ignored.
>>>
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>>   drivers/s390/cio/vfio_ccw_cp.c | 11 +++++------
>>>   1 file changed, 5 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c 
>>> b/drivers/s390/cio/vfio_ccw_cp.c
>>> index 36d76b821209..c0a52025bf06 100644
>>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>>> @@ -289,8 +289,6 @@ static long copy_ccw_from_iova(struct 
>>> channel_program *cp,
>>>   #define ccw_is_read_backward(_ccw) (((_ccw)->cmd_code & 0x0F) == 0x0C)
>>>   #define ccw_is_sense(_ccw) (((_ccw)->cmd_code & 0x0F) == 
>>> CCW_CMD_BASIC_SENSE)
>>> -#define ccw_is_test(_ccw) (((_ccw)->cmd_code & 0x0F) == 0)
>>> -
>>>   #define ccw_is_noop(_ccw) ((_ccw)->cmd_code == CCW_CMD_NOOP)
>>>   #define ccw_is_tic(_ccw) ((_ccw)->cmd_code == CCW_CMD_TIC)
>>> @@ -314,6 +312,10 @@ static inline int ccw_does_data_transfer(struct 
>>> ccw1 *ccw)
>>>       if (ccw->count == 0)
>>>           return 0;
>>> +    /* If the command is a NOP, then no data will be transferred */
>>> +    if (ccw_is_noop(ccw))
>>> +        return 0;
>>> +
>>>       /* If the skip flag is off, then data will be transferred */
>>>       if (!ccw_is_skip(ccw))
>>>           return 1;
>>> @@ -398,7 +400,7 @@ static void ccwchain_cda_free(struct ccwchain 
>>> *chain, int idx)
>>>   {
>>>       struct ccw1 *ccw = chain->ch_ccw + idx;
>>> -    if (ccw_is_test(ccw) || ccw_is_noop(ccw) || ccw_is_tic(ccw))
>>> +    if (ccw_is_tic(ccw))
>>
>>
>> AFAIR, we introduced this code to protect against noop and test with a 
>> non zero CDA.
>> This could go away only if there is somewhere the guaranty that noop 
>> have always a null CDA (same for test).
> 
> What was generating either the null or "test" command codes?  I can 
> provide plenty of examples for both these command codes and how they 
> look coming out of vfio-ccw now.

I've sent both x00 and x03 (NOP) CCWs with zero and non-zero CDAs to 
hardware without this patch.  I don't see anything particuarly 
surpising, so I'm not sure what the original code was attempting to protect.

Maybe, since you question this in ccwchain_cda_free(), you're referring 
to commit 408358b50dea ("s390: vfio-ccw: Do not attempt to free no-op, 
test and tic cda."), which fixed up our attempt to clean things up that 
weren't allocated on the transmit side?  With this series, that is 
reverted, but the cda is indeed set to something that needs to be free'd 
(see below).  So maybe I should at least mention that commit here.

Regardless, while the I/Os work/fail as I expect, the cda addresses 
themselves are wrong in much the same way I describe in patch 4.  Yes, 
without this patch we don't convert them to an IDAL so certain program 
checks aren't applicable.  But the addresses that we end up sending to 
the hardware are nonsensical, though potentially valid, locations.

> 
> The noop check is moved up into the "does data transfer" routine, to 
> determine whether the pages should be pinned or not.  Regardless of 
> whether or not the input CDA is null, we'll end up with a CCW pointing 
> to a valid IDAL of invalid addresses.
> 
> The "test" command codes always struck me as funky, because x18 and xF8 
> and everything in between that ends in x8 is architecturally invalid 
> too, but we don't check for them like we do for things that end in x0. 
> And there's a TON of other opcodes that are invalid for today's ECKD 
> devices, or perhaps were valid for older DASD but have since been 
> deprecated, or are only valid for non-DASD device types.  We have no 
> logic to permit them, either.  If those CCWs had a non-zero CDA, we 
> either pin it successfully and let the targeted device sort it out or an 
> error occurs and we fail at that point.  (QEMU will see a "wirte" region 
> error of -EINVAL because of vfio_pin_pages())
> 
>>
>>
>>
>>>           return;
>>>       kfree((void *)(u64)ccw->cda);
>>> @@ -723,9 +725,6 @@ static int ccwchain_fetch_one(struct ccwchain 
>>> *chain,
>>>   {
>>>       struct ccw1 *ccw = chain->ch_ccw + idx;
>>> -    if (ccw_is_test(ccw) || ccw_is_noop(ccw))
>>> -        return 0;
>>> -
>>>       if (ccw_is_tic(ccw))
>>>           return ccwchain_fetch_tic(chain, idx, cp);
>>>
>>
>>

