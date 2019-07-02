Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D385D278
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 17:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfGBPMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 11:12:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38688 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725851AbfGBPMJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jul 2019 11:12:09 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62F861j167221;
        Tue, 2 Jul 2019 11:11:50 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tg7p45r19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 11:11:50 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x62F59XT021048;
        Tue, 2 Jul 2019 15:11:49 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 2tdym6pujk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 15:11:49 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x62FBmOq55247142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Jul 2019 15:11:48 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4DF2AE064;
        Tue,  2 Jul 2019 15:11:48 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E97DAE05F;
        Tue,  2 Jul 2019 15:11:48 +0000 (GMT)
Received: from [9.60.84.127] (unknown [9.60.84.127])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Jul 2019 15:11:48 +0000 (GMT)
Subject: Re: [RFC v1 1/4] vfio-ccw: Set orb.cmd.c64 before calling
 ccwchain_handle_ccw
To:     Farhan Ali <alifm@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1561997809.git.alifm@linux.ibm.com>
 <050943a6f5a427317ea64100bc2b4ec6394a4411.1561997809.git.alifm@linux.ibm.com>
 <20190702102606.2e9cfed3.cohuck@redhat.com>
 <de9ae025-a96a-11ab-2ba9-8252d8b070e0@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <62c3b191-3fae-011d-505d-59e8412229d0@linux.ibm.com>
Date:   Tue, 2 Jul 2019 11:11:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <de9ae025-a96a-11ab-2ba9-8252d8b070e0@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/19 9:56 AM, Farhan Ali wrote:
> 
> 
> On 07/02/2019 04:26 AM, Cornelia Huck wrote:
>> On Mon,  1 Jul 2019 12:23:43 -0400
>> Farhan Ali <alifm@linux.ibm.com> wrote:
>>
>>> Because ccwchain_handle_ccw calls ccwchain_calc_length and
>>> as per the comment we should set orb.cmd.c64 before calling
>>> ccwchanin_calc_length.
>>>
>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>>> ---
>>>   drivers/s390/cio/vfio_ccw_cp.c | 10 +++++-----
>>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c
>>> b/drivers/s390/cio/vfio_ccw_cp.c
>>> index d6a8dff..5ac4c1e 100644
>>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>>> @@ -640,16 +640,16 @@ int cp_init(struct channel_program *cp, struct
>>> device *mdev, union orb *orb)
>>>       memcpy(&cp->orb, orb, sizeof(*orb));
>>>       cp->mdev = mdev;
>>>   -    /* Build a ccwchain for the first CCW segment */
>>> -    ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
>>> -    if (ret)
>>> -        cp_free(cp);
>>> -
>>>       /* It is safe to force: if not set but idals used
>>>        * ccwchain_calc_length returns an error.
>>>        */
>>>       cp->orb.cmd.c64 = 1;
>>>   +    /* Build a ccwchain for the first CCW segment */
>>> +    ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
>>> +    if (ret)
>>> +        cp_free(cp);
>>> +
>>>       if (!ret)
>>>           cp->initialized = true;
>>>   
>>
>> Hm... has this ever been correct, or did this break only with the
>> recent refactorings?
>>
>> (IOW, what should Fixes: point to?)

Yeah, that looks like it should blame my refactoring.

>>
>>
> 
> I think it was correct before some of the new refactoring we did. But we
> do need to set before calling ccwchain_calc_length, because the function
> does have a check for orb.cmd.64. I will see which exact commit did it.

I get why that check exists, but does anyone know why it's buried in
ccwchain_calc_length()?  Is it simply because ccwchain_calc_length()
assumes to be working on Format-1 CCWs?  I don't think that routine
cares if it's an IDA or not, an it'd be nice if we could put a check for
the supported IDA formats somewhere up front.

> 
> Thanks
> Farhan
