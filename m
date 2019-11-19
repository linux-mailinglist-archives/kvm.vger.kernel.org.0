Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1055B10285C
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 16:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfKSPpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 10:45:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11146 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727509AbfKSPpV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 10:45:21 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJFgQHP070856;
        Tue, 19 Nov 2019 10:45:19 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wcf564nq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Nov 2019 10:45:19 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xAJFh22H074364;
        Tue, 19 Nov 2019 10:45:19 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wcf564npj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Nov 2019 10:45:19 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAJFgMWS008154;
        Tue, 19 Nov 2019 15:45:22 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01wdc.us.ibm.com with ESMTP id 2wa8r64c86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Nov 2019 15:45:22 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAJFjHl845941044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 15:45:17 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5BD9B205F;
        Tue, 19 Nov 2019 15:45:17 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B9EBB2066;
        Tue, 19 Nov 2019 15:45:17 +0000 (GMT)
Received: from [9.80.210.113] (unknown [9.80.210.113])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Nov 2019 15:45:17 +0000 (GMT)
Subject: Re: [RFC PATCH v1 02/10] vfio-ccw: Register a chp_event callback for
 vfio-ccw
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
 <20191115025620.19593-3-farman@linux.ibm.com>
 <20191119134809.75ba276b.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <077147ec-39c3-7d00-5ee1-fc290ab7fd1a@linux.ibm.com>
Date:   Tue, 19 Nov 2019 10:45:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191119134809.75ba276b.cohuck@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_05:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911190142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/19/19 7:48 AM, Cornelia Huck wrote:
> On Fri, 15 Nov 2019 03:56:12 +0100
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
>>     v0->v1: [EF]
>>      - Add s390dbf trace
>>
>>  drivers/s390/cio/vfio_ccw_drv.c | 44 +++++++++++++++++++++++++++++++++
>>  1 file changed, 44 insertions(+)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>> index 91989269faf1..05da1facee60 100644
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
>> @@ -257,6 +258,48 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
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
>> +	if (cio_update_schib(sch))
>> +		return -ENODEV;
> 
> It seems this return code is only checked by the common I/O layer for
> the _OFFLINE case; still, it's probably not a bad idea, even though it
> is different from what the vanilla I/O subchannel driver does.

cio_update_schib() itself can only return -ENODEV so it seemed sane.

> 
>> +
>> +	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
>> +			   mdev_uuid(private->mdev), sch->schid.cssid,
>> +			   sch->schid.ssid, sch->schid.sch_no,
>> +			   mask, event);
> 
> If you log only here, you're missing the case above.

Ah, yes.  I'll move that up.

> 
>> +
>> +	switch (event) {
>> +	case CHP_VARY_OFF:
>> +		/* Path logically turned off */
>> +		sch->opm &= ~mask;
>> +		sch->lpm &= ~mask;
>> +		break;
>> +	case CHP_OFFLINE:
>> +		/* Path is gone */
>> +		cio_cancel_halt_clear(sch, &retry);
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
> 
> Looks sane as the first round.
> 
>> +
>> +	return 0;
>> +}
>> +
>>  static struct css_device_id vfio_ccw_sch_ids[] = {
>>  	{ .match_flags = 0x1, .type = SUBCHANNEL_TYPE_IO, },
>>  	{ /* end of list */ },
>> @@ -274,6 +317,7 @@ static struct css_driver vfio_ccw_sch_driver = {
>>  	.remove = vfio_ccw_sch_remove,
>>  	.shutdown = vfio_ccw_sch_shutdown,
>>  	.sch_event = vfio_ccw_sch_event,
>> +	.chp_event = vfio_ccw_chp_event,
>>  };
>>  
>>  static int __init vfio_ccw_debug_init(void)
> 
