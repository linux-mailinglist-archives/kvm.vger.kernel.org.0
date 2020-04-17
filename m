Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2CA1ADD73
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 14:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgDQMia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 08:38:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51558 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729541AbgDQMia (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 08:38:30 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03HCXP77009734;
        Fri, 17 Apr 2020 08:38:28 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30fbeya04r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 08:38:28 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03HCXl5s010648;
        Fri, 17 Apr 2020 08:38:28 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30fbeya03y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 08:38:28 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03HCZLMN001715;
        Fri, 17 Apr 2020 12:38:27 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 30b5h72ae6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 12:38:27 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03HCcPQo55574786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 12:38:25 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0BD6BE051;
        Fri, 17 Apr 2020 12:38:25 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F06E8BE04F;
        Fri, 17 Apr 2020 12:38:24 +0000 (GMT)
Received: from [9.160.73.232] (unknown [9.160.73.232])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 17 Apr 2020 12:38:24 +0000 (GMT)
Subject: Re: [PATCH v3 2/8] vfio-ccw: Register a chp_event callback for
 vfio-ccw
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
 <20200417023001.65006-3-farman@linux.ibm.com>
 <20200417122907.034c8508.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <046d43e9-3411-3247-1368-3a94c9c93aa1@linux.ibm.com>
Date:   Fri, 17 Apr 2020 08:38:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200417122907.034c8508.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-17_03:2020-04-17,2020-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004170100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/17/20 6:29 AM, Cornelia Huck wrote:
> On Fri, 17 Apr 2020 04:29:55 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> From: Farhan Ali <alifm@linux.ibm.com>
>>
>> Register the chp_event callback to receive channel path related
>> events for the subchannels managed by vfio-ccw.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>
>> Notes:
>>     v2->v3:
>>      - Add a call to cio_cancel_halt_clear() for CHP_VARY_OFF [CH]
>>     
>>     v1->v2:
>>      - Move s390dbf before cio_update_schib() call [CH]
>>     
>>     v0->v1: [EF]
>>      - Add s390dbf trace
>>
>>  drivers/s390/cio/vfio_ccw_drv.c | 45 +++++++++++++++++++++++++++++++++
>>  1 file changed, 45 insertions(+)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>> index 8715c1c2f1e1..e48967c475e7 100644
>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>> @@ -19,6 +19,7 @@
>>  
>>  #include <asm/isc.h>
>>  
>> +#include "chp.h"
>>  #include "ioasm.h"
>>  #include "css.h"
>>  #include "vfio_ccw_private.h"
>> @@ -262,6 +263,49 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
>>  	return rc;
>>  }
>>  
>> +static int vfio_ccw_chp_event(struct subchannel *sch,
>> +			      struct chp_link *link, int event)
>> +{
>> +	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
>> +	int mask = chp_ssd_get_mask(&sch->ssd_info, link);
>> +	int retry = 255;
>> +
>> +	if (!private || !mask)
>> +		return 0;
>> +
>> +	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
>> +			   mdev_uuid(private->mdev), sch->schid.cssid,
>> +			   sch->schid.ssid, sch->schid.sch_no,
>> +			   mask, event);
>> +
>> +	if (cio_update_schib(sch))
>> +		return -ENODEV;
>> +
>> +	switch (event) {
>> +	case CHP_VARY_OFF:
>> +		/* Path logically turned off */
>> +		sch->opm &= ~mask;
>> +		sch->lpm &= ~mask;
>> +		cio_cancel_halt_clear(sch, &retry);
>> +		break;
>> +	case CHP_OFFLINE:
>> +		/* Path is gone */
>> +		cio_cancel_halt_clear(sch, &retry);
> 
> Looking at this again: While calling the same function for both
> CHP_VARY_OFF and CHP_OFFLINE is the right thing to do,
> cio_cancel_halt_clear() is probably not that function. I don't think we
> want to terminate an I/O that does not use the affected path.
> 
> Looking at what the normal I/O subchannel driver does, it first checks
> for the lpum and does not do anything if the affected path does not
> show up there. Following down the git history rabbit hole, that basic
> check (surviving several reworks) precedes the first git import, so
> there's unfortunately no patch description explaining that. Looking at
> the PoP, I cannot find a whole lot of details... I think some of the
> path-handling stuff is explained in non-public documentation, and
> whoever wrote the original code (probably me) relied on the information
> there.
> 
> tl;dr: We probably should check the lpum here as well.

Makes sense.  I'll go through that other doc and fix this up accordingly.

> 
>> +		break;
>> +	case CHP_VARY_ON:
>> +		/* Path logically turned on */
>> +		sch->opm |= mask;
>> +		sch->lpm |= mask;
>> +		break;
>> +	case CHP_ONLINE:
>> +		/* Path became available */
>> +		sch->lpm |= mask & sch->opm;
>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static struct css_device_id vfio_ccw_sch_ids[] = {
>>  	{ .match_flags = 0x1, .type = SUBCHANNEL_TYPE_IO, },
>>  	{ /* end of list */ },
>> @@ -279,6 +323,7 @@ static struct css_driver vfio_ccw_sch_driver = {
>>  	.remove = vfio_ccw_sch_remove,
>>  	.shutdown = vfio_ccw_sch_shutdown,
>>  	.sch_event = vfio_ccw_sch_event,
>> +	.chp_event = vfio_ccw_chp_event,
>>  };
>>  
>>  static int __init vfio_ccw_debug_init(void)
> 
