Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DB215E455
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 17:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393637AbgBNQf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 11:35:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393566AbgBNQf0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 11:35:26 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EGVn2C039983;
        Fri, 14 Feb 2020 11:35:25 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y5vhppefk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 11:35:24 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EGW1oI041062;
        Fri, 14 Feb 2020 11:35:24 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y5vhppef4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 11:35:24 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EGZD0W016492;
        Fri, 14 Feb 2020 16:35:23 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 2y5bc09t3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 16:35:23 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EGZMPo31392000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 16:35:22 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF50CB2066;
        Fri, 14 Feb 2020 16:35:22 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 480B3B2065;
        Fri, 14 Feb 2020 16:35:22 +0000 (GMT)
Received: from [9.160.20.216] (unknown [9.160.20.216])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 16:35:22 +0000 (GMT)
Subject: Re: [RFC PATCH v2 2/9] vfio-ccw: Register a chp_event callback for
 vfio-ccw
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200206213825.11444-1-farman@linux.ibm.com>
 <20200206213825.11444-3-farman@linux.ibm.com>
 <20200214131147.0a98dd7d.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <459a60d1-699d-2f16-bb59-23f11b817b81@linux.ibm.com>
Date:   Fri, 14 Feb 2020 11:35:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214131147.0a98dd7d.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 clxscore=1015 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/14/20 7:11 AM, Cornelia Huck wrote:
> On Thu,  6 Feb 2020 22:38:18 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> From: Farhan Ali <alifm@linux.ibm.com>
>>
>> Register the chp_event callback to receive channel path related
>> events for the subchannels managed by vfio-ccw.
> 
> I'm wondering how useful this patch would be on its own.

Probably not much.  I can't speak to his original thoughts on the
matter, but it doesn't seem to buy us much by itself other than a
consumable sized patch.

> 
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>
>> Notes:
>>     v1->v2:
>>      - Move s390dbf before cio_update_schib() call [CH]
>>     
>>     v0->v1: [EF]
>>      - Add s390dbf trace
>>
>>  drivers/s390/cio/vfio_ccw_drv.c | 44 +++++++++++++++++++++++++++++++++
>>  1 file changed, 44 insertions(+)
>>
> (...)
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
>> +		break;
>> +	case CHP_OFFLINE:
>> +		/* Path is gone */
>> +		cio_cancel_halt_clear(sch, &retry);
> 
> Any reason you do this only for CHP_OFFLINE and not for CHP_VARY_OFF?

Hrm...  No reason that I can think of.  I can fix this.

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
> 
> If I'm not mistaken, this patch introduces the first usage of sch->opm
> in the vfio-ccw code. 

Correct.

> Are we missing something?

Maybe?  :)

>Or am I missing
> something? :)
> 

Since it's only used in this code, for acting as a step between
vary/config off/on, maybe this only needs to be dealing with the lpm
field itself?

>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static struct css_device_id vfio_ccw_sch_ids[] = {
>>  	{ .match_flags = 0x1, .type = SUBCHANNEL_TYPE_IO, },
>>  	{ /* end of list */ },
> (...)
> 
