Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FBC151C5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 18:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfEFQgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 12:36:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725883AbfEFQgy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 12:36:54 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x46GXP4q129479
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 12:36:52 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sar6794y3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 12:36:52 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Mon, 6 May 2019 17:36:51 +0100
Received: from b03cxnp07028.gho.boulder.ibm.com (9.17.130.15)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 17:36:49 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x46Gameu8192356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 16:36:48 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A747C605B;
        Mon,  6 May 2019 16:36:48 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 305BBC6062;
        Mon,  6 May 2019 16:36:47 +0000 (GMT)
Received: from [9.85.230.129] (unknown [9.85.230.129])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 May 2019 16:36:46 +0000 (GMT)
Subject: Re: [PATCH 2/7] s390/cio: Set vfio-ccw FSM state before ioeventfd
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-3-farman@linux.ibm.com>
 <20190506165158.5da82576.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Mon, 6 May 2019 12:36:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506165158.5da82576.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050616-0016-0000-0000-000009ADBC0E
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011060; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01199476; UDB=6.00629281; IPR=6.00980352;
 MB=3.00026758; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-06 16:36:50
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050616-0017-0000-0000-0000431B1DBD
Message-Id: <39a1efa5-5298-97b9-21fa-e9ed70a2b892@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/19 10:51 AM, Cornelia Huck wrote:
> On Fri,  3 May 2019 15:49:07 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> Otherwise, the guest can believe it's okay to start another I/O
>> and bump into the non-idle state.  This results in a cc=3
>> (or cc=2 with the pending async CSCH/HSCH code [1]) to the guest,
> 
> I think you can now refer to cc=2, as the csch/hsch is on its way in :)

Woohoo!  :)

> 
>> which is unfortunate since everything is otherwise working normally.
>>
>> [1] https://patchwork.kernel.org/comment/22588563/
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>
>> ---
>>
>> I think this might've been part of Pierre's FSM cleanup?
> 
> Not sure if I saw this before, but there have been quite a number of
> patches going around...

I guess I should have said his original cleanup from last year.  I 
didn't find it, but it also seems familiar to me.

> 
>> ---
>>   drivers/s390/cio/vfio_ccw_drv.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>> index 0b3b9de45c60..ddd21b6149fd 100644
>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>> @@ -86,11 +86,11 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>>   	}
>>   	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
>>   
>> -	if (private->io_trigger)
>> -		eventfd_signal(private->io_trigger, 1);
>> -
>>   	if (private->mdev && is_final)
>>   		private->state = VFIO_CCW_STATE_IDLE;
>> +
>> +	if (private->io_trigger)
>> +		eventfd_signal(private->io_trigger, 1);
>>   }
>>   
>>   /*
> 

