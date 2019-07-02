Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C52A5D411
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfGBQPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:15:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725996AbfGBQPb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jul 2019 12:15:31 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62G9Xpq058705;
        Tue, 2 Jul 2019 12:15:10 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tg9nx2r27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 12:15:10 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x62G9RTt011190;
        Tue, 2 Jul 2019 16:15:07 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 2tdym6y6ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 16:15:07 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x62GF75Y50921906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Jul 2019 16:15:07 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E18C8AE05C;
        Tue,  2 Jul 2019 16:15:06 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2431AE060;
        Tue,  2 Jul 2019 16:15:06 +0000 (GMT)
Received: from [9.60.84.127] (unknown [9.60.84.127])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Jul 2019 16:15:06 +0000 (GMT)
Subject: Re: [RFC v1 2/4] vfio-ccw: No need to call cp_free on an error in
 cp_init
To:     Farhan Ali <alifm@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1561997809.git.alifm@linux.ibm.com>
 <5f1b69cd3a52e367f9f5014a3613768c8634408c.1561997809.git.alifm@linux.ibm.com>
 <20190702104257.102f32d3.cohuck@redhat.com>
 <66d92fe7-6395-46a6-b9bc-b76cbe7fb48e@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <4f7e52bd-6b22-90b0-ab7b-f9c5c3ccac3f@linux.ibm.com>
Date:   Tue, 2 Jul 2019 12:15:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <66d92fe7-6395-46a6-b9bc-b76cbe7fb48e@linux.ibm.com>
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
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020176
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/19 9:58 AM, Farhan Ali wrote:
> 
> 
> On 07/02/2019 04:42 AM, Cornelia Huck wrote:
>> On Mon,  1 Jul 2019 12:23:44 -0400
>> Farhan Ali <alifm@linux.ibm.com> wrote:
>>
>>> We don't set cp->initialized to true so calling cp_free
>>> will just return and not do anything.
>>>
>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>>> ---
>>>   drivers/s390/cio/vfio_ccw_cp.c | 2 --
>>>   1 file changed, 2 deletions(-)
>>>
>>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c
>>> b/drivers/s390/cio/vfio_ccw_cp.c
>>> index 5ac4c1e..cab1be9 100644
>>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>>> @@ -647,8 +647,6 @@ int cp_init(struct channel_program *cp, struct
>>> device *mdev, union orb *orb)
>>>         /* Build a ccwchain for the first CCW segment */
>>>       ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
>>> -    if (ret)
>>> -        cp_free(cp);
>>
>> Makes sense; hopefully ccwchain_handle_ccw() cleans up correctly on
>> error :) (I think it does)
>>
> 
> I have checked that it does as well, but wouldn't hurt if someone else
> also glances over once again :)

Oh noes.  What happens once we start encountering TICs?  If we do:

ccwchain_handle_ccw()	(OK)
ccwchain_loop_tic()	(OK)
ccwchain_handle_ccw()	(FAIL)

The first _handle_ccw() will have added a ccwchain to the cp list, which
doesn't appear to get cleaned up now.  That used to be done in cp_init()
until I squashed cp_free and cp_unpin_free.  :(

> 
>> Maybe add a comment
>>
>> /* ccwchain_handle_ccw() already cleans up on error */
>>
>> so we don't stumble over this in the future?
> 
> Sure.
> 
>>
>> (Also, does this want a Fixes: tag?)
> 
> This might warrant a fixes tag as well.
>>
>>>         if (!ret)
>>>           cp->initialized = true;
>>
>>
