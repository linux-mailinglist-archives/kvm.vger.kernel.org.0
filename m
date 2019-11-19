Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0DA1027D8
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 16:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfKSPQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 10:16:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17398 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbfKSPQe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 10:16:34 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJF7x6X050964;
        Tue, 19 Nov 2019 10:16:33 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wcf70k53k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Nov 2019 10:16:33 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xAJF82bp051293;
        Tue, 19 Nov 2019 10:16:32 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wcf70k52j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Nov 2019 10:16:32 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAJFGUJ7013161;
        Tue, 19 Nov 2019 15:16:31 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 2wa8r6v61h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Nov 2019 15:16:31 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAJFGURn46268814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 15:16:30 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8C88B2067;
        Tue, 19 Nov 2019 15:16:30 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67B5CB2064;
        Tue, 19 Nov 2019 15:16:30 +0000 (GMT)
Received: from [9.80.210.113] (unknown [9.80.210.113])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Nov 2019 15:16:30 +0000 (GMT)
Subject: Re: [RFC PATCH v1 03/10] vfio-ccw: Use subchannel lpm in the orb
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
 <20191115025620.19593-4-farman@linux.ibm.com>
 <20191119140046.4b81edd8.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <fa7f22e1-df44-4ad2-871a-23cd4feebc5e@linux.ibm.com>
Date:   Tue, 19 Nov 2019 10:16:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191119140046.4b81edd8.cohuck@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_04:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=913 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911190139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/19/19 8:00 AM, Cornelia Huck wrote:
> On Fri, 15 Nov 2019 03:56:13 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> From: Farhan Ali <alifm@linux.ibm.com>
>>
>> The subchannel logical path mask (lpm) would have the most
>> up to date information of channel paths that are logically
>> available for the subchannel.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>
>> Notes:
>>     v0->v1: [EF]
>>      - None; however I am greatly confused by this one.  Thoughts?
> 
> I think it's actually wrong.
> 
>>
>>  drivers/s390/cio/vfio_ccw_cp.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
>> index 3645d1720c4b..d4a86fb9d162 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>> @@ -779,9 +779,7 @@ union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm)
>>  	orb->cmd.intparm = intparm;
>>  	orb->cmd.fmt = 1;
>>  	orb->cmd.key = PAGE_DEFAULT_KEY >> 4;
>> -
>> -	if (orb->cmd.lpm == 0)
>> -		orb->cmd.lpm = lpm;
> 
> In the end, the old code will use the lpm from the subchannel
> structure, if userspace did not supply anything to be used.
> 
>> +	orb->cmd.lpm = lpm;
> 
> The new code will always discard any lpm userspace has supplied and
> replace it with the lpm from the subchannel structure. This feels
> wrong; what if the I/O is supposed to be restricted to a subset of the
> paths?

I had the same opinion, but didn't want to flat-out discard it from his
series without a second look.  :)

> 
> If we want to include the current value of the subchannel lpm in the
> requests, we probably want to AND the masks instead.

Then we'd be on the hook to return some sort of error if the result is
zero.  Is it better to just send it to hw as-is, and let the response
come back naturally?  (Which is what we do today.)

> 
>>  
>>  	chain = list_first_entry(&cp->ccwchain_list, struct ccwchain, next);
>>  	cpa = chain->ch_ccw;
> 
