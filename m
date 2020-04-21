Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F61B247B
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 13:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgDULCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 07:02:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgDULCJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 07:02:09 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LAXq9d069335;
        Tue, 21 Apr 2020 07:02:09 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggxpv1uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 07:02:08 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03LAXuMo069829;
        Tue, 21 Apr 2020 07:02:08 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggxpv1tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 07:02:08 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03LB0Rdx011835;
        Tue, 21 Apr 2020 11:02:07 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 30fs66ghav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 11:02:07 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03LB26V644433856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 11:02:06 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F31DB6E052;
        Tue, 21 Apr 2020 11:02:05 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6646B6E05F;
        Tue, 21 Apr 2020 11:02:04 +0000 (GMT)
Received: from [9.160.39.160] (unknown [9.160.39.160])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Apr 2020 11:02:04 +0000 (GMT)
Subject: Re: [PATCH v3 5/8] vfio-ccw: Introduce a new CRW region
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
 <20200417023001.65006-6-farman@linux.ibm.com>
 <20200421114114.672f35a4.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <e24dfccc-d2b7-9a47-3cef-323c01797ee1@linux.ibm.com>
Date:   Tue, 21 Apr 2020 07:02:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421114114.672f35a4.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_04:2020-04-20,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/21/20 5:41 AM, Cornelia Huck wrote:
> On Fri, 17 Apr 2020 04:29:58 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> From: Farhan Ali <alifm@linux.ibm.com>
>>
>> This region provides a mechanism to pass Channel Report Word(s)
>> that affect vfio-ccw devices, and need to be passed to the guest
>> for its awareness and/or processing.
>>
>> The base driver (see crw_collect_info()) provides space for two
>> CRWs, as a subchannel event may have two CRWs chained together
>> (one for the ssid, one for the subcahnnel).  All other CRWs will

s/subcahnnel/subchannel/

>> only occupy the first one.  Even though this support will also
>> only utilize the first one, we'll provide space for two also.
> 
> This is no longer true?

Oops, yes.

> 
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>
>> Notes:
>>     v2->v3:
>>      - Remove "if list-empty" check, since there's no list yet [EF]
>>      - Reduce the CRW region to one fullword, instead of two [CH]
>>     
>>     v1->v2:
>>      - Add new region info to Documentation/s390/vfio-ccw.rst [CH]
>>      - Add a block comment to struct ccw_crw_region [CH]
>>     
>>     v0->v1: [EF]
>>      - Clean up checkpatch (whitespace) errors
>>      - Add ret=-ENOMEM in error path for new region
>>      - Add io_mutex for region read (originally in last patch)
>>      - Change crw1/crw2 to crw0/crw1
>>      - Reorder cleanup of regions
>>
>>  Documentation/s390/vfio-ccw.rst     | 16 +++++++++
>>  drivers/s390/cio/vfio_ccw_chp.c     | 53 +++++++++++++++++++++++++++++
>>  drivers/s390/cio/vfio_ccw_drv.c     | 20 +++++++++++
>>  drivers/s390/cio/vfio_ccw_ops.c     |  4 +++
>>  drivers/s390/cio/vfio_ccw_private.h |  3 ++
>>  include/uapi/linux/vfio.h           |  1 +
>>  include/uapi/linux/vfio_ccw.h       |  8 +++++
>>  7 files changed, 105 insertions(+)
>>
>> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
>> index 98832d95f395..3338551ef642 100644
>> --- a/Documentation/s390/vfio-ccw.rst
>> +++ b/Documentation/s390/vfio-ccw.rst
>> @@ -247,6 +247,22 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_SCHIB.
>>  Reading this region triggers a STORE SUBCHANNEL to be issued to the
>>  associated hardware.
>>  
>> +vfio-ccw crw region
>> +---------------------
>> +
>> +The vfio-ccw crw region is used to return Channel Report Word (CRW)
>> +data to userspace::
>> +
>> +  struct ccw_crw_region {
>> +         __u32 crw;
>> +  } __packed;
>> +
>> +This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_CRW.
>> +
>> +Currently, space is provided for a single CRW. Handling of chained
>> +CRWs (not implemented in vfio-ccw) can be accomplished by re-reading
>> +the region for additional CRW data.
> 
> What about the following instead:
> 
> "Reading this region returns a CRW if one that is relevant for this
> subchannel (e.g. one reporting changes in channel path state) is
> pending, or all zeroes if not. If multiple CRWs are pending (including
> possibly chained CRWs), reading this region again will return the next
> one, until no more CRWs are pending and zeroes are returned. This is
> similar to how STORE CHANNEL REPORT WORD works."

Sounds good to me.

Hrm...  Maybe coffee hasn't hit yet.  Should I wire STCRW into this, or
just rely on the notification from the host to trigger the read?

> 
>> +
>>  vfio-ccw operation details
>>  --------------------------
>>  
>> diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
>> index 18f3b3e873a9..c1362aae61f5 100644
>> --- a/drivers/s390/cio/vfio_ccw_chp.c
>> +++ b/drivers/s390/cio/vfio_ccw_chp.c
>> @@ -74,3 +74,56 @@ int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private)
>>  					    VFIO_REGION_INFO_FLAG_READ,
>>  					    private->schib_region);
>>  }
>> +
>> +static ssize_t vfio_ccw_crw_region_read(struct vfio_ccw_private *private,
>> +					char __user *buf, size_t count,
>> +					loff_t *ppos)
>> +{
>> +	unsigned int i = VFIO_CCW_OFFSET_TO_INDEX(*ppos) - VFIO_CCW_NUM_REGIONS;
>> +	loff_t pos = *ppos & VFIO_CCW_OFFSET_MASK;
>> +	struct ccw_crw_region *region;
>> +	int ret;
>> +
>> +	if (pos + count > sizeof(*region))
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&private->io_mutex);
>> +	region = private->region[i].data;
>> +
>> +	if (copy_to_user(buf, (void *)region + pos, count))
>> +		ret = -EFAULT;
>> +	else
>> +		ret = count;
> 
> I see that you implemented it a bit differently in patch 7, but I think
> resetting crw to 0 immediately after the copy_to_user() is cleaner. It
> also can be done in this patch already :)

Ha, yes.  I actually had it set that way, but didn't like the result in
patch 7.  I'll revisit that.

> 
>> +
>> +	mutex_unlock(&private->io_mutex);
>> +	return ret;
>> +}
> 
> (...)
> 
>> diff --git a/include/uapi/linux/vfio_ccw.h b/include/uapi/linux/vfio_ccw.h
>> index 758bf214898d..faf57e691d4a 100644
>> --- a/include/uapi/linux/vfio_ccw.h
>> +++ b/include/uapi/linux/vfio_ccw.h
>> @@ -44,4 +44,12 @@ struct ccw_schib_region {
>>  	__u8 schib_area[SCHIB_AREA_SIZE];
>>  } __packed;
>>  
>> +/*
>> + * Used for returning Channel Report Word(s) to userspace.
> 
> s/Channel Report Word(s)/a Channel Report Word/ ?

Nod.

> 
>> + * Note: this is controlled by a capability
>> + */
>> +struct ccw_crw_region {
>> +	__u32 crw;
>> +} __packed;
>> +
>>  #endif
> 
